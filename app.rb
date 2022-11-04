require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/database_connection'
require_relative 'lib/peep_repo'

DatabaseConnection.connect

class Application < Sinatra::Base
  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/peep_repo'
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


    # return a view to confirm form submission
    return erb(:peep_created)

  end
end