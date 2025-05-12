<div id="list-Proveedor" role="main" style="margin-top: 10px;">

    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 15%">Especialidad</th>
            <th style="width: 15%">Tipo</th>
            <th style="width: 15%">Ruc</th>
            <th style="width: 45%">Nombre</th>
            <th style="width: 9%">Seleccionar</th>
            <th style="width: 1%"></th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 420px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
        <tbody>
        <g:if test="${datos}">
            <g:each in="${datos}" status="i" var="proveedorInstance">
                <tr>
                    <td style="width: 15%">${janus.EspecialidadProveedor.get(proveedorInstance.espc__id)?.descripcion}</td>
                    <td style="width: 15%">${(proveedorInstance.prvetipo=="N")?"Natural": (proveedorInstance.prvetipo=="J")? "Jurídica":"Empresa Pública"}</td>
                    <td style="width: 15%">${proveedorInstance?.prve_ruc}</td>
                    <td style="width: 45%">${proveedorInstance?.prvenmbr}</td>
                    <td style="width: 9%; text-align: center">
                        <a class="btn btn-xs btn-success btnSeleccionarProveedor" href="#" rel="tooltip" title="Seleccionar" data-id="${proveedorInstance.prve__id}" data-nombre="${proveedorInstance.prvenmbr}">
                            <i class="fa fa-check"></i>
                        </a>
                    </td>
                    <td  style="width: 1%">

                    </td>
                </tr>
            </g:each>
        </g:if>
        <g:else>
            <tr>
                <td class="alert alert-warning" colspan="6" style="text-align: center;"> <h3><i class="fa fa-exclamation-triangle"></i> No existen registros</h3> </td>
            </tr>
        </g:else>
        </tbody>
    </table>
</div>

<script type="text/javascript">

    $(".btnSeleccionarProveedor").click(function () {
        var id = $(this).data("id");
        var nombre = $(this).data("nombre");
        $("#proveedor").val(id);
        $("#proveedorName").val(nombre);
        cerrarBuscadorProveedor();
    })

</script>