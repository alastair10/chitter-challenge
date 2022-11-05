require 'bcrypt'
require_relative 'user'

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
    # Encrypt the password to save it into the new database record.
    encrypted_password = BCrypt::Password.create(user.password)

    sql = 'INSERT INTO users (username, email, password) VALUES ($1, $2, $3);'
    sql_params = [user.username, user.email, encrypted_password]

    result_set = DatabaseConnection.exec_params(sql,sql_params)
  end

  def sign_in(email, submitted_password)
    user = find_by_email(email)

    return nil if user.nil?

    # Compare the submitted pwd with the encrypted one in the db
    if submitted_password == BCrypt::Password.new(user.password)
      # correct password
    else
      # wrong password
    end
  end

  def find_by_email(email)
    
    sql = 'SELECT id, username, email, password FROM users WHERE email = $1;'
    result_set = DatabaseConnection.exec_params(sql, [email])

    return nil if result_set.values.empty?

    user = User.new
    user.id = result_set[0]['id'].to_i
    user.username = result_set[0]['username']
    user.email = result_set[0]['email']
    user.password = result_set[0]['password']

    return user

  end

    # def update(student)
    # end

    # def delete(student)
    # end
end