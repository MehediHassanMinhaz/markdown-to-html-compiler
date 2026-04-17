const express = require('express');
const fs = require('fs');
const { exec } = require('child_process');

const app = express();
app.use(express.json());
app.use(express.static('public'));

app.post('/convert', (req, res) => {
    const input = req.body.text;

    // save input
    fs.writeFileSync('input.txt', input);

    // run flex+bison program
	exec('type input.txt | md2html\\app.exe', (err, stdout, stderr) => {
		if (err) {
			console.error(err);
			console.error(stderr);
			return res.send(stderr);
		}
        res.send(stdout); // send output back
	});
});

app.listen(3000, () => {
    console.log("Server running at http://localhost:3000");
});