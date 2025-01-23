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
        <g:if test="${obras}">
            <g:each in="${obras}" var="obra" status="j">
                <tr class="obra_row" id="${obra.obra__id}">
                    <td style="width: 12%">${obra.obracdgo}</td>
                    <td style="width: 29%">${obra.obranmbr}</td>
                    <td style="width: 13%; font-size: 10px">${obra.tpobdscr}</td>
                    <td style="width: 8%"><g:formatDate date="${obra.obrafcha}" format="dd-MM-yyyy"/></td>
                    <td style="width: 21%; font-size: 10px">${obra.cntnnmbr} - ${obra.parrnmbr} - ${obra.cmndnmbr}</td>
                    <td style="width: 9%">${obra.obravlor}</td>
                    <td style="width: 14%">${obra.dptodscr}</td>
                    <td style="width: 11%; font-size: 10px">${obra.obrarefe}</td>
                    <g:if test="${obras?.size() < 9}">
                        <td style="width: 5% !important; font-size: 10px">${obra.estado}</td>
                        <td style="width: 1%"></td>
                    </g:if>
                    <g:else>
                        <td style="width: 6% !important;font-size: 10px">${obra.estado}</td>
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