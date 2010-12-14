class BuildConfig
  include Mongoid::Document
  #include ActsAsList::Mongoid

  field :name,      :type => String
  field :env_cmd,   :type => String

  embeds_many :steps
  embedded_in :project, :inverse_of => :configs

end
