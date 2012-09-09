class ProductsController < PublicController
  def index
    @products = Product.are_active.search.page(params[:page]).per(10)
  end
  
  def show
    @product = Product.are_active.find_by_permalink!(params[:id])
    if @product.variants.present?
      @selected_variant =  @product.variants.first
      @variants_with_selected = @product.variants.to_a
      @variants = @variants_with_selected.dup
      @variants.delete(@selected_variant)
    else
      @selected_variant = @product.master
      @variants = []
    end
  end
end
