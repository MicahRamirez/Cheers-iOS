var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var DrinkEventSchema  = new Schema(
    {
  creatorUsername: String,
  location: String, 
  time: String,
  locationAddress: String,
  usersAttending : [{username:String}]
});

mongoose.model('drinkEvent', DrinkEventSchema);