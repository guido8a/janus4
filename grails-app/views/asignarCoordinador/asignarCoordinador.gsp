
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Asignar Coordinador</title>
</head>

<body>

<div class="col-md-12 btn-group" style="margin-bottom: 10px">
    <button class="btn btnRegresar btn-info" ><i class="fa fa-arrow-left"></i> Regresar</button>
</div>

<div class="col-md-12">
    <div class="col-md-6" style="font-weight: bold">Dirección:
    <g:select name="direccion" class="direccion form-control" from="${janus.Direccion.list([sort: 'nombre'])}" optionValue="nombre" optionKey="id"  />
    </div>
</div>

<div class="col-md-12" id="departamentoSel"></div>

<script type="text/javascript">

    function cargarTablaCoordinadores(id){
        $.ajax({
            type: "POST",
            url: "${g.createLink(controller: 'asignarCoordinador', action:'tablaCoordinadores_ajax')}",
            data: {
                id: id
            },
            success: function (msg) {
                $("#divTablaCoordinadores").html(msg);
            }
        });
    }

    cargarDepartamento();

    function agregarCoordinador() {
        var idDireccion = $("#direccion option:selected").val();
        var idDepartamento = $("#departamento option:selected").val();
        var idPersona = $("#persona option:selected").val();

        $.ajax({
            type: 'POST',
            url: "${createLink(controller: "asignarCoordinador", action: 'guardarCoordinador_ajax')}",
            data:{
                id: idPersona,
                direccion: idDireccion,
                departamento: idDepartamento
            },
            success: function(msg){
                var parts = msg.split("_");
                if(parts[0] === 'ok'){
                    log(parts[1], "success");
                    cargarTablaCoordinadores(idDepartamento);
                }else{
                    bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                }
            }
        })
    }

    $(".btnRegresar").click(function () {
        location.href = "${createLink(controller: 'persona', action: 'list')}";
    });

    function cargarDepartamento() {
        var idDep = $("#direccion").val();
        $.ajax({
            type: "POST",
            url: "${g.createLink(controller: 'asignarCoordinador', action:'getDepartamento')}",
            data: {
                id: idDep
            },
            success: function (msg) {
                $("#departamentoSel").html(msg);
            }
        });
    }

    $("#direccion").change(function () {
        var valor = $(this).val();
        if (valor !== -1) {
            cargarDepartamento();
        }
    });

</script>

</body>
</html>