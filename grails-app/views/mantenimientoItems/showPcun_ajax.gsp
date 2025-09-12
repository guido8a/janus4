<div class="row">
    <div class="col-md-12">
        <a href="#" class="btn btn-primary btnNuevoPrimerPrecio" >
            <i class="fa fa-file"></i>
            Nuevo Precio
        </a>

        <a href="#" class="btn btn-warning btnNuevoPrecioTodos">
            <i class="fa fa-globe"></i>
            Nuevo Precio todos los lugares
        </a>

        <div role="main" style="margin-top: 5px;">
            <table class="table table-bordered table-striped table-condensed table-hover">
                <thead>
                <tr>
                    <th style="width: 26%">Lugar</th>
                    <th style="width: 8%">Fecha</th>
                    <th style="width: 8%">Precio</th>
                    <th style="width: 8%">Acciones</th>
                </tr>
                </thead>
            </table>
        </div>

        <div class="" style="width: 99.7%;height: 400px; overflow-y: auto;float: right; margin-top: -20px">
            <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
                <tbody>
                <g:if test="${data}">
                    <g:each in="${data}" status="i" var="item">
                        <tr data-id="${item?.rbpc__id}">
                            <td style="width: 26%">${item.lgardscr}</td>
                            <td style="width: 8%">${item.rbpcfcha}</td>
                            <td style="width: 8%">${item.rbpcpcun ?: ''}</td>
                            <td style="width: 8%; text-align: center">
                                <a href="#" class="btn btn-xs btn-info btnVerMaterialPcun" data-id="${item?.item__id}" title="Ver">
                                    <i class="fas fa-search"></i>
                                </a>
                                <a href="#" class="btn btn-xs btn-success btnHistoricoPcun" data-item="${item?.item__id}" data-lugar="${item?.lgar__id}" title="Histórico de Precios">
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
    </div>
</div>

<script type="text/javascript">

    $(".btnNuevoPrecioTodos").click(function () {
        createEditPrecioConLugares2('all')
    });

    $(".btnNuevoPrimerPrecio").click(function () {
        createEditPrecioConLugares2(null)
    });

    $(".btnVerMaterialPcun").click(function () {
        var id = $(this).data("id");
        verMaterial(id);
    });

    $(".btnHistoricoPcun").click(function () {
        var item = $(this).data("item");
        var lugar = $(this).data("lugar");
        cargarTablaHistoricoPrecios(item, lugar, 2)
    });

    function createEditPrecioConLugares2(todos) {
        $.ajax({
            type    : "POST",
            url     : "${createLink( action:'formPreciosLugares2_ajax')}",
            data    : {
                item        : "${itemInstance.id}",
                all: todos
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id    : "dlgCreateEditP",
                    title : "Nuevo precio",
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
                                return submitFormPrecio2();
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

    function submitFormPrecio2() {
        var item = '${itemInstance?.id}';
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
                        cerrarPreciosDesdeItems();
                        verPrecios('${itemInstance?.id}');
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

</script>
