
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Lista de Rubros
    </title>
</head>
<body>

<div class="row" style="margin-bottom: 1px">
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

<div id="busqueda" style="overflow: hidden">
    <fieldset class="borde" style="border-radius: 4px">

        <div class="row-fluid">
            <div class="col-md-12">
                <div class="col-md-1"> <label> Tipo de Obra: </label> </div>
                <div class="col-md-2">
                    <g:select name="tipoName" id="tipo" class="form-control btn-success" from="${tipos}" optionKey="id" optionValue="descripcion" />
                </div>

                <div class="col-md-1"> <label> Subpresupuesto </label> </div>
                <div class="col-md-5" id="divSubpresupuesto">

                </div>
            </div>
        </div>

        <div class="row-fluid" style="margin-top: 50px !important;">
            <div class="col-md-12">
                <div class="col-md-1"> <label> Buscar Por </label> </div>
                <div class="col-md-2">
                    <g:select name="buscarPor" class="buscarPor form-control" from="${[1: 'Nombre', 2: 'Código']}" optionKey="key" optionValue="value"/>
                </div>
                <div class="col-md-1"> <label> Criterio </label> </div>
                <div class="col-md-3">
                    <g:textField name="criterio" class="criterio form-control"/>
                </div>
                <div class="col-md-1"> <label> Ordenado por </label> </div>
                <div class="col-md-2">
                    <g:select name="ordenar" class="ordenar form-control" from="${[1: 'Nombre', 2: 'Código']}"  optionKey="key"
                              optionValue="value"/>
                </div>
                <div class="col-md-2 btn-group">
                    <button class="btn btn-info" id="btnBuscar"><i class="fa fa-search"></i></button>
                    <button class="btn btn-warning" id="btnLimpiar" title="Limpiar Búsqueda"><i class="fa fa-eraser"></i></button>
                </div>
            </div>
        </div>
    </fieldset>

    <fieldset class="borde col-md-12">
        <div class="col-md-7" id="divTabla">
        </div>
        <div class="col-md-5" id="divTablaSeleccionados" >
        </div>
    </fieldset>
</div>

<script type="text/javascript">
    var di;

    $("#btnRegresar").click(function () {
        location.href="${createLink(controller: 'volumenObra', action: 'volObra')}/${obra?.id}"
    });

    cargarSubpresupuestoBusqueda();

    function cargarSubpresupuestoBusqueda (){
        var tipo = $("#tipo option:selected").val();
        $.ajax({
            type    : "POST",
            url : "${g.createLink(controller: 'volumenObra',action:'subpresupuestos_ajax')}",
            data    : {
                id: tipo,
                obra: '${obra?.id}'
            },
            success : function (msg) {
                $("#divSubpresupuesto").html(msg)
            }
        });
    }

    $("#tipo").change(function () {
        cargarSubpresupuestoBusqueda();
    });

    $("#btnBuscar").click(function () {
        cargarTablaBusqueda();
    });

    $("#btnLimpiar").click(function  () {
        $("#buscarPor").val(1);
        $("#criterio").val('');
        $("#ordenar").val(1);
        cargarTablaBusqueda();
    });

    $("#criterio").keydown(function (ev) {
        if (ev.keyCode === 13) {
            cargarTablaBusqueda();
            return false;
        }
        return true;
    });

    cargarTablaBusqueda();
    cargarTablaSeleccionados();

    function cargarTablaBusqueda() {
        var d = cargarLoader("Cargando...");
        var buscarPor = $("#buscarPor option:selected").val();
        var criterio = $(".criterio").val();
        var ordenar = $("#ordenar option:selected").val();

        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'volumenObra', action:'tablaBusqueda_ajax')}",
            data: {
                buscarPor: buscarPor,
                criterio: criterio,
                ordenar: ordenar
            },
            success: function (msg) {
                d.modal("hide");
                $("#divTabla").html(msg);
            }
        });
    }

    function cargarTablaSeleccionados() {
        // var grupo = $("#tipo option:selected").val();
        var subpresupuesto = $("#subpresupuestoBusqueda option:selected").val();
        var d = cargarLoader("Cargando...");
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'volumenObra', action:'tablaSeleccionados_ajax')}",
            data: {
                // grupo: grupo,
                subpresupuesto:subpresupuesto,
                obra: '${obra?.id}'
            },
            success: function (msg) {
                d.modal("hide");
                $("#divTablaSeleccionados").html(msg);
            }
        });
    }

</script>

</body>
</html>
