class Admin::AdminUsersController < AdminController
  
  def index
    @admin_users = AdminUser.search(params[:search]).page(params[:page]).per(1)
  end
  
  def edit
    @admin_user = AdminUser.find(params[:id])
  end
  def new
    @admin_user = AdminUser.new
  end
  
  def create
    @admin_user = AdminUser.new(params[:admin_user])
    if @admin_user.save
      redirect_to admin_admin_users_url, :notice => t('admin.creation_successfull')
    else
      flash[:error] = t('admin.creation_failed')
      render "new"
    end
  end
  
  def destroy
    @admin_user = AdminUser.find(params[:id])
    if @admin_user.destroy
      redirect_to admin_admin_users_url, :notice => t('admin.successfully_deleted')
    else
      redirect_to admin_admin_users_url, :error => t('admin.could_not_be_deleted')
    end
  end
  
  def update
    @admin_user = AdminUser.find(params[:id])
    if @admin_user.update_attributes(params[:admin_user])
      redirect_to admin_admin_users_url, :notice => t('admin.creation_successfull')
    else
      flash[:error] = t('admin.creation_failed')
      render "edit"
    end
  end
end
