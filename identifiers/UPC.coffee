class UPC
    a_an: "a"
    name: "UPC"
    longName: "Universal Product Code"
    
    constructor: (@code, @item, @checksum) ->
    
    data: () -> [
        { cls: "first", words: @code, title: "Item Group", meaning: "" }
        { cls: "data", words: @item, title: "Item Number", meaning: "" }
        { cls: "checksum", words: @checksum, title: "Checksum", meaning: "" }
    ]
    
    @attempt: (string) ->
        re = /^([0-9])([0-9]{10})([0-9])$/
        if (matches = re.exec(string))
            ["success", new UPC(matches[1], matches[2], matches[3])]
        else
            ["failure", null]
            
module.exports =
    UPC: UPC