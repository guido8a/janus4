<g:if test="${id != '-1'}">
    <div class="col-md-12" style="font-weight: bold; margin-top: 10px">  Departamento:
    <g:select name="departamento.id" id="departamento" class="departamento form-control" from="${departamento}" optionValue="descripcion" optionKey="id"
              style="width: 400px;"/>
    </div>

    <div class="col-md-12" style="font-weight: bold; margin-top: 10px" id="personasSel"></div>
</g:if>

<div class="col-md-6" id="divTablaCoordinadores" style="margin-top: 10px"></div>

<script type="text/javascript">

    cargarPersonas();

    function cargarPersonas() {
        var idDep = $("#departamento option:selected").val();
        $.ajax({
            type: "POST",
            url: "${g.createLink(controller: 'asignarCoordinador', action:'getPersonas')}",
            data: {
                id: idDep
            },
            success: function (msg) {
                $("#personasSel").html(msg);
            }
        });
    }

    $("#departamento").change(function () {
        var id = $(this).val();
        if (id !== '-1') {
            cargarPersonas();
            cargarTablaCoordinadores(id)
        }
    });
</script>