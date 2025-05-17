<div role="main" style="margin-top: 5px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 35%">Rubro</th>
            <th style="width: 35%">Item</th>
            <th style="width: 10%">Cantidad</th>
            <th style="width: 10%">Rendimiento</th>
            <th style="width: 9%">Acciones</th>
            <th style="width: 1%"></th>
        </tr>
        </thead>
    </table>
</div>

<div style="width: 100%;height: 300px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
        <tbody>
        <g:if test="${datos}">
            <g:each in="${datos}" var="dt" status="i">
                <tr style="width: 100%">
                    <td style="width: 35%">${dt.rubro}</td>
                    <td style="width: 35%">${dt.item}</td>
                    <td style="width: 10%">${dt.rbofcntd}</td>
                    <td style="width: 10%">${dt.rbofrndt}</td>
                    <td style="width: 9%; text-align: center">
                        <span href="#" class="btn-danger btn-xs btnBorre" data-id="${dt?.rbof__id}"
                           data-rubro="${dt?.rubro}" data-item="${dt?.item}"><i class="fa fa-trash"></i></span>
                    </td>
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
