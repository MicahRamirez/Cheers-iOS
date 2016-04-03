var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var DrinkEvent  = new Schema(
    {
  eventName: String,
  organizer: String, 
  location: String,
  date: String,
  attendingList: [String],
  invitedList : [String]
});

mongoose.model('drinkEvent', DrinkEvent);
