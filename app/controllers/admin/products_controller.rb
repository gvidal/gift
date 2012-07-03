class Admin::ProductsController < AdminController
  def index
    @products = Product.search(params[:search])
    respond_to do |format|
      format.html{@products = @products.page(params[:page]).per(params[:per])}
      format.json{render :json => @products.to_a.map{|x| {:name => x.name, :id => x.id}}}
    end
  end
  
  def edit
    @product = Product.find_by_permalink(params[:id])
  end
  def new
    @product = Product.new
    @product.build_master
    @product.master.variant_images.build
  end
  
  def create
    @product = Product.new(params[:product])
    if @product.save
      redirect_to edit_admin_product_url(@product), :notice => t('admin.creation_successfull')
    else
      flash[:error] = t('admin.creation_failed')
      render "new"
    end
  end
  
  def destroy
    @product = Product.find_by_permalink(params[:id])
    if @product.destroy
      redirect_to admin_products_url, :notice => t('admin.successfully_deleted')
    else
      redirect_to admin_products_url, :error => t('admin.could_not_be_deleted')
    end
  end
  
  def update
    @product = Product.find_by_permalink(params[:id])
    if @product.update_attributes(params[:product])
      redirect_to edit_admin_product_url(@product), :notice => t('admin.creation_successfull')
    else
      flash[:error] = t('admin.creation_failed')
      render "edit"
    end
  end
end
