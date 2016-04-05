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