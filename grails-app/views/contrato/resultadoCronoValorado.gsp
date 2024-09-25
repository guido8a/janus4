<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Resultado de carga de archivos</title>
</head>

<body>
<div class="well">
    <g:link class="btn btn-primary" controller="contrato" action="subirExcelContrato" ><i class="fa fa-arrow-left"></i> Regresar </g:link>
    <elm:poneHtml textoHtml="${flash.message}"/>
    <g:link class="btn btn-primary" controller="contrato" action="subirExcelContrato" ><i class="fa fa-arrow-left"></i> Regresar </g:link>
</div>
</body>
</html>