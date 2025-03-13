%{--<g:select name="rubro" from="${rubros}" optionKey="key" optionValue="value" class="form-control"/>--}%
<g:select name="rubro" from="${rubros}" optionKey="key" optionValue="value"
          style="width: 100%; margin-left: -80px"/>


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
                id: id,
                obra: ${obra}
            },
            success: function (msg) {
                $("#divComposicion").html(msg);
            }
        });
    }

</script>