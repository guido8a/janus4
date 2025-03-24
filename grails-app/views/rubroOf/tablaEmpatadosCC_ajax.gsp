
<g:if test="${!materiales}">
    <div class="alert alert-success" style="text-align: center; font-size: 14px">
        <i class="fa fa fa-thumbs-up text-info fa-2x"></i> <strong style="font-size: 14px"> Todos los materiales emparejados </strong>
    </div>
</g:if>
<g:else>
    <div class="alert alert-warning" style="text-align: center; font-size: 14px">
        <i class="fa fa-exclamation-triangle text-info fa-2x"></i> <strong style="font-size: 14px"> Existen materiales no emparejados </strong>
    </div>
</g:else>

<g:if test="${!mano}">
    <div class="alert alert-success" style="text-align: center; font-size: 14px">
        <i class="fa fa fa-thumbs-up text-info fa-2x"></i> <strong style="font-size: 14px"> Todos la mano de obra emparejada </strong>
    </div>
</g:if>
<g:else>
    <div class="alert alert-warning" style="text-align: center; font-size: 14px">
        <i class="fa fa-exclamation-triangle text-info fa-2x"></i> <strong style="font-size: 14px"> Existe mano de obra no emparejada </strong>
    </div>
</g:else>

<g:if test="${!equipos}">
    <div class="alert alert-success" style="text-align: center; font-size: 14px">
        <i class="fa fa-thumbs-up text-info fa-2x"></i> <strong style="font-size: 14px"> Todos los equipos emparejados </strong>
    </div>
</g:if>
<g:else>
    <div class="alert alert-warning" style="text-align: center; font-size: 14px">
        <i class="fa fa-exclamation-triangle text-info fa-2x"></i> <strong style="font-size: 14px"> Existen equipos no emparejados </strong>
    </div>
</g:else>

<g:if test="${!materiales}">
    <g:if test="${!mano}">
        <g:if test="${!equipos}">
            <div class="row-fluid">
                <div class="col-md-4" style="margin-top: 10px">
                </div>
                <div class="col-md-4" style="margin-top: 10px; width: 33%">
                    <a href="#" class="btn btn-info" id="btnCopiar" style="text-align: center; width: 100%">
                        <i class="fa fa-edit"></i>
                        Copiar composición a los APU del Oferente
                    </a>
                </div>
            </div>
        </g:if>
    </g:if>
</g:if>

%{--<div role="main" style="margin-top: 5px;">--}%
%{--    <table class="table table-bordered table-striped table-condensed table-hover">--}%
%{--        <thead>--}%
%{--        <tr style="width: 100%">--}%
%{--            <th colspan="8">Rubros Empatados</th>--}%
%{--        </tr>--}%
%{--        <tr>--}%
%{--            <th style="width: 8%">Tipo</th>--}%
%{--            <th style="width: 8%">Código</th>--}%
%{--            <th style="width: 32%">Descripción</th>--}%
%{--            <th style="width: 8%">Equivale a</th>--}%
%{--            <th style="width: 8%">Código</th>--}%
%{--            <th style="width: 30%">Descripción</th>--}%
%{--            <th style="width: 1%"></th>--}%
%{--        </tr>--}%
%{--        </thead>--}%
%{--    </table>--}%
%{--</div>--}%

%{--<div class="" style="width: 99.7%;height: 350px; overflow-y: auto;float: right; margin-top: -20px">--}%
%{--    <table class="table-bordered table-striped table-condensed table-hover" width="100%">--}%
%{--        <tbody>--}%
%{--        <g:if test="${data}">--}%
%{--            <g:each in="${data}" var="d" status="i">--}%
%{--                <tr>--}%
%{--                    <td style="width: 8%">${d?.dtrbtipo == 'EQ' ? 'Equipos' : (d?.dtrbtipo == 'MT' ? 'Materiales' : 'Mano de Obra') }</td>--}%
%{--                    <td style="width: 8%">${d?.dtrbcdgo}</td>--}%
%{--                    <td style="width: 32%">${d?.dtrbnmbr}</td>--}%
%{--                    <td style="width: 8%; text-align: center"><i class="fa fa-exchange-alt fa-3x text-success"></i> </td>--}%
%{--                    <td style="width: 8%">${d?.itemcdgo}</td>--}%
%{--                    <td style="width: 30%">${d?.itemnmbr}</td>--}%
%{--                    <td style="width: 1%"></td>--}%
%{--                </tr>--}%
%{--            </g:each>--}%
%{--        </g:if>--}%
%{--        <g:else>--}%
%{--            <div class="alert alert-info" style="text-align: center">--}%
%{--                <i class="fa fa-exclamation-triangle text-info fa-2x"></i> <strong style="font-size: 14px"> No se encontraron registros </strong>--}%
%{--            </div>--}%
%{--        </g:else>--}%
%{--        </tbody>--}%
%{--    </table>--}%
%{--</div>--}%

<script type="text/javascript">



</script>