class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :check_holds

  helper_method :hasSidebar, :sort_column, :sort_direction, :filter_type

  def hasSidebar
    sidebarPages = ["catalogue", "users"]
    return sidebarPages.include?(params[:controller]) && params[:action] == "index"
  end

  def sort_column
    tableColumns.include?(params[:sort]) ? params[:sort] : nil
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
  end
  
  def filter_type
    tableColumns.include?(params[:filter_type]) ? params[:filter_type] : nil
  end
  
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

