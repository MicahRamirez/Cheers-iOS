/**
 * Module dependencies.
 */

//Defining variables
var express = require('express')
  , mongoose = require('mongoose')
  , http = require('http')
  , path = require('path')
    , drinkEvent = require('./models/drinkEvent')
    , drinkEventRoutes = require('./routes/drinkEventRoutes')
    , usersModel = require('./models/users')
    , usersRoute = require('./routes/notifications')
    , cheersUser = require('./models/cheersUser')
    , cheersUserRoute = require('./routes/cheersUser')
    , bodyParser = require('body-parser')
    , logger = require('morgan')
    , favicon = require('serve-favicon')
    , methodOverride = require('method-override')
    , errorHandler = require('errorhandler')
    , multer = require('multer')
    , session = require('express-session') 

var app = express();

// all environments
// configuring server env
app.set('port', process.env.PORT || 3000);
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended : true}));
app.use(logger('dev'));
app.use(methodOverride());

// when dev use error handler
if ('development' == app.get('env')) {
  app.use(errorHandler());
}

var uriString =
    process.env.MONGOLAB_URI ||
        process.env.MONGOHQ_URL ||
        'mongodb://localhost/HelloMongoose';

// Connection to mLab
mongoose.connect('mongodb://micah:micah1991@ds013901.mlab.com:13901/alamofire-db');

//setting up the connect to mongo DB
var db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function callback () {
   console.log('Successfully mongodb is connected');
});


/**
* CheersUser Routes
*/
app.post('/user_create', cheersUserRoute.newUser);
//hook for authentication (Not secure)
// the :<string> syntax designates those parameters in the get request url... Example request:
//  get (herokuserver.app/login/<username>/<password>)
app.get('/login/:username/:password', cheersUserRoute.validateUser);
app.get('/cheers_user/exists/:username', cheersUserRoute.checkUserExists);
app.get('/query_friend/', cheersUserRoute.queryFriend);
app.post('/fl_query/', cheersUserRoute.queryFriendsList);
app.post('/update_status/', cheersUserRoute.updateStatus);
app.post('/add_friend/', cheersUserRoute.addFriend);
app.post('/update_pending_event/', cheersUserRoute.updatePendingEventOnUser);



/**
* DrinkEvent Routes
*/
app.post('/add_drink_event/', drinkEventRoutes.createDrinkEvent);
app.post('/add_attendee/', drinkEventRoutes.addAttendee);

//create server and listen on it
var server = http.createServer(app);
server.listen(app.get('port'), function(){
  console.log('Express server listening on port ' + app.get('port'));
});