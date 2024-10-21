<g:form class="form-horizontal" name="frmRubroVolObra" role="form" controller="volumenObra" action="addItem" method="POST">
    <g:hiddenField name="id" value="${rubro?.id}" />

    <div class="form-group ${hasErrors(bean: rubro, field: 'cantidad', 'error')} required">
        <span class="grupo">
            <label for="cantidad" class="col-md-2 control-label text-info">
                Cantidad
            </label>
            <span class="col-md-4">
                <g:textField name="cantidad" required="" class="form-control required" value="${rubro?.cantidad}"/>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: rubro, field: 'rendimiento', 'error')} required">
        <span class="grupo">
            <label for="rendimiento" class="col-md-2 control-label text-info">
                Rendimiento
            </label>
            <span class="col-md-4">
                <g:textField name="rendimiento" required="" class="form-control required" value="${rubro?.rendimiento}"/>
            </span>
        </span>

        <span class="col-md-2">
            <a href="#" class="btn btn-info btnRendimientoDefecto">
                <i class="fa fa-info"></i>
                Rendimiento por defecto
            </a>
        </span>
    </div>

</g:form>

<script type="text/javascript">

    $(".btnRendimientoDefecto").click(function () {
        $("#rendimiento").val(${rendimiento})
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


    $("#cantidad, #rendimiento").keydown(function (ev) {
        return validarNum(ev);
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
            submitFormEditarItem();
            return false;
        }
        return true;
    });
</script>