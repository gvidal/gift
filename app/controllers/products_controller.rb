class ProductsController < PublicController
  def index
    @products = Product.are_active.search.page(params[:page]).per(10)
  end
  
  def show
    @product = Product.are_active.find_by_permalink!(params[:id])
    if @product.variants.present?
      @selected_variant =  @product.variants.first
      @variants = @product.variants.to_a.delete(@selected_variant)
    else
      @selected_variant = @product.master
    end
  end
end
