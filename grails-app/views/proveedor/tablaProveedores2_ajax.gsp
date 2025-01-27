<div id="list-Proveedor" role="main" style="margin-top: 10px;">

    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 10%">Especialidad</th>
            <th style="width: 10%">Tipo</th>
            <th style="width: 10%">Ruc</th>
            <th style="width: 25%">Nombre</th>
            <th style="width: 33%">Contacto</th>
            <th style="width: 12%">Acciones</th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
        <tbody>
        <g:each in="${datos}" status="i" var="proveedorInstance">
            <tr>
                <td style="width: 10%">${janus.EspecialidadProveedor.get(proveedorInstance.espc__id)?.descripcion}</td>
                <td style="width: 10%">${(proveedorInstance.prvetipo=="N")?"Natural": (proveedorInstance.prvetipo=="J")? "Jurídica":"Empresa Pública"}</td>
                <td style="width: 10%">${proveedorInstance?.prve_ruc}</td>
                <td style="width: 25%">${proveedorInstance?.prvenmbr}</td>
                <td style="width: 33%">${proveedorInstance?.prvenbct + " " + (proveedorInstance?.prveapct ?: '')}</td>
                <td style="width: 12%">
                    <a class="btn btn-xs btn-show btn-info" href="#" rel="tooltip" title="Ver" data-id="${proveedorInstance.prve__id}">
                        <i class="fa fa-search"></i>
                    </a>
                    <a class="btn btn-xs btn-edit btn-success" href="#" rel="tooltip" title="Editar" data-id="${proveedorInstance.prve__id}">
                        <i class="fa fa-edit"></i>
                    </a>
                    <g:if test="${proveedorInstance.prvetipo=="J"}">
                        <a class="btn btn-xs btn-info btnAccionistas" href="#" title="Accionistas" data-id="${proveedorInstance.prve__id}">
                            <i class="fa fa-users"></i>
                        </a>
                    </g:if>
                    <a class="btn btn-xs btn-delete btn-danger" href="#" rel="tooltip" title="Eliminar" data-id="${proveedorInstance.prve__id}">
                        <i class="fa fa-trash"></i>
                    </a>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>

<script type="text/javascript">

    $(".btnAccionistas").click(function () {
        var id = $(this).data("id");
        $.ajax({
            type    : "POST",
            url     : "${createLink( controller: 'accionista', action: 'list')}",
            data    : {
                id : id
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgAccionistas",
                    title   : "Accionistas",
                    class: 'modal-lg',
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
            }
        });
    });

    $(".btn-new").click(function () {
        createEditRow();
    }); //click btn new

    $(".btn-edit").click(function () {
        var id = $(this).data("id");
        createEditRow(id);
    }); //click btn edit

    $(".btn-show").click(function () {
        var id = $(this).data("id");
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'show_ajax')}",
            data    : {
                id : id
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgShow",
                    title   : "Ver Proveedor",
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
            }
        });
    }); //click btn show

    $(".btn-delete").click(function () {
        var id = $(this).data("id");
        deleteRow(id);
    });



</script>