<#import "parts/common.ftl" as c>
<#import "parts/login.ftl" as l>

<@c.page>
Страница регистрации
${message?if_exists}
<@l.login "/registration" />
<a href="/login">Перейти к авторизации</a>
</@c.page>
