 class Notifier::Campfire
  include Mongoid::Document
  include Rails.application.routes.url_helpers
  field :ssl,       :type => Boolean, :default => true
  field :token,     :type => String
  field :room,      :type => String
  field :subdomain, :type => String

  embedded_in :project, :inverse_of => :campfire

  def send_failed(build)
    branch = build.latest_commit.nil? ? build.project.branch_name : build.latest_commit.branch
    link = build_url(build, :host => APP_CONFIG[:domain])
    send_message("[#{build.project.name}/#{branch}] Build #{build.id} failed. #{link}")
    send_message(build.build_steps.last.really_clean_output, true)
  end

  def send_success(build)
    branch = build.latest_commit.nil? ? build.project.branch_name : build.latest_commit.branch
    link = build_url(build, :host => APP_CONFIG[:domain])
    send_message("[#{build.project.name}/#{branch}] Build #{build.id} successful. #{link}")
  end

  def post_message?
    !token.empty? && !room.empty? && !subdomain.empty?
  end
 
  def send_message(message, paste=false)
    campfire = Tinder::Campfire.new(self.subdomain, :token => self.token, :ssl => self.ssl)
    room = campfire.find_room_by_name(self.room)
    paste ? room.paste(message) : room.speak(message)
    room.leave
  end
  private :send_message 

  def self.icon
    "notifications/campfire.png"
  end

end
