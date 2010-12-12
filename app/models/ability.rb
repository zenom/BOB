class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    
    if user.role == "admin"
      can :manage, :all
    elsif user.role == "client"
      can :read, Project do |project|
        project.users.include?(user)
      end
      can :manage, Build do |build|
        build.project.users.include?(user)
      end
    else
      can :read, Project do |project|
        project.private = false
      end
    end
  end
end
