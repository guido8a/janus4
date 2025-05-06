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

<div id="divPAC">

</div>

<div id="divConcurso">

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

    function cargarAsignaciones(partida){
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'asignacion', action:'asignacion_ajax')}",
            data: {
                partida: partida
            },
            success: function (msg) {
                $("#divAsignaciones").html(msg);
            }
        });
    }

    function cargarPAC(partida){
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'pac', action:'pac_ajax')}",
            data: {
                partida: partida
            },
            success: function (msg) {
                $("#divPAC").html(msg);
            }
        });
    }

    function cargarConcurso(pac){
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'concurso', action:'concurso_ajax')}",
            data: {
                pac: pac
            },
            success: function (msg) {
                $("#divConcurso").html(msg);
            }
        });
    }

</script>

</body>
</html>
