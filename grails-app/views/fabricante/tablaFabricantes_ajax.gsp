<div role="main" style="margin-top: 10px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 30%">Fabricante - Nombre</th>
            <th style="width: 20%">Contacto</th>
            <th style="width: 40%">Observaciones</th>
            <th style="width: 10%">Acciones</th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
        <tbody>
        <g:if test="${data?.size() > 0}">
            <g:each in="${data}" status="i" var="fabricante">
                <tr data-id="${fabricante?.fabr__id}">
                    <td style="width: 30%">${fabricante?.fabrnmbr}</td>
                    <td style="width: 20%">${(fabricante?.fabrnbct ?: '') + " " + (fabricante?.fabrapct?:'')}</td>
                    <td style="width: 40%">${fabricante?.fabrobsr}</td>
                    <td style="width: 10%; text-align: center">
                        <a href="#" class="btn btn-xs btn-info btnVerFabricante" data-id="${fabricante?.fabr__id}" title="Ver">
                            <i class="fas fa-search"></i>
                        </a>
                        <a href="#" class="btn btn-xs btn-success btnEditarExamen" data-id="${fabricante?.fabr__id}" title="Editar">
                            <i class="fas fa-edit"></i>
                        </a>
                        <a href="#" class="btn btn-xs btn-danger btnEliminarExamen" data-id="${fabricante?.fabr__id}" title="Eliminar">
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

    $(".btnVerFabricante").click(function () {
        var id = $(this).data("id");
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'fabricante', action:'show_ajax')}",
            data    : {
                id: id
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgVerFabricante",
                    title   : "Ver Fabricante",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        }
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    });

</script>