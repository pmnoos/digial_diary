demo_user = User.find_by(username: 'DemoUser')
if demo_user
  entries_with_images = demo_user.diary_entries.joins(:images_attachments).includes(:images_attachments)
  puts "Entries with images:"
  entries_with_images.each do |entry|
    puts "#{entry.id}: #{entry.title} (#{entry.images.count} images)"
  end
else
  puts "No demo user found"
end
