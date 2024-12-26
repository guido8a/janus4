<div role="main" style="margin-top: 5px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 15%">Código</th>
            <th style="width: 70%">Descripción</th>
            <th style="width: 15%">Tipo</th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 350px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover">
        <tbody>
        <g:if test="${indices}">
            <g:each in="${indices}" var="indice" status="i">
                <tr>
                    <td style="width: 15%">${indice?.indccdgo}</td>
                    <td style="width: 70%">${indice?.indcdscr}</td>
                    <td style="width: 15%">${indice?.tpin__id}</td>
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