<div class="row alert alert-info">
    <div class="col-md-12 breadcrumb" style="font-size: 18px; text-align: center; font-weight: bold">
        Asignación
    </div>
    <div class="col-md-12" >
        <div class="col-md-1">
            <label style="font-size: 18px; text-align: center; font-weight: bold">
                Asignación
            </label>
        </div>
        <div class="col-md-6">
            <g:select name="asignacion" from="${asignaciones}" value="" optionValue="${{it.prespuesto.proyecto + " - " + it.prespuesto.programa}}" optionKey="id" class="form-control" />
        </div>
        <div class="col-md-1">
            <label style="font-size: 18px; text-align: center; font-weight: bold">
                Valor
            </label>
        </div>
        <div class="col-md-2" id="divValorAsignacion">
        </div>
        <div class="col-md-2" style="margin-top: 2px; float: right">
            <a href="#" class="btn btn-success btnNuevaAsignacion"><i class="fa fa-file"></i> Nueva Asignación</a>
        </div>
    </div>
</div>

<script type="text/javascript">


    cargarPAC($("#asignacion option:selected").val());


    $("#asignacion").change(function () {
        cargarValorAsignacion();
    });

    cargarValorAsignacion();

    function cargarValorAsignacion() {
        var asignacion = $("#asignacion option:selected").val();
        var partida = '${partida?.id}';
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'asignacion', action:'valor_ajax')}",
            data: {
                id: asignacion
            },
            success: function (msg) {
                $("#divValorAsignacion").html(msg);
                cargarPAC($("#asignacion option:selected").val());
            }
        });
    }

    function createEditAsignacion(id, partida) {
        var title = id ? "Editar " : "Crear ";
        var data = id ? {id : id} : {};
        data.partida = partida;
        $.ajax({
            type    : "POST",
            url: "${createLink(controller: 'asignacion', action:'formNuevaAsignacion_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEditAsignacion",
                    title   : title + " Asignación",
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
                                return submitFormAsignacion();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    } //createEdit

    function submitFormAsignacion() {
        var partida = '${partida?.id}';
        var $form = $("#frmAsignacion");
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
                        cargarAsignaciones(partida);
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

    $(".btnNuevaAsignacion").click(function () {
        createEditAsignacion(null, '${partida?.id}');
    });



</script>