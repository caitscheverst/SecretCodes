class IPv4
    a_an: "an"
    name: "IPv4 Address"
    longName: ""
    
    constructor: (@o) ->
    
    getData: (callback) -> callback [
        { cls: "first", words: @o.join('.'), title: "IP Address", meaning: "" }
    ]
    
    @attempt: (string) ->
        re = /// ^
            ( [0-9]{1,3} ) \.
            ( [0-9]{1,3} ) \.
            ( [0-9]{1,3} ) \.
            ( [0-9]{1,3} )
        $ ///
        if (matches = re.exec(string))
            if parseInt(matches[1]) <= 255 and parseInt(matches[2]) <= 255 and
               parseInt(matches[3]) <= 255 and parseInt(matches[4]) <= 255
                ["success", new IPv4(string.split '.')]
            else
                ["failure", "Numbers out of range"]
        else
            ["failure", "Didn't match regexp"]
            
module.exports =
    IPv4: IPv4
