class FactionPolicy < ApplicationPolicy
attr_reader :user
def initialize(user)
  @user = user
end
def show?
  false
end
def edit?
  @user.admin? 
end
def update?
  #only admins can update
  @user.admin?
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
