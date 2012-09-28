# node requires
http = require 'http'
fs = require 'fs'
ejs = require 'ejs'

# express requires
express = require 'express'

# log every query to the console
logging = true

# loop through the identifiers folder, loading classes in turn.
identifiers = {}
for file in fs.readdirSync('identifiers')
    lib = require "./identifiers/#{file}"
    for name, tester of lib
        console.log "Loaded #{name} (#{tester.name}) from #{file}"
        identifiers[name] = tester

# set up our application
app = express()
app.use express.static(__dirname + '/static')

# gets a result, and formats it as HTML from the views
getResultHTML = (q, callback) ->
    r = null
    
    for name, tester of identifiers
        results = tester.attempt(q) 
        if results[0] == "success"
            str = fs.readFileSync('views/main.ejs', 'utf8')
            r = results[1]
            break

    
    if r != null
        r.getData (result) ->
            data = { a_an: r.a_an, name: r.name, longName: r.longName, parts: result }
            callback(ejs.render(str, data))

    # if all those fail, error out
    else
        fs.readFile 'views/nope.ejs', 'utf8', (err, str) ->
            html = ejs.render(str, { input: q })
            callback(html)

# getting a query (with a query attached to it) returns the html results of
# that query.
app.get /^\/query\/(.+)$/, (req, res) ->
    q = req.params[0]
    console.log q if logging

    getResultHTML q, (result) ->
        res.writeHead(200, 'Content-Type': 'text/html')
        res.end(result)

# getting the index page with a query gets the home page with results already
# inserted into it.
app.get /^\/(.+)$/, (req, res) ->
    res.writeHead(200, 'Content-Type': 'text/html')

    getResultHTML req.params[0], (result) ->
        html = fs.readFileSync('static/index.html', 'utf8')
        html = html.replace '<div id="results"></div>', '<div id="results">' + result + '</div>'  # insert the results into the div
        html = html.replace 'value=""', 'value="' + req.params[0] + '"'  # insert the query into the text input box
        html = html.replace '<title>', '<title>' + req.params[0] + ' - '  # insert the query into the text input box
        res.end(html)

# getting the index page just gets the home page.
app.get '/', express.static(__dirname + '/static/index.html')

# run, you fools
app.listen(process.env.PORT || 2345)
