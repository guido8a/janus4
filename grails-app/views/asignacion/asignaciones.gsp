<%@ page import="janus.pac.Asignacion" %>
<%@ page import="janus.Grupo" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Asignaciones
    </title>
</head>

<body>
<div class="row">
    <div class="col-md-12 breadcrumb" style="font-size: 18px; text-align: center">
        <h3>Lista de asignaciones presupuestarias por año</h3>
    </div>
</div>

<div class="row" id="busqueda" style="overflow: hidden">
    <fieldset class="borde" style="border-radius: 4px">
        <div class="row-fluid">
            <div class="col-md-2">
                Año
                <g:select class="form-control" name="anios" from="${janus.pac.Anio.list(sort: 'anio')}" value="${pac ?  pac.anio?.id :  actual?.id}" optionKey="id" optionValue="anio"/>
            </div>
            <div class="col-md-2">
                Buscar Por
                <g:select name="buscarPor" class="buscarPor form-control" from="${[2: 'Descripción' , 1: 'Código']}" style="width: 100%" optionKey="key" optionValue="value"/>
            </div>
            <div class="col-md-3">
                Criterio
                <g:textField name="criterio" class="criterio form-control" value="${partida ? partida?.numero : ''}"/>
            </div>
            <div class="col-md-2 btn-group" style="margin-top: 20px">
                <button class="btn btn-info" id="btnBuscarAsignacion"><i class="fa fa-search"></i></button>
                <button class="btn btn-warning" id="btnLimpiar" title="Limpiar Búsqueda"><i class="fa fa-eraser"></i></button>
            </div>

            <div class="col-md-1" style="margin-top: 20px">
                <a href="${createLink(controller: 'presupuesto', action: 'list')}" class="btn btn-info"><i class="fa fa-book"></i> Partidas</a>
            </div>

            <div class="col-md-1" style="margin-top: 20px">
                <a href="#" class="btn btn-success btnNuevaAsignacion"><i class="fa fa-file"></i> Nueva Asignación</a>
            </div>

        </div>
    </fieldset>

    <fieldset class="borde col-md-12" style="margin-top: 10px">
        <div class="col-md-12" id="divTablaAsignaciones">
        </div>
    </fieldset>
</div>


<script type="text/javascript">

    var bcpc;

    <g:if test="${partida}">
    $("#buscarPor").val(1);
    </g:if>
    <g:else>
    $("#buscarPor").val(2);
    </g:else>

    $("#btnLimpiar").click(function () {
        $("#buscarPor").val(2);
        $("#criterio").val('');
        $("#anios").val('${actual?.id}');
        cargarAsignaciones();
    });

    $("#anios").change(function () {
        cargarAsignaciones();
    });

    cargarAsignaciones();

    $("#btnBuscarAsignacion").click(function () {
        cargarAsignaciones();
    });

    function cargarAsignaciones() {
        var anio = $("#anios option:selected").val();
        var buscarPor = $("#buscarPor option:selected").val();
        var criterio = $("#criterio").val();
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'asignacion', action:'tablaAsignaciones_ajax')}",
            data: {
                buscarPor: buscarPor,
                criterio: criterio,
                anio: anio
            },
            success: function (msg) {
                $("#divTablaAsignaciones").html(msg);
            }
        });
    }

    $("#criterio").keydown(function (ev) {
        if (ev.keyCode === 13) {
            ev.preventDefault();
            cargarAsignaciones();
            return false;
        }
    });

    function cerrarBuscadorPartida(){
        bcpc.modal("hide")
    }

    // $("#valor").keydown(function (ev) {
    //     return validarNum(ev);
    // });
    //
    // function validarNum(ev) {
    //     /*
    //      48-57      -> numeros
    //      96-105     -> teclado numerico
    //      188        -> , (coma)
    //      190        -> . (punto) teclado
    //      110        -> . (punto) teclado numerico
    //      8          -> backspace
    //      46         -> delete
    //      9          -> tab
    //      37         -> flecha izq
    //      39         -> flecha der
    //      */
    //     return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
    //         (ev.keyCode >= 96 && ev.keyCode <= 105) ||
    //         ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
    //         ev.keyCode === 37 || ev.keyCode === 39 || ev.keyCode === 190 || ev.keyCode === 110 ) ;
    // }

    function cargarTecho() {
        if ($("#item_prsp").val() * 1 > 0) {
            $.ajax({
                type: "POST",
                url: "${g.createLink(controller: 'asignacion',action:'cargarTecho')}",
                data: "id=" + $("#item_prsp").val() + "&anio=" + $("#anio").val(),
                success: function (msg) {
                    $("#valor").val(number_format(msg, 2, ".", ""))
                }
            });
        } else {
            bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Escoja una partida presupuestaria, dando doble click en el campo de texto 'Partida' " + '</strong>');
        }
    }

    $("#prsp_editar").click(function () {
        createEditPresupuesto($("#item_prsp").val());
    });

    $("#guardar").click(function () {
        var msn = "";
        var valor = $("#valor").val();
        if ($("#item_prsp").val() * 1 < 1) {
            msn += "Escoja una partida presupuestaria, dando doble click en el campo de texto 'Partida' "
        }
        if (isNaN(valor)) {
            msn += "El valor debe ser un número positivo"
        } else {
            if (valor * 1 < 0) {
                msn += "El valor debe ser un número positivo"
            }
        }
        if (msn === ""){
            var d = cargarLoader("Guardando...");
            $(".frm_asgn").submit();
        }
        else {
            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + msn + '</strong>');
        }
    });

    $("#anio").change(cargarTecho);

    $("#item_agregar_prsp").click(function () {
        createEditPresupuesto();
    });

    function createEditPresupuesto(id) {
        var title = id ? "Editar" : "Crear";
        var data = id ? {id : id} : {};
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'presupuesto', action:'form_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id    : "dlgCreateEditPR",
                    title : title + " presupuesto",
                    // class : "modal-lg",
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
                setTimeout(function () {
                    b.find(".form-control").first().focus()
                }, 500);
            } //success
        }); //ajax
    } //createEdit

    function submitFormPresupuesto() {
        var $form = $("#frmSave-presupuestoInstance");
        if ($form.valid()) {
            var data = $form.serialize();
            var dd = cargarLoader("Guardando...");
            $.ajax({
                type    : "POST",
                url     : $form.attr("action"),
                data    : data,
                success : function (msg) {
                    dd.modal('hide');
                    var parts = msg.split("_");
                    if(parts[0] === 'ok'){
                        log(parts[1], "success");
                        $("#item_prsp").val(parts[2]);
                        $("#item_presupuesto").val(parts[3]);
                        $("#item_desc").val(parts[4]);
                        $("#item_fuente").val(parts[5]);
                        $("#item_prog").val(parts[6]);
                        $("#item_spro").val(parts[7]);
                        $("#item_proy").val(parts[8]);
                    }else{
                        bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                        return false;
                    }
                }
            });
        } else {
            return false;
        }
    }


    function createEditAsignacion(id) {
        var title = id ? "Editar " : "Crear ";
        var data = id ? {id : id} : {};

        $.ajax({
            type    : "POST",
            url: "${createLink(controller: 'asignacion', action:'formAsignacion_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEditAsignacion",
                    title   : title + " Asignación",
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
                                return submitFormAsignacion();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    } //createEdit

    function submitFormAsignacion() {
        var $form = $("#frmAsignacion");
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
                        cargarAsignaciones();
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

    $(".btnNuevaAsignacion").click(function () {
        createEditAsignacion();
    })

</script>

</body>
</html>