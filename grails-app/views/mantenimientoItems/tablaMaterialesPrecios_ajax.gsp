<div role="main" style="margin-top: 5px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 10%">Código</th>
            <th style="width: 40%">Descripción</th>
            <th style="width: 26%">Lugar</th>
            <th style="width: 8%">Fecha</th>
            <th style="width: 8%">Precio</th>
            <th style="width: 8%">Acciones</th>
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
                    <td style="width: 40%">${item.itemnmbr}</td>
                    <td style="width: 26%">${item.lgardscr}</td>
                    <td style="width: 8%">${item.rbpcfcha}</td>
                    <td style="width: 8%">${item.rbpcpcun ?: ''}</td>
                    <td style="width: 8%; text-align: center">
                        <a href="#" class="btn btn-xs btn-info btnVerMaterial" data-id="${item?.item__id}" title="Ver">
                            <i class="fas fa-search"></i>
                        </a>
                        <a href="#" class="btn btn-xs btn-success btnHistorico" data-item="${item?.item__id}" data-lugar="${item?.lgar__id}" title="Histórico de Precios">
                            <i class="fas fa-edit"></i>
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

    var ths;

    $(".btnHistorico").click(function () {
        var item = $(this).data("item");
        var lugar = $(this).data("lugar");
        cargarTablaHistoricoPrecios(item, lugar)
    });

    function cargarTablaHistoricoPrecios(item, lugar){
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'mantenimientoItems', action:'showLg_ajax')}",
            data    : {
                id: lugar,
                item: item,
                fecha: "all"
            },
            success : function (msg) {
                ths = bootbox.dialog({
                    id    : "dlgVerPrecios",
                    title : "Histórico de Precios",
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

    function cerrarTablaHistoricos(){
        ths.modal("hide");
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
                    title : "Datos del material",
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




</script>