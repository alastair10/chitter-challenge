require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/database_connection'
require_relative 'lib/peep_repo'
require_relative 'lib/user_repo'


DatabaseConnection.connect

class Application < Sinatra::Base
  enable :sessions

  # This allows the app code to refresh w/o having to restart the server
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/peep_repo'
    also_reload 'lib/user_repo'
  end

  get '/create_account' do
    return erb(:create_account)
  end

  post '/create_account' do
    # invalid params check needed

    new_user = User.new
    new_user.username = params[:username]
    new_user.email = params[:email]
    new_user.password = params[:password]

    repo = UserRepository.new
    return erb(:email_already_exists) if repo.find_by_email(new_user.email) != nil

    repo.create(new_user)

    @email = params[:email]
    @username = params[:username]

    return erb(:create_account_success)

  end

  # Route to return to log in page
  get '/login' do
    return erb(:login)
  end

  # Route receives login info (email/pwd) as body params and finds user in db w/email 
  # If pwd matches, returns success page
  post '/login' do

    if invalid_logon_parameters?
      status 400
      return erb(:failed_logon_parameters)
    end

    email = params[:email]
    password = params[:password]

    user = UserRepository.new
  
    return erb(:email_not_found) if user.find_by_email(email).nil?

    if user.authentication(email, password)
      session[:user_id] = user.id
      return erb(:login_success)
    else
      return erb(:login_failure)
    end
  end

  get '/login_failure' do
    status 400
    return erb(:login_failure)
  end

  get '/email_not_found' do
    return erb(:email_not_found)
  end

  get '/email_already_exists' do
    return erb(:email_already_exists)
  end

  # "authenticated-only" route can be accessed only if a user signed-in (if we have user info in session).
  get '/account_page' do
    if session[:user_id] == nil
      # not logged in so no user in session
      return redirect('/login')
    else
      # user is logged in
      return erb(:account)
    end
  end

  get '/' do
    return erb(:index)
  end

  get '/peeps' do
    repo = PeepRepository.new
    @peeps = repo.all
    return erb(:peeps)
  end

  get '/peeps/new' do
    return erb(:new_peep)
  end

  post '/peeps' do

    if invalid_peep_parameters?
      status 400
      return erb(:failed_peep_post)
    end

    # gets the body parameters
    content = params[:title]
    tag = params[:tag]

    # create the post in the database
    repo = PeepRepository.new
    new_peep = Peep.new
    new_peep.content = params[:content]
    new_peep.tag = params[:tag]
    new_peep.timestamp = Time.new
    new_peep.user_id = 3
    repo.create(new_peep)

    @content = params[:content]
    @tag = params[:tag]

    # return a view to confirm form submission
    return erb(:peep_created)
  end

  private
  # checks for HTML tags, '<' beginnings, and blank comments. (tags can be blank)
  def invalid_peep_parameters?
    content = params[:content]
    tag = params[:tag]
    content.match(/<.+>/) || 
    content.start_with?('<') || 
    content == "" || 
    tag.match(/<.+>/) ||
    tag.start_with?('<') ? true : false
  end

  def invalid_logon_parameters?
    email = params[:email]
    password = params[:password]
    email.match(/<.+>/) || 
    email.start_with?('<') || 
    email == "" || 
    password.match(/<.+>/) ||
    password.start_with?('<') ||
    password == "" ? true : false
  end
end