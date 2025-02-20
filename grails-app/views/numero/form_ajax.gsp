
<%@ page import="janus.EstadoObra" %>

<div id="create-estadoObraInstance" class="span" role="main">
<g:form class="form-horizontal" name="frmNumero" action="saveNumero_ajax">
    <g:hiddenField name="id" value="${numero?.id}"/>

    <div class="form-group ${hasErrors(bean: numero, field: 'valor', 'error')} ">
        <span class="grupo">
            <label for="valor" class="col-md-2 control-label text-info">
                Número
            </label>
            <span class="col-md-6">
                <g:textField name="valor" class="form-control allCaps required" value="${numero?.valor}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
</g:form>

<script type="text/javascript">

    function validarNum(ev) {
        /*
         48-57      -> numeros
         96-105     -> teclado numerico
         188        -> , (coma)
         190        -> . (punto) teclado
         110        -> . (punto) teclado numerico
         8          -> backspace
         46         -> delete
         9          -> tab
         37         -> flecha izq
         39         -> flecha der
         */
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
            (ev.keyCode >= 96 && ev.keyCode <= 105) ||
            ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
            ev.keyCode === 37 || ev.keyCode === 39);
    }

    $("#valor").keydown(function (ev) {
        return validarNum(ev);
    });

    $("#frmNumero").validate({
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
            submitFormNumero();
            return false;
        }
        return true;
    });
</script>
