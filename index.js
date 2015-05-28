var express = require('express'),
    app = express(),
    fs = require('fs'),
    path = require('path'),
    script = fs.readFileSync(path.resolve(__dirname, 'install.sh'), { encoding: 'utf8' });

app.get('/', function (req, res, next) {
  res.set('Content-Type', 'text/plain');
  res.send(script);
});

app.get('/:token', function (req, res, next) {
  res.set('Content-Type', 'text/plain');
  res.send(script.replace('accept_token=""', 'accept_token="' + req.params.token + '"'));
});

var server = app.listen(process.env.PORT || 3333, function () {
  var host = server.address().address;
  var port = server.address().port;

  console.log('Spore Install listening at http://%s:%s', host, port);
});
