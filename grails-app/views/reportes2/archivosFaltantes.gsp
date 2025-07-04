<%@ page import="janus.pac.Anio" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Archivos faltantes
    </title>
</head>

<body>

<div class="row">
    <div class="col-md-12" style="margin-bottom: 5px">
        <div class="col-md-1 btn-group" role="navigation">
            <a href="#" class="btn btn-info btnRegresar">
                <i class="fa fa-arrow-left"></i>
                Regresar
            </a>
        </div>

        <div class="col-md-11 breadcrumb">
            Archivos faltantes de la obra: ${obra?.descripcion}
        </div>

        <div class="col-md-12" style="font-weight: bold; font-size: 14px; text-align: center">
            <elm:poneHtml textoHtml="${archivos}" />
        </div>
    </div>
</div>

<script type="text/javascript">

    $(".btnRegresar").click(function () {
        location.href="${createLink(controller: "obra", action: "registroObra")}?obra=" + "${obra?.id}"
    })

</script>

</body>
</html>