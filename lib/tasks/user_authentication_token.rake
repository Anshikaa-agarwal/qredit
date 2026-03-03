namespace :user_authentication_token do
  desc "Create authentication token for verified user."

  task create: :environment do
    puts "Generating authetication token."

    print "Enter email: "
    email = STDIN.gets.chomp

    user = User.find_by(email: email)

    unless user
      puts "No user with email: #{email} exists."
      exit(1)
    end

    unless user.verified?
      puts "User: #{email} not verified. Exiting."
      exit(1)
    end

    if user.auth_token.present?
      puts "Authentication token for #{user.email} already exists."
      puts "It can be accessed on profile page."
      exit(0)
    end

    user.auth_token = SecureRandom.hex(20)

    if user.save
      puts "Authentication token successfully generated."
      puts "It can be accessed on profile page."
    else
      puts "Failed to create authentication token."
      exit(1)
    end
  end
end
