var mongoose = require('mongoose'),
	DrinkEvent = mongoose.model('drinkEvent')

var test = require('../models/cheersUser');
CheersUser = mongoose.model('cheersUser');
//TEST drinkEvent creation
exports.createDrinkEvent = function(req, res){
	console.log("Creating Drink Event\nRequest Body");
	console.log(req.body);
	var drinkEvent = new DrinkEvent(req.body);
	drinkEvent.save(function(err){
		if(err){
			res.send("err occurred!");
			return console.log(err);
		}
		console.log("Users invited");
		console.log(req.body.invitedList);
		CheersUser.where('username')
			.in(req.body.invitedList)
			.exec(function(err, result){
				console.log("starting for loop");
				console.log("This is Drink Event");
				console.log(drinkEvent);
				for(var user of result){
					CheersUser.findOneAndUpdate({'username' : user.username}, {$push: {pendingEvents:drinkEvent}}, {safe:true, upsert:true}, function(err, cheersuser){
						if(err){
							return console.log(err);
						}
						console.log("Updated CheersUSer!!!!");
						console.log(cheersuser);
					});
				}
			}
		);
		res.send(drinkEvent);
	});
}

//For adding an attendee after the fact
//add attendee will just be pushing the user that is in the request
// expects organizer, eventname, and location to find document
// adds an attendee to the attendingList
exports.addAttendee = function(req, res){
	console.log("Adding Attendee!");
	console.log("Request body: " + req.body);
    DrinkEvent.findOneAndUpdate({'organizer': req.body.organizer,'location':req.body.location, 'eventName':req.body.eventName }, {$push: {attendingList: req.body.attendee}}, {safe:true, upsert:true}, function(err,drinkEvent){
        if(err){
            res.send('Error occurred');
            return console.log(err);
        }
        res.send(drinkEvent);
    });
}



