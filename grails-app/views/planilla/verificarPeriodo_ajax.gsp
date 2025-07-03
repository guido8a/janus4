<div class="row">
    <div class="col-md-12">

        <div class="breadcrumb" style="text-align: center">
            <i class="fa fa-exclamation-triangle fa-2x text-warning"></i> <strong style="font-size: 14px;"> No existen valores para los siguientes índices </strong>
        </div>

        <table class="table table-bordered table-striped table-condensed table-hover">
            <thead>
            <tr style="width: 100%">
                <th style="width:55%;">Descripción</th>
                <th style="width:15%;">Período</th>
                <th style="width:15%;">Fecha inicio</th>
                <th style="width:15%;">Fecha Fin</th>
            </tr>
            </thead>
        </table>

        <div class="" style="width: 100%;height: 250px; overflow-y: auto;float: right; margin-top: -20px">
            <table class="table-bordered table-condensed table-hover table-striped" style="width: 100%">
                <tbody>
                <g:if test="${datos.size() > 0}">
                    <g:each in="${datos}" var="dato">
                        <tr style="width: 100%">
                            <td style="width:55%">${dato?.indcdscr}</td>
                            <td style="width:15%;">${dato?.prindscr}</td>
                            <td style="width:15%;">${dato?.prinfcin}</td>
                            <td style="width:15%;">${dato?.prinfcfn}</td>
                        </tr>
                    </g:each>
                </g:if>
                <g:else>
                    <tr>
                        <td class="alert alert-info" colspan="7" style="text-align: center"> <h3><i class="fa fa-exclamation-triangle"></i> No exiten registros</h3> </td>
                    </tr>
                </g:else>
                </tbody>
            </table>
        </div>
    </div>
</div>

