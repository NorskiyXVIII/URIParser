import std/strutils
import std/strformat
## URI представляет собой строку, в которой лежит URI
type URI* = string 

## функция proto возвращает протокол URI
proc proto*(uri: URI): string =
    if not uri.contains("://") or uri == "":
        return ""
    
    let protoEnd = uri.find("://")

    return uri[0 ..< protoEnd]

## функция deleteProto удаляет из строки протокол
proc deleteProto*(uri: var URI) =
    let proto = uri.proto() & "://"
    uri = uri.replace(proto, "")

## функция host возвращает имя хоста 
proc host*(uri: URI): string =
    if uri == "":
        return ""

    var uriTmp = uri
    uriTmp.deleteProto()
    
    # удаляем порт
    var hostEnd = uriTmp.find(":")
    if hostEnd == -1:
        hostEnd = uriTmp.find("/")

    return uriTmp[0 ..< hostEnd]

## функция deleteHost удаляет хоста
proc deleteHost(uri: var URI) =
    let host = uri.host()
    uri = uri.replace(host, "")

## функция domain позволяет получить домен URI
## НЕЖЕЛАТЕЛЕН В ИСПОЛЬЗОВАНИИ: 
## айпи адреса плохо интерпретирует
## 127.0.0.1 -> domain вернет 0.0.1
## google.com -> domain вернет com
proc domain*(uri: URI): string =
    if uri == "":
        return ""
    
    var uriHost = uri.host()
    let domainStart = uriHost.find(".")
    return uriHost[domainStart + 1 .. ^1]

## функция deleteDomain удаляет из URI домен
## НЕЖЕЛАТЕЛЕН В ИСПОЛЬЗОВАНИИ
proc deleteDomain*(uri: var URI) =
    let domain = "." & uri.domain()
    uri = uri.replace(domain, "")

## функция port возвращает порт uri
## НЕЖЕЛАТЕЛЬНА В ИСПОЛЬЗОВАНИИ:
## если есть query, но нет порта, то выведет query
proc port*(uri: URI): string =
    if not uri.contains(":") or uri == "":
        return ""

    var uriTmp = uri
    uriTmp.deleteProto()
    uriTmp.deleteHost()

    return uriTmp[1 .. ^1]

## функция deletePort удаляет порт из URI
proc deletePort*(uri: var URI) =
    let port = ":" & uri.port()
    uri = uri.replace(port, "")

## функция path получает путь из URI
proc path*(uri: URI): string =
    var uriTmp = uri
    uriTmp.deleteProto()
    uriTmp.deleteHost()
    uriTmp.deletePort()

    if not uri.contains("/") or uri == "":
        return ""

    return uriTmp[1 .. ^1]

## функция deletePath удаляет путь из URI
proc deletePath*(uri: var URI) =
    let path = uri.path()
    uri = uri.replace(path, "")

## функция query получает запрос из URI
proc query*(uri: URI): string =
    var uriTmp = uri
    if uriTmp == "":
        return ""
    
    let queryStart = uriTmp.find("?")
    if queryStart == -1:
        return ""
    let queryEnd   = uriTmp.find("#")
    if queryEnd == -1:
        return uriTmp[queryStart + 1 .. ^1]

    return uriTmp[queryStart + 1 ..< queryEnd]

## функция deleteQuery удаляет запрос из URI
proc deleteQuery*(uri: var URI) =
    let query = "?" & uri.query()
    uri = uri.replace(query, "")

## функция queryAsSeq возвращает seq, в котором фрагменты
proc queryAsSeq*(uri: URI): seq[string] =
    if uri.query() == "":
        return @[""]
    
    return uri.query().split("&")

## функция fragments возвращает фрагменты в URI
proc fragments*(uri: URI): string =
    var uriTmp = uri
    uriTmp.deleteQuery()
    let fragmentStart = uriTmp.find("#")

    if uriTmp == "" or fragmentStart == -1:
        return ""

    return uriTmp[fragmentStart + 1 .. ^1]

## функция deleteFragments удаляет фрагменты из URI
proc deleteFragments*(uri: var URI): string =
    let fragments = "#" & uri.fragments()
    uri = uri.replace(fragments, "")

## функция fragmentsAsSeq возвращает seq, в котором фрагменты
proc fragmentsAsSeq*(uri: URI): seq[string] =
    if uri.fragments() == "":
        return @[""]
    
    return uri.fragments().split("#")

proc format*(uri: URI, sep = "\n", indent: string = "\t", startIndent = "", inline = false,
            proto = true, host = true, domain = false, port = false,
            path = false, query = false, queryAsSeq = false, fragments = false,
            fragmentsAsSeq: bool = false): string =
    var res: string
    if inline: 
        res = "{" & startIndent
    else:
        res = "{\n" & startIndent
    
    if proto:
        let proto = uri.proto()
        res &= indent & "Protocol -> " & proto & sep
    if host:
        let host = uri.host()
        res &= indent & "HostName -> " & host & sep
    if domain:
        let domain = uri.domain()
        res &= indent & "Domain -> " & domain & sep
    if port:
        let port = uri.port()
        res &= indent & "Port -> " & port & sep
    if path:
        let path = uri.path()
        res &= indent & "Path -> " & path & sep
    if query:
        let query = uri.query()
        res &= indent & "Query -> " & query & sep
    if queryAsSeq:
        let queryAsSeq = uri.queryAsSeq()
        res &= indent & "@[Query] -> " & fmt"{queryAsSeq}" & sep
    if fragments:
        let fragments = uri.fragments()
        res &= indent & "Fragments ->" & fragments & sep
    if fragmentsAsSeq:
        let fragmentsAsSeq = uri.fragmentsAsSeq()
        res &= indent & "@[Fragments] ->" & fmt"{fragmentsAsSeq}" & sep
    
    if inline: 
        res &= "}"
    else:
        res &= "\n}"
    return res