<!doctype html>
<html lang="en" class="no-js">
<head>

    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>
        <g:layoutTitle default="janus4"/>
    </title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <asset:link rel="icon" href="favicon.ico" type="image/x-ico"/>

    <g:if test="${janus.Parametros.findByEmpresaLike('SEP-C-GADPP')}">
        <asset:stylesheet src="/bootstrap-3.3.2/dist/css/bootstrapCon.css"/>
    </g:if>
    <g:else>
        <asset:stylesheet src="/bootstrap-3.3.2/dist/css/bootstrapNuevo.css"/>
    </g:else>

    <asset:stylesheet src="/bootstrap-3.3.2/dist/css/bootstrap-theme.css"/>

    <asset:stylesheet src="/jquery/jquery-ui-1.10.3.custom.min.css"/>
    <asset:stylesheet src="/apli/jquery-ui.css"/>
    %{--<asset:stylesheet src="/apli/jquery-ui.structure.css"/>--}%
    %{--<asset:stylesheet src="/apli/jquery-ui.theme.css"/>--}%
    <asset:stylesheet src="/apli/custom.css"/>
    <asset:stylesheet src="/apli/lzm.context-0.5.css"/>
    <asset:stylesheet src="/apli/jquery.pnotify.js"/>
    <asset:stylesheet src="/apli/jquery.pnotify.default.css"/>
    <asset:stylesheet src="/apli/font-awesome.min.css"/>
    <asset:stylesheet src="/apli/CustomSvt.css"/>
    <asset:stylesheet src="/apli/tulpen/stylesheet.css"/>
    <asset:stylesheet src="/apli/switcher.css"/>


    <asset:stylesheet src="/fonts/fontawesome-webfont.woff"/>
    <asset:stylesheet src="/apli/bootstrap-datetimepicker.min.css"/>

    <asset:javascript src="/jquery/jquery-2.2.4.js"/>
    %{--<asset:javascript src="/jquery/jquery-1.9.1.js"/>--}%
    <asset:javascript src="/jquery/jquery-ui-1.10.2.custom.js"/>
    %{--<asset:javascript src="/jquery/ui.js"/>--}%

    <asset:javascript src="/apli/moment.js"/>
    <asset:javascript src="/apli/moment-with-locales.js"/>

    <asset:javascript src="/apli/funciones.js"/>
    <asset:javascript src="/apli/functions.js"/>
    <asset:javascript src="/apli/loader.js"/>
    <asset:javascript src="/apli/bootbox.js"/>
    <asset:javascript src="/apli/lzm.context-0.5.js"/>

    <asset:javascript src="/jquery-validation-1.11.1/js/jquery.validate.min.js"/>
    <asset:javascript src="/jquery-validation-1.11.1/js/jquery.validate.js"/>
    <asset:javascript src="/jquery-validation-1.11.1/localization/messages_es.js"/>

    <asset:javascript src="/apli/jquery.pnotify.js"/>
    <asset:javascript src="/apli/fontawesome.all.min.js"/>

    <asset:javascript src="/apli/bootstrap-datetimepicker.min.js"/>
    <asset:javascript src="/apli/bootstrap-maxlength.min.js"/>
    <asset:javascript src="/apli/jquery.switcher.min.js"/>
    <asset:javascript src="/bootstrap-3.3.2/dist/js/bootstrap.min.js"/>
    %{--<asset:javascript src="/bootstrap.min.js"/>--}%

    <script type="text/javascript">
        var spinner = $('<asset:image src="apli/spinner32.gif" style="padding: 40px;"/>');
        var spinnerBg = $('<asset:image src="apli/spinner32.gif" style="padding: 40px;"/>');
        %{--var spinnerSquare64 = $('<asset:image src="/spinner_64.GIF" style="padding: 40px;"/>');--}%
    </script>


    <g:layoutHead/>

</head>

<body style="background-color: #d8d8df">


%{--<div id="modalTableGray"></div>--}%

<mn:menu title="${g.layoutTitle(default: 'FIDA')}"/>

<div class="container" style="min-width: 1300px !important; margin-top: 0px; overflow-y: hidden;">
    <g:layoutBody/>
</div>

<asset:javascript src="jquery/application.js"/>

<script type="text/javascript">

</script>

<style>
/*.bootbox-body {*/
.modal-body {
    background-color: #e8e8e8;
}
</style>

</body>
</html>
