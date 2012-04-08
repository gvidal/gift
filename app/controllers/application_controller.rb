class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :current_user
  private
  def current_user
    @current_user = (session["uid"] && session["provider"]) ? Authentication.find_by_uid_and_provider(session["uid"], session["provider"]).try(:user) : nil
    if @current_user
      case session["provider"]
        when "facebook"
          @fb_graph = Koala::Facebook::API.new(@current_user.current_token)
      end
    end
  end
end
