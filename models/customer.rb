require_relative("../db/sql_runner")

class Customer

  attr_accessor :name, :funds
  attr_reader :id

  def initialize(details)
    @name = details['name']
    @funds = details['funds'].to_i
    @id = details['id'].to_i if details['id']
  end

  def save
    sql = "INSERT INTO customers (name, funds)
          VALUES ($1, $2)
          RETURNING id"
    values = [@name, @funds]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def self.all
    sql = "SELECT * FROM customers"
    SqlRunner.run(sql)
  end

  def update
    sql = "UPDATE customers
          SET (name, funds) = ($1, $2)
          WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

  def films
    sql = "SELECT films.*
          FROM films
          INNER JOIN tickets
          ON tickets.film_id = films.id
          WHERE customer_id = $1"
    values = [@id]
    return SqlRunner.run(sql, values).map {
      |film| Film.new(film)
    }
  end

  def tickets
    sql = "SELECT tickets.*
          FROM tickets
          WHERE customer_id = $1"
    values = [@id]
    return SqlRunner.run(sql, values).map {
      |ticket| Ticket.new(ticket)
    }
  end

  def ticket_count
    return tickets().count
  end

end
