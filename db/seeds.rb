# frozen_string_literal: true

puts 'Seeding db'

user = User.create(username: 'example_user', email: 'example_user@example.ru', password: '123456')

budgets = Budget.create([{ date_from: Date.new(2020, 1, 1), date_to: Date.new(2020, 1, 31), user: user },
                         { date_from: Date.new(2020, 2, 1), date_to: Date.new(2020, 2, 29), user: user },
                         { date_from: Date.new(2020, 3, 1), date_to: Date.new(2020, 3, 31), user: user },
                         { date_from: Date.new(2020, 4, 1), date_to: Date.new(2020, 4, 30), user: user }])

categories = Category.create([{ name: 'Operation expense', operation_type: 'expense', user: user },
                              { name: 'Operation income', operation_type: 'income', user: user }])

payment_methods = PaymentMethod.create([{ name: 'Cash payment', is_cash: true, user: user },
                                        { name: 'Сashless payment', is_cash: false, user: user }])

Operation.create([
                   { date: budgets.last.date_from,
                     description: 'something',
                     category: categories.last,
                     payment_method: payment_methods.first,
                     amount: 100_000,
                     budget: budgets.last },

                   { date: budgets.last.date_from + 1.day,
                     description: 'something',
                     category: categories.first,
                     payment_method: payment_methods.first,
                     amount: 3_000,
                     budget: budgets.last },

                   { date: budgets.last.date_from + 2.day,
                     description: 'something',
                     category: categories.first,
                     payment_method: payment_methods.last,
                     amount: 4_000,
                     budget: budgets.last },

                   { date: budgets.last.date_from + 3.day,
                     description: 'something',
                     category: categories.first,
                     payment_method: payment_methods.last,
                     amount: 2_000,
                     budget: budgets.last },

                   { date: budgets.last.date_from + 4.day,
                     description: 'something',
                     category: categories.first,
                     payment_method: payment_methods.last,
                     amount: 6_000,
                     budget: budgets.last }
                 ])
