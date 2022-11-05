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

  let(:repo) {UserRepository.new}

  context "ALL method" do
    it "returns all users" do
      users = repo.all

      expect(users.length).to eq(3)
      expect(users.first.username).to eq('alastair123')
      expect(users.last.email).to eq('thanos@gmail.com')
    end
  end

  context "CREATE method" do
    it "creates a new user" do
      new_user = User.new
      new_user.username = 'family123'
      new_user.email = 'family@gmail.com'
      new_user.password = 'Password4444'

      repo.create(new_user)
      users = repo.all

      expect(users.length).to eq(4)
      expect(users.last.username).to eq('family123')
      expect(users.last.email).to eq('family@gmail.com')
      expect(users.last.password.length).to eq(60) # check if pw was encrypted
    end
  end

  context "FIND_BY_EMAIL method" do
    it "returns the thanos record" do
      
      user = repo.find_by_email('thanos@gmail.com')

      expect(user.id).to eq(3)
      expect(user.username).to eq('thanos123')
      expect(user.email).to eq('thanos@gmail.com')
      expect(user.password).to eq('Password333')
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