class ISBN
    a_an: "an"
    name: "ISBN"
    longName: "International Standard Book Number"
    
    constructor: (@gs1, @group, @publisher, @item, @checksum) ->
    
    getData: (callback) -> callback [
        { cls: "first", words: @gs1, title: "GS1 Prefix", meaning: "" }
        { cls: "background", words: "-" }
        { cls: "second", words: @group, title: "Group ID", meaning: "" }
        { cls: "background", words: "-" }
        { cls: "third", words: @publisher, title: "Publisher ID", meaning: "" }
        { cls: "data", words: @item, title: "Book ID", meaning: "" }
        { cls: "checksum", words: @checksum, title: "Checksum", meaning: "" }
    ]
    
    @attempt: (string) ->
        re = /// ^
            ( [0-9]{3} ) -   # GS1 Prefix
            ( [0-9]{2} ) -   # Group ID
            ( [0-9]{4} )     # Publisher ID
            ( [0-9]{3} )     # Book ID
            ( [0-9] )        # Checksum digit
        $ ///
        if (matches = re.exec(string))
            ["success", new ISBN(matches[1], matches[2], matches[3], matches[4], matches[5])]
        else
            ["failure", "Didn't match regexp"]
            
module.exports =
    ISBN: ISBN