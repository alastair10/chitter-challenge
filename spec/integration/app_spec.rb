require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # Used to rack-test helper methods.
  include Rack::Test::Methods

  # Need to declare the `app` value by instantiating the Application class so the tests work.
  let(:app) { Application.new }

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

      expect(response.body).to include("<h2>Show me what everyone's talking about.</h2>")
    end
  end

  context 'GET /peeps' do
    it "returns a list of peeps" do
      response = get('/peeps')
      expect(response.status).to eq(200)
      expect(response.body).to eq('<alastair is amazing<br />')
      expect(response.body).to eq('everyone is amazing')
      expect(response.body).to eq('2022-01-08 06:05:06')
    end
  end








end