
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Comprobar valores de los rubros
    </title>

    <style>
    .noCuadra {
        color: #9c1e27 !important;
        font-weight: bold;
    }
    </style>
</head>
<body>

<div class="row">
    <div class="col-md-1 btn-group" role="navigation">
        <a href="#" class="btn btn-primary" id="btnRegresar">
            <i class="fa fa-arrow-left"></i>
            Regresar
        </a>
    </div>

    <div id="list-grupo" class="col-md-10" role="main" style="margin-top: 10px;margin-left: 5px">
        <div class="col-md-12">
            <div class="col-md-2" style="text-align: right">
                <label>Obra Ofertada:</label>
            </div>
            <div class="col-md-10">
                %{--                        <g:select name="obra" class="form-control"   from="${obras}" optionKey="key" optionValue="value"  style="width: 100%;"/>--}%

                <select id="obra" class="selectObras col-md-12" >
                    <g:each in="${obras}" var="obraSeleccionada">
                        <option class="obra" value="${obraSeleccionada?.key}">
                            ${obraSeleccionada?.value}
                        </option>
                    </g:each>
                </select>
            </div>
        </div>
    </div>
</div>
<div class="row" style="margin-top: 20px">
    <div class="col-md-12">
        <div class="col-md-3"></div>
        <div class="col-md-7 alert alert-warning" style="font-size: 14px">
            <i class="fa fa-exclamation-triangle fa-2x text-info"></i> Para que los valores se vean correctamente reflejados en la tabla inferior, es necesario primero ir al
            <br/>  punto número 4 <strong> "Validar items y revisar APU del oferente" </strong> y validar los rubros.
            <a href="#" class="btn btn-success" id="btnIrValidar">
                <i class="fa fa-check"></i>
                Ir a Validar items
            </a>
        </div>
    </div>
</div>

<fieldset class="borde">
    <div id="divTabla">
    </div>
</fieldset>

<script type="text/javascript">
    var di;

    $('.selectObras').select2();

    $("#btnIrValidar").click(function () {
        location.href = "${createLink(controller: 'rubroOf', action: 'rubroCon')}?tipo=" + 1;
    });

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
