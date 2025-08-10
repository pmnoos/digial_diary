class ImageProcessingJob < ApplicationJob
  queue_as :default
  retry_on StandardError, wait: :exponentially_longer, attempts: 3

  def perform(attachment_id)
    attachment = ActiveStorage::Attachment.find(attachment_id)
    return unless attachment.blob.image?

    begin
      # Pre-generate common variants
      attachment.variant(:thumb)
      attachment.variant(:medium) 
      attachment.variant(:large)
      
      Rails.logger.info "Successfully processed variants for image: #{attachment.blob.filename}"
    rescue => e
      Rails.logger.error "Failed to process image variants for #{attachment.blob.filename}: #{e.message}"
      # Don't re-raise - let the image display with fallbacks
    end
  end
end
