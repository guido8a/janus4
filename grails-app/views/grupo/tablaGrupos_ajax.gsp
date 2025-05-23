%{--<div style="position: fixed; top: 150px; float: left">--}%
%{--    <strong>Número de grupos desplegados: ${numero}</strong>--}%
%{--</div>--}%
<div class="col-md-12" style="text-align: center; font-size: 14px; font-weight: bold;  margin-top: -30px">
%{--    <div class="col-md-4"></div>--}%
%{--    <div class="col-md-2" role="alert">--}%
%{--        <ol class="breadcrumb" style="font-weight: bold">--}%
%{--            <li class="active"><i class="fa fa-${grupo?.descripcion == 'OBRAS VIALES' ? 'car' : (grupo?.descripcion == 'OBRAS DE RIEGO' ? 'water' : 'hammer') } text-warning"></i> ${grupo?.descripcion}</li>--}%
%{--        </ol>--}%
%{--    </div>--}%
%{--    <div class="col-md-4" role="alert">--}%
%{--        <ol class="breadcrumb" style="font-weight: bold">--}%
%{--            <li class="active">GRUPO</li>--}%
%{--        </ol>--}%
%{--    </div>--}%


    <div class="col-md-2" style="float: right">
        <a href="#" class="btn btn-sm btn-success btnNuevoGrupo" title="Crear nuevo grupo">
            <i class="fas fa-file"></i> Nuevo Grupo
        </a>
    </div>
</div>

<div role="main" style="margin-top: 5px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 10%">Código</th>
            <th style="width: 80%">Descripción</th>
            <th style="width: 10%">Acciones</th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
        <tbody>
        <g:each in="${grupos}" status="i" var="grupo">
            <tr data-id="${grupo?.id}">
                <td style="width: 10%">${grupo?.codigo}</td>
                <td style="width: 80%">${grupo?.descripcion}</td>
                <td style="width: 10%; text-align: center">
                    <a href="#" class="btn btn-xs btn-success btnEditarGrupo" data-id="${grupo?.id}" title="Editar">
                        <i class="fas fa-edit"></i>
                    </a>
                    <a href="#" class="btn btn-xs btn-warning btnEstructuraGrupo" data-id="${grupo?.id}" title="Subgrupos">
                        <i class="fas fa-list"></i>
                    </a>
                    <a href="#" class="btn btn-xs btn-primary btnImprimirGrupo" data-id="${grupo?.id}" title="Imprimir rubros del subgrupo">
                        <i class="fas fa-print"></i>
                    </a>
                    <a href="#" class="btn btn-xs btn-danger btnEliminarGrupo" data-id="${grupo?.id}" title="Eliminar">
                        <i class="fas fa-trash"></i>
                    </a>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>

<script type="text/javascript">

    var dfg;

    $(".btnEstructuraGrupo").click(function () {
        var id = $(this).data("id");
        $("#tipo").val(2);
        cargarTablaGrupoRubros(id);
    });

    $(".btnNuevoGrupo").click(function () {
        createEditGrupo();
    });

    $(".btnEditarGrupo").click(function () {
        var id = $(this).data("id");
        createEditGrupo(id);
    });

    $(".btnEliminarGrupo").click(function () {
        var id = $(this).data("id");
        deleteGrupo(id);
    });

    function createEditGrupo(id) {
        var title = id ? "Editar" : "Crear";
        var data = id ? {id : id} : {};
        data.grupo = '${grupo?.id}';
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'mantenimientoItems', action:'formSg_ajax')}",
            data    : data,
            success : function (msg) {
                dfg = bootbox.dialog({
                    id    : "dlgCreateEditGP",
                    title : title + " grupo",
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
                                return submitFormGrupo();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    } //createEdit

    function submitFormGrupo() {
        var $form = $("#frmSave");
        var $btn = $("#dlgCreateEditGP").find("#btnSave");
        if ($form.valid()) {
            var data = $form.serialize();
            $btn.replaceWith(spinner);
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
                        cerrarFormGrupo();
                        cargarTablaGrupoRubros();
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

    function deleteGrupo(id){
        bootbox.confirm({
            title: "Eliminar Grupo",
            message: '<i class="fa fa-trash text-danger fa-3x"></i>' + '<strong style="font-size: 14px">' + "Está seguro de borrar este grupo? Esta acción no puede deshacerse. " + '</strong>' ,
            buttons: {
                cancel: {
                    label: '<i class="fa fa-times"></i> Cancelar',
                    className: 'btn-primary'
                },
                confirm: {
                    label: '<i class="fa fa-trash"></i> Borrar',
                    className: 'btn-danger'
                }
            },
            callback: function (result) {
                if(result){
                    var dialog = cargarLoader("Borrando...");
                    $.ajax({
                        type: 'POST',
                        url: '${createLink(controller: 'mantenimientoItems', action: 'deleteSg_ajax')}',
                        data:{
                            id: id
                        },
                        success: function (msg) {
                            dialog.modal('hide');
                            var parts = msg.split("_");
                            if(parts[0] === 'ok'){
                                log(parts[1],"success");
                                cargarTablaGrupoRubros();
                            }else{
                                log(parts[1], "error")
                            }
                        }
                    });
                }
            }
        });
    }


    function cerrarFormGrupo(){
        dfg.modal("hide");
    }

    $(".btnImprimirGrupo").click(function () {
        var id = $(this).data("id");
        imprimirRubrosGrupo(id, 'sg');
    });

</script>