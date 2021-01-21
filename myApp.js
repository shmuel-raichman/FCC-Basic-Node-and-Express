// B"H
var express = require('express');
var app = express();
const bodyParser = require('body-parser');

const dotenv = require('dotenv');
dotenv.config();
// --> 7)  Mount the Logger middleware here
app.use( function(req, res, next) {
  console.log(`${req.method} ${req.path} - ${req.ip}`);
  next();
});

// --> 11)  Mount the body-parser middleware  here
app.use( bodyParser.urlencoded({extended: false}) );

/** 1) Meet the node console. */
console.log("Hello World");

/** k8s health */
app.get( '/health', function(req, res) {
  res.status(200).json({"status:": "up"});
});

/** 2) A first working Express Server */
app.get( '/str', function(req, res) {
  res.send('Hello Express');
});

/** 3) Serve an HTML file */
let absoluteIndexHtmlPath = __dirname + "/static/views/index.html";
let publicDirPath = __dirname + "/static/public";
app.get( '/', function(req, res) {
  res.sendFile(absoluteIndexHtmlPath);
});

/** 4) Serve static assets  */
app.use(express.static(publicDirPath));

/** 5) serve JSON on a specific route */
let jsonObject = {"message": "Hello json"}


/** 6) Use the .env file to configure the app */
function isUpper(){
  if( process.env.MESSAGE_STYLE == "uppercase"){
    jsonObject.message = jsonObject.message.toUpperCase();
    return Object.assign({}, jsonObject);
  }else {
    return jsonObject;
  }
}

app.get( '/json', (req, res) => res.send(isUpper()));
/** 7) Root-level Middleware - A logger */
//  place it before all the routes !
// Done

/** 8) Chaining middleware. A Time server */
app.get('/now', (req, res, next) => { 
   //let reqTime = { time: req.time = new Date }
   req.time = new Date().toString();
   next();
  },
   (req, res) => res.send({time: req.time})
);

/** 9)  Get input from client - Route parameters */
app.get('/:word/echo', (req, res) => {
  res.send({echo: req.params.word});
});

/** 10) Get input from client - Query parameters */
// /name?first=<firstname>&last=<lastname>
// alidate request
function nameGet(req, res){
  if(req.query.last && req.query.first){
    res.status(200).json({name: req.query.first + " " + req.query.last});
  }else{
    res.status(500).json({err: 'worng'});
  }
}

app.route('/name').get( (req, res) => { nameGet(req, res) });
  
/** 11) Get ready for POST Requests - the `body-parser` */
// place it before all the routes !

// Done
/** 12) Get data form POST  */

function namePost(req, res){
  if(req.body.last && req.body.first){
    res.status(200).json({name: req.body.first + " " + req.body.last});
  }else{
    res.status(500).json({err: 'worng'});
  }
}
app.route('/name').post( (req, res) => { namePost(req, res) }); 

function unitTest(){
  return true
}

// This would be part of the basic setup of an Express app
// but to allow FCC to run tests, the server is already active
/** app.listen(process.env.PORT || 3000 ); */

//---------- DO NOT EDIT BELOW THIS LINE --------------------

 module.exports = app;

