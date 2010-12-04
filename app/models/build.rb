class Build
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Stateflow
  include Rails.application.routes.url_helpers

  field :state,         :type => String
  field :started_at,    :type => Time
  field :completed_at,  :type => Time
  field :build_num,     :type => Integer # used for better gte/lte sorting

  referenced_in     :project
  references_many   :commits, :inverse_of => :build, :dependent => :destroy
  references_many   :build_steps, :inverse_of => :build, :dependent => :destroy

  before_create :associate_commits
  before_create :generate_buildnum
  after_destroy :remove_build_dir

  # on state change, handle running hooks
  stateflow do
    initial :pending

    state :pending

    state :building do
      enter :processing_build
    end

    state :failed do
      enter :failed_build
    end

    state :success do
      enter :successful_build
    end

    event :build do
      transitions :from => :pending,  :to => :building
      transitions :from => :failed,   :to => :building
      transitions :from => :success,  :to => :building
    end 

    event :build_completed do
      transitions :from => :building, :to => :success
    end

    event :build_failed do
      transitions :from => :building, :to => :failed
    end

  end

  def processing_build
    self.build_steps.delete_all # just in case...we don't want them lingering
    self.update_attributes(:started_at => Time.now.utc) 
  end

  def failed_build
    self.update_attributes(:completed_at => Time.now.utc)

    return if Rails.env == 'test'
    # do the hooks
    self.project.campfire.send_failed(self) if self.project.campfire.post_message?
  end

  def successful_build
    # Hook needs moved
    self.update_attributes(:completed_at => Time.now.utc)

    return if Rails.env == 'test'
    # do the hooks
    self.project.campfire.send_success(self) if self.project.campfire.post_message?
  end

  def generate_buildnum
    self.build_num = Build.count
  end

  def associate_commits
    self.project.commits.untested.each do |commit|
      commit.update_attributes(:build => self) 
    end
  end

  def build_dir
    File.join(Rails.root, 'tmp', 'builds', self.id.to_s)
  end

  # process the build
  def perform
    # Change state to building 
    build!

    Rails.logger.debug("[BOB] running perform for build #{self.id}.")

    scm = project.scm_type.constantize
    checkout = scm.checkout(self)
    steps = project.steps.clone
    steps.unshift(Step.new(:name => 'Code Checkout', :command => checkout))

    # Make the build dir
    FileUtils.mkdir_p(self.build_dir)

    steps.each_with_index do |step, index|
      build_step = BuildStep.new
      build_step.name = step.name
      build_step.build = self
      build_step.command = step.command
      build_step.save
      build_step.build_step!

      # get any commit info we can 
      if !commits.present? and index == 1
        scm.build_commit(self)
      end

      begin
        result = Runner.run(build_dir, step.formatted_command)
        # change state to completed
        build_step.output = result
        build_step.step_completed!
      rescue ::RunnerError => e
        # change state to failed
        build_step.output = e.output
        build_step.save
        build_step.step_failed!
        break
        Rails.logger.debug(e.message)
      end
    end

    Build.delay.clean_old_builds(project.id)
    has_failure? ? build_failed! : build_completed!
  end

  def has_failure?
    (self.build_steps.where(:state => :failed).count >= 1) ? true : false
  end

  def duration
    self.completed_at - self.started_at
  end

  def remove_build_dir
    FileUtils.rm_rf(self.build_dir)
  end

  def steps_completed
    done = build_steps.where(:state => 'success').count
    (done - 1)
  end

  def latest_commit
    commits.last
  end

  class << self
    def clean_old_builds(project)
      project = Project.find(project)
      build_count = project.keep_build_count ||= 10
      old_builds = self.order_by(:build_num.desc, :created_at.desc).skip(build_count)
      old_builds.each do |build|
        build.destroy
      end
    end
  end

end
