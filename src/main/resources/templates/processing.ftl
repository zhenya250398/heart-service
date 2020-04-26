<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>HeartService</title>

</head>
<body onload="init()">
<#list hearts! as heart>
    <img id="loadImg" src="/img/${heart.filename}" style="display:none" alt="alternative">
</#list>
<canvas id="can" width="400" height="300" style="position:absolute;top:10%;left:10%;border:2px solid;">
</canvas>
<div style="position:absolute;top:2%;left:43%;">Choose color</div>
<div id = "green" style="position:absolute;top:5%;left:45%;width:10px;height:10px;background:green;" data-color="green" onclick="getColor(this)"></div>
<div id = "blue" style="position:absolute;top:5%;left:46%;width:10px;height:10px;background:blue;" data-color="blue" onclick="getColor(this)"></div>
<div style="position:absolute;top:5%;left:47%;width:10px;height:10px;background:red;" data-color="red" onclick="getColor(this)"></div>
<div style="position:absolute;top:7%;left:45%;width:10px;height:10px;background:yellow;" data-color="yellow" onclick="getColor(this)"></div>
<div style="position:absolute;top:7%;left:46%;width:10px;height:10px;background:orange;" data-color="orange" onclick="getColor(this)"></div>
<div style="position:absolute;top:7%;left:47%;width:10px;height:10px;background:black;" data-color="black" onclick="getColor(this)"></div>
<div style="position:absolute;top:2%;left:40%;">Eraser</div>
<div style="position:absolute;top:5%;left:40%;width:15px;height:15px;background:white;border:2px solid;" data-color="eraser" onclick="getColor(this)"></div>
<canvas id="canvasimg" style="display:none;"></canvas>
<img id="finalImg" style="position:absolute;top:10%;left:52%;display:none;" >
<input type="button" value="save" id="btn" size="30" onclick="save()" style="position:absolute;top:80%;left:10%;">
<input type="button" value="clear" id="clr" size="23" onclick="erase()" style="position:absolute;top:80%;left:15%;">
</body>

<script type="text/javascript">
    var canvas, canvasimg, backgroundImage, finalImg;
    var	mouseClicked = false;
    var prevX = 0;
    var currX = 0;
    var prevY = 0;
    var currY = 0;
    var fillStyle = "yellow";
    var globalCompositeOperation = "source-over";
    var lineWidth = 2;
    var lines;


    function init() {


        backgroundImage = new Image();
        backgroundImage = document.getElementById('loadImg');
        canvas = document.getElementById('can');
        canvas.width = backgroundImage.width;
        canvas.height = backgroundImage.height;
        finalImg = document.getElementById('finalImg');
        canvasimg = document.getElementById('canvasimg');
        canvas.style.backgroundImage = "url('" + backgroundImage.getAttribute("src") + "')";
        console.log(document.getElementById('loadImg').getAttribute("src"));
        canvas.addEventListener("mousemove", handleMouseEvent);
        canvas.addEventListener("mousedown", handleMouseEvent);
        canvas.addEventListener("mouseup", handleMouseEvent);
        canvas.addEventListener("mouseout", handleMouseEvent);

        //Закрасить область по исходным данным output.csv файла
        var request = new XMLHttpRequest();
        var path = "/out/output.csv";
        request.open("GET", path, false);
        request.send();

        var csvData = new Array();
        var jsonObject = request.responseText.split(/\r?\n|\r/);
        for (var i = 0; i < jsonObject.length; i++) {
            csvData.push(jsonObject[i].split(','));
        }
        console.log(csvData);

        const ctx = canvas.getContext("2d");
        ctx.beginPath();
        ctx.moveTo(csvData[0][1],csvData[0][0]);
        for(var i = 0; i < csvData.length; i++){
            if(i !== 0)
                ctx.lineTo(csvData[i][1],csvData[i][0]);
        }
        ctx.lineTo(csvData[0][1],csvData[0][0]);
        ctx.closePath();
        ctx.fillStyle = "yellow";
        ctx.fill();

    }

    function getColor(btn) {
        globalCompositeOperation = 'source-over';
        lineWidth = 2;
        switch (btn.getAttribute('data-color')) {
            case "green":
                fillStyle = "green";
                break;
            case "blue":
                fillStyle = "blue";
                break;
            case "red":
                fillStyle = "red";
                break;
            case "yellow":
                fillStyle = "yellow";
                break;
            case "orange":
                fillStyle = "orange";
                break;
            case "black":
                fillStyle = "black";
                break;
            case "eraser":
                globalCompositeOperation = 'destination-out';
                fillStyle = "rgba(0,0,0,1)";
                lineWidth = 14;
                break;
        }

    }

    function draw(dot) {
        const ctx = canvas.getContext("2d");
        ctx.beginPath();
        ctx.globalCompositeOperation = globalCompositeOperation;
        ctx.height = backgroundImage.height;
        ctx.width = backgroundImage.width;
        if(dot){
            ctx.fillStyle = fillStyle;
            ctx.fillRect(currX, currY, 2, 2);
        } else {
            ctx.beginPath();
            ctx.moveTo(prevX, prevY);
            ctx.lineTo(currX, currY);
            ctx.strokeStyle = fillStyle;
            ctx.lineWidth = lineWidth;
            ctx.stroke();
        }
        ctx.closePath();
    }

    function erase() {
        if (confirm("Want to clear")) {
            const ctx = canvas.getContext("2d");
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            document.getElementById("canvasimg").style.display = "none";
            finalImg.style.display = "none";
        }
    }

    function save() {
        canvas.style.border = "2px solid";
        canvasimg.width = canvas.width;
        canvasimg.height = canvas.height;
        const ctx2 = canvasimg.getContext("2d");
        ctx2.drawImage(backgroundImage, 0, 0);
        ctx2.drawImage(canvas, 0, 0);
        finalImg.src = canvasimg.toDataURL();
        finalImg.style.display = "inline";
    }

    function handleMouseEvent(e) {
        if (e.type === 'mousedown') {
            prevX = currX;
            prevY = currY;
            currX = e.offsetX;
            currY = e.offsetY;
            mouseClicked = true;
            draw(true);
        }
        if (e.type === 'mouseup' || e.type === "mouseout") {
            mouseClicked = false;
        }
        if (e.type === 'mousemove') {
            if (mouseClicked) {
                prevX = currX;
                prevY = currY;
                currX = e.offsetX;
                currY = e.offsetY;
                draw();
            }
        }
    }
</script>
</html>