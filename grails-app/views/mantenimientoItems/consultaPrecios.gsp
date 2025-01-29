
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
                    <g:set var="tipoMQ" value="${janus.TipoLista.findAllByCodigo('MQ')}"/>
                    <g:select name="lugar" from="${janus.Lugar.findAllByTipoListaNotInList(tipoMQ, [sort: 'descripcion'])}" optionKey="id" optionValue="descripcion" class="form-control"/>
                </span>
                <span class="col-md-2">
                    <label class="control-label text-info">Fecha</label>
                    <input aria-label="" name="fecha" id='fechaConsulta' type='text' class="form-control" value="${new Date().format("dd-MM-yyyy")}" />
                </span>
            </span>
            <div class="col-md-2" style="margin-top: 20px">
                <button class="btn btn-info" id="btnBuscar"><i class="fa fa-search"></i></button>
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
        var fecha = $("#fechaConsulta").val();
        var d = cargarLoader("Cargando...");
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'mantenimientoItems', action: 'tablaConsultaPrecios_ajax')}',
            data:{
                lugar: lugar,
                fecha: fecha
            },
            success: function (msg){
                d.modal("hide");
                $("#divTablaPrecios").html(msg)
            }
        })
    }




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
