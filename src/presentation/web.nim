import
  std/asynchttpserver,
  std/asyncdispatch,
  std/json,
  ../errors,
  ../application/create_new_user_usecase,
  ../application/get_all_users_usecase

let htmlResponseHeader = {"Content-type": "text/html; charset=utf-8"}.newHttpHeaders()
let jsonResponseHeader = {"Content-type": "application/json; charset=utf-8"}.newHttpHeaders()

proc main {.async.} =
  var server = newAsyncHttpServer()
  proc cb(req: Request) {.async, gcsafe.} =
    if req.reqMethod == HttpGet and req.url.path == "/":
      await req.respond(Http200, "Hello World", htmlResponseHeader)
    elif req.reqMethod == HttpGet and req.url.path == "/users":
      try:
        let usecase = GetAllUsersUsecase.new()
        let resp = %*{
          "users": await usecase.invoke()
        }
        await req.respond(Http200, $resp, jsonResponseHeader)
      except DomainError:
        let resp = %*{
          "error": getCurrentExceptionMsg()
        }
        await req.respond(Http400, $resp, jsonResponseHeader)
      except InfraError:
        let resp = %*{
          "error": getCurrentExceptionMsg()
        }
        await req.respond(Http500, $resp, jsonResponseHeader)
    elif req.reqMethod == HttpPost and req.url.path == "/users":
      let params = req.body.parseJson()
      let lastName = params["lastName"].getStr
      let firstName = params["firstName"].getStr
      let kanaLastName = params["kanaLastName"].getStr
      let kanaFirstName = params["kanaFirstName"].getStr
      let email = params["email"].getStr
      let birthDate = params["birthDate"].getStr
      let usecase = CreateNewUserUsecase.new()
      try:
        await usecase.invoke(lastName, firstName, kanaLastName, kanaFirstName, email, birthDate)
        let resp = %*{
          "msg": "success"
        }
        await req.respond(Http200, $resp, jsonResponseHeader)
      except DomainError:
        let resp = %*{
          "error": getCurrentExceptionMsg()
        }
        await req.respond(Http400, $resp, jsonResponseHeader)
      except InfraError:
        let resp = %*{
          "error": getCurrentExceptionMsg()
        }
        await req.respond(Http500, $resp, jsonResponseHeader)
    else:
      await req.respond(Http404, "", htmlResponseHeader)

  server.listen(Port(8000))
  while true:
    if server.shouldAcceptRequest():
      await server.acceptRequest(cb)
    else:
      await sleepAsync(500)

waitFor main()
