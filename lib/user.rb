class User
  attr_accessor :id, :username, :email, :password, :peeps

  def initialize
    @peeps = []
  end
end