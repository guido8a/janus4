<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-striped table-hover" style="width: 100%">
        <g:if test="${data}">
            <g:each in="${data}" var="fila" status="j">
                <tr style="width: 100%">
                    <td style="width: 10%">${fila.obracdgo}</td>
                    <td style="width: 24%; font-size: 10px">${fila.obranmbr}</td>
                    <td style="width: 18%; font-size: 10px">${fila.direccion}</td>
                    <td style="width: 7%"><g:formatDate date="${fila.obrafcha}" format="dd-MM-yyyy"/></td>
                    <td style="width: 14%">${fila.obrasito}</td>
                    <td style="width: 13%; font-size: 10px">${fila.parrnmbr} - ${fila.cmndnmbr}</td>
                    <td style="width: 7%"><g:formatDate date="${fila.obrafcin}" format="dd-MM-yyyy"/></td>
                    <td style="width: 7%"><g:formatDate date="${fila.obrafcfn}" format="dd-MM-yyyy"/></td>
                </tr>
            </g:each>
        </g:if>
        <g:else>
            <tr style="text-align: center">
                <td class="alert alert-warning"><i class="fa fa-exclamation-triangle fa-2x text-info"></i> <strong style="font-size: 16px"> No existen registros </strong></td>
            </tr>
        </g:else>
    </table>
</div>