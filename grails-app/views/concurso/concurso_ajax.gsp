<div class="row alert alert-info">
    <div class="col-md-12 breadcrumb" style="font-size: 18px; text-align: center; font-weight: bold">
        Concurso
    </div>

    <div class="col-md-12" >
        <div style="margin-bottom: 10px; height: 300px">

            <div class="row" style="margin-bottom: 5px;">
                <div class="col-md-9 btn-group" role="navigation">
                    <g:if test="${concurso.estado != 'R'}">
                        <a href="#" class="btn btn-success" id="btnSave">
                            <i class="fa fa-save"></i> Guardar
                        </a>
                    </g:if>
                    <g:if test="${concurso}">
                        <a href="#" class="btn btn-info" id="btnEstado"><i class="fa fa-check"></i> Cambiar Estado</a>
                    </g:if>
                </div>
            </div>

            <g:form class="form-horizontal" name="frmConcurso" action="saveConcurso_ajax">
                <g:hiddenField name="id" value="${concurso?.id}"/>
                <div class="form-group">
                    <span class="grupo">
                        <label for="objeto" class="col-md-1 control-label text-info">
                            Prefecto
                        </label>
                        <span class="col-md-6">
                            <g:hiddenField name="administracion.id" value="${concurso?.administracion?.id}"/>
                            <g:textField name="administracionName" class="form-control" value="${concurso?.administracion?.nombrePrefecto}" readonly=""/>
                            <p class="help-block ui-helper-hidden"></p>
                        </span>
                    </span>
                    <span class="grupo">
                        <label for="objeto" class="col-md-1 control-label text-info">
                            Estado
                        </label>
                        <span class="col-md-2">
                            <g:textField name="estado" class="form-control" value="${concurso?.estado == 'R' ? 'REGISTRADO' : 'NO REGISTRADO'}" readonly=""/>
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
                            <g:textField name="memoCertificacionFondos" minlength="1" maxlength="20" class="form-control" value="${concurso?.memoCertificacionFondos}" />
                            <p class="help-block ui-helper-hidden"></p>
                        </span>
                        <label for="objeto" class="col-md-1 control-label text-info">
                            Memo SIF
                        </label>
                        <span class="col-md-2">
                            <g:textField name="memoSif" maxlength="120" class="form-control" value="${concurso?.memoSif}" />
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
                            <g:textField name="codigo" maxlength="4" class="form-control required" value="${concurso?.codigo}" />
                            <p class="help-block ui-helper-hidden"></p>
                        </span>
                        <label for="objeto" class="col-md-2 control-label text-info">
                            Memo de requerimiento
                        </label>
                        <span class="col-md-2">
                            <g:textField name="memoRequerimiento" minlength="1" maxlength="20" class="form-control" value="${concurso?.memoRequerimiento}" />
                            <p class="help-block ui-helper-hidden"></p>
                        </span>
                        <label for="objeto" class="col-md-1 control-label text-info">
                            Obra requerida
                        </label>
                        <span class="col-md-2">
                            <g:hiddenField name="obra" value="${concurso?.obra?.id}" />
                            <g:textField name="obraName" class="form-control" value="${concurso?.obra?.codigo}" />
                            <p class="help-block ui-helper-hidden"></p>
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

        <div id="divDatosConcurso">

        </div>
    </div>
</div>

<script type="text/javascript">

    %{--$("#pac").change(function () {--}%
    %{--    cargarDatosPAC();--}%
    %{--});--}%

    %{--cargarDatosPAC();--}%

    %{--function cargarDatosPAC() {--}%
    %{--    var pac = $("#pac option:selected").val();--}%
    %{--    $.ajax({--}%
    %{--        type: "POST",--}%
    %{--        url: "${createLink(controller: 'pac', action:'tablaDatosPAC_ajax')}",--}%
    %{--        data: {--}%
    %{--            id: pac--}%
    %{--        },--}%
    %{--        success: function (msg) {--}%
    %{--            $("#divTablaPAC").html(msg);--}%
    %{--        }--}%
    %{--    });--}%
    %{--}--}%

</script>