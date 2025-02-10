<div role="main" style="margin-top: 5px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr style="width: 100%">
          <th colspan="7">Rubros Empatados</th>
        </tr>
        <tr>
            <th style="width: 15%">Código</th>
            <th style="width: 30%">Descripción</th>
            <th style="width: 10%"></th>
            <th style="width: 15%">Código</th>
            <th style="width: 30%">Descripción</th>
            <th style="width: 9%">Acciones</th>
            <th style="width: 1%"></th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 400px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover">
        <tbody>
        <g:if test="${data}">
%{--            <g:each in="${data}" var="dt" status="i">--}%
%{--                <tr>--}%
%{--                    <td style="width: 9%">${dt.itemcdgo}</td>--}%
%{--                    <td style="width: 69%">${dt.itemnmbr}</td>--}%
%{--                    <td style="width: 10%">--}%
%{--                        ${dt.unddcdgo}--}%
%{--                    </td>--}%
%{--                    <td style="width: 9%">--}%
%{--                        <a href="#" class="btn btn-success btn-xs btnSeleccionarRubro" data-id="${dt?.item__id}"><i class="fa fa-check"></i></a>--}%
%{--                    </td>--}%
%{--                </tr>--}%
%{--            </g:each>--}%
        </g:if>
        <g:else>
            <div class="alert alert-info" style="text-align: center">
                <i class="fa fa-exclamation-triangle text-info fa-2x"></i> <strong style="font-size: 14px"> No se encontraron registros </strong>
            </div>
        </g:else>

        </tbody>
    </table>
</div>