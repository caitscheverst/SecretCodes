class MeyersBriggs
    a_an: "an"
    name: "MBTI"
    longName: "Meyers-Briggs Type Indicator&reg;"
    
    constructor: (@a, @p, @j, @l) ->
        @attitude   = {E: "Extraversion", I: "Intraversion"}[@a]
        @perceiving = {S: "Sensing", N: "Intuition"}[@p]
        @judging    = {T: "Thinking", F: "Feeling"}[@j]
        @lifestyle  = {J: "Judging", P: "Perception"}[@l]
        
    getData: (callback) -> callback [
        { cls: "first", words: @a, title: "Attitude", meaning: @attitude }
        { cls: "second", words: @p, title: "Perceiving", meaning: @perceiving }
        { cls: "third", words: @j, title: "Judging", meaning: @judging }
        { cls: "data", words: @l, title: "Lifestyle", meaning: @lifestyle }
    ]
        
    @attempt: (string) ->
        re = /// ^
            ( [EI] )   # Attitude
            ( [SN] )   # Perceiving
            ( [TF] )   # Judging
            ( [JP] )   # Lifestyle
        $ ///
        if (matches = re.exec(string))
            ["success", new MeyersBriggs(matches[1], matches[2], matches[3], matches[4])]
        else
            ["failure", "Didn't match regexp"]

module.exports =
    MeyersBriggs: MeyersBriggs