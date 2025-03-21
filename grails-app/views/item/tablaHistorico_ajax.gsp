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

<div role="main" style="margin-top: 5px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 10%">Código</th>
            <th style="width: 10%">Cód. Esp.</th>
            <th style="width: 20%">Nombre</th>
            <th style="width: 15%">Especificación</th>
            <th style="width: 15%">Ilustración</th>
            <th style="width: 10%">Word</th>
            <th style="width: 9%">Acciones</th>
            <th style="width: 1%;"></th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
        <tbody>
        <g:if test="${datos}">
            <g:each in="${datos}" status="i" var="rb">
                <tr>
                    <td style="width: 10%">${rb?.itemcdgo}</td>
                    <td style="width: 10%">${rb?.itemcdes}</td>
                    <td style="width: 20%">${rb?.itemnmbr}</td>
                    <td style="width: 15%">${rb?.aresruta}</td>
                    <td style="width: 15%">${rb?.itemfoto}</td>
                    <td style="width: 10%">${rb?.aresespe}</td>
                    <td style="width: 9%; text-align: center">
                        <g:if test="${rb?.aresruta}">
                            <g:link controller="rubro" action="downloadFile" id="${rb?.item__id}" params="[tipo: 'dt']" class="btn btn-info btn-xs" title="Descargar Especificación">
                                <i class="fa fa-download"></i>
                            </g:link>
                        </g:if>
                        <g:if test="${rb?.aresruta}">
                            <g:link controller="rubro" action="downloadFile" id="${rb?.item__id}" params="[tipo: 'il']" class="btn btn-success btn-xs" title="Descargar imagen">
                                <i class="fa fa-download"></i>
                            </g:link>
                        </g:if>
                        <g:if test="${rb?.aresespe}">
                            <g:link controller="rubro" action="downloadFile" id="${rb?.item__id}" params="[tipo: 'wd']" class="btn btn-warning btn-xs" title="Descargar Word">
                                <i class="fa fa-download"></i>
                            </g:link>
                        </g:if>
                    </td>
                    <td style="width: 1%"></td>
                </tr>
            </g:each>
        </g:if>
        <g:else>
            <td class="alert alert-warning"><i class="fa fa-exclamation-triangle fa-2x text-info"></i>
                <strong style="font-size: 16px"> No existen registros </strong>
            </td>
        </g:else>
        </tbody>
    </table>
</div>