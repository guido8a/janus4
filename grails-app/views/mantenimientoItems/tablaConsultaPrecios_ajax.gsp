<div role="main" style="margin-top: 5px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 7%">Código</th>
            <th style="width: 15%">Materiales</th>
            <th style="width: 7%">Unidad</th>
            <th style="width: 15%">Peso/vol</th>
            <th style="width: 10%">Costo</th>
            <th style="width: 28%">Fecha Act.</th>
            <th style="width: 5%">#Rubros</th>
            <th style="width: 14%">#Obras</th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
        <tbody>
        <g:if test="${materiales}">
            <g:each in="${materiales}" status="i" var="material">
                <tr>
                    <td style="width: 7%">${material[0]}</td>
                    <td style="width: 15%">${material[1]}</td>
                    <td style="width: 7%">${material[2]}</td>
                    <td style="width: 15%">${material[3]}</td>
                    <td style="width: 10%">${material[4]}</td>
                    <td style="width: 10%">${material[5]}</td>
                    <td style="width: 10%">${material[6]}</td>
                    <td style="width: 10%">${material[7]}</td>
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