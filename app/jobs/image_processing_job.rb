class ImageProcessingJob < ApplicationJob
  queue_as :default
  retry_on StandardError, wait: :exponentially_longer, attempts: 3

  def perform(attachment_id)
    attachment = ActiveStorage::Attachment.find(attachment_id)
    return unless attachment.blob.image?

    begin
      # Just validate the image can be processed
      attachment.blob.open do |file|
        # This will raise an error if the image is corrupted
        MiniMagick::Image.open(file.path)
      end
      
      Rails.logger.info "Successfully validated image: #{attachment.blob.filename}"
    rescue => e
      Rails.logger.error "Failed to validate image #{attachment.blob.filename}: #{e.message}"
      # Don't re-raise - let the image display with fallbacks
    end
  end
end
