<%@ page import="janus.cnsl.Costo" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!costoInstance}">
    <elm:notFound elem="Costo" genero="o"/>
</g:if>
<g:else>

    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmPrecio" role="form" action="savePrecio_ajax" method="POST">
            <g:hiddenField name="id" value="${costoInstance?.id}"/>

            <div class="form-group keeptogether ${hasErrors(bean: costoInstance, field: 'numero', 'error')} ">
                <span class="grupo">
                    <label for="precioUnitario" class="col-md-2 control-label">
                        Precio
                    </label>

                    <div class="col-md-6">
                         <g:textField name="precioUnitario" maxlength="15" class="form-control input-sm" value="${costoInstance?.numero}"/>
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