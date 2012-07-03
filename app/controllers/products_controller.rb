class ProductsController < PublicController
  def index
    @products = Product.are_active.search.page(params[:page]).per(10)
  end
  
  def show
    @product = Product.are_active.find_by_permalink!(params[:id])
  end
end
