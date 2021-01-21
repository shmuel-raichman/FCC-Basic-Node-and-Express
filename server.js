// B"H
 
var myApp = require('./myApp');
var express = require('express');
var app = express();

var port = process.env.PORT || 3000;

app.use('/', myApp);
app.listen(port, () => console.log('App listening on port ', port));

