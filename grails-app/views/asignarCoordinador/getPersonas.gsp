<div class="col-md-4" style="font-weight: bold;">Persona:
<g:select name="persona.id" class="persona form-control" id="persona" from="${personas}" optionValue="${{it.apellido + ' ' + it.nombre}}" optionKey="${{it.id}}"
          style="width: 400px; margin-left: -15px"/>
</div>

<div class="col-md-6">
    <div class="col-md-4" id="funcionDiv">
        Asignar Función:
        <g:select name="funcion" from="${janus.Funcion?.findAllById(10)}" optionValue="descripcion" optionKey="id" class="form-control"/>
    </div>
    <div class="col-md-1" style="margin-top: 18px;">
        <button class="btn btn-success" id="btnAdicionar" ${personas?.size() > 0 ? '' : 'disabled'} ><i class="fa fa-plus"></i> Asignar</button>
    </div>
</div>

<script type="text/javascript">

%{--    <g:if test="${personas?.size() > 0}">--}%
    cargarTablaCoordinadores('${departamento?.id}');
%{--    </g:if>--}%
%{--    <g:else>--}%
%{--    $("#divTablaCoordinadores").html("");--}%
%{--    </g:else>--}%

    $("#btnAdicionar").click(function () {
        agregarCoordinador();
    });

    // if($(".persona").val() != null){
    //     cargarFuncion();
    // }else {
    //     $("#funcionPersona").html("");
    // }
    //
    // $(".persona").change(function () {
    //     cargarFuncion();
    // });

    %{--function cargarFuncion () {--}%
    %{--    var idPersona = $(".persona").val();--}%
    %{--    $.ajax({--}%
    %{--        type: "POST",--}%
    %{--        url: "${g.createLink(action: 'obtenerFuncionCoor')}",--}%
    %{--        data : {--}%
    %{--            id: idPersona--}%
    %{--        } ,--}%
    %{--        success: function (msg) {--}%
    %{--            $("#funcionPersona").html(msg);--}%
    %{--        }--}%
    %{--    });--}%
    %{--}--}%
</script>