<#macro page>
    <!DOCTYPE html>
    <html lang="en" style="height: 100%;">
    <head>
        <meta charset="UTF-8">
        <title>Главная</title>
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
        <link rel="stylesheet" type="text/css" href="https://fonts.googleapis.com/css?family=Tangerine">
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
        <script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>


        <#--    <link rel="icon" href="/main/resources  /favicons/favicon-64x64.png" sizes="64x64" type="image/png">-->
        <#--    <link rel="icon" href="/main/resources/favicons/favicon-16x16.png" sizes="16x16" type="image/png">-->
        <#--    <link rel="icon" href="/main/resources/favicons/favicon.ico">-->
    </head>
    <body style="min-height:100%;
    position:relative;
    padding-bottom: 200px;
    background: radial-gradient(#228ef4 15%, transparent 16%) 0 0, radial-gradient(#228cf2 15%, transparent 16%) 8px 8px, radial-gradient(rgba(255,255,255,.1) 15%, transparent 20%) 0 1px, radial-gradient(rgba(255,255,255,.1) 15%, transparent 20%) 8px 9px;
    background-color: #33aeff;
    background-size: 16px 16px;">
    <div>

        <#include "navbar.ftl">
        <div class="container mt-5" style="color:white">
            <#nested>
        </div>
    </div>

    <#include "footer.ftl">
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
    </body>
    </html>
</#macro>
