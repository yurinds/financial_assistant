# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(username: 'example', email: 'example@example.ru', password: '123456')

Budget.create([date_from: Date.new(2020, 1, 1), date_to: Date.new(2020, 1, 31), user: User.first,
               date_from: Date.new(2020, 2, 1), date_to: Date.new(2020, 2, 29), user: User.first,
               date_from: Date.new(2020, 3, 1), date_to: Date.new(2020, 3, 31), user: User.first])
