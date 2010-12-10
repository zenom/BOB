class Ability
  include CanCan::Ability

  def initialize(user)
    if user.role == "admin"
      can :manage, :all
    elsif user.role == "client"
      can :read, Project do |project|
        project.users.include?(user)
      end
      can :manage, Build do |build|
        build.project.users.include?(user)
      end
    end
  end
end
