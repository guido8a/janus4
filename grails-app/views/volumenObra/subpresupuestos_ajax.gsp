<g:select name="subpresupuestoBusqueda" class="form-control btn-info" from="${subpresupuestos}" optionKey="${{it.id}}" optionValue="${{it.descripcion}}" />

<script type="text/javascript">

    cargarTablaSeleccionados();

    $("#subpresupuestoBusqueda").change(function () {
        cargarTablaSeleccionados();
    });

</script>