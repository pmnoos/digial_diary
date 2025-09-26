require "mini_magick"
MiniMagick.configure do |config|
  config.tmpdir = Rails.root.join("tmp")
end