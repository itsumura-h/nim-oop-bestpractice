import
  domain/user/user_repository_interface,
  infra/user/json_user_repository,
  infra/user/rdb_user_repository

type DiContainer* = tuple
  userRepository: IUserRepository

proc new*(_:type DiContainer):DiContainer =
  return (
    # userRepository: JsonUserRepository.new().toInterface(),
    userRepository: RdbUserRepository.new().toInterface(),
  )

let di* = DiContainer.new()
