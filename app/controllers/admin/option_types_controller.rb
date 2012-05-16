class Admin::OptionTypesController < AdminController
  def index
    @option_types = OptionType.search(params[:search]).page(params[:page]).per(params[:per])
    format_for do |format|
      format.hml
      format.json{render :json => OptionType.tokens(params[:q])}
    end
  end
  
  def edit
    @option_type = OptionType.find(params[:id])
  end
  def new
    @option_type = OptionType.new
  end
  
  def create
    @option_type = OptionType.new(params[:option_type])
    if @option_type.save
      redirect_to admin_option_types_url, :notice => t('admin.creation_successfull')
    else
      flash[:error] = t('admin.creation_failed')
      render "new"
    end
  end
  
  def destroy
    @option_type = OptionType.find(params[:id])
    if @option_type.destroy
      redirect_to admin_option_types_url, :notice => t('admin.successfully_deleted')
    else
      redirect_to admin_option_types_url, :error => t('admin.could_not_be_deleted')
    end
  end
  
  def update
    @option_type = OptionType.find(params[:id])
    if @option_type.update_attributes(params[:option_type])
      redirect_to edit_admin_option_type_url(@option_type), :notice => t('admin.creation_successfull')
    else
      flash[:error] = t('admin.creation_failed')
      render "edit"
    end
  end
end
