# Demo Data Seeds for Digital Diary App
# This creates a rich demo environment with lots of sample content

puts "🌱 Creating demo data for Digital Diary App..."

# Create demo user
demo_user = User.find_or_create_by(email: 'demo@digitaldiaryapp.com') do |user|
  user.password = 'demopassword123'
  user.password_confirmation = 'demopassword123'
  user.username = 'DemoUser'
end

puts "✅ Demo user created: #{demo_user.email}"

# Sample diary entry templates
diary_templates = [
  {
    title: "Morning Coffee Reflections",
    content: "Started my day with a perfect cup of coffee and watched the sunrise from my window. There's something magical about those quiet morning moments when the world is still waking up. I'm grateful for these peaceful beginnings.",
    mood: "content"
  },
  {
    title: "Successful Meeting Today",
    content: "Had an amazing team meeting where we finally cracked the solution to the project we've been working on for weeks. The collaboration was incredible, and everyone brought their A-game. Feeling really proud of what we accomplished together.",
    mood: "happy"
  },
  {
    title: "Rainy Day Thoughts",
    content: "It's been raining all day, which gave me the perfect excuse to stay inside with a good book and some hot tea. Sometimes these slower days are exactly what we need to recharge and reflect on life.",
    mood: "peaceful"
  },
  {
    title: "Family Dinner Celebration",
    content: "We celebrated Mom's birthday tonight with her favorite homemade lasagna and chocolate cake. The house was full of laughter, stories, and love. These family moments remind me what truly matters in life.",
    mood: "joyful"
  },
  {
    title: "Challenging Workout Complete",
    content: "Pushed myself harder than usual at the gym today. My personal trainer introduced some new exercises that really challenged me, but I feel stronger already. The endorphins afterward made it all worth it!",
    mood: "energetic"
  },
  {
    title: "Weekend Nature Walk",
    content: "Explored a new hiking trail today and discovered a beautiful hidden waterfall. Nature has this incredible way of putting everything into perspective. Took some amazing photos and filled my lungs with fresh air.",
    mood: "refreshed"
  },
  {
    title: "Productive Work Session",
    content: "Had one of those amazing flow states where everything just clicked. Completed three major tasks and felt completely in the zone. Days like this remind me why I love what I do.",
    mood: "accomplished"
  },
  {
    title: "Learning Something New",
    content: "Started learning Spanish today using a new app. It's challenging but exciting to exercise my brain in a new way. Looking forward to eventually having conversations in another language!",
    mood: "curious"
  },
  {
    title: "Cozy Evening at Home",
    content: "Perfect night in with my favorite Netflix series, homemade popcorn, and soft blankets. Sometimes the best evenings are the simple ones where you can just relax and unwind.",
    mood: "relaxed"
  },
  {
    title: "Helping a Friend",
    content: "Spent the afternoon helping my friend move into their new apartment. It was hard work, but seeing their excitement about this new chapter in their life made it feel meaningful. Good friends make everything better.",
    mood: "fulfilled"
  },
  {
    title: "Creative Breakthrough",
    content: "Finally figured out the solution to that design problem I've been stuck on for days! Sometimes stepping away and coming back with fresh eyes is exactly what's needed. Creativity can't be rushed.",
    mood: "inspired"
  },
  {
    title: "Difficult Day Reflection",
    content: "Today was tough. Work was stressful, traffic was horrible, and everything seemed to go wrong. But I'm learning that bad days make us appreciate the good ones even more. Tomorrow is a fresh start.",
    mood: "reflective"
  },
  {
    title: "Farmers Market Adventure",
    content: "Visited the local farmers market and came home with bags full of fresh produce and homemade bread. I love supporting local businesses and eating food that's grown with care and attention.",
    mood: "satisfied"
  },
  {
    title: "Late Night Stargazing",
    content: "Couldn't sleep, so I went outside and lay on the grass looking up at the stars. The universe is so vast and mysterious. It's humbling and beautiful at the same time.",
    mood: "contemplative"
  },
  {
    title: "Surprise Visit from Old Friends",
    content: "My college roommates surprised me with an impromptu visit! We stayed up way too late catching up, laughing about old memories, and making new ones. These friendships are precious treasures.",
    mood: "nostalgic"
  }
]

# Create diary entries spanning several months
puts "📝 Creating diary entries..."

entry_count = 0
(1..150).each do |i|
  # Random date in the past 6 months
  random_date = rand(180.days).seconds.ago
  
  # Pick a random template
  template = diary_templates.sample
  
  # Create variations of the title and content
  title_variations = [
    template[:title],
    "#{template[:title]} - Day #{i}",
    "#{random_date.strftime('%B')} #{template[:title]}",
    "Thoughts on #{template[:title]}"
  ]
  
  content_additions = [
    "\n\nThe weather was perfect today - sunny with a gentle breeze.",
    "\n\nI'm really grateful for all the good things in my life right now.",
    "\n\nCan't wait to see what tomorrow brings!",
    "\n\nFeeling optimistic about the future.",
    "\n\nIt's amazing how much can change in just one day.",
    "\n\nLife is full of beautiful surprises.",
    "\n\nTaking time to appreciate the little moments.",
    "\n\nEvery day is a new opportunity to grow and learn."
  ]
  
  diary_entry = DiaryEntry.create!(
    title: title_variations.sample,
    content: template[:content] + content_additions.sample,
    entry_date: random_date.to_date,
    mood: template[:mood],
    user: demo_user
  )
  
  entry_count += 1
  print "." if entry_count % 10 == 0
end

puts "\n✅ Created #{entry_count} diary entries"

# Create some tags
puts "🏷️ Creating tags..."

tag_names = [
  "personal-growth", "family-time", "work-life", "fitness", "travel", 
  "cooking", "reading", "nature", "friends", "creativity", "meditation",
  "learning", "gratitude", "challenges", "celebrations", "weekend",
  "morning-routine", "evening-thoughts", "achievements", "reflections"
]

tags = tag_names.map do |tag_name|
  Tag.find_or_create_by(name: tag_name)
end

puts "✅ Created #{tags.count} tags"

# Assign random tags to entries
puts "🔗 Assigning tags to entries..."

DiaryEntry.where(user: demo_user).find_each do |entry|
  # Assign 1-3 random tags to each entry
  random_tags = tags.sample(rand(1..3))
  random_tags.each do |tag|
    DiaryEntryTag.find_or_create_by(diary_entry: entry, tag: tag)
  end
end

puts "✅ Tags assigned to entries"

# Create some thoughts of the day
puts "💭 Creating thoughts of the day..."

thoughts = [
  "The best time to plant a tree was 20 years ago. The second best time is now.",
  "Success is not final, failure is not fatal: it is the courage to continue that counts.",
  "Life is what happens to you while you're busy making other plans.",
  "The only way to do great work is to love what you do.",
  "In the middle of difficulty lies opportunity.",
  "Be yourself; everyone else is already taken.",
  "Two things are infinite: the universe and human stupidity; and I'm not sure about the universe.",
  "You only live once, but if you do it right, once is enough.",
  "Life is really simple, but we insist on making it complicated.",
  "The purpose of our lives is to be happy."
]

thoughts.each do |thought_content|
  Thought.create!(
    content: thought_content
  )
end

puts "✅ Created #{thoughts.count} thoughts"

puts "\n🎉 Demo data creation complete!"
puts "Demo login: demo@digitaldiaryapp.com"
puts "Password: demopassword123"
puts "\nThe demo account now has:"
puts "- #{DiaryEntry.where(user: demo_user).count} diary entries"
puts "- #{tags.count} tags"
puts "- #{thoughts.count} thoughts of the day"
puts "- Entries spanning the last 6 months"
puts "- Rich, varied content with different moods and themes"
