class Commit
  include Mongoid::Document
  include Mongoid::Timestamps

  referenced_in :build
  referenced_in :project
  field :author,          :type => String
  field :author_email,    :type => String
  field :guid,            :type => String
  field :url,             :type => String
  field :message,         :type => String
  field :files_added,     :type => Integer
  field :files_removed,   :type => Integer
  field :files_modified,  :type => Integer
  field :branch,          :type => String

  scope :untested, where(:build_id => nil)

end
