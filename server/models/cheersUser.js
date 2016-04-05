var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var CheersUserSchema  = new Schema(
    {
  firstName: String,
  lastName: String, 
  password: String,
  email: String,
  username: String,
  friendsList : [String],
  status: Boolean,
  pendingEvents: [String],
  acceptedEvents: [String]
});

mongoose.model('cheersUser', CheersUserSchema);

