class PublicController < ApplicationController
  layout "application"
  before_filter :current_user
  before_filter :load_graph
  
  
  private
  def current_user
#    session["uid"] = nil
#    session["provider"] = nil

    @current_user ||= (session["uid"] && session["provider"]) ? Authentication.find_by_uid_and_provider(session["uid"], session["provider"]).try(:user) : nil
    if @current_user.try(:fb_token_expired?)
#      require 'ruby-debug';debugger;2+1
    end
    @current_user
#    if @current_user && @current_user.fb_token_expired?
#      require 'ruby-debug';debugger;1
#      @current_user = nil
#      session["uid"] = nil
#      session["provider"] = nil
#    end
  end
  def load_graph
    @graph ||= @current_user.graph_api if @current_user
#    require 'ruby-debug';debugger;1
#    @graph.get_object("me")
#  rescue Koala::Facebook::APIError, Exception => e
#    session["uid"] = nil
#    session["provider"] = nil
#  ensure
#    true
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
