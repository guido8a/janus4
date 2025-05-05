<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Concursos</title>
</head>
<body>
<div class="row alert alert-info">
    <div class="col-md-12 breadcrumb" style="font-size: 18px; text-align: center; font-weight: bold">
        Partida
    </div>
    <div class="col-md-12" >
        <div class="col-md-1">
            <label style="font-size: 18px; text-align: center; font-weight: bold">
                Año
            </label>
        </div>
        <div class="col-md-2">
            <g:textField name="anio" value="" class="form-control" readonly=""/>
        </div>
        <div class="col-md-1">
            <label style="font-size: 18px; text-align: center; font-weight: bold">
                Código
            </label>
        </div>
        <div class="col-md-5">
            <g:hiddenField name="partida" value=""/>
            <g:textField name="codigoPartida" value="" class="form-control" readonly=""/>
        </div>
    </div>
    <div class="col-md-12" >
        <div class="col-md-1">
            <label style="font-size: 18px; text-align: center; font-weight: bold">
                Partida
            </label>
        </div>
        <div class="col-md-8">
            <g:textArea name="nombrePartida" value="" class="form-control" style="resize: none" readonly="" />
        </div>
        <div class="col-md-3" style="margin-top: 2px; float: right">
            <a href="#" class="btn btn-info btnBuscarPartida"><i class="fa fa-search"></i> Buscar</a>
            <a href="#" class="btn btn-success btnNuevaPartida"><i class="fa fa-file"></i> Nueva Partida</a>
        </div>
    </div>
</div>

<div id="divAsignaciones">

</div>


<script type="text/javascript">

    var bcptd;

    $(".btnBuscarPartida").click(function () {
        $.ajax({
            type    : "POST",
            url: "${createLink(controller: 'presupuesto', action:'buscadorPartida_ajax')}",
            data    : {},
            success : function (msg) {
                bcptd = bootbox.dialog({
                    id      : "dlgBuscarpartida",
                    title   : "Buscar Partida",
                    class: 'modal-lg',
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        }
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    });

    function cerrarBuscadorPartida() {
        bcptd.modal("hide");
    }

    %{--$("#btnBuscarPartida").click(function () {--}%
    %{--    buscarPartida;--}%
    %{--});--}%

    %{--function buscarPartida() {--}%
    %{--    var buscarPor = $("#buscarPorT option:selected").val();--}%
    %{--    var criterio = $("#criterioCriterioT").val();--}%
    %{--    $.ajax({--}%
    %{--        type: "POST",--}%
    %{--        url: "${createLink(controller: 'mantenimientoItems', action:'tablaCPCTransporte_ajax')}",--}%
    %{--        data: {--}%
    %{--            buscarPor: buscarPor,--}%
    %{--            criterio: criterio,--}%
    %{--            tipo: '${tipo}'--}%
    %{--        },--}%
    %{--        success: function (msg) {--}%
    %{--            $("#divTablaCPCT").html(msg);--}%
    %{--        }--}%
    %{--    });--}%
    %{--}--}%

    %{--$("#anios").change(function () {--}%
    %{--    cargarListaPartidas();--}%
    %{--});--}%

    %{--cargarListaPartidas();--}%

    %{--function cargarListaPartidas(){--}%
    %{--    var anio = $("#anios option:selected").val();--}%
    %{--    var id = '${concurso?.id}';--}%
    %{--    $.ajax({--}%
    %{--        type: "POST",--}%
    %{--        url: "${createLink(controller: 'presupuesto', action:'listaPartidas_ajax')}",--}%
    %{--        data: {--}%
    %{--            anio: anio,--}%
    %{--            id: id--}%
    %{--        },--}%
    %{--        success: function (msg) {--}%
    %{--            $("#divListaPartidas").html(msg);--}%
    %{--        }--}%
    %{--    });--}%

    %{--}--}%

</script>

</body>
</html>
