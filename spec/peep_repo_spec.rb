require 'peep_repo'
require 'peep'

def reset_peeps_table
  seed_sql = File.read('spec/seeds/seed.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter_app_test' })
  connection.exec(seed_sql)
end

describe PeepRepository do
  before(:each) do 
    reset_peeps_table
  end

  context "ALL method" do
    it "returns all peeps" do
      repo = PeepRepository.new

      peeps = repo.all
    
      expect(peeps.length).to eq(4)
      expect(peeps.first.content).to eq('alastair is amazing')
      expect(peeps.last.tag).to eq('@makers')
    end
  end

  context "CREATE method" do
    it "adds a new peep" do
      repo = PeepRepository.new

      new_peep = Peep.new
      new_peep.content = 'NewPostTest'
      new_peep.timestamp = '2024-04-04 13:35:06'
      new_peep.tag = '@gunel'
      new_peep.user_id = 2

      repo.create(new_peep)

      peeps = repo.all

      expect(peeps.length).to eq(5)
      expect(peeps.last.content).to eq('NewPostTest')
      expect(peeps.last.timestamp).to eq('2024-04-04 13:35:06')
      expect(peeps.last.tag).to eq('@gunel')
      expect(peeps.last.user_id).to eq(2)
    end
  end

  # context "FIND method" do
  #   it "returns a single post with the @cat tag" do
  #     repo = PeepRepository.new

  #     peep = repo.find('@makers')
      
  #     expect(peep.id).to eq(3)
  #     expect(peep.content).to eq('thanos is amazing')
  #     expect(peep.tag).to eq('@cat@alastair@gunel')
  #     expect(peep.user_id).to eq(3)
  #   end
  # end
end