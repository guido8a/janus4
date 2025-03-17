
<div id="create" class="span" role="main">
    <g:form class="form-horizontal" name="frmSave" action="save_ajax">
        <g:hiddenField name="id" value="${detalle?.id}"/>

        <div class="breadcrumb">
            ${detalle?.nombre ?: ''}
        </div>

        <div class="form-group keeptogether">
            <div class="col-md-12">
                <span class="grupo">
                    <label for="peso" class="col-md-1 control-label">
                        Peso
                    </label>
                    <span  class="col-md-2">
                        <g:textField name="peso" class="required form-control" value="${g.formatNumber(number: detalle?.peso ?: 0, maxFractionDigits: 5,
                                minFractionDigits: 2, locale: 'ec')}"/>
                        <p class="help-block ui-helper-hidden"></p>
                    </span>
                    <label for="cantidad" class="col-md-1 control-label">
                        Cantidad
                    </label>
                    <span  class="col-md-2">
                        <g:textField name="cantidad" class="required form-control" value="${g.formatNumber(number: detalle?.cantidad ?: 0, maxFractionDigits: 5,
                                minFractionDigits: 2, locale: 'ec')}"/>
                        <p class="help-block ui-helper-hidden"></p>
                    </span>
                    <label for="distancia" class="col-md-1 control-label">
                        Distancia
                    </label>
                    <span  class="col-md-2">
                        <g:textField name="distancia" class="required form-control" value="${detalle?.distancia}"/>
                        <p class="help-block ui-helper-hidden"></p>
                    </span>
                    <label for="subtotal" class="col-md-1 control-label">
                        Unitario
                    </label>
                    <span  class="col-md-2">
                        <g:textField name="precio" class="required form-control" value="${g.formatNumber(number: detalle?.precio ?: 0, maxFractionDigits: 5,
                                minFractionDigits: 2, locale: 'ec')}"/>
                        <p class="help-block ui-helper-hidden"></p>
                    </span>
                </span>
            </div>
            <div class="col-md-12" style="margin-top: 10px">
                <span class="grupo">
                    <label for="costo" class="col-md-1 control-label">
                        Tarifa
                    </label>
                    <span  class="col-md-2">
                        <g:textField name="costo" class="required form-control" value="${g.formatNumber(number: detalle?.costo ?: 0, maxFractionDigits: 5,
                                minFractionDigits: 2, locale: 'ec')}"/>
                        <p class="help-block ui-helper-hidden"></p>
                    </span>
                    <label for="subtotal" class="col-md-1 control-label">
                        C.Total
                    </label>
                    <span  class="col-md-2">
                        <g:textField name="subtotal" class="required form-control" value="${g.formatNumber(number: detalle?.subtotal ?: 0, maxFractionDigits: 5,
                                minFractionDigits: 2, locale: 'ec')}"/>
                        <p class="help-block ui-helper-hidden"></p>
                    </span>
                </span>
            </div>
        </div>
    </g:form>
</div>

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
            ev.keyCode === 190 || ev.keyCode === 110 ||
            ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
            ev.keyCode === 37 || ev.keyCode === 39);
    }


    $("#peso, #precio, #cantidad, #costo, #distancia").keydown(function (ev) {
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
