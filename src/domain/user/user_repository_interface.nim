import
  std/asyncdispatch,
  std/json,
  user_entity

type IUserRepository* = tuple
  getAll:proc():Future[JsonNode]
  save:proc(user:User):Future[void]
