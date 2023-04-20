const http = require('http');

const hostname = '127.0.0.1';
const port = 3000;

const htmlFileContent = require('fs').readFileSync('./cute-cat.html');

const server = http.createServer((_req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/html');
  res.end(htmlFileContent);
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
}); 
