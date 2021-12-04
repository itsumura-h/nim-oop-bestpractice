import
  std/os,
  std/json,
  std/asyncdispatch,
  interface_implements,
  ../../domain/user/user_value_objects,
  ../../domain/user/user_entity,
  ../../domain/user/user_repository_interface

type JsonUserRepository* = ref object
  path:string

proc new*(_:type JsonUserRepository):JsonUserRepository =
  return JsonUserRepository(
    path: getCurrentDir() / "data.json"
  )

implements JsonUserRepository, IUserRepository:
  proc getAll(self:JsonUserRepository):Future[JsonNode] {.async.} =
    var f = open(self.path, fmRead)
    defer: f.close()
    let stream = f.readAll()
    if stream.len == 0:
      return newJArray()
    let jsonContent = stream.parseJson()
    if not jsonContent.hasKey("users"):
      return newJArray()
    return jsonContent["users"]

  proc save(self:JsonUserRepository, user:User):Future[void] {.async.} =
    var f = open(self.path, fmRead)
    defer: f.close()
    let stream = f.readAll()
    var jsonContent =
      if stream.len == 0:
        let j = newJObject()
        j["users"] = newJArray()
        j
      else:
        stream.parseJson()
    if not jsonContent.hasKey("users"):
      jsonContent["users"] = newJArray()  
    jsonContent["users"].add(%*{
      "id": $user.uid,
      "lastName": $user.lastName,
      "firstName": $user.firstName,
      "kanaLastName": $user.kanaLastName,
      "kanaFirstName": $user.kanaFirstName,
      "email": $user.email,
      "birthDate": $user.birthDate,
    })
    self.path.writeFile($jsonContent)
