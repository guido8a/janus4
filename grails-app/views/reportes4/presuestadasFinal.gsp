<%@ page import="janus.Grupo" %>

<%
    def reportesServ = grailsApplication.classLoader.loadClass('utilitarios.reportesService').newInstance()
%>

<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Obras Presupuestadas
    </title>
    %{--    <asset:javascript src="/jquery/plugins/jQuery-contextMenu-gh-pages/src/jquery.contextMenu.js"/>--}%
    %{--    <asset:stylesheet src="/jquery/plugins/jQuery-contextMenu-gh-pages/src/jquery.contextMenu.css"/>--}%
</head>

<body>

<div class="row-fluid">
    <div class="span12">
        <a href="#" class="btn btn-primary" id="regresar">
            <i class=" fa fa-arrow-left"></i>
            Regresar
        </a>
        <b style="margin-left: 35px">Buscar Por:</b>
        <elm:select name="buscador" from = "${reportesServ.obrasPresupuestadas()}" value="${params.buscador}"
                    optionKey="campo" optionValue="nombre" optionClass="operador" id="buscador_con" style="width: 200px" />
        <b>Operación:</b>
        <span id="selOpt"></span>
        <b style="margin-left: 20px">Criterio: </b>
        <g:textField name="criterio" style="width: 230px; margin-right: 10px" value="${params.criterio}" id="criterio_con"/>
    </div>
    <div class="span12">

        <div class="col-md-1">
        </div>
        <div class="col-md-4">
            <b style="margin-left: 20px">Dirección o Coordinación requirente:</b>
            <g:select name="departamento.id"
                      from="${departamento}" id="departamento" optionKey="key" optionValue="value"
                      noSelection="['' : 'Todas']" style="width: 410px;"/>

        </div>
        <div class="col-md-2" style="align-items: center;">
            <b style="margin-left: 20px">Fecha Desde: </b>
            <input aria-label="" name="fechaInicio_name" id='fechaInicio' type='text' class=""  />
        </div>

        <div class="col-md-2" style="align-items: center;">
            <b style="margin-left: 20px">Fecha Hasta: </b>
            <input aria-label="" name="fechaFin_name" id='fechaFin' type='text' class=""  />
        </div>

        <a href="#" class="btn btn-success" id="buscar">
            <i class=" fa fa-search"></i>
            Reporte
        </a>
        <a href="#" class="btn btn-info" id="imprimir" >
            <i class=" fa fa-print"></i>
            Imprimir
        </a>
        <a href="#" class="btn btn-success" id="excel" >
            <i class="fa fa-file-excel"></i>
            Excel
        </a>
    </div>
</div>


<div style="margin-top: 15px; min-height: 300px">
    <table class="table table-bordered table-hover table-condensed" style="width: 100%; background-color: #a39e9e">
        <thead>
        <tr>
            <th style="width: 12%;">
                Código
            </th>
            <th style="width: 29%;">
                Nombre
            </th>
            <th style="width: 13%;">
                Tipo
            </th>
            <th style="width: 8%">
                Fecha Reg
            </th>
            <th style="width: 21%">
                Cantón-Parroquia-Comunidad
            </th>
            <th style="width: 9%">
                Valor
            </th>
            <th style="width: 14%">
                Requirente
            </th>
            <th style="width: 11%">
                Doc.Referencia
            </th>
            <th style="width: 5%">
                Estado
            </th>
            <th style="width: 1%">
            </th>
        </tr>
        </thead>
    </table>
    <div id="detalle">
    </div>
</div>

<script type="text/javascript">

    $('#fechaInicio, #fechaFin').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        icons: {
        }
    });

    /* inicializa el select de oprd con la primea opción de busacdor */
    $( document ).ready(function() {
//        cargarTabla();
    });

    function cargarTabla() {
        $("#buscador_con").change();
        var d = cargarLoader("Cargando...");
        var datos = "si=${"si"}&buscador=" + $("#buscador_con").val() + "&criterio=" + $("#criterio_con").val() +
            "&operador=" + $("#oprd").val() + "&departamento=" + $("#departamento option:selected").val() +
            "&fechaInicio=" + $("#fechaInicio").val() + "&fechaFin=" + $("#fechaFin").val();
        $.ajax({
            type : "POST",
            url : "${g.createLink(controller: 'reportes4',action:'tablaPresupuestadas')}",
            data     : datos,
            success  : function (msg) {
                d.modal("hide");
                $("#detalle").html(msg)
            }
        });
    }

    $("#buscar").click(function(){
        cargarTabla();
    });

    $("#regresar").click(function () {
        location.href = "${g.createLink(controller: 'reportes', action: 'index')}"
    });

    $("#imprimir").click(function () {
        location.href = "${g.createLink(controller: 'reportes4', action:'reportePresupuestadas' )}?buscador=" + $("#buscador_con").val() + "&criterio=" + $("#criterio_con").val() + "&operador=" + $("#oprd").val() + "&departamento=" + $("#departamento option:selected").val() + "&fechaInicio=" + $("#fechaInicio").val() + "&fechaFin=" + $("#fechaFin").val()
    });

    $("#excel").click(function () {
        location.href = "${g.createLink(controller: 'reportesExcel', action:'reporteExcelPresupuestadas' )}?buscador=" + $("#buscador_con").val() + "&criterio=" + $("#criterio_con").val() + "&operador=" + $("#oprd").val() + "&departamento=" + $("#departamento option:selected").val() + "&fechaInicio=" + $("#fechaInicio").val() + "&fechaFin=" + $("#fechaFin").val()
    });

    $("#buscador_con").change(function(){
        var opciones = $(this).find("option:selected").attr("class").split(",");
        poneOperadores(opciones);
    });

    function poneOperadores (opcn) {
        var $sel = $("<select name='operador' id='oprd' style='width: 160px'}>");
        for(var i=0; i<opcn.length; i++) {
            var opt = opcn[i].split(":");
            var $opt = $("<option value='"+opt[0]+"'>"+opt[1]+"</option>");
            $sel.append($opt);
        }
        $("#selOpt").html($sel);
    }

    $("#criterio_con").keydown(function (ev) {
        if (ev.keyCode === 13) {
            ev.preventDefault();
            cargarTabla();
            return false;
        }
    });

</script>
</body>
</html>

