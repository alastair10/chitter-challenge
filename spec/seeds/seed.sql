DROP TABLE IF EXISTS users CASCADE; 
DROP TABLE IF EXISTS peeps;

-- Table 1 Definition
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username text,
  email text,
  password text
);

-- Table 2 Definition
CREATE TABLE peeps (
  id SERIAL PRIMARY KEY,
  content text,
  timestamp timestamp,
  tag text,
-- The foreign key name is always {other_table_singular}_id
  user_id int,
  constraint fk_user foreign key(user_id)
    references users(id)
    on delete cascade
);

TRUNCATE TABLE users, peeps RESTART IDENTITY CASCADE;

INSERT INTO users (username, email, password) VALUES ('alastair123', 'alastair@gmail.com', 'Password111');
INSERT INTO users (username, email, password) VALUES ('gunel123', 'gunel@gmail.com', 'Password222');
INSERT INTO users (username, email, password) VALUES ('thanos123', 'thanos@gmail.com', 'Password333');

INSERT INTO peeps (content, timestamp, tag, user_id) VALUES ('I like burritos', '2022-01-08 04:05:06', '@burritos', 1);
INSERT INTO peeps (content, timestamp, tag, user_id) VALUES ('gunel is amazing', '2022-01-08 05:05:06', '@wife', 2);
INSERT INTO peeps (content, timestamp, tag, user_id) VALUES ('cats are the best', '2022-01-08 06:05:06', '@cat', 3);
INSERT INTO peeps (content, timestamp, tag, user_id) VALUES ('everyone is using chitter', '2022-01-08 07:05:06', '@burritos @wife @cat',3);