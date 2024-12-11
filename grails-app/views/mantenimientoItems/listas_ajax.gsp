
<div id="listaRbro" style="overflow: hidden">
    <fieldset class="borde" style="border-radius: 4px">
        <div class="row-fluid" style="margin-left: 10px">
            <span class="grupo">
%{--                <label class="col-md-2 control-label text-info">--}%
%{--                    Buscar Por--}%
%{--                </label>--}%
%{--                <span class="col-md-3">--}%
%{--                    <g:select name="buscarPorT" class="buscarPorT col-md-12 form-control" from="${[1: 'Descripción', 2: 'Código']}" optionKey="key"--}%
%{--                              optionValue="value"/>--}%
%{--                </span>--}%
%{--                <label class="col-md-1 control-label text-info">--}%
%{--                    Criterio--}%
%{--                </label>--}%
%{--                <span class="col-md-4">--}%
%{--                    <g:textField name="buscarCriterioT" id="criterioCriterioT" class="form-control"/>--}%
%{--                </span>--}%
%{--            </span>--}%
%{--            <div class="col-md-1" style="margin-top: 1px">--}%
%{--                <button class="btn btn-info" id="btnBuscarCPCT"><i class="fa fa-search"></i></button>--}%
%{--            </div>--}%
        </div>
    </fieldset>

    <fieldset class="borde" style="border-radius: 4px">
        <div id="divTablaListas" style="height: 460px; overflow: auto; margin-top: 5px">
        </div>
    </fieldset>
</div>


<script type="text/javascript">

    function createEditLista(id, parentId) {
        var title = id ? "Editar" : "Crear";
        var data = id ? {id : id} : {};
        // data.grupo = parentId;
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
        $.ajax({
            type    : "POST",
            url: "${createLink(action:'tablaListas_ajax')}",
            data    : {},
            success : function (msg) {
                $("#divTablaListas").html(msg)
            } //success
        }); //ajax
    }

</script>