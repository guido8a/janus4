<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 28/08/20
  Time: 13:31
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Cronograma cargado</title>
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