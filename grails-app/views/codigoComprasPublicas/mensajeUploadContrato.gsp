<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 27/08/20
  Time: 16:23
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Carga de archivo</title>
</head>

<body>
<div class="well">
    %{--actionUrl = "${createLink(controller:'pdf',action:'pdfLink')}?filename=" + file + "&url=" + url;--}%
    <div class="btn btn-primary" id="btnRegresar">Regresar</div>
    <elm:poneHtml textoHtml="${flash.message}"/>
%{--    <g:link class="btn btn-primary" controller="composicion" action="tabla" id="${obra}">Regresar</g:link>--}%
</div>
<script type="text/javascript">
    $("#btnRegresar").button().click(function() {
        location.href = "${createLink(controller:'codigoComprasPublicas',action:'list')}" + "?contrato=${contrato?.id}"
    });
</script>
</body>

</html>