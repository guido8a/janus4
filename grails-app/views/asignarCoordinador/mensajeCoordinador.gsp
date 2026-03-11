<g:if test="${id != '' && id}">
    <g:if test="${getCoordinador?.size() > 0}">
        <div class="col-md-5 alert alert-info" id="directorSel" style="font-weight: bold;">
            Coordinador Actual:
            <g:each in="${getCoordinador}" var="coordinador">
                <ul>
                    <li>${ coordinador?.persona?.apellido + " " +  coordinador?.persona?.nombre}</li>
                </ul>
            </g:each>
        </div>
    </g:if>
    <g:else>
        <div class="col-md-5 alert alert-danger" id="directorSel" style="font-weight: bold;">Coordinador Actual: El departamento seleccionado no cuenta con un coordinador asignado.</div>
    </g:else>
</g:if>
