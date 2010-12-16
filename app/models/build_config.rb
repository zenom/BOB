class BuildConfig
  include Mongoid::Document
  #include ActsAsList::Mongoid

  field :name,      :type => String
  field :env_cmd,   :type => String

  embeds_many :steps
  embedded_in :project, :inverse_of => :build_configs

  validates_presence_of :name, :env_cmd

  validates_associated :steps
  accepts_nested_attributes_for :steps
end
