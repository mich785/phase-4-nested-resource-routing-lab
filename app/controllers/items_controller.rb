class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  # GET /users/:user_id/items
  def index
    if params[:user_id]
      user = User.find_by(id: params[:user_id])
      if user
        items = user.items
      else
        render json: { error: 'User not found' }, status: :not_found
        return
      end
    else
      items = Item.all
    end

    render json: items, include: :user
  end
  
  def show 
    item = Item.find(params[:id])
    render json: item, include: :user
  end

  def create
    item = Item.create(items_params)
    render json: item ,include: :user, status: :created 
  end

  private

  def items_params
    params.permit(:name, :description, :price, :user_id)
  end

  def render_not_found_response
    render json: { error: "Item not found" }, status: :not_found
  end
end

