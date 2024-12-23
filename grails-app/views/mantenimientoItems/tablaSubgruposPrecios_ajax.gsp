
<div role="main" style="margin-top: 5px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 10%">Código Grupo</th>
            <th style="width: 20%">Grupo</th>
            <th style="width: 10%">Código</th>
            <th style="width: 45%">Descripción</th>
            <th style="width: 10%">Acciones</th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
        <tbody>
        <g:if test="${subgrupos}">
            <g:each in="${subgrupos}" status="i" var="sbgr">
%{--                <tr data-id="${sbgr?.dprt__id}">--}%
                <tr data-id="${sbgr?.id}">
%{--                    <td style="width: 10%">${sbgr?.sbgrcdgo}</td>--}%
%{--                    <td style="width: 20%">${sbgr?.sbgrdscr}</td>--}%
%{--                    <td style="width: 10%">${sbgr?.dprtcdgo}</td>--}%
%{--                    <td style="width: 45%">${sbgr?.dprtdscr}</td>--}%
%{--                    <td style="width: 10%; text-align: center">--}%
%{--                        <a href="#" class="btn btn-xs btn-warning btnEstructuraSubgrupo" data-id="${sbgr?.dprt__id}" title="Materiales">--}%
%{--                            <i class="fas fa-list"></i>--}%
%{--                        </a>--}%
%{--                    </td>--}%

                    <td style="width: 10%">${sbgr?.subgrupo?.codigo}</td>
                    <td style="width: 20%">${sbgr?.subgrupo?.descripcion}</td>
                    <td style="width: 10%">${sbgr?.codigo}</td>
                    <td style="width: 45%">${sbgr?.descripcion}</td>
                    <td style="width: 10%; text-align: center">
                        <a href="#" class="btn btn-xs btn-warning btnEstructuraSubgrupo" data-id="${sbgr?.id}" title="Materiales">
                            <i class="fas fa-list"></i>
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

    var dfs;

    $(".btnCrearMaterial").click(function () {
        var id = $(this).data("id");
        createEditItem(null,id)
    });

    $(".btnEstructuraSubgrupo").click(function () {
        var id = $(this).data("id");
        $("#tipo").val(3);
        cargarTablaItemsPrecios(id);
    });

    $(".btnNuevoSubgrupo").click(function () {
        createEditSubgrupo();
    });

    $(".btnEditarSubgrupo").click(function () {
        var id = $(this).data("id");
        createEditSubgrupo(id);
    });

    $(".btnEliminarSubgrupo").click(function () {
        var id = $(this).data("id");
        deleteSubGrupo(id);
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
        var $form = $("#frmSaveDp");
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
                        cargarTablaItemsPrecios();
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

    function deleteSubGrupo(id){
        bootbox.confirm({
            title: "Eliminar Subgrupo",
            message: '<i class="fa fa-trash text-danger fa-3x"></i>' + '<strong style="font-size: 14px">' + "Está seguro de borrar este subgrupo? Esta acción no puede deshacerse. " + '</strong>' ,
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
                        url: '${createLink(action: 'deleteDp_ajax')}',
                        data:{
                            id: id
                        },
                        success: function (msg) {
                            dialog.modal('hide');
                            var parts = msg.split("_");
                            if(parts[0] === 'ok'){
                                log(parts[1],"success");
                                cargarTablaItemsPrecios();
                            }else{
                                log(parts[1], "error")
                            }
                        }
                    });
                }
            }
        });
    }

    function verEstructura(id) {
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'mantenimientoItems', action:'estructuraSubgrupo_ajax')}",
            data    : {
                id: id
            },
            success : function (msg) {
                var e = bootbox.dialog({
                    id    : "dlgVerEstructura",
                    title : "Estructura del subgrupo",
                    // class : "modal-lg",
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
    } //createEdit


    function cerrarFormSubgrupo(){
        dfs.modal("hide");
    }


</script>