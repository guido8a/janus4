<%@ page import="janus.cnsl.Costo" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!costoInstance}">
    <elm:notFound elem="Costo" genero="o"/>
</g:if>
<g:else>

    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmCosto" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${costoInstance?.id}"/>
            <g:hiddenField name="padre.id" value="${costoInstance?.padreId}"/>
            <g:hiddenField name="nivel" value="${costoInstance?.nivel}"/>

            <div class="form-group keeptogether ${hasErrors(bean: costoInstance, field: 'nivel', 'error')} required">
                <span class="grupo">
                    <label for="nivel" class="col-md-2 control-label">
                        Nivel
                    </label>

                    <div class="col-md-2">
                        <p class="form-control-static">
                            ${costoInstance?.nivel}
                        </p>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: costoInstance, field: 'numero', 'error')} ">
                <span class="grupo">
                    <label for="numero" class="col-md-2 control-label">
                        Número
                    </label>

                    <div class="col-md-6">
                        <g:if test="${costoInstance.id}">
                            <p class="form-control-static">
                                ${costoInstance?.numero}
                            </p>
                        </g:if>
                        <g:else>
                            <g:textField name="numero" maxlength="15" class="form-control input-sm" value="${costoInstance?.numero}"/>
                        </g:else>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: costoInstance, field: 'descripcion', 'error')} ">
                <span class="grupo">
                    <label for="descripcion" class="col-md-2 control-label">
                        Descripción
                    </label>

                    <div class="col-md-10">
                        <g:textArea name="descripcion" cols="40" rows="5" maxlength="255" class="form-control input-sm"
                                    value="${costoInstance?.descripcion}"/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: costoInstance, field: 'movimiento', 'error')} required">
                <span class="grupo">
                    <label for="movimiento" class="col-md-4 control-label">
                        Acepta valor de presupuesto
                    </label>

                    <div class="col-md-2">
                        <g:select name="movimiento" from="[1: 'Sí', 0: 'No']" optionKey="key" optionValue="value"
                                  class="form-control input-sm" value="${costoInstance?.movimiento}"/>
                        %{--<g:field name="movimiento" type="number" value="${costoInstance.movimiento}" class="digits form-control required" required=""/>--}%
                    </div>

                    <label for="movimiento" class="col-md-3 control-label">
                        Estado
                    </label>

                    <div class="col-md-3">
                        <g:select name="estado" from="[A: 'Activo', B: 'Dado de baja']" optionKey="key" optionValue="value"
                                  class="form-control input-sm" value="${costoInstance?.estado}"/>
                        %{--<g:field name="movimiento" type="number" value="${costoInstance.movimiento}" class="digits form-control required" required=""/>--}%
                    </div>
                </span>
            </div>

        </g:form>
    </div>

    <script type="text/javascript">
        var validator = $("#frmCosto").validate({
            errorClass     : "help-block",
            errorPlacement : function (error, element) {
                if (element.parent().hasClass("input-group")) {
                    error.insertAfter(element.parent());
                } else {
                    error.insertAfter(element);
                }
                element.parents(".grupo").addClass('has-error');
            },
            success        : function (label) {
                label.parents(".grupo").removeClass('has-error');
                label.remove();
            }

        });
        $(".form-control").keydown(function (ev) {
            if (ev.keyCode == 13) {
                submitFormCosto();
                return false;
            }
            return true;
        });
    </script>

</g:else>