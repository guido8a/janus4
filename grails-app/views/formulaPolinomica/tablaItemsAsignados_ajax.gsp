<div class="alert-success" style="font-size: 14px; font-weight: bold; text-align: center" >Asignados</div>

<div role="main" style="margin-top: 5px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 15%">Código</th>
            <th style="width: 55%">Item</th>
            <th style="width: 15%">Valor</th>
            <th style="width: 15%">Acciones</th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 350px; overflow-y: auto;float: right; margin-top: -20px;">
    <table class="table-bordered table-striped table-condensed table-hover" >
        <tbody>
        <g:if test="${asignados}">
            <g:set var="total" value="${0}"/>
            <g:each in="${asignados}" var="asignado" >
                <tr>
                    <g:set var="total" value="${total += asignado?.valor}"/>
                    <td style="width: 15%">${asignado?.item?.codigo}</td>
                    <td style="width: 55%">${asignado?.item?.nombre}</td>
                    <td style="width: 15%">${asignado?.valor}</td>
                    <td style="width: 15%">
                        <a href="#" class="btn btn-danger btn-xs btnBorrarAsignado" data-id="${asignado?.id}"><i class="fa fa-trash"></i></a>
                    </td>
                </tr>
            </g:each>
            <td colspan="2" style="text-align: right; font-weight: bold; font-size: 14px">Total</td>
            <td class="text-info" style="text-align: right; font-weight: bold; font-size: 14px">${total}</td>
            <td></td>
        </g:if>
        <g:else>
            <div class="alert alert-info" style="text-align: center">
                <i class="fa fa-exclamation-triangle text-info fa-2x"></i> <strong style="font-size: 14px"> No se encontraron registros </strong>
            </div>
        </g:else>
        </tbody>
    </table>
</div>

<script type="text/javascript">


    $(".btnBorrarAsignado").click(function () {
        var id = $(this).data("id");
        borrarAsignado(id);
    });

    function borrarAsignado(id){
        var formula = '${formula?.id}';
        bootbox.confirm({
            title: "Eliminar Subgrupo",
            message: '<i class="fa fa-trash text-danger fa-3x"></i>' + '<strong style="font-size: 14px">' + "Está seguro de borrar este item?. " + '</strong>' ,
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
                        url: '${createLink(controller: 'formulaPolinomica' , action: 'borrarAsignado_ajax')}',
                        data:{
                            id: id
                        },
                        success: function (msg) {
                            dialog.modal('hide');
                            var parts = msg.split("_");
                            if(parts[0] === 'ok'){
                                log(parts[1],"success");
                                cargarItemsNuevos(formula);
                                cargarItemsAsignados(formula);
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