<%@ page import="janus.pac.Asignacion" %>
<%@ page import="janus.Grupo" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        P.A.C.
    </title>
</head>

<body>

<div class="col-md-12 breadcrumb" style="font-size: 18px; text-align: center">
    <h3>P.A.C. por año</h3>
</div>

<div class="row" id="busqueda" style="overflow: hidden">
    <fieldset class="borde" style="border-radius: 4px">
        <div class="row-fluid">
            <div class="col-md-2">
                Año
                <g:select class="form-control" name="anios" from="${janus.pac.Anio.list(sort: 'anio')}" value="${presupuesto ? presupuesto?.anio?.id : actual?.id}" optionKey="id" optionValue="anio"/>
            </div>
            <div class="col-md-2">
                Buscar Por
                <g:select name="buscarPor" class="buscarPor form-control" from="${[2: 'Descripción' , 1: 'Código']}" style="width: 100%" optionKey="key" optionValue="value"/>
            </div>
            <div class="col-md-3">
                Criterio
                <g:textField name="criterio" class="criterio form-control" value="${presupuesto ? presupuesto?.numero : ''}"/>
            </div>
            <div class="col-md-2 btn-group" style="margin-top: 20px">
                <button class="btn btn-info" id="btnBuscarPac"><i class="fa fa-search"></i></button>
                <button class="btn btn-warning" id="btnLimpiarPac" title="Limpiar Búsqueda"><i class="fa fa-eraser"></i></button>
            </div>

            <div class="col-md-1" style="margin-top: 20px">
                <a href="#" class="btn btn-success btnNuevoPac"><i class="fa fa-file"></i> Nuevo PAC</a>
            </div>

            <div class="col-md-1" style="margin-top: 20px">
                <g:link action="formUploadPac" class="btn btn-info" title="Subir Excel" id="btnUpload">
                    <i class="fa fa-upload"></i> Subir PAC
                </g:link>
            </div>

        </div>
    </fieldset>

    <fieldset class="borde col-md-12" style="margin-top: 10px">
        <div class="col-md-12" id="divTablaPac">
        </div>
    </fieldset>
</div>

<script type="text/javascript">

    <g:if test="${presupuesto}">
    $("#buscarPor").val(1);
    </g:if>
    <g:else>
    $("#buscarPor").val(2);
    </g:else>

    $("#btnLimpiarPac").click(function () {
        $("#buscarPor").val(2);
        $("#criterio").val('');
        $("#anios").val('${actual?.id}');
        cargarPacs();
    });

    $("#anios").change(function () {
        cargarPacs();
    });

    cargarPacs();

    $("#btnBuscarPac").click(function () {
        cargarPacs();
    });

    function cargarPacs() {
        var anio = $("#anios option:selected").val();
        var buscarPor = $("#buscarPor option:selected").val();
        var criterio =  $("#criterio").val();

        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'pac', action:'tablaPac_ajax')}",
            data: {
                buscarPor: buscarPor,
                criterio: criterio,
                anio: anio

            },
            success: function (msg) {
                $("#divTablaPac").html(msg);
            }
        });
    }

    $("#criterio").keydown(function (ev) {
        if (ev.keyCode === 13) {
            ev.preventDefault();
            cargarPacs();
            return false;
        }
    });

    function createEditPac(id) {
        var title = id ? "Editar " : "Crear ";
        var data = id ? {id : id} : {};

        $.ajax({
            type    : "POST",
            url: "${createLink(controller: 'pac', action:'form_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEditPac",
                    title   : title + " P.A.C.",
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
                                return submitFormPac();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    } //createEdit

    function submitFormPac() {
        var $form = $("#frmPac");
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
                        cargarPacs();
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

    $(".btnNuevoPac").click(function () {
        createEditPac();
    })

</script>

</body>
</html>