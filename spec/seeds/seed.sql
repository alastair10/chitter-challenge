DROP TABLE IF EXISTS users; 
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

INSERT INTO users (username, email, password) VALUES ('alastair123', 'alastair@gmail.com', 'password111');
INSERT INTO users (username, email, password) VALUES ('gunel123', 'gunel@gmail.com', 'password222');
INSERT INTO users (username, email, password) VALUES ('thanos123', 'thanos@gmail.com', 'password333');

INSERT INTO peeps (content, timestamp, tag, user_id) VALUES ('alastair is amazing', '2022-01-08 04:05:06', '#alastair#life#makers', 1);
INSERT INTO peeps (content, timestamp, tag, user_id) VALUES ('gunel is amazing', '2022-01-08 05:05:06', '#gunel#life#starling', 2);
INSERT INTO peeps (content, timestamp, tag, user_id) VALUES ('thanos is amazing', '2022-01-08 06:05:06', '#cat#cantspeak', 3);
INSERT INTO peeps (content, timestamp, tag, user_id) VALUES ('everyone is amazing', '2022-01-08 07:05:06', '#life#makers', 1);