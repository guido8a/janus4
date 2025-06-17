<g:select name="subpresupuestoDestino" class="form-control" from="${subPresupuestosDestino}" optionKey="${{it.id}}" optionValue="${{it.grupo.descripcion + " - " + it.descripcion}}"/>

<script type="text/javascript">

    cargarTablaDestino();

    $("#subpresupuestoDestino").change(function () {
        cargarTablaDestino();
    })

</script>