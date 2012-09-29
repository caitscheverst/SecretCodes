fs = require 'fs'

class MAC
    a_an: "a"
    name: "MAC Address"
    longName: ""
    
    constructor: (@o) ->
    
    getData: (callback) ->
        prefix = [@o[0], @o[1], @o[2]].join(':')
        @getVendor (vendor) =>
            callback [
                { cls: "first", words: prefix, title: "Organisationally-Unique Identifier", meaning: "<tt>#{prefix}</tt> = #{vendor}" }
                { cls: "background", words: ":" }
                { cls: "data", words: [@o[3], @o[4], @o[5]].join(':'), title: "Identifier", meaning: "" }
            ]
            
    @attempt: (string) ->
        re = /// ^
            ( [0-9A-Fa-f]{2} )       # First octet
            (?:                        # Five groups comprise the rest:
                :                      # Colon (separator)
                ( [0-9A-Fa-f]{2} )     # Another octet
            ){5} 
        $ ///
        if (matches = re.exec(string))
            ["success", new MAC(string.split(':'))]
        else
            ["failure", "Didn't match regexp"]
            
    @prefixDict: null
    
    getVendor: (callback) ->
        firstThreeOctets = [@o[0], @o[1], @o[2]].join('')
        if MAC.prefixDict?
            callback MAC.prefixDict[firstThreeOctets]
        else
            fs.readFile 'data/oui.txt', (err, data) ->
                lines = data.toString().split("\n")
                dict = {}
                re = /^([0-9A-F]{6}) (.+)/
                for line in lines
                    if (matches = re.exec(line))
                        dict[matches[1]] = matches[2]
                    else
                MAC.prefixdict = dict
                callback dict[firstThreeOctets]

module.exports =
    MAC: MAC