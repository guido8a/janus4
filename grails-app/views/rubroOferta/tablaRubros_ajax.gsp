<div role="main" style="margin-top: 5px;">
    <table class="table table-bordered table-striped table-condensed table-hover" style="margin-top: 20px">
        <thead>
        <tr style="width: 100%">
            <th colspan="8">Rubros Cargados de la Oferta</th>
        </tr>
        <tr>
            <th style="width: 5%">Orden</th>
            <th style="width: 64%">Descripción</th>
            <th style="width: 10%">Precio Oferente</th>
            <th style="width: 10%">Precio APU</th>
            <th style="width: 10%">Diferencia</th>
            <th style="width: 1%"></th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%; height: 450px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover" width="100%">
        <tbody>
        <g:if test="${data}">
            <g:each in="${data}" var="d" status="i">
                <tr class="${Math.abs(d?.diff) > 0.009 ? 'noCuadra' : ''}">
                    <td style="width: 5%">${d?.ofrbordn}</td>
                    <td style="width: 64%">${d?.ofrbnmbr}</td>
                    <td style="width: 10%; text-align: right">${d?.ofrbpcun}</td>
                    <td style="width: 10%; text-align: right">${d?.sum}</td>
                    <td style="width: 10%; text-align: right">${d?.diff}</td>
                    <td style="width: 1%"></td>
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