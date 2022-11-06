require 'bcrypt'
require_relative 'user'

class UserRepository

  def all
    users = []
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

    return users # => array of User objects
  end

  def create(user)
    encrypted_password = BCrypt::Password.create(user.password) # Encrypts password

    sql = 'INSERT INTO users (username, email, password) VALUES ($1, $2, $3);'
    sql_params = [user.username, user.email, encrypted_password]
    result_set = DatabaseConnection.exec_params(sql,sql_params)
  end

  def authentication(email, submitted_password)
    user = find_by_email(email)
    
    decrypted = BCrypt::Password.new(user.password)
    
    if decrypted == submitted_password
      return true
    else
      return false

    end
  end

  def find_by_email(email)
    
    sql = 'SELECT id, username, email, password FROM users WHERE email = $1;'
    result_set = DatabaseConnection.exec_params(sql, [email])

    if result_set.values.empty?
      return nil 
    else
      user = User.new
      user.id = result_set[0]['id'].to_i
      user.username = result_set[0]['username']
      user.email = result_set[0]['email']
      user.password = result_set[0]['password']

      return user
    end
  end

  def find_by_id(user_id)
    sql = 'SELECT username, email, password FROM users WHERE id = $1;'
    result_set = DatabaseConnection.exec_params(sql, [user_id])

    user = User.new
    user.id = result_set[0]['id'].to_i
    user.username = result_set[0]['username']
    user.email = result_set[0]['email']
    user.password = result_set[0]['password']

    return user
  end
end