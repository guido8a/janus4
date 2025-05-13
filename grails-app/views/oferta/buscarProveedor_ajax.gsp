<div id="listaRbro" style="overflow: hidden">
    <fieldset class="borde" style="border-radius: 4px">
        <div class="row-fluid" style="margin-left: 10px">
            <div class="col-md-2">
                Buscar Por
                <g:select name="buscarProveedorPor" class="buscarProveedorPor form-control" from="${[2: 'Nombre' , 1: 'RUC']}" style="width: 100%" optionKey="key" optionValue="value"/>
            </div>
            <div class="col-md-5">
                Criterio
                <g:textField name="criterioProveedor" class="criterioProveedor form-control"/>
            </div>
            <div class="col-md-2 btn-group" style="margin-top: 20px">
                <button class="btn btn-info" id="btnBuscadorProveedor"><i class="fa fa-search"></i></button>
                <button class="btn btn-warning" id="btnLimpiarProveedor" title="Limpiar Búsqueda"><i class="fa fa-eraser"></i></button>
            </div>
            <div class="col-md-1 btn-group" style="margin-top: 20px">
                <button class="btn btn-success" id="btnCrearProveedor"><i class="fa fa-file"></i> Nuevo Proveedor</button>
            </div>
        </div>
    </fieldset>

    <fieldset class="borde" style="border-radius: 4px">
        <div id="divTablaProveedores" style="height: 460px; overflow: auto; margin-top: 5px">
        </div>
    </fieldset>
</div>

<script type="text/javascript">

    var fmpo;

    $("#btnCrearProveedor").click(function () {
        createEditProveedores();
    });

    $("#btnLimpiarProveedor").click(function () {
        $("#buscarProveedorPor").val(2);
        $("#criterioProveedor").val('');
        cargarProveedores();
    });

    cargarProveedores();

    $("#btnBuscadorProveedor").click(function () {
        cargarProveedores();
    });

    function cargarProveedores() {
        var buscarPor = $("#buscarProveedorPor option:selected").val();
        var criterio = $("#criterioProveedor").val();
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'oferta', action:'tablaBuscarProveedores_ajax')}",
            data: {
                buscarPor: buscarPor,
                criterio: criterio
            },
            success: function (msg) {
                $("#divTablaOferta").focus();
                $("#divTablaProveedores").html(msg);
            }
        });
    }

    function createEditProveedores(id) {
        var title = id ? "Editar " : "Crear ";
        var data = id ? {id : id}: {};

        $.ajax({
            type    : "POST",
            url: "${createLink(controller: 'proveedor', action:'form_ajax')}",
            data    : data,
            success : function (msg) {
                fmpo = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : title + " Proveedor",
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
                                return submitFormProveedor();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    } //createEdit

    function submitFormProveedor() {
        var $form = $("#frmSave-Proveedor");
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
                        $("#criterioProveedor").val(parts[2]);
                        cargarProveedores();
                        cerrarProveedores();
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

    function cerrarProveedores(){
        fmpo.modal("hide")
    }

    $("#criterioProveedor").keydown(function (ev) {
        if (ev.keyCode === 13) {
            ev.preventDefault();
            cargarProveedores();
            return false;
        }
    })
</script>