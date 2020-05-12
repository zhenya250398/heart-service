<#import "parts/common.ftl" as c>
<#import "parts/login.ftl" as l>
<#include "parts/security.ftl">

<@c.page>
    <h1 style="margin-top: 150px">Поиск по загрузкам</h1>
    <div class="form-row mt-3">
        <div class="form-group col-md-6">
            <form method="get" action="/main" class="form-inline">
                <input type="text" name="filter" class="form-control" value="${filter?if_exists}">
                <button type="submit" class="btn btn-primary ml-2">Найти</button>
            </form>
        </div>
    </div>

    <a class="btn btn-primary mt-3" data-toggle="collapse" href="#collapseExample" role="button" aria-expanded="false" aria-controls="collapseExample">
        Добавление нового Изображения
    </a>
    <a class="btn btn-primary mt-3" data-toggle="collapse" href="#collapseExampleTwo" role="button" aria-expanded="false" aria-controls="collapseExample">
        Добавление нового Изображения
    </a>
    <div class="collapse" id="collapseExample">
        <form method="post" action="/main/addImage" enctype="multipart/form-data">
            <div class="form-control">
                <div class="form-group mt-3">
                    <input type="text" class="form-control" name="text" placeholder="Введите название изображения"/>
                </div>
                <div class="form-group">
                    <div class="custom-file">
                        <input type="file" name="file" id="customFile">
                        <label class="custom-file-label" for="customFile">Choose file</label>

                        <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                    </div>
                </div>
                <div class="form-group">
                    <button type="submit" class="btn btn-primary">Добавить изображение</button>
                </div>
            </div>
        </form>
    </div>
    <div class="collapse" id="collapseExampleTwo">
        <form method="post" action="/main/addVideo" enctype="multipart/form-data">
            <div class="form-control">
                <div class="form-group mt-3">
                    <input type="text" class="form-control" name="text" placeholder="Введите название видео"/>
                </div>
                <div class="form-group">
                    <div class="custom-file">
                        <input type="file" name="file" id="customFile">
                        <label class="custom-file-label" for="customFile">Choose file</label>

                        <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                    </div>
                </div>
                <div class="form-group">
                    <button type="submit" class="btn btn-primary">Добавить видео</button>
                </div>
            </div>
        </form>
    </div>
    <h2 class="mt-3">Список загрузок</h2>
    <div class="row row-cols-1 row-cols-md-2">
        <#list hearts?if_exists as heart>
            <#if heart.author.id == currentUserId>

                <div class="card m-2" style="border: 1px solid rgb(25,133,255); width: 20em;">
                    <b>${heart.id}</b>
                    <span>${heart.text}</span>
                    <strong>Тип файла: ${heart.filetype?if_exists}</strong>
                    <div>
                        <#if heart.filename??>
                            <#if heart.filetype?if_exists=="Изображение">
                                <img class="card-img-top" src="/img/${heart.filename}">
                                <form method="get" action="/imageProcessing">
                                    <input type="hidden" name="id" value="${heart.id}"/>
                                    <input type="hidden" name="name" value="${heart.filename}"/>
                                    <button type="submit" onclick="button.disabled = true;
setTimeout(function() { button.disabled = false }, 3000);" class="btn btn-primary m-3">Обработать</button>
                                </form>
                            </#if>
                            <#if heart.filetype?if_exists=="Видео">
                                <video style="width: 20em;height: 20em;">
                                    <source class="card-img-top" src="/img/${heart.filename}">
                                </video>
                                <form method="get" action="/videoProcessing">
                                    <input type="hidden" name="id" value="${heart.id}"/>
                                    <input type="hidden" name="name" value="${heart.filename}"/>
                                    <button id="btn-processing-video" onclick="button.disabled = true;
setTimeout(function() { button.disabled = false }, 3000);"  type="submit"class="btn btn-primary m-3">Обработать</button>
                                </form>
                            </#if>
                        </#if>

                        <form method="post" action="/delete">
                            <input type="hidden" name="id" value="${heart.id}"/>
                            <input type="hidden" name="name" value="${heart.filename}"/>
                            <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                            <button type="submit"class="btn btn-primary m-3">Удалить</button>
                        </form>
                    </div>
                </div>
            </#if>
        <#else>
            No heart
        </#list>
    </div>
</@c.page>

<script type="text/javascript">

    function processing() {
        var btnVideo= document.getElementById("btn-processing-video");
        btnVideo.disabled = true;
        setTimeout(function() { кнопка.disabled = false }, 1000);
    }
    $('#btn').attr('disabled', '');
    $('#btn').removeAttr('disabled');

</script>