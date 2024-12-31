import std/strutils


type URI* = string

proc getIndex(uri: URI, ch: char): int =
    var i = 0
    while (uri[i] != ch):
        i += 1
    return i


proc getProto*(uri: URI): string = 
    if not strutils.contains(uri, "://") or uri == "":
        return ""
    
    let endingProto = getIndex(uri, ':')
    
    return uri[0 ..< endingProto]


proc deleteProto*(uri: var URI) =
    let proto = getProto(uri) & "://"
    uri = strutils.replace(uri, proto)

proc getHost*(uri: URI): string =
    if uri == "":
        return ""

    var uriTmp = uri
    if getProto(uri) != "":
        deleteProto(uriTmp)
    
    let portStartIndex = getIndex(uriTmp, ':')
    
    
    return uriTmp[0 .. portStartIndex]

proc deleteHost*(uri: var URI) =
    let host = getHost(uri)
    uri = strutils.replace(uri, host)


proc getPort*(uri: URI): string =
    if uri == "":
        return ""
    
    
    var uriTmp = uri 
    deleteProto(uriTmp)
    deleteHost(uriTmp)
    
    let segStart = getIndex(uriTmp, '/')
    return uriTmp[0 ..< segStart]

proc deletePort*(uri: var URI) =
    let port = getPort(uri)
    uri = strutils.replace(uri, port)

proc getSegmentsAsString*(uri: URI): string =
    if uri == "":
        return ""
    
    var uriTmp = uri
    deleteProto(uriTmp)
    deleteHost(uriTmp)
    deletePort(uriTmp)
    
    return uriTmp

proc getSegmentsAsSeq*(uri: URI): seq[string] =
    if uri == "":
        return @[""]
    
    return strutils.split(getSegmentsAsString(uri[2 .. ^1]), '/')