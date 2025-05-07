<div class="row alert alert-info">
    <div class="col-md-12 breadcrumb" style="font-size: 18px; text-align: center; font-weight: bold">
        Partida
    </div>
    <div class="col-md-12" >
        <div class="col-md-1">
            <label style="font-size: 18px; text-align: center; font-weight: bold">
                Año
            </label>
        </div>
        <div class="col-md-2">
            <g:textField name="anioPartida" value="${partida?.anio?.anio}" class="form-control" readonly=""/>
        </div>
        <div class="col-md-1">
            <label style="font-size: 18px; text-align: center; font-weight: bold">
                Código
            </label>
        </div>
        <div class="col-md-5">
            <g:hiddenField name="partida" value=""/>
            <g:textField name="codigoPartida" value="${partida?.numero}" class="form-control" readonly=""/>
        </div>
    </div>
    <div class="col-md-12" >
        <div class="col-md-1">
            <label style="font-size: 18px; text-align: center; font-weight: bold">
                Partida
            </label>
        </div>
        <div class="col-md-8">
            <g:textArea name="nombrePartida" value="${partida?.descripcion}" class="form-control" style="resize: none" readonly="" />
        </div>
        <div class="col-md-3" style="margin-top: 2px; float: right">
            <a href="#" class="btn btn-info btnBuscarPartida"><i class="fa fa-search"></i> Buscar</a>
            <a href="#" class="btn btn-success btnNuevaPartida"><i class="fa fa-file"></i> Nueva Partida</a>
        </div>
    </div>
</div>

<script type="text/javascript">

    var bcptd;

    $(".btnBuscarPartida").click(function () {
        $.ajax({
            type    : "POST",
            url: "${createLink(controller: 'presupuesto', action:'buscadorPartida_ajax')}",
            data    : {},
            success : function (msg) {
                bcptd = bootbox.dialog({
                    id      : "dlgBuscarpartida",
                    title   : "Buscar Partida",
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
            } //success
        }); //ajax
    });

    function cerrarBuscadorPartida() {
        bcptd.modal("hide");
    }

    function createEditPresupuesto(id) {
        var title = id ? "Editar " : "Crear ";
        var data = id ? {id : id} : {};

        $.ajax({
            type    : "POST",
            url: "${createLink(controller: 'presupuesto', action:'form_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEditPartida",
                    title   : title + " Partida",
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
                                return submitFormPresupuesto();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    } //createEdit

    function submitFormPresupuesto() {
        var $form = $("#frmPartida");
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
                    }else{
                        if(parts[0] === 'err'){
                            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                            return false;
                        }else{
                            log(parts[1], "error");
                        }
                    }
                }
            });
        } else {
            return false;
        }
    }

    $(".btnNuevaPartida").click(function () {
        createEditPresupuesto();
    })

</script>

