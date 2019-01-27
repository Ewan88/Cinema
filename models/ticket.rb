require_relative("../db/sql_runner")

require ('pry')

class Ticket

  attr_reader :customer_id, :film_id, :screening_id, :id

  def initialize(details)
    @customer_id = details['customer_id'].to_i
    @film_id = details['film_id'].to_i
    @screening_id = details['screening_id'].to_i
    @id = details['id'].to_i if details['id']
  end

  def save
    sql = "INSERT INTO tickets (customer_id, film_id, screening_id)
          VALUES ($1, $2, $3)
          RETURNING id"
    values = [@customer_id, @film_id, @screening_id]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def self.all
    sql = "SELECT * FROM tickets"
    SqlRunner.run(sql)
  end

  def update
    sql = "UPDATE tickets
          SET (customer_id, film_id, screening_id) = ($1, $2, $3)
          WHERE id = $4"
    values = [@customer_id, @film_id, @screening_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM tickets WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

  def customer
    sql = "SELECT * FROM customers WHERE id = $1"
    values = [@customer_id]
    return Customer.new(SqlRunner.run(sql, values).first)
  end

  def film
    sql = "SELECT * FROM films WHERE id = $1"
    values = [@film_id]
    return Film.new(SqlRunner.run(sql, values).first)
  end

  def screening
    sql = "SELECT * FROM screenings WHERE id = $1"
    values = [@screening_id]
    return Screening.new(SqlRunner.run(sql, values).first)
  end

  def self.sell(customer, film, screening)
    if customer.funds >= film.price
      if screening.capacity > screening.tickets.length
        customer.funds -= film.price
        ticket = Ticket.new({
          'customer_id' => customer.id,
          'film_id' => film.id,
          'screening_id' => screening.id
          })
          customer.update
          ticket.save
          return ticket
        end
      end
    end

end
