class AdminController < ApplicationController
  before_filter :admin_user_required
  layout "admin"
  private
  def admin_user_required
    redirect_to admin_url unless admin_user
  end
  def admin_user
    @admin_user ||= AdminUser.find_by_id(session[:admin_user_id])
  end
  helper_method :admin_user
end
