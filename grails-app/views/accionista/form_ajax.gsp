
<g:form class="form-horizontal" name="frmSaveAccionista" action="save_ajax">
    <g:hiddenField name="id" value="${consorcio?.id}"/>
    <g:hiddenField name="proveedor" value="${proveedor?.id}"/>

    <div class="form-group ${hasErrors(bean: accionista, field: 'cedula', 'error')} ">
        <span class="grupo">
            <label for="cedula" class="col-md-2 control-label text-info">
                Cédula
            </label>
            <span class="col-md-4">
                <g:textField name="cedula" maxlength="13" minlength="10" class="form-control allCaps required" value="${accionista?.cedula}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: accionista, field: 'nombre', 'error')} ">
        <span class="grupo">
            <label for="cedula" class="col-md-2 control-label text-info">
                Nombre
            </label>
            <span class="col-md-8">
                <g:textField name="nombre" maxlength="30" minlength="3" class="form-control required" value="${accionista?.nombre}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: accionista, field: 'apellido', 'error')} ">
        <span class="grupo">
            <label for="apellido" class="col-md-2 control-label text-info">
                Apellido
            </label>
            <span class="col-md-8">
                <g:textField name="apellido" maxlength="30" minlength="3" class="form-control required" value="${accionista?.apellido}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: accionista, field: 'cargo', 'error')} ">
        <span class="grupo">
            <label for="apellido" class="col-md-2 control-label text-info">
                Cargo
            </label>
            <span class="col-md-8">
                <g:textField name="cargo" maxlength="63" minlength="3" class="form-control" value="${accionista?.cargo}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: accionista, field: 'titulo', 'error')} ">
        <span class="grupo">
            <label for="titulo" class="col-md-2 control-label text-info">
                Título
            </label>
            <span class="col-md-4">
                <g:textField name="titulo" maxlength="4" class="form-control" value="${accionista?.titulo}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: accionista, field: 'mail', 'error')} ">
        <span class="grupo">
            <label for="mail" class="col-md-2 control-label text-info">
                Email
            </label>
            <span class="col-md-8">
                <g:textField name="mail" maxlength="63" class="form-control mail email" value="${accionista?.mail}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: accionista, field: 'telefono', 'error')} ">
        <span class="grupo">
            <label for="telefono" class="col-md-2 control-label text-info">
                Teléfono
            </label>
            <span class="col-md-8">
                <g:textField name="telefono" maxlength="63" class="form-control" value="${accionista?.telefono}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group">
        <span class="grupo">
            <label for="porcentaje" class="col-md-2 control-label text-warning" >
                Porcentaje
            </label>
            <span class="col-md-4">
                <g:textField name="porcentaje" maxlength="5" class="form-control required" value="${consorcio?.porcentaje ?: 1}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

</g:form>

<script type="text/javascript">

      function validarNum(ev) {
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
            (ev.keyCode >= 96 && ev.keyCode <= 105) ||
            ev.keyCode === 190 || ev.keyCode === 110 ||
            ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
            ev.keyCode === 37 || ev.keyCode === 39);
    }

    function validarNumDec(ev) {
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
            (ev.keyCode >= 96 && ev.keyCode <= 105) ||
            ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode ===9 ||
            ev.keyCode === 37 || ev.keyCode === 39);
    }

    $("#cedula").keydown(function (ev) {
        return validarNumDec(ev)
    });

    $("#porcentaje").keydown(function (ev) {
        return validarNum(ev);
    });

    $("#frmSaveAccionista").validate({
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
        },
        errorClass     : "help-block"
    });

</script>