class Admin::OptionValuesController < AdminController
  before_filter :load_option_type
  def index
    @option_values = (@option_type.present?) ? @option_type.option_values : OptionValue
    @option_values = @option_values.search(params[:search]).page(params[:page]).per(params[:per])
  end
  
  def edit
    @option_value = (@option_type.present?) ? @option_types.option_values : OptionValue
    @option_value = @option_value.find(params[:id])
  end
  
  def new
    @option_value = (@option_type.present?) ? @option_type.option_values.build : OptionValue.new
  end
  
  def create
    @option_value = (@option_type.present?) ? @option_type.option_values.build(params[:option_type]) : OptionValue.new(parmas[:option_type])
    @option_value = @option_value.new(params[:option_type])
    if @option_value.save
      redirect_to admin_option_values_url, :notice => t('admin.creation_successfull')
    else
      flash[:error] = t('admin.creation_failed')
      render "new"
    end
  end
  
  def destroy
    @option_value = OptionValue.find(params[:id])
    if @option_type.destroy
      redirect_to admin_option_values_url, :notice => t('admin.successfully_deleted')
    else
      redirect_to admin_option_values_url, :error => t('admin.could_not_be_deleted')
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
  def load_option_type
    @option_type = OptionType.find(params[:option_type_id]) if params[:option_type_id]
  end
end
