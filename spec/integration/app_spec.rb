require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # Used to rack-test helper methods.
  include Rack::Test::Methods

  # Need to declare the `app` value by instantiating the Application class so the tests work.
  let(:app) { Application.new }

  context 'GET /email_not_found' do
    it "responds with email not found" do
      response = get('/email_not_found')
      
      expect(response.status).to eq(200)
      expect(response.body).to include("<h1>Email not found.</h1>")
      expect(response.body).to include("<p>It looks like you haven't signed up to Chitter yet.</p>")
      expect(response.body).to include("<p><a href='/create_account'>Sign up here!</a></p>")
    end
  end

  context "GET /" do
    it "returns 200 OK with correct content" do
      response = get("/")

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Welcome to Chitter!</h1>')
      expect(response.body).to include('<h2>New here?</h2>')
      expect(response.body).to include('<a href="/create_account">Create an account</a>')
      expect(response.body).to include('<div><a href="/login">Sign in</a></div>')
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

  # need to adjust for sessions
  context "GET /peeps/new" do
    it "returns the sign in page without proper user_id" do
      response = get('/peeps/new')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Sign in</h1>')
      expect(response.body).to include('<label>Password: </label>')
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

    it "responds with 400 status if tag starts with <" do
      response = post('/peeps', content: 'blah', tag: '<a')
      expect(response.status).to eq(400)
      expect(response.body).to include('<h1>Invalid input.</h1>')
    end
  end

  context 'GET /login' do
    it "returns 200 OK with correct content" do
      response = get('/login')
      expect(response.status).to eq(200)
      expect(response.body).to include('<label>Email: </label>')
      expect(response.body).to include('<input type="text" name="password" />')
      expect(response.body).to include("<a href='/''>Nevermind, go back.</a>")
    end
  end

  context "POST /login" do
    it "returns a failure page for email entered that isn't in db" do
      response = post('/login', email: 'wrong', password: 'Password3333')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Email not found.</h1>')
      expect(response.body).to include("<p>It looks like you haven't signed up to Chitter yet.</p>")
    end

    it "returns an invalid input message when email field is blank" do
      response = post('/login', email:'', password: 'Password3333')
      expect(response.status).to eq(400)
      expect(response.body).to include('<h1>Invalid input.</h1>')
    end

    it "returns an invalid input message when password field is blank" do
      response = post('/login', email: 'wrong', password: '')
      expect(response.status).to eq(400)
      expect(response.body).to include('<h1>Invalid input.</h1>')
    end

    it "returns an invalid input message when HTML script is entered into the email field" do
      response = post('/login', email: '<script>', password: 'Password3333')
      expect(response.status).to eq(400)
      expect(response.body).to include('<h1>Invalid input.</h1>')
    end

    it "returns an invalid input message when HTML script is entered into the password field" do
      response = post('/login', email: 'wrong', password: '<a href')
      expect(response.status).to eq(400)
      expect(response.body).to include('<h1>Invalid input.</h1>')
    end
  end
  
  context "GET /create_account" do
    it "returns 200 OK with correct content" do
      response = get('/create_account')
      expect(response.status).to eq(200)
      expect(response.body).to include('<label>Email: </label>')
      expect(response.body).to include('<label>Password: </label>')
      expect(response.body).to include('<label>Username: </label>')
    end
  end

  context "POST /create_account" do
    it "returns a 200 status when user creates a new account" do
      response = post('/create_account', email:'new_account@gmail.com', password: 'Password1234', username: 'newbie')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h3>Welcome, newbie!  Thank you for creating an account.</h3>')
    end

    it "returns a 200 status when user attempts to sign up with email already in use" do
      response = post('/create_account', email:'thanos@gmail.com', password: 'Password1234', username: 'thanos1234')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Email already in use.</h1>')
    end
  end
end