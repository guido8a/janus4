<%@ page import="janus.Grupo" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Rubros contratista
    </title>
</head>

<body>

<div class="col-md-1 btn-group" role="navigation">
    <a href="#" class="btn  btn-primary" id="btnRegresar">
        <i class="fa fa-arrow-left"></i>
        Regresar
    </a>
</div>

<div class="col-md-4 btn-group" role="navigation">
    <div class="col-md-4">
        <label></label>
    </div>
    <div class="col-md-4">
        <label>Costos indirectos</label>
    </div>
    <div class="col-md-3" style="margin-left: -40px" id="divCostosIndirectos">

    </div>
    <div class="col-md-1" style="margin-left: -30px; margin-top: 7px">
        %
    </div>
</div>

<div class="col-md-2 btn-group" role="navigation">
    <a href="#" class="btn  btn-info" id="btnProcesar">
        <i class="fa fa-check-circle"></i>
        Validar rubros importados de excel
    </a>
</div>

<div class="col-md-2 btn-group" role="navigation">
    <div class="col-md-4">
        <label></label>
    </div>
</div>

<div class="col-md-2 btn-group" role="navigation">
    <a href="#" class="btn  btn-success" id="btnEmpatar">
        <i class="fa fa-check-circle"></i>
        Emparejamiento de Items
    </a>
</div>

<div id="list-grupo" class="col-md-12" role="main" style="margin-top: 10px;margin-left: -10px">

    <div class="col-md-12">
        <div class="col-md-2">
            <b style="margin-left: 20px">Obra Ofertada:</b>
        </div>
        <div class="col-md-10">
            %{--<g:select name="obra" from="${obras}" optionKey="key" optionValue="value" style="width: 100%; margin-left: -80px"/>--}%
            <g:select name="obra" from="${obras}" optionKey="id" optionValue="nombre" style="width: 100%; margin-left: -80px"/>
        </div>
    </div>

    <div class="col-md-12" style="margin-top: 20px">
        <div class="col-md-2">
            <b style="margin-left: 20px">Rubros:</b>
        </div>
        <div class="col-md-10" id="divRubros">

        </div>
    </div>

    <div class="col-md-12" id="divComposicion">

    </div>

</div>

<script type="text/javascript">

    $("#obra").change(function () {
        cargarRubro();
    });

    cargarRubro();

    function cargarRubro() {
        var id = $("#obra").val();
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'rubroOf', action:'listaRubros_ajax')}",
            data: {
                id: id
            },
            success: function (msg) {
                $("#divRubros").html(msg);
            }
        });
    }

    $("#btnRegresar").click(function () {
        var cntr = $("#obra").val();
        location.href = "${createLink(controller: 'rubroOf', action: 'rubroPrincipalOf')}?contrato=" + cntr
    });

    $("#btnProcesar").click(function () {
        var cntr = $("#obra").val();
        var indi = $("#indi").val();
        %{--location.href = "${createLink(controller: 'rubroOf', action: 'procesarRubrosOf')}?contrato=" + cntr + '&indi=' + indi--}%

        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'rubroOf', action:'procesarRubrosOf')}",
            data: {
                contrato: cntr,
                indi: indi
            },
            success: function (msg) {
                var parts = msg.split("_");
                if(parts[0] === 'ok'){
                    log("Rubros validados correctamente","success");
                    setTimeout(function () {
                        location.reload();
                    }, 800);
                }else{
                    log("Error al validar", "error")
                }
            }
        });

    });

    $("#btnEmpatar").click(function () {
        var cntr = $("#obra").val();
        location.href = "${createLink(controller: 'rubroOf', action: 'rubroEmpatado')}?contrato=" + cntr
    });

    cargarCostosIndirectos();

    function cargarCostosIndirectos(){
        var obra = $("#obra option:selected").val();
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'rubroOf', action:'costosIndirectos_ajax')}",
            data: {
                id: obra
            },
            success: function (msg) {
             $("#divCostosIndirectos").html(msg)
            }
        });
    }

    $("#obra").change(function (){
        cargarCostosIndirectos();
    });

</script>
</body>
</html>