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

<div class="row">
    <div class="col-md-12">

        <div class="col-md-12 alert alert-info">
            Código de especificación: <strong>${cdes}</strong> Códigos de items: <strong>${codigos}</strong>
        </div>

        <div role="main" style="margin-top: 5px;">
            <table class="table table-bordered table-striped table-condensed table-hover">
                <thead>
                <tr>
                    <th style="width: 64%">Rubros</th>
                    <th style="width: 27%">Especificación</th>
                    <th style="width: 8%">Acciones</th>
                    <th style="width: 1%;"></th>
                </tr>
                </thead>
            </table>
        </div>

        <div class="" style="width: 99.7%;height: 300px; overflow-y: auto;float: right; margin-top: -20px">
            <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
                <tbody>
                <g:if test="${datos}">
                    <g:each in="${datos}" status="i" var="dato">
                        <tr>
                            <td style="width: 64%">${raw(nombres)}</td>
                            <td style="width: 27%">${dato}</td>
                            <td style="width: 8%; text-align: center">
                                <a class="btn btn-info btn-xs btnDescargarPdfHistorico" href="#" rel="tooltip" title="Descargar especificaciones" data-id="${item?.id}" data-tipo="${"dt"}">
                                    <i class="fa fa-download"></i>
                                </a>
                            </td>
                            <td style="width: 1%"></td>
                        </tr>
                    </g:each>
                </g:if>
                <g:else>
                    <td class="alert alert-warning" style="text-align: center"><i class="fa fa-exclamation-triangle fa-2x text-info"></i>
                        <strong style="font-size: 16px"> No existen registros </strong>
                    </td>
                </g:else>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>

    $(".btnDescargarPdfHistorico").click(function () {
        var id = $(this).data("id");
        var tipo = $(this).data("tipo");
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'rubro', action:'downloadFileHistoricoEspecificaciones')}",
            data    : {
                id: id,
                tipo: tipo
            },
            success : function (msg) {
                var parts = msg.split("_");
                if(parts[0] === 'no' ){
                    bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                    return false;
                }else{
                    location.href="${createLink(controller: 'rubro', action: 'downloadFileHistoricoEspecificaciones')}?id=" + id + "&tipo=" + tipo
                }
            } //success
        }); //ajax
    });

</script>
