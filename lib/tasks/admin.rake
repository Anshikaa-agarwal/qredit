namespace :admin do
  desc "Create a new admin."
  task new: :environment do
    puts "Creating a new admin."

    print "Name: "
    name = STDIN.gets.chomp

    print "Email: "
    email = STDIN.gets.chomp

    print "Password (min 6 chars): "
    password = STDIN.gets.chomp
    puts

    if name.to_s.empty? || email.to_s.empty? || password.length < 6
      puts "Name, email and password (min 6 chars) are required."
      exit(1)
    end

    if User.exists?(email: email)
      puts "User with email #{email} already exists."
      exit(1)
    end

    user = User.new(name: name, email: email, password: password, role: :admin)
    user.confirmed_at = Time.current
    user.verified = true
    user.auth_token = SecureRandom.hex(20)

    if user.save
      puts "Admin with email:#{user.email} created."
    else
      puts "Failed to create admin user."
      puts user.errors.full_messages
      exit(1)
    end
  end
end
