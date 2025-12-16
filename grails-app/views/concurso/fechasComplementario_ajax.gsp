<div class="row alert alert-success">
    <div class="col-md-12 breadcrumb" style="font-size: 18px; text-align: center; font-weight: bold">
        Fechas del Concurso complementario
    </div>

    <div class="col-md-12" >
        <div style="margin-bottom: 10px; height: 150px">

            <div class="row" style="margin-bottom: 5px;">
                <div class="col-md-9 btn-group" role="navigation">
                    <g:if test="${concurso?.estado != 'R'}">
                        <a href="#" class="btn btn-success" id="btnSaveFechasConcursoComplementario">
                            <i class="fa fa-save"></i> Guardar
                        </a>
                    </g:if>
                </div>
            </div>

            <g:form class="form-horizontal" name="frmFechasConcursoComplementario" action="saveConcurso_ajax">
                <g:hiddenField name="id" value="${concurso?.id}"/>
                <div class="form-group">
                    <span class="grupo">
                        <label class="col-md-1 control-label text-info">
                            Publicación
                        </label>
                        <span class="col-md-2">
                            <input aria-label="" name="fechaPublicacion" id='fecha1' type='text' class="input-small" value="${concurso?.fechaPublicacion?.format("dd-MM-yyyy HH:mm")}" />
                            <p class="help-block ui-helper-hidden"></p>
                        </span>
                    </span>
                    <span class="grupo">
                        <label class="col-md-2 control-label text-info">
                            Inicio Evaluación Oferta
                        </label>
                        <span class="col-md-2">
                            <input aria-label="" name="fechaInicioEvaluacionOferta" id='fecha2' type='text' class="input-small" value="${concurso?.fechaInicioEvaluacionOferta?.format("dd-MM-yyyy HH:mm")}" />
                            <p class="help-block ui-helper-hidden"></p>
                        </span>
                    </span>
                    <span class="grupo">
                        <label class="col-md-2 control-label text-info">
                            Aceptación proveedor
                        </label>
                        <span class="col-md-2">
                            <input aria-label="" name="fechaAceptacionProveedor" id='fecha3' type='text' class="input-small" value="${concurso?.fechaAceptacionProveedor?.format("dd-MM-yyyy HH:mm")}" />
                            <p class="help-block ui-helper-hidden"></p>
                        </span>
                    </span>
                </div>
                <div class="form-group">
                    <span class="grupo">
                        <label class="col-md-1 control-label text-info">
                            Adjudicación
                        </label>
                        <span class="col-md-2">
                            <input aria-label="" name="fechaAdjudicacion" id='fecha6' type='text' class="input-small" value="${concurso?.fechaAdjudicacion?.format("dd-MM-yyyy HH:mm")}" />
                            <p class="help-block ui-helper-hidden"></p>
                        </span>
                    </span>
                    <span class="grupo">
                        <label class="col-md-2 control-label text-info">
                            Límite resultados finales
                        </label>
                        <span class="col-md-2">
                            <input aria-label="" name="fechaLimiteResultadosFinales" id='fecha4' type='text' class="input-small" value="${concurso?.fechaLimiteResultadosFinales?.format("dd-MM-yyyy HH:mm")}" />
                            <p class="help-block ui-helper-hidden"></p>
                        </span>
                    </span>
                    <span class="grupo">
                        <label class="col-md-2 control-label text-info">
                            Límite Preguntas
                        </label>
                        <span class="col-md-2">
                            <input aria-label="" name="fechaLimitePreguntas" id='fecha5' type='text' class="input-small" value="${concurso?.fechaLimitePreguntas?.format("dd-MM-yyyy HH:mm")}" />
                            <p class="help-block ui-helper-hidden"></p>
                        </span>
                    </span>
                </div>
                <div class="form-group">
                    <span class="grupo">
                        <label class="col-md-1 control-label text-info">
                            Inicio
                        </label>
                        <span class="col-md-2">
                            <input aria-label="" name="fechaInicio" id='fecha8' type='text' class="input-small" value="${concurso?.fechaInicio?.format("dd-MM-yyyy HH:mm")}" />
                            <p class="help-block ui-helper-hidden"></p>
                        </span>
                    </span>
                    <span class="grupo">
                        <label class="col-md-2 control-label text-info">
                            Límite Respuestas
                        </label>
                        <span class="col-md-2">
                            <input aria-label="" name="fechaLimiteRespuestas" id='fecha7' type='text' class="input-small" value="${concurso?.fechaLimiteRespuestas?.format("dd-MM-yyyy HH:mm")}" />
                            <p class="help-block ui-helper-hidden"></p>
                        </span>
                    </span>
                    <label class="col-md-2 control-label text-info">
                        Notificación adjudicación
                    </label>
                    <span class="col-md-2">
                        <input aria-label="" name="fechaNotificacionAdjudicacion" id='fecha16' type='text' class="input-small" value="${concurso?.fechaNotificacionAdjudicacion?.format("dd-MM-yyyy HH:mm")}" />
                        <p class="help-block ui-helper-hidden"></p>
                    </span>
                </div>
                <div class="form-group">
                    <span class="grupo">
                        <label class="col-md-1 control-label text-info">
                            Calificación
                        </label>
                        <span class="col-md-2">
                            <input aria-label="" name="fechaCalificacion" id='fecha10' type='text' class="input-small" value="${concurso?.fechaCalificacion?.format("dd-MM-yyyy HH:mm")}" />
                            <p class="help-block ui-helper-hidden"></p>
                        </span>
                    </span>
                    <span class="grupo">
                        <label class="col-md-2 control-label text-info">
                            Apertura Ofertas
                        </label>
                        <span class="col-md-2">
                            <input aria-label="" name="fechaAperturaOfertas" id='fecha11' type='text' class="input-small" value="${concurso?.fechaAperturaOfertas?.format("dd-MM-yyyy HH:mm")}" />
                            <p class="help-block ui-helper-hidden"></p>
                        </span>
                    </span>
                    <span class="grupo">
                        <label class="col-md-2 control-label text-info">
                            Inicio Puja
                        </label>
                        <span class="col-md-2">
                            <input aria-label="" name="fechaInicioPuja" id='fecha12' type='text' class="input-small" value="${concurso?.fechaInicioPuja?.format("dd-MM-yyyy HH:mm")}" />
                            <p class="help-block ui-helper-hidden"></p>
                        </span>
                    </span>
                </div>
                <div class="form-group">
                    <span class="grupo">
                        <label class="col-md-1 control-label text-info">
                            Fin Puja
                        </label>
                        <span class="col-md-2">
                            <input aria-label="" name="fechaFinPuja" id='fecha14' type='text' class="input-small" value="${concurso?.fechaFinPuja?.format("dd-MM-yyyy HH:mm")}" />
                            <p class="help-block ui-helper-hidden"></p>
                        </span>
                    </span>
                    <span class="grupo">
                        <label class="col-md-2 control-label text-info">
                            Solicitar Convalidación
                        </label>
                        <span class="col-md-2">
                            <input aria-label="" name="fechaLimiteSolicitarConvalidacion" id='fecha13' type='text' class="input-small" value="${concurso?.fechaLimiteSolicitarConvalidacion?.format("dd-MM-yyyy HH:mm")}" />
                            <p class="help-block ui-helper-hidden"></p>
                        </span>
                    </span>
                    <span class="grupo">
                        <label class="col-md-2 control-label text-info">
                            Recibir Convalidación
                        </label>
                        <span class="col-md-2">
                            <input aria-label="" name="fechaLimiteRespuestaConvalidacion" id='fecha15' type='text' class="input-small" value="${concurso?.fechaLimiteRespuestaConvalidacion?.format("dd-MM-yyyy HH:mm")}" />
                            <p class="help-block ui-helper-hidden"></p>
                        </span>
                    </span>
                </div>
                <div class="form-group">
                    <span class="grupo">
                        <span class="grupo">
                            <label class="col-md-1 control-label text-info">
                                Límite Entrega Ofertas
                            </label>
                            <span class="col-md-2">
                                <input aria-label="" name="fechaLimiteEntregaOfertas" id='fecha9' type='text' class="input-small required" required="" value="${concurso?.fechaLimiteEntregaOfertas?.format("dd-MM-yyyy HH:mm")}" />
                                <p class="help-block ui-helper-hidden"></p>
                            </span>
                            <span class="col-md-4" style="margin-left: -40px">
                                <label class="text-danger"> <i class="fa fa-arrow-circle-left fa-2x text-danger"></i> <strong style="font-size: 14px"> Necesario para migrar de obras a oferentes </strong></label>
                            </span>
                        </span>
                    </span>
                </div>
            </g:form>
        </div>
    </div>
</div>

<script type="text/javascript">

    $('#fecha1, #fecha2, #fecha3, #fecha4, #fecha5, #fecha6, #fecha7, #fecha8, #fecha9, #fecha10, #fecha11, #fecha12, #fecha13, #fecha14, #fecha15, #fecha16, #fecha17, #fecha18, #fecha19, #fecha20, #fecha21, #fecha22').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY HH:mm',
        // minDate: moment({hour: 9, minute: 30}),
        sideBySide: true,
        icons: {
        }
    });

    $("#btnSaveFechasConcursoComplementario").click(function () {
        return submitFormFechasConcursoComplementario();
    });

    function submitFormFechasConcursoComplementario() {
        var $form = $("#frmFechasConcursoComplementario");
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
                        cargarConcursoComplentario('${concurso?.pac?.id}');
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

</script>