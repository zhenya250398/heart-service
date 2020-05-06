<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>HeartService</title>

</head>
<body onload="init()">
<#list hearts! as heart>
<img id="loadImg" src="/img/${heart.filename}" style="display:none" alt="alternative">

<canvas id="canvas" width="400" height="300" style="position:absolute;top:10%;left:10%;border:2px solid;">
</canvas>
<div style="position:absolute ;top:2%;left:43%;">Choose color</div>
<div id = "green" style="position: absolute ;top:5%;left:45%;width:10px;height:10px;background:green;" data-color="green" onclick="getColor(this)"></div>
<div style="position:absolute ;top:5%;left:47%;width:10px;height:10px;background:red;" data-color="red" onclick="getColor(this)"></div>
<div style="position:absolute ;top:7%;left:45%;width:10px;height:10px;background:yellow;" data-color="yellow" onclick="getColor(this)"></div>
<div style="position:absolute ;top:7%;left:46%;width:10px;height:10px;background:orange;" data-color="orange" onclick="getColor(this)"></div>

<div style="position:absolute ;top:2%;left:40%;">Eraser</div>
<div style="position:absolute ;top:5%;left:40%;width:15px;height:15px;background:white;border:2px solid;" data-color="eraser" onclick="getColor(this)"></div>
<div style="position:absolute ;top:2%;left:35%;">Drag</div>
<canvas id="canvasImg" style="display:none;"></canvas>
<img id="finalImg" style="position:absolute;top:10%;left:52%;display:none;" >
<input type="button" value="save" id="btn" size="30" onclick="save()" style="position:absolute;top:80%;left:10%;">
<input type="button" value="clear" id="clr" size="23" onclick="erase()" style="position:absolute;top:80%;left:15%;">
</body>

<script type="text/javascript">
    var canvas, canvasImg, backgroundImage, finalImg;
    var mouseX;
    var mouseY;
    var lastX;
    var lastY;
    var fillStyle = "yellow";
    var globalCompositeOperation = "source-over";
    var lineWidth = 2;
    var circles = [];
    var isDown = false;
    var drag = false;
    var draggingCircle;
    function init() {


        backgroundImage = new Image();
        backgroundImage = document.getElementById('loadImg');
        canvas = document.getElementById('canvas');
        canvas.width = backgroundImage.width;
        canvas.height = backgroundImage.height;
        finalImg = document.getElementById('finalImg');
        canvasImg = document.getElementById('canvasImg');
        canvas.style.backgroundImage = "url('" + backgroundImage.getAttribute("src") + "')";
        console.log(document.getElementById('loadImg').getAttribute("src"));
        canvas.addEventListener("mousemove", handleMouseEvent);
        canvas.addEventListener("mousedown", handleMouseEvent);
        canvas.addEventListener("mouseup", handleMouseEvent);
        canvas.addEventListener("mouseout", handleMouseEvent);

        //Закрасить область по исходным данным output.csv файла
        var request = new XMLHttpRequest();
        var path = "/out/${heart.filename}/output.csv";
        request.open("GET", path, false);
        request.send();


        var jsonObject = request.responseText.split(/\r?\n|\r/);
        for (var i = 0; i < jsonObject.length; i++) {
            circles.push({currX : parseInt(jsonObject[i].split(',')[0]) , currY: parseInt(jsonObject[i].split(',')[1]), color: "yellow"});
        }

        console.log(circles);
        draw();

    }

    function getColor(btn) {
        globalCompositeOperation = 'source-over';
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
            case "drag":
                drag = true;

        }
    }

    function draw(hit) {
        const ctx = canvas.getContext("2d");
        ctx.globalCompositeOperation = globalCompositeOperation;
        ctx.height = backgroundImage.height;
        ctx.width = backgroundImage.width;


            for (var i = 0; i < circles.length; i++) {
                var circle = circles[i];
                if (hit == i)
                {
                    ctx.beginPath();
                    circle
                }
                else {

                    ctx.beginPath();
                    ctx.arc(circle.currX, circle.currY, 1, 0, Math.PI * 2);
                    ctx.closePath();
                    ctx.fillStyle = circle.color;
                    ctx.fill();
                }
            }
    }

    function erase() {
        if (confirm("Want to clear")) {
            const ctx = canvas.getContext("2d");
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            document.getElementById("canvasImg").style.display = "none";
            finalImg.style.display = "none";
        }
    }

    function save() {
        canvas.style.border = "2px solid";
        canvasImg.width = canvas.width;
        canvasImg.height = canvas.height;
        const ctx2 = canvasImg.getContext("2d");
        ctx2.drawImage(backgroundImage, 0, 0);
        ctx2.drawImage(canvas, 0, 0);
        finalImg.src = canvasImg.toDataURL();
        finalImg.style.display = "inline";
    }

    function handleMouseEvent(e) {
        e.preventDefault();
        e.stopPropagation();

        if (e.type === 'mousedown') {

            lastX = parseInt(e.offsetX);
            lastY = parseInt(e.offsetY);
            // Проверка нажатия на одну из существующих точек
            var hit = -1;
            for (var i = 0; i < circles.length; i++) {
                var circle = circles[i];
                var dx = circle.currX - lastX;
                var dy = circle.currY - lastY;
                if (dx * dx + dy * dy < 4  ) { // 4 = circle.radius * circle.radius
                    hit = i;
                }
            }

            // Если не зафиксировано нажатие на точку добавляем новую
            // Если нажитие тогда устанавливаем флаг isDown true
            if (hit < 0) {
                circles.push({currX: lastX, currY: lastY, color: fillStyle}); // Координаты из Python приходят наоборот, поэтому x->y и y->x

                draw(hit);
            } else {
                draggingCircle = circles[hit];
                isDown = true;
            }

        }
        if (e.type === 'mouseup') {

            isDown = false;
        }

        if (e.type === 'mousemove') {

            if (!isDown) {
                return;
            }

            mouseX = parseInt(e.offsetX);
            mouseY = parseInt(e.offsetY);

            var dx = mouseX - lastX;
            var dy = mouseY - lastY;

            lastX = mouseX;
            lastY = mouseY;

            draggingCircle.currX += dx;
            draggingCircle.currY += dy;


        }
        draw(hit);
    }
</script>
</#list>
</html>