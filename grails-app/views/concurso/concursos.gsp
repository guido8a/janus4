
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Procesos de contratación</title>
</head>

<body>

<div class="row-fluid">
    <div class="span12">

        <div class="col-md-1">
            <a href="#" class="btn btn-primary" id="regresar">
                <i class=" fa fa-arrow-left"></i>
                Regresar
            </a>
        </div>

        <div class="col-md-4" style="margin-top: 12px">
            <b>Buscar Por:</b>
            <g:select name="buscador" from="${[0: 'Código', 1: 'Objeto', 2: 'Obra', 3: 'Certificación']}" optionKey="key" optionValue="value" />
            <span id="selOpt"></span>
            <b style="margin-left: 20px">Criterio: </b>
            <g:textField name="criterio" style="width: 160px; margin-right: 10px" value="${params.criterio ?: ''}" id="criterio"/>
        </div>

        <div class="col-md-2" style="align-items: center;">
            <b style="margin-left: 20px">Fecha Desde: </b>
            <input aria-label="" name="fechaInicio_name" id='fechaInicio' type='text' class=""  />
        </div>

        <div class="col-md-2" style="align-items: center;">
            <b style="margin-left: 20px">Fecha Hasta: </b>
            <input aria-label="" name="fechaFin_name" id='fechaFin' type='text' class=""  />
        </div>

        <div class="col-md-3">
            <a href="#" class="btn btn-success" id="buscar">
                <i class="fa fa-search"></i>
                Buscar
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
</div>

<div style="margin-top: 15px; min-height: 300px">
    <table class="table table-bordered table-hover table-condensed" style="width: 100%; background-color: #a39e9e">
        <thead>
        <tr>
            <th style="width: 11%;">
                Código
            </th>
            <th style="width: 8%;">
                Fecha Adjudicación
            </th>
            <th style="width: 24%;">
                Objeto
            </th>
            <th style="width: 24%;">
                Obra
            </th>
            <th style="width: 10%">
                Código Obra
            </th>
            <th style="width: 7%">
                Monto
            </th>
            <th style="width: 8%">
                Certificación Presupuestaria
            </th>
            <th style="width: 7%">
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

    $("#imprimir").click(function () {
        location.href = "${g.createLink(controller: 'reportes4', action:'reporteProcesosContratacion' )}?buscador=" +$("#buscador option:selected").val() + "&criterio=" + $("#criterio").val() + "&fechaInicio=" + $("#fechaInicio").val() + "&fechaFin=" + $("#fechaFin").val();
    });

    $("#excel").click(function () {
        location.href = "${g.createLink(controller: 'reportesExcel', action:'reporteExcelProcesosContratacion' )}?buscador=" +$("#buscador option:selected").val() + "&criterio=" + $("#criterio").val() + "&fechaInicio=" + $("#fechaInicio").val() + "&fechaFin=" + $("#fechaFin").val();
    });

    $("#buscar").click(function () {
        cargarTabla();
    });

    cargarTabla();

    function cargarTabla() {
        var fechaInicio = $("#fechaInicio").val();
        var fechaFin = $("#fechaFin").val();
        var d = cargarLoader("Cargando...");
        $.ajax({
            type : "POST",
            url : "${g.createLink(controller: 'reportes4',action:'tablaProcesos')}",
            data     : {
                buscador: $("#buscador option:selected").val(),
                criterio: $("#criterio").val(),
                fechaInicio: fechaInicio,
                fechaFin: fechaFin
            },
            success  : function (msg) {
                d.modal("hide");
                $("#detalle").html(msg);
            }
        });
    }

    $("#regresar").click(function () {
        location.href = "${g.createLink(controller: 'reportes', action: 'index')}"
    });


</script>
</body>
</html>