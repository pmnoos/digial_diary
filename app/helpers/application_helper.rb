module ApplicationHelper
  def thought_of_the_day(mood: nil)
    scope = mood.present? ? Thought.where(mood: mood) : Thought.all
    return "No thoughts available" if scope.empty?

    index = Date.today.yday % scope.count
    scope.offset(index).first.content
  end
end
