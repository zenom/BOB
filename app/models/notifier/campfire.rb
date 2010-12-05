 class Notifier::Campfire
  include Mongoid::Document
  include Rails.application.routes.url_helpers
  field :ssl,       :type => Boolean, :default => true
  field :token,     :type => String
  field :room,      :type => String
  field :subdomain, :type => String

  embedded_in :project, :inverse_of => :campfire

  def send_failed(build)
    link = build_url(build, :host => APP_CONFIG[:domain])
    send_message("[#{build.project.name}] Build #{build.id} failed. #{link}")
  end

  def send_success(build)
    link = build_url(build, :host => APP_CONFIG[:domain])
    send_message("[#{build.project.name}] Build #{build.id} successful. #{link}")
  end

  def post_message?
    !token.empty? && !room.empty? && !subdomain.empty?
  end
 
  def send_message(message)
    campfire = Tinder::Campfire.new(self.subdomain, :token => self.token, :ssl => self.ssl)
    room = campfire.find_room_by_name(self.room)
    room.speak(message)
    room.leave
  end
  private :send_message 

  def self.icon
    "notifications/campfire.png"
  end

end
