require_relative('models/customer')
require_relative('models/film')
require_relative('models/screening')
require_relative('models/ticket')

require('pry')

Customer.delete_all
Film.delete_all
Screening.delete_all
Ticket.delete_all

customer1 = Customer.new({
  'name' => 'Bob',
  'funds' => 10
  })
  customer1.save()

customer2 = Customer.new({
  'name' => 'Alice',
  'funds' => 5
  })
  customer2.save()

customer3 = Customer.new({
  'name' => 'Wendy',
  'funds' => 2
  })
  customer3.save()

customer4 = Customer.new({
  'name' => 'Wilhelm',
  'funds' => 5
  })
  customer4.save()

film1 = Film.new({
  'title' => 'Pulp Fiction',
  'price' => 5
  })
  film1.save()

film2 = Film.new({
  'title' => 'Predator 2',
  'price' => 5
  })
  film2.save()

screening1 = Screening.new({
  'time' => '19:00',
  'capacity' => 2
  })
  screening1.save()

screening2 = Screening.new({
  'time' => '23:00',
  'capacity' => 2
  })
  screening2.save()

ticket1 = Ticket.sell(customer1, film1, screening1)
ticket2 = Ticket.sell(customer1, film2, screening2)
ticket3 = Ticket.sell(customer2, film2, screening2)
ticket4 = Ticket.sell(customer3, film1, screening1) # should fail
ticket5 = Ticket.sell(customer4, film2, screening2) # should fail

# Screening.most_popular()

binding.pry
nil
