<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Cronograma cargado</title>
</head>

<body>
<div class="col-md-12">
    <div class="col-md-2">
        <g:link class="btn btn-primary" controller="rubroOf" action="index" id="${contrato?.id}">
            <i class="fa fa-arrow-left"></i> Regresar
        </g:link>
    </div>

    <div class="col-md-2">
        <g:link class="btn btn-danger" controller="rubroOf" action="subirExcel" id="${contrato?.id}">
            <i class="fa fa-arrow-left"></i> Regresar a Subir APU
        </g:link>
    </div>

    <div class="col-md-2">
        <g:link class="btn btn-info" controller="rubroOf" action="rubroCon" id="${contrato?.id}">
            Continuar: Validar Ítems <i class="fa fa-arrow-right"></i>
        </g:link>
    </div>
</div>

<div class="well">
    <elm:poneHtml textoHtml="${flash.message}"/>
</div>

</body>
</html>