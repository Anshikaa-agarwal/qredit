# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Clear old data
Answer.delete_all
Question.delete_all
Topic.delete_all
User.delete_all

# Create users
users = [
  { name: "Alice Johnson", email: "alice@example.com" },
  { name: "Bob Smith", email: "bob@example.com" },
  { name: "Charlie Lee", email: "charlie@example.com" },
  { name: "David Kumar", email: "david@example.com" },
  { name: "Emma Brown", email: "emma@example.com" }
]

users = users.map do |u|
  User.create!(
    name: u[:name],
    email: u[:email],
    password: "password123",
    confirmed_at: Time.now
  )
end

# Create topics
topics = [
  "Ruby on Rails",
  "Programming",
  "Web Development",
  "JavaScript",
  "Databases"
]

topics = topics.map { |t| Topic.create!(name: t) }

# Create questions
questions = [
  {
    title: "What is Ruby on Rails?",
    content: "Can someone explain what Rails is used for?"
  },
  {
    title: "How does MVC work?",
    content: "I want to understand MVC architecture in web frameworks."
  },
  {
    title: "What is REST API?",
    content: "What does REST mean and why is it important?"
  },
  {
    title: "Best way to learn Ruby?",
    content: "Any good resources for beginners?"
  },
  {
    title: "How to deploy Rails apps?",
    content: "Which platforms support free Rails deployment?"
  }
]

questions = questions.map do |q|
  Question.create!(
    title: q[:title],
    content: q[:content],
    user: users.sample,
    status: 0,
    posted_at: Time.now
  )
end

# Create answers
answers = [
  "Ruby on Rails is a web framework written in Ruby that follows MVC architecture.",
  "MVC stands for Model View Controller. It separates application logic.",
  "REST is an architectural style used for building APIs.",
  "The best way to learn Ruby is by building small projects.",
  "You can deploy Rails apps on platforms like Render or Fly.io."
]

questions.each do |question|
  2.times do
    Answer.create!(
      content: answers.sample,
      user: users.sample,
      question: question,
      status: 1
    )
  end
end

puts "Seed data created successfully!"
