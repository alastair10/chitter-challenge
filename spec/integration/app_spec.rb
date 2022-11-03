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
      expect(response.body).to include('<div>New here?</div>')
      expect(response.body).to include('<div>Show me what people are talking about.</div>')
    end
  end
end