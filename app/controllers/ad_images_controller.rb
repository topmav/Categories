class AdImagesController < ApplicationController
  before_action :set_category

  def index
    # Return JSON of all images
    ad_assets = AdImageAssets.new(@category.id)
    images = ad_assets.images.map do |path|
      filename = File.basename(path)
      {
        url: "/ads/#{@category.id}/#{filename}",
        filename: filename
      }
    end
    render json: { images: images }
  end

  def create
    file_param = params[:file]
    if file_param.blank?
      return render json: { success: false, error: "No file provided" }, status: :unprocessable_entity
    end

    begin
      ad_assets = AdImageAssets.new(@category.id)
      file_path = ad_assets.upload_image(file_param)
      filename = File.basename(file_path)

      render json: {
        success: true,
        filename: filename,
        url: "/ads/#{@category.id}/#{filename}"
      }
    rescue => e
      render json: { success: false, error: e.message }, status: :unprocessable_entity
    end
  end

  def destroy
    filename = params[:id]
    Rails.logger.info "Attempting to delete image: #{filename} for category: #{@category.id}"
    if filename.blank?
      return render json: { success: false, error: "No filename provided" }, status: :unprocessable_entity
    end

    # Add file extension back if it was stripped by Rails
    unless filename.include?('.')
      %w[.png .jpg .jpeg .gif .svg .webp].each do |ext|
        test_filename = filename + ext
        if File.exist?(AdImageAssets::ASSETS_BASE_PATH.join(@category.id.to_s, test_filename))
          filename = test_filename
          break
        end
      end
    end

    begin
      ad_assets = AdImageAssets.new(@category.id)
      ad_assets.delete_image(filename)
      render json: { success: true }
    rescue => e
      Rails.logger.error "Error deleting image: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      render json: { success: false, error: e.message }, status: :internal_server_error
    end
  end

  private

  def set_category
    @category = Category.find(params[:category_id])
  end
end