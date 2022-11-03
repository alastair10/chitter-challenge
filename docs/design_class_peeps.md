# PEEPS Model and Repository Classes Design Recipe

## 1. Design and create the Table

## 2. Create Test SQL seeds

## 3. Define the class names


```ruby
# EXAMPLE
# Table name: students

# Model class
# (in lib/student.rb)
class Peep
end

# Repository class
# (in lib/student_repository.rb)
class PeepRepository
end

## 4. Implement the Model class

class Peep
  attr_accessor :id, :content, :timestamp, :tag, :user_id
end

```
## 5. Define the Repository Class interface

```ruby

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
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all peeps

repo = PeepRepository.new

peeps = repo.all

expect(peeps.length).to eq(4)
expect(peeps.first.content).to eq('alastair is amazing')
expect(peeps.last.tag).to eq('#life#makers')

# 2
# Get a single peep using a tag

repo = PeepRepository.new

peep = repo.find('#cat')

expect(peep.id).to eq(3)
expect(peep.content).to eq('thanos is amazing')
expect(peep.tag).to eq('#cat#catspeak')
expect(peep.user_id).to eq(3)

# Get multiple peeps using a tag

repo = PeepRepository.new

peep = repo.find('#life')
peeps = repo.all

expect(peeps.length).to eq(3)
expect(peeps.first.content).to eq('alastair is amazing')
expect(peeps.last.content).to eq('everyone is amazing')
expect(peep.first.timestamp).to eq(2022-01-08 04:05:06)
expect(peep.last.timestamp).to eq(2022-01-08 07:05:06)


# 3
# Create a peep

repo = PeepRepository.new

new_peep = Peep.new
new_peep.content = 'NewPostTest'
new_peep.timestamp = 2024-04-04 13:35:06
new_peep.tag = '#time'
new_peep.user_id = 2

peep.create(new_peep)

peeps = repo.all

expect(peeps.length).to eq(5)
expect(peeps.last.content).to eq('NewPostTest')
expect(peeps.last.timestamp).to eq(2024-04-04 13:35:06)
expect(peeps.last.tag).to eq('#time')
expect(peeps.last.user_id).to eq(2)

```

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/student_repository_spec.rb

def reset_peeps_table
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter_app_test' })
  connection.exec(seed_sql)
end

describe PeepRepository do
  before(:each) do 
    reset_peeps_table
  end

  # (tests go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

