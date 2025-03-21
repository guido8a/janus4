
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Copiar Composición de los APUS
    </title>
</head>
<body>

<div id="busqueda" style="overflow: hidden">
    <fieldset class="borde" style="border-radius: 4px">
        <div class="row-fluid">
            <div class="col-md-1 btn-group" role="navigation">
                <a href="#" class="btn btn-primary" id="btnRegresarPrincipal">
                    <i class="fa fa-arrow-left"></i>
                    Regresar
                </a>
            </div>
            <div id="list-grupo" class="col-md-11" role="main" style="margin-top: 10px;margin-left: -10px">

                <div class="col-md-12">
                    <div class="col-md-3">
                        <b style="margin-left: 20px">Obra Ofertada:</b>
                    </div>
                    <div class="col-md-9">
                        <g:select name="obra"
                                  from="${obras}" optionKey="key" optionValue="value"
                                  style="width: 100%; margin-left: -80px"/>
                    </div>
                </div>
            </div>
        </div>
    </fieldset>
</div>

<g:if test="${!datos}">
    <div class="row-fluid">
        <div class="col-md-4" style="margin-top: 10px">
        </div>
        <div class="col-md-4" style="margin-top: 10px; width: 33%">
            <a href="#" class="btn btn-info" id="btnCopiar" style="text-align: center; width: 100%">
                <i class="fa fa-edit"></i>
                Copiar composición a los APU del Oferente
            </a>
        </div>
    </div>
</g:if>
<g:else>
    <i class="fa fa-exclamation-triangle text-info fa-2x"></i> <strong style="font-size: 14px"> No se puede copiar la composición </strong>
</g:else>


<div class="col-md-12" id="divTablaEmpatados" style="margin-top: 10px">

</div>


<script type="text/javascript">
    var di;

    $("#btnRegresarPrincipal").click(function () {
        location.href = "${createLink(controller: 'rubroOf', action: 'index')}";
    });

    cargarTablaEmpatados();

    function cargarTablaEmpatados() {
        var d = cargarLoader("Cargando...");
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'rubroOf', action:'tablaEmpatadosCC_ajax')}",
            data: {
                obra: $("#obra").val()
            },
            success: function (msg) {
                d.modal("hide");
                $("#divTablaEmpatados").html(msg);
            }
        });
    }

</script>

</body>
</html>
