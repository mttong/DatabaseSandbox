DROP DATABASE IF EXISTS HuskyGram;
CREATE DATABASE IF NOT EXISTS HuskyGram;

USE HuskyGram;

DROP TABLE IF EXISTS users;
CREATE TABLE IF NOT EXISTS users
(
    id         INT PRIMARY KEY,
    username   VARCHAR(255) UNIQUE NOT NULL,
    created_at DATETIME
);

DROP TABLE IF EXISTS follows;
CREATE TABLE IF NOT EXISTS follows
(
    follower_id INT NOT NULL,
    followee_id INT NOT NULL,
    created_at  DATETIME,
    PRIMARY KEY (follower_id, followee_id),
    FOREIGN KEY (follower_id) REFERENCES users (id),
    FOREIGN KEY (followee_id) REFERENCES users (id)
);

DROP TABLE IF EXISTS photos;
CREATE TABLE IF NOT EXISTS photos
(
    id         INT PRIMARY KEY,
    image_url  VARCHAR(255) NOT NULL,
    user_id    INT          NOT NULL,
    created_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES users (id)
);

DROP TABLE IF EXISTS tags;
CREATE TABLE IF NOT EXISTS tags
(
    id         INT PRIMARY KEY,
    tag_name   VARCHAR(255) UNIQUE,
    created_at DATETIME
);

DROP TABLE IF EXISTS photo_tags;
CREATE TABLE IF NOT EXISTS photo_tags
(
    photo_id INT NOT NULL,
    tag_id   INT NOT NULL,
    PRIMARY KEY (photo_id, tag_id),
    FOREIGN KEY (photo_id) REFERENCES photos (id),
    FOREIGN KEY (tag_id) REFERENCES tags (id)
);

DROP TABLE IF EXISTS comments;
CREATE TABLE IF NOT EXISTS comments
(
    id           INT PRIMARY KEY,
    comment_text VARCHAR(255) NOT NULL,
    user_id      INT          NOT NULL,
    photo_id     INT          NOT NULL,
    created_at   DATETIME,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (photo_id) REFERENCES photos (id)
);

DROP TABLE IF EXISTS likes;
CREATE TABLE IF NOT EXISTS likes
(
    user_id    INT NOT NULL,
    photo_id   INT NOT NULL,
    created_at DATETIME,
    PRIMARY KEY (user_id, photo_id),
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (photo_id) REFERENCES photos (id)
);

INSERT INTO users (id, username, created_at)
VALUES (1, 'MAGGIE', NOW());
INSERT INTO users (id, username, created_at)
VALUES (2, 'SONIA', NOW());
INSERT INTO users (id, username, created_at)
VALUES (3, 'DYLAN', NOW());
insert INTO users (id, username, created_at)
VALUES (4, 'MILO', NOW());

INSERT INTO follows (follower_id, followee_id, created_at)
VALUES (1, 2, NOW());
INSERT INTO follows (follower_id, followee_id, created_at)
VALUES (2, 1, NOW());

INSERT INTO photos (id, image_url, user_id, created_at)
VALUES (10, 'https://example.com/image.jpg', 1, NOW());
INSERT INTO photos (id, image_url, user_id, created_at)
VALUES (11, 'https://example.com/image2.jpg', 2, NOW());
INSERT INTO photos (id, image_url, user_id, created_at)
VALUES (12, 'https://example.com/image3.jpg', 3, NOW());

INSERT INTO tags (id, tag_name, created_at)
VALUES (30, 'nature', NOW());
insert INTO tags (id, tag_name, created_at)
VALUES (40, 'beach', NOW());
INSERT INTO tags (id, tag_name, created_at)
VALUES (50, '#NEU', NOW());
INSERT INTO tags (id, tag_name, created_at)
VALUES (60, '#BU', NOW());

insert INTO photo_tags (photo_id, tag_id)
VALUES (10, 30);
insert INTO photo_tags (photo_id, tag_id)
VALUES (11, 40);
insert INTO photo_tags (photo_id, tag_id)
VALUES (12, 50);
insert INTO photo_tags (photo_id, tag_id)
VALUES (12, 60);
INSERT INTO photo_tags (photo_id, tag_id)
VALUES (10, 50);
INSERT INTO photo_tags (photo_id, tag_id)
VALUES (11, 60);

INSERT INTO comments (id, comment_text, user_id, photo_id, created_at)
VALUES (1, 'Great photo! college', 2, 10, NOW());
INSERT INTO comments (id, comment_text, user_id, photo_id, created_at)
VALUES (2, 'Nice!', 1, 11, NOW());
INSERT INTO comments (id, comment_text, user_id, photo_id, created_at)
VALUES (3, 'Cool! COLLEGE', 3, 12, NOW());



INSERT INTO likes (user_id, photo_id, created_at)
VALUES (1, 12, NOW());
INSERT INTO likes (user_id, photo_id, created_at)
VALUES (2, 11, NOW());









# what I put down for 4, had to switch it around a lot and it was super wrong!!! oops!
# also when changing the 0 as "num_comments"
SELECT t.photo_id as "photo id", t.photo_URL as "photo URL", t.num_comments as "number of comments"
FROM (SELECT DISTINCT p.id        AS "photo_id",
                      p.image_url AS "photo_URL",
                      COUNT(*) AS "num_comments",
                      p.created_at
      FROM photos p
               JOIN comments c ON p.id = c.photo_id
      GROUP BY p.id
      UNION
      SELECT DISTINCT p.id        AS "photo_id",
                      p.image_url AS "photo_URL",
                      0           AS "num_comments",
                      p.created_at
      FROM photos p
               LEFT JOIN comments c ON p.id = c.photo_id
      WHERE c.photo_id IS NULL
      GROUP BY p.id) AS t
ORDER BY t.created_at DESC;

#NUMBER 4, SOLUTION
#milo's answer, which works!
#need to understand group by and count?
SELECT p.id AS photo_id, p.image_url AS URL, COUNT(c.id) AS num_comments
FROM photos p
         LEFT OUTER JOIN comments c ON p.id = c.photo_id
GROUP BY p.id, p.image_url, p.created_at
ORDER BY p.created_at DESC;

#NUMBER 5, SOLUTION
SELECT DISTINCT u.username AS "usernames"
FROM users u
         JOIN photos p ON u.id = p.user_id
         LEFT JOIN likes l ON l.photo_id = p.id
         JOIN comments c ON c.photo_id = p.id
WHERE l.created_at IS NULL
ORDER BY u.username;
#yay!

#need alias for table...
#this can be more efficient
SELECT COUNT(*) AS "num_photos"
FROM (SELECT p.user_id
      FROM photos p
               JOIN photo_tags pt ON p.id = pt.photo_id
               JOIN tags t ON t.id = pt.tag_id
      WHERE tag_name = '#NEU'
      INTERSECT
      SELECT p.user_id
      FROM photos p
               JOIN photo_tags pt ON p.id = pt.photo_id
               JOIN tags t ON t.id = pt.tag_id
      WHERE tag_name = '#BU') as pptuipptui;

#NUMBER 6, SOLUTION
#simplified!
SELECT COUNT(*) AS "num_photos"
FROM (SELECT pt.photo_id
      FROM photo_tags pt
               JOIN tags t ON t.id = pt.tag_id
      WHERE tag_name = '#NEU'
      INTERSECT
      SELECT pt.photo_id
      FROM photo_tags pt
               JOIN tags t ON t.id = pt.tag_id
      WHERE tag_name = '#BU') as pptuipptui;

#NUMBER 7, SOLUTION
SELECT u.username, c.comment_text
FROM comments c
         JOIN users u ON u.id = c.user_id
WHERE LOWER(c.comment_text) LIKE '%college%'
ORDER BY c.created_at;

#NUMBER 8, SOLUTION
SELECT u.username AS "no photo users", u.created_at AS "creation date"
FROM users u LEFT JOIN photos p on u.id = p.user_id
WHERE p.created_at IS NULL
ORDER BY u.username;


























