<%@ page import="utilitarios.reportesService" %>

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
        <g:if test="${data}">
            <g:each in="${data}" var="obra" status="j">
                <tr class="obra_row" >
                    <td style="width: 10%;">${obra.cncrcdgo}</td>
                    <td style="width: 7%;"><g:formatDate date="${obra.cncrfcad}" format="dd-MM-yyyy"/></td>
                    <td style="width: 24%; font-size: 10px">${obra.cncrobjt}</td>
                    <td style="width: 24%; font-size: 10px">${obra.obranmbr}</td>
                    <td style="width: 10%;">${obra.obracdgo}</td>
                    <td style="width: 7%;">${obra.cncrprrf}</td>
                    <td style="width: 8%;">${obra.cncrnmct}</td>
                    <g:if test="${data?.size() < 9}">
                        <td style="width: 7% !important; font-size: 10px">${obra.cncretdo == 'R' ? 'Registrada' : 'No registrada'}</td>
                        <td style="width: 1%"></td>
                    </g:if>
                    <g:else>
                        <td style="width: 7% !important;font-size: 10px">${obra.cncretdo == 'R' ? 'Registrada' : 'No registrada'}</td>
                    </g:else>
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

