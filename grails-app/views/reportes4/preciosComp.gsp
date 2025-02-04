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
        <g:each in="${obras}" var="fila" status="j">
            <tr style="width: 100%">
                <td style="width: 10%">${fila.obracdgo}</td>
                <td style="width: 34%; font-size: 10px">${fila.obranmbr}</td>
                <td style="width: 19%; font-size: 10px">${fila.cntnnmbr} - ${fila.parrnmbr} - ${fila.cmndnmbr}</td>
                <td style="width: 8%">${fila.cntrcdgo}</td>
                <td style="width: 10%">${fila.prvenmbr}</td>
                <td style="width: 7%"><g:formatNumber number="${fila.cntrmnto}" maxFractionDigits="2" minFractionDigits="2" format="##,##0.##" locale="ec"/></td>
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
            type    : "POST",
            url     : "${createLink(controller: 'reportes4', action:'comparacion_ajax')}",
            data    : {
                id: id
            },
            success : function (msg) {
                var dfg = bootbox.dialog({
                    id    : "dlgVer",
                    title : "Comparación de obras",
                    class : "modal-lg",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        }
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    } //createEdit

</script>