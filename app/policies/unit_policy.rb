class UnitPolicy
  attr_reader :user

  def initialize(user)
    @user = user
  end
  def show?
    true
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
    @user.admin?
  end
  def create?
    #only admins can create
    @user.admin?
  end
end
