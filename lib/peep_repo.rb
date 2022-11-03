require 'peep'

class PeepRepository

  # Selecting all records
  # No arguments
  def all
    
    peeps = []
    
    # Executes the SQL query:
    sql = "SELECT id, content, timestamp, tag, user_id FROM peeps;"
    result_set = DatabaseConnection.exec_params(sql,[])

    result_set.each do |record|
      peep = Peep.new
      peep.id = record['id'].to_i
      peep.content = record['content']
      peep.timestamp = record['timestamp']
      peep.tag = record['tag']
      peep.user_id = record['user_id'].to_i

      peeps << peep

    end

    # Returns an array of Peep objects.
    return peeps
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(tag)
    # Executes the SQL query:
    # SELECT id, name, cohort_name FROM students WHERE id = $1;
    sql = "SELECT id, content, timestamp, tag, user_id FROM peeps WHERE tag LIKE '%$1%';"
    # Returns a single Student object.
  end

  # Add more methods below for each operation you'd like to implement.

  def create(peep)
    # Executes the SQL query:
    sql = "INSERT INTO peeps (content, timestamp, tag, user_id) VALUES ($1, $2, $3, $4);"
    sql_params = [peep.content, peep.timestamp, peep.tag, peep.user_id]

    DatabaseConnection.exec_params(sql, sql_params)
  end

  # def update(student)
  # end

  # def delete(student)
  # end
end