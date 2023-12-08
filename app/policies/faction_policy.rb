class FactionPolicy
attr_reader :user
def initialize(user)
  @user = user
end
def show?
  false
end
def edit?
  @user.admin == true
end
def update?
  #only admins can update
  @user.admin == true
end
def destroy?
  #only admins can delete
  @user.admin == true
end
def create?
  #only admins can create
  @user.admin == true
end
end
