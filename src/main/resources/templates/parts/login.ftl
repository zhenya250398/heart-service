<#macro login path isRegisterForm>

    <form action="${path}" method="post">
        <#if !isRegisterForm><div style="margin-top: 150px">Вход в систему</div></#if>
        <#if isRegisterForm><div style="margin-top: 150px">Регистрация</div></#if>
        <div class="form-group row">
            <label class="col-sm-2 col-form-label">Username:</label>
            <div class="col-sm-4">
                <input type="text" name="username" class="form-control"/>
            </div>
        </div>

        <div class="form-group row">
            <label class="col-sm-2 col-form-label">Password:</label>
            <div class="col-sm-4">
                <input type="password" class="form-control" name="password"/>
            </div>
        </div>

        <input type="hidden" name="_csrf" value="${_csrf.token}" />
        <#if !isRegisterForm><a href="/registration">Добавить нового пользователя</a></#if>
        <#if isRegisterForm><a href="/login">Перейти к авторизации</a></#if>
        <button class="btn btn-primary m-2" type="submit"><#if isRegisterForm>Create<#else>Sign In</#if></button>

    </form>
</#macro>

<#macro logout>
    <form action="/logout" method="post">
        <input type="hidden" name="_csrf" value="${_csrf.token}" />
        <button class="btn btn-primary" type="submit">Sign Out</button>
    </form>
</#macro>
