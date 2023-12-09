class FavoritePolicy < ApplicationPolicy
  attr_reader :user, :favortie
    def initialize(user,favorite)
      @user = user
      @favorite = favorite
    end
    def show?
      true
    end
    def edit?
      false
    end
    def update?
      #only the user can update
      @user.id?
    end
    def destroy?
      #only the user can delete
      @user.admin?
    end
    def create?
      #only the user can create
      true
    end
  end
  