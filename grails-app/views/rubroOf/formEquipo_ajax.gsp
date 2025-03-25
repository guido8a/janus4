
<div id="create" class="span" role="main">
    <g:form class="form-horizontal" name="frmSave" action="save_ajax">
        <g:hiddenField name="id" value="${detalle?.id}"/>

        <div class="breadcrumb">
            ${detalle?.nombre ?: ''}
        </div>

        <div class="form-group keeptogether">
            <div class="col-md-12">
                <span class="grupo">
                    <label for="cantidad" class="col-md-1 control-label">
                        Cantidad
                    </label>
                    <span  class="col-md-2">
                        <g:textField name="cantidad" class="required form-control" value="${detalle?.cantidad ?: 0}"/>
                        <p class="help-block ui-helper-hidden"></p>
                    </span>
                    <label for="precio" class="col-md-1 control-label">
                        ${detalle?.tipo == 'EQ' ? 'Tarifa' : 'Jornal'}
                    </label>
                    <span  class="col-md-2">
                        <g:textField name="precio" class="required form-control" value="${detalle?.precio}"/>
                        <p class="help-block ui-helper-hidden"></p>
                    </span>
                    <label for="rendimiento" class="col-md-1 control-label">
                        Rendimiento
                    </label>
                    <span  class="col-md-2">
                        <g:textField name="rendimiento" class="required form-control" value="${detalle?.rendimiento}"/>
                        <p class="help-block ui-helper-hidden"></p>
                    </span>
                    <label for="subtotal" class="col-md-1 control-label">
                        C.Total
                    </label>
                    <span  class="col-md-2">
                        <g:textField name="subtotal" class="required form-control" value="${detalle?.subtotal ?: 0}"/>
                        <p class="help-block ui-helper-hidden"></p>
                    </span>
                </span>
            </div>
        </div>

    </g:form>
</div>

<script type="text/javascript">

    $("#precio, #cantidad, #rendimiento").keyup(function () {
        calcularSubtotal();
    });

    function calcularSubtotal(){
        var precio = $("#precio").val();
        var cantidad = $("#cantidad").val();
        var rendimiento = $("#rendimiento").val();

         // var subtotal = Math.round(((precio * cantidad) * rendimiento) * 100) / 100;
        var subtotal = (precio * cantidad) * ((rendimiento !== 0 || rendimiento !== 0.0) ? rendimiento : 1);

        $("#subtotal").val(subtotal);

    }

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

    $("#rendimiento, #precio, #cantidad, #subtotal").keydown(function (ev) {
        return validarNum(ev);
    });

    $("#frmSave").validate({
        errorClass    : "help-block",
        errorPlacement: function (error, element) {
            if (element.parent().hasClass("input-group")) {
                error.insertAfter(element.parent());
            } else {
                error.insertAfter(element);
            }
            element.parents(".grupo").addClass('has-error');
        },
        success       : function (label) {
            label.parents(".grupo").removeClass('has-error');
            label.remove();
        }
    });
</script>
