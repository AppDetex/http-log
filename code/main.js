const url = require('url')
const http = require('http')
const app = http.createServer((req, resp) => {

	if ('POST' === req.method) {
		let body = '';
		req.on('data', chunk => {
			body += chunk.toString();
		});

		req.on('end', () => {
			console.log('Received data: ' + body)
		});
	}
	console.log('Request for: ' + req.url)
	resp.writeHead(200, {"Content-Type": "text/html"});
	resp.write('<p>Received a request</p>');
	resp.end();
});

app.listen(8080);
