Thought.create!([
  { content: "Breathe. Reflect. Begin again.", mood: "calm" },
  { content: "You are more than the mistakes you’ve made.", mood: "encouraging" },
  { content: "Your story matters. Keep writing it.", mood: "motivational" },
  { content: "Some days you just have to create your own sunshine.", mood: "positive" },
  { content: "Don’t count the days — make the days count.", mood: "determined" },
  { content: "Even the quietest steps move you forward.", mood: "reflective" },
  { content: "It's okay to pause. Growth happens in stillness too.", mood: "calm" },
  { content: "What you water grows. Choose wisely.", mood: "mindful" },
  { content: "Your perspective can turn problems into possibilities.", mood: "optimistic" },
  { content: "Every scar has a story. Yours shows resilience.", mood: "resilient" },
  { content: "The sunrise always follows the darkest hour.", mood: "hopeful" },
  { content: "You’ve made it through 100% of your hardest days so far.", mood: "encouraging" },
  { content: "Tiny steps still move mountains.", mood: "motivational" },
  { content: "Let go of what you can't control. Embrace what you can.", mood: "peaceful" },
  { content: "Celebrate small wins — they build big momentum.", mood: "joyful" }
])

# Create demo user with active trial
demo_user = User.find_or_create_by(email: 'demo@digitaldiaryapp.com') do |user|
  user.password = 'demopassword123'
  user.username = 'DemoUser'
end

# Always refresh the demo user's trial to be active
demo_user.update!(
  trial_started_at: Time.current,
  trial_ends_at: 30.days.from_now,
  subscription_status: 'trial'
)

# Keep the original test user for backwards compatibility
user = User.find_or_create_by(email: "test@example.com") do |u|
  u.password = "password"
  u.username = "TestUser"
end

DiaryEntry.create!([
  {
    title: "New Beginnings",
    content: "Starting the year with hope and reflection.",
    entry_date: Date.new(2023, 1, 5),
    status: "published",
    mood: "hopeful",
    user: user
  },
  {
    title: "Winter Thoughts",
    content: "It’s cold but cozy, time to slow down.",
    entry_date: Date.new(2023, 1, 18),
    status: "published",
    mood: "calm",
    user: user
  },
  {
    title: "Midyear Check-in",
    content: "Halfway through, and life is moving fast.",
    entry_date: Date.new(2024, 6, 10),
    status: "published",
    mood: "reflective",
    user: user
  },
  {
    title: "Solstice Dreams",
    content: "Longest days bring the brightest ideas.",
    entry_date: Date.new(2024, 6, 21),
    status: "published",
    mood: "grateful",
    user: user
  },
  {
    title: "Sunshine State",
    content: "July brings warmth and creativity.",
    entry_date: Date.new(2025, 7, 2),
    status: "published",
    mood: "joyful",
    user: user
  },
  {
    title: "A Pause to Reflect",
    content: "What a journey this year has been already.",
    entry_date: Date.new(2025, 7, 15),
    status: "published",
    mood: "reflective",
    user: user
  }
])
