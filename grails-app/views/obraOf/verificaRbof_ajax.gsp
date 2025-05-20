
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

<div class="row">
    <div class="col-md-12">
        <div role="main">
            <div style="margin-top: -20px; font-size: large; text-align: center">Importante: Elimine sólo los componentes repetidos</div>
            <table class="table table-bordered table-striped table-condensed table-hover">
                <thead>
                <tr>
                    <th style="width: 30%">Rubro</th>
                    <th style="width: 35%">Item</th>
                    <th style="width: 10%">Cantidad</th>
                    <th style="width: 14%">Rendimiento</th>
                    <th style="width: 10%">Acciones</th>
                    <th style="width: 1%"></th>
                </tr>
                </thead>
            </table>
        </div>

        <div style="width: 100%;height: 300px; overflow-y: auto;float: right; margin-top: -20px">
            <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
                <tbody>
                <g:if test="${datos}">
                    <g:each in="${datos}" var="dt" status="i">
                        <tr style="width: 100%">
                            <td style="width: 30%">${dt.rubro}</td>
                            <td style="width: 35%">${dt.item}</td>
                            <td style="width: 10%">${dt.rbofcntd}</td>
                            <td style="width: 14%">${dt.rbofrndt}</td>
                            <td style="width: 10%; text-align: center">
                                <a href="#" class="btn btn-xs btn-danger btnEliminarRepetido" data-id="${dt?.rbof__id}" title="Eliminar">
                                    <i class="fas fa-trash"></i>
                                </a>

                            </td>
                            <td style="width: 1%"></td>
                        </tr>
                    </g:each>
                </g:if>
                <g:else>
                    <div class="alert alert-info" style="text-align: center">
                        <i class="fa fa-exclamation-triangle text-info fa-2x"></i> <strong style="font-size: 14px">
                        No se encontraron componentes repetidos en los Rubros </strong>
                    </div>
                </g:else>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script type="text/javascript">

    $(".btnEliminarRepetido").click(function () {
        var id = $(this).data("id");
        deleteRepetido(id)
    });

    function deleteRepetido(id){
        bootbox.confirm({
            title: "Borrar rubro repetido",
            message: '<i class="fa fa-trash text-danger fa-3x"></i>' + '<strong style="font-size: 14px">' + "Está seguro de borrar este rubro repetido?" + '</strong>' ,
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
                        url: '${createLink(action: 'borrarRepetido_ajax')}',
                        data:{
                            id: id
                        },
                        success: function (msg) {
                            dialog.modal('hide');
                            var parts = msg.split("_");
                            if(parts[0] === 'ok'){
                                log(parts[1],"success");
                                cerrarDialogoRubroRepetido();
                                cargarRubrosRepetidos()
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