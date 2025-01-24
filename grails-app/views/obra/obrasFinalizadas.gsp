<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>

    <meta name="layout" content="main">

    <title>OBRAS FINALIZADAS</title>
</head>

<body>

<div class="col-md-12">
    <a href="#" class="btn btn-primary col-md-1" id="regresar">
        <i class=" fa fa-arrow-left"></i>
        Regresar
    </a>

    <div class="col-md-3">
        <b>Buscar Por:</b>
        <g:select name="buscador" id="buscador" from="${[0: 'Código', 1: 'Nombre', 2: 'Descripción', 3: 'Sitio', 4: 'Parroquia', 5: 'Comunidad', 6: 'Dirección']}"
                  optionKey="key" optionValue="value" style="width: 200px" />
    </div>

    <div class="col-md-4">
        <b>Criterio: </b>
        <g:textField name="criterio" id="criterio" value="${params.criterio ?: ''}" style="width: 250px;"/>
    </div>

</div>

<div class="col-md-12">

    <div class="col-md-1">
    </div>
    <div class="col-md-4">
        <b style="margin-left: 20px">Dirección o Coordinación requirente:</b>
        %{--<g:select name="departamento.id"--}%
                  %{--from="${janus.Departamento.findAllByRequirente(1).sort{it.direccion.nombre}}"--}%
                  %{--id="departamento" optionKey="id" optionValue="${{ it.direccion.nombre + ' - ' + it.descripcion }}"--}%
                  %{--dire="${{ it.direccion.id }}" noSelection="['' : 'Todas']" style="width: 400px;"/>--}%
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

<div style="margin-top: 15px; min-height: 300px">
    <table class="table table-bordered table-hover table-condensed" style="width: 100%; background-color: #a39e9e">
        <thead>
        <tr>
            <th style="width: 10%;">
                Código
            </th>
            <th style="width: 24%;">
                Nombre
            </th>
            <th style="width: 18%;">
                Dirección
            </th>
            <th style="width: 7%;">
                Fecha Reg.
            </th>
            <th style="width: 14%;">
                Sitio
            </th>
            <th style="width: 13%;">
                Parroquia -  Comunidad
            </th>
            <th style="width: 7%;">
                Fecha Inicio
            </th>
            <th style="width: 7%;">
                Fecha Fin
            </th>
        </tr>
        </thead>
    </table>
    <div id="detalle">
    </div>
</div>

<script  type="text/javascript">

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
        location.href = "${g.createLink(controller: 'reportes5', action:'reporteObrasFinalizadas' )}?buscador=" +$("#buscador option:selected").val() + "&criterio=" + $("#criterio").val() +  "&departamento=" + $("#departamento option:selected").val() + "&fechaInicio=" + $("#fechaInicio").val() + "&fechaFin=" + $("#fechaFin").val();
    });

    $("#excel").click(function () {
        location.href = "${g.createLink(controller: 'reportesExcel', action:'reporteExcelObrasFinalizadas' )}?buscador=" +$("#buscador option:selected").val() + "&criterio=" + $("#criterio").val() +  "&departamento=" + $("#departamento option:selected").val() + "&fechaInicio=" + $("#fechaInicio").val() + "&fechaFin=" + $("#fechaFin").val();
    });

    cargarTabla();

    function cargarTabla() {
        var d = cargarLoader("Cargando...");
        var datos = "&buscador=" + $("#buscador").val() + "&criterio=" + $("#criterio").val() +
            "&departamento=" + $("#departamento option:selected").val() + "&fechaInicio=" + $("#fechaInicio").val() + "&fechaFin=" + $("#fechaFin").val();
        $.ajax({
            type : "POST",
            url : "${g.createLink(controller: 'obra',action:'tablaObrasFinalizadas')}",
            data     : datos,
            success  : function (msg) {
                d.modal("hide");
                $("#detalle").html(msg)
            }
        });
    }

    $("#buscar").click(function(){
        cargarTabla();
    })

</script>
</body>
</html>