
<div class="row" >
    <div class="col-md-12">
        <div class="col-md-6" style="text-align: center">
            <label>Tipo de Lista</label>
            <g:select from="${janus.TipoLista.list().sort{it.descripcion}}" optionValue="descripcion" optionKey="id"  name="tipoLista" class="form-control" />
        </div>
        <div class="grupo col-md-2" style="margin-top: 20px">
            <a href="#" class="btn btn-success btn-sm btnNuevaLista" title="Nueva lista">
                <i class="fa fa-file"></i> Nueva Lista
            </a>
        </div>
    </div>
</div>

<fieldset class="borde" style="border-radius: 4px">
    <div id="divTablaListas" style="height: 460px; overflow: auto; margin-top: 5px">
    </div>
</fieldset>


<script type="text/javascript">

    $("#tipoLista").change(function () {
        cargarTablaListas();
    });

    $(".btnNuevaLista").click(function () {
        createEditLista();
    });

    function createEditLista(id, parentId) {
        var title = id ? "Editar" : "Crear";
        var data = id ? {id : id} : {};
        $.ajax({
            type    : "POST",
            url     : "${createLink( action:'formLg_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id    : "dlgCreateEditLT",
                    title : title + " lista",
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
                                return submitFormLista(parentId);
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
                setTimeout(function () {
                    b.find(".form-control").first().focus()
                }, 500);
            } //success
        }); //ajax
    } //createEdit

    function submitFormLista(tipo) {
        var $form = $("#frmSave");
        var $btn = $("#dlgCreateEditLT").find("#btnSave");
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
                    if(parts[0] === 'OK'){
                        log("Guardado correctamente", "success");
                        cargarTablaListas();
                    }else{
                        bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                        return false;
                    }
                }
            });
        } else {
            return false;
        }
    }

    cargarTablaListas();

    function cargarTablaListas(){
        var d = cargarLoader("Cargando...");
        var tipo = $("#tipoLista option:selected").val();
        $.ajax({
            type    : "POST",
            url: "${createLink(controller: 'mantenimientoItems',  action:'tablaListas_ajax')}",
            data    : {
                tipo: tipo
            },
            success : function (msg) {
                d.modal("hide");
                $("#divTablaListas").html(msg)
            } //success
        }); //ajax
    }

</script>