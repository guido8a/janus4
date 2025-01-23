<style type="text/css">
table {
    table-layout: fixed;
    overflow-x: scroll;
}
th, td {
    overflow: hidden;
    text-overflow: ellipsis;
    word-wrap: break-word;
}
</style>

<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-striped table-hover" style="width: 100%">
        <g:if test="${res}">
            <g:each in="${res}" var="cont" status="j">
                <tr class="obra_row" id="${cont.id}">
                    <td style="width: 9%;">${cont.codigo}</td>
                    <td style="width: 6%;"><g:formatDate date="${cont.fechasu}" format="dd-MM-yyyy"/></td>
                    <td style="width: 8%;">${cont.concurso}</td>
                    <td style="width: 8%;">${cont.obracodigo}</td>
                    <td style="width: 18%; font-size: 10px">${cont.obranombre} </td>
                    <td style="width: 7%; font-size: 10px" >${cont.tipoobra}</td>
                    <td style="width: 7%; font-size: 10px">${cont.tipocontrato}</td>
                    <td style="width: 7%;">${cont.monto}</td>
                    <td style="width: 4%;">${cont.porcentaje}</td>
                    <td style="width: 6%;">${cont.anticipo}</td>
                    <td style="width: 8%; font-size: 10px" >${cont.nombrecontra}</td>
                    <td style="width: 6%;"><g:formatDate date="${cont.fechainicio}" format="dd-MM-yyyy"/></td>
                    <td style="width: 6%;"><g:formatDate date="${cont.fechafin}" format="dd-MM-yyyy"/></td>
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