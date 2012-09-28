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
    
    data: () -> [
        { cls: "first", words: @before, title: "Data", meaning: "" }
        { cls: "second", words: @during, title: "Variant", meaning: "<tt>#{@during}</tt> = #{@which}" }
        { cls: "third", words: @after, title: "Data", meaning: "" }
    ]
    
    @attempt: (string) ->
        re = /^([0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-)([0-9A-Fa-f])([0-9A-Fa-f]{3}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12})$/
        if (matches = re.exec(string))
            ["success", new UUID(matches[1], matches[2], matches[3])]
        else
            ["failure", "Didn't match regexp"]

module.exports =
    UUID: UUID