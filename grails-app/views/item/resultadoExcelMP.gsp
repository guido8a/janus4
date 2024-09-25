<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Resultado de carga de archivos</title>
</head>

<body>
<div class="well">
    <g:link class="btn btn-primary" controller="item" action="mantenimientoPrecios" ><i class="fa fa-arrow-left"></i> Regresar a mantenimiento items</g:link>
    <elm:poneHtml textoHtml="${flash.message}"/>
    <g:link class="btn btn-primary" controller="item" action="mantenimientoPrecios" ><i class="fa fa-arrow-left"></i> Regresar a mantenimiento items</g:link>
</div>
</body>
</html>