<#import "parts/common.ftl" as c>
<#import "parts/login.ftl" as l>

<@c.page>
    <div style="margin-top: 150px"></div>
    ${message?if_exists}
    <form>

    <@l.login "/registration" true/>
    </form>
</@c.page>
