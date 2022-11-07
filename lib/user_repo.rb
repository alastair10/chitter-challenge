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
    sql = 'SELECT * FROM users WHERE id = $1;'
    result_set = DatabaseConnection.exec_params(sql, [user_id])

    user = User.new
    user.id = result_set.first['id'].to_i
    user.username = result_set.first['username']
    user.email = result_set.first['email']
    user.password = result_set.first['password']
    
    return user
    
  end


  def find_all_with_id
    sql = 'SELECT users.id, users.username, users.email, users.password, peeps.id, peeps.content, peeps.timestamp, peeps.tag
    FROM users
    JOIN peeps on peeps.user_id = users.id;'
    result_set = DatabaseConnection.exec_params(sql,[])

    user = User.new
    user.id = result_set.first['id'].to_i
    user.username = result_set.first['username']
    user.email = result_set.first['email']
    user.password = result_set.first['password']

    result_set.each do |record|
      peep = Peep.new
      peep.id = record['id']
      peep.content = record['content']
      peep.timestamp = record['timestamp']
      peep.tag = record['tag']

      user.peeps << peep
    end

    return user
  end
end