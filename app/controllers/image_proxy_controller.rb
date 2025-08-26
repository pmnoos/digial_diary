class ImageProxyController < ApplicationController
  def show
    @attachment = ActiveStorage::Attachment.find(params[:id])
    @blob = @attachment.blob
    
    if params[:variant].present?
      case params[:variant]
      when 'thumb'
        variant = @blob.variant(resize_to_fill: [150, 150])
      when 'medium'
        variant = @blob.variant(resize_to_fill: [400, 300])
      when 'large'
        variant = @blob.variant(resize_to_limit: [800, 600])
      else
        variant = @blob.variant(resize_to_fill: [150, 150])
      end
      
      redirect_to url_for(variant), allow_other_host: true
    else
      redirect_to url_for(@blob), allow_other_host: true
    end
  rescue ActiveRecord::RecordNotFound
    head :not_found
  rescue => e
    Rails.logger.error "Image proxy error: #{e.message}"
    head :unprocessable_entity
  end
end
