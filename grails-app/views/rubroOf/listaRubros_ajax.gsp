<g:select name="rubro" from="${rubros}" optionKey="id" optionValue="nombre" class="form-control"/>

<script type="text/javascript">

    cargarComposicion($("#rubro option:selected").val());

    $("#rubro").change(function () {
       var id = $(this).val();
       cargarComposicion(id);
    });

    function cargarComposicion(id) {
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'rubroOf', action:'tablaComposicion_ajax')}",
            data: {
                id: id
            },
            success: function (msg) {
                $("#divComposicion").html(msg);
            }
        });
    }

</script>