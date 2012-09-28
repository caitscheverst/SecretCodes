# node requires
http = require 'http'
fs = require 'fs'
ejs = require 'ejs'

# express requires
express = require 'express'

# log every query to the console
logging = true

# loop through the identifiers folder, loading classes in turn.
# this is done synchronously, as there's no use doing it asynchronously when
# the web server hasn't been set up yet.
identifiers = {}
for file in fs.readdirSync 'identifiers'
    lib = require "./identifiers/#{file}"
    for name, tester of lib
        console.log "Loaded #{name} (#{tester.name}) from #{file}"
        identifiers[name] = tester

# set up our application
app = express()
app.use express.static(__dirname + '/static')

# gets a result, and formats it as HTML from the views
getResultHTML = (query, callback) ->
    result = null
    
    # loop through every tester until we find one that works.
    # (todo: support for multiple successes)
    for name, tester of identifiers
        [status, data] = tester.attempt query
        
        # success is currently determined by a string instead of a boolean
        # to allow for future expansion (half-successes)
        switch status
            when "success"
                result = data
                break
            when "failure"
                continue
            else
                console.log "Weird status from #{name}: #{status} (data: #{data})"
    
    # if we have a result, then tell the result to format itself.
    if result?
        fs.readFile 'views/main.ejs', 'utf8', (err, str) ->
            result.getData (data) ->
                html = ejs.render str,
                    a_an:     result.a_an,
                    name:     result.name,
                    longName: result.longName,
                    parts:    data
                callback html

    # if all the checks fail, display a "not found" message
    else
        fs.readFile 'views/nope.ejs', 'utf8', (err, str) ->
            html = ejs.render str, input: query
            callback html

# getting a query (with a query attached to it) returns the html results of
# that query.
app.get /^\/query\/(.+)$/, (req, res) ->
    query = req.params[0]
    console.log query if logging

    getResultHTML query, (result) ->
        res.writeHead 200, 'Content-Type': 'text/html'
        res.end result

# getting the index page with a query gets the home page with results already
# inserted into it.
app.get /^\/(.+)$/, (req, res) ->
    res.writeHead 200, 'Content-Type': 'text/html'

    getResultHTML req.params[0], (result) ->
        fs.readFile 'static/index.html', 'utf8', (err, html) ->
            html = html.replace '<div id="results"></div>', '<div id="results">' + result + '</div>'  # insert the results into the div
            html = html.replace 'value=""', 'value="' + req.params[0] + '"'  # insert the query into the text input box
            html = html.replace '<title>', '<title>' + req.params[0] + ' - '  # insert the query into the text input box
            res.end html

# getting the index page just gets the home page.
app.get '/', express.static(__dirname + '/static/index.html')

# run, you fools
app.listen(process.env.PORT || 2345)
