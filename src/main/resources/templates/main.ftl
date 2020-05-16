<#import "parts/common.ftl" as c>
<#import "parts/login.ftl" as l>
<#include "parts/security.ftl">

<@c.page>
    <div>
        <label>Пользователь ${name}</label>
        <@l.logout />
        <#if isAdmin>
            <span><a href="/user">Список пользователей</a></span>
        </#if>
    </div>
    <div>
        <form method="post" action="/main/addImage" enctype="multipart/form-data">
            <input type="text" name="text" placeholder="Введите название изображения"/>
            <input type="file" name="file">
            <input type="hidden" name="_csrf" value="${_csrf.token}"/>
            <button type="submit">Добавить изображение</button>
        </form>
        <form method="post" action="/main/addVideo" enctype="multipart/form-data">
            <input type="text" name="text" placeholder="Введите название видео"/>
            <input type="file" name="file">
            <input type="hidden" name="_csrf" value="${_csrf.token}"/>
            <button type="submit">Добавить видео</button>
        </form>
    </div>
    <div>Список загрузок</div>
    <form method="get" action="/main">
        <input type="text" name="filter" value="${filter?if_exists}">
        <button type="submit">Найти</button>
    </form>
    <#list hearts?if_exists as heart>
        <#if heart.author.id == currentUserId>
            <div>
                <b>${heart.id}</b>
                <span>${heart.text}</span>
                <strong>Тип файла: ${heart.filetype}</strong>
                <div>
                    <#if heart.filename??>
                        <#if heart.filetype=="Изображение">
                            <img src="/img/${heart.filename}">
                            <form method="get" action="/imageProcessing">
                                <input type="hidden" name="id" value="${heart.id}"/>
                                <input type="hidden" name="name" value="${heart.filename}"/>
                                <button type="submit">Обработать</button>
                            </form>
                        </#if>
                        <#if heart.filetype=="Видео">
                            <video>
                                <source src="/img/${heart.filename}">
                            </video>
                            <form method="get" action="/videoProcessing">
                                <input type="hidden" name="id" value="${heart.id}"/>
                                <input type="hidden" name="name" value="${heart.filename}"/>
                                <button type="submit">Обработать</button>
                            </form>
                        </#if>
                    </#if>
                </div>
                <form method="post" action="/delete">
                    <input type="hidden" name="id" value="${heart.id}"/>
                    <input type="hidden" name="name" value="${heart.filename}"/>
                    <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                    <button type="submit">Удалить</button>
                </form>
            </div>
        </#if>
    <#else>
        No heart
    </#list>
</@c.page>
