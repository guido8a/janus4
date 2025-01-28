<style type="text/css">
table {
    table-layout: fixed;
    overflow-x: scroll;
}
th, td {
    overflow: hidden;
    text-overflow: ellipsis;
    word-wrap: break-word;
}
</style>

<table class="table table-bordered table-striped table-hover table-condensed" id="tabla">
    <thead>
    <tr>
        <th style="width: 15%">Cédula</th>
        <th style="width: 40%">Nombre</th>
        <th style="width: 15%">Email</th>
        <th style="width: 10%">Teléfono</th>
        <th style="width: 10%">Porcentaje</th>
        <th style="width: 9%">Acciones</th>
        <th style="width: 1%"></th>
    </tr>
    </thead>
</table>

<div class="" style="width: 99.7%;height: 280px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover" style="width: 100%">
        <g:if test="${accionistas}">
            <g:each in="${accionistas}" var="accionista" status="i">
                <tr>
                    <td style="width: 10%">${accionista?.accionista?.cedula}</td>
                    <td style="width: 40%">${accionista?.accionista?.nombre + " " + accionista?.accionista?.apellido}</td>
                    <td style="width: 15%">${accionista?.accionista?.mail}</td>
                    <td style="width: 10%">${accionista?.accionista?.telefono}</td>
                    <td style="width: 10%">${accionista?.porcentaje}</td>
                    <td style="width: 10%">
                        <a href="#" class="btn btn-xs btn-success btnEditarAccionista" data-id="${accionista?.id}" title="Editar">
                            <i class="fas fa-edit"></i>
                        </a>
                        <a href="#" class="btn btn-xs btn-danger btnEliminarAccionista" data-id="${accionista?.id}" title="Eliminar">
                            <i class="fas fa-trash"></i>
                        </a>
                    </td>
                </tr>
            </g:each>
        </g:if>
        <g:else>
            <div class="alert alert-info" style="text-align: center">
                <i class="fa fa-exclamation-triangle text-info fa-2x"></i> <strong style="font-size: 14px"> No se encontraron registros </strong>
            </div>
        </g:else>

    </table>
</div>

<script type="text/javascript">


    $(".btnEliminarAccionista").click(function () {
        var id = $(this).data("id");
        eliminarAccionista(id);
    });

    $(".btnEditarAccionista").click(function () {
        var id = $(this).data("id");
        createEditItem(id);
    });


    function eliminarAccionista(id){
        bootbox.confirm({
            title: "Eliminar Accionista",
            message: '<i class="fa fa-trash text-danger fa-3x"></i>' + '<strong style="font-size: 14px">' + "Está seguro de borrar este accionista? Esta acción no puede deshacerse. " + '</strong>' ,
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
                        url: '${createLink(controller: 'accionista', action: 'delete_ajax')}',
                        data:{
                            id: id
                        },
                        success: function (msg) {
                            dialog.modal('hide');
                            var parts = msg.split("_");
                            if(parts[0] === 'ok'){
                                log(parts[1],"success");
                                cargarTablaAccionistas();
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