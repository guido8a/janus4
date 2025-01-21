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

        <g:each in="${obras}" var="obra" status="j">
            <tr class="obra_row" id="${obra.obra__id}">
                <td style="width: 10% !important;">${obra.obracdgo}</td>
                <td style="width: 25% !important;">${obra.obranmbr}</td>
                <td style="width: 13% !important;">${obra.tpobdscr}</td>
                <td style="width: 8% !important;"><g:formatDate date="${obra.obrafcha}" format="dd-MM-yyyy"/></td>
                <td style="width: 21% !important; font-size: 10px">${obra.cntnnmbr} - ${obra.parrnmbr} - ${obra.cmndnmbr}</td>
                <td style="text-align: right; width: 9% !important;">${obra.obravlor}</td>
                <td style="width: 16% !important;">${obra.dptodscr}</td>
                <td style="width: 11% !important;">${obra.obrarefe}</td>
                <g:if test="${obras?.size() < 9}">
                    <td style="width: 9% !important;">${obra.estado}</td>
                    <td style="width: 1%"></td>
                </g:if>
                <g:else>
                    <td style="width: 10% !important;">${obra.estado}</td>
                </g:else>
            </tr>
        </g:each>
    </table>
</div>