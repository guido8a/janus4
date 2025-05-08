<g:if test="${asignacion}">
    <div class="row alert alert-info">
        <div class="col-md-12 breadcrumb" style="font-size: 18px; text-align: center; font-weight: bold">
            P.A.C.
        </div>
        <div class="col-md-12" >
            <div class="col-md-1">
                <label style="font-size: 18px; text-align: center; font-weight: bold">
                    P.A.C.
                </label>
            </div>
            <div class="col-md-8">
                <g:select name="pac" from="${pacs}" value="" optionValue="${{it.descripcion + " - " + (it?.c1 ? " C1 " :( it?.c2 ? "C2" : "C3" )) }}" optionKey="id" class="form-control" />
            </div>

            <div class="col-md-2" style="margin-top: 2px; float: right">
                <a href="#" class="btn btn-success btnNuevoPac"><i class="fa fa-file"></i> Nuevo PAC</a>
            </div>

            <div id="divTablaPAC">

            </div>
        </div>
    </div>
</g:if>

<script type="text/javascript">

    cargarConcurso($("#pac option:selected").val());

    $("#pac").change(function () {
        cargarDatosPAC();
    });

    cargarDatosPAC();

    function cargarDatosPAC() {
        var pac = $("#pac option:selected").val();
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'pac', action:'tablaDatosPAC_ajax')}",
            data: {
                id: pac
            },
            success: function (msg) {
                $("#divTablaPAC").html(msg);
            }
        });
    }

    function createEditPac(id, asignacion) {
        var title = id ? "Editar " : "Crear ";
        var data = id ? {id : id} : {};
        data.asignacion = asignacion;

        $.ajax({
            type    : "POST",
            url: "${createLink(controller: 'pac', action:'formNuevoPac_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEditPac",
                    title   : title + " P.A.C.",
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
                                return submitFormPac();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    } //createEdit

    function submitFormPac() {
        var asignacion = '${asignacion?.id}';
        var $form = $("#frmPac");
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
                        cargarPAC(asignacion);
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

    $(".btnNuevoPac").click(function () {
        createEditPac(null, '${asignacion?.id}');
    });



</script>