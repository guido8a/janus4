<div role="main" style="margin-top: 5px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 10%">Código</th>
            <th style="width: 24%">Descripción</th>
            <th style="width: 7%">Lugar 1</th>
            <th style="width: 7%">Lugar 2</th>
            <th style="width: 7%">Lugar 3</th>
            <th style="width: 7%">Lugar 4</th>
            <th style="width: 7%">Lugar 5</th>
            <th style="width: 7%">Lugar 6</th>
            <th style="width: 7%">Lugar 7</th>
            <th style="width: 7%">Lugar 8</th>
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
                <g:set var="itemIDActual" value="${item.item__id}"/>
                <tr data-id="${item?.item__id}">
                    <td style="width: 10%">${item.itemcdgo}</td>
                    <td style="width: 24%">${item.itemnmbr}</td>
                    <td style="width: 7%">${item.lgardscr == 'CAYAMBE' ? item.rbpcpcun : ''}</td>
                    <td style="width: 7%">${100}</td>
                    <td style="width: 7%">${100}</td>
                    <td style="width: 7%">${100}</td>
                    <td style="width: 7%">${100}</td>
                    <td style="width: 7%">${100}</td>
                    <td style="width: 7%">${100}</td>
                    <td style="width: 7%">${100}</td>
                    <td style="width: 10%; text-align: center">
                        <a href="#" class="btn btn-xs btn-info btnVerMaterial" data-id="${item?.item__id}" title="Ver">
                            <i class="fas fa-search"></i>
                        </a>
                        <a href="#" class="btn btn-xs btn-success btnEditarMaterial" data-id="${item?.item__id}" title="Editar precios">
                            <i class="fas fa-edit"></i>
                        </a>
                        <a href="#" class="btn btn-xs btn-info btnHistorico" data-id="${item?.item__id}" title="Histórico de Precios">
                            <i class="fas fa-dollar-sign"></i>
                        </a>
                        %{--                        <g:if test="${perfil}">--}%
                        %{--                            <a href="#" class="btn btn-xs btn-warning btnEspecificacionesMaterial" data-id="${material?.id}" title="Especificaciones e Ilustración" ${material?.codigoEspecificacion ?: 'disabled'}>--}%
                        %{--                                <i class="fas fa-book"></i>--}%
                        %{--                            </a>--}%
                        %{--                        </g:if>--}%

                        %{--                        <a href="#" class="btn btn-xs btn-danger btnEliminarMaterial" data-id="${material?.id}" title="Eliminar">--}%
                        %{--                            <i class="fas fa-trash"></i>--}%
                        %{--                        </a>--}%
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

    $(".btnFabricante").click(function () {
        location.href="${createLink(controller: 'fabricante', action: 'list')}?tipo=" + 1
    });

    $(".btnEspecificacionesMaterial").click(function () {
        var id = $(this).data("id");
        var child = window.open('${createLink(controller:"mantenimientoItems",action:"especificaciones_ajax")}?id=' + id,
            'janus4', 'width=850,height=800,toolbar=0,resizable=0,menubar=0,scrollbars=1,status=0');

        if (child.opener == null)
            child.opener = self;
        window.toolbar.visible = false;
        window.menubar.visible = false;
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

    $(".btnEditarMaterial").click(function () {
        var id = $(this).data("id");
        var sub =$(this).data("sub");
        createEditItem(id, sub)
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