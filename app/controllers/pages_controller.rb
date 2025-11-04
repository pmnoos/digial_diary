class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:landing]
  
  def landing
    @features = [
      {
        icon: "fas fa-pen-fancy",
        title: "Simple Text Editor",
        description: "Write your thoughts with a clean, distraction-free text editor"
      },
      {
        icon: "fas fa-images",
        title: "Photo Memories",
        description: "Upload multiple images to accompany your diary entries"
      },
      {
        icon: "fas fa-calendar-check",
        title: "Events & Appointments",
        description: "Track important dates, appointments, and upcoming events with reminders"
      },
      {
        icon: "fas fa-heart",
        title: "Mood Tracking",
        description: "Track your emotions and see patterns over time"
      },
      {
        icon: "fas fa-search",
        title: "Smart Search",
        description: "Find any entry quickly by searching title or content"
      },
      {
        icon: "fas fa-calendar-alt",
        title: "Date Organization",
        description: "Browse entries by year, month, or specific dates"
      },
      {
        icon: "fas fa-lightbulb",
        title: "Daily Inspiration",
        description: "Get thoughtful prompts and quotes to inspire your writing"
      },
      {
        icon: "fas fa-bell",
        title: "Smart Reminders",
        description: "Never miss important events with upcoming reminders on your dashboard"
      },
      {
        icon: "fas fa-mobile-alt",
        title: "Mobile Ready",
        description: "Write on any device - phone, tablet, or computer"
      },
      {
        icon: "fas fa-lock",
        title: "Private & Secure",
        description: "Your thoughts and events are yours alone - private and encrypted"
      }
    ]
  end
end