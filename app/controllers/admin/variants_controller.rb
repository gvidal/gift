class Admin::VariantsController < AdminController
  
  before_filter :load_product
  before_filter :warn_option_type_needed
  before_filter :option_type_needed, only: [:new, :create, :update, :edit]
    
  def index
    @variants = @product.variants.search(params[:search])
    respond_to do |format|
      format.html{@variants = @variants.page(params[:page]).per(params[:per])}
      format.json{render :json => @variants.to_a.map{|x| {:name => x.name, :id => x.id}}}
    end
  end
  
  def edit
     @variant = @product.variants.find(params[:id])
  end
  
  def new
    @variant = @product.variants.new
  end
  
  def create
    @variant = @product.variants.new(params[:variant])
    if @variant.save
      redirect_to admin_product_variants_url(@product), :notice => t('admin.creation_successfull')
    else
      flash[:error] = t('admin.creation_failed')
      render "new"
    end
  end
  
  def destroy
    @variant = @product.variants.find(params[:id])
    if @variant.destroy
      redirect_to admin_product_variants_url(@product), :notice => t('admin.successfully_deleted')
    else
      redirect_to admin_product_variants_url(@product), :error => t('admin.could_not_be_deleted')
    end
  end
  
  def update
    @variant = @product.variants.find(params[:id])
    if @variant.update_attributes(params[:variant])
      redirect_to edit_admin_product_variant_url(@product,@variant), :notice => t('admin.creation_successfull')
    else
      flash[:error] = t('admin.creation_failed')
      render "edit"
    end
  end
  private
  def warn_option_type_needed
    if @product.option_types.blank?
      flash[:warn] = t('admin.views.variants.product_needs_option_type')
    end
  end
  def option_type_needed
    if @product.option_types.blank?
      redirect_to admin_product_variants_url
    end
  end
  def load_product
    @product = Product.find_by_permalink(params[:product_id])
  end
end
