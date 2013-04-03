class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :sidebarPages

  def sidebarPages
    @sidebarPages = ["catalogue", "users"]
  end
end
