<div role="main" style="margin-top: 5px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 15%">Código</th>
            <th style="width: 70%">Item</th>
            <th style="width: 15%">Aporte</th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 40px; overflow-y: auto;float: right; margin-top: -20px;">
    <table class="table-bordered table-striped table-condensed table-hover" >
        <tbody>
        <g:if test="${items}">
            <g:each in="${items}" var="item" status="i">
                <tr style="background-color: #4dcfff">
                    <td style="width: 15%">${item?.codigo}</td>
                    <td style="width: 70%">${item?.item}</td>
                    <td style="width: 15%">${item?.aporte}</td>
                </tr>
            </g:each>
        </g:if>
        <g:else>
            <div class="alert alert-info" style="text-align: center">
                <i class="fa fa-exclamation-triangle text-info fa-2x"></i> <strong style="font-size: 14px"> No se encontraron registros </strong>
            </div>
        </g:else>
        </tbody>
    </table>
</div>

<div class="col-md-10">
    <g:select name="indicesSelect" class="form-control" from="${indices}" optionValue="${{it.indcdscr}}" optionKey="${{it.indc__id}}" />
</div>
<div class="col-md-1">
    <a href="#" class="btn btn-success btn-xs btnSeleccionar"><i class="fa fa-save"></i></a>
</div>


%{--<div role="main" style="margin-top: 5px;">--}%
%{--    <table class="table table-bordered table-striped table-condensed table-hover">--}%
%{--        <thead>--}%
%{--        <tr>--}%
%{--            <th style="width: 15%">Código</th>--}%
%{--            <th style="width: 70%">Descripción</th>--}%
%{--            <th style="width: 15%">Seleccionar</th>--}%
%{--        </tr>--}%
%{--        </thead>--}%
%{--    </table>--}%
%{--</div>--}%

%{--<div class="" style="width: 99.7%;height: 350px; overflow-y: auto;float: right; margin-top: -20px">--}%
%{--    <table class="table-bordered table-striped table-condensed table-hover">--}%
%{--        <tbody>--}%
%{--        <g:if test="${indices}">--}%
%{--            <g:each in="${indices}" var="indice" status="i">--}%
%{--                <tr>--}%
%{--                    <td style="width: 15%">${indice?.indccdgo}</td>--}%
%{--                    <td style="width: 70%">${indice?.indcdscr}</td>--}%
%{--                    <td style="width: 15%">--}%
%{--                        <a href="#" class="btn btn-success btn-xs btnSeleccionar" data-id="${indice?.indc__id}"><i class="fa fa-check"></i></a>--}%
%{--                    </td>--}%
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

    cargarItemsNuevos($("#indicesSelect option:selected").val());

    $("#indicesSelect").change(function () {
        var indice = $(this).val();
        console.log(indice)
        cargarItemsNuevos(indice)
    });

</script>