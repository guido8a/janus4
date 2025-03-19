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
            <th style="width: 10%">Código</th>
            <th style="width: 70%">Descripción</th>
            <th style="width: 9%">Unidad</th>
            <th style="width: 10%">Seleccionar</th>
            <th style="width: 1%"></th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 400px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover">
        <tbody>
        <g:if test="${data}">
            <g:each in="${data}" var="dt" status="i">
                <tr>
                    <td style="width: 10%">${dt.itemcdgo}</td>
                    <td style="width: 70%">${dt.itemnmbr}</td>
                    <td style="width: 9%">
                        ${dt.unddcdgo}
                    </td>
                    <td style="width: 10%">
                        <a href="#" class="btn btn-success btn-xs btnSeleccionarRubroRubro" data-id="${dt?.item__id}" data-nombre="${dt?.itemnmbr}"><i class="fa fa-check"></i></a>
                    </td>
                    <td style="width: 1%"></td>
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

    $(".btnSeleccionarRubroRubro").click(function () {
        var id = $(this).data("id");
        var g = cargarLoader("Guardando...");
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'rubroOf', action:'emparejarRubros_ajax')}",
            data: {
                id: id,
                rubro: '${rubro}',
                obra: '${obra}'
            },
            success: function (msg) {
                g.modal("hide");
                var parts = msg.split("_");
                if(parts[0] === 'ok'){
                    log(parts[1], "success");
                    cerrarDialogoBusquedaRubro();
                    cargarTablaBusquedaRubros();
                    cargarTablaEmpatadosRubros();
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
    })

</script>