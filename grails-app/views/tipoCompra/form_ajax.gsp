
<%@ page import="janus.pac.TipoCompra" %>

<div id="create-TipoCompra" class="span" role="main">
    <g:form class="form-horizontal" name="frmSave-TipoCompra" action="save">
        <g:hiddenField name="id" value="${tipoCompraInstance?.id}"/>

        <div class="form-group ${hasErrors(bean: tipoCompraInstance, field: 'descripcion', 'error')} ">
            <span class="grupo">
                <label for="descripcion" class="col-md-2 control-label text-info">
                    Descripción
                </label>
                <span class="col-md-8">
                    <g:textField name="descripcion" maxlength="63" class="form-control required" value="${tipoCompraInstance?.descripcion}"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>
    </g:form>

<script type="text/javascript">
    $("#frmSave-TipoCompra").validate({
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
        }
    });
    $(".form-control").keydown(function (ev) {
        if (ev.keyCode === 13) {
            submitFormTC();
            return false;
        }
        return true;
    });
</script>
