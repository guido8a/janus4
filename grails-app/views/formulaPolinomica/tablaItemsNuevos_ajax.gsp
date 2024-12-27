<div role="main" style="margin-top: 5px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 15%">Código</th>
            <th style="width: 55%">Item</th>
            <th style="width: 15%">Aporte</th>
            <th style="width: 15%">Acciones</th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 350px; overflow-y: auto;float: right; margin-top: -20px;">
    <table class="table-bordered table-striped table-condensed table-hover" >
        <tbody>
        <g:if test="${items}">
            <g:each in="${items}" var="item" status="i">
                <tr>
                    <td style="width: 15%">${item?.codigo}</td>
                    <td style="width: 55%">${item?.item}</td>
                    <td style="width: 15%">${item?.aporte}</td>
                    <td style="width: 15%">
                        <g:checkBox name="aaa" value="" />
                    </td>
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