node_static = require("node-static")

#
# Create a node-static server instance to serve the './public' folder
#
file = new node_static.Server("./public")

#
# Serve files!
#
require("http").createServer((request, response) ->
  request.addListener("end", ->
    file.serve request, response
  ).resume()
).listen 8080