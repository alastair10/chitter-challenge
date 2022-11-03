require 'user'

class UserRepository

  # Selecting all records
  # No arguments
  def all
    
    users = []
    # Executes the SQL query:
    sql = 'SELECT id, username, email, password FROM users;'
    result_set = DatabaseConnection.exec_params(sql, [])

    result_set.each do |record|
      user = User.new
      user.id = record['id']
      user.username = record['username']
      user.email = record['email']
      user.password = record['password']

      users << user
    end

    # Returns an array of Student objects.
    return users
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  # def find(id)
  #   # Executes the SQL query:
  #   SELECT id, username, email FROM users WHERE id = '$1';
  #   # Returns a single Student object.
  # end

  # Add more methods below for each operation you'd like to implement.

  def create(user)
    # Executes the SQL query:
    sql = 'INSERT INTO users (username, email, password) VALUES ($1, $2, $3);'
    sql_params = [user.username, user.email, user.password]

    result_set = DatabaseConnection.exec_params(sql,sql_params)
  end

  # def update(student)
  # end

  # def delete(student)
  # end
end