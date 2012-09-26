# draws a Bezier curve from the bottom midpoint of `$top` to the top midpoint
# of `$bottom` on the specified canvas.
connect = ($top, $bottom, $canvas, colour) ->

    # calculate top position
    top_x = $top.offset().left + ($top.width() / 2) - $canvas.offset().left + 4
    top_y = $top.offset().top  + $top.height()      - $canvas.offset().top  + 6
    
    # calculate bottom position
    bottom_x = $bottom.offset().left + ($bottom.width() / 2) - $canvas.offset().left + 4
    bottom_y = ($bottom.offset().top  - $canvas.offset().top)

    # set up canvas nonsense    
    context = $canvas.get(0).getContext("2d")
    context.lineWidth = 2
    context.strokeStyle = colour
    context.beginPath()
    
    # the "sharpness" of the curve is an absolute value, rather than a
    # relative one; to have the same shape curve every time, it needs to
    # be relative to the size of the curve itself.
    sharpness = (bottom_y - top_y) / 1.618
    
    context.moveTo(top_x, top_y)         # start
    context.bezierCurveTo(
        top_x, top_y + sharpness,        # first bezier point
        bottom_x, bottom_y - sharpness,  # second bezier point
        bottom_x, bottom_y               # final destination
    )
    context.stroke()                     # finish

# what colour is the sky in your world?
worlds = {
    first: "#718c00"
    second: "#4271ae"
    third: "#c82829"
    data: "#000"
    checksum: "#999"
}

# function to draw the bezier lines on the canvas. When it's run, the canvas
# element should have just been created (inserted into the #results div on the
# page), which is why it's created anew here.
drawBeziers = ->
    $canvas = $('#canvas')

    # todo: there can only be one colour per set; this is problematic with
    # two things, both called 'data'
    for id, colour of worlds

        # dynamically create jQuery selectors. there's probably a better way
        # to do this, but.
        $hither  = $("#explanation .#{id}")
        $thither = $("#bits .#{id}")

        # not all these are guaranteed to exist - don't do anything if they're
        # not actually present
        if $hither.length and $thither.length   # using `.length` to mean `== null`
            connect $hither, $thither, $canvas, colour
          
# list of examples
arbits = [
    "978-18-53260865",     # ISBN
    #"u4pruydqqvj",         # Geohash
    "123456789999",        # UPC-A barcode
    #"2001:db8:85a3::8a2e:370:7334",  # IPv6
    "192.168.0.0/24",      # CIDR
    "01:23:45:67:89:ab",   # MAC address
    #"InChI=1S/CH4/h1H4",   # IUPAC standard InChI
    "f47ac10b-58cc-4372-a567-0e02b2c3d479",  # UUID
    #"00012345678905",      # GTIN-12
    #"S-1-5-21-3623811015-3361044348-30300820-1013",  # Security Identifier
    #"0002-8231(199412)45:10<737:TIODIM>2.3.TX;2-M",  # SICI
    #"BBIP87654321/AB12C",  # UK Migration Authorisation Code
    "A02-2009-000004BE-A", # ISTC
    #"ESNTPB",              # ISO 10962
    #"331.04136",           # Dewey Decimal notation
    #"3055-00-721-4790"     # NATO Stock Number
]

# get a random example when clicking the random button
$('#random').click (e) ->
    $('#code').val arbits[Math.floor(Math.random() * arbits.length)]

# function to fetch html-formatted results via ajax
getResults = (query) ->
    document.title = "#{query} - Secret Codes"
    
    # initially, fade the results out. then, change the results to the
    # throbber background, and use that until the results come in.
    $('#results').fadeOut 600, (done) ->
        $('#results').html("").addClass('loading').fadeIn(800)
    $.ajax
        url: "/query/" + query,
        cache: false,
        success: (data, textStatus, jqXHR) ->
            $('#results').html(data)
            $('#results').stop().removeClass('loading').css(opacity: 1)
            drawBeziers()
        error: (jqXHR, textStatus, errorThrown) ->
            $('#results').html("Error: #{textStatus} + #{errorThrown}")
            $('#results').stop().removeClass('loading').css(opacity: 1)

# update the page when clicking the update the page button
$('#submit').click (e) ->
    query = $('#code').val()

    # push a new history state with the query as data.    
    # the backslash removes any forward slashes added by any previous queries
    history.pushState { query: query }, "", '\\' + query
    getResults(query)

# when clicking back, replace the results with those from an older query
window.onpopstate = (e) ->
    getResults(e.state.query) if e.state.query?

# if there's an #explanation tag, then it means that the page has been
# generated with results already in it. if so, call the function to draw the
# beziers (they aren't drawn automatically)
if $('#explanation').length
    drawBeziers()