class KeywordsController < ApplicationController
  before_action :set_category

  def create
    @keyword = @category.keywords.build(keyword_params)
    
    if @keyword.save
      render json: { success: true, id: @keyword.id }
    else
      render json: { success: false, error: @keyword.errors.full_messages.join(', ') }
    end
  end

  def destroy
    @keyword = @category.keywords.find(params[:id])
    if @keyword.destroy
      render json: { success: true }
    else
      render json: { success: false, error: 'Failed to delete keyword' }
    end
  end

  # NEW: update action for editing existing keywords
  def update
    @keyword = @category.keywords.find(params[:id])
    if @keyword.update(keyword_params)
      render json: { success: true }
    else
      render json: { success: false, error: @keyword.errors.full_messages.join(', ') }
    end
  end

  private

  def set_category
    @category = Category.find(params[:category_id])
  end

  def keyword_params
    params.require(:keyword).permit(:keyword, :monthly_search_volume)
  end
end