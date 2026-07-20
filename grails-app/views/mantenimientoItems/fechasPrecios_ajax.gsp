<label class="control-label text-info">Fecha</label>
<g:select name="fecha" from="${fechas}" id="fecha" optionKey="value" optionValue="value" style="font-size: 16px;" class="form-control" value="${fechaNueva}" />

<script type="text/javascript">

    cargarTablaPrecios();

    $("#fecha").change(function () {
        cargarTablaPrecios();
    });

</script>
