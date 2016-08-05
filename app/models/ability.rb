class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    company = user.company

    if company.present?
      if user.admin? || user.account_owner?
        can :manage, User, company_id: company.id
        can :manage, Company, id: company.id
        can :manage, Location, company_id: company.id
        can :manage, Team, company_id: company.id
        can :manage, Workstream, company_id: company.id
        can :manage, Invite, user: { company_id: company.id }
        can :manage, Task, workstream: { company_id: company.id }
        can :manage, UploadedFile, company_id: company.id
      else
        can :manage, user
        can :read, company
      end
    end
  end
end
