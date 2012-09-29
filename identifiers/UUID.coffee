class UUID
    a_an: "a"
    name: "UUID"
    longName: "Universally Unique Identifier"
    
    constructor: (@before, @during, @after) ->
        @which = switch @during
            when "1" then "MAC Address"
            when "2" then "DCE Security"
            when "3" then "MD5 Hash"
            when "4" then "Randomly-generated"
            when "5" then "SHA1 Hash"
    
    getData: (callback) -> callback [
        { cls: "first", words: @before, title: "Data", meaning: "" }
        { cls: "second", words: @during, title: "Variant", meaning: "<tt>#{@during}</tt> = #{@which}" }
        { cls: "third", words: @after, title: "Data", meaning: "" }
    ]
    
    @attempt: (string) ->
        re = /// ^
            (                      # The first two groups are just data
                [0-9A-Fa-f]{8} -    # One of eight
                [0-9A-Fa-f]{4} -    # One of four
            )
            ( [0-9A-Fa-f] )        # The first character of group 3 specifies the creation procedure
            (                      # The other groups are juts data
                [0-9A-Fa-f]{3} -    # Group of four, minus one for the other character
                [0-9A-Fa-f]{4} -    # Group of four
                [0-9A-Fa-f]{12}     # One last group of twelve
            )
        $ ///
        if (matches = re.exec(string))
            ["success", new UUID(matches[1], matches[2], matches[3])]
        else
            ["failure", "Didn't match regexp"]

module.exports =
    UUID: UUID