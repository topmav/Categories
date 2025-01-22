class CategoriesController < ApplicationController
  def index
    @categories = Category.order(:id)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path, notice: 'Category was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # /categories/:id -> edit
  def edit
    @category = Category.find(params[:id])
    @form = @category.form || @category.build_form
    load_landing_page_images
    load_ad_images
  end

  def update
    @category = Category.find(params[:id])
    # Always ensure @form is set
    @form = @category.form || @category.build_form

    if @category.update(category_params)
      # Handle JSON form data from the text area
      if params[:form_data].present?
        begin
          if params[:form_data].is_a?(String)
            @form.form_data = JSON.parse(params[:form_data])
          else
            @form.form_data = params[:form_data].to_unsafe_h
          end
          @form.save!
        rescue JSON::ParserError => e
          flash.now[:alert] = "Invalid JSON in Form Data: #{e.message}"
        end
      end

      flash[:notice] = 'Category updated successfully!'
      load_landing_page_images
      load_ad_images
      render :edit
    else
      flash.now[:alert] = 'Error updating category!'
      load_landing_page_images
      load_ad_images
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def category_params
    params.require(:category).permit(
      :name,
      :description,
      :qualified_lead_desc,
      :unqualified_lead_desc,
      :suggested_lead_pricing,
      :pricing_factors,
      :monthly_search_volume,
      :customer_lifetime_value,
      :cpc_low,
      :cpc_high,
      :viability_assessment
      # Removed :form_data here since we handle it separately
    )
  end

  def load_landing_page_images
    category_assets = CategoryAssets.new(@category.id)
    @landing_page_images = category_assets.images.map do |path|
      filename = File.basename(path)
      {
        url: "/landing_pages/#{@category.id}/#{filename}",
        filename: filename
      }
    end
  end

  def load_ad_images
    category_assets = AdImageAssets.new(@category.id)
    @ad_images = category_assets.images.map do |path|
      filename = File.basename(path)
      {
        url: "/ads/#{@category.id}/#{filename}",
        filename: filename
      }
    end
  end
end