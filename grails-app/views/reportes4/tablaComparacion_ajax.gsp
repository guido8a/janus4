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


<div class="" style="width: 99.7%;height: 300px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-striped table-hover" style="width: 100%">
        <g:each in="${data}" var="o" status="j">
            <tr style="width: 100%">
                <td style="width: 10%">${o.itemcdgo}</td>
                <td style="width: 34%; font-size: 10px">${o.itemnmbr}</td>
                <td style="width: 6%; font-size: 10px; text-align: center">${o.unddcdgo}</td>
                <td style="width: 8%; text-align: right">${o.vlobcntd}</td>
                <td style="width: 8%; text-align: right">${o.pcun}</td>
                <td style="width: 8%; text-align: right">${o.pcof}</td>
                <td style="width: 8%; text-align: right"><g:formatNumber number="${o.diffpcun}" maxFractionDigits="2" minFractionDigits="2" format="##,##0.##" locale="ec"/></td>
                <td style="width: 10%; text-align: right"><g:formatNumber number="${o.diffsbtt}" maxFractionDigits="2" minFractionDigits="2" format="##,##0.##" locale="ec"/></td>
                <td style="width: 8%; text-align: right"><g:formatNumber number="${Math.round(o.diffpcun/o.pcun*10000)/100}%" maxFractionDigits="2" minFractionDigits="2" format="##,##0.##" locale="ec"/></td>
            </tr>
        </g:each>
    </table>
</div>