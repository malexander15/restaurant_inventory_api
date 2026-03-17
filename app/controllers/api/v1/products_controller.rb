class Api::V1::ProductsController < ApplicationController
  def index
    products = current_restaurant.products
    render json: products.as_json(include: [:product_category, :ingredient])
  end

  def show
    product = current_restaurant.products.find(params[:id])
    render json: product.as_json(include: [:product_category, :ingredient])
  end

  def create
    product = current_restaurant.products.new(product_params)

    if product.save
      render json: product.as_json(include: [:product_category, :ingredient]), status: :created
    else
      render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    product = current_restaurant.products.find(params[:id])

    if product.update(product_params)
      render json: product.as_json(include: [:product_category, :ingredient])
    else
      render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    product = current_restaurant.products.find(params[:id])
    product.destroy

    head :no_content
  end

  def replenish
    product = current_restaurant.products.find(params[:id])
    product.replenish!(params[:quantity])

    render json: {
      message: "Inventory replenished",
      product: product.as_json(include: [:product_category, :ingredient])
    }, status: :ok
  rescue ArgumentError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def by_barcode
    product = current_restaurant.products.find_by(barcode: params[:barcode])

    if product
      render json: product.as_json(include: [:product_category, :ingredient])
    else
      render json: { error: "Product not found" }, status: :not_found
    end
  end

  private

  def product_params
    params.require(:product).permit(
      :name,
      :barcode,
      :unit,
      :stock_quantity,
      :unit_cost,
      :product_category_id,
      :ingredient_id,
      :vendor,
      :par_level
    )
  end
end