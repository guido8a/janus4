<div role="main" style="margin-top: 5px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr style="width: 100%">
            <th style="width: 10%">Código</th>
            <th style="width: 45%">Materiales</th>
            <th style="width: 5%">Unidad</th>
            <th style="width: 10%">P. Unitario</th>
            <th style="width: 14%">Fecha Act.</th>
            <th style="width: 15%">Lista</th>
            <th style="width: 1%"></th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
        <tbody>
        <g:if test="${materiales}">
            <g:each in="${materiales}" status="i" var="m">
                <tr style="width: 100%">
                    <td style="width: 10%">${m.itemcdgo}</td>
                    <td style="width: 45%">${m.itemnmbr}</td>
                    <td style="width: 5%">${m.unddcdgo}</td>
                    <td style="width: 10%">${m.rbpcpcun}</td>
                    <td style="width: 14%">${m.rbpcfcha}</td>
                    <td style="width: 15%">${m.lgardscr}</td>
                    <td style="width: 1%"></td>
                </tr>
            </g:each>
        </g:if>
        <g:else>
            <tr style="text-align: center">
                <td class="alert alert-warning"><i class="fa fa-exclamation-triangle fa-2x text-info"></i> <strong style="font-size: 16px"> No existen registros </strong></td>
            </tr>
        </g:else>
        </tbody>
    </table>
</div>