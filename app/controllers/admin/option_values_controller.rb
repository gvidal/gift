class Admin::OptionValuesController < AdminController
  before_filter :load_option_type
  before_filter :set_url_callback
  def index
    @option_values = (@option_type.present?) ? @option_type.option_values : OptionValue
    @option_values = @option_values.search(params[:search]).page(params[:page]).per(params[:per])
  end
  
  def edit
    @option_value = (@option_type.present?) ? @option_type.option_values : OptionValue
    @option_value = @option_value.find(params[:id])
  end
  
  def new
    @option_value = (@option_type.present?) ? @option_type.option_values.build : OptionValue.new
  end
  
  def create
    @option_value = (@option_type.present?) ? @option_type.option_values.build(params[:option_value]) : OptionValue.new(params[:option_value])
#    @option_value = @option_value.new(params[:option_value])
    if @option_value.save
      redirect_to @url_back, :notice => t('admin.creation_successfull')
    else
      flash[:error] = t('admin.creation_failed')
      render "new"
    end
  end
  
  def destroy
    @option_value = OptionValue.find(params[:id])
    if @option_type.destroy
      redirect_to @url_back, :notice => t('admin.successfully_deleted')
    else
      redirect_to @url_back, :error => t('admin.could_not_be_deleted')
    end
  end
  
  def update
    @option_value = (@option_type.present?) ? @option_type.option_values : OptionValue
    @option_value = @option_value.find(params[:id])
    if @option_value.update_attributes(params[:option_value])
      redirect_to edit_admin_option_values_url, :notice => t('admin.creation_successfull')
    else
      flash[:error] = t('admin.creation_failed')
      render "edit"
    end
  end
  private
  def set_url_callback
    if params[:action] == "create" || params[:action] == "destroy"
      @url_back = (@option_type) ? admin_option_type_option_values_url(@option_type) : admin_option_values_url
    elsif params[:action] == "update"
      @url_back = (@option_type) ? edit_admin_option_type_option_values_url(@option_type) : edit_admin_option_values_url
    end
  end
  def load_option_type
    @option_type = OptionType.find(params[:option_type_id]) if params[:option_type_id]
  end
end
