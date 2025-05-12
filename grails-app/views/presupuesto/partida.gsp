<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Concursos</title>
</head>
<body>

<div id="divPartida">

</div>

<div id="divAsignaciones">

</div>

<div id="divPAC">

</div>

<div id="divConcurso">

</div>

<div id="divFechas">

</div>

<div id="divOferta">

</div>

<script type="text/javascript">

    cargarPartida();

    function cargarPartida(partida){
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'presupuesto', action:'partida_ajax')}",
            data: {
                partida: partida
            },
            success: function (msg) {
                $("#divPartida").html(msg);
            }
        });
    }

    function cargarAsignaciones(partida){
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'asignacion', action:'asignacion_ajax')}",
            data: {
                partida: partida
            },
            success: function (msg) {
                $("#divAsignaciones").html(msg);
            }
        });
    }

    function cargarPAC(asignacion){
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'pac', action:'pac_ajax')}",
            data: {
                asignacion: asignacion
            },
            success: function (msg) {
                $("#divPAC").html(msg);
            }
        });
    }

    function cargarConcurso(pac){
        var d = cargarLoader("Cargando...");
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'concurso', action:'concurso_ajax')}",
            data: {
                pac: pac
            },
            success: function (msg) {
                d.modal("hide");
                $("#divConcurso").html(msg);
            }
        });
    }

    function cargarOferta(concurso){
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'oferta', action:'oferta_ajax')}",
            data: {
                concurso: concurso
            },
            success: function (msg) {
                $("#divOferta").html(msg);
            }
        });
    }

</script>

</body>
</html>
