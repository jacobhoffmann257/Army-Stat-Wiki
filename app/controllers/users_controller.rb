class UsersController < ApplicationController
  def mine
    @user = User.find_by!(username: params.fetch(:username))
  end
end
