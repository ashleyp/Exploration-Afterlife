-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Thu May  3 15:25:06 2012
-- 

;
BEGIN TRANSACTION;
--
-- Table: category
--
CREATE TABLE category (
  category_id INTEGER PRIMARY KEY NOT NULL,
  category_name text NOT NULL
);
--
-- Table: user_level
--
CREATE TABLE user_level (
  user_level_id INTEGER PRIMARY KEY NOT NULL,
  user_level_name text NOT NULL
);
--
-- Table: users
--
CREATE TABLE users (
  user_id INTEGER PRIMARY KEY NOT NULL,
  user_level_id integer NOT NULL,
  username text NOT NULL,
  password text NOT NULL,
  lastname text NOT NULL,
  firstname text NOT NULL,
  email text NOT NULL,
  FOREIGN KEY(user_level_id) REFERENCES user_level(user_level_id)
);
CREATE INDEX users_idx_user_level_id ON users (user_level_id);
CREATE UNIQUE INDEX username ON users (username);
--
-- Table: article
--
CREATE TABLE article (
  article_id INTEGER PRIMARY KEY NOT NULL,
  content text NOT NULL,
  title text NOT NULL,
  date_posted integer NOT NULL,
  category_id integer NOT NULL,
  posted_by_user_id integer NOT NULL,
  FOREIGN KEY(category_id) REFERENCES category(category_id),
  FOREIGN KEY(posted_by_user_id) REFERENCES users(user_id)
);
CREATE INDEX article_idx_category_id ON article (category_id);
CREATE INDEX article_idx_posted_by_user_id ON article (posted_by_user_id);
COMMIT
