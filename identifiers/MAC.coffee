class MAC
    a_an: "a"
    name: "MAC Address"
    longName: ""
    
    constructor: (@o) ->
    
    data: () ->
        prefix = [@o[0], @o[1], @o[2]].join(':')
        [
            { cls: "first", words: prefix, title: "Vendor", meaning: "The first three octets identify the hardware vendor.<br /><tt>#{prefix}</tt> = Cisco" }
            { cls: "background", words: ":" }
            { cls: "data", words: [@o[3], @o[4], @o[5]].join(':'), title: "Identifier", meaning: "The last three octets are machine-specific." }
        ]
        
    @attempt: (string) ->
        re = /^([0-9A-Fa-f]{2})(?::([0-9A-Fa-f]{2})){5}$/
        if (matches = re.exec(string))
            ["success", new MAC(string.split(':'))]
        else
            ["failure", null]

module.exports =
    MAC: MAC