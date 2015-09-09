var express = require('express'),
    app = express(),
    fs = require('fs'),
    path = require('path'),
    installScript = fs.readFileSync(path.resolve(__dirname, 'install.sh'), { encoding: 'utf8' }),
    uninstallScript = fs.readFileSync(path.resolve(__dirname, 'uninstall.sh'), { encoding: 'utf8' });

app.get('/', function (req, res, next) {
  res.set('Content-Type', 'text/plain');
  res.send(installScript);
});

app.get('/uninstall(.sh)?', function (req, res, next) {
  res.set('Content-Type', 'text/plain');
  res.send(uninstallScript);
});

app.get('/:token', function (req, res, next) {
  // remove non-token characters
  var token = req.params.token.replace(/[^a-zA-Z0-9]/g, "");

  res.set('Content-Type', 'text/plain');
  res.send(installScript.replace('accept_token=""', 'accept_token="' + token + '"'));
});

var server = app.listen(process.env.PORT || 3333, function () {
  var host = server.address().address;
  var port = server.address().port;

  console.log('Spore Install listening at http://%s:%s', host, port);
});
