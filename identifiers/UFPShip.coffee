class UFPShip
    a_an: "an"
    name: "UFP Registry"
    longName: "United Federation of Planets Vessel Registry Code"
    
    constructor: (@prodtype, @serial, @lineage) ->
        
    getData: (callback) -> callback [
        { cls: "first", words: @prodtype, title: "Production Type", meaning: "Proto-, Test or Production Type" }
        { cls: "second", words: @serial, title: "Serial Number", meaning: "" }
        { cls: "third", words: @lineage, title: "Lineage" , meaning: "Nth ship to bear the name." }
    ]
        
    @attempt: (string) ->
        re = /// ^
            ( [N,C,X,n,c,x]{2,3} )
			-
            ( [0-9]* )
			[\-]?			
            ( [A-Z]{0,1} )
        $ ///
        if (matches = re.exec(string))
            ["success", new UFPShip(matches[1], matches[2], matches[3])]
        else
            ["failure", "Didn't match regexp"]

module.exports =
    UFPShip: UFPShip