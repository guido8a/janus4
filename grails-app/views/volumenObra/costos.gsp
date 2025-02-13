<%@ page import="janus.Grupo" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Costos
    </title>

    <style type="text/css">
    .boton {
        padding: 2px 6px;
        margin-top: -10px
    }

    </style>
</head>

<body>

<div class="row" role="navigation" style="margin-left: 35px;">
    <div class="col-md-1 btn-group" role="navigation">
        <a href="${g.createLink(controller: 'obra', action: 'registroObra', params: [obra: obra?.id])}"
           class="btn btn-info btn-new" id="atras" title="Regresar a la obra">
            <i class="fa fa-arrow-left"></i>
            Regresar
        </a>
    </div>

    <div class="alert alert-info col-md-10" style="font-size: 14px;">
        Obra: ${obra.nombre + " (" + obra.codigo + ")"}
        <input type="hidden" id="override" value="0">
    </div>
</div>

<div class="row">
    <div class="col-md-12">
        <div class="col-md-4" style="margin-top: 20px;">
            <a href="#" class="btn btn-success" id="btnAgregarCostos" title="Agregar costos">
                <i class="fa fa-plus-square"></i>
                Agregar costos
            </a>
        </div>
    </div>
</div>

<div id="list-grupo" class="col-md-12" role="main" style="margin-top: 20px;margin-left: 0px">
    <div class="borde_abajo" style="padding-left: 5px;position: relative; height: 92px">

%{--        <div class="borde_abajo" style="position: relative;float: left;width: 100%;padding-left: 45px">--}%
%{--            <p class="css-vertical-text">Composición</p>--}%

%{--            <div class="linea" style="height: 98%;"></div>--}%

            <div style="width: 99.7%;height: 400px;overflow-y: auto;float: right;" id="divTablaCostos"></div>

%{--        </div>--}%
    </div>

</div>

<script type="text/javascript">

    $("#btnAgregarCostos").click(function () {
        location.href="${createLink(controller: 'volumenObra', action: 'buscarCostos')}/" + '${obra?.id}';
    });

    function cargarTabla() {
        var d = cargarLoader("Cargando...");
        $.ajax({
            type : "POST",
            url : "${g.createLink(controller: 'volumenObra', action:'tablaCostos_ajax')}",
            data     : {
                obra: '${obra?.id}'
            },
            success  : function (msg) {
                d.modal("hide");
                $("#divTablaCostos").html(msg);
            }
        });
    }

    cargarTabla();

    function formCostoP(id, costo){
        $.ajax({
            type    : "POST",
            url: "${createLink(controller: 'volumenObra', action:'formCosto_ajax')}",
            data    : {
                id: id,
                costo: costo,
                obra: '${obra?.id}'
            },
            success : function (msg) {
                var er = bootbox.dialog({
                    id      : "dlgCreateEditCosto",
                    title   : "Costo",
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
                                return submitFormCostoP();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    }

    function submitFormCostoP() {
        var $form = $("#frmCosto");
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
                        cargarTabla();
                    }else{
                        if(parts[0] === 'err'){
                            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                            return false;
                        }else{
                            log(parts[1], "error");
                            return false;
                        }
                    }
                }
            });
        } else {
            return false;
        }
    }

    function borrarCostoP(id){
        bootbox.confirm({
            title: "Eliminar",
            message: "<i class='fa fa-exclamation-triangle text-info fa-3x'></i> <strong style='font-size: 14px'> Está seguro de eliminar este costo?</strong> ",
            buttons: {
                cancel: {
                    label: '<i class="fa fa-times"></i> Cancelar',
                    className: 'btn-primary'
                },
                confirm: {
                    label: '<i class="fa fa-trash"></i> Borrar',
                    className: 'btn-danger'
                }
            },
            callback: function (result) {
                if(result){
                    var d = cargarLoader("Borrando...");
                    $.ajax({
                        type : "POST",
                        url : "${g.createLink(controller: 'volumenObra',action:'deleteCosto_ajax')}",
                        data     : {
                            id: id
                        },
                        success  : function (msg) {
                            d.modal("hide");
                            var parts = msg.split("_");
                            if(parts[0] === "ok"){
                                log(parts[1], "success");
                                cargarTabla();
                            }else{
                                bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] +'</strong>');
                            }
                        }
                    });
                }
            }
        });
    }

</script>
</body>
</html>