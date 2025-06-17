
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Mover Rubros
    </title>
</head>
<body>

<div class="row" style="margin-bottom: 10px">
    <div class="col-md-1 btn-group" role="navigation">
        <a href="#" class="btn btn-primary" id="btnRegresar">
            <i class="fa fa-arrow-left"></i>
            Regresar
        </a>
    </div>

    <div class="col-md-10 breadcrumb" style="font-weight: bold; font-size: 16px">
        Obra: ${" (" + obra.codigo + ") - " + obra.nombre}
    </div>
</div>

<fieldset class="borde col-md-12">
    <div class="col-md-6">

        <div class="alert alert-info" style="margin-top: 10px; text-align: center">
            <i class="fa fa-list"></i> <strong style="font-size: 16px"> Subpresupuesto de Origen</strong>
        </div>

        <div class="col-md-12">
            <g:select name="subpresupuestoOrigen" class="form-control" from="${subPresupuestosOrigen}" optionKey="${{it.id}}" optionValue="${{it.descripcion}}"/>
        </div>

        <div class="col-md-12" id="divTablaOrigen" >

        </div>

    </div>

    <div class="col-md-6">

        <div class="alert alert-success" style="margin-top: 10px; text-align: center">
            <i class="fa fa-list"></i> <strong style="font-size: 16px"> Subpresupuesto de Destino</strong>
        </div>

        <div class="row-fluid">
            <div class="col-md-12">
                <div class="col-md-9" id="divSubpresupuestodestino">

                </div>
            </div>
        </div>

        <div class="col-md-12" id="divTablaDestino" >

        </div>
    </div>


</fieldset>

<script type="text/javascript">

    cargarTablaOrigen();

    $("#subpresupuestoOrigen").change(function () {
        cargarTablaOrigen();
    });

    function cargarTablaOrigen(){
        var d = cargarLoader("Cargando...");
        var subpresupuesto = $("#subpresupuestoOrigen option:selected").val();
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'volumenObra', action:'tablaRubrosOrigen_ajax')}",
            data: {
                subpresupuesto: subpresupuesto,
                obra: '${obra?.id}'
            },
            success: function (msg) {
                d.modal("hide");
                $("#divTablaOrigen").html(msg);
            }
        });
    }

    $("#btnRegresar").click(function () {
        location.href="${createLink(controller: 'volumenObra', action: 'volObra')}/${obra?.id}"
    });

</script>

</body>
</html>
