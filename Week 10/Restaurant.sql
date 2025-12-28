db.createCollection("Restaurant");

db.Restaurant.insertMany([
{name:"Meghna Foods",town:"Jayanagar", cuisine: "Indian", score: 8, address: { zipcode: "10001",street: "Jayanagar"}},
{ name: "Empire", town: "MG Road", cuisine: "Indian", score: 7, address: { zipcode: "10100",street: "MG Road" } },
{ name: "Chinese WOK", town: "Indiranagar", cuisine: "Chinese", score: 12, address: { zipcode:"20000", street: "Indiranagar"}},
{ name: "Kyotos", town: "Majestic", cuisine: "Japanese", score: 9, address: { zipcode: "10300",street: "Majestic" } },
{ name: "WOW Momos", town: "Malleshwaram", cuisine: "Indian", score: 5, address: { zipcode:"10400", street: "Malleshwaram" }}]);

db.Restaurant.find().sort({ "name": -1 });

db.Restaurant.find({ "grades.score": { $lte: 10 } },{ _id: 1, name: 1, town: 1, cuisine: 1, restaurant_id: 1 });

db.restaurants.aggregate([ { $group: { _id: "$name", average_score: { $avg: "$score" }}}]);

db.restaurants.find({ "address.zipcode": /^10/ }, { name: 1, "address.street": 1, _id: 0 });
