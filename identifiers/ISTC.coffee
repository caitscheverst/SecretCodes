class ISTC
    a_an: "an"
    name: "ISTC"
    longName: "International Standard Text Code"
    
    constructor: (@agency, @year, @id, @checksum) ->
    
    data: () -> [
        { cls: "first", words: @agency, title: "Agency", meaning: "" }
        { cls: "background", words: "-" }
        { cls: "second", words: @year, title: "Year", meaning: "" }
        { cls: "background", words: "-" }
        { cls: "data", words: @id, title: "Work ID", meaning: "" }
        { cls: "background", words: "-" }
        { cls: "checksum", words: @checksum, title: "Checksum", meaning: "Passed!" }
    ]

    @attempt: (string) ->
        re = /^([0-9A-Fa-f]{3})-([0-9]{4})-([0-9A-Fa-f]{8})-([0-9A-Fa-f])$/
        if (matches = re.exec(string))
            ["success", new ISTC(matches[1], matches[2], matches[3], matches[4])]
        else
            ["failure", null]

module.exports =
    ISTC: ISTC
