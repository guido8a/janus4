<div class="row">
    <div class="col-md-12">
        <div class="alert alert-warning">
            <i class="fa fa-exclamation-triangle text-danger fa-3x"></i> <strong style="font-size: 14px">No se puede borrar el material, se usa en las siguientes obras </strong>
        </div>

        <div role="main" style="margin-top: 10px;">
            <table class="table table-bordered table-striped table-condensed table-hover">
                <thead>
                <tr>
                    <th style="width: 25%">Código</th>
                    <th style="width: 75%">Nombre</th>
                </tr>
                </thead>
            </table>
        </div>

        <div class="" style="width: 99.7%;height: 400px; overflow-y: auto;float: right; margin-top: -20px">
            <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
                <tbody>
                <g:each in="${volumenes}" status="i" var="volumen">
                    <tr>
                        <td style="width: 25%">${volumen?.obra?.codigo}</td>
                        <td style="width: 75%">${volumen?.obra?.nombre}</td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>
    </div>
</div>
