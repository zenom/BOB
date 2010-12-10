class User
  include Mongoid::Document
  ROLES = %w[admin client blocked]

  devise :database_authenticatable, :recoverable, :rememberable, 
    :trackable, :validatable

  field :first_name,    :type => String
  field :last_name,     :type => String
  field :role,          :type => String

  validates_presence_of :first_name, :last_name, :role

  references_many :projects, :stored_as => :array, :inverse_of => :users

  def name
    "#{first_name} #{last_name}"
  end

  protected
    def password_required?
      !persisted? || password.present? || password_confirmation.present?
    end
end
