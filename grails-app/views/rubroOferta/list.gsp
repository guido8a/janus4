
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Emparejar rubros
    </title>

    <style>
        .noCuadra {
            color: #9c1e27 !important;
            font-weight: bold;
        }
    </style>
</head>
<body>

<div id="busqueda" style="overflow: hidden">
    <fieldset class="borde" style="border-radius: 4px">
        <div class="row-fluid">
            <div class="col-md-1 btn-group" role="navigation">
                <a href="#" class="btn btn-primary" id="btnRegresar">
                    <i class="fa fa-arrow-left"></i>
                    Regresar
                </a>
            </div>

            <div id="list-grupo" class="col-md-10" role="main" style="margin-top: 10px;margin-left: 5px">
                <div class="col-md-12">
                    <div class="col-md-2">
                        <b>Obra Ofertada:</b>
                    </div>
                    <div class="col-md-10">
                        <g:select name="obra" class="form-control"
                                  from="${obras}" optionKey="key" optionValue="value"
                                  style="width: 100%;"/>
                    </div>
                </div>
            </div>
        </div>
    </fieldset>

    <fieldset class="borde">
        <div id="divTabla">
        </div>
    </fieldset>
</div>


<script type="text/javascript">
    var di;

    $("#btnRegresar").click(function () {
        location.href = "${createLink(controller: 'rubroOf', action: 'index')}";
    });

    $("#obra").change(function () {
        cargarTabla();
    });

    cargarTabla();

    function cargarTabla() {
        var d = cargarLoader("Cargando...");
        var obra = $("#obra option:selected").val();
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'rubroOferta', action:'tablaRubros_ajax')}",
            data: {
                id: obra
            },
            success: function (msg) {
                d.modal("hide");
                $("#divTabla").html(msg);
            }
        });
    }

</script>

</body>
</html>
