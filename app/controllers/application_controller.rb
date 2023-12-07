class ApplicationController < ActionController::Base
  include Pundit::Authorization
  skip_forgery_protection
end
