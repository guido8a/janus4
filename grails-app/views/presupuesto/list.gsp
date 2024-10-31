<%@ page import="janus.pac.Asignacion" %>
<%@ page import="janus.Grupo" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Partidas Presupuestarias
    </title>
</head>

<body>

<div class="col-md-12 breadcrumb" style="font-size: 18px; text-align: center">
    <h3>Lista de partidas presupuestarias por año</h3>
</div>

<div class="row" id="busqueda" style="overflow: hidden">
    <fieldset class="borde" style="border-radius: 4px">
        <div class="row-fluid">
            <div class="col-md-2">
                Año
                <g:select class="form-control" name="anios" from="${janus.pac.Anio.list(sort: 'anio')}" value="${actual?.id}" optionKey="id" optionValue="anio"/>
            </div>
            <div class="col-md-2">
                Buscar Por
                <g:select name="buscarPor" class="buscarPor form-control" from="${[2: 'Descripción' , 1: 'Código']}" style="width: 100%" optionKey="key" optionValue="value"/>
            </div>
            <div class="col-md-3">
                Criterio
                <g:textField name="criterio" class="criterio form-control"/>
            </div>
            <div class="col-md-2 btn-group" style="margin-top: 20px">
                <button class="btn btn-info" id="btnBuscarPartida"><i class="fa fa-search"></i></button>
                <button class="btn btn-warning" id="btnLimpiarPartida" title="Limpiar Búsqueda"><i class="fa fa-eraser"></i></button>
            </div>

            <div class="col-md-1" style="margin-top: 20px">
                <a href="${createLink(controller: 'asignacion', action: 'form_ajax')}" class="btn btn-info"><i class="fa fa-book"></i> Asignaciones</a>
            </div>

            <div class="col-md-1" style="margin-top: 20px">
                <a href="#" class="btn btn-success btnNuevaPartida"><i class="fa fa-file"></i> Nueva Partida</a>
            </div>

        </div>
    </fieldset>

    <fieldset class="borde col-md-12" style="margin-top: 10px">
        <div class="col-md-12" id="divTablaPartidas">
        </div>
    </fieldset>
</div>

<script type="text/javascript">

    // var bcpc;

    $("#btnLimpiarPartida").click(function () {
        $("#buscarPor").val(2);
        $("#criterio").val('');
        $("#anios").val('${actual?.id}');
        cargarPartidas();
    });

    $("#anios").change(function () {
        cargarPartidas();
    });

    cargarPartidas();

    $("#btnBuscarAsignacion").click(function () {
        cargarPartidas();
    });

    function cargarPartidas() {
        var anio = $("#anios option:selected").val();
        var buscarPor = $("#buscarPor option:selected").val();
        var criterio = $("#criterio").val();
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'presupuesto', action:'tablaPresupuesto_ajax')}",
            data: {
                buscarPor: buscarPor,
                criterio: criterio,
                anio: anio
            },
            success: function (msg) {
                $("#divTablaPartidas").html(msg);
            }
        });
    }

    $("#criterio").keydown(function (ev) {
        if (ev.keyCode === 13) {
            ev.preventDefault();
            cargarPartidas();
            return false;
        }
    });

    // function cerrarBuscadorPartida(){
    //     bcpc.modal("hide")
    // }

    function createEditPresupuesto(id) {
        var title = id ? "Editar " : "Crear ";
        var data = id ? {id : id} : {};

        $.ajax({
            type    : "POST",
            url: "${createLink(controller: 'presupuesto', action:'form_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEditPartida",
                    title   : title + " Partida",
                    class : "modal-lg",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        guardar  : {
                            id        : "btnSave",
                            label     : "<i class='fa fa-save'></i> Guardar",
                            className : "btn-success",
                            callback  : function () {
                                return submitFormPresupuesto();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    } //createEdit

    function submitFormPresupuesto() {
        var $form = $("#frmPartida");
        if ($form.valid()) {
            var data = $form.serialize();
            var dialog = cargarLoader("Guardando...");
            $.ajax({
                type    : "POST",
                url     : $form.attr("action"),
                data    : data,
                success : function (msg) {
                    dialog.modal('hide');
                    var parts = msg.split("_");
                    if(parts[0] === 'ok'){
                        log(parts[1], "success");
                        cargarPartidas();
                    }else{
                        if(parts[0] === 'err'){
                            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                            return false;
                        }else{
                            log(parts[1], "error");
                        }
                    }
                }
            });
        } else {
            return false;
        }
    }

    $(".btnNuevaPartida").click(function () {
        createEditPresupuesto();
    })

</script>

</body>
</html>