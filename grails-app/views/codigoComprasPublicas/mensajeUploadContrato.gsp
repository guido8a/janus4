<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Archivos cargados</title>
</head>

<body>
<div class="well">
    <div class="btn btn-primary" id="btnRegresar">Regresar</div>
    <elm:poneHtml textoHtml="${flash.message}"/>
</div>
<script type="text/javascript">
    $("#btnRegresar").button().click(function() {
        location.href = "${createLink(controller:'codigoComprasPublicas',action:'list')}" + "?contrato=${contrato?.id}"
    });
</script>
</body>

</html>