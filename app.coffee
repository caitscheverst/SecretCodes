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
getResultHTML = (q) ->
    for name, tester of identifiers
        results = tester.attempt(q) 
        if results[0] == "success"
            str = fs.readFileSync('views/main.ejs', 'utf8')
            r = results[1]
            data = { a_an: r.a_an, name: r.name, longName: r.longName, parts: r.data() }
            return ejs.render(str, data)

    # if all those fail, error out
    str = fs.readFileSync('views/nope.ejs', 'utf8')
    html = ejs.render(str, { input: q })
    return html

# getting a query (with a query attached to it) returns the html results of
# that query.
app.get '/query/:query', (req, res) ->
    q = req.params.query
    console.log q if logging

    result = getResultHTML(q)
    res.writeHead(200, 'Content-Type': 'text/html')
    res.end(result)

# getting the index page with a query gets the home page with results already
# inserted into it.
app.get '/:query', (req, res) ->
    res.writeHead(200, 'Content-Type': 'text/html')

    result = getResultHTML(req.params.query)
    html = fs.readFileSync('static/index.html', 'utf8')
    html = html.replace '<div id="results"></div>', '<div id="results">' + result + '</div>'  # insert the results into the div
    html = html.replace 'value=""', 'value="' + req.params.query + '"'  # insert the query into the text input box
    res.end(html)

# getting the index page just gets the home page.
app.get '/', express.static(__dirname + '/static/index.html')

# run, you fools
app.listen(process.env.PORT || 2345)
