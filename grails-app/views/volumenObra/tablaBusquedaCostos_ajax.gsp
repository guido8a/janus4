<div role="main" style="margin-top: 5px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 15%">Número</th>
            <th style="width: 50%">Descripción</th>
            <th style="width: 15%">Unitario</th>
            <th style="width: 10%">Porcentaje</th>
            <th style="width: 9%"></th>
            <th style="width: 1%"></th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover">
        <tbody>
        <g:if test="${datos}">
            <g:each in="${datos}" var="dt" status="i">
                <tr style="width: 100%">
                    <td style="width: 15%">${dt.cstonmro}</td>
                    <td style="width: 50%">${dt.cstodscr}</td>
                    <td style="width: 15%; text-align: right">${dt.prcspcun}</td>
                    <td style="width: 10%; text-align: center">${dt.prcspcnt}%</td>
                    <td style="width: 9%; text-align: center">
                        <a href="#" class="btn btn-success btn-xs btnSeleccionar" data-id="${dt?.csto__id}" data-por="${dt.prcspcnt}" data-uni="${dt.prcspcun}" ><i class="fa fa-check"></i></a>
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

    $(".btnSeleccionar").click(function () {
        var costo = $(this).data("id");
        var unitario = $(this).data("uni");
        var porcentaje = $(this).data("por");
        formCosto(null, costo, 1, unitario, porcentaje)
    });

</script>