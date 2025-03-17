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

<div role="main" style="margin-top: 5px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 12%">Código</th>
            <th style="width: 68%">Descripción</th>
            <th style="width: 10%">Unidad</th>
            <th style="width: 10%">Seleccionar</th>
            <th style="width: 1%"></th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width:100%;height: 400px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover">
        <tbody>
        <g:if test="${data}">
            <g:each in="${data}" var="dt" status="i">
                <tr style="width: 100%">
                    <td style="width: 12%">${dt.itemcdgo}</td>
                    <td style="width: 68%">${dt.itemnmbr}</td>
                    <td style="width: 10%">
                        ${dt.unddcdgo}
                    </td>
                    <td style="width: 10%; text-align: center">
                        <a href="#" class="btn btn-success btn-xs btnSeleccionarRubro" data-id="${dt?.item__id}" data-nombre="${dt?.itemnmbr}"><i class="fa fa-check"></i></a>
                    </td>
                    <td style="width: 1%;"></td>
                </tr>
            </g:each>
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

    $(".btnSeleccionarRubro").click(function () {
        var id = $(this).data("id");
        // var nombre = $(this).data("nombre");
        %{--bootbox.confirm({--}%
        %{--    title: "Empatar rubro ",--}%
        %{--    message: "<i class='fa fa-exclamation-triangle text-info fa-3x'></i> <strong style='font-size: 14px; text-align: center'> Está seguro de empatar ${rubro?.nombre}" + "<br>" + "con el rubro: " + nombre + " ?. </strong> ",--}%
            // buttons: {
            //     cancel: {
            //         label: '<i class="fa fa-times"></i> Cancelar',
            //         className: 'btn-primary'
            //     },
            //     confirm: {
            //         label: '<i class="fa fa-check"></i> Aceptar',
            //         className: 'btn-success'
            //     }
            // },
            // callback: function (result) {
            //     if(result){
                    var g = cargarLoader("Guardando...");
                    $.ajax({
                        type: "POST",
                        url: "${createLink(controller: 'rubroOf', action:'empatarRubros_ajax')}",
                        data: {
                            id: id,
                            rubro: '${rubro?.id}',
                            obra: '${obra}'
                        },
                        success: function (msg) {
                            g.modal("hide");
                            var parts = msg.split("_");
                            if(parts[0] === 'ok'){
                                log(parts[1], "success");
                                cerrarDialogoBusquedaRubro();
                                cargarTablaBusqueda();
                                cargarTablaEmpatados();
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
            //     }
            // }
        // });
    })

</script>