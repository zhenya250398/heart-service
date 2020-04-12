<#import "parts/common.ftl" as c>
<#import "parts/login.ftl" as l>

<@c.page>
<div>
    <@l.logout />
</div>
<div>
    <form method="post" enctype="multipart/form-data">
        <input type="text" name="text" placeholder="Введите сообщение" />
        <input type="file" name="file">
        <input type="hidden" name="_csrf" value="${_csrf.token}" />
        <button type="submit">Добавить</button>
    </form>
</div>
<div>Список сообщений</div>
<form method="get" action="/main">
    <input type="text" name="filter" value="${filter?if_exists}">
    <button type="submit">Найти</button>
</form>
<#list hearts?if_exists as heart>
<div>
    <b>${heart.id}</b>
    <span>${heart.text}</span>
    <strong>${heart.authorName}</strong>
    <div>
        <#if heart.filename??>
            <img src="/img/${heart.filename}">
        </#if>
    </div>
</div>
<#else>
No heart
</#list>
</@c.page>
