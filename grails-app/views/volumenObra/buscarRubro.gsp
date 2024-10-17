
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
            <div class="col-md-2">
                Subpresupuesto
                <g:select name="seleccionarSubpresupuesto" from="${subPresupuestos}" optionKey="${{it.id}}" optionValue="${{it.descripcion}}" class="form-control" />
            </div>
            <div class="col-md-2">
                Buscar Por
                <g:select name="buscarPor" class="buscarPor form-control" from="${[1: 'Nombre', 2: 'Código']}" style="width: 100%" optionKey="key" optionValue="value"/>
            </div>
            <div class="col-md-2">
                Criterio
                <g:textField name="criterio" class="criterio form-control"/>
            </div>
            <div class="col-md-2">
                Ordenado por
                <g:select name="ordenar" class="ordenar form-control" from="${[1: 'Nombre', 2: 'Código']}"   style="width: 100%" optionKey="key"
                          optionValue="value"/>
            </div>
            <div class="col-md-2 btn-group" style="margin-top: 20px">
                <button class="btn btn-info" id="btnBuscar"><i class="fa fa-search"></i></button>
                <button class="btn btn-warning" id="btnLimpiar" title="Limpiar Búsqueda"><i class="fa fa-eraser"></i></button>
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

    %{--$("#btnBuscar").click(function () {--}%
    %{--    cargarTablaBusqueda();--}%
    %{--});--}%

    %{--$("#btnLimpiar").click(function  () {--}%
    %{--    $("#buscarGrupo").val(1);--}%
    %{--    $("#buscarPor").val(1);--}%
    %{--    $("#criterio").val('');--}%
    %{--    $("#ordenar").val(1);--}%
    %{--    cargarTablaBusqueda();--}%
    %{--});--}%

    %{--$("#criterio").keydown(function (ev) {--}%
    %{--    if (ev.keyCode === 13) {--}%
    %{--        cargarTablaBusqueda();--}%
    %{--        return false;--}%
    %{--    }--}%
    %{--    return true;--}%
    %{--});--}%

    %{--cargarTablaBusqueda();--}%
    %{--cargarTablaSeleccionados();--}%

    %{--function cargarTablaBusqueda() {--}%
    %{--    var d = cargarLoader("Cargando...");--}%
    %{--    var grupo = $("#buscarGrupo option:selected").val();--}%
    %{--    var buscarPor = $("#buscarPor option:selected").val();--}%
    %{--    var criterio = $(".criterio").val();--}%
    %{--    var ordenar = $("#ordenar option:selected").val();--}%

    %{--    $.ajax({--}%
    %{--        type: "POST",--}%
    %{--        url: "${createLink(controller: 'rubro', action:'tablaBusqueda_ajax')}",--}%
    %{--        data: {--}%
    %{--            buscarPor: buscarPor,--}%
    %{--            criterio: criterio,--}%
    %{--            ordenar: ordenar,--}%
    %{--            grupo: grupo,--}%
    %{--            rubro: '${rubro?.id}'--}%
    %{--        },--}%
    %{--        success: function (msg) {--}%
    %{--            d.modal("hide");--}%
    %{--            $("#divTabla").html(msg);--}%
    %{--        }--}%
    %{--    });--}%
    %{--}--}%

    %{--function cargarTablaSeleccionados() {--}%
    %{--    var d = cargarLoader("Cargando...");--}%
    %{--    $.ajax({--}%
    %{--        type: "POST",--}%
    %{--        url: "${createLink(controller: 'rubro', action:'tablaSeleccionados_ajax')}",--}%
    %{--        data: {--}%
    %{--            id: '${rubro?.id}'--}%
    %{--        },--}%
    %{--        success: function (msg) {--}%
    %{--            d.modal("hide");--}%
    %{--            $("#divTablaSeleccionados").html(msg);--}%
    %{--        }--}%
    %{--    });--}%
    %{--}--}%

</script>

</body>
</html>
