function convert() {
    let input = document.getElementById("markdownInput").value;

    document.getElementById("output").innerHTML = "Processing...";

    fetch('/convert', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ text: input })
    })
    .then(res => res.text())
    .then(data => {
        document.getElementById("output").innerHTML = data;
    });
}