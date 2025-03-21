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


<div class="" style="width: 99.7%; max-height: 240px; overflow-y: auto;float: right; margin-top: -20px;
border-style: solid; border-width: 1px; border-color: #506c90; margin-bottom: 20px">
    <table class="table-bordered table-condensed table-striped table-hover" style="width: 100%">
        <g:each in="${obras}" var="fila" status="j">
            <tr style="width: 100%">
                <td style="width: 10%">${fila.obracdgo}</td>
                <td style="width: 34%; font-size: 10px">${fila.obranmbr}</td>
                <td style="width: 19%; font-size: 10px">${fila.cntnnmbr} - ${fila.parrnmbr} - ${fila.cmndnmbr}</td>
                <td style="width: 8%">${fila.cntrcdgo}</td>
                <td style="width: 10%">${fila.prvenmbr}</td>
                <td style="width: 7%; text-align: right"><g:formatNumber number="${fila.cntrmnto}" maxFractionDigits="2" minFractionDigits="2" format="##,##0.##" locale="ec"/></td>
                <td style="width: 7%"><g:formatDate date="${fila.cntrfcsb}" format="dd-MM-yyyy"/></td>
                <td style="width: 5%; text-align: center">
                    <a href="#" class="btn btn-info btn-xs btnVerComparacion" data-id="${fila?.obra__id}">
                        <i class="fa fa-search"></i>
                    </a>
                </td>
            </tr>
        </g:each>
    </table>
</div>

<script type="text/javascript">

    $(".btnVerComparacion").click(function () {
        var id = $(this).data("id");
        verComparacion(id);
    });

    function verComparacion (id) {
        $.ajax({
            type : "POST",
            url : "${g.createLink(controller: 'reportes4', action: 'comparacion_ajax')}",
            data     : {
                id: id
            },
            success  : function (msg) {
                $("#divDetalle2").html(msg)
            }
        });
    } //createEdit

</script>