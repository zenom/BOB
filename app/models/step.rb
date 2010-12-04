class Step
  include Mongoid::Document
  field :name,    :type => String
  field :command, :type => String
  field :private, :type => Boolean, :default => false
  field :process_order,   :type => Integer # the order the command should be run in

  embedded_in :project, :inverse_of => :steps

  validates_presence_of :name, :command

  def formatted_command
    commands = []
    self.command.each_line do |line|
      commands << line.strip
    end
    commands.join(' && ')
  end
end
