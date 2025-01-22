class CategoryAssets
    # CHANGED: Switched from app/assets/images/landing_pages to public/landing_pages
    ASSETS_BASE_PATH = Rails.root.join("public", "landing_pages")
  
    attr_reader :category_id
  
    def initialize(category_id)
      @category_id = category_id
    end
  
    # Returns an array of file paths (string) for images associated with the given category
    def images
      ensure_folder_exists!
      Dir.glob(folder_path.join("**", "*.{png,jpg,jpeg,gif,svg,webp}"))
    end
  
    # Copies an uploaded image file into the category's subfolder
    def upload_image(image)
      ensure_folder_exists!
      timestamp = Time.now.strftime("%Y%m%d_%H%M%S")
      original_filename = File.basename(image.original_filename)
      filename = "#{timestamp}_#{original_filename}"
      file_path = folder_path.join(filename)
      FileUtils.cp(image.path, file_path)
      file_path.to_s
    end
  
    # Deletes an image by filename if it exists
    def delete_image(filename)
      file_to_delete = folder_path.join(filename)
      Rails.logger.info "Attempting to delete file at: #{file_to_delete}"
      Rails.logger.info "File exists?: #{File.exist?(file_to_delete)}"
      File.delete(file_to_delete) if File.exist?(file_to_delete)
      Rails.logger.info "After deletion - File exists?: #{File.exist?(file_to_delete)}"
    end
  
    private
  
    def ensure_folder_exists!
      FileUtils.mkdir_p(folder_path) unless File.directory?(folder_path)
    end
  
    def folder_path
      ASSETS_BASE_PATH.join(category_id.to_s)
    end
  end