class Project
  include Mongoid::Document
  include Mongoid::Timestamps

  field   :name,              :type => String
  field   :scm_type,          :type => String,  :default => 'Bob::Git'
  field   :scm_path,          :type => String
  field   :keep_build_count,  :type => Integer, :default => 10 
  field   :fixed_branch,      :type => Boolean, :default => false
  field   :branch_name,       :type => String,  :default => 'master'

  index :branch_name
  index :scm_path
  index :name

  references_many :builds, :dependent => :delete
  references_many :commits, :dependent => :delete
  embeds_many :steps
  embeds_one :campfire, :class_name => 'Notifier::Campfire'

  validates_presence_of :name
  validates_presence_of :scm_path
  validates_presence_of :keep_build_count

  validates_associated :steps
  validates_associated :campfire
  accepts_nested_attributes_for :steps
  accepts_nested_attributes_for :campfire

  # run the build
  def build!
    #Commit.build_git_commit(self) 
    build = Build.new
    build.project = self
    build.save
    build.delay.perform
  end

  def total_builds
    active = builds.count
    deleted = builds.deleted.count
    active + deleted
  end

  def fail_rate
    failed_deleted = builds.deleted.where(:state => 'failed').count
    failed  = builds.where(:state => 'failed').count 
    deleted = builds.deleted.count    
    active = builds.count

    total = deleted + active
    fail_count = failed_deleted + failed
    (fail_count.to_f / total.to_f) * 100
  end
       
end
