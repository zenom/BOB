 class Notifier::Campfire
  include Mongoid::Document
  include Rails.application.routes.url_helpers
  field :ssl,       :type => Boolean, :default => true
  field :token,     :type => String
  field :room,      :type => String
  field :subdomain, :type => String

  embedded_in :project, :inverse_of => :campfire

  def send_failed(build)
    room = build_room
    link = build_url(build, :host => APP_CONFIG[:domain])
    room.speak "[#{build.project.name}] Build #{build.id} failed. #{link}"
    room.leave
  end

  def send_success(build)
    room = build_room
    link = build_url(build, :host => APP_CONFIG[:domain])
    room.speak "[#{build.project.name}] Build #{build.id} successful. #{link}"
    room.leave
  end

  def post_message?
    !token.empty? && !room.empty? && !subdomain.empty?
  end
  
  def build_room
    campfire = Tinder::Campfire.new(self.subdomain, :token => self.token, :ssl => self.ssl)
    room = campfire.find_room_by_name(self.room)
    room
  end
  private :build_room 

  def self.icon
    "notifications/campfire.png"
  end

end
