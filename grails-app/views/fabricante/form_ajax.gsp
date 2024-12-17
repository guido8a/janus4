<g:if test="${!fabricante}">
    Error
</g:if>
<g:else>
    <g:form class="form-horizontal" name="frmFabricante" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${fabricante?.id}" />

        <div class="form-group ${hasErrors(bean: fabricante, field: 'ruc', 'error')} ">
            <span class="grupo">
                <label for="ruc" class="col-md-2 control-label text-info">
                    Ruc
                </label>
                <span class="col-md-8">
                    <g:textField name="ruc" maxlength="13" minlength="10" class="form-control required" value="${fabricante?.ruc}"/>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: fabricante, field: 'nombre', 'error')} ">
            <span class="grupo">
                <label for="nombre" class="col-md-2 control-label text-info">
                    Nombre
                </label>
                <span class="col-md-8">
                    <g:textField name="nombre" maxlength="63" minlength="0" class="form-control required" value="${fabricante?.nombre}"/>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: fabricante, field: 'nombre', 'error')} ">
            <span class="grupo">
                <label for="nombre" class="col-md-2 control-label text-info">
                    Nombre contacto
                </label>
                <span class="col-md-4">
                    <g:textField name="nombreContacto" maxlength="31" minlength="0" class="form-control" value="${fabricante?.nombreContacto}"/>
                </span>
            </span>

            <span class="grupo">
                <label for="nombre" class="col-md-2 control-label text-info">
                    Apellido contacto
                </label>
                <span class="col-md-4">
                    <g:textField name="apellidoContacto" maxlength="31" minlength="0" class="form-control" value="${fabricante?.apellidoContacto}"/>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: fabricante, field: 'gerente', 'error')} ">
            <span class="grupo">
                <label for="gerente" class="col-md-2 control-label text-info">
                    Gerente
                </label>
                <span class="col-md-8">
                    <g:textField name="gerente" maxlength="40" minlength="0" class="form-control" value="${fabricante?.gerente}"/>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: fabricante, field: 'direccion', 'error')} ">
            <span class="grupo">
                <label for="direccion" class="col-md-2 control-label text-info">
                    Dirección
                </label>
                <span class="col-md-8">
                    <g:textField name="direccion" maxlength="60" minlength="0" class="form-control" value="${fabricante?.direccion}"/>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: fabricante, field: 'telefono', 'error')} ">
            <span class="grupo">
                <label for="telefono" class="col-md-2 control-label text-info">
                    Teléfono
                </label>
                <span class="col-md-4">
                    <g:textField name="telefono" maxlength="40" minlength="0" class="form-control" value="${fabricante?.telefono}"/>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: fabricante, field: 'mail', 'error')} ">
            <span class="grupo">
                <label for="mail" class="col-md-2 control-label text-info">
                    Email
                </label>
                <span class="col-md-8">
                    <g:textField name="mail" maxlength="40" minlength="0" class="form-control" value="${fabricante?.mail}"/>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: fabricante, field: 'ttlr', 'error')} ">

            <span class="grupo">
                <label for="estado" class="col-md-2 control-label text-info">
                    Estado
                </label>
                <span class="col-md-3">
                    <g:select name="estado" from="${['I' : 'Inactivo', 'A' : 'Activo']}" optionValue="value" optionKey="key" class="form-control" value="${fabricante?.estado}"/>
                </span>
            </span>

            <span class="grupo">
                <label for="ttlr" class="col-md-3 control-label text-info">
                    Título (Ing - Arq)
                </label>
                <span class="col-md-2">
                    <g:textField name="ttlr" maxlength="4" class="form-control" value="${fabricante?.ttlr}"/>
                </span>
            </span>

        </div>

        <div class="form-group ${hasErrors(bean: fabricante, field: 'observaciones', 'error')} ">
            <span class="grupo">
                <label for="mail" class="col-md-2 control-label text-info">
                    Observaciones
                </label>
                <span class="col-md-8">
                    <g:textArea name="observaciones" maxlength="124" minlength="0" class="form-control" value="${fabricante?.observaciones}" style="resize: none; height: 80px"/>
                </span>
            </span>
        </div>


    </g:form>

    <script type="text/javascript">

        var validator = $("#frmFabricante").validate({
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
                submitForm();
                return false;
            }
            return true;
        });
    </script>

</g:else>