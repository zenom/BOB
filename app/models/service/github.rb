class Service::Github

  def self.parse(project, payload)
    payload = Hashie::Mash.new(payload)
    commits = []
    payload.commits.each do |c|
      commit = Commit.new
      commit.author         = c.author.name
      commit.author_email   = c.author.email
      commit.message        = c.message
      commit.guid           = c.id
      commit.files_added    = c.added.size
      commit.files_removed  = c.removed.size
      commit.files_modified = c.modified.size
      commit.url            = c.url
      commit.branch         = payload.ref.blank? ? 'master' : payload.ref.split("\/").last
      commit.project_id     = project.id
      commit.save
      commits << commit
    end
    commits
  end

end
