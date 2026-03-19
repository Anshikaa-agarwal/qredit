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
CreditTransaction.delete_all
CreditPurchase.delete_all
Vote.delete_all
Comment.delete_all
Answer.delete_all
Question.delete_all
Topic.delete_all
User.delete_all

# create topics
topics = [
  "Environment",
  "Politics",
  "Literature",
  "Books",
  "Travel",
  "India",
  "Education",
  "Exams",
  "Career"
]

topics.map { |t| Topic.create!(name: t) }

# Create user
users = [
  {
    name: "Admin User",
    username: "admin",
    email: "admin@example.com",
    password: "password123",
    password_confirmation: "password123",
    role: 0,
    verified: true,
    confirmed_at: Time.current
  },
  {
    name: "John Doe",
    username: "johndoe",
    email: "john@example.com",
    password: "password123",
    password_confirmation: "password123",
    role: 1,
    verified: true,
    confirmed_at: Time.current
  },
  {
    name: "Jane Smith",
    username: "janesmith",
    email: "jane@example.com",
    password: "password123",
    password_confirmation: "password123",
    role: 1,
    verified: false,
    confirmed_at: Time.current
  },
  {
    name: "Alice Johnson",
    username: "alicejohnson",
    email: "alice@example.com",
    password: "password123",
    password_confirmation: "password123",
    role: 1,
    verified: true,
    confirmed_at: Time.current
  },
  {
    name: "Bob Brown",
    username: "bobbrown",
    email: "bob@example.com",
    password: "password123",
    password_confirmation: "password123",
    role: 1,
    verified: false,
    confirmed_at: Time.current
  }
]

users.each do |attrs|
  user = User.find_or_initialize_by(email: attrs[:email])
  user.assign_attributes(attrs)
  user.save!
end

puts "Seeded #{User.count} users."

# Create questions
question_records = [
  {
    title: "What are the main causes of climate change?",
    content: "I want to understand the major human and natural factors contributing to climate change.",
    user: User.find_by!(email: "john@example.com"),
    status: 0,
    posted_at: Time.current - 5.days,
    topics: [ "Environment" ]
  },
  {
    title: "How does the Indian Parliament function?",
    content: "Can someone explain the structure and role of Lok Sabha and Rajya Sabha in simple terms?",
    user: User.find_by!(email: "jane@example.com"),
    status: 0,
    posted_at: Time.current - 4.days,
    topics: [ "Politics", "India", "Education" ]
  },
  {
    title: "Which books should I read to improve my English literature knowledge?",
    content: "I am looking for beginner-friendly books and classics to better understand English literature.",
    user: User.find_by!(email: "alice@example.com"),
    status: 0,
    posted_at: Time.current - 3.days,
    topics: [ "Literature", "Books", "Education" ]
  },
  {
    title: "What are the best places to visit in North India during winter?",
    content: "I am planning a trip and would like suggestions for scenic and budget-friendly destinations.",
    user: User.find_by!(email: "bob@example.com"),
    status: 0,
    posted_at: Time.current - 2.days,
    topics: [ "Travel", "India" ]
  },
  {
    title: "How should I prepare for competitive exams effectively?",
    content: "I often lose consistency while studying. What strategies help with preparation and revision?",
    user: User.find_by!(email: "john@example.com"),
    status: 0,
    posted_at: Time.current - 1.day,
    topics: [ "Exams", "Education", "Career" ]
  },
  {
    title: "What is the difference between UPSC and SSC exams?",
    content: "I want to know the eligibility, syllabus, and career opportunities in both exams.",
    user: User.find_by!(email: "jane@example.com"),
    status: 0,
    posted_at: Time.current - 12.hours,
    topics: [ "Exams", "Career", "Education" ]
  },
  {
    title: "Why is environmental conservation important for future generations?",
    content: "Please explain the long-term benefits of protecting forests, rivers, and biodiversity.",
    user: User.find_by!(email: "alice@example.com"),
    status: 0,
    posted_at: Time.current - 8.hours,
    topics: [ "Environment", "Education" ]
  },
  {
    title: "How can I choose the right career path after graduation?",
    content: "I am confused between higher studies, government jobs, and private sector opportunities.",
    user: User.find_by!(email: "bob@example.com"),
    status: 0,
    posted_at: Time.current - 6.hours,
    topics: [ "Career", "Education" ]
  }
]

question_records.each do |attrs|
  topics = attrs.delete(:topics)

  question = Question.create!(
    title: attrs[:title],
    content: attrs[:content],
    user: attrs[:user],
    status: attrs[:status],
    posted_at: attrs[:posted_at]
  )

  topics.each do |topic_name|
    topic = Topic.find_by!(name: topic_name)
    TopicAssignement.find_or_create_by!(
      topic: topic,
      topicable: question
    )
  end

  Question.update_all(status: 1)
end

puts "Seeded #{Question.count} questions."
