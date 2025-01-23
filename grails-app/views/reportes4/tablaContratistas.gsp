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
                    <td style="width: 7%;">${cont.ruc}</td>
                    <td style="width: 19%;">${cont.nombre}</td>
                    <td style="width: 8%;">${cont.especialidad}</td>
                    <td style="width: 10%;">${cont.nombrecon + " " + cont.apellidocon} </td>
                    <td style="width: 15%;">${cont.direccion}</td>
                    <td style="width: 7%;">${cont.telefono}</td>
                    <td style="width: 10%;">${cont.garante}</td>
                    <td style="width: 7%;"><g:formatDate date="${cont.fecha}" format="dd-MM-yyyy"/></td>
                    <td style="width: 7%;"><g:formatDate date="${cont.fechacontrato}" format="dd-MM-yyyy"/></td>
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
