<%@ page import="seguridad.Persona; janus.Departamento" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Subir excel APU</title>
    <style type="text/css">
    table, th, td {
        border: 1px solid white;
    }

    .contenedor {
        width: 100%;
        border: 1px solid #888;
        white-space: nowrap;
        background-color: #b8c8d8;
        height: 35px;
        padding: 2px;
        margin-bottom: 5px;
        border-radius: 4px;
    }

    .inside {
        height: 25px;
        display: inline-block;
        font-size: 12pt;
        text-align: left;
        color: #0A246A;
    }

    </style>
</head>

<body>

<div class="row">
    <div class="col-md-3">
        <a href="#" class="btn btn-primary" id="btnRegresar">
            <i class="fa fa-arrow-left"></i>
            Regresar
        </a>
    </div>

    <div class="col-md-9" style="margin-top: -15px;">
        <h3>Cargar valores de los APU del oferente: ${oferente.nombre} ${oferente.apellido}</h3>
    </div>
</div>

<g:if test="${flash.message}">
    <div class="alert alert-error">
        ${flash.message}
    </div>
</g:if>

<div class="row" style="margin-bottom: 10px">
    <div class="col-md-12">
        <div class="col-md-3"></div>
        <div class="col-md-1">
            <label style="font-size: 14px"> Composición </label>
        </div>
        <div class="col-md-6">
            <g:select name="composicion" from="${janus.RegistroApu.findAllByPersona(seguridad.Persona.get(oferente?.id)).sort{it.nombre}}" optionValue="${{it.nombre}}" optionKey="id" class="form-control" noSelection="[null: 'Nueva composición']" />
        </div>
    </div>

    <div id="divTablaRegistro">
    </div>
</div>


<script type="text/javascript">

    $("#composicion").change(function () {
        cargarTabla();
    });

    cargarTabla();

    function cargarTabla(){
        var d = cargarLoader("Cargando...");
        var id = $("#composicion option:selected").val();
        var oferente = '${oferente}';
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'registroApu', action:'tablaRegistro_ajax')}",
            data: {
                oferente: oferente,
                id: id
            },
            success: function (msg) {
                d.modal("hide");
                $("#divTablaRegistro").html(msg);
            }
        });
    }


    $("#btnRegresar").click(function () {
        location.href = "${createLink(controller: 'rubroOf', action: 'index')}";
    });

</script>
</body>
</html>