<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Registro y Mantenimiento de Items</title>


    <style>

    </style>
</head>

<body>

<div>
    <fieldset class="borde" style="border-radius: 4px; margin-bottom: 10px">
        <div class="row-fluid" style="margin-left: 10px">
            <span class="grupo">
                <span class="col-md-2">
                    <label class="control-label text-info">Buscar Por</label>
                    <g:select name="buscarPor" class="buscarPor col-md-12 form-control btn-success" from="${[1: 'Materiales', 2: 'Mano de Obra', 3: 'Equipos']}" optionKey="key"
                              optionValue="value"/>
                </span>
                <span class="col-md-2">
                    <label class="control-label text-info">Tipo</label>
                    <g:select name="tipo" class="tipo col-md-12 form-control btn-info" from="${[1: 'Grupo', 2: 'Subgrupo', 3: 'Materiales']}" optionKey="key"
                              optionValue="value"/>
                </span>
                <span class="col-md-4">
                    <label class="control-label text-info">Criterio</label>
                    <g:textField name="criterio" id="criterio" class="form-control"/>
                </span>
            </span>
            <div class="col-md-2" style="margin-top: 20px">
                <button class="btn btn-info" id="btnBuscar"><i class="fa fa-search"></i>Buscar</button>
                <button class="btn btn-warning" id="btnLimpiar" title="Limpiar Búsqueda"><i class="fa fa-eraser"></i>Limpiar</button>
            </div>
        </div>
    </fieldset>

    <fieldset class="borde" style="border-radius: 4px">
        <div id="divTablaItems" >
        </div>
    </fieldset>
</div>


<script type="text/javascript">

    var dfi;

    $("#btnLimpiar").click(function () {
        $("#buscarPor, #tipo").val(1);
        $("#criterio").val('');
        cargarTablaItems();
    });

    $("#buscarPor, #tipo").change(function () {
        cargarTablaItems();
    });

    $("#btnBuscar").click(function () {
        cargarTablaItems();
    });

    cargarTablaItems();

    function cargarTablaItems(id) {
        var d = cargarLoader("Cargando...");
        var buscarPor = $("#buscarPor option:selected").val();
        var tipo = $("#tipo option:selected").val();
        var criterio = $("#criterio").val();
        var url = '';

        switch (tipo) {
            case "1":
                url = '${createLink(controller: 'mantenimientoItems', action: 'tablaGrupos_ajax')}';
                break;
            case "2":
                url = '${createLink(controller: 'mantenimientoItems', action: 'tablaSubgrupos_ajax')}';
                break;
            case "3":
                url = '${createLink(controller: 'mantenimientoItems', action: 'tablaMateriales_ajax')}';
                break;
        }

        $.ajax({
            type: 'POST',
            url: url,
            data:{
                buscarPor: buscarPor,
                tipo: tipo,
                criterio: criterio,
                id: id
            },
            success: function (msg){
                d.modal("hide");
                $("#divTablaItems").html(msg)
            }
        })
    }

    %{--function dialogoBuscar(tipo){--}%
    %{--    $.ajax({--}%
    %{--        type    : "POST",--}%
    %{--        url     :  "${createLink(controller: 'mantenimientoItems', action:'tablaBusqueda_ajax')}",--}%
    %{--        data    : {--}%
    %{--            criterio: $("#searchArbol").val(),--}%
    %{--            tipo: tipo--}%
    %{--        },--}%
    %{--        success : function (msg) {--}%
    %{--            var b = bootbox.dialog({--}%
    %{--                id      : "dlgShowB",--}%
    %{--                title   : "Búsqueda",--}%
    %{--                class   : "modal-lg",--}%
    %{--                message : msg,--}%
    %{--                buttons : {--}%
    %{--                    cancelar : {--}%
    %{--                        label     : "Cancelar",--}%
    %{--                        className : "btn-primary",--}%
    %{--                        callback  : function () {--}%
    %{--                        }--}%
    %{--                    }--}%
    %{--                } //buttons--}%
    %{--            }); //dialog--}%
    %{--        } //success--}%
    %{--    }); //ajax--}%
    %{--}--}%

    // function showInfo() {
    //     var node = $("#tree").jstree(true).get_selected();
    //
    //     var nodeId = node.toString().split("_")[1];
    //     var nodeNivel = node.toString().split("_")[0];
    //
    //     if(nodeNivel !== 'root'){
    //         cargarInfo(nodeNivel, nodeId);
    //     }
    // }
    //
    // function showInfo2() {
    //     var node = $("#tree2").jstree(true).get_selected();
    //
    //     var nodeId = node.toString().split("_")[1];
    //     var nodeNivel = node.toString().split("_")[0];
    //
    //     if(nodeNivel !== 'root'){
    //         cargarInfo(nodeNivel, nodeId);
    //     }
    // }
    //
    // function showInfo3() {
    //     var node = $("#tree3").jstree(true).get_selected();
    //
    //     var nodeId = node.toString().split("_")[1];
    //     var nodeNivel = node.toString().split("_")[0];
    //
    //     if(nodeNivel !== 'root'){
    //         cargarInfo(nodeNivel, nodeId);
    //     }
    // }

    %{--function cargarInfo(nodeNivel, nodeId){--}%
    %{--    switch (nodeNivel) {--}%
    %{--        case "gp":--}%
    %{--            url = "${createLink(action:'showGr_ajax')}";--}%
    %{--            break;--}%
    %{--        case "sg":--}%
    %{--            url = "${createLink(action:'showSg_ajax')}";--}%
    %{--            break;--}%
    %{--        case "dp":--}%
    %{--            url = "${createLink(action:'showDp_ajax')}";--}%
    %{--            break;--}%
    %{--        case "it":--}%
    %{--            url = "${createLink(action:'showIt_ajax')}";--}%
    %{--            break;--}%
    %{--    }--}%

    %{--    $.ajax({--}%
    %{--        type    : "POST",--}%
    %{--        url     : url,--}%
    %{--        data    : {--}%
    %{--            id : nodeId--}%
    %{--        },--}%
    %{--        success : function (msg) {--}%
    %{--            $("#info").removeClass('hide');--}%
    %{--            $("#info").html(msg);--}%
    %{--        }--}%
    %{--    });--}%
    %{--}--}%





    %{--function createContextMenu(node) {--}%

    %{--    var nodeStrId = node.id;--}%
    %{--    var $node = $("#" + nodeStrId);--}%
    %{--    var nodeId = nodeStrId.split("_")[1];--}%
    %{--    var parentId = $node.parent().parent().children()[1].id.split("_")[1];--}%
    %{--    var nodeType = $node.data("jstree").type;--}%
    %{--    var esRoot = nodeType === "root";--}%
    %{--    var esPrincipal = nodeType === "principal";--}%
    %{--    var esSubgrupo = nodeType.contains("subgrupo");--}%
    %{--    var esDepartamento = nodeType.contains("departamento");--}%
    %{--    var esItem = nodeType.contains("item");--}%
    %{--    var tipoGrupo = $node.data("tipo");--}%
    %{--    var nodeHasChildren = $node.hasClass("hasChildren");--}%
    %{--    var abueloId = null;--}%

    %{--    if(esDepartamento){--}%
    %{--        abueloId = $node.parent().parent().parent().parent().children()[1].id.split("_")[1];--}%
    %{--    }else{--}%
    %{--        abueloId = parentId--}%
    %{--    }--}%

    %{--    var items = {};--}%

    %{--    var nuevoGrupo = {--}%
    %{--        label  : "Nuevo grupo",--}%
    %{--        icon   : "fa fa-copyright text-info",--}%
    %{--        action : function () {--}%
    %{--            createEditGrupo(null, nodeId);--}%
    %{--        }--}%
    %{--    };--}%

    %{--    var editarGrupo = {--}%
    %{--        label  : "Editar grupo",--}%
    %{--        icon   : "fa fa-copyright text-info",--}%
    %{--        action : function () {--}%
    %{--            createEditGrupo(nodeId, parentId);--}%
    %{--        }--}%
    %{--    };--}%

    %{--    var nuevoSubgrupo = {--}%
    %{--        label  : "Nuevo subgrupo",--}%
    %{--        icon   : "fa fa-registered text-danger",--}%
    %{--        action : function () {--}%
    %{--            createEditSubgrupo(null, nodeId, abueloId);--}%
    %{--        }--}%
    %{--    };--}%

    %{--    var editarSubgrupo = {--}%
    %{--        label  : "Editar subgrupo",--}%
    %{--        icon   : "fa fa-registered text-danger",--}%
    %{--        action : function () {--}%
    %{--            createEditSubgrupo(nodeId, parentId, abueloId);--}%
    %{--        }--}%
    %{--    };--}%

    %{--    var nuevoMaterial = {--}%
    %{--        label  : "Nuevo material",--}%
    %{--        icon   : "fa fa-info-circle text-warning",--}%
    %{--        action : function () {--}%
    %{--            createEditItem(null, nodeId);--}%
    %{--        }--}%
    %{--    };--}%

    %{--    var nuevaManoObra = {--}%
    %{--        label  : "Nueva mano de obra",--}%
    %{--        icon   : "fa fa-info-circle text-warning",--}%
    %{--        action : function () {--}%
    %{--            createEditItem(null, nodeId);--}%
    %{--        }--}%
    %{--    };--}%

    %{--    var nuevoEquipo = {--}%
    %{--        label  : "Nuevo equipo",--}%
    %{--        icon   : "fa fa-info-circle text-warning",--}%
    %{--        action : function () {--}%
    %{--            createEditItem(null, nodeId);--}%
    %{--        }--}%
    %{--    };--}%

    %{--    var editarMaterial = {--}%
    %{--        label  : "Editar material",--}%
    %{--        icon   : "fa fa-info-circle text-warning",--}%
    %{--        action : function () {--}%
    %{--            createEditItem(nodeId, parentId);--}%
    %{--        }--}%
    %{--    };--}%

    %{--    var editarManoObra = {--}%
    %{--        label  : "Editar mano de obra",--}%
    %{--        icon   : "fa fa-info-circle text-warning",--}%
    %{--        action : function () {--}%
    %{--            createEditItem(nodeId, parentId);--}%
    %{--        }--}%
    %{--    };--}%

    %{--    var editarEquipo = {--}%
    %{--        label  : "Editar equipo",--}%
    %{--        icon   : "fa fa-info-circle text-warning",--}%
    %{--        action : function () {--}%
    %{--            createEditItem(nodeId, parentId);--}%
    %{--        }--}%
    %{--    };--}%

    %{--    var verItem = {--}%
    %{--        label            : "Ver información del Item",--}%
    %{--        icon             : "fa fa-laptop text-info",--}%
    %{--        separator_before : true,--}%
    %{--        action           : function () {--}%
    %{--            $.ajax({--}%
    %{--                type    : "POST",--}%
    %{--                url     : "${createLink(action:'infoItems')}",--}%
    %{--                data    : {--}%
    %{--                    id : nodeId--}%
    %{--                },--}%
    %{--                success : function (msg) {--}%
    %{--                    bootbox.dialog({--}%
    %{--                        title   : "Ver información del Item",--}%
    %{--                        message : msg,--}%
    %{--                        class : 'modal-lg',--}%
    %{--                        buttons : {--}%
    %{--                            ok : {--}%
    %{--                                label     : "Aceptar",--}%
    %{--                                className : "btn-primary",--}%
    %{--                                callback  : function () {--}%
    %{--                                }--}%
    %{--                            }--}%
    %{--                        }--}%
    %{--                    });--}%
    %{--                }--}%
    %{--            });--}%
    %{--        }--}%
    %{--    };--}%

    %{--    var borrarGrupo = {--}%
    %{--        label            : "Eliminar Grupo",--}%
    %{--        icon             : "fa fa-trash text-danger",--}%
    %{--        separator_before : true,--}%
    %{--        action           : function () {--}%
    %{--            bootbox.confirm({--}%
    %{--                title: "Eliminar Grupo",--}%
    %{--                message: "Está seguro de borrar este grupo? Esta acción no puede deshacerse.",--}%
    %{--                buttons: {--}%
    %{--                    cancel: {--}%
    %{--                        label: '<i class="fa fa-times"></i> Cancelar',--}%
    %{--                        className: 'btn-primary'--}%
    %{--                    },--}%
    %{--                    confirm: {--}%
    %{--                        label: '<i class="fa fa-trash"></i> Borrar',--}%
    %{--                        className: 'btn-danger'--}%
    %{--                    }--}%
    %{--                },--}%
    %{--                callback: function (result) {--}%
    %{--                    if(result){--}%
    %{--                        var dialog = cargarLoader("Borrando...");--}%
    %{--                        $.ajax({--}%
    %{--                            type: 'POST',--}%
    %{--                            url: '${createLink(action: 'deleteSg_ajax')}',--}%
    %{--                            data:{--}%
    %{--                                id: nodeId--}%
    %{--                            },--}%
    %{--                            success: function (msg) {--}%
    %{--                                dialog.modal('hide');--}%
    %{--                                if(msg === 'OK'){--}%
    %{--                                    log("Grupo borrado correctamente","success");--}%
    %{--                                    setTimeout(function () {--}%
    %{--                                        if(tipoSeleccionado === 1){--}%
    %{--                                            recargarMateriales();--}%
    %{--                                        }else if(tipoSeleccionado === 2){--}%
    %{--                                            recargaMano();--}%
    %{--                                        }else{--}%
    %{--                                            recargaEquipo();--}%
    %{--                                        }--}%
    %{--                                    }, 1000);--}%
    %{--                                }else{--}%
    %{--                                    log("Error al borrar el grupo", "error")--}%
    %{--                                }--}%
    %{--                            }--}%
    %{--                        });--}%
    %{--                    }--}%
    %{--                }--}%
    %{--            });--}%
    %{--        }--}%
    %{--    };--}%

    %{--    var borrarSubgrupo = {--}%
    %{--        label            : "Eliminar subgrupo",--}%
    %{--        icon             : "fa fa-trash text-danger",--}%
    %{--        separator_before : true,--}%
    %{--        action           : function () {--}%
    %{--            bootbox.confirm({--}%
    %{--                title: "Eliminar subgrupo",--}%
    %{--                message: "Está seguro de borrar este subgrupo? Esta acción no puede deshacerse.",--}%
    %{--                buttons: {--}%
    %{--                    cancel: {--}%
    %{--                        label: '<i class="fa fa-times"></i> Cancelar',--}%
    %{--                        className: 'btn-primary'--}%
    %{--                    },--}%
    %{--                    confirm: {--}%
    %{--                        label: '<i class="fa fa-trash"></i> Borrar',--}%
    %{--                        className: 'btn-danger'--}%
    %{--                    }--}%
    %{--                },--}%
    %{--                callback: function (result) {--}%
    %{--                    if(result){--}%
    %{--                        var dialog = cargarLoader("Borrando...");--}%
    %{--                        $.ajax({--}%
    %{--                            type: 'POST',--}%
    %{--                            url: '${createLink(action: 'deleteDp_ajax')}',--}%
    %{--                            data:{--}%
    %{--                                id: nodeId--}%
    %{--                            },--}%
    %{--                            success: function (msg) {--}%
    %{--                                dialog.modal('hide');--}%
    %{--                                if(msg === 'OK'){--}%
    %{--                                    log("Subgrupo borrado correctamente","success");--}%
    %{--                                    setTimeout(function () {--}%
    %{--                                        if(tipoSeleccionado === 1){--}%
    %{--                                            recargarMateriales();--}%
    %{--                                        }else if(tipoSeleccionado === 2){--}%
    %{--                                            recargaMano();--}%
    %{--                                        }else{--}%
    %{--                                            recargaEquipo();--}%
    %{--                                        }--}%
    %{--                                    }, 1000);--}%
    %{--                                }else{--}%
    %{--                                    log("Error al borrar el Subgrupo", "error")--}%
    %{--                                }--}%
    %{--                            }--}%
    %{--                        });--}%
    %{--                    }--}%
    %{--                }--}%
    %{--            });--}%
    %{--        }--}%
    %{--    };--}%

    %{--    var borrarItem = {--}%
    %{--        label            : "Eliminar item",--}%
    %{--        icon             : "fa fa-trash text-danger",--}%
    %{--        separator_before : true,--}%
    %{--        action           : function () {--}%
    %{--            bootbox.confirm({--}%
    %{--                title: "Eliminar item",--}%
    %{--                message: "Está seguro de borrar este item? Esta acción no puede deshacerse.",--}%
    %{--                buttons: {--}%
    %{--                    cancel: {--}%
    %{--                        label: '<i class="fa fa-times"></i> Cancelar',--}%
    %{--                        className: 'btn-primary'--}%
    %{--                    },--}%
    %{--                    confirm: {--}%
    %{--                        label: '<i class="fa fa-trash"></i> Borrar',--}%
    %{--                        className: 'btn-danger'--}%
    %{--                    }--}%
    %{--                },--}%
    %{--                callback: function (result) {--}%
    %{--                    if(result){--}%
    %{--                        var dialog = cargarLoader("Borrando...");--}%
    %{--                        $.ajax({--}%
    %{--                            type: 'POST',--}%
    %{--                            url: '${createLink(action: 'deleteIt_ajax')}',--}%
    %{--                            data:{--}%
    %{--                                id: nodeId--}%
    %{--                            },--}%
    %{--                            success: function (msg) {--}%
    %{--                                dialog.modal('hide');--}%
    %{--                                if(msg === 'OK'){--}%
    %{--                                    log("Borrado correctamente","success");--}%
    %{--                                    setTimeout(function () {--}%
    %{--                                        if(tipoSeleccionado === 1){--}%
    %{--                                            recargarMateriales();--}%
    %{--                                        }else if(tipoSeleccionado === 2){--}%
    %{--                                            recargaMano();--}%
    %{--                                        }else{--}%
    %{--                                            recargaEquipo();--}%
    %{--                                        }--}%
    %{--                                    }, 1000);--}%
    %{--                                }else{--}%
    %{--                                    log("Error al borrar", "error")--}%
    %{--                                }--}%
    %{--                            }--}%
    %{--                        });--}%
    %{--                    }--}%
    %{--                }--}%
    %{--            });--}%
    %{--        }--}%
    %{--    };--}%

    %{--    var copiarOferentes = {--}%
    %{--        label            : "Copiar a oferentes",--}%
    %{--        icon             : "fa fa-file text-success",--}%
    %{--        separator_before : true,--}%
    %{--        action           : function () {--}%
    %{--            $.ajax({--}%
    %{--                type    : "POST",--}%
    %{--                url     : "${createLink(action:'copiarOferentes')}",--}%
    %{--                data    : {--}%
    %{--                    id : nodeId--}%
    %{--                },--}%
    %{--                success : function (msg) {--}%
    %{--                    var parts =  msg.split("_");--}%
    %{--                    if(parts[0] === 'OK'){--}%
    %{--                        log("Item copiado a oferentes","success")--}%
    %{--                    }else{--}%
    %{--                        log("Error al copiar el item a oferentes","error")--}%
    %{--                    }--}%
    %{--                }--}%
    %{--            });--}%
    %{--        }--}%
    %{--    };--}%


    %{--    if (esRoot) {--}%
    %{--    } else if (esPrincipal) {--}%
    %{--        if(tipoGrupo !== 2){--}%
    %{--            items.nuevoGrupo = nuevoGrupo;--}%
    %{--        }--}%
    %{--    } else if (esSubgrupo) {--}%
    %{--        if(tipoGrupo !== 2){--}%
    %{--            items.editarGrupo = editarGrupo;--}%
    %{--        }--}%
    %{--        items.nuevoSubgrupo = nuevoSubgrupo;--}%
    %{--        if(!nodeHasChildren){--}%
    %{--            items.borrarGrupo = borrarGrupo;--}%
    %{--        }--}%
    %{--    } else if (esDepartamento) {--}%
    %{--        items.editarSubgrupo = editarSubgrupo;--}%
    %{--        if(tipoGrupo === 1){--}%
    %{--            items.nuevoMaterial= nuevoMaterial;--}%
    %{--        }else if(tipoGrupo === 2){--}%
    %{--            items.nuevaManoObra= nuevaManoObra;--}%
    %{--        }else if(tipoGrupo === 3){--}%
    %{--            items.nuevoEquipo= nuevoEquipo;--}%
    %{--        }--}%
    %{--        if(!nodeHasChildren){--}%
    %{--            items.borrarSubgrupo = borrarSubgrupo;--}%
    %{--        }--}%

    %{--    } else if (esItem) {--}%
    %{--        items.verItem = verItem;--}%
    %{--        if(tipoGrupo === 1){--}%
    %{--            items.editarMaterial= editarMaterial;--}%
    %{--        }else if(tipoGrupo === 2){--}%
    %{--            items.editarManoObra= editarManoObra;--}%
    %{--        }else if(tipoGrupo === 3){--}%
    %{--            items.editarEquipo= editarEquipo;--}%
    %{--        }--}%
    %{--        items.copiarOferentes = copiarOferentes;--}%
    %{--        if(!nodeHasChildren){--}%
    %{--            items.borrarItem = borrarItem;--}%
    %{--        }--}%
    %{--    }--}%
    %{--    return items;--}%
    %{--}--}%

    function createEditItem(id, parentId) {
        var title = id ? "Editar" : "Crear";
        var data = id ? {id : id} : {};
        data.departamento = parentId;
        $.ajax({
            type    : "POST",
            url     : "${createLink( action:'formIt_ajax')}",
            data    : data,
            success : function (msg) {
                dfi= bootbox.dialog({
                    id    : "dlgCreateEditIT",
                    title : title + " item",
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
                                return submitFormItem();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    } //createEdit

    function submitFormItem() {
        var $form = $("#frmSave");
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
                        cerrarFormItem();
                        $("#tipo").val(3);
                        cargarTablaItems(parts[2]);
                    }else{
                        bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                        return false;
                    }
                }
            });
            return false;
        } else {
            return false;
        }
    }

    function cerrarFormItem(){
        dfi.modal("hide");
    }


    $("#criterio").keydown(function (ev) {
        if (ev.keyCode === 13) {
            cargarTablaItems();
            return false;
        }
        return true;
    });


</script>

</body>
</html>