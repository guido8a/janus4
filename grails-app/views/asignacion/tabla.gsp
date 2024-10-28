<table class="table table-bordered table-striped table-condensed table-hover">
    <thead>
    <tr>
        <th style="width:5%;">Año</th>
        <th style="width:15%;">Proyecto</th>
        <th style="width:32%;">Partida</th>
        <th style="width:15%;">Programa</th>
        <th style="width: 15%;">Subprograma</th>
        <th style="width: 10%;">Valor</th>
        <th style="width: 7%;">Acciones</th>
        <th style="width: 1%;"></th>
    </tr>
    </thead>
</table>

<div class="" style="width: 100%;height: 550px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover table-striped" style="width: 100%">
        <tbody>
        <g:if test="${asignaciones.size() > 0}">
            <g:each in="${asignaciones}" var="asignacion">
                <tr>
                    <td style="text-align: center; width:5%">${anio?.anio}</td>
                    <td style="width:15%;">${asignacion?.prspproy}</td>
                    <td style="width:32%;">${asignacion?.prspdscr} <strong style="color: #0d7bdc">(${asignacion?.prspnmro})</strong> </td>
                    <td style="width:15%;">${asignacion?.prspprgm}</td>
                    <td style="width:15%;">${asignacion?.prspsbpr}</td>
                    <td style="text-align: right; font-weight: bold; font-size: 14px;  width:10%">
                        <g:formatNumber number="${asignacion?.asgnvlor}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/>
                    </td>
                    <td style="width: 7%; text-align: center">
                        <a href="#" class="btn btn-success btn-xs btnEditarAsignacion" data-id="${asignacion?.asgn__id}" ><i class="fa fa-edit"></i></a>
                        <a href="#" class="btn btn-danger btn-xs btnBorrarAsignacion" data-id="${asignacion?.asgn__id}" ><i class="fa fa-trash"></i></a>
                    </td>
                    <td style="width: 1%"></td>
                </tr>
            </g:each>
        </g:if>
        <g:else>
            <tr>
                <td class="alert alert-info" colspan="7" style="text-align: center"> <h3><i class="fa fa-exclamation-triangle"></i> No exiten registros</h3> </td>
            </tr>
        </g:else>
        </tbody>
    </table>
</div>


<script type="text/javascript">

    $(".btnEditarAsignacion").click(function () {
        var id = $(this).data("id");
        createEditAsignacion(id)
    });

</script>