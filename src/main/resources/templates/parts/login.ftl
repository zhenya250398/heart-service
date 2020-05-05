<#macro login path>
<form action="${path}" method="post">
    <div> Имя пользователя: </div>
    <div><input type="text" name="username"/></div>
    <div> Пароль: </div>
    <div><input type="password" name="password"/></div>
    <input type="hidden" name="_csrf" value="${_csrf.token}" />
    <div><input type="submit" value="Продолжить"/></div>
</form>
</#macro>

<#macro logout>
<form action="/logout" method="post">
    <input type="hidden" name="_csrf" value="${_csrf.token}" />
    <input type="submit" value="Выйти из учетной записи"/>
</form>
</#macro>
