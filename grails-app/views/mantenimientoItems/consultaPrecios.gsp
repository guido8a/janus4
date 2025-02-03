
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Consulta de precios</title>
</head>
<body>

<div>
    <fieldset class="borde" style="border-radius: 4px; margin-bottom: 10px; overflow-y: inherit">
        <div class="row-fluid" style="margin-left: 10px">
            <div class="col-md-1">
                <div class="btn-toolbar toolbar" style="margin-top: 20px">
                    <div class="btn-group">
                        <g:link controller="mantenimientoItems" action="precios" class="btn btn-primary">
                            <i class="fa fa-arrow-left"></i> Regresar
                        </g:link>
                    </div>
                </div>
            </div>

            <span class="grupo">
                <span class="col-md-4">
                    <label class="control-label text-info">Lugar</label>
                    %{--<g:set var="tipo" value="${janus.TipoLista.findByCodigo('P')}"/>--}%
                    <g:select name="lugar" from="${janus.TipoLista.list([sort: 'descripcion'])}"
                              optionKey="id"
                              optionValue="descripcion" class="form-control"/>
                </span>
                <div class="col-md-1">
                    <label class="control-label text-info" style="text-align: center">Año</label>
                    <g:select style="font-size:large;" name="anio" class="form-control"
                                                from="${anio - 1..anio}" value="${params.anio}"/>
                </div>
                %{--<span class="col-md-2">--}%
                    %{--<label class="control-label text-info">Fecha</label>--}%
                    %{--<input aria-label="" name="fecha" id='fechaConsulta' type='text' class="form-control"--}%
                           %{--value="${new Date().format("dd-MM-yyyy")}" />--}%
                %{--</span>--}%
                <div class="col-md-2" id="divFecha" style="text-align: center">



                </div>

            </span>
            <div class="col-md-1" style="margin-top: 20px">
                <button class="btn btn-info" id="btnBuscar" title="Buscar"><i class="fa fa-search"></i>Consultar</button>
            </div>
            <div class="col-md-1" style="margin-top: 20px">
                <button class="btn btn-danger" id="btnBorrar" title="Buscar"><i class="fa fa-trash"></i>
                    Borrar todos los precios</button>
            </div>
        </div>
    </fieldset>

    <fieldset class="borde" style="border-radius: 4px">
        <div id="divTablaPrecios" >
        </div>
    </fieldset>
</div>


<script type="text/javascript">

    $('#fechaConsulta').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        icons: {
        }
    });

    %{--var id = null;--}%

    %{--$("#buscarPor").change(function () {--}%
    %{--    cargarTablaFabricantes();--}%
    %{--});--}%

    %{--$("#btnLimpiar").click(function () {--}%
    %{--    $("#buscarPor").val(1);--}%
    %{--    $("#criterio").val('');--}%
    %{--    cargarTablaFabricantes();--}%
    %{--});--}%

    $("#btnBuscar").click(function () {
        cargarTablaConsulta();
    });


    function cargarTablaConsulta(){
        var lugar = $("#lugar option:selected").val();
        var fecha = $("#fecha").val();
        var anio = $("#anio").val();
        var d = cargarLoader("Cargando...");
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'mantenimientoItems', action: 'tablaConsultaPrecios_ajax')}',
            data:{
                lugar: lugar,
                anio: anio,
                fecha: fecha
            },
            success: function (msg){
                d.modal("hide");
                $("#divTablaPrecios").html(msg)
            }
        })
    }

    cargarFechas();

    function cargarFechas(){
        var anio = $("#anio").val();
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'mantenimientoItems', action: 'fechas_ajax')}',
            data:{
                anio: anio
            },
            success: function (msg){
                $("#divFecha").html(msg)
            }
        })
    }

    $("#anio").change(function () {
        cargarFechas();
    });

    %{--$("#criterio").keydown(function (ev) {--}%
    %{--    if (ev.keyCode === 13) {--}%
    %{--        cargarTablaFabricantes();--}%
    %{--        return false;--}%
    %{--    }--}%
    %{--    return true;--}%
    %{--});--}%

</script>

</body>
</html>
