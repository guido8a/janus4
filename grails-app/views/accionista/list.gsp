<div style="overflow: hidden">
    <fieldset class="borde" style="border-radius: 4px">
        <div class="row-fluid" style="margin-left: 10px">
            <div class="alert alert-success" style="font-size: 14px;">
                Accionistas de: <strong> ${proveedor?.nombre} </strong>
            </div>
        </div>
        <div class="btn-group">
            <a class="btn btn-success" href="#" title="Crear accionista" id="btnNuevoAccionista" data-id="${proveedor?.id}">
                <i class="fa fa-file"></i> Nuevo accionista
            </a>
        </div>
    </fieldset>

    <fieldset class="borde" style="border-radius: 4px">
        <div id="divTablaAccionistas" style="height: 310px; overflow: auto; margin-top: 5px">
        </div>
    </fieldset>
</div>

<script type="text/javascript">

    var dac;

    $("#btnNuevoAccionista").click(function () {
        createEditItem();
    });

    cargarTablaAccionistas();

    function cargarTablaAccionistas(){
        var proveedor = '${proveedor?.id}';
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'accionista', action:'tablaAccionistas_ajax')}",
            data: {
               proveedor: proveedor
            },
            success: function (msg) {
                $("#divTablaAccionistas").html(msg);
            }
        });
    }

    function createEditItem(id) {
        var title = id ? "Editar" : "Crear";
        var data = id ? {id : id} : {};
        data.proveedor = '${proveedor?.id}';
        $.ajax({
            type    : "POST",
            url     : "${createLink( action:'form_ajax')}",
            data    : data,
            success : function (msg) {
                dac = bootbox.dialog({
                    id    : "dlgCreateEditIT",
                    title : title + " accionista",
                    // class : "modal-lg",
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
                                return submitFormAccionista();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    } //createEdit

    function submitFormAccionista() {
        var $form = $("#frmSaveAccionista");
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
                        cerrarNuevoAccionista();
                        cargarTablaAccionistas()
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

    function cerrarNuevoAccionista(){
        dac.modal("hide");
    }

</script>