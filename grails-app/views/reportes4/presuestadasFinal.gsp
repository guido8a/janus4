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
    <asset:javascript src="/jquery/plugins/jQuery-contextMenu-gh-pages/src/jquery.contextMenu.js"/>
    <asset:stylesheet src="/jquery/plugins/jQuery-contextMenu-gh-pages/src/jquery.contextMenu.css"/>
</head>

<body>

<div class="row-fluid">
    <div class="span12">
        <a href="#" class="btn btn-primary" id="regresar">
            <i class=" fa fa-arrow-left"></i>
            Regresar
        </a>
        <b>Buscar Por:</b>
        <elm:select name="buscador" from = "${reportesServ.obrasPresupuestadas()}" value="${params.buscador}"
                    optionKey="campo" optionValue="nombre" optionClass="operador" id="buscador_con" style="width: 240px" />
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
            <g:select name="departamento.id"
                      from="${janus.Departamento.findAllByRequirente(1).sort{it.direccion.nombre}}"
                      id="departamento" optionKey="id" optionValue="${{ it.direccion.nombre + ' - ' + it.descripcion }}"
                      dire="${{ it.direccion.id }}" noSelection="['' : 'Todas']" style="width: 410px;"/>
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
            Buscar
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
            <th style="width: 80px;">
                Código
            </th>
            <th style="width: 280px;">
                Nombre
            </th>
            <th style="width: 120px;">
                Tipo
            </th>
            <th style="width: 80px">
                Fecha Reg
            </th>
            <th style="width: 270px">
                Cantón-Parroquia-Comunidad
            </th>
            <th style="width: 100px">
                Valor
            </th>
            <th style="width: 200px">
                Elaborado
            </th>
            <th style="width: 70px">
                Doc.Referencia
            </th>
            <th style="width: 80px">
                Estado
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

    cargarTabla();

    function cargarTabla() {
        var d = cargarLoader("Cargando...");
        var  datos = "si=${"si"}&buscador=" + $("#buscador_reg1").val() + "&estado=" + $("#estado_reg1").val() + "&departamento=" + $("#departamento option:selected").val() + "&fi=" + $("#fechaInicio").val() + "&ff=" + $("#fechaFin").val();
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

    var checkeados = [];

    $("#buscar").click(function(){
        var c = cargarLoader("Cargando...");
        var datos = "si=${"si"}&buscador=" + $("#buscador_con").val() + "&criterio=" + $("#criterio_con").val() +
            "&operador=" + $("#oprd").val();
        $.ajax({
            type : "POST",
            url : "${g.createLink(controller: 'reportes4',action:'tablaPresupuestadas')}",
            data     : datos,
            success  : function (msg) {
                c.modal("hide");
                $("#detalle").html(msg)
            }
        });
    });

    $("#regresar").click(function () {
        location.href = "${g.createLink(controller: 'reportes', action: 'index')}"
    });

    $("#imprimir").click(function () {
        location.href = "${g.createLink(controller: 'reportes4', action:'reportePresupuestadas' )}?buscador=" + $("#buscador_con").val() + "&criterio=" + $("#criterio_con").val() + "&operador=" + $("#oprd").val()
    });

    $("#excel").click(function () {
        location.href = "${g.createLink(controller: 'reportesExcel', action:'reporteExcelPresupuestadas' )}?buscador=" + $("#buscador_con").val() + "&criterio=" + $("#criterio_con").val() + "&operador=" + $("#oprd").val()
    });

    $("#buscador_con").change(function(){
        var anterior = "${params.operador}";
        var opciones = $(this).find("option:selected").attr("class").split(",");
        poneOperadores(opciones);
        /* regresa a la opción seleccionada */
        // $("#oprd option[value=" + anterior + "]").prop('selected', true);
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

    /* inicializa el select de oprd con la primea opción de busacdor */
    $( document ).ready(function() {
        $("#buscador_con").change();
    });

    $.contextMenu({
        selector: '.obra_row',
        callback: function (key, options) {

            var m = "clicked: " + $(this).attr("id");
            var idFila = $(this).attr("id");

            if(key === "registro"){
                location.href = "${g.createLink(controller: 'obra', action: 'registroObra')}" + "?obra=" + idFila;
            }
        },
        items: {
            "registro": {name: "Ir al Registro de esta Obra", icon:"info"}
        }
    });

</script>
</body>
</html>

