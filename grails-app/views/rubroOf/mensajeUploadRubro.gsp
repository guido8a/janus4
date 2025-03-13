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
    <title>Rubros cargados</title>
</head>

<body>
<div class="well">
    <g:link class="btn btn-primary" controller="rubroOf" action="subirRubros" id="${contrato?.id}">Regresar</g:link>
    <elm:poneHtml textoHtml="${flash.message}"/>
</div>
</body>
</html>