<div role="main" style="margin-top: 5px;">
    <table class="table table-bordered table-striped table-condensed">
        <thead>
        <tr style="width: 100%">
            <th style="width: 35%; background-color: #0c4c85;">Anterior</th>
            <th style="width: 35%; background-color: white; color: black">Suspensión</th>
            <th style="width: 30%; background-color: #0c4c85;">Reinicio</th>
        </tr>
        </thead>
        <tbody>
        <g:if test="${fechaInicio}">
            <tr style="width: 100%; font-weight: bold; font-size: 16px">
                <td  style="width: 35%; text-align: center; background-color: #0c4c85; color: white">${fechaAnterior ?: ''}</td>
                <td  style="width: 35%; background-color: white; text-align: center">${(fechaInicio ?  (fechaInicio?.toString() ) : '')} <br>  ${" a "}   <br> ${(fechaFin?.toString() ?: '')}</td>
                <td  style="width: 35%; text-align: center; background-color: #0c4c85; color: white">${fechaReinicio ?: ''}</td>
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