<div role="main" style="margin-top: 5px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr style="width: 100%">
            <th colspan="8">Rubros Emparejados</th>
        </tr>
        <tr>
            <th style="width: 32%">Descripción - Oferente</th>
            <th style="width: 8%">Equivale a</th>
            <th style="width: 8%">Código</th>
            <th style="width: 30%">Descripción - Sistema</th>
            <th style="width: 5%">Acciones</th>
            <th style="width: 1%"></th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 350px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover" width="100%">
        <tbody>
        <g:if test="${data}">
            <g:each in="${data}" var="d" status="i">
                <tr>
                    <td style="width: 32%">${d?.ofrbnmbr}</td>
                    <td style="width: 8%; text-align: center"><i class="fa fa-exchange-alt fa-3x text-success"></i> </td>
                    <td style="width: 8%">${d?.itemcdgo}</td>
                    <td style="width: 30%">${d?.itemnmbr}</td>
                    <td style="width: 5%; text-align: center">
                        <a href="#" class="btn btn-danger btn-xs btnDesempatar" data-id="${d?.ofrb__id}" title="Quitar empate"><i class="fa fa-trash"></i></a>
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

    $(".btnDesempatar").click(function () {
        var id = $(this).data("id");
        var obra = '${obra}';
        var g = cargarLoader("Guardando...");
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'rubroOf', action:'quitarEmpateRubrosRubros_ajax')}",
            data: {
                id: id,
                obra: obra
            },
            success: function (msg) {
                g.modal("hide");
                var parts = msg.split("_");
                if(parts[0] === 'ok'){
                    log(parts[1], "success");
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