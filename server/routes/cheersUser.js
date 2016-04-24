var mongoose = require('mongoose'),
	CheersUser = mongoose.model('cheersUser')


exports.newUser = function(req,res){
    var cheersUser = new CheersUser(req.body);
    console.log("Attempting to create new cheers user");
    cheersUser.save(function(err){
        if (err) {
            res.send('Error occurred');
            return console.log(err);
        }
        res.send(cheersUser);
    });
}

exports.validateUser = function(req, res){
    //grabs the parameters from the request and searches the mongoDB using the mongoose findOne function
    CheersUser.findOne({'username': req.params.username, 'password' :req.params.password}, function(err, cheersuser){
        if(err){
            res.send('Error occurred');
            return console.log(err);
        }
        res.send(cheersuser);
    });
}

exports.addFriend = function(req, res){
    //grabs the new friend from the request and pushes it onto this friend
    var userName = req.body.friend;
    CheersUser.findOneAndUpdate({'username': req.body.username}, {$push: {friendsList: userName}}, {safe:true, upsert:true}, function(err,cheersuser){
        if(err){
            res.send('Error occurred');
            return console.log(err);
        }
        res.send(cheersuser);
    });
}

exports.checkUserExists = function(req, res){
    CheersUser.findOne({'username':req.params.username}, function(err,cheersuser){
        if(err){
            res.send('Error occurred');
            return console.log(err);
        }
        if(!cheersuser){
            res.send({'exists':false});
        }else{
            res.send({'exists':true});
        }
    });
}

exports.inviteFriendsToEvent = function(req, res){
    //in Req body we need to have the drinkEvent object passed in!

    CheersUser.where('username').in(req.body.invitedList).exec(function(err, invitedUsers){
            if(err){
                res.send('Error occurred');
                return console.log(err);
            }
            for(user in invitedUsers){
                if(invitedUsers.hasOwnProperty('id')){
                    console.log(user);
                    var user_id = user.id;
                    CheersUser.update({_id, user_id}, {$push: {pendingEvents:req.body.drinkEvent}}, {safe:true, upsert:true}, function(err,cheersuser){
                        if(err){
                            res.send('Error occurred');
                            return console.log(err);
                        }
                        res.send(cheersuser);
                    });

                }
            }
    });
}

exports.queryFriend = function(req, res){
    CheersUser.findOne({'username': req.body.username}, function(err, cheersuser){
        if(err){
            res.send('Error occurred');
            return console.log(err);
        }
        res.send(cheersuser);
    });
}

exports.queryFriendsList = function(req, res){
    CheersUser.where('username').in(req.body.friendsList).
        exec(function(err, cheersuser){
            if(err){
                res.send('Error occurred!');
                return console.log(err);
            }
            console.log(cheersuser);
            res.send(cheersuser);
        });
}

/**
* updateStatus
*   updates the boolean status of the user to the specified value in the req.body
*   HTTP POST
*   PRE : req.body.status type == Bool
*/
exports.updateStatus = function(req, res){

    CheersUser.findOneAndUpdate({'username':req.body.username}, {'status':req.body.status}, function(err, cheersuser){
        if(err){
            res.send('Error occurred!');
            return console.log(err);
        }
        res.send(cheersuser);
    });
}

/**
* updatePendingEventOnUser
*  updates the pending event on a SINGLE user based on params pased in req.body
*  HTTP POST
*  Required Body Params : 
*                   String:   req.body.username (Logged in User)  
*                   String:   req.body.eventName 
*                   String:   req.body.organizer 
*                   Boolean:  req.body.accepted 
*/

exports.updatePendingEventOnUser = function(req, res){
    CheersUser.where('username')
                .in(req.body.username)
                .exec(function(err, cheersuser){
                    //Delete
                    if(err){
                        return console.log(err);
                    }
                    var pendingEvents = cheersuser[0]["pendingEvents"];
                    var matchedEvent = "";
                    //go through each pendingEvent 
                    for(var idx in pendingEvents){
                        //assumming idx is an actual idx since pendingEvents is an arr
                        var event = pendingEvents[idx];
                        //we have the correct event
                        if(event["eventName"] == req.body.eventName && event["organizer"] == req.body.organizer){
                            //SHOULD remove the pending event
                            cheersuser[0]["pendingEvents"].splice(idx, 1);
                            matchedEvent = event;
                        }

                    }

                    //event is either accepted or rejected
                    //remove the event either way but save as tmp
                    if(req.body.accepted){
                        //add to accepted
                        //get our one and only response
                        cheersuser[0]["acceptedEvents"].push(matchedEvent);
                    }
                    CheersUser.where({'username':req.body.username})
                                .setOptions({overwrite: true})
                                .update(cheersuser[0], function(err, cheersuser){
                                    if(err){
                                        return console.log(err);
                                    }
                                    //send back the updated user
                                    res.send(cheersuser);
                                });
                });
}




