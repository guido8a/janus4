<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Registro y Mantenimiento de Precios</title>

</head>

<body>

<div class="span12 btn-group" >



    <div class="col-md-12 btn-group"  style="margin-bottom: 5px; margin-top: 10px">

        <div class="btn-group">
            <a href="#" id="btnItems" class="btn">
                <i class="fa fa-list-ul"></i> Items
            </a>
            <g:if test="${session.perfil.codigo == 'CSTO'}">
                <a href="#" id="btnMantenimientoPrecios" class="btn">
                    <i class="fa fa-money-bill"></i> Mantenimiento de precios
                </a>
                <a href="#" id="btnPreciosVolumen" class="btn">
                    <i class="fa fa-money-bill"></i> Precios por Volumen
                </a>
                <a href="#" id="btnRegistrar" class="btn">
                    <i class="fa fa-check"></i> Registrar
                </a>
            </g:if>
            <a href="#" id="btnReporte" class="btn btn-ajax">
                <i class="fa fa-print"></i> Reporte
            </a>
            <a href="#" id="btnReporteMinas" class="btn btn-success">
                <i class="fa fa-file-excel"></i> Reporte Minas
            </a>
        </div>

        <span class="col-md-2">
            Fecha por
            defecto:
        </span>

        <span class="col-md-2">
            <input aria-label="" name="fechaPorDefecto" id='datetimepicker2' type='text' class="form-control" value="${ new Date().format("dd-MM-yyyy")}"/>
        </span>

    </div>
</div>

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
                <span class="col-md-3">
                    <label class="control-label text-info">Criterio</label>
                    <g:textField name="criterio" id="criterio" class="form-control"/>
                </span>
            </span>
            <div class="col-md-2" style="margin-top: 20px">
                <button class="btn btn-info" id="btnBuscar"><i class="fa fa-search"></i></button>
                <button class="btn btn-warning" id="btnLimpiar" title="Limpiar Búsqueda"><i class="fa fa-eraser"></i></button>
            </div>
            <div class="col-md-2" style="width: 260px; margin-top: 21px">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="#" id="bc_grpo">Grupo</a></li>
                    <li class="breadcrumb-item"><a href="#" id="bc_sbgr">Subgrupo</a></li>
                    <li class="breadcrumb-item" aria-current="page" id="bc_item">Items</li>
                </ol>
            </div>

        </div>
    </fieldset>

    <fieldset class="borde" style="border-radius: 4px">
        <div id="divTablaItemsPrecios" >
        </div>
    </fieldset>
</div>



<script type="text/javascript">

    var dfi;

    $("#btnLimpiar").click(function () {
        $("#buscarPor, #tipo").val(1);
        $("#criterio").val('');
        cargarTablaItemsPrecios();
    });

    $("#buscarPor, #tipo").change(function () {
        cargarTablaItemsPrecios();
    });

    $("#btnBuscar").click(function () {
        cargarTablaItemsPrecios();
    });

    cargarTablaItemsPrecios();

    function cargarTablaItemsPrecios(id) {
        var d = cargarLoader("Cargando...");
        var buscarPor = $("#buscarPor option:selected").val();
        var tipo = $("#tipo option:selected").val();
        var criterio = $("#criterio").val();
        var url = '';

        switch (tipo) {
            case "1":
                url = '${createLink(controller: 'mantenimientoItems', action: 'tablaGruposPrecios_ajax')}';
                break;
            case "2":
                url = '${createLink(controller: 'mantenimientoItems', action: 'tablaSubgruposPrecios_ajax')}';
                break;
            case "3":
                url = '${createLink(controller: 'mantenimientoItems', action: 'tablaMaterialesPrecios_ajax')}';
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
                $("#divTablaItemsPrecios").html(msg);
                switch (tipo) {
                    case "1":
                        $('#bc_grpo').html('Grupo');
                        $('#bc_sbgr').hide();
                        $('#bc_item').hide();
                        break;
                    case "2":
                        $('#bc_grpo').html('Grupo');
                        var li = $('#li_sbgr');
                        var elemento = document.createElement('a');
                        elemento.id = 'bc_sbgr';
                        elemento.href = url;
                        elemento.id_grpo = '#';
                        li.append(elemento);
                        $('#bc_sbgr').show();
                        $('#bc_sbgr').html('Subgrupo');
                        $('#bc_item').hide();
                        break;
                    case "3":
                        $('#bc_grpo').html('Grupo');
                        $('#bc_sbgr').show();
                        $('#bc_sbgr').html('Subgrupo');
                        $('#bc_item').show();
                        $('#bc_item').html('Materiales');
                        break;
                }
            }
        })
    }

    $('#datetimepicker2').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        icons: {
        }
    });

    $("#btnItems").click(function () {
        location.href="${createLink(controller: 'mantenimientoItems', action: 'registro')}"
    });

    $("#btnMantenimientoPrecios").click(function () {
        location.href="${createLink(controller: 'item', action: 'mantenimientoPrecios')}"
    });

    $("#btnPreciosVolumen").click(function () {
        location.href="${createLink(controller: 'item', action: 'precioVolumen')}"
    });

    $("#btnRegistrar").click(function () {
        location.href="${createLink(controller: 'item', action: 'registrarPrecios')}"
    });

    function createEditPrecio(id, item, lugar) {
        var fechaDefecto = $("#datetimepicker2").val();
        var title = id ? "Editar" : "Nuevo";
        $.ajax({
            type    : "POST",
            url     : "${createLink( action:'formPrecio_ajax')}",
            data    : {
                item        : item,
                lugar       : lugar,
                %{--nombreLugar : "${lugarNombre}",--}%
                %{--fecha       : "${fecha}",--}%
                %{--all         : "${params.all}",--}%
                %{--ignore      : "${params.ignore}",--}%
                id: id,
                fd: fechaDefecto
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id    : "dlgCreateEditP",
                    title : title + " precio",
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
                                return submitFormPrecio();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    } //createEdit

    function submitFormPrecio() {
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
                    if(parts[0] === 'OK'){
                        log(parts[1], "success");
                        cargarTablaItemsPrecios();
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
    %{--    var esLugar = nodeType.contains("lugar");--}%
    %{--    var tipoGrupo = $node.data("tipo");--}%
    %{--    var nodeHasChildren = $node.hasClass("hasChildren");--}%
    %{--    var abueloId = null;--}%

    %{--    if(esDepartamento){--}%
    %{--        abueloId = $node.parent().parent().parent().parent().children()[1].id.split("_")[1];--}%
    %{--    }else{--}%
    %{--        abueloId = parentId--}%
    %{--    }--}%

    %{--    var items = {};--}%

    %{--    var nuevaLista = {--}%
    %{--        label  : "Nueva Lista",--}%
    %{--        icon   : "fa fa-underline text-success",--}%
    %{--        action : function () {--}%
    %{--            createEditLista(null, nodeId);--}%
    %{--        }--}%
    %{--    };--}%

    %{--    var editarLista = {--}%
    %{--        label  : "Editar lista",--}%
    %{--        icon   : "fa fa-underline text-success",--}%
    %{--        action : function () {--}%
    %{--            createEditLista(nodeId, parentId);--}%
    %{--        }--}%
    %{--    };--}%

    %{--    if (esItem) {--}%
    %{--        if(!todosLugares){--}%
    %{--            items.nuevaLista = nuevaLista--}%
    %{--        }--}%
    %{--    } else if(esLugar){--}%
    %{--        if(!todosLugares){--}%
    %{--            items.editarLista = editarLista--}%
    %{--        }--}%
    %{--    }--}%
    %{--    return items;--}%
    %{--}--}%

    %{--function createEditLista(id, parentId) {--}%
    %{--    var title = id ? "Editar" : "Crear";--}%
    %{--    var data = id ? {id : id} : {};--}%
    %{--    data.grupo = parentId;--}%
    %{--    $.ajax({--}%
    %{--        type    : "POST",--}%
    %{--        --}%%{--url     : "${createLink( action:'formSg_ajax')}",--}%
    %{--        url     : "${createLink( action:'formLg_ajax')}",--}%
    %{--        data    : data,--}%
    %{--        success : function (msg) {--}%
    %{--            var b = bootbox.dialog({--}%
    %{--                id    : "dlgCreateEditLT",--}%
    %{--                title : title + " lista",--}%
    %{--                class : "modal-lg",--}%
    %{--                message : msg,--}%
    %{--                buttons : {--}%
    %{--                    cancelar : {--}%
    %{--                        label     : "Cancelar",--}%
    %{--                        className : "btn-primary",--}%
    %{--                        callback  : function () {--}%
    %{--                        }--}%
    %{--                    },--}%
    %{--                    guardar  : {--}%
    %{--                        id        : "btnSave",--}%
    %{--                        label     : "<i class='fa fa-save'></i> Guardar",--}%
    %{--                        className : "btn-success",--}%
    %{--                        callback  : function () {--}%
    %{--                            return submitFormLista(parentId);--}%
    %{--                        } //callback--}%
    %{--                    } //guardar--}%
    %{--                } //buttons--}%
    %{--            }); //dialog--}%
    %{--            setTimeout(function () {--}%
    %{--                b.find(".form-control").first().focus()--}%
    %{--            }, 500);--}%
    %{--        } //success--}%
    %{--    }); //ajax--}%
    %{--} //createEdit--}%

    %{--function submitFormLista(tipo) {--}%
    %{--    var $form = $("#frmSave");--}%
    %{--    var $btn = $("#dlgCreateEditLT").find("#btnSave");--}%
    %{--    if ($form.valid()) {--}%
    %{--        var data = $form.serialize();--}%
    %{--        $btn.replaceWith(spinner);--}%
    %{--        var dialog = cargarLoader("Guardando...");--}%
    %{--        $.ajax({--}%
    %{--            type    : "POST",--}%
    %{--            url     : $form.attr("action"),--}%
    %{--            data    : data,--}%
    %{--            success : function (msg) {--}%
    %{--                dialog.modal('hide');--}%
    %{--                var parts = msg.split("_");--}%
    %{--                if(parts[0] === 'OK'){--}%
    %{--                    log("Guardado correctamente", "success");--}%
    %{--                    setTimeout(function () {--}%
    %{--                        if(tipoSeleccionado === 1){--}%
    %{--                            recargarMateriales();--}%
    %{--                        }else if(tipoSeleccionado === 2){--}%
    %{--                            recargaMano();--}%
    %{--                        }else{--}%
    %{--                            recargaEquipo();--}%
    %{--                        }--}%
    %{--                    }, 1000);--}%
    %{--                }else{--}%
    %{--                    bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');--}%
    %{--                    return false;--}%
    %{--                }--}%
    %{--            }--}%
    %{--        });--}%
    %{--    } else {--}%
    %{--        return false;--}%
    %{--    }--}%
    %{--}--}%


    %{--$("#btnReporte").click(function () {--}%
    %{--    var tipo = tipoSeleccionado == 1 ? 'materiales' : (tipoSeleccionado == 2 ? 'mano_obra' : 'equipos')--}%
    %{--    $.ajax({--}%
    %{--        type    : "POST",--}%
    %{--        url     : "${createLink(action:'reportePreciosUI')}",--}%
    %{--        data    : {--}%
    %{--            grupo : tipoSeleccionado--}%
    %{--        },--}%
    %{--        success : function (msg) {--}%
    %{--            var btnOk = $('<a href="#" data-dismiss="modal" class="btn ">Cancelar</a>');--}%
    %{--            var btnSave = $('<a href="#"  class="btn btn-info"><i class="fa fa-print"></i> PDF </a>');--}%
    %{--            var btnExcel = $('<a href="#" class="btn btnExcel btn-success" ><i class="fa fa-file-excel"></i> Excel</a>');--}%

    %{--            btnSave.click(function () {--}%
    %{--                var data = "";--}%
    %{--                data += "orden=" + $(".orden.active").attr("id");--}%
    %{--                data += "&tipo=" + $(".tipo.active").attr("id");--}%
    %{--                data += "&lugar=" + $("#lugarRep").val();--}%
    %{--                data += "&fecha=" + $("#fechaRep").val();--}%
    %{--                data += "&grupo=" + tipoSeleccionado;--}%
    %{--                data += "&estado=" + $("#revisar").val();--}%

    %{--                $(".col.active").each(function () {--}%
    %{--                    data += "&col=" + $(this).attr("id");--}%
    %{--                });--}%

    %{--                location.href = "${g.createLink(controller: 'reportes2', action: '_reportePrecios')}?" + data;--}%
    %{--            });--}%

    %{--            btnExcel.click(function () {--}%
    %{--                var fecha = $("#fechaRep").val();--}%
    %{--                var lugar = $("#lugarRep").val();--}%
    %{--                var grupo = tipoSeleccionado;--}%
    %{--                var estadoA = $("#revisar option:selected").val();--}%

    %{--                location.href = "${g.createLink(controller: 'reportesExcel2', action: 'reportePreciosExcel')}?fecha=" +--}%
    %{--                    fecha + "&lugar=" + lugar + "&grupo=" + grupo + "&estado=" + estadoA;--}%
    %{--            });--}%

    %{--            btnOk.click(function () {--}%
    %{--                $("#modal-tree").dialog("close");--}%
    %{--            });--}%

    %{--            $("#modalHeader").removeClass("btn-edit btn-show btn-delete");--}%
    %{--            $("#modalTitle").html("Formato de impresión");--}%
    %{--            $("#modalBody").html(msg);--}%
    %{--            $("#modalFooter").html("").append(btnOk).append(btnSave).append(btnExcel);--}%
    %{--            $("#modal-tree").dialog("open");--}%
    %{--        }--}%
    %{--    });--}%
    %{--});--}%

    %{--$("#btnReporteMinas").click(function (){--}%
    %{--    $.ajax({--}%
    %{--        type    : "POST",--}%
    %{--        url: "${createLink(action:'impresionMinas_ajax')}",--}%
    %{--        data    : {},--}%
    %{--        success : function (msg) {--}%
    %{--            var b = bootbox.dialog({--}%
    %{--                id      : "dlgImprimirMinas",--}%
    %{--                title   : "Listas de Precios de materiales pétreos - minas (Excel)",--}%
    %{--                message : msg,--}%
    %{--                buttons : {--}%
    %{--                    cancelar : {--}%
    %{--                        label     : "Cancelar",--}%
    %{--                        className : "btn-primary",--}%
    %{--                        callback  : function () {--}%
    %{--                        }--}%
    %{--                    },--}%
    %{--                    guardar  : {--}%
    %{--                        id        : "btnSave",--}%
    %{--                        label     : "<i class='fa fa-file-excel'></i> Excel",--}%
    %{--                        className : "btn-success",--}%
    %{--                        callback  : function () {--}%
    %{--                            location.href="${createLink(controller: 'reportesExcel2', action: 'reporteExcelMinas')}?lista=" + $("#lista option:selected").val();--}%
    %{--                        } //callback--}%
    %{--                    } //guardar--}%
    %{--                } //buttons--}%
    %{--            }); //dialog--}%
    %{--        } //success--}%
    %{--    }); //ajax--}%
    %{--});--}%

</script>

</body>
</html>