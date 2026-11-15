namespace :admin do
  desc "Create or update an admin user (prompts for email and password, or reads ADMIN_EMAIL / ADMIN_PASSWORD)"
  task create: :environment do
    require "io/console"

    email = ENV["ADMIN_EMAIL"].presence || begin
      print "Admin email: "
      $stdin.gets.to_s.strip
    end
    password = ENV["ADMIN_PASSWORD"].presence || begin
      print "Password (min 12 chars): "
      $stdin.noecho(&:gets).to_s.strip.tap { puts }
    end

    abort "Password must be at least 12 characters." if password.length < 12 && Rails.env.production?

    user = User.find_or_initialize_by(email_address: email)
    user.update!(password: password)
    puts "#{user.previously_new_record? ? "Created" : "Updated"} admin #{user.email_address}"
  end
end
