<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>HeartService</title>
    <script src="http://code.jquery.com/jquery-3.3.1.js" type="text/javascript"></script>
    <link rel="stylesheet" href = "https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">

</head>
<body onload="init()">
<#list hearts! as heart>
<img id="loadImg" src="/img/${heart.filename}" style="display:none" alt="alternative">

<h3 class="container centerm-2" style="font-family: DM Mono, serif; display: flex; text-align: justify; align-items: center;justify-content: center;">
    Наша нейросеть определила точки на изображении. Если вас устраивает результат - нажмите Download.<br>
    Если результат необходимо исправить - тяните точки до достижения нужного эффекта.
</h3>
<div class="container-2 m-2" style="display: flex; align-items: center;justify-content: center;">

    <canvas id="canvas" width="400" height="300" style="border:2px solid rgb(25,133,255);;">
    </canvas>
    <div class="container-3 m-2" style="align-items: center;justify-content: center;">
        <h4>Выберите цвет границы</h4>
        <div class="row">
            <div class="col-sm">
                <div id="light_green" style="height: 2em; width: 5em; background:#66ff00;" data-color="#66ff00" onclick="ChangeColor(this)"></div>
                <div id="red" style="height: 2em; width: 5em; background:#ff2400;" data-color="#ff2400" onclick="ChangeColor(this)"></div>
                <div id="yellow" style="height: 2em; width: 5em;background:#ffff00;" data-color="yellow" onclick="ChangeColor(this)"></div>
                <div id="blue" style="height: 2em; width: 5em;background:#00ccff;" data-color="#00ccff" onclick="ChangeColor(this)"></div>
            </div>
        </div>
    </div>
    <div class = "container-4 m-2">
        <h5>S фигуры усл. ед.</h5>
        <div class="areaFigure"></div>
    </div>
</div>


<canvas id="canvasImg" style="display:none;"></canvas>
<img id="finalImg" style="display:none;">
<div class="btn-group mr-2" style="top:80%;left:10%;">
    <form method="post" id="myForm">
        <input type="hidden" name="_csrf" value="${_csrf.token}"/>
        <a id="btn" download="image.png"><button class="btn btn-sm btn-outline-primary my-2"  type="button" onClick="save()">Download</button></a>
    </form>
    <input class="btn btn-sm btn-outline-warning my-2" type="button" value="reset points" id="reset" size="23" onclick="reset()">
</div>
<a class="btn btn-sm btn-outline-primary my-2" style="position: relative; top:80%;left:60%;" href="/main" >Вернуться на страницу загрузок</a>
<#include "./parts/footer.ftl">

</body>

<script type="text/javascript">
    var canvas, canvasImg, backgroundImage, finalImg;
    var mouseX;
    var mouseY;
    var lastX;
    var lastY;
    var fillStyle = "yellow";
    var globalCompositeOperation = "source-over";
    var circles =  [];
    var isDown = false;
    var draggingCircle;
    var areaTotal;

    function init() {

        backgroundImage = new Image();
        backgroundImage = document.getElementById('loadImg');
        canvas = document.getElementById('canvas');
        canvas.width = backgroundImage.width;
        canvas.height = backgroundImage.height;
        finalImg = document.getElementById('finalImg');
        canvasImg = document.getElementById('canvasImg');
        canvas.style.backgroundImage = "url('" + backgroundImage.getAttribute("src") + "')";
        areaTotal = document.querySelector(".areaFigure");

        //console.log(document.getElementById('loadImg').getAttribute("src"));
        $("#canvas").mousedown(function (e) {
            handleMouseDown(e);
        });
        $("#canvas").mousemove(function (e) {
            handleMouseMove(e);
        });
        $("#canvas").mouseup(function (e) {
            handleMouseUp(e);
        });
        $("#canvas").mouseout(function (e) {
            handleMouseUp(e);
        });


        reset();
        //console.log(circles);
        drawCanvas();

    }

    function ChangeColor(btn) {
        globalCompositeOperation = 'source-over';
        fillStyle = btn.getAttribute('data-color');
        drawCanvas();
    }



    function drawCanvas() {
        const ctx = canvas.getContext("2d");
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        document.getElementById("canvasImg").style.display = "none";
        finalImg.style.display = "none";
        ctx.height = backgroundImage.height;
        ctx.width = backgroundImage.width;
        drawCircles(ctx);

    }

    function drawCircles(ctx) {

        for (var i = 0; i < circles.length; i++) {
            if(i==0)
            {
                ctx.beginPath();
                ctx.moveTo(circles[i].y, circles[i].x);
            }
            else {
                ctx.lineTo(circles[i].y, circles[i].x);
                ctx.arc(circles[i].y, circles[i].x, 1, 0, Math.PI * 2);

            }
        }
        ctx.closePath();
        ctx.strokeStyle = fillStyle;
        ctx.lineWidth = 1;
        ctx.stroke();
        //console.log(areaTotal);
    }

    function reset() {
        circles.splice(0, circles.length);
        var request = new XMLHttpRequest();
        const path = "/out/${heart.filename}/output.csv";
        request.open("GET", path, true);

        request.onreadystatechange = function() {
            if (request.readyState == 4 && request.status == 200) {
                console.log(request);
            }
        };
        request.send(null);
        request.onload = function () {
            var jsonObject = request.responseText.split(/\r?\n|\r/);
            for (var i = 0; i < jsonObject.length; i=i+2) {
                circles.push(
                    {
                        x: parseInt(jsonObject[i].split(',')[0]),
                        y: parseInt(jsonObject[i].split(',')[1]),
                        //color: "yellow"
                    });
            }
            console.log(circles);
            calculateArea();
            drawCanvas();
        };
    }

    function calculateArea() {

        var tempAreaTotal = 0.0;
        for (var i=0; i < circles.length-3; i++)
        {
            if(!isNaN(circles[i].x) && !isNaN(circles[i].y) && !isNaN(circles[i+1].x) && !isNaN(circles[i+1].y))
            {
                tempAreaTotal += (circles[i].x*circles[i+1].y) - (circles[i+1].x*circles[i].y);
                console.log(tempAreaTotal);
            }
            else
                {
                    console.log("found NAN for index:", i);
                }
        }
        tempAreaTotal = 0.5 * Math.abs(tempAreaTotal + circles[circles.length-2].x*circles[0].y - circles[0].x*circles[circles.length-2].y);
        console.log(tempAreaTotal);
        console.log(circles);
        areaTotal.innerHTML = tempAreaTotal;
    }

    function save() {
        canvas.style.border = "1px solid";
        canvasImg.width = canvas.width;
        canvasImg.height = canvas.height;
        const ctx2 = canvasImg.getContext("2d");
        ctx2.drawImage(backgroundImage, 0, 0);
        ctx2.drawImage(canvas, 0, 0);
        finalImg.src = canvasImg.toDataURL();
        var link = document.getElementById('btn');
        link.setAttribute('download', 'DynamicEcho.png');
        link.setAttribute('href', finalImg.src.replace("image/png", "image/octet-stream"));


        <#--var response = new XMLHttpRequest();-->
        <#--var theUrl = "/out/${heart.filename}/save.csv";-->
        <#--response.open("POST", theUrl, true);-->
        <#--response.setRequestHeader("Content-type", "application/x-www-form-urlencoded");-->
        <#--response.onreadystatechange = function() {//Вызывает функцию при смене состояния.-->
        <#--    if(response.readyState == XMLHttpRequest.DONE && response.status == 200) {-->
        <#--        // Запрос завершен. Здесь можно обрабатывать результат.-->
        <#--    }-->
        <#--}-->
        <#--response.send(JSON.stringify(circles));-->


        //here https://stackoverflow.com/questions/24639335/javascript-console-log-causes-error-synchronous-xmlhttprequest-on-the-main-thr

        var token =  $('input[name="_csrf"]').attr('value');

        $.ajax({
            async: true,
            type: "POST",
            url: "/out/${heart.filename}/save.csv",
            contentType: "application/json",
            data: JSON.stringify(circles),
            success: success,
            headers: {'X-CSRF-Token': token  }
        });
    }



    function handleMouseDown(e) {
        e.preventDefault();
        e.stopPropagation();
        lastX = parseInt(e.offsetX);
        lastY = parseInt(e.offsetY);
        // Проверка нажатия на одну из существующих точек
        var hit = -1;
        for (var i = 0; i < circles.length; i++) {
            var dx = lastX - circles[i].y;
            var dy = lastY - circles[i].x;
            if (dx * dx + dy * dy < 4) { // 4 = circle.radius * circle.radius
                hit = i;
            }
        }

        // Если не зафиксировано нажатие -> возврат
        // Если нажитие тогда устанавливаем флаг isDown -> true
        if (hit < 0) {
            return;
        }
        else {
            draggingCircle = circles[hit];
            isDown = true;
        }
    }

    function handleMouseUp(e) {
        e.preventDefault();
        e.stopPropagation();
        isDown = false;
    }

    function handleMouseMove(e) {

        if (!isDown) {
            return;
        }
        e.preventDefault();
        e.stopPropagation();
        mouseX = parseInt(e.offsetX);
        mouseY = parseInt(e.offsetY);
        var dx = mouseX - lastX;
        var dy = mouseY - lastY;

        draggingCircle.y += dx;
        draggingCircle.x += dy;
        calculateArea();
        drawCanvas();
        lastX = mouseX;
        lastY = mouseY;
    }


</script>
</#list>
</html>