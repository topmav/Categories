class SellersController < ApplicationController
    before_action :set_category
  
    def create
      @seller = @category.sellers.build(seller_params)
      if @seller.save
        render json: { success: true, id: @seller.id }
      else
        render json: { success: false, error: @seller.errors.full_messages.join(", ") }
      end
    end
  
    def destroy
      @seller = @category.sellers.find(params[:id])
      if @seller.destroy
        render json: { success: true }
      else
        render json: { success: false, error: "Failed to delete seller" }
      end
    end
  
    # NEW: update action for editing existing sellers
    def update
      @seller = @category.sellers.find(params[:id])
      if @seller.update(seller_params)
        render json: { success: true }
      else
        render json: { success: false, error: @seller.errors.full_messages.join(", ") }
      end
    end
  
    private
  
    def set_category
      @category = Category.find(params[:category_id])
    end
  
    def seller_params
      params.require(:seller).permit(:name, :website, :size, :note)
    end
  end