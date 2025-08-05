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

    # Sample entry data - comprehensive demo showcase
    entries = [
      # Recent entries (last 2 weeks)
      {
        title: "Rainy Day Reading",
        content: "Perfect rainy day for staying in with a good book and hot tea. Sometimes the weather forces us to slow down, and that's exactly what I needed. Currently reading 'The Seven Husbands of Evelyn Hugo' - can't put it down!",
        mood: "cozy",
        entry_date: 1.day.ago
      },
      {
        title: "Weekend Photography Walk",
        content: "Took my camera out for a proper photo walk around the city today. Discovered some amazing street art and captured the golden hour perfectly. Photography always helps me see the world differently.",
        mood: "inspired",
        entry_date: 2.days.ago
      },
      {
        title: "Project Milestone Celebration",
        content: "Finally completed the big project at work! Three months of hard work paid off. The team celebration was well-deserved - we went out for dinner and shared stories about all the challenges we overcame together.",
        mood: "accomplished",
        entry_date: 4.days.ago
      },
      {
        title: "Morning Yoga Session",
        content: "Started my day with 45 minutes of yoga on the balcony. The sunrise was spectacular and I felt so grounded afterward. Need to make this a daily habit - my body and mind both feel the difference.",
        mood: "centered",
        entry_date: 6.days.ago
      },
      {
        title: "Coffee Shop Discovery",
        content: "Found this amazing little coffee shop tucked away in an alley downtown. The barista makes the most incredible latte art, and they have these huge windows perfect for people watching. Definitely my new work-from-cafe spot!",
        mood: "delighted",
        entry_date: 1.week.ago
      },
      {
        title: "Family Video Call",
        content: "Had a long video call with family across the country. It's amazing how technology keeps us connected. Grandma is learning to use her tablet and she's becoming quite the expert! We laughed so much my cheeks hurt.",
        mood: "grateful",
        entry_date: 10.days.ago
      },
      {
        title: "Cooking Adventure Gone Wrong",
        content: "Attempted to make a soufflé tonight. Let's just say it was more like a pancake by the time I took it out of the oven! Sometimes failures make the best stories. Ordered pizza instead and laughed about it.",
        mood: "amused",
        entry_date: 2.weeks.ago
      },

      # One month ago entries
      {
        title: "Art Gallery Opening",
        content: "Attended the opening of a local artist's exhibition tonight. Her work on climate change was both beautiful and haunting. Art has this incredible power to make us feel and think simultaneously. Met some interesting people too.",
        mood: "reflective",
        entry_date: 3.weeks.ago
      },
      {
        title: "Beach Day Reflections",
        content: "Spent the entire day at the beach reading and watching the waves. Sometimes the simple moments are the most meaningful. Finished 'Atomic Habits' - such great insights about building better routines. The sound of waves is so therapeutic.",
        mood: "peaceful",
        entry_date: 1.month.ago
      },
      {
        title: "Cooking Success Story",
        content: "Tried making homemade pasta for the first time and it actually worked! It was messier than expected but turned out absolutely delicious. Mom's recipe never fails. The whole kitchen smelled like Italy.",
        mood: "proud",
        entry_date: 5.weeks.ago
      },
      {
        title: "Late Night Stargazing",
        content: "Couldn't sleep so I went out to the backyard and looked up at the stars. Found the Big Dipper and even saw a shooting star! Moments like these remind me how vast and beautiful the universe is. Made a wish too.",
        mood: "wonder",
        entry_date: 6.weeks.ago
      },

      # Two months ago entries
      {
        title: "Weekend Hiking Adventure", 
        content: "Went hiking with friends today on the mountain trail. The climb was challenging but the views from the summit were absolutely breathtaking. We saw deer, a family of rabbits, and even spotted a hawk circling overhead. Nature is the best therapy.",
        mood: "exhilarated",
        entry_date: 2.months.ago
      },
      {
        title: "Concert Under the Stars",
        content: "Attended an outdoor concert tonight - a local indie band playing in the park. The music was incredible and the atmosphere was magical with string lights everywhere. Music has this way of bringing strangers together.",
        mood: "euphoric",
        entry_date: 9.weeks.ago
      },
      {
        title: "Rainy Sunday Baking",
        content: "Spent the rainy Sunday afternoon baking chocolate chip cookies from scratch. The house smells amazing and I have enough cookies to share with neighbors. There's something so satisfying about creating something delicious with your own hands.",
        mood: "satisfied",
        entry_date: 10.weeks.ago
      },

      # Three months ago entries
      {
        title: "First Day at New Job",
        content: "Today was my first day at the new company and I'm feeling a mix of excitement and nerves. Everyone was incredibly welcoming and I'm excited about the projects ahead. The office has this amazing view of the city skyline that I'll never get tired of!",
        mood: "excited",
        entry_date: 3.months.ago
      },
      {
        title: "Garden Planning Session",
        content: "Spent the morning planning this year's garden. Decided to try growing tomatoes, herbs, and maybe some sunflowers. There's something hopeful about planting seeds and imagining the harvest. Spring always fills me with possibility.",
        mood: "hopeful",
        entry_date: 13.weeks.ago
      },
      {
        title: "Book Club Discussion",
        content: "Had our monthly book club meeting tonight. We discussed 'The Midnight Library' and had such deep conversations about life choices and parallel lives. It's amazing how a good book can spark hours of philosophical discussion.",
        mood: "thoughtful",
        entry_date: 14.weeks.ago
      },

      # Four months ago entries
      {
        title: "Winter Solstice Reflection",
        content: "Today marks the shortest day of the year, but also the promise that light is returning. I love this symbolic turning point - a reminder that even in darkness, there's always hope for brighter days ahead. Made hot cocoa and lit candles tonight.",
        mood: "contemplative",
        entry_date: 4.months.ago
      },
      {
        title: "Ice Skating Adventure",
        content: "Went ice skating for the first time in years! Fell down more times than I'd like to admit, but laughed until my stomach hurt. Sometimes you need to embrace being a beginner again. The hot chocolate afterward was the perfect ending.",
        mood: "playful",
        entry_date: 17.weeks.ago
      },
      {
        title: "Holiday Market Exploration",
        content: "Wandered through the holiday market downtown today. The smell of cinnamon and pine, twinkling lights everywhere, and handmade crafts as far as the eye could see. Bought some unique gifts and felt the magic of the season.",
        mood: "festive",
        entry_date: 18.weeks.ago
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
      
      # Add relevant tags to demonstrate search/filter functionality
      tag_sets = [
        ['reading', 'relaxation', 'self-care'], # Rainy Day Reading
        ['photography', 'creativity', 'urban', 'art'], # Weekend Photography Walk
        ['work', 'achievement', 'teamwork', 'celebration'], # Project Milestone Celebration
        ['wellness', 'morning-routine', 'mindfulness', 'self-care'], # Morning Yoga Session
        ['coffee', 'discovery', 'work-from-home', 'local-business'], # Coffee Shop Discovery
        ['family', 'technology', 'connection', 'gratitude'], # Family Video Call
        ['cooking', 'failure', 'humor', 'food'], # Cooking Adventure Gone Wrong
        ['art', 'culture', 'social', 'inspiration'], # Art Gallery Opening
        ['beach', 'reading', 'nature', 'mindfulness'], # Beach Day Reflections
        ['cooking', 'success', 'italian', 'family-recipe'], # Cooking Success Story
        ['stargazing', 'wonder', 'universe', 'nighttime'], # Late Night Stargazing
        ['hiking', 'nature', 'friends', 'adventure'], # Weekend Hiking Adventure
        ['music', 'concert', 'community', 'outdoor'], # Concert Under the Stars
        ['baking', 'cooking', 'neighbors', 'sharing'], # Rainy Sunday Baking
        ['work', 'new-beginnings', 'career', 'office'], # First Day at New Job
        ['gardening', 'planning', 'hope', 'spring'], # Garden Planning Session
        ['book-club', 'reading', 'discussion', 'philosophy'], # Book Club Discussion
        ['winter', 'reflection', 'solstice', 'hope'], # Winter Solstice Reflection
        ['ice-skating', 'winter-activities', 'playful', 'hot-chocolate'], # Ice Skating Adventure
        ['holiday', 'market', 'crafts', 'seasonal'] # Holiday Market Exploration
      ]
      
      # Add tags for this entry
      if tag_sets[index]
        tag_sets[index].each do |tag_name|
          tag = Tag.find_or_create_by(name: tag_name)
          DiaryEntryTag.find_or_create_by(diary_entry: entry, tag: tag)
        end
      end
      
      # Attach demo images to showcase photo gallery across different entries
      case index
      when 1 # Weekend Photography Walk
        attach_sample_image(entry, 'street_art', 'Urban street art discovery')
        attach_sample_image(entry, 'golden_hour', 'Perfect golden hour lighting')
      when 2 # Project Milestone Celebration
        attach_sample_image(entry, 'celebration', 'Team celebration dinner')
      when 4 # Coffee Shop Discovery
        attach_sample_image(entry, 'coffee_art', 'Beautiful latte art')
        attach_sample_image(entry, 'cozy_cafe', 'Cozy coffee shop atmosphere')
      when 9 # Cooking Success Story
        attach_sample_image(entry, 'homemade_pasta', 'Fresh homemade pasta')
        attach_sample_image(entry, 'cooking_process', 'Pasta making process')
      when 11 # Weekend Hiking Adventure
        attach_sample_image(entry, 'mountain_view', 'Breathtaking mountain summit view')
        attach_sample_image(entry, 'hiking_trail', 'Scenic hiking trail')
        attach_sample_image(entry, 'wildlife', 'Wildlife spotted on trail')
      when 12 # Concert Under the Stars
        attach_sample_image(entry, 'concert_stage', 'Outdoor concert stage with lights')
        attach_sample_image(entry, 'crowd_atmosphere', 'Concert crowd atmosphere')
      when 13 # Rainy Sunday Baking
        attach_sample_image(entry, 'cookies', 'Fresh baked chocolate chip cookies')
      when 15 # Garden Planning Session
        attach_sample_image(entry, 'garden_plan', 'Garden layout and seed packets')
        attach_sample_image(entry, 'planting_tools', 'Gardening tools and supplies')
      when 18 # Ice Skating Adventure
        attach_sample_image(entry, 'ice_rink', 'Ice skating rink with friends')
      when 19 # Holiday Market Exploration
        attach_sample_image(entry, 'holiday_market', 'Festive holiday market scene')
        attach_sample_image(entry, 'handmade_crafts', 'Beautiful handmade holiday crafts')
      end
      
      print "."
    end

    puts "\nCreated #{entries.count} demo diary entries with images"
    puts "Demo setup complete!"
  end

  private

  def attach_sample_image(entry, category, description)
    require 'open-uri'
    
    # Use Lorem Picsum for demo images - free placeholder service
    image_urls = {
      'street_art' => 'https://picsum.photos/400/300?random=1',
      'golden_hour' => 'https://picsum.photos/400/300?random=2',
      'celebration' => 'https://picsum.photos/400/300?random=3',
      'coffee_art' => 'https://picsum.photos/400/300?random=4',
      'cozy_cafe' => 'https://picsum.photos/400/300?random=5',
      'homemade_pasta' => 'https://picsum.photos/400/300?random=6',
      'cooking_process' => 'https://picsum.photos/400/300?random=7',
      'mountain_view' => 'https://picsum.photos/400/300?random=8',
      'hiking_trail' => 'https://picsum.photos/400/300?random=9',
      'wildlife' => 'https://picsum.photos/400/300?random=10',
      'concert_stage' => 'https://picsum.photos/400/300?random=11',
      'crowd_atmosphere' => 'https://picsum.photos/400/300?random=12',
      'cookies' => 'https://picsum.photos/400/300?random=13',
      'garden_plan' => 'https://picsum.photos/400/300?random=14',
      'planting_tools' => 'https://picsum.photos/400/300?random=15',
      'ice_rink' => 'https://picsum.photos/400/300?random=16',
      'holiday_market' => 'https://picsum.photos/400/300?random=17',
      'handmade_crafts' => 'https://picsum.photos/400/300?random=18'
    }
    
    begin
      url = image_urls[category]
      if url
        downloaded_image = URI.open(url)
        entry.images.attach(
          io: downloaded_image,
          filename: "#{category}_#{entry.id}.jpg",
          content_type: 'image/jpeg'
        )
        puts "\n  Attached image for #{entry.title}"
      end
    rescue => e
      puts "\n  Warning: Could not attach image for #{entry.title}: #{e.message}"
    end
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
