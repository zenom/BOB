class Step
  include Mongoid::Document
  #include ActsAsList::Mongoid

  field :name,            :type => String
  field :command,         :type => String
  field :process_order,   :type => Integer # the order the command should be run in

  embedded_in :build_config, :inverse_of => :steps

  validates_presence_of :name, :command

  def formatted_command
    self.command.split("\n").map(&:strip).join(' && ')
  end
end
