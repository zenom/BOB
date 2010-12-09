class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :recoverable, :rememberable, 
    :trackable, :validatable

  field :first_name,    :type => String
  field :last_name,     :type => String

  validates_presence_of :first_name, :last_name
end
