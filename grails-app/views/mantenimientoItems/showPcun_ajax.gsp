<div role="main" style="margin-top: 5px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 26%">Lugar</th>
            <th style="width: 8%">Fecha</th>
            <th style="width: 8%">Precio</th>
            <th style="width: 8%">Acciones</th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 400px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
        <tbody>
        <g:if test="${data}">
            <g:each in="${data}" status="i" var="item">
                <tr data-id="${item?.rbpc__id}">
                    <td style="width: 26%">${item.lgardscr}</td>
                    <td style="width: 8%">${item.rbpcfcha}</td>
                    <td style="width: 8%">${item.rbpcpcun ?: ''}</td>
                    <td style="width: 8%; text-align: center">
                        <a href="#" class="btn btn-xs btn-info btnVerMaterial" data-id="${item?.item__id}" title="Ver">
                            <i class="fas fa-search"></i>
                        </a>
                        <a href="#" class="btn btn-xs btn-success btnHistorico" data-item="${item?.item__id}" data-lugar="${item?.lgar__id}" title="Histórico de Precios">
                            <i class="fas fa-edit"></i>
                        </a>
                    </td>
                </tr>
                <g:set var="itemIDAnterior" value="${item.item__id}"/>
            </g:each>
        </g:if>
        <g:else>
            <tr style="text-align: center">
                <td class="alert alert-warning"><i class="fa fa-exclamation-triangle fa-2x text-info"></i> <strong style="font-size: 16px"> No existen registros </strong></td>
            </tr>
        </g:else>

        </tbody>
    </table>
</div>
