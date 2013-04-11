class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :check_holds
 
  private
 
  def check_holds
    @holds = Hold.all
    @holds.each do |hold|
        if hold.end_date < Date.today
            hold.destroy
            redirect_to(holds_path)
        end    
    end
  end
  
end
