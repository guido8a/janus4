
<table class="table table-bordered table-striped table-hover table-condensed" id="tabla">
    <thead>
    <tr>
        <th style="width: 9%">Año</th>
        <th style="width:320px;">Partida</th>
        <th style="width:180px;">Programa</th>
        <th style="width:180px;">Subprograma</th>
        <th style="width:220px;">Proyecto</th>
        <th style="width:80px;">Valor</th>
        <th style="width: 9%">Acciones</th>
        <th style="width: 1%"></th>
    </tr>
    </thead>
</table>

<div class="" style="width: 99.7%;height: 430px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover">
        <g:each in="${presupuestos}" var="presupuesto" status="i">
            <tr style="width: 100%">
                <td style="width: 10%">${janus.pac.Anio.get(presupuesto.anio__id)?.anio}</td>
                <td style="width:320px;">${presupuesto?.prspdscr} <strong style="color: #0d7bdc">(${presupuesto.prspnmro})</strong> </td>
                <td style="width: 65%">${presupuesto.prspprgm}</td>
                <td style="width: 65%">${presupuesto.prspsbpr}</td>
                <td style="width: 65%">${presupuesto.prspproy}</td>
                <td style="width: 65%">${presupuesto.prspprgm}</td>
                <td style="width: 10%">
                    <div style="text-align: center" class="selecciona" data-desc="${presupuesto.prspdscr}" data-codigo="${presupuesto.prspnmro}"
                         data-id="${presupuesto.prsp__id}" data-fuente="${ janus.FuenteFinanciamiento.get(presupuesto.fnfn__id)?.descripcion}" data-proy="${presupuesto.prspproy}"
                         data-prog="${presupuesto.prspprgm}" data-sub="${presupuesto.prspsbpr}">

                    </div>
                </td>
            </tr>
        </g:each>
    </table>
</div>

<script type="text/javascript">

</script>