<#import "parts/common.ftl" as c>

<@c.page>
    <div style="margin-top: 150px">Редактор пользователей</div>
    <form action="/user" method="post">
        <input type="text" name="username" value="${user.username}">
        <input type="text" name="userpass" value="${user.password}">
        <#list roles as role>
            <div>
                <label><input type="checkbox" name="${role}" ${user.roles?seq_contains(role)?string("checked", "")}>${role}</label>
            </div>
        </#list>
        <input type="hidden" value="${user.id}" name="userId">
        <input type="hidden" value="${_csrf.token}" name="_csrf">
        <button type="submit">Сохранить</button>
    </form>
</@c.page>