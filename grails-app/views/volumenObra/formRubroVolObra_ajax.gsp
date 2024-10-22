<g:form class="form-horizontal" name="frmRubroVolObra" role="form" controller="volumenObra" action="addItem" method="POST">
    <g:hiddenField name="id" value="${volumenObra?.id}" />
    <g:hiddenField name="obra" value="${obra?.id}" />
    <g:hiddenField name="sub" value="${subpresupuesto?.id}" />
    <g:hiddenField name="item" value="${rubro?.id}" />
    <g:hiddenField name="cod" value="${rubro?.codigo}" />

    <div class="form-group ${hasErrors(bean: volumenObra, field: 'cantidad', 'error')} required">
        <span class="grupo">
            <label for="cantidad" class="col-md-2 control-label text-info">
                Cantidad
            </label>
            <span class="col-md-3">
                <g:textField name="cantidad" required="" class="form-control required" value="${volumenObra?.cantidad}"/>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: volumenObra, field: 'orden', 'error')} required">
        <span class="grupo">
            <label for="orden" class="col-md-2 control-label text-info">
                Orden
            </label>
            <span class="col-md-3">
                <g:textField name="orden" required="" class="form-control required" value="${volumenObra?.orden}"/>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: volumenObra, field: 'descripcion', 'error')} ">
        <span class="grupo">
            <label for="dscr" class="col-md-2 control-label text-info">
                Descripción
            </label>
            <span class="col-md-10">
                <g:textField name="dscr" required="" class="form-control" value="${volumenObra?.descripcion}"/>
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

    $("#cantidad").keydown(function (ev) {
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

    $("#frmRubro").validate({
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
            submitFormRubroVolObra();
            return false;
        }
        return true;
    });
</script>