<div role="main" style="margin-top: 10px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 15%">Orden</th>
            <th style="width: 50%">Descripción</th>
            <th style="width: 20%">Valor</th>
            <th style="width: 20%">Acciones</th>
            <th style="width: 1%"></th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 475px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
        <tbody>
        <g:if test="${costos}">
            <g:each in="${costos}" var="costo" status="i">
                <tr>
                    <td style="width: 15%; font-size: 10px">${costo?.orden}</td>
                    <td style="width: 50%; font-size: 10px">${costo?.descripcion}</td>
                    <td style="width: 20%; text-align: right"><g:formatNumber number="${costo?.valor}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/></td>
                    <td style="width: 20%">
                        <a href="#" class="btn btn-success btn-xs btnEditarSeleccion" data-id="${costo?.id}" ><i class="fa fa-edit"></i></a>
                        <a href="#" class="btn btn-danger btn-xs btnBorrarSeleccion" data-id="${costo?.id}" ><i class="fa fa-trash"></i></a>
                    </td>
                    <td style="width: 1%"></td>
                </tr>
            </g:each>
        </g:if>
        <g:else>
            <div class="alert alert-info" style="text-align: center">
                <i class="fa fa-exclamation-triangle text-info fa-2x"></i> <strong style="font-size: 14px"> No existen registros </strong>
            </div>
        </g:else>
        </tbody>
    </table>
</div>

<script type="text/javascript">

    $(".btnBorrarSeleccion").click(function () {
        var id = $(this).data("id");
        borrarCosto(id);
    });

    $(".btnEditarSeleccion").click(function () {
        var id = $(this).data("id");
        formCosto(id)
    });

</script>