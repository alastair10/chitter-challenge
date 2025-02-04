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

    it "returns nil if email is not in db" do
      user = repo.find_by_email('new-email@gmail.com')
      expect(user).to eq(nil)
    end
  end



  context "AUTHENTICATION method" do
    it "signs in the user with correct credentials" do
      new_user = User.new
      new_user.username = 'family123'
      new_user.email = 'family@gmail.com'
      new_user.password = 'Password4444'

      repo.create(new_user)
      result = repo.authentication('family@gmail.com', 'Password4444')
      expect(result).to eq(true)
    end
    
    it "signs in the user with other correct credentials" do
      new_user = User.new
      new_user.username = 'new22'
      new_user.email = 'new22'
      new_user.password = 'Password'

      repo.create(new_user)
      result = repo.authentication('new22', 'Password')
      expect(result).to eq(true)
    end

    it "rejects user that submits incorrect password" do
      new_user = User.new
      new_user.username = 'family123'
      new_user.email = 'family@gmail.com'
      new_user.password = 'Password4444'

      repo.create(new_user)
      result = repo.authentication('family@gmail.com', 'Password4441')
      expect(result).to eq(false)
    end

    it "rejects user that submits incorrect password" do
      new_user = User.new
      new_user.username = 'family123'
      new_user.email = 'family@gmail.com'
      new_user.password = 'Password4444'

      repo.create(new_user)
      result = repo.authentication('family@gmail.com', 'Password4441')
      expect(result).to eq(false)

    end
  end

  context "FIND_BY_ID method" do
    it "returns the username for peep id = 1" do
      user = repo.find_by_id(1)
      expect(user.username).to eq('alastair123')
    end
  end

  context "FIND_BY_ID method" do
    it "returns the username for peep id = 3" do
      user = repo.find_by_id(3)
      expect(user.username).to eq('thanos123')
    end
  end

  context "find_all_with_id method test to get all info related to user" do
    it "returns user information about JOIN" do
      user = repo.find_all_with_id(2)
      expect(user.username).to eq('gunel123')
    end
    
    it "returns info for the first peep from JOIN method" do
      user = repo.find_all_with_id(3)
      expect(user.peeps.first.tag).to eq('@cat')
    end

    it "returns info for the second peep from JOIN method" do
      user = repo.find_all_with_id(3)
      expect(user.peeps.length).to eq(2)
      expect(user.peeps.last.content).to eq('everyone is using chitter')
    end
  end
end