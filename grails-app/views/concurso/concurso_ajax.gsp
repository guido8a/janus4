<g:if test="${pac}">
    <div class="row alert alert-info">
        <div class="col-md-12 breadcrumb" style="font-size: 18px; text-align: center; font-weight: bold">
            Concurso
        </div>
        <div class="col-md-12" >
            <div style="margin-bottom: 10px; height: 300px">
                <div class="row" style="margin-bottom: 5px;">
                    <div class="col-md-9 btn-group" role="navigation">
                        <g:if test="${pac}">
                            <g:if test="${concurso?.estado != 'R'}">
                                <a href="#" class="btn btn-success" id="btnSaveConcurso">
                                    <i class="fa fa-save"></i> Guardar
                                </a>
                            </g:if>

                            <g:if test="${concurso?.id}">
                                <a href="#" class="btn btn-info" id="btnCambiarEstado"><i class="fa fa-check"></i> Cambiar Estado</a>
                            </g:if>
                        </g:if>
                    </div>
                </div>

                <g:form class="form-horizontal" name="frmConcurso" action="saveConcurso_ajax">
                    <g:hiddenField name="pac" value="${pac?.id}"/>
                    <g:hiddenField name="administracion" value="${administracion?.id}"/>
                    <g:hiddenField name="id" value="${concurso?.id}"/>
                    <div class="form-group">
                        <span class="grupo">
                            <label for="objeto" class="col-md-1 control-label text-info">
                                Prefecto
                            </label>
                            <span class="col-md-6">
                                <g:hiddenField name="administracion.id" value="${concurso?.administracion?.id}"/>
                                <g:textField name="administracionName" class="form-control" value="${concurso?.administracion?.nombrePrefecto ?: administracion?.nombrePrefecto}" readonly=""/>
                                <p class="help-block ui-helper-hidden"></p>
                            </span>
                        </span>
                        <span class="grupo">
                            <label for="objeto" class="col-md-1 control-label text-info">
                                Estado
                            </label>
                            <span class="col-md-2">
                                <g:hiddenField name="estado" value="${concurso?.estado ?: null}"/>
                                <g:textField name="estadoName" class="form-control" value="${concurso?.estado == 'R' ? 'REGISTRADO' : 'NO REGISTRADO'}" readonly=""/>
                                <p class="help-block ui-helper-hidden"></p>
                            </span>
                        </span>
                    </div>

                    <div class="form-group ${hasErrors(bean: concurso, field: 'objeto', 'error')} ">
                        <span class="grupo">
                            <label for="objeto" class="col-md-1 control-label text-info">
                                Objeto
                            </label>
                            <span class="col-md-10">
                                <g:textArea name="objeto" maxlength="250" class="form-control required" value="${concurso?.objeto}" style="resize: none"/>
                                <p class="help-block ui-helper-hidden"></p>
                            </span>
                        </span>
                    </div>

                    <div class="form-group ${hasErrors(bean: concurso, field: 'numeroCertificacion', 'error')} ">
                        <span class="grupo">
                            <label for="objeto" class="col-md-1 control-label text-info">
                                Número de certificación
                            </label>
                            <span class="col-md-2">
                                <g:textField name="numeroCertificacion" maxlength="4" class="form-control" value="${concurso?.numeroCertificacion ?: 0000}" />
                                <p class="help-block ui-helper-hidden"></p>
                            </span>
                            <label for="objeto" class="col-md-2 control-label text-info">
                                Memo certificación fondos
                            </label>
                            <span class="col-md-2">
                                <g:textField name="memoCertificacionFondos" minlength="1" maxlength="40" class="form-control allCaps" value="${concurso?.memoCertificacionFondos}" />
                                <p class="help-block ui-helper-hidden"></p>
                            </span>
                            <label for="objeto" class="col-md-1 control-label text-info">
                                Memo SIF
                            </label>
                            <span class="col-md-2">
                                <g:textField name="memoSif" maxlength="120" class="form-control allCaps" value="${concurso?.memoSif}" />
                                <p class="help-block ui-helper-hidden"></p>
                            </span>
                        </span>
                    </div>

                    <div class="form-group ${hasErrors(bean: concurso, field: 'numeroCertificacion', 'error')} ">
                        <span class="grupo">
                            <label for="objeto" class="col-md-1 control-label text-info">
                                Código
                            </label>
                            <span class="col-md-2">
                                <g:textField name="codigo" maxlength="40" class="form-control allCaps required" value="${concurso?.codigo}" />
                                <p class="help-block ui-helper-hidden"></p>
                            </span>
                            <label for="objeto" class="col-md-2 control-label text-info">
                                Memo de requerimiento
                            </label>
                            <span class="col-md-2">
                                <g:textField name="memoRequerimiento" maxlength="40" class="form-control allCaps" value="${concurso?.memoRequerimiento}" />
                                <p class="help-block ui-helper-hidden"></p>
                            </span>
                            <label for="objeto" class="col-md-1 control-label text-info">
                                Obra requerida
                            </label>
                            <span class="col-md-2">
                                <g:hiddenField name="obra" value="${concurso?.obra?.id}" />
                                <g:textField name="obraName" class="form-control" value="${concurso?.obra?.codigo}" title="${concurso?.obra?.descripcion}" readonly="" />
                                <p class="help-block ui-helper-hidden"></p>
                            </span>
                            <span class="col-md-1">
                                <a href="#" class="btn btn-info" id="btnBuscarObra" title="Buscar Obra"><i class="fa fa-search"></i></a>
                            </span>
                        </span>
                    </div>

                    <div class="form-group ${hasErrors(bean: concurso, field: 'numeroCertificacion', 'error')} ">
                        <span class="grupo">
                            <label for="presupuestoReferencial" class="col-md-1 control-label text-info">
                                Presupuesto Referencial
                            </label>
                            <span class="col-md-2">
                                <g:textField name="presupuestoReferencial" class="form-control required" value="${concurso?.presupuestoReferencial}" />
                                <p class="help-block ui-helper-hidden"></p>
                            </span>
                            <label for="objeto" class="col-md-2 control-label text-info">
                                Costo base x 1000
                            </label>
                            <span class="col-md-2">
                                <g:textField name="porMilBases"  class="form-control" value="${concurso?.porMilBases}" />
                                <p class="help-block ui-helper-hidden"></p>
                            </span>
                            <label for="objeto" class="col-md-1 control-label text-info">
                                Costo base
                            </label>
                            <span class="col-md-2">
                                <g:textField name="costoBases"  class="form-control" value="${concurso?.costoBases}" />
                                <p class="help-block ui-helper-hidden"></p>
                            </span>
                        </span>
                    </div>

                    <div class="form-group ${hasErrors(bean: concurso, field: 'observaciones', 'error')} ">
                        <span class="grupo">
                            <label for="objeto" class="col-md-1 control-label text-info">
                                Observaciones
                            </label>
                            <span class="col-md-10">
                                <g:textArea name="observaciones" maxlength="127" class="form-control" value="${concurso?.observaciones}" style="resize: none"/>
                                <p class="help-block ui-helper-hidden"></p>
                            </span>
                        </span>
                    </div>

                </g:form>

            </div>

        </div>
    </div>
</g:if>

<script type="text/javascript">

    var bcob;


    $("#btnBuscarObra").click(function () {
        $.ajax({
            type    : "POST",
            url: "${createLink(controller: 'concurso', action:'buscadorObras_ajax')}",
            data    : {},
            success : function (msg) {
                bcob = bootbox.dialog({
                    id      : "dlgBuscarobra",
                    title   : "Buscar Obra",
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

    function cerrarBuscadorObras(){
        bcob.modal("hide");
    }

    <g:if test="${concurso?.id}">

    cargarFechasConcurso('${concurso?.id}');
    cargarOferta('${concurso?.id}');

    </g:if>
    <g:else>
    $("#divFechas").html('');
    $("#divOferta").html('');
    </g:else>

    function cargarFechasConcurso(concurso){
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'concurso', action:'fechas_ajax')}",
            data: {
                concurso: concurso
            },
            success: function (msg) {
                $("#divFechas").html(msg);
            }
        });
    }

    $("#btnSaveConcurso").click(function () {
       return submitFormConcurso();
    });

    function submitFormConcurso() {
        var $form = $("#frmConcurso");
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
                        cargarConcurso('${pac?.id}');
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

    $("#btnCambiarEstado").click(function () {
        bootbox.confirm({
            title: "Cambiar estado del concurso",
            message: '<i class="fa fa-retweet text-info fa-3x"></i>' + '<strong style="font-size: 14px">' + "Está seguro de querer cambiar el estado del concurso?. " + '</strong>' ,
            buttons: {
                cancel: {
                    label: '<i class="fa fa-times"></i> Cancelar',
                    className: 'btn-primary'
                },
                confirm: {
                    label: '<i class="fa fa-retweet"></i> Cambiar',
                    className: 'btn-success'
                }
            },
            callback: function (result) {
                if(result){
                    $("#estado").val() === 'R' ? $("#estado").val('N') : $("#estado").val('R');
                    return submitFormConcurso();
                }
            }
        });
    });


</script>