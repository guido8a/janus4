<div class="alert alert-success" style="margin-top: 10px; text-align: center">
       <i class="fa fa-list"></i> <strong style="font-size: 16px"> Rubros en la composición </strong>
</div>

<div role="main" style="margin-top: 10px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 17%">Código</th>
            <th style="width: 75%">Descripción</th>
            <th style="width: 9%">Acciones</th>
            <th style="width: 1%"></th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
        <tbody>
        <g:if test="${items}">
            <g:each in="${items}" var="item" status="i">
                <tr>
                    <td style="width: 15%">${item.item.codigo}</td>
                    <td style="width: 70%">${item.item.nombre}</td>
                    <td style="width: 12%">
                        <a href="#" class="btn btn-danger btn-xs btnBorrarSeleccion" data-id="${item?.id}" ><i class="fa fa-trash"></i></a>
                    </td>
                </tr>
            </g:each>
        </g:if>
        <g:else>
            <div class="alert alert-info" style="text-align: center">
                <i class="fa fa-exclamation-triangle text-info fa-2x"></i> <strong style="font-size: 14px"> Ningún item agregado a la composición </strong>
            </div>
        </g:else>
        </tbody>
    </table>
</div>

<script type="text/javascript">

    $(".btnBorrarSeleccion").click(function () {
        var id = $(this).data("id");
        bootbox.confirm({
            title: "Eliminar ",
            message: "<i class='fa fa-trash  text-danger fa-3x'></i> <strong style='font-size: 14px'> Está seguro de querer eliminar el rubro?. </strong> ",
            buttons: {
                cancel: {
                    label: '<i class="fa fa-times"></i> Cancelar',
                    className: 'btn-primary'
                },
                confirm: {
                    label: '<i class="fa fa-trash"></i> Aceptar',
                    className: 'btn-success'
                }
            },
            callback: function (result) {
                if(result){
                    var g = cargarLoader("Cargando...");
                    $.ajax({
                        type: "POST",
                        url: "${createLink(controller: 'rubro', action: 'eliminarRubro_ajax')}",
                        data: {
                            id: id
                        },
                        success: function (msg) {
                            g.modal("hide");
                            var parts = msg.split("_");
                            if(parts[0] === 'ok'){
                                log(parts[1], "success");
                                cargarTablaSeleccionados();
                            }else{
                                log(parts[1], "error")
                            }
                        }
                    })
                }
            }
        });

    });

</script>