import
  std/asyncdispatch,
  std/json,
  ../domain/user/user_repository_interface,
  ../di_container

type GetAllUsersUsecase* = ref object
  repository: IUserRepository

proc new*(_:type GetAllUsersUsecase):GetAllUsersUsecase =
  return GetAllUsersUsecase(
    repository: di.userRepository
  )

proc invoke*(self:GetAllUsersUsecase):Future[JsonNode] {.async.} =
  let users = await self.repository.getAll()
  return users
