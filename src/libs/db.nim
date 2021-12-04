import
  std/os,
  std/db_sqlite

let conn* = open(getCurrentDir() / "data.sqlite", "", "", "")