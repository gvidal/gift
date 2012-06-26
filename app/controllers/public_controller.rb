class PublicController < ApplicationController
  layout "application"
  private
  def current_user
    @current_user ||= (session["uid"] && session["provider"]) ? Authentication.find_by_uid_and_provider(session["uid"], session["provider"]).try(:user) : nil
  end
  helper_method :current_user
end
