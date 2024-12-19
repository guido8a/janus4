<div role="main" style="margin-top: 10px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 25%">Nombre</th>
            <th style="width: 20%">Contacto</th>
            <th style="width: 45%">Observaciones</th>
            <th style="width: 10%">Acciones</th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
        <tbody>
        <g:if test="${fabricantes.size() > 0}">
            <g:each in="${fabricantes}" status="i" var="fabricante">
                <tr data-id="${fabricante.id}">
                    <td style="width: 15%">${fabricante?.ruc}</td>
                    <td style="width: 25%">${fabricante?.nombre}</td>
                    <td style="width: 10%">${fabricante?.telefono}</td>
                    <td style="width: 10%">${fabricante?.mail}</td>
                    <td style="width: 10%; text-align: center">
                        <a href="#" class="btn btn-xs btn-success btnEditarExamen" data-id="${fabricante?.id}" title="Editar">
                            <i class="fas fa-edit"></i>
                        </a>
                        <a href="#" class="btn btn-xs btn-danger btnEliminarExamen" data-id="${fabricante?.id}" title="Eliminar">
                            <i class="fas fa-trash"></i>
                        </a>
                    </td>
                </tr>
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

<script type="text/javascript">

    $(".btnEditarExamen").click(function () {
        var id = $(this).data("id");
        createEditRow(id);
    });

    $(".btnEliminarExamen").click(function () {
        var id = $(this).data("id");
        deleteRow(id);
    });

</script>