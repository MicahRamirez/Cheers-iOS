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
    console.log("Request Object");
    console.log(req);
    console.log("Request Params");
    console.log(req.params);
    CheersUser.findOne({'username': req.params.username, 'password' :req.params.password}, function(err, cheersuser){
        if(err){
            res.send('Error occurred');
            return console.log(err);
        }
        res.send(cheersuser);
    });
}