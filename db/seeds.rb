# Create thoughts for inspiration
Thought.create!([
  { content: "Breathe. Reflect. Begin again.", mood: "calm" },
  { content: "You are more than the mistakes you've made.", mood: "encouraging" },
  { content: "Your story matters. Keep writing it.", mood: "motivational" },
  { content: "Some days you just have to create your own sunshine.", mood: "positive" },
  { content: "Don't count the days — make the days count.", mood: "determined" },
  { content: "Even the quietest steps move you forward.", mood: "reflective" },
  { content: "It's okay to pause. Growth happens in stillness too.", mood: "calm" },
  { content: "What you water grows. Choose wisely.", mood: "mindful" },
  { content: "Your perspective can turn problems into possibilities.", mood: "optimistic" },
  { content: "Every scar has a story. Yours shows resilience.", mood: "resilient" },
  { content: "The sunrise always follows the darkest hour.", mood: "hopeful" },
  { content: "You've made it through 100% of your hardest days so far.", mood: "encouraging" },
  { content: "Tiny steps still move mountains.", mood: "motivational" },
  { content: "Let go of what you can't control. Embrace what you can.", mood: "peaceful" },
  { content: "Celebrate small wins — they build big momentum.", mood: "joyful" }
])

# Create demo user with always-active trial
demo_user = User.find_or_create_by(email: 'demo@digitaldiaryapp.com') do |user|
  user.password = 'demopassword123'
  user.username = 'DemoUser'
end

# Always refresh the demo user's trial to be active for testing
demo_user.update!(
  trial_started_at: Time.current,
  trial_ends_at: 30.days.from_now,
  subscription_status: 'trial'
)

puts "Demo user created/updated: #{demo_user.email} - Trial active until #{demo_user.trial_ends_at}"

# Keep the original test user for backwards compatibility
user = User.find_or_create_by(email: "test@example.com") do |u|
  u.password = "password"
  u.username = "TestUser"
end

# Create sample diary entries for demo user
DiaryEntry.create!([
  {
    title: "New Beginnings",
    content: "Starting the year with hope and reflection. This is a sample entry to showcase the diary features.",
    entry_date: Date.new(2025, 1, 5),
    status: "published",
    mood: "hopeful",
    user: demo_user
  },
  {
    title: "Winter Thoughts",
    content: "It's cold but cozy, time to slow down and appreciate the quiet moments.",
    entry_date: Date.new(2025, 1, 18),
    status: "published",
    mood: "calm",
    user: demo_user
  },
  {
    title: "Midyear Check-in",
    content: "Halfway through, and life is moving fast. Time to pause and reflect on progress.",
    entry_date: Date.new(2025, 6, 10),
    status: "published",
    mood: "reflective",
    user: demo_user
  },
  {
    title: "Solstice Dreams",
    content: "Longest days bring the brightest ideas. Summer energy is flowing through everything.",
    entry_date: Date.new(2025, 6, 21),
    status: "published",
    mood: "grateful",
    user: demo_user
  },
  {
    title: "Sunshine State",
    content: "July brings warmth and creativity. The perfect time for new projects and adventures.",
    entry_date: Date.new(2025, 7, 2),
    status: "published",
    mood: "joyful",
    user: demo_user
  },
  {
    title: "A Pause to Reflect",
    content: "What a journey this year has been already. So many lessons learned and growth achieved.",
    entry_date: Date.new(2025, 7, 15),
    status: "published",
    mood: "reflective",
    user: demo_user
  },
  {
    title: "August Adventures",
    content: "A new month brings new possibilities. Excited to see what unfolds.",
    entry_date: Date.new(2025, 8, 1),
    status: "published",
    mood: "excited",
    user: demo_user
  }
])

puts "Created #{DiaryEntry.count} diary entries for demo user"
puts "Demo user has #{demo_user.remaining_trial_entries} entries remaining in trial"
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?