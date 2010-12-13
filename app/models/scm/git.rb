module Bob
  class Git
    def self.build_commit(build)

      # should use the branch thats checked out
      command = "git log --max-count=1 --format=\"%H%n%an%n%ae%n%ad%n%s\""
      info = Runner.run(build.build_dir, command).split(/\n/)
      ## update git information
      commit = Commit.new
      commit.author = info[1]
      commit.author_email = info[2]
      commit.guid = info[0]
      commit.message = info[4]
      commit.build = build
      commit.project = build.project
      build.commits << commit
      build.save
    end

    def self.checkout(build)
      # will need to add the fixed branch stuff here if checked eventually
      if build.project.fixed_branch
        branch = build.project.branch_name
      else
        branch = build.latest_commit.nil? ? build.project.branch_name : build.latest_commit.branch
      end
      "git clone --branch #{branch} --depth 1 #{build.project.scm_path} #{build.build_dir}"
    end

  end

end
