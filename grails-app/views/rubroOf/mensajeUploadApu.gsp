

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
    <div class="col-md-3">
        <a href="#" class="btn btn-primary btnRegresar">
            <i class="fa fa-arrow-left"></i> Regresar
        </a>
    </div>
    <div class="col-md-6 breadcrumb" style="font-size: 16px; font-weight: bold; text-align: center">
        Comprobación de archivo APU cargado en el sistema
    </div>
</div>

<div class="well" style="margin-top: 50px">
    <elm:poneHtml textoHtml="${flash.message}"/>
</div>


<script type="text/javascript">

    $(".btnRegresar").click(function () {
        location.href="${createLink(controller: 'rubroOf', action: 'subirExcelApu')}?tipo=" + 1
    })

</script>

</body>
</html>