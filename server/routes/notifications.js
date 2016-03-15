var mongoose = require('mongoose'),
	User = mongoose.model('users')


/**
 * Get Todos Listing
 */
exports.index  = function(req,res){
    User.find( function(err, todo) {
        if (err) return res.render('Error occurred');
        res.send(todo);
    });
};

exports.findById = function(req,res){
    User.findById( req.params.id, function( err, todo ) {
            if (err) {
                res.send('Error occurred');
                return console.log(err);
            }
            res.send(todo);
    });
};

exports.newUser = function(req,res){
    console.log("This is request!");
    console.log(req);
    console.log("This is request.body");
    console.log(req.body);
    var user = new User(req.body);
    console.log("this is user");
    console.log(user);

    user.save(function(err){
        if (err) {
            res.send('Error occurred');
            return console.log(err);
        }
        res.send(user);
    });
}