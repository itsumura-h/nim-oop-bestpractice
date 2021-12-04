import
  std/asyncdispatch,
  ../domain/user/user_value_objects,
  ../domain/user/user_entity,
  ../domain/user/user_repository_interface,
  ../di_container

type CreateNewUserUsecase* = ref object
  repository:IUserRepository

proc new*(_:type CreateNewUserUsecase):CreateNewUserUsecase =
  return CreateNewUserUsecase(
    repository: di.userRepository
  )

proc invoke*(
  self:CreateNewUserUsecase,
  lastName:string,
  firstName:string,
  kanaLastName:string,
  kanaFirstName:string,
  email:string,
  birthDate:string
){.async.} =
  let uid = Uid.new()
  let lastName = Name.new(lastName)
  let firstName = Name.new(firstName)
  let kanaLastName = KanaName.new(kanaLastName)
  let kanaFirstName = KanaName.new(kanaFirstName)
  let email = Email.new(email)
  let birthDate = BirthDate.new(birthDate)
  let user = User.new(
    uid, lastName, firstName, kanaLastName, kanaFirstName,
    email, birthDate
  )
  await self.repository.save(user)
