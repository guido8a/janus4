<!doctype html>
<%@ page import="utilitarios.reportesService" %>
<%
    def reportesServ = grailsApplication.classLoader.loadClass('utilitarios.reportesService').newInstance()
%>

<html>
<head>
    <meta name="layout" content="main">
    <title>
        Obras Suspendidas
    </title>
</head>

<body>

<div class="row-fluid">
    <div class="span12">
        <a href="#" class="btn btn-primary" id="regresar">
            <i class=" fa fa-arrow-left"></i>
            Regresar
        </a>
        <b>Buscar Por: </b>
        <elm:select name="buscador" from = "${reportesServ.obrasContratadas()}" value="${params.buscador}"
                    optionKey="campo" optionValue="nombre" optionClass="operador" id="buscador_con" style="width: 200px" />
        <b>Operación:</b>
        <span id="selOpt"></span>
        <b style="margin-left: 20px">Criterio: </b>
        <g:textField name="criterio" style="width: 160px; margin-right: 10px" value="${params.criterio}" id="criterio_con"/>

    </div>
    <div class="span12">

        <div class="col-md-1">
        </div>
        <div class="col-md-4">
            <b style="margin-left: 20px">Dirección o Coordinación requirente:</b>
            %{--<g:select name="departamento.id"--}%
                      %{--from="${janus.Departamento.findAllByRequirente(1).sort{it.direccion.nombre}}"--}%
                      %{--id="departamento" optionKey="id" optionValue="${{ it.direccion.nombre + ' - ' + it.descripcion }}"--}%
                      %{--dire="${{ it.direccion.id }}" noSelection="['' : 'Todas']" style="width: 410px;"/>--}%
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
            <i class="fa fa-search"></i>
            Reporte
        </a>
        <a href="#" class="btn btn-info" id="imprimir" >
            <i class="fa fa-print"></i>
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
            <th style="width: 10%">
                Código
            </th>
            <th style="width: 24%;">
                Nombre
            </th>
            <th style="width: 14%">
                Cantón-Parroquia-Comunidad
            </th>
            <th style="width: 8%">
                Núm. Contrato
            </th>
            <th style="width: 10%">
                Contratista
            </th>
            <th style="width: 8%">
                Monto
            </th>
            <th style="width: 8%">
                Fecha suscripción
            </th>
            <th style="width: 8%">
                Fecha Inicio Obra
            </th>
            <th style="width: 6%">
                Plazo
            </th>
            <th style="width: 7%">
                % avance económico
            </th>
            <th style="width: 5%">
                Avance físico
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

    $("#regresar").click(function () {
        location.href = "${g.createLink(controller: 'reportes', action: 'index')}"
    });

    $("#imprimir").click(function () {
        var busca = $("#buscador_con").val();
        location.href="${g.createLink(controller: 'reportes4', action:'reporteSuspendidas' )}?buscador=" + busca + "&operador=" + $("#oprd").val() + "&criterio=" + $("#criterio_con").val()
    });

    $("#excel").click(function () {
        location.href="${g.createLink(controller: 'reportesExcel', action:'reporteExcelSuspendidas' )}?buscador=" + $("#buscador_con").val() + "&criterio=" + $("#criterio_con").val() + "&operador=" + $("#oprd").val()
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

    $( document ).ready(function() {
        $("#buscador_con").change();
        cargarTabla();
    });

    function cargarTabla() {
        var d = cargarLoader("Cargando...");
        var datos = "si=${"si"}&buscador=" + $("#buscador_con").val() + "&criterio=" + $("#criterio_con").val() +
            "&operador=" + $("#oprd").val() + "&departamento=" + $("#departamento option:selected").val() + "&fi=" + $("#fechaInicio").val() + "&ff=" + $("#fechaFin").val();
        $.ajax({
            type : "POST",
            url : "${g.createLink(controller: 'reportes4', action: 'tablaSuspendidas')}",
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

</script>
</body>
</html>

