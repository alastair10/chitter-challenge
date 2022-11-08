# Chitter Application
Chitter is a slimmed-down Twitter clone. A user can sign up, sign in and post peeps. All peeps are visible to all users, even if not signed in, but posting is only able to be done by users who have signed up to the platform.

Chitter uses Ruby, Sinatra, PostgresSQL, and Bcrypt

## Features to implement in the future
- CSS styling
- enable a single email to sign up with multiple usernames
- email notification of peeps
- peep sorting by user
- replies to peeps


## How to use

### To set up the project

Clone this repository and then run:
```
git clone https://github.com/alastair10/chitter-challenge.git
cd chitter-challenge
bundle
```

### To run the app:

```
1. Run command `rackup`
2. In web browser, enter i.e. "localhost:9292" (or the port provided from previous step)
```

### To run tests:

```
rspec
```

### To run linting:

```
rubocop
```

### Technology

- Web Framework: Sinatra
- Test Framework: rspec
- Database: PostgreSQL