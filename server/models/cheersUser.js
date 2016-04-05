var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var DrinkEvent = require('./drinkEvent');

var CheersUserSchema  = new Schema(
    {
  firstName: String,
  lastName: String, 
  password: String,
  email: String,
  username: String,
  friendsList : [String],
  status: Boolean,
  pendingEvents: [DrinkEvent],
  acceptedEvents: [DrinkEvent]
});

mongoose.model('cheersUser', CheersUserSchema);

