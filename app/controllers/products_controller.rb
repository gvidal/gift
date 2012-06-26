class ProductsController < PublicController
  def index
    @products = Product.are_active.search.page(params[:page]).per(10)
  end
end
