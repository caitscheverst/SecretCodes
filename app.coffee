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

# getting the index page just gets the home page.
app.get '/', express.static(__dirname + '/static/index.html')

# getting a query (with a query attached to it) returns the html results of
# that query.
app.get '/query/:query', (req, res) ->
    q = req.params.query
    console.log q if logging

    # go through each one until we find one that passes
    for name, tester of identifiers
        results = tester.attempt(q) 
        if results[0] == "success"
            res.writeHead(200, 'Content-Type': 'text/html')  # 200 OK
            str = fs.readFileSync('views/main.ejs', 'utf8');
            r = results[1]
            html = ejs.render(str, a_an: r.a_an, name: r.name, longName: r.longName, parts: r.data())
            res.end(html)
            return

    # if all those fail, error out
    res.writeHead(200, 'Content-Type': 'text/html')  # 204 No Content
    str = fs.readFileSync('views/nope.ejs', 'utf8');
    html = ejs.render(str, { input: q })
    res.end(html)
    return

# run, you fools
app.listen(process.env.PORT || 2345)
