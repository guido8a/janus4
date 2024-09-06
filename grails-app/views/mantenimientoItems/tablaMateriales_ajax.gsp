<div class="col-md-12" style="text-align: center; font-size: 14px; font-weight: bold">
    <div class="col-md-4"></div>
    <div class="alert alert-success col-md-2" role="alert"><i class="fa fa-${grupo?.descripcion == 'MATERIALES' ? 'box' : (grupo?.descripcion == 'MANO DE OBRA' ? 'users' : 'truck') } text-warning"></i> ${grupo?.descripcion}</div>
    <div class="col-md-4" role="alert">
        <ol class="breadcrumb" style="font-weight: bold">
            <li class="active">GRUPO</li>
            <li class="active">SUBGRUPO</li>
            <li class="active">MATERIALES</li>
        </ol>
    </div>
</div>

<div role="main" style="margin-top: 5px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 8%">Código Grupo</th>
            <th style="width: 15%">Grupo</th>
            <th style="width: 8%">Código Subgrupo</th>
            <th style="width: 15%">Subgrupo</th>
            <th style="width: 10%">Código</th>
            <th style="width: 35%">Descripción</th>
            <th style="width: 10%">Acciones</th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
        <tbody>
        <g:each in="${materiales}" status="i" var="material">
            <tr data-id="${material?.id}">
                <td style="width: 8%">${material?.departamento?.subgrupo?.codigo}</td>
                <td style="width: 15%">${material?.departamento?.subgrupo?.descripcion}</td>
                <td style="width: 8%">${material?.departamento?.codigo}</td>
                <td style="width: 15%">${material?.departamento?.descripcion}</td>
                <td style="width: 10%">${material?.codigo}</td>
                <td style="width: 35%">${material?.nombre}</td>
                <td style="width: 10%; text-align: center">
                    <a href="#" class="btn btn-xs btn-success btnEditarMaterial" data-id="${material?.id}" title="Editar">
                        <i class="fas fa-edit"></i>
                    </a>
                    <a href="#" class="btn btn-xs btn-danger btnEliminarMaterial" data-id="${material?.id}" title="Eliminar">
                        <i class="fas fa-trash"></i>
                    </a>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>

<script type="text/javascript">

    $(".btnEditarMaterial").click(function () {
        var id = $(this).data("id");
        // createEditRow(id);
    });

    $(".btnEliminarMaterial").click(function () {
        var id = $(this).data("id");
        // deleteRow(id);
    });

</script>