<div role="main" style="margin-top: 5px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 10%">Código</th>
            <th style="width: 38%">Descripción</th>
            <th style="width: 26%">Lugar</th>
            <th style="width: 8%">Fecha</th>
            <th style="width: 8%">Precio</th>
            <th style="width: 10%">Acciones</th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
        <tbody>
        <g:if test="${items}">
            <g:each in="${items}" status="i" var="item">
                <tr data-id="${item?.rbpc__id}">
                    <td style="width: 10%">${item.itemcdgo}</td>
                    <td style="width: 38%">${item.itemnmbr}</td>
                    <td style="width: 26%">${item.lgardscr}</td>
                    <td style="width: 8%">${item.rbpcfcha}</td>
                    <td style="width: 8%">${item.rbpcpcun ?: ''}</td>
                    <td style="width: 10%; text-align: center">
                        <a href="#" class="btn btn-xs btn-info btnVerMaterial" data-id="${item?.item__id}" title="Ver">
                            <i class="fas fa-search"></i>
                        </a>
                        <a href="#" class="btn btn-xs btn-success btnHistorico" data-item="${item?.item__id}" data-lugar="${item?.lgar__id}" title="Histórico de Precios">
                            <i class="fas fa-edit"></i>
                        </a>
                        <g:if test="${perfil}">
                            <a href="#" class="btn btn-xs btn-warning btnEspecificacionesMaterial" data-id="${item?.item__id}" title="Especificaciones e Ilustración" ${janus.Item.get(item?.item__id)?.codigoEspecificacion ?: 'disabled'}>
                                <i class="fas fa-book"></i>
                            </a>
                        </g:if>
                        <a href="#" class="btn btn-xs btn-danger btnEliminarVarios" data-item="${item?.item__id}" data-nombre="${item.itemnmbr}" title="Borrar varios precios">
                            <i class="fas fa-trash"></i>
                        </a>
                    </td>
                </tr>
                <g:set var="itemIDAnterior" value="${item.item__id}"/>
            </g:each>
        </g:if>
        <g:else>
            <tr style="text-align: center">
                <td class="alert alert-warning"><i class="fa fa-exclamation-triangle fa-2x text-info"></i> <strong style="font-size: 16px"> No existen registros </strong></td>
            </tr>
        </g:else>

        </tbody>
    </table>
</div>

<script type="text/javascript">

    var es;

    $(".btnEspecificacionesMaterial").click(function () {
        var id = $(this).data("id");
        cargarEspecificaciones(id, 2);
    });

    function cargarEspecificaciones(id, tipo){
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'mantenimientoItems', action:'especificaciones_ajax')}",
            data    : {
                id: id,
                tipo: tipo
            },
            success : function (msg) {
                es = bootbox.dialog({
                    id    : "dlgEspecificacionesMaterial",
                    title : "Especificaciones del item",
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

    $(".btnHistorico").click(function () {
        var item = $(this).data("item");
        var lugar = $(this).data("lugar");
        cargarTablaHistoricoPrecios(item, lugar)
    });

    $(".btnEliminarVarios").click(function () {
        var item = $(this).data("item");
        var nombre = $(this).data("nombre");
        borrarTodosPrecios(item, nombre)
    });

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

        cargarTablaItemsPrecios();
    });

    $(".btnNuevoMaterial").click(function () {
        createEditItem(null, ${id})
    });

    $(".btnEditarPrecio").click(function () {
        var id = $(this).data("id");
        createEditPrecio(id, null, null)
    });

    $(".btnEliminarMaterial").click(function () {
        var id = $(this).data("id");
        deleteMaterial(id);
    });

    function deleteMaterial(id){
        bootbox.confirm({
            title: "Eliminar Grupo",
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
                                cargarTablaItemsPrecios(parts[2]);
                            }else{
                                log(parts[1], "error")
                            }
                        }
                    });
                }
            }
        });
    }

    function borrarTodosPrecios(id, nombre){
        bootbox.confirm({
            title: "Eliminar varios precios",
            message: '<i class="fa fa-trash text-danger fa-3x"></i>' + '<p style="font-size: 14px; margin-left: 40px">' +
            'Está seguro de borrar los precios del item: <strong>' + nombre +  '</strong> registrados a la <br>fecha: <strong>' +
            $("#datetimepicker2").val() + ' en todas las listas de precios<strong></p>' ,
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
                        url: '${createLink(action: 'borrarVariosPrecios_ajax')}',
                        data:{
                            id: id,
                            fecha: $("#datetimepicker2").val()
                        },
                        success: function (msg) {
                            dialog.modal('hide');
                            var parts = msg.split("_");
                            if(parts[0] === 'ok'){
                                log(parts[1],"success");
                                cargarTablaItemsPrecios();
                            }else{
                                log(parts[1], "error")
                            }
                        }
                    });
                }
            }
        });
    }

</script>