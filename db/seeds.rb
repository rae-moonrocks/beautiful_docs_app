# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
admin_user = User.first_or_create!(email: 'rachel@moonrocks.dev', password: 'password', password_confirmation: 'password', role: 1)

if Doorkeeper::Application.count.zero?
  Doorkeeper::Application.create!(name: 'Moonrocks - web', redirect_uri: '', scopes: '', owner_id: admin_user.id, owner_type: 'User')
  Doorkeeper::Application.create!(name: 'Moonrocks - ios', redirect_uri: '', scopes: '', owner_id: admin_user.id, owner_type: 'User')
end



load File.join(File.dirname(__FILE__), 'seeds', 'documents.rb')
