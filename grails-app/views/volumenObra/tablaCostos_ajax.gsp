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

<div class="" style="width: 99.7%;height: 350px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
        <tbody>
        <g:if test="${costos}">
            <g:set var="total" value="${0}"/>
            <g:each in="${costos}" var="costo" status="i">
                <tr>
                    <g:set var="total" value="${total += (costo?.valor ?: 0)}"/>
                    <td style="width: 15%; font-size: 10px">${costo?.orden}</td>
                    <td style="width: 50%; font-size: 10px">${costo?.descripcion}</td>
                    <td style="width: 20%; text-align: right"><g:formatNumber number="${costo?.valor}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/></td>
                    <td style="width: 20%">
                        <a href="#" class="btn btn-success btn-xs btnEditarCosto" data-id="${costo?.id}" ><i class="fa fa-edit"></i></a>
                        <a href="#" class="btn btn-danger btn-xs btnBorrarCosto" data-id="${costo?.id}" ><i class="fa fa-trash"></i></a>
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

    <div class="col-md-12 breadcrumb" style="height: 35px;overflow-y: auto;float: right;text-align: right; font-size: 14px" id="total">
        <div class="col-md-9">
            <b>TOTAL:</b>
        </div>
        <div class="col-md-2" >
            <div id="divTotal" style="height: 30px;font-weight: bold;font-size: 14px;margin-right: 20px; text-align: center">${total}</div>
        </div>
    </div>
</div>

<script type="text/javascript">

    $(".btnBorrarCosto").click(function () {
        var id = $(this).data("id");
        borrarCostoP(id);
    });

    $(".btnEditarCosto").click(function () {
        var id = $(this).data("id");
        formCostoP(id)
    });

</script>