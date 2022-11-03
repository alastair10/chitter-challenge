# file: spec/spec_helper.rb

require 'database_connection'

# Make sure this connects to your test database
# (its name should end with '_test')
DatabaseConnection.connect('chitter_app_test')