<label>Grupos</label>
<g:select name="grupo_${tipo}" from="${grupos}" class="form-control" optionKey="${{it.sbgr__id}}" optionValue="${{it.sbgrcdgo + " " + it.sbgrdscr}}" noSelection="[null: 'TODOS']" />

<script type="text/javascript">

    $("#grupo_2").change(function () {
        var id = $(this).val();
        cargarSubgrupo(id);
    });

    cargarSubgrupo($("#grupo_2").val());

    function cargarSubgrupo(id){
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'mantenimientoItems',  action: 'comboSubgrupos_ajax')}",
            data    : {
                id: id
            },
            success : function (msg) {
                $("#divSubgrupo").html(msg)
            }
        });
    }

</script>