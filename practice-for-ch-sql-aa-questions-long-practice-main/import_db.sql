PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    author_id INTEGER NOT NULL,

    FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    parent_reply_id INTEGER,
    author_id INTEGER NOT NULL,
    body TEXT NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (parent_reply_id) REFERENCES replies(id),
    FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
    users (fname, lname)
VALUES 
    ('Babe', 'Ruth'),
    ('Michael', 'Jordan');

INSERT INTO 
    questions (title, body, author_id)
VALUES 
    ('Tuition', 'How much is the full tuition?', (SELECT id from users WHERE fname = 'Michael' AND lname = 'Jordan' )),
    ('Computers', 'Will I need a computer?', (SELECT id from users WHERE fname = 'Michael' AND lname = 'Jordan' ));

INSERT INTO
    question_follows (user_id, question_id)
VALUES 
    -- ((SELECT id FROM users WHERE fname = 'Michael'), (SELECT questions.id from questions WHERE questions_follows.user_id = questions.author_id))
    (1,1);

INSERT INTO
    replies (question_id, parent_reply_id, author_id, body)
VALUES
    ((SELECT id FROM questions WHERE title = 'Tuition'), NULL, (SELECT id FROM users WHERE fname = 'Babe' AND lname = 'Ruth'), 'your dignity.');

INSERT INTO
    question_likes (user_id, question_id)
VALUES
    ((SELECT id FROM users WHERE fname = 'Michael' AND lname = 'Jordan'), (SELECT id FROM questions WHERE title = 'Tuition'));