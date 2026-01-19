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
