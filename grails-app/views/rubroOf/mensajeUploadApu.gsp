

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Archivo cargado</title>

    <style type="text/css">
    table {
        table-layout: fixed;
        overflow-x: scroll;
    }
    th, td {
        overflow: hidden;
        text-overflow: ellipsis;
        word-wrap: break-word;
    }
    </style>
</head>

<body>
<div class="col-md-12">
    <div class="col-md-2">
        <g:link class="btn btn-primary" controller="cronogramaEjecucion" action="indexNuevo" id="${contrato?.id}">
            <i class="fa fa-arrow-left"></i> Regresar
        </g:link>
    </div>

</div>

<div class="well">
    <elm:poneHtml textoHtml="${flash.message}"/>
</div>

</body>
</html>