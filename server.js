const http = require('http');
const express = require('express');
const MessagingResponse = require('twilio').twiml.MessagingResponse;
const bodyParser = require('body-parser');
const mongoose = require('mongoose');

const app = express();
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());


/* Connect to database
const dbName = {{name}};
const dbUser = {{user}};
const dbPassword = {{password}};
*/

mongoose.connect('mongodb://'+dbUser+':'+dbPassword+'@ds137581.mlab.com:37581/'+dbName);


/* Callback for database connection */
var db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function() {
  console.log('connected to database');
});


/* Establish Schema */
var announcementSchema = mongoose.Schema({
  date: String,
  from: String,
  message: String
});

var Announcement = mongoose.model('Announcement', announcementSchema);


/* 
	Twilio redirect endpoint. 
	Example response back to Twilio:
	{ 
		ToCountry: 'US',
		ToState: 'CA',
		SmsMessageSid: 'SM4be94456ced27368aa4d3438c7493abf',
		NumMedia: '0',
		ToCity: 'DANVILLE',
		FromZip: '60173',
		SmsSid: 'SM4be94456ced27368aa4d3438c7493abf',
		FromState: 'IL',
		SmsStatus: 'received',
		FromCity: 'ITASCA',
		Body: 'test',
		FromCountry: 'US',
		To: '+19258544198',
		MessagingServiceSid: 'MGf6f39a122984fcc3038e486eb9a4437b',
		ToZip: '94506',
		NumSegments: '1',
		MessageSid: 'SM4be94456ced27368aa4d3438c7493abf',
		AccountSid: 'ACdb4d498c8aded79e2c4dde43e8939f96',
		From: '+18477735485',
		ApiVersion: '2010-04-01' 
	}

  */
app.post('/sms', (req, res) => {
	/* Create Message and save to database*/
	console.log("message received");
	var date = new Date();
	var message = new Announcement({
		date: "(" + (date.getMonth()+1) + "/" + date.getDate() + ", " + date.toLocaleTimeString() + ")",
		from: req.body.From,
		message: req.body.Body
	});
	console.log("date: " + message.date + ", from: " + message.phone_num + ", message: "+ message.message);
	message.save(function (err) {
    	if (err) return console.error(err);
    	console.log("message saved to database!")
  	});
  
	/* Construct response back to Twilio API */
	const twiml = new MessagingResponse();

	twiml.message('The Robots are coming! Head for the hills!');

	res.writeHead(200, {'Content-Type': 'text/xml'});
	res.end(twiml.toString());
});

http.createServer(app).listen(3000, () => {
  console.log('Express server listening on port 3000');
});