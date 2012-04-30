class AdminUsersController < ApplicationController
  layout "admin_log_in"
  def new
    @admin_user = AdminUser.new
  end
  
  def log_in
    @admin_user = AdminUser.find_by_email(params[:email])
    if @admin_user && @admin_user.authenticate(params[:password])
      session[:admin_user_id] = @admin_user.id
      redirect_to admin_home_url, :notice => t('admin.authentication_successfull')
    else
      flash[:error] = t('admin.authentication.authentication_not_valid')
      render "new"
    end
  end
end
