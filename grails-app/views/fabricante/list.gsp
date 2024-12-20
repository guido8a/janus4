
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Lista de Fabricantes</title>
</head>
<body>

<div>
    <fieldset class="borde" style="border-radius: 4px; margin-bottom: 10px">
        <div class="row-fluid" style="margin-left: 10px">

            <span class="col-md-3">
                <div class="btn-toolbar toolbar" style="margin-top: 20px">
                    <div class="btn-group">
                        <g:if test="${tipo == '1'}">
                            <g:link controller="mantenimientoItems" action="registro" class="btn btn-primary">
                                <i class="fa fa-arrow-left"></i> Regresar
                            </g:link>
                        </g:if>
                        <g:else>
                            <g:link controller="inicio" action="parametros" class="btn btn-primary">
                                <i class="fa fa-arrow-left"></i> Regresar
                            </g:link>
                        </g:else>
                    </div>
                    <div class="btn-group">
                        <g:link action="form" class="btn btn-success btnCrear">
                            <i class="fa fa-clipboard-list"></i> Nuevo fabricante
                        </g:link>
                    </div>
                </div>
            </span>

            <span class="grupo">
                <span class="col-md-2">
                    <label class="control-label text-info">Buscar Por</label>
                    <g:select name="buscarPor" class="buscarPor col-md-12 form-control btn-success" from="${[1: 'Nombre', 2: 'RUC']}" optionKey="key"
                              optionValue="value"/>
                </span>
                <span class="col-md-4">
                    <label class="control-label text-info">Criterio</label>
                    <g:textField name="criterio" id="criterio" class="form-control"/>
                </span>
            </span>
            <div class="col-md-2" style="margin-top: 20px">
                <button class="btn btn-info" id="btnBuscar"><i class="fa fa-search"></i></button>
                <button class="btn btn-warning" id="btnLimpiar" title="Limpiar Búsqueda"><i class="fa fa-eraser"></i></button>
            </div>

        </div>
    </fieldset>

    <fieldset class="borde" style="border-radius: 4px">
        <div id="divTablaFabricantes" >
        </div>
    </fieldset>
</div>


<script type="text/javascript">
    var id = null;

    $("#buscarPor").change(function () {
        cargarTablaFabricantes();
    });

    $("#btnLimpiar").click(function () {
        $("#buscarPor").val(1);
        $("#criterio").val('');
        cargarTablaFabricantes();
    });

    $("#btnBuscar").click(function () {
        cargarTablaFabricantes();
    });

    cargarTablaFabricantes();

    function cargarTablaFabricantes(){
        var buscarPor = $("#buscarPor option:selected").val();
        var criterio = $("#criterio").val();
        var d = cargarLoader("Cargando...");
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'fabricante', action: 'tablaFabricantes_ajax')}',
            data:{
                buscarPor: buscarPor,
                criterio: criterio
            },
            success: function (msg){
                d.modal("hide");
                $("#divTablaFabricantes").html(msg)
            }
        })
    }

    function createEditRow(id) {
        var title = id ? "Editar" : "Crear";
        var data = id ? { id: id } : {};
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'fabricante', action:'form_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEditF",
                    title   : title + " Fabricante",
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
                                return submitForm();
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

    function submitForm() {
        var $form = $("#frmFabricante");
        if ($form.valid()) {
            $.ajax({
                type    : "POST",
                url     : '${createLink(controller: 'fabricante', action:'save_ajax')}',
                data    : $form.serialize(),
                success : function (msg) {
                    var parts = msg.split("_");
                    if(parts[0] === 'ok'){
                        log(parts[1], "success");
                        cargarTablaFabricantes();
                    }else{
                        bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                        return false;
                    }
                }
            });
        } else {
            return false;
        } //else
    }
    function deleteRow(itemId) {
        bootbox.dialog({
            title   : "Alerta",
            message : "<i class='fa fa-trash fa-2x pull-left text-danger text-shadow'></i><p style='font-weight: bold; font-size: 14px'> ¿Está seguro que desea eliminar el fabricante seleccionado?.</p>",
            buttons : {
                cancelar : {
                    label     : "Cancelar",
                    className : "btn-primary",
                    callback  : function () {
                    }
                },
                eliminar : {
                    label     : "<i class='fa fa-trash'></i> Eliminar",
                    className : "btn-danger",
                    callback  : function () {
                        $.ajax({
                            type    : "POST",
                            url     : '${createLink(controller: 'fabricante', action:'delete_ajax')}',
                            data    : {
                                id : itemId
                            },
                            success : function (msg) {
                                var parts = msg.split("_");
                                if(parts[0] === 'ok'){
                                    log(parts[1],"success");
                                    cargarTablaFabricantes();
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
    }

    $(".btnCrear").click(function() {
        createEditRow();
        return false;
    });

    $("#criterio").keydown(function (ev) {
        if (ev.keyCode === 13) {
            cargarTablaFabricantes();
            return false;
        }
        return true;
    });

</script>

</body>
</html>
