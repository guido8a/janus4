<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Planillas y Pagos</title>
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
            <g:select class="form-control" name="anios" from="${janus.pac.Anio.list(sort: 'anio')}" value="${concurso ? concurso?.pac?.presupuesto?.anio?.id : actual?.id}" optionKey="id" optionValue="anio"/>
        </div>
        <div class="col-md-1">
            <label style="font-size: 18px; text-align: center; font-weight: bold">
                Partida
            </label>
        </div>
        <div class="col-md-7" id="divListaPartidas">

        </div>
        <div class="col-md-1" style="margin-top: 2px; float: right">
            <a href="#" class="btn btn-success btnNuevaPartida"><i class="fa fa-file"></i> Nueva Partida</a>
        </div>
    </div>
</div>

<div id="divAsignaciones">

</div>


<script type="text/javascript">

    $("#anios").change(function () {
        cargarListaPartidas();
    });

    cargarListaPartidas();

    function cargarListaPartidas(){
        var anio = $("#anios option:selected").val();
        var id = '${concurso?.id}';
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'presupuesto', action:'listaPartidas_ajax')}",
            data: {
                anio: anio,
                id: id
            },
            success: function (msg) {
                $("#divListaPartidas").html(msg);
            }
        });

    }

</script>

</body>
</html>
