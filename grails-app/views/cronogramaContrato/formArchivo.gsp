<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Formato incorrecto</title>

</head>

<body>
<div class="btn-toolbar" style="margin-top: 5px;">
    <div class="btn-group">
        <a href="${g.createLink(controller: 'contrato', action: 'registroContrato')}?contrato=${cntr}" class="btn btn-info" title="Regresar">
            <i class="fa fa-arrow-left"></i>
            Volver a Contrato
        </a>
    </div>
</div>

<div style="font-size: 16px">
    <br>
    Error al cargar el archivo excel:<br>
    El archivo debe estar en el formato <strong>xlsx</strong>
</div>
</body>
</html>
