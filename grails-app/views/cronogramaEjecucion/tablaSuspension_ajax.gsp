<div role="main" style="margin-top: 5px;">
    <table class="table table-bordered table-striped table-condensed">
        <thead>
        <tr style="width: 100%">
            <th style="width: 35%">Fecha anterior a la suspensión</th>
            <th style="width: 35%">Período de suspensión</th>
            <th style="width: 30%">Fecha de reinicio de obra</th>
        </tr>
        </thead>
        <tbody>
        <g:if test="${fechaInicio}">
            <tr style="width: 100%; font-weight: bold; font-size: 16px">
                <td class="text-success" style="width: 35%; text-align: center">${fechaAnterior ?: ''}</td>
                <td class="text-warning" style="width: 35%">${(fechaInicio?   fechaInicio?.toString()  + " a " : '')  + (fechaFin?.toString() ?: '')}</td>
                <td class="text-success" style="width: 35%; text-align: center">${fechaReinicio ?: ''}</td>
            </tr>
        </g:if>
        <g:else>
                <tr>
                    <td colspan="3">
                        <div class="alert alert-info" style="text-align: center">
                        <i class="fa fa-exclamation-triangle text-info fa-2x"></i> <strong style="font-size: 14px"> Seleccione una fecha de inicio </strong>
                        </div>
                    </td>
                </tr>
        </g:else>
        </tbody>
    </table>
</div>