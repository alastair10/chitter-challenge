require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # Used to rack-test helper methods.
  include Rack::Test::Methods

  # Need to declare the `app` value by instantiating the Application class so the tests work.
  let(:app) { Application.new }

  context 'GET /log in' do
    it "responds with 400 status - email not found" do
      response = get('/email_not_found')
      
      expect(response.status).to eq(400)
      expect(response.body).to include("<h1>Email not found.</h1>")
      expect(response.body).to include("<p>Uh oh, looks like you haven't signed up to Chitter yet.</p>")
      expect(response.body).to include("<p><a href='/sign_up'>Sign up here!</a></p>")
    end
  end

  context "GET to /" do
    it "returns 200 OK with correct content" do
      # Send a GET request to /
      # and returns a response object we can test.
      response = get("/")

      # Assert the response status code and body.
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Welcome to Chitter!</h1>')
      expect(response.body).to include('<h2>New here?</h2>')
      expect(response.body).to include('<div>Sign up</div>')
      expect(response.body).to include('<div>Sign in</div>')

      expect(response.body).to include('<a href="/peeps">Show me what everyone is talking about.</a></h2>')
    end
  end

  context 'GET /peeps' do
    it "returns a list of peeps" do
      response = get('/peeps')
      expect(response.status).to eq(200)
      expect(response.body).to include('everyone is using chitter')
      expect(response.body).to include('I like burritos')
    end
  end

  context "GET /peeps/new" do
    it "returns the form page for posting a peep" do
      response = get('/peeps/new')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Add a peep</h1>')
      # Check we have the correct form tag w/the action and method
      expect(response.body).to include('<form method="POST" action="/peeps">')

      # We can assert more things, like having
      # the right HTML form inputs, etc.

    end
  end

  context "POST /peeps" do
    it "returns a success page for posting a peep" do
      response = post('/peeps', content: 'Hello world', tag: '@world')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h3>Your peep has been added: </h3>')
      expect(response.body).to include('Hello world')
      expect(response.body).to include('@world')
    end
    
    it "returns a success page if tag is empty" do
      response = post('/peeps', content: 'Hello world', tag: '')
      expect(response.body).to include('<h3>Your peep has been added: </h3>')
      expect(response.body).to include('Hello world')
    end

    it "responds with 400 status if content is invalid" do
      response = post('/peeps', content: '<script>', tag: '@world')
      expect(response.status).to eq(400)
      expect(response.body).to include('<h1>Invalid input.</h1>')
    end

    it "responds with 400 status if comments starts with <" do
      response = post('/peeps', content: '<a', tag: '@world')
      expect(response.status).to eq(400)
      expect(response.body).to include('<h1>Invalid input.</h1>')
    end

    it "responds with 400 status if content is blank" do
      response = post('/peeps', content: '', tag: '@world')
      expect(response.status).to eq(400)
      expect(response.body).to include('<h1>Invalid input.</h1>')
    end
  end

    context 'GET /log in' do
      it "responds with 400 status - email not found" do

      end
    end




end