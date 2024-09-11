<div class="row">
    <div class="alert alert-info col-md-12" style="text-align: center; font-weight: bold; font-size: 16px">
        ${subgrupo?.descripcion}
    </div>
    <div class="" style="width: 100%;height: 320px; overflow-y: auto; margin-top: 5px">
        <ul>
            <g:each in="${departamentos}" var="departamento">
                <li>
                    ${departamento?.descripcion}
                </li>
            </g:each>
        </ul>
    </div>
</div>