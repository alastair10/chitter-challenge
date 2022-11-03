# USERS Model and Repository Classes Design Recipe

## 1. Design and create the Table

## 2. Create Test SQL seeds

## 3. Define the class names

```ruby
# EXAMPLE
# Table name: students

# Model class
# (in lib/student.rb)
class User
end

# Repository class
# (in lib/student_repository.rb)
class UserRepository
end

## 4. Implement the Model class

class User
  attr_accessor :id, :username, :email
end

```
## 5. Define the Repository Class interface

```ruby

class UserRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    SELECT id, username, email FROM users;

    # Returns an array of Student objects.
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
    INSERT INTO users (username, email) VALUES ($1, $2);
  end

  # def update(student)
  # end

  # def delete(student)
  # end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all peeps

repo = UserRepository.new

users = repo.all

expect(users.length).to eq(3)
expect(users.first.username).to eq('alastair123')
expect(users.last.email).to eq('thanos@gmail.com')

# 2
# Get a single peep using a tag

repo = UserRepository.new

user = repo.find('gunel123')

expect(user.id).to eq(2)
expect(user.username).to eq('gunel123')
expect(user.email).to eq('gunel@gmail.com')

# 3
# Create a peep

repo = UserRepository.new

new_user = User.new
new_user.username = 'family123'
new_user.email = 'family@gmail.com'

repo.create(new_user)

users = repo.all

expect(users.length).to eq(4)
expect(users.last.username).to eq('family123')
expect(users.last.email).to eq('family@gmail.com')

```

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/student_repository_spec.rb

def reset_users_table
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter_app_test' })
  connection.exec(seed_sql)
end

describe UserRepository do
  before(:each) do 
    reset_users_table
  end

  # (tests go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

