# config/initializers/active_storage.rb

# Enable image variant processing with proper error handling
Rails.application.config.active_storage.preprocess_variants = true

# Use mini_magick for image processing (more reliable than vips)
Rails.application.config.active_storage.variant_processor = :mini_magick

# Set content types allowed for inline display
Rails.application.config.active_storage.content_types_allowed_inline = %w[
  image/png
  image/jpeg 
  image/jpg
  image/gif
  image/webp
  image/svg+xml
]

# Prevent processing of very large images that could crash the system
Rails.application.config.active_storage.max_image_pixel_count = 16_777_216 # 4096x4096 pixels

# Better error handling for image processing
class ActiveStorage::Variant
  private

  def transform_blob
    processed_blob = blob.open do |input|
      output = Tempfile.new(["variant", blob.filename.extension_with_delimiter])
      output.binmode

      begin
        image = MiniMagick::Image.new(input.path)
        
        # Validate the image before processing
        raise "Invalid image format" unless image.valid?
        
        # Apply format conversion if specified
        image.format(format.to_s) if format
        
        # Apply transformations
        image.combine_options do |cmd|
          variation.each do |name, argument|
            case name.to_s
            when "resize_to_limit"
              cmd.resize "#{argument[0]}x#{argument[1]}>"
            when "resize_to_fill"
              cmd.resize "#{argument[0]}x#{argument[1]}^"
              cmd.gravity "center"
              cmd.extent "#{argument[0]}x#{argument[1]}"
            when "resize_and_pad"
              cmd.resize "#{argument[0]}x#{argument[1]}"
              cmd.background "white"
              cmd.gravity "center"
              cmd.extent "#{argument[0]}x#{argument[1]}"
            else
              cmd.send(name, argument)
            end
          end
        end
        
        image.write(output.path)
        Rails.logger.info "Successfully processed image variant: #{blob.filename}"
        
      rescue => e
        Rails.logger.error "Image processing failed for #{blob.filename}: #{e.message}"
        # Return original image data if processing fails
        input.rewind
        output.write(input.read)
      end

      output.flush
      output.rewind
      output
    end

    new_blob = blob.class.create_and_upload!(
      io: processed_blob,
      filename: "#{blob.filename.base}_variant.#{format || blob.filename.extension}",
      content_type: blob.content_type
    )

    processed_blob.close!
    new_blob
  rescue => e
    Rails.logger.error "Failed to create variant blob: #{e.message}"
    # Return the original blob if variant creation fails
    blob
  end
end
