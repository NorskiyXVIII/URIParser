import URI/parsing
import std/strformat

when isMainModule:
    var url: parsing.URI = "http://150.241.74.54/mosos"
    
    echo fmt"protocol = {url.getProto()}"
    echo fmt"ip = {url.getHost()}"
    echo fmt"port = {url.getPort()}"
    echo fmt"segm = {url.getSegmentsAsString()}"
