<#import "parts/common.ftl" as c>
<#import "parts/login.ftl" as l>

<@c.page>
    <div style="margin-top: 150px"></div>
    <@l.login "/registration" true/>
    ${message?if_exists}
</@c.page>
