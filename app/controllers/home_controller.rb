class HomeController < ApplicationController
  def index
    if user_signed_in?
      redirect_to catalogue_path
    end
  end
end
