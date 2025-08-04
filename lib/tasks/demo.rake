namespace :demo do
  desc "Create demo user and sample entries for production demo"
  task setup: :environment do
    # Create or find demo user
    demo_user = User.find_or_create_by(username: 'DemoUser') do |user|
      user.email = 'demo@digitaldiaryapp.com'
      user.password = SecureRandom.hex(16)
      user.subscription_status = 'active'
      user.subscription_plan = 'yearly'
      user.trial_started_at = 1.year.ago
      user.trial_ends_at = 1.year.from_now
    end

    puts "Demo user: #{demo_user.username} (ID: #{demo_user.id})"

    # Check if demo entries already exist
    if demo_user.diary_entries.count > 0
      puts "Demo entries already exist: #{demo_user.diary_entries.count} entries"
      next
    end

    puts "Creating demo diary entries..."

    # Sample entry data
    entries = [
      {
        title: "First Day at New Job",
        content: "Today was my first day at the new company. Everyone was so welcoming and I'm excited about the projects ahead. The office has a great view of the city!",
        mood: "excited",
        entry_date: 3.months.ago
      },
      {
        title: "Weekend Hiking Adventure",
        content: "Went hiking with friends today. The trail was challenging but the views from the top were absolutely breathtaking. We saw deer and even a fox!",
        mood: "happy",
        entry_date: 2.months.ago
      },
      {
        title: "Cooking Experiment",
        content: "Tried making homemade pasta for the first time. It was messier than expected but turned out delicious! Mom's recipe never fails.",
        mood: "content",
        entry_date: 1.month.ago
      },
      {
        title: "Beach Day Reflections",
        content: "Spent the day at the beach reading and watching the waves. Sometimes the simple moments are the most meaningful. Finished that book I've been reading for months.",
        mood: "peaceful",
        entry_date: 3.weeks.ago
      },
      {
        title: "Family Dinner",
        content: "Had dinner with the whole family tonight. Grandma told stories about her childhood, and we laughed until our stomachs hurt. These moments are precious.",
        mood: "grateful",
        entry_date: 2.weeks.ago
      },
      {
        title: "Morning Meditation",
        content: "Started my day with 20 minutes of meditation. Feeling more centered and ready to tackle the challenges ahead. Need to make this a daily habit.",
        mood: "calm",
        entry_date: 1.week.ago
      },
      {
        title: "Project Milestone",
        content: "Finally completed the big project at work! Three months of hard work paid off. The team celebration was well-deserved.",
        mood: "accomplished",
        entry_date: 3.days.ago
      },
      {
        title: "Rainy Day Reading",
        content: "Perfect rainy day for staying in with a good book and hot tea. Sometimes the weather forces us to slow down, and that's exactly what I needed.",
        mood: "cozy",
        entry_date: 1.day.ago
      }
    ]

    entries.each_with_index do |entry_data, index|
      entry = demo_user.diary_entries.create!(
        title: entry_data[:title],
        entry_date: entry_data[:entry_date],
        mood: entry_data[:mood],
        status: 'published'
      )
      
      entry.content.body = entry_data[:content]
      entry.save!
      
      print "."
    end

    puts "\nCreated #{entries.count} demo diary entries"
    puts "Demo setup complete!"
  end

  desc "Remove demo data"
  task cleanup: :environment do
    demo_user = User.find_by(username: 'DemoUser')
    if demo_user
      entry_count = demo_user.diary_entries.count
      demo_user.destroy
      puts "Removed demo user and #{entry_count} entries"
    else
      puts "No demo user found"
    end
  end
end
