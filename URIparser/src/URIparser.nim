import uri/uri

when isMainModule:
    let url: uri.URI = "http://150.241.74.54/mosos"
    echo url.format(", ", "", startIndent = " ", inline = true)
    let url2: uri.URI = "https://google.com/policy&val=30#start"
    echo url2.format(sep = "\n", indent = "\t", startIndent = "",
    domain = true, path = true, query = true, fragments = true)
    