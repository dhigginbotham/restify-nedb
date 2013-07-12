ds = require "./"
Schema = ds.Schema

cache = [
  new Schema
    cheese: "jalepano jack"
    # store: "jalepano-jack", 
  new Schema
    cheese: "pepper jack"
    store: "pepper-jack",
  new Schema
    cheese: "swiss"
    store: "swiss",
  new Schema
    cheese: "american"
    store: "american"
]

# cache = [
#   new Schema
#     cheese: "provolone"
#   new Schema
#     cheese: "muenster"
#   new Schema
#     cheese: "brie"
#   new Schema
#     cheese: "motzeralla"
# ]

for c in cache
  do (c) ->
    ds.insert c, (err, inserted) ->
      return console.log if err? then err else inserted

ds.loadDatabase (err) ->
  ds.find {}, (err, find) ->
    console.log if err? then err else find