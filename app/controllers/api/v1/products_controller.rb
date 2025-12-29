class Api::V1::ProductsController < ApplicationController
  def index
    products = Product.all
    render json: products
  end

  def show
    product = Product.find(params[:id])
    render json: product
  end

  def create
    product = Product.new(product_params)

    if product.save
      render json: product, status: :created
    else
      render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    product = Product.find(params[:id])

    if product.update(product_params)
      render json: product
    else
      render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    product = Product.find(params[:id])
    product.destroy

    head :no_content
  end

  # app/controllers/api/v1/products_controller.rb
  def replenish
    product = Product.find(params[:id])
    qty = params[:quantity].to_f

    if qty <= 0
      render json: { error: "Quantity must be greater than zero" }, status: :unprocessable_entity
      return
    end

    product.increment!(:stock_quantity, qty)

    render json: {
      message: "Inventory replenished",
      product: product
    }, status: :ok
  end


  private

  def product_params
    params.require(:product).permit(
      :name, :barcode, :unit, :stock_quantity, :unit_cost,
      :category, :vendor, :par_level
    )
  end
end