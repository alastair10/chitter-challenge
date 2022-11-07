require 'sinatra/base'
require 'sinatra/flash'
require 'sinatra/reloader'
require_relative 'lib/database_connection'
require_relative 'lib/peep_repo'
require_relative 'lib/user_repo'
require_relative 'lib/user'

DatabaseConnection.connect

class Application < Sinatra::Base
  enable :sessions

  # This allows the app code to refresh w/o having to restart the server
  configure :development do
    register Sinatra::Flash
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

    #session[:user_id] = user.id
    
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

    repo = UserRepository.new
    found_user = repo.find_by_email(params[:email])
    

    if found_user.nil?
      return erb(:email_not_found)
    elsif repo.authentication(params[:email], params[:password])
      @username = found_user.username
      @user_id = found_user.id
      @session_id = found_user.id
      session[:user_id] = found_user.id
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

  get '/' do
    return erb(:index)
  end

  get '/peeps' do
    repo = PeepRepository.new
    @peeps = repo.all
    
    if session[:user_id] == nil
      return erb(:peeps)
    else
      return erb(:session_peeps)
    end
  end

  get '/peeps/new' do
    if session[:user_id] == nil
      return erb(:login)
    else
      return erb(:new_peep)
    end
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
    new_peep.user_id = session[:user_id]
    repo.create(new_peep)

    @content = params[:content]
    @tag = params[:tag]

    # return a view to confirm form submission
    return erb(:peep_created)
  end


  get '/session/logout' do
    session.clear
    flash[:notice] = "You have signed out."
    redirect '/'
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