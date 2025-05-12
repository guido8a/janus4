<div class="row">
    <div class="col-md-12">

        <div class="alert alert-success" style="font-size: 14px; font-weight: bold">
            <i class="fa fa-list fa-2x"></i> Rubros sin código de especificación
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
                <g:each in="${rubros}" status="i" var="rubro">
                    <tr>
                        <td style="width: 25%">${rubro?.itemcdgo}</td>
                        <td style="width: 75%">${rubro?.itemnmbr}</td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>
    </div>
</div>

