const http = require('http');

const url = new URL('http://localhost:4567/submit');
const postData = new URLSearchParams({
  amount: 200,
  'destination-account': '222'
});

const req = http.request({
  method: 'POST',
  protocol: url.protocol,
  host: url.hostname,
  path: url.pathname,
  port: url.port,
  headers: {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Referer': 'fakereferrer.com',
    'Content-Length': Buffer.byteLength(postData.toString())
  }
}, function(res) {
  res.on('data', function(data) {
    console.log('Response', data)
  });

  res.on('end', function() {
    console.log(res.headers);
  });
});

req.write(postData.toString());
req.on('error', function(err) {
  console.log(err);
});
req.end();
