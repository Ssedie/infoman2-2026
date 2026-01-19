/*psql -U postgres -c "CREATE DATABASE week1_lab;"
Password for user postgres:

CREATE DATABASE

psql -U postgres -d week1_lab -f blog_schema_postgres.sql
Password for user postgres:

CREATE TABLE
CREATE TABLE
CREATE TABLE
INSERT 0 7
INSERT 0 7
INSERT 0 7

psql -U postgres
Password for user postgres:

psql (18.1)
WARNING: Console code page (437) differs from Windows code page (1252)
         8-bit characters might not work correctly. See psql reference
         page "Notes for Windows users" for details.
Type "help" for help.

postgres=# \l
                                                                    List of databases
   Name    |  Owner   | Encoding | Locale Provider |          Collate           |           Ctype            | Locale | ICU Rules |   Access privileges
-----------+----------+----------+-----------------+----------------------------+----------------------------+--------+-----------+-----------------------
 postgres  | postgres | UTF8     | libc            | English_United States.1252 | English_United States.1252 |        |           |
 template0 | postgres | UTF8     | libc            | English_United States.1252 | English_United States.1252 |        |           | =c/postgres          +
           |          |          |                 |                            |                            |        |           | postgres=CTc/postgres
 template1 | postgres | UTF8     | libc            | English_United States.1252 | English_United States.1252 |        |           | =c/postgres          +
           |          |          |                 |                            |                            |        |           | postgres=CTc/postgres
 week1_lab | postgres | UTF8     | libc            | English_United States.1252 | English_United States.1252 |        |           |
(4 rows)

SELECT * FROM users;
 id | username |         created_at
----+----------+----------------------------
  1 | alice    | 2026-01-13 21:24:52.654886
  2 | bob      | 2026-01-13 21:24:52.654886
  3 | charlie  | 2026-01-13 21:24:52.654886
  4 | dave     | 2026-01-13 21:24:52.654886
  5 | eve      | 2026-01-13 21:24:52.654886
  6 | frank    | 2026-01-13 21:24:52.654886
  7 | grace    | 2026-01-13 21:24:52.654886
(7 rows)

SELECT * FROM comments;
 id | post_id | user_id |                          comment                           |         created_at
----+---------+---------+------------------------------------------------------------+----------------------------
  1 |       1 |       2 | Great first post, Alice!                                   | 2026-01-13 21:24:52.662084
  2 |       2 |       1 | Interesting thoughts, Bob.                                 | 2026-01-13 21:24:52.662084
  3 |       3 |       4 | Thanks for the update, Charlie.                            | 2026-01-13 21:24:52.662084
  4 |       4 |       5 | Can't wait for the big news, Dave!                         | 2026-01-13 21:24:52.662084
  5 |       5 |       6 | Eve, your insights are always valuable.                    | 2026-01-13 21:24:52.662084
  6 |       6 |       7 | Looking forward to hearing more about your journey, Frank. | 2026-01-13 21:24:52.662084
  7 |       7 |       1 | Great tips, Grace!                                         | 2026-01-13 21:24:52.662084
(7 rows)

SELECT * FROM posts;
 id | user_id |        title        |                  body                   |         created_at
----+---------+---------------------+-----------------------------------------+----------------------------
  1 |       1 | First Post!         | This is the body of the first post.     | 2026-01-13 21:24:52.658877
  2 |       2 | Bob's Thoughts      | A penny for my thoughts.                | 2026-01-13 21:24:52.658877
  3 |       3 | Charlie's Update    | Here is what I have been up to lately.  | 2026-01-13 21:24:52.658877
  4 |       4 | Dave's Announcement | Big news coming soon!                   | 2026-01-13 21:24:52.658877
  5 |       5 | Eve's Insights      | Sharing some insights on recent events. | 2026-01-13 21:24:52.658877
  6 |       6 | Frank's Journey     | Documenting my journey through life.    | 2026-01-13 21:24:52.658877
  7 |       7 | Grace's Tips        | Tips and tricks for a better life.      | 2026-01-13 21:24:52.658877
(7 rows)*/

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    body TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);


CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);


INSERT INTO users (username) VALUES ('alice'), ('bob'), ('charlie'), ('dave'), ('eve'), ('frank'), ('grace');


INSERT INTO posts (user_id, title, body) VALUES
(1, 'First Post!', 'This is the body of the first post.'),
(2, 'Bob''s Thoughts', 'A penny for my thoughts.'),
(3, 'Charlie''s Update', 'Here is what I have been up to lately.'),
(4, 'Dave''s Announcement', 'Big news coming soon!'),
(5, 'Eve''s Insights', 'Sharing some insights on recent events.'),
(6, 'Frank''s Journey', 'Documenting my journey through life.'),
(7, 'Grace''s Tips', 'Tips and tricks for a better life.');


INSERT INTO comments (post_id, user_id, comment) VALUES
(1, 2, 'Great first post, Alice!'),
(2, 1, 'Interesting thoughts, Bob.'),
(3, 4, 'Thanks for the update, Charlie.'),
(4, 5, 'Can''t wait for the big news, Dave!'),
(5, 6, 'Eve, your insights are always valuable.'),
(6, 7, 'Looking forward to hearing more about your journey, Frank.'),
(7, 1, 'Great tips, Grace!');
