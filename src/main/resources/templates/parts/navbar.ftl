<#import "login.ftl" as l>
<#include "security.ftl">

<nav style="
 position: fixed;
 background: #007bff;
 background: linear-gradient(to right, #0062E6, #33AEFF);" class="navbar navbar-dark fixed-top flex-md-nowrap">
    <a class="navbar-brand col-sm-11 col-md-auto mr-0" href="/"><h1 style="font-family: Droid Serif, serif">Services recognition<br>Heart Ultrasound and Head MRI</h1></a>
    <a class="navbar-brand col-sm-6 col-md-auto mr-0" href="/main"><h2 style="font-family: Droid Serif, serif">Страница обработки сердца</h2></a>
    <a class="navbar-brand col-sm-6 col-md-auto mr-0" href="/mainBrain"><h2 style="font-family: Droid Serif, serif">Страница обработки мозга</h2></a>

    <ul class="navbar-nav px-3">
        <#if isAdmin>
            <li class="nav-item">
                Настройки Администратора
                <a class="nav-link"  href="/userList">UserList</a>
            </li>
        </#if>
    </ul>

    <ul class="navbar-nav px-3">
        <div class="navbar-text-nowrap" style="text-align: center">${name}</div>
        <#if name =="unknown">
            <li id="SignInButton" class="nav-item text-nowrap">
                <a class="nav-link" href="/login">Sign in</a>
            </li>
        </#if>
        <#if name !="unknown"> <@l.logout/></#if>
    </ul>

</nav>