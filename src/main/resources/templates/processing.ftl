<#import "parts/common.ftl" as c>

<@c.page>
    <p>processing</p>
    <#list hearts?if_exists as heart>
     <img src="/img/${heart.filename}">
    </#list>
</@c.page>
