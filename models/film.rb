require_relative("../db/sql_runner")

class Film

  attr_accessor :title, :price
  attr_reader :id

  def initialize(details)
    @title = details['title']
    @price = details['price'].to_i
    @id = details['id'].to_i if details['id']
  end

  def save
    sql = "INSERT INTO films (title, price)
          VALUES ($1, $2)
          RETURNING id"
    values = [@title, @price]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def self.all
    sql = "SELECT * FROM films"
    SqlRunner.run(sql)
  end

  def update
    sql = "UPDATE films
          SET (name, funds) = ($1, $2)
          WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM films WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

  def customers
    sql = "SELECT customers.*
          FROM customers
          INNER JOIN tickets
          ON tickets.customer_id = customers.id
          WHERE film_id = $1
          ORDER BY customers.name"
    values = [@id]
    return SqlRunner.run(sql, values).map {
      |customer| Customer.new(customer)
    }
  end

  def customer_count
    return customers().length
  end

  def screenings
    sql = "SELECT screenings.*
          FROM screenings
          INNER JOIN tickets
          ON tickets.screening_id = screenings.id
          WHERE film_id = $1"
    values = [@id]
    screenings = SqlRunner.run(sql, values).map {
      |screening| Screening.new(screening)
    }
    return screenings.uniq {
      |screening| screening.id
    }
  end

  def screening_count
    return screenings().length
  end

  def tickets
    sql = "SELECT tickets.*
          FROM tickets
          WHERE film_id = $1"
    values = [@id]
    return SqlRunner.run(sql, values).map {
      |ticket| Ticket.new(ticket)
    }
  end

  def sold
    return tickets().length
  end

end
