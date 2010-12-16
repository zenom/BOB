class Project
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field   :name,              :type => String
  field   :scm_type,          :type => String,  :default => 'Bob::Git'
  field   :scm_path,          :type => String
  field   :keep_build_count,  :type => Integer, :default => 10 
  field   :fixed_branch,      :type => Boolean, :default => false
  field   :branch_name,       :type => String,  :default => 'master'
  field   :private,           :type => Boolean, :default => false
  slug    :name

  index :branch_name
  index :scm_path
  index :name

  references_many :builds, :dependent => :delete
  references_many :commits, :dependent => :delete
  references_many :users, :stored_as => :array, :inverse_of => :projects
  embeds_many     :build_configs
  embeds_one :campfire, :class_name => 'Notifier::Campfire'

  validates_presence_of :name
  validates_presence_of :scm_path
  validates_presence_of :keep_build_count

  validates_associated :campfire
  validates_associated :build_configs

  accepts_nested_attributes_for :build_configs
  accepts_nested_attributes_for :campfire


  # public only projects
  scope :public_projects, where(:private => false)

  # public or where user is allowed
  scope :allowed_projects, lambda { |user| any_of({:user_ids.in => [user.id]}, {:private => false})  }

  # run the build
  def build!
    build = Build.create(:project => self)
    build.delay.perform unless has_running_builds?
  end

  def has_running_builds?
    self.builds.where(:state => :building).count > 0 ? true : false
  end

  def total_builds
    (builds.count + builds.deleted.count)
  end

  def fail_rate
    failed_deleted = builds.deleted.where(:state => 'failed').count
    failed  = builds.where(:state => 'failed').count 

    fail_count = failed_deleted + failed
    (fail_count.to_f / total_builds.to_f) * 100
  end
       
end
