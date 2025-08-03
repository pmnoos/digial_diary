# config/initializers/active_storage.rb

# Disable all image variant processing to avoid dependency issues
Rails.application.config.active_storage.preprocess_variants = false

# Use mini_magick instead of vips for any needed processing
Rails.application.config.active_storage.variant_processor = :mini_magick
