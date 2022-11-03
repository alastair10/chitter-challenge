require 'user_repo' 

def reset_users_table
  seed_sql = File.read('spec/seeds/seed.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter_app_test' })
  connection.exec(seed_sql)
end

describe UserRepository do
  before(:each) do 
    reset_users_table
  end

  context "ALL method" do
    it "returns all users" do
      
      repo = UserRepository.new

      users = repo.all

      expect(users.length).to eq(3)
      expect(users.first.username).to eq('alastair123')
      expect(users.last.email).to eq('thanos@gmail.com')
    end
  end

  context "CREATE method" do
    it "creates a new user" do

      repo = UserRepository.new

      new_user = User.new
      new_user.username = 'family123'
      new_user.email = 'family@gmail.com'
      new_user.password = 'Password4444'

      repo.create(new_user)

      users = repo.all

      expect(users.length).to eq(4)
      expect(users.last.username).to eq('family123')
      expect(users.last.email).to eq('family@gmail.com')
      expect(users.last.password).to eq('Password4444')

    end
  end

# # 2
# # Get a single peep using a tag

# repo = UserRepository.new

# user = repo.find('gunel123')

# expect(user.id).to eq(2)
# expect(user.username).to eq('gunel123')
# expect(user.email).to eq('gunel@gmail.com')





end