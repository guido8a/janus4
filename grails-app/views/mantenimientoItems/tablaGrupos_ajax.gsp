<div class="col-md-12" style="text-align: center; font-size: 14px; font-weight: bold; margin-top: -30px">
    <div class="col-md-6"></div>
%{--    <div class="col-md-2" role="alert">--}%
%{--        <ol class="breadcrumb" style="font-weight: bold">--}%
%{--            <li class="active"><i class="fa fa-${grupo?.descripcion == 'MATERIALES' ? 'box' : (grupo?.descripcion == 'MANO DE OBRA' ? 'users' : 'truck') } text-warning"></i> ${grupo?.descripcion}</li>--}%
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
            <tr data-id="${grupo?.sbgr__id}">
                <td style="width: 10%">${grupo?.sbgrcdgo}</td>
                <td style="width: 80%">${grupo?.sbgrdscr} ${session.perfil.nombre}</td>
                <td style="width: 10%; text-align: center">
                    <a href="#" class="btn btn-xs btn-warning btnEstructuraGrupo" data-id="${grupo?.sbgr__id}" title="Subgrupos">
                        <i class="fas fa-list"></i>
                    </a>
                    <g:if test="${session.perfil.nombre == 'CRFC'}">
                        <a href="#" class="btn btn-xs btn-success btnEditarGrupo" data-id="${grupo?.sbgr__id}" title="Editar">
                            <i class="fas fa-edit"></i>
                        </a>
                        <a href="#" class="btn btn-xs btn-danger btnEliminarGrupo" data-id="${grupo?.sbgr__id}" title="Eliminar">
                            <i class="fas fa-trash"></i>
                        </a>
                    </g:if>
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
        cargarTablaItems(id);
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
            url     : "${createLink( action:'formSg_ajax')}",
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
                        cargarTablaItems();
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
                        url: '${createLink(action: 'deleteSg_ajax')}',
                        data:{
                            id: id
                        },
                        success: function (msg) {
                            dialog.modal('hide');
                            var parts = msg.split("_");
                            if(parts[0] === 'ok'){
                                log(parts[1],"success");
                                cargarTablaItems();
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

</script>