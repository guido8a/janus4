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

<table class="table table-bordered table-striped table-hover table-condensed" id="tabla">
    <thead>
    <tr>
        <th style="width: 16%">Código</th>
        <th style="width: 70%">Descripción</th>
        <th style="width: 13%">Seleccionar</th>
        <th style="width: 1%"></th>
    </tr>
    </thead>
</table>

<div class="" style="width: 99.7%;height: 450px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover" style="width: 100%">
        <g:if test="${data}">
            <g:each in="${data}" var="dt" status="i">
                <tr>
                    <td style="width: 16%">${dt.cpacnmro}</td>
                    <td style="width: 70%">${dt.cpacdscr}</td>
                    <td style="width: 13%">
                        <div style="text-align: center" class="selecciona" id="reg_${i}" data-desc="${dt?.cpacdscr}" data-codigo="${dt?.cpacnmro}" data-id="${dt?.cpac__id}">
                            <button class="btn btn-xs btn-success"><i class="fa fa-check"></i></button>
                        </div>
                    </td>
                    <td style="width: 1%"></td>
                </tr>
            </g:each>
        </g:if>
        <g:else>
            <tr style="width: 100%">
                <td class="alert alert-info" colspan="4" style="text-align: center"> <h3><i class="fa fa-exclamation-triangle"></i> No exiten registros</h3> </td>
            </tr>
        </g:else>
    </table>
</div>

<script type="text/javascript">
    $(".selecciona").click(function () {
        var idCPC = $(this).data("id");
        var codigo = $(this).data("codigo");
        var nombre = $(this).data("desc");

        <g:if test="${params.tipo == '1'}">
        $("#cpp").val(idCPC);
        $("#cppCodigo").val(codigo);
        $("#cppName").val(nombre);
        </g:if>
        <g:else>
        $("#codigoComprasPublicas").val(idCPC);
        $("#item_codigo").val(codigo);
        <g:if test="${tipo == '1'}">
        $("#item_cpac").val(idCPC);
        </g:if>
        <g:else>
        $("#item_desc").val(nombre);
        </g:else>
        </g:else>

        cerrarBuscadorCPC();
    });
</script>