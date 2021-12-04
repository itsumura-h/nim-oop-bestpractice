import
  std/json,
  std/db_sqlite,
  std/asyncdispatch,
  interface_implements,
  ../../libs/db,
  ../../domain/user/user_value_objects,
  ../../domain/user/user_entity,
  ../../domain/user/user_repository_interface

type RdbUserRepository* = ref object
  db:DbConn

proc new*(_:type RdbUserRepository):RdbUserRepository =
  return RdbUserRepository(
    db: conn
  )

implements RdbUserRepository, IUserRepository:
  proc getAll(self:RdbUserRepository):Future[JsonNode] {.async.} =
    let query = sql"select * from users"
    let rows = self.db.getAllRows(query)
    let res = newJArray()
    for row in rows:
      res.add(%*{
        "id": row[0],
        "lastName": row[1],
        "firstName": row[2],
        "kanaLastName": row[3],
        "kanaFirstName": row[4],
        "email": row[5],
        "birthDate": row[6],
      })
    return res

  proc save(self:RdbUserRepository, user:User):Future[void] {.async.} =
    let query = sql"""insert into users (
      id, last_name, first_name,
      kana_last_name, kana_first_name,
      email, birth_date
    ) values (?, ?, ?, ?, ?, ?, ?)"""
    self.db.exec(query, [
      $user.uid, $user.lastName, $user.firstName,
      $user.kanaLastName, $user.kanaFirstName,
      $user.email, $user.birthDate
    ])
