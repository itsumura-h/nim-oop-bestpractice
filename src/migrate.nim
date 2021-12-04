import
  std/db_sqlite,
  libs/db

conn.exec(sql"drop table if exists users")
conn.exec(sql"drop index if exists users_id")

let query = sql"""
create table users(
  id TEXT NOT NULL,
  last_name TEXT,
  first_name TEXT,
  kana_last_name TEXT,
  kana_first_name TEXT,
  email TEXT,
  birth_date TEXT
);
create index users_id on users(id);
"""

conn.exec(query)
