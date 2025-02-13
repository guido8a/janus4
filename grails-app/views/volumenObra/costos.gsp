<%@ page import="janus.Grupo" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Costos
    </title>

    <style type="text/css">
    .boton {
        padding: 2px 6px;
        margin-top: -10px
    }

    </style>
</head>

<body>

<div class="row" role="navigation" style="margin-left: 35px;">
    <div class="col-md-1 btn-group" role="navigation">
        <a href="${g.createLink(controller: 'obra', action: 'registroObra', params: [obra: obra?.id])}"
           class="btn btn-info btn-new" id="atras" title="Regresar a la obra">
            <i class="fa fa-arrow-left"></i>
            Regresar
        </a>
    </div>

    <div class="alert alert-info col-md-10" style="font-size: 14px;">
       Obra: ${obra.nombre + " (" + obra.codigo + ")"}
        <input type="hidden" id="override" value="0">
    </div>
</div>

<div class="row">
    <div class="col-md-12">
        <div class="col-md-4" style="margin-top: 20px;">
            <a href="#" class="btn btn-success" id="btnAgregarCostos" title="Agregar costos">
                <i class="fa fa-plus-square"></i>
                Agregar costos
            </a>
        </div>
    </div>
</div>


<div id="list-grupo" class="col-md-12" role="main" style="margin-top: 20px;margin-left: 0px">
    <div class="borde_abajo" style="padding-left: 5px;position: relative; height: 92px">

        <div class="row-fluid" style="margin-left: 0px" id="divTablaCostos">

        </div>



        %{--        <div class="borde_abajo" style="position: relative;float: left;width: 100%;padding-left: 45px">--}%
        %{--            <p class="css-vertical-text">Composición</p>--}%

        %{--            <div class="linea" style="height: 98%;"></div>--}%

        %{--            <div style="width: 99.7%;height: 600px;overflow-y: auto;float: right;" id="detalle"></div>--}%

        %{--            <div class="col-md-12 breadcrumb" style="height: 35px;overflow-y: auto;float: right;text-align: right; font-size: 14px" id="total">--}%
        %{--                <div class="col-md-10">--}%
        %{--                    <b>TOTAL:</b>--}%
        %{--                </div>--}%
        %{--                <div class="col-md-2" >--}%
        %{--                    <div id="divTotal" style="float: left;height: 30px;font-weight: bold;font-size: 14px;margin-right: 20px"></div>--}%
        %{--                </div>--}%
        %{--            </div>--}%
        %{--        </div>--}%
    </div>

</div>

<script type="text/javascript">

    $("#btnAgregarCostos").click(function () {
        location.href="${createLink(controller: 'volumenObra', action: 'buscarCostos')}/" + '${obra?.id}';
    });

    function cargarTabla() {
        var d = cargarLoader("Cargando...");
        $.ajax({
            type : "POST",
            url : "${g.createLink(controller: 'volumenObra', action:'tablaCostos_ajax')}",
            data     : {

            },
            success  : function (msg) {
                d.modal("hide");
                $("#divTablaCostos").html(msg);
            }
        });
    }

    cargarTabla();




</script>
</body>
</html>