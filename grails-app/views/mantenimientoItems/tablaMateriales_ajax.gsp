<%@ page import="janus.Item" %>
<div class="col-md-12" style="text-align: center; font-size: 14px; font-weight: bold; margin-top: -30px">
    <div class="col-md-4"></div>

    <div class="col-md-3" style="float: right">
%{--        <a href="#" class="btn btn-sm btn-success btnRegresarMaterial" title="Regresar">--}%
%{--            <i class="fas fa-arrow-left"></i>--}%
%{--        </a>--}%
        <a href="#" class="btn btn-sm btn-success btnNuevoMaterial" title="Crear nuevo material">
            <i class="fas fa-file"></i> Nuevo Item
        </a>
        <a href="#" class="btn btn-sm btn-info btnFabricante" title="Fabricante">
            <i class="fas fa-bookmark"></i> Fabricante
        </a>
    </div>
</div>

<div role="main" style="margin-top: 5px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 7%">Código Grupo</th>
            <th style="width: 15%">Grupo</th>
            <th style="width: 7%">Código Subgrupo</th>
            <th style="width: 12%">Subgrupo</th>
            <th style="width: 8%">Código</th>
            <th style="width: 25%">Descripción</th>
            <th style="width: 5%">Unidad</th>
            <th style="width: 5%">PDF</th>
            <th style="width: 16%">Acciones</th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
        <tbody>
        <g:if test="${materiales}">
            <g:each in="${materiales}" status="i" var="m">
                <tr data-id="${m.item__id}" class="${m.itemetdo == 'B'? 'dadoDeBaja': ''}">
                    <td style="width: 7%">${m.sbgrcdgo}</td>
                    <td style="width: 15%">${m.sbgrdscr}</td>
                    <td style="width: 7%">${m.dprtcdgo}</td>
                    <td style="width: 12%">${m.dprtdscr}</td>
                    <td style="width: 8%">${m.itemcdgo}</td>
                    <td style="width: 25%">${m.itemnmbr}</td>
                    <td style="width: 5%">${Item.get(m.item__id)?.unidad?.codigo}</td>
                    <td style="width: 5%; text-align: center">
                        <g:if test="${janus.apus.ArchivoEspecificacion.findByItem(janus.Item.get(m.item__id))?.ruta}">
                            <i class="fa fa-check text-success"></i>
                        </g:if>
                        <g:else>
                            <i class="fa fa-times text-danger"></i>
                        </g:else>
                    </td>
                    <td style="width: 16%; text-align: center">
                        <a href="#" class="btn btn-xs btn-info btnRegresarItem" data-id="${janus.Item.get(m.item__id)?.departamento?.subgrupo?.id}" title="Regresar a subgrupo">
                            <i class="fas fa-arrow-left"></i>
                        </a>
                        <a href="#" class="btn btn-xs btn-info btnVerMaterial" data-id="${m.item__id}" title="Datos del material">
                            <i class="fas fa-search"></i>
                        </a>
                        <a href="#" class="btn btn-xs btn-success btnVerInfo" data-id="${m.item__id}" title="Ver información del item">
                            <i class="fas fa-info"></i>
                        </a>
                        <g:if test="${session.perfil.nombre == 'CRFC'}">
                            <a href="#" class="btn btn-xs btn-warning btnEspecificacionesMaterial" data-id="${m.item__id}"
                               title="Especificaciones e Ilustración" ${m.itemcdes ?: 'disabled'}>
                                <i class="fas fa-book"></i>
                            </a>
                        </g:if>
                        <g:if test="${session.perfil.nombre == 'CRFC'}">
                            <a href="#" class="btn btn-xs btn-success btnEditarMaterial" data-id="${m.item__id}"
                               data-sub="${m.dprt__id}" title="Editar">
                                <i class="fas fa-edit"></i>
                            </a>
                            <a href="#" class="btn btn-xs btn-danger btnEliminarMaterial" data-id="${m.item__id}" title="Eliminar">
                                <i class="fas fa-trash"></i>
                            </a>
                        </g:if>
                    </td>
                </tr>
            </g:each>
        </g:if>
        <g:else>
            <tr style="text-align: center">
                <td class="alert alert-warning"><i class="fa fa-exclamation-triangle fa-2x text-info"></i>
                    <strong style="font-size: 16px"> No existen registros </strong></td>
            </tr>
        </g:else>

        </tbody>
    </table>
</div>

<script type="text/javascript">

    var es;

    $(".btnVerInfo").click(function () {
        var id = $(this).data("id");
        verInfoItem(id);
    });

    $(".btnFabricante").click(function () {
        location.href="${createLink(controller: 'fabricante', action: 'list')}?tipo=" + 1
    });

    $(".btnEspecificacionesMaterial").click(function () {
        var id = $(this).data("id");
        cargarEspecificaciones(id);
    });

    function cargarEspecificaciones(id){
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'mantenimientoItems', action:'especificaciones_ajax')}",
            data    : {
                id: id
            },
            success : function (msg) {
                es = bootbox.dialog({
                    id    : "dlgEspecificacionesMaterial",
                    title : "Especificaciones del material",
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
    }

    $(".btnVerMaterial").click(function () {
        var id = $(this).data("id");
        verMaterial(id);
    });

    $(".btnRegresarMaterial").click(function () {
        $("#buscarPor").val(${grupo?.id});
        $("#tipo").val(2);
        %{--if('${id}'){--}%
        if('${departamento}'){
            $("#criterio").val('${departamento?.descripcion}');
        }else{
            $("#criterio").val('');
        }

        cargarTablaItems();
    });

    $(".btnNuevoMaterial").click(function () {
        createEditItem(null, ${id})
    });

    $(".btnEditarMaterial").click(function () {
        var id = $(this).data("id");
        var sub =$(this).data("sub");
        createEditItem(id, sub)
    });

    $(".btnEliminarMaterial").click(function () {
        var id = $(this).data("id");
        // deleteMaterial(id);
        verificarBorrado(id);
    });

    function verificarBorrado(id){
        var aa = cargarLoader("Cargando...");
        $.ajax({
            type : "POST",
            url : "${g.createLink(controller: 'mantenimientoItems',action:'verificaBorrado_ajax')}",
            data     : {
                id : id
            },
            success  : function (msg) {
                aa.modal("hide");
                var resp = msg.split('_');
                if(resp[0] === "ok"){
                    var ou = cargarLoader("Cargando...");
                    $.ajax({
                        type : "POST",
                        url : "${g.createLink(controller: 'mantenimientoItems',action:'rubrosUsados_ajax')}",
                        data     : {
                            id : id
                        },
                        success  : function (msg) {
                            ou.modal("hide");
                            var b = bootbox.dialog({
                                id      : "dlgLOU",
                                title   : "Lista de obras usadas",
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
                        }
                    });
                }else{
                    deleteMaterial(id);
                }
            }
        });
    }

    function deleteMaterial(id){
        bootbox.confirm({
            title: "Eliminar material",
            message: '<i class="fa fa-trash text-danger fa-3x"></i>' + '<strong style="font-size: 14px">' + "Está seguro de borrar este material? Esta acción no puede deshacerse. " + '</strong>' ,
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
                    var dialog = cargarLoader("Borrando...");
                    $.ajax({
                        type: 'POST',
                        url: '${createLink(action: 'deleteIt_ajax')}',
                        data:{
                            id: id
                        },
                        success: function (msg) {
                            dialog.modal('hide');
                            var parts = msg.split("_");
                            if(parts[0] === 'ok'){
                                log(parts[1],"success");
                                cargarTablaItems(parts[2]);
                            }else{
                                if(parts[0] === 'err'){
                                    bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                                    return false;
                                }else{
                                    log(parts[1], "error")
                                }
                            }
                        }
                    });
                }
            }
        });
    }

    function verMaterial(id) {
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'mantenimientoItems', action:'showIt_ajax')}",
            data    : {
                id: id
            },
            success : function (msg) {
                var e = bootbox.dialog({
                    id    : "dlgVerMaterial",
                    title : "Datos del item",
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
    } //createEdit

    function verInfoItem(id) {
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'mantenimientoItems', action:'infoItems')}",
            data    : {
                id: id
            },
            success : function (msg) {
                var e = bootbox.dialog({
                    id    : "dlgInfoMaterial",
                    title : "Información del item",
                    class : 'modal-lg',
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
    } //createEdit

    function cerrarEspecificaciones(){
        es.modal("hide");
    }

    $(".btnRegresarItem").click(function () {
        $("#buscarPor").val(${grupo?.id});
        $("#tipo").val(2);
        $("#criterio").val('');
        var id = $(this).data("id");

        cargarTablaItems(id);
    })

</script>