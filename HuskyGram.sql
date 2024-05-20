DROP DATABASE IF EXISTS HuskyGram; 
CREATE DATABASE IF NOT EXISTS HuskyGram;

USE HuskyGram;

DROP TABLE IF EXISTS users;
CREATE TABLE IF NOT EXISTS users (
   id INT PRIMARY KEY,
   username VARCHAR(255) UNIQUE NOT NULL,
   created_at DATETIME
);

DROP TABLE IF EXISTS follows;
CREATE TABLE IF NOT EXISTS follows (
    follower_id INT NOT NULL, 
    followee_id INT NOT NULL,
    created_at DATETIME, 
    PRIMARY KEY (follower_id, followee_id), 
    FOREIGN KEY (follower_id) REFERENCES users(id),
    FOREIGN KEY (followee_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS photos;
CREATE TABLE IF NOT EXISTS photos (
    id INT PRIMARY KEY,
    image_url VARCHAR(255) NOT NULL,
    user_id INT NOT NULL,
    created_at DATETIME, 
    FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS tags;
CREATE TABLE IF NOT EXISTS tags (
    id INT PRIMARY KEY,
    tag_name VARCHAR(255) UNIQUE, 
    created_at DATETIME
);

DROP TABLE IF EXISTS photo_tags;
CREATE TABLE IF NOT EXISTS photo_tags (
    photo_id INT NOT NULL,
    tag_id INT NOT NULL,
    PRIMARY KEY (photo_id, tag_id),
    FOREIGN KEY (photo_id) REFERENCES photos(id),
    FOREIGN KEY (tag_id) REFERENCES tags(id)
);

DROP TABLE IF EXISTS comments;
CREATE TABLE IF NOT EXISTS comments (
    id INT PRIMARY KEY,
    comment_text VARCHAR(255) NOT NULL,
    user_id INT NOT NULL,
    photo_id INT NOT NULL,
    created_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (photo_id) REFERENCES photos(id)
);

DROP TABLE IF EXISTS likes;
CREATE TABLE IF NOT EXISTS likes (
    user_id INT NOT NULL,
    photo_id INT NOT NULL,
    created_at DATETIME,
    PRIMARY KEY (user_id, photo_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (photo_id) REFERENCES photos(id)
);

INSERT INTO users (id, username, created_at) VALUES (1, 'MAGGIE', NOW());
INSERT INTO users (id, username, created_at) VALUES (2, 'SONIA', NOW());
INSERT INTO users (id, username, created_at) VALUES (3, 'DYLAN', NOW());

INSERT INTO follows (follower_id, followee_id, created_at) VALUES (1, 2, NOW());
INSERT INTO follows (follower_id, followee_id, created_at) VALUES (2, 1, NOW());

INSERT INTO photos (id, image_url, user_id, created_at) VALUES (10, 'https://example.com/image.jpg', 1, NOW());
INSERT INTO photos (id, image_url, user_id, created_at) VALUES (11, 'https://example.com/image2.jpg', 2, NOW());

INSERT INTO tags (id, tag_name, created_at) VALUES (30, 'nature', NOW());
insert INTO tags (id, tag_name, created_at) VALUES (40, 'beach', NOW());

insert INTO photo_tags (photo_id, tag_id) VALUES (10, 30);
insert INTO photo_tags (photo_id, tag_id) VALUES (11, 40);

INSERT INTO comments (id, comment_text, user_id, photo_id, created_at) VALUES (1, 'Great photo!', 2, 10, NOW());
INSERT INTO comments (id, comment_text, user_id, photo_id, created_at) VALUES (2, 'Nice!', 1, 11, NOW());

INSERT INTO likes (user_id, photo_id, created_at) VALUES (1, 10, NOW());
INSERT INTO likes (user_id, photo_id, created_at) VALUES (2, 11, NOW());







