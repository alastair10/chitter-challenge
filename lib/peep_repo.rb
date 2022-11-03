class PeepRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    SELECT id, content, timestamp, tag, user_id FROM peeps;

    # Returns an array of Student objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(tag)
    # Executes the SQL query:
    # SELECT id, name, cohort_name FROM students WHERE id = $1;
    SELECT id, content, timestamp, tag, user_id FROM peeps WHERE tag LIKE '%$1%';
    # Returns a single Student object.
  end

  # Add more methods below for each operation you'd like to implement.

  def create(student)
    # Executes the SQL query:
    INSERT INTO peeps (content, timestamp, tag, user_id) VALUES ($1, $2, $3, $4);
  end

  # def update(student)
  # end

  # def delete(student)
  # end
end