const http = require("http");

const port = process.env.PORT || 8080;

const server = http.createServer((req, res) => {
    console.log(`${new Date().toISOString()} ${req.method} ${req.url}`);

    if (req.url === "/health") {
        res.writeHead(200, { "Content-Type": "application/json" });
        return res.end(JSON.stringify({ status: "healthy" }));
    }

    res.writeHead(200, { "Content-Type": "text/html" });
    res.end(`
        <h1>SRE Azure Lab</h1>
        <p>Application successfully deployed to Azure.</p>
    `);
});

server.listen(port, () => {
    console.log(`SRE Azure Lab running on port ${port}`);
});