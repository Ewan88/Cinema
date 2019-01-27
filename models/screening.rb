require_relative("../db/sql_runner")

require('pry')

class Screening

  attr_accessor :time, :capacity
  attr_reader :id

  def initialize(details)
    @time = details['time']
    @capacity = details['capacity'].to_i
    @id = details['id'].to_i if details['id']
  end

  def save
    sql = "INSERT INTO screenings (time, capacity)
          VALUES ($1, $2)
          RETURNING id"
    values = [@time, @capacity]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def self.all
    sql = "SELECT * FROM screenings"
    SqlRunner.run(sql)
  end

  def update
    sql = "UPDATE screenings
          SET (time, capacity) = ($1, $2)
          WHERE id = $3"
    values = [@time, @capacity, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM screenings WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)
  end

  def films
    sql = "SELECT films.*
          FROM films
          INNER JOIN tickets
          ON tickets.film_id = films.id
          WHERE film_id = $1"
    values = [@id]
    return SqlRunner.run(sql, values).map {
      |film| Film.new(film)
    }
  end

  def tickets
    sql = "SELECT tickets.*
          FROM tickets
          WHERE screening_id = $1"
    values = [@id]
    return SqlRunner.run(sql, values).map {
      |screening| Ticket.new(screening)
    }
  end

  def self.most_popular
    tickets = self.all.map {
      |screening| Screening.new(screening).tickets
    }
    tickets.sort! {
      |ticket| ticket.length
    }
    return tickets[0][0].screening
  end

end
