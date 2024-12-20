<form class="form-horizontal">
    <g:if test="${fabricante?.ruc}">
        <div class="row">
            <div class="col-md-3 text-info">
                RUC
            </div>
            <div class="col-md-6 negrita">
                ${fabricante?.ruc}
            </div>
        </div>
    </g:if>

    <g:if test="${fabricante?.nombre}">
        <div class="row">
            <div class="col-md-3 text-info">
                Nombre
            </div>
            <div class="col-md-6 negrita">
                ${fabricante?.nombre}
            </div>
        </div>
    </g:if>

    <g:if test="${fabricante?.nombreContacto}">
        <div class="row">
            <div class="col-md-3 text-info">
                Nombre Contacto
            </div>
            <div class="col-md-6 negrita">
                ${fabricante?.nombreContacto}
            </div>
        </div>
    </g:if>

    <g:if test="${fabricante?.apellidoContacto}">
        <div class="row">
            <div class="col-md-3 text-info">
                Apellido Contacto
            </div>
            <div class="col-md-6 negrita">
                ${fabricante?.apellidoContacto}
            </div>
        </div>
    </g:if>

    <g:if test="${fabricante?.gerente}">
        <div class="row">
            <div class="col-md-3 text-info">
                Gerente
            </div>
            <div class="col-md-6 negrita">
                ${fabricante?.gerente}
            </div>
        </div>
    </g:if>

    <g:if test="${fabricante?.direccion}">
        <div class="row">
            <div class="col-md-3 text-info">
                Dirección
            </div>
            <div class="col-md-6 negrita">
                ${fabricante?.direccion}
            </div>
        </div>
    </g:if>

    <g:if test="${fabricante?.mail}">
        <div class="row">
            <div class="col-md-3 text-info">
                Email
            </div>
            <div class="col-md-6 negrita">
                ${fabricante?.mail}
            </div>
        </div>
    </g:if>

    <g:if test="${fabricante?.telefono}">
        <div class="row">
            <div class="col-md-3 text-info">
                Teléfono
            </div>
            <div class="col-md-6 negrita">
                ${fabricante?.telefono}
            </div>
        </div>
    </g:if>

    <g:if test="${fabricante?.observaciones}">
        <div class="row">
            <div class="col-md-3 text-info">
                Observaciones
            </div>
            <div class="col-md-6 negrita">
                ${fabricante?.observaciones}
            </div>
        </div>
    </g:if>
</form>
