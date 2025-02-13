<div role="main" style="margin-top: 10px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 25%">Subpresupuesto</th>
            <th style="width: 16%">Código</th>
            <th style="width: 43%">Descripción</th>
            <th style="width: 10%">Cantidad</th>
            <th style="width: 8%">Acciones</th>
            <th style="width: 1%"></th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 475px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
        <tbody>
        <g:if test="${valores}">
%{--            <g:each in="${valores}" var="val" status="i">--}%
%{--                <tr>--}%
%{--                    <td style="width: 24%; font-size: 10px">${val.sbprdscr}</td>--}%
%{--                    <td style="width: 15%; font-size: 10px">${val.rbrocdgo}</td>--}%
%{--                    <td style="width: 40%; font-size: 12px">${val.rbronmbr}</td>--}%
%{--                    <td style="width: 10%"><g:formatNumber number="${val.vlobcntd}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/></td>--}%
%{--                    <td style="width: 9%">--}%
%{--                        <g:if test="${obra.estado!='R' && duenoObra == 1}">--}%
%{--                            <a href="#" class="btn btn-danger btn-xs btnBorrarSeleccion" data-id="${val.vlob__id}" ><i class="fa fa-trash"></i></a>--}%
%{--                        </g:if>--}%
%{--                    </td>--}%
%{--                    <td style="width: 1%"></td>--}%
%{--                </tr>--}%
%{--            </g:each>--}%
        </g:if>
        <g:else>
            <div class="alert alert-info" style="text-align: center">
                <i class="fa fa-exclamation-triangle text-info fa-2x"></i> <strong style="font-size: 14px"> No existen registros </strong>
            </div>
        </g:else>
        </tbody>
    </table>
</div>