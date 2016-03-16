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
    var user = new User(req.body);
    user.save(function(err){
        if (err) {
            res.send('Error occurred');
            return console.log(err);
        }
        res.send(user);
    });
}