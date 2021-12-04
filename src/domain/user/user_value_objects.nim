import
  std/nre,
  std/options,
  std/times,
  std/oids,
  std/sha1,
  ../../errors

type Uid* = ref object
  value:string

proc new*(_:type Uid):Uid =
  return Uid(
    value: genOid().`$`.secureHash().`$`
  )

proc `$`*(self:Uid):string =
  return self.value


type Name* = ref object
  value:string

proc new*(_:type Name, value:string):Name =
  if value.len == 0:
    raise newException(DomainError, "名前が空です")
  
  return Name(value:value)

proc `$`*(self:Name):string =
  return self.value


type KanaName* = ref object
  value:string

proc new*(_:type KanaName, value:string):KanaName =
  if value.len == 0:
    raise newException(DomainError, "カナ名前が空です")
  if not value.match(re"(*UTF8)^[ァ-ン]+").isSome:
    raise newException(DomainError, "カナ名前がカタカナでありません")
  
  return KanaName(value:value)

proc `$`*(self:KanaName):string =
  return self.value


type Email* = ref object
  value:string

proc new*(_:type Email, value:string):Email =
  if value.len == 0:
    raise newException(DomainError, "メールアドレスが空です")
  if not value.match(re".+@.+").isSome:
    raise newException(DomainError, "メールアドレスが正しくありません")

  return Email(value:value)

proc `$`*(self:Email):string =
  return self.value


type BirthDate* = ref object
  value: DateTime

proc new*(_:type BirthDate, value:string):BirthDate =
  if not value.match(re"^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$").isSome:
    raise newException(DomainError, "生年月日は1990-01-10の形式です")

  return BirthDate(value:value.parse("yyyy-MM-dd"))

proc `$`*(self:BirthDate):string =
  return self.value.format("yyyy-MM-dd")

proc get*(self:BirthDate):DateTime =
  return self.value


type YearsOld* = ref object
  value:int

proc new*(_:type YearsOld, value:int):YearsOld =
  if value < 0:
    raise newException(DomainError, "年齢は0以上です")
  return YearsOld(
    value: value
  )

proc get*(self:YearsOld):int =
  return self.value
