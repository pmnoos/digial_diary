class SessionsController < Devise::SessionsController
  # Override the destroy method to add debugging
  def destroy
    logger.info "Session destroy called"
    logger.info "Request method: #{request.method}"
    logger.info "Request format: #{request.format}"
    logger.info "Params: #{params}"
    
    # Call the parent destroy method
    super
  end
end