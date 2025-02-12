<%@ page import="janus.cnsl.Costo" %>

<div class="modal-contenido">
    <g:form class="form-horizontal" name="frmPrecio" role="form" action="savePrecio_ajax" method="POST">
        <g:hiddenField name="id" value="${precioCosto?.id}"/>
        <g:hiddenField name="costo" value="${costo?.id}"/>

        <div class="form-group keeptogether ${hasErrors(bean: precioCosto, field: 'precioUnitario', 'error')} ">
            <span class="grupo">
                <label for="precioUnitario" class="col-md-3 control-label">
                    Precio
                </label>

                <span class="col-md-8">
                    <g:textField name="precioUnitario" maxlength="15" class="form-control input-sm required" value="${precioCosto?.precioUnitario}"/>
                </span>
            </span>
        </div>

        <div class="form-group keeptogether ${hasErrors(bean: precioCosto, field: 'precioUnitario', 'error')} ">
            <span class="grupo">
                <label for="porcentaje" class="col-md-3 control-label">
                    Porcentaje
                </label>

                <span class="col-md-8">
                    <g:textField name="porcentaje" maxlength="15" class="form-control input-sm required"
                                 value="${precioCosto?.porcentaje}"/>
                </span>
            </span>
        </div>

        <div class="form-group keeptogether ${hasErrors(bean: precioCosto, field: 'fecha', 'error')} ">
            <span class="grupo">
                <label for="precioUnitario" class="col-md-3 control-label">
                    Fecha
                </label>

                <span class="col-md-8">
                    <input aria-label="" name="fecha" id='datetimepicker1' type='text' class="form-control required"
                           value="${precioCosto?.fecha?.format("dd-MM-yyyy") ?: new Date().format("dd-MM-yyyy")}"/>
                </span>
            </span>
        </div>

    </g:form>
</div>

<script type="text/javascript">

    $('#datetimepicker1').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        icons: {
        }
    });

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
            ev.keyCode === 190 || ev.keyCode === 110 ||
            ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
            ev.keyCode === 37 || ev.keyCode === 39);
    }


    $("#precioUnitario").keydown(function (ev) {
        return validarNum(ev);
    });

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
