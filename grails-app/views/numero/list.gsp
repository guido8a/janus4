
<%@ page import="janus.EstadoObra" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Numeración
    </title>
</head>
<body>

<div class="col-md-2 btn-group" role="navigation">
    <g:link class="link btn btn-primary" controller="inicio" action="parametros">
        <i class="fa fa-arrow-left"></i>
        Parámetros
    </g:link>
</div>
<div class="col-md-2 btn-group" role="navigation">
</div>
<div class="col-md-2 btn-group" role="navigation">
    <a class="btn btn-warning btnReiniciar" href="#"  title="Reiniciar valores">
        <i class="fa fa-recycle"></i> Reiniciar todos los valores
    </a>
</div>

<div class="col-md-12" role="main" style="margin-top: 10px;">
    <table class="table table-bordered table-striped table-condensed table-hover" style="width: 600px !important">
        <thead>
        <tr>
            <th width="50%">Numeración para:</th>
            <th whith="20%">Código<br>a usar<br>(Prefijo)</th>
            <th whith="20%">Número</th>
            <th whith="10%">Acciones</th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${numeros}" status="i" var="numero">
            <tr>
                <td>${numero?.tipoNumero?.descripcion}</td>
                <td>${numero?.descripcion}</td>
                <td style="text-align: center">${numero?.valor}</td>
                <td style="text-align: center">
                    <a class="btn btn-success btn-xs btn-edit" href="#"  title="Editar" data-id="${numero.id}">
                        <i class="fa fa-edit"></i>
                    </a>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>


<script type="text/javascript">

    $(".btnReiniciar").click(function () {
        bootbox.dialog({
            title   : "Alerta",
            message : "<i class='fa fa-trash fa-2x pull-left text-danger text-shadow'></i><p style='font-weight: bold; font-size: 14px'> ¿Está seguro que desea reiniciar todos los valores a 1?.</p>",
            buttons : {
                cancelar : {
                    label     : "Cancelar",
                    className : "btn-primary",
                    callback  : function () {
                    }
                },
                eliminar : {
                    label     : "<i class='fa fa-check'></i> Aceptar",
                    className : "btn-success",
                    callback  : function () {
                        $.ajax({
                            type    : "POST",
                            url     : '${createLink(controller: 'numero', action:'reiniciar_ajax')}',
                            data    : {

                            },
                            success : function (msg) {
                                var parts = msg.split("_");
                                if(parts[0] === 'ok'){
                                    log(parts[1], "success");
                                    setTimeout(function () {
                                        location.reload();
                                    }, 800);
                                }else{
                                    bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                                    return false;
                                }
                            }
                        });
                    }
                }
            }
        });
    });

    function createEditRow(id) {
        var title = id ? "Editar " : "Crear ";
        var data = id ? {id : id} : {};

        $.ajax({
            type    : "POST",
            url: "${createLink(action:'form_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : title + "Numeración",
                    message : msg,
                    class: "modal-sm",
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
                                return submitFormNumero();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    } //createEdit

    function submitFormNumero() {
        var $form = $("#frmNumero");
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
                        setTimeout(function () {
                            location.reload();
                        }, 800);
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

    $(".btn-edit").click(function () {
        var id = $(this).data("id");
        createEditRow(id);
    }); //click btn edit

</script>
</body>
</html>