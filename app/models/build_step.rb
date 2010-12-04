class BuildStep
  include Mongoid::Document
  include Stateflow

  field :name,          :type => String
  field :command,       :type => String
  field :output,        :type => String
  field :state,         :type => String
  field :started_at,    :type => Time
  field :completed_at,  :type => Time

  referenced_in :build, :inverse_of => :build_steps

  stateflow do
    initial :waiting

    state :waiting

    state :success do
      enter lambda { |t| t.update_attributes(:completed_at => Time.now.utc) }
    end

    state :failed do
      enter lambda { |t| t.update_attributes(:completed_at => Time.now.utc) }
    end

    state :building do
      enter lambda { |t| t.update_attributes(:started_at => Time.now.utc) }
    end

    event :build_step do
      transitions :from => :waiting, :to => :building
    end

    event :step_failed do
      transitions :from => :building, :to => :failed
    end

    event :step_completed do
      transitions :from => :building, :to => :success
    end

  end

  def duration
    return if self.building?
    self.completed_at - self.started_at
  end

  def clean_output
    output.gsub("\n", "<br>").gsub("\e[0m", '</span>').gsub(/\e\[(\d+)m/, "<span class=\"color\\1\">")
  end

end
