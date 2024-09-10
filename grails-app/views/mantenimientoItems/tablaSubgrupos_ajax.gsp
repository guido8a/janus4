<div class="col-md-12" style="text-align: center; font-size: 14px; font-weight: bold">
    <div class="col-md-4"></div>
    <div class="col-md-2" role="alert">
        <ol class="breadcrumb" style="font-weight: bold">
            <li class="active"><i class="fa fa-${grupo?.descripcion == 'MATERIALES' ? 'box' : (grupo?.descripcion == 'MANO DE OBRA' ? 'users' : 'truck') } text-warning"></i> ${grupo?.descripcion}</li>
        </ol>
    </div>
    <div class="col-md-4" role="alert">
        <ol class="breadcrumb" style="font-weight: bold">
            <li class="active">GRUPO</li>
            <li class="active">SUBGRUPO</li>
        </ol>
    </div>
    <div class="col-md-2">
        <a href="#" class="btn btn-sm btn-success btnNuevoSubgrupo" title="Crear nuevo subgrupo">
            <i class="fas fa-file"></i> Nuevo Subgrupo
        </a>
    </div>
</div>

<div role="main" style="margin-top: 5px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 10%">Código Grupo</th>
            <th style="width: 20%">Grupo</th>
            <th style="width: 10%">Código</th>
            <th style="width: 50%">Descripción</th>
            <th style="width: 10%">Acciones</th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
        <tbody>
        <g:each in="${subgrupos}" status="i" var="subgrupo">
            <tr data-id="${subgrupo?.id}">
                <td style="width: 10%">${subgrupo?.subgrupo?.codigo}</td>
                <td style="width: 20%">${subgrupo?.subgrupo?.descripcion}</td>
                <td style="width: 10%">${subgrupo?.codigo}</td>
                <td style="width: 50%">${subgrupo?.descripcion}</td>
                <td style="width: 10%; text-align: center">
                    <a href="#" class="btn btn-xs btn-success btnEditarSubgrupo" data-id="${subgrupo?.id}" title="Editar">
                        <i class="fas fa-edit"></i>
                    </a>
                    <a href="#" class="btn btn-xs btn-danger btnEliminarSubgrupo" data-id="${subgrupo?.id}" title="Eliminar">
                        <i class="fas fa-trash"></i>
                    </a>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>

<script type="text/javascript">

    var dfs;

    $(".btnNuevoSubgrupo").click(function () {
        createEditSubgrupo();
    });

    $(".btnEditarSubgrupo").click(function () {
        var id = $(this).data("id");
        createEditSubgrupo(id);
    });

    $(".btnEliminarSubgrupo").click(function () {
        var id = $(this).data("id");
        // deleteRow(id);
    });

    function createEditSubgrupo(id) {
        var title = id ? "Editar" : "Crear";
        var data = id ? {id : id} : {};
        data.grupo = '${grupo?.id}';
        $.ajax({
            type    : "POST",
            url     : "${createLink( action:'formDp_ajax')}",
            data    : data,
            success : function (msg) {
                dfs= bootbox.dialog({
                    id    : "dlgCreateEditDP",
                    title : title + " subgrupo",
                    class : "modal-lg",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        guardar  : {
                            id        : "btnSave",
                            label     : "<i class='fa fa-save'></i> Guardar",
                            className : "btn-success",
                            callback  : function () {
                                return submitFormSubgrupo();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    } //createEdit

    function submitFormSubgrupo() {
        var $form = $("#frmSave");
        if ($form.valid()) {
            var data = $form.serialize();
            var dialog = cargarLoader("Guardando...");
            $.ajax({
                type    : "POST",
                url     : $form.attr("action"),
                data    : data,
                success : function (msg) {
                    dialog.modal('hide');
                    var parts = msg.split("_");
                    if(parts[0] === 'ok'){
                        log(parts[1], "success");
                        cargarTablaItems();
                        cerrarFormSubgrupo();
                    }else{
                        bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                        return false;
                    }
                }
            });
            return false;
        } else {
            return false;
        }
    }

    function cerrarFormSubgrupo(){
        dfs.modal("hide");
    }


</script>