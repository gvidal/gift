class PublicController < ApplicationController
  layout "application"
  before_filter :current_user
  before_filter :load_graph
  
  
  private
  def current_user
    @current_user ||= (session["uid"] && session["provider"]) ? Authentication.find_by_uid_and_provider(session["uid"], session["provider"]).try(:user) : nil
  end
  def load_graph
    @graph ||= @current_user.graph_api if @current_user
  end

  helper_method :current_user
  def user_needs_to_be_logged_in
    unless @current_user
    flash[:warn] = "You must be logged in to access this zone"
    redirect_to root_url
    end
  end
  helper_method :user_needs_to_be_logged_in
end
