import
  std/asyncdispatch,
  std/json,
  ../application/create_new_user_usecase,
  ../application/get_all_users_usecase

proc createUser(args: seq[string]) {.async.} =
  var lastName = ""
  var firstName = ""
  var kanaLastName = ""
  var kanaFirstName = ""
  var email = ""
  var birthDate = ""
  for i in 0..<6:
    case i
    of 0:
      echo "苗字を入力して下さい"
      lastName = stdin.readLine
    of 1:
      echo "名前を入力して下さい"
      firstName = stdin.readLine
    of 2:
      echo "苗字（カナ）を入力して下さい"
      kanaLastName = stdin.readLine
    of 3:
      echo "名前（カナ）を入力して下さい"
      kanaFirstName = stdin.readLine
    of 4:
      echo "メールアドレスを入力して下さい"
      email = stdin.readLine
    of 5:
      echo "生年月日をハイフン区切りで入力して下さい"
      birthDate = stdin.readLine
    else:
      discard
  let usecase = CreateNewUserUsecase.new()
  await usecase.invoke(
    lastName, firstName, kanaLastName, kanaFirstName, email, birthDate
  )

proc getUsers(args:seq[string]) {.async.} =
  let usecase = GetAllUsersUsecase.new()
  echo await usecase.invoke()


when isMainModule:
  import cligen
  dispatchMulti([createUser], [getUsers])
