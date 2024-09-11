<div class="row">
    <div class="alert alert-info col-md-12" style="text-align: center; font-weight: bold; font-size: 16px">
        ${departamento?.descripcion}
    </div>
    <div class="" style="width: 100%;height: 400px; overflow-y: auto; margin-top: 5px">
        <ul>
            <g:each in="${materiales}" var="material">
                <li>
                    ${material?.nombre}
                </li>
            </g:each>
        </ul>
    </div>
</div>