<g:select name="subpresupuestoSeleccionado" class="form-control" from="${subPresupuestos}" optionKey="${{it.id}}" optionValue="${{it.descripcion}}" />

<script type="text/javascript">

    cargarTablaSeleccionados();

    $("#subpresupuestoSeleccionado").change(function () {
        cargarTablaSeleccionados();
    })

</script>