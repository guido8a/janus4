<g:form class="form-horizontal" name="frmCosto" role="form" controller="volumenObra" action="saveCosto_ajax" method="POST">
    <g:hiddenField name="id" value="${detalle?.id}" />
    <g:hiddenField name="costo" value="${costo?.id}" />
    <g:hiddenField name="obra" value="${obra?.id}" />

    <g:if test="${tipo == '1'}">
        <div class="breadcrumb">
          <strong style="font-size: 14px"> Unitario: ${unitario}   -  Porcentaje: ${porcentaje} %</strong>
        </div>

    </g:if>

    <div class="form-group ${hasErrors(bean: detalle, field: 'orden', 'error')} required">
        <span class="grupo">
            <label for="orden" class="col-md-2 control-label text-info">
                Orden
            </label>
            <span class="col-md-3">
                <g:textField name="orden" required="" class="form-control required" value="${detalle?.orden ?: 1}"/>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: detalle, field: 'descripcion', 'error')} ">
        <span class="grupo">
            <label for="descripcion" class="col-md-2 control-label text-info">
                Descripción
            </label>
            <span class="col-md-10">
                <g:textArea name="descripcion" maxlenght="127" class="form-control" value="${detalle?.descripcion ?: costo?.descripcion}" style="resize: none; height: 100px" />
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: detalle, field: 'valor', 'error')} required">
        <span class="grupo">
            <label for="valor" class="col-md-2 control-label text-info">
                Valor
            </label>
            <span class="col-md-3">
                <g:textField name="valor" required="" class="form-control required" value="${detalle?.valor ?: 0}"/>
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
            ev.keyCode === 190 || ev.keyCode === 110 ||
            ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
            ev.keyCode === 37 || ev.keyCode === 39);
    }

    $("#valor").keydown(function (ev) {
        return validarNum(ev);
    });

    function validarNumEntero(ev) {
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
            (ev.keyCode >= 96 && ev.keyCode <= 105) ||
            ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
            ev.keyCode === 37 || ev.keyCode === 39);
    }

    $("#orden").keydown(function (ev) {
        return validarNumEntero(ev);
    });

    $("#frmCosto").validate({
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

</script>