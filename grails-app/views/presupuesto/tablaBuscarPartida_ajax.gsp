
<table class="table table-bordered table-striped table-hover table-condensed" id="tabla">
    <thead>
    <tr>
        <th style="width:15%;">Proyecto</th>
        <th style="width:32%;">Partida</th>
        <th style="width:15%;">Programa</th>
        <th style="width: 15%;">Subprograma</th>
        <th style="width: 7%;">Seleccionar</th>
        <th style="width: 1%;"></th>
    </tr>
    </thead>
</table>

<div class="" style="width: 99.7%;height: 430px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover" style="width: 100%">
        <g:if test="${presupuestos.size() > 0}">
            <g:each in="${presupuestos}" var="presupuesto">
                <tr>
                    <td style="width:15%;">${presupuesto?.prspproy}</td>
                    <td style="width:32%;">${presupuesto?.prspdscr} <strong style="color: #0d7bdc">(${presupuesto?.prspnmro})</strong> </td>
                    <td style="width:15%;">${presupuesto?.prspprgm}</td>
                    <td style="width:15%;">${presupuesto?.prspsbpr}</td>
                    <td style="width: 7%; text-align: center">
                        <a href="#" class="btn btn-success btn-xs seleccionaPartida" data-id="${presupuesto?.prsp__id}" data-nombre="${presupuesto?.prspdscr}" data-codigo="${presupuesto?.prspnmro}" ><i class="fa fa-check"></i></a>
                    </td>
                    <td style="width: 1%"></td>
                </tr>
            </g:each>
        </g:if>
        <g:else>
            <tr>
                <td class="alert alert-info" colspan="5" style="text-align: center"> <h3><i class="fa fa-exclamation-triangle"></i> No exiten registros</h3> </td>
            </tr>
        </g:else>
    </table>
</div>

<script type="text/javascript">
    $(".seleccionaPartida").click(function () {
        var idPartida = $(this).data("id");
        cargarPartida(idPartida);
        cargarAsignaciones(idPartida);
        cerrarBuscadorPartida();
    });
</script>