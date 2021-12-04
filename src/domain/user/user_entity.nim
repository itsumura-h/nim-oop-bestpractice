import
  std/times,
  user_value_objects

type User* = ref object
  uid:Uid
  lastName:Name
  firstName:Name
  kanaLastName:KanaName
  kanaFirstName:KanaName
  email:Email
  birthDate:BirthDate
  yearsOld:YearsOld

proc new*(_:type User,
  uid:Uid,
  lastName: Name,
  firstName: Name,
  kanaLastName: KanaName,
  kanaFirstName: KanaName,
  email: Email,
  birthDate: BirthDate
):User =
  return User(
    uid: uid,
    lastName: lastName,
    firstName: firstName,
    kanaLastName: kanaLastName,
    kanaFirstName: kanaFirstName,
    email: email,
    birthDate: birthDate,
    yearsOld: YearsOld.new(
      now().year - birthDate.get.year
    )
  )

proc uid*(self:User):Uid =
  return self.uid

proc lastName*(self:User):Name =
  return self.lastName

proc firstName*(self:User):Name =
  return self.firstName

proc kanaLastName*(self:User):KanaName =
  return self.kanaLastName

proc kanaFirstName*(self:User):KanaName =
  return self.kanaFirstName

proc email*(self:User):Email =
  return self.email

proc birthDate*(self:User):BirthDate =
  return self.birthDate

proc yearsOld*(self:User):YearsOld =
  return self.yearsOld
