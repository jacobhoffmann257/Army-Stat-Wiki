class UserPolicy < ApplicationPolicy
  attr_reader :user, :unit
  def initialize(user, unit)
    @user = user
    @unit = unit
  end  

  def show?
    @user.admin? || @user.id === @unit.id
  end
  def edit?
    update?|| @user.id === @unit.id
  end
  def update?
    #only admins can update
    # this should be the == comparison operator
    @user.admin?|| @user.id === @unit.id
  end
  def destroy?
    #only admins can delete
    false
  end
  def create?
    #only admins can create
    false
  end
end
