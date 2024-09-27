<div role="main" style="margin-top: 10px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 17%">Código</th>
            <th style="width: 75%">Descripción</th>
            <th style="width: 9%">Acciones</th>
            <th style="width: 1%"></th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
        <tbody>
        <g:each in="${items}" var="item" status="i">
            <tr>
                <td style="width: 15%">${item.item.codigo}</td>
                <td style="width: 70%">${item.item.nombre}</td>
                <td style="width: 10%">

                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>