class UserPolicy < ApplicationPolicy
  attr_reader :user, :unit
  def initialize(user, unit)
    @user = user
    @unit = unit
  end  

  def show?
    true
  end
  def edit?
    update?
  end
  def update?
    #only admins can update
    @user.admin?
  end
  def destroy?
    #only admins can delete
    @user.admin?
  end
  def create?
    #only admins can create
    @user.admin = true 
  end
end
