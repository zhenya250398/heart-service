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
        <form method="post" enctype="multipart/form-data">
            <input type="text" name="text" placeholder="Введите сообщение"/>
            <input type="file" name="file">
            <input type="hidden" name="_csrf" value="${_csrf.token}"/>
            <button type="submit">Добавить</button>
        </form>
    </div>
    <div>Список изображений</div>
    <form method="get" action="/main">
        <input type="text" name="filter" value="${filter?if_exists}">
        <button type="submit">Найти</button>
    </form>
    <#list hearts?if_exists as heart>
        <#if heart.author.id == currentUserId>
            <div>
                <b>${heart.id}</b>
                <span>${heart.text}</span>
                <strong>${heart.authorName}</strong>
                <div>
                    <#if heart.filename??>
                        <img src="/img/${heart.filename}">
                    </#if>
                </div>
                <form method="get" action="/processing">
                    <input type="hidden" name="id" value="${heart.id}"/>
                    <input type="hidden" name="name" value="${heart.filename}"/>
                    <button type="submit">Обработать</button>
                </form>
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
