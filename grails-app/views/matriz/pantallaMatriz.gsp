<%@ page import="janus.Obra" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        ${titulo}
    </title>
    <asset:javascript src="/apli/jquery.onscreen.js"/>

    <style type="text/css">
    .gr {
        background-color: #ececec;
    }

    .a1 {
        background-color: rgba(255, 172, 55, 0.8);
        font-weight: bold;
    }

    .bl {
        background-color: transparent;
    }

    .estaticas {
        background: linear-gradient(to bottom, #FFFFFF, #E6E6E6);
        font-weight: bold;
    }

    tr {
        cursor: pointer !important;
    }

    th {
        padding-left: 0px;
        padding-right: 0px;
    }

    td {
        line-height: 12px !important;
        padding: 3px !important;
        font-size: 10px !important;
        text-align: right !important;
    }

    .lb {
        text-align: left !important;
    }

    .sc {
        background-color: rgba(120, 220, 249, 0.4);
        font-weight: bold;
    }

    .mano {
        background-color: rgba(244, 198, 162, 0.5);
    }

    .saldo {
        background-color: #ffcfd6;
    }

    .totalCol {
        background-color: #85d0c9;
    }
    .hh {
        display: none;
    }
    </style>

    <script type="text/javascript">
        $("#dlgLoad").dialog("open");
    </script>
</head>

<body>

<div class="span12">
    <g:if test="${flash.message}">
        <div class="alert ${flash.clase ?: 'alert-info'}" role="status">
            <a class="close" data-dismiss="alert" href="#">×</a>
            ${flash.message}
        </div>
    </g:if>
</div>

<div class="col-md-7 btn-group" role="navigation" style="margin-left: 0px;">
    <a href="${g.createLink(controller: 'obra', action: 'registroObra', params: [obra: obra])}" class="btn btn-info btn-new" id="atras" title="Regresar a la obra">
        <i class="fa fa-arrow-left"></i>
        Regresar
    </a>
    <g:link controller="formulaPolinomica" action="insertarVolumenesItem" class="btn btn-success btn-new btnFormula"
            params="[obra: obra, sbpr: params.sbpr]" title="Coeficientes">
        <i class="fa fa-table"></i>
        Fórmula polinómica
    </g:link>
    <a href="${g.createLink(controller: 'reportes', action: 'imprimeMatriz', id: "${obra}")}" class="btn btn-ajax btn-new" id="imprimir" title="Imprimir">
        <i class="fa fa-print"></i>
        Imprimir A3
    </a>
    <a href="${g.createLink(controller: 'reportes4', action: 'imprimeMatrizA4', id: "${obra}")}" class="btn btn-ajax btn-new" id="imprimir" title="Imprimir">
        <i class="fa fa-print"></i>
        Imprimir A4
    </a>
    <a href="${g.createLink(controller: 'reportesExcel', action: 'matrizExcel', id: "${obra}")}" class="btn btn-ajax btn-new" id="excelReporte" title="Exportar matriz a Excel">
        <i class="fa fa-file-excel"></i>
        Excel
    </a>
    <a href="${g.createLink(controller: 'reportes2', action: 'reporteDesgloseEquipos', id: "${obra}")}" class="btn btn-ajax btn-new" id="desglose" title="Desglose Equipos">
        <i class="fa fa-print"></i>
        Imprimir Desglose
    </a>
</div>
<div class="col-md-2 btn-group" role="navigation" >
    <input type="text" style="margin-left: 5px;margin-top: 1px;" class="form-control" id="texto_busqueda">
</div>
<div class="col-md-3 btn-group" role="navigation" style="margin-left: -10px;">
    <a href="#" class="btn btn-info btn-new" id="buscar" title="Buscar">
        <i class="fa fa-search"></i>
        Buscar
    </a>
    <a href="#" class="btn btn-ajax btn-new" id="reset" title="Resetear">
        <i class="fa fa-eraser"></i>
        Limpiar selección
    </a>
</div>

<div class="col-md-3 btn-group" role="navigation" style="float: right; margin-top: 8px; text-align: right">
    <a href="${g.createLink(controller: 'matriz', action: 'pantallaMatriz', id: "${obra}", params: [offset: 0, sbpr: 0])}"
       class="btn btn-ajax btn-new btn-info" id="inicio" title="Inicio de la tabla" onclick="cargar()">
        <i class="fa fa-caret-left"></i> Inicio
    </a>
    <g:if test="${cont != 0}">
        <a href="${g.createLink(controller: 'matriz', action: 'pantallaMatriz', id: "${obra}", params: [offset: (cont - 30), sbpr: 0])}"
           class="btn btn-ajax btn-new btn-success" id="anterior" title="Anterior" onclick="cargar()">
            <i class="fa fa-arrow-left"></i> # ${cont}
        </a>
    </g:if>
    <g:if test="${offset < cont2}">
        <a href="${g.createLink(controller: 'matriz', action: 'pantallaMatriz', id: "${obra}", params: [offset: (offset - 1), sbpr: 0])}"
           class="btn btn-ajax btn-new btn-success" id="siguiente" title="Siguiente" onclick="cargar()">
            <i class="fa fa-arrow-right"></i> # ${offset}
        </a>
    </g:if>
    <a href="${g.createLink(controller: 'matriz', action: 'pantallaMatriz', id: "${obra}", params: [offset: cont2 - 6, sbpr: 0])}"
       class="btn btn-ajax btn-new btn-info" id="fin" title="Fin de la tabla" onclick="cargar()">
        Fin <i class="fa fa-caret-right"></i>
    </a>
</div>

<div id="list-grupo" role="main" style="margin-top: 10px;margin-left: 0;width: 100%;max-width: 100%;overflow-x: hidden">
    <div style="width: 140px; height: auto; float: left">
        <table class="table table-bordered table-condensed" id="tablaHeaders" style="width:140px;max-width:140px;">
            <thead style="height: 120px">
            <tr style="font-size: 10px !important;" id="ht">
                <th style="width: 20px;max-width: 30px;font-size: 12px !important" class="h_0">#</th>
                <th style="width: 60px;font-size: 12px !important" class="h_1">Código</th>
                <th style="width: 60px;font-size: 12px !important;" class="h_1 hh">Código</th>
            </tr>
            </thead>
            <tbody>
            <elm:poneHtml textoHtml="${filasF}"/>
            </tbody>
        </table>
    </div>

    <div style="width: 1100px;overflow-x: auto;" class="scroll-pane">
        <table class="table table-bordered table-condensed" id ="matriz" style="width: ${cols.size() * 120 - 90}px; max-width: ${cols.size() * 120 - 90}px;float:left">
            <thead style="height: 120px">
            <tr style="font-size: 10px !important;">
                <th style="width: 320px !important;;font-size: 12px !important">Rubro</th>
                <th style="width: 30px;;font-size: 12px !important">Unidad</th>
                <th style="width: 60px;;font-size: 12px !important">Cantidad</th>
                <g:each in="${cols}" var="c" status="k">
                    <g:if test="${c[2] != 'R'}">
                        <th style="width: 120px;font-size: 12px !important" class="c_${k}" c="${k}">${c[1]}</th>
                    </g:if>
                </g:each>
            </tr>
            </thead>
            <tbody id="tableBody" class="scroll-content">
            <elm:poneHtml textoHtml="${filas}"/>
            </tbody>
            <tfoot>
            <tr id="bandera">
            </tr>
            </tfoot>
        </table>
    </div>
</div>

<script type="text/javascript">

    var ban = 0;
    var inicio = 2;
    var fin = false;
    var ultimo = 1;
    var ctrl = 0;

    function cargar(){
        cargarLoader("Cargando...")
    }

    $("body").keydown(function (ev) {
        if (ev.keyCode === 17)
            ctrl = 600;
        if (ev.keyCode === 16)
            ctrl = 60000
    });

    var interval = setInterval(function () {
        if ($("#bandera:onScreen").attr("id")) {
            if (!fin) {
//                    if (inicio > ultimo) {
//                        $("#dlgLoad").dialog("open");
//                        fin = cargarDatosAsinc(inicio, "interval", 20)
//                        ultimo = inicio
//                        if (!fin)
//                            inicio++
//                        $(document).scrollTop($(document).scrollTop() - 300)
//                    }
            } else {
                clearInterval(interval)
            }
        }
    }, 2000);

    $(".rb").bind("click", function () {
        if (ban == 0) {
            if ($(this).hasClass("a1")) {
                $("." + $(this).attr("f")).addClass($(".a1").attr("color")).removeClass("a1")
            } else {
                $(this).addClass("a1")
                $("." + $(this).attr("f")).addClass("a1");
                $("." + $(this).attr("f")).removeClass("gr");
                $("." + $(this).attr("f")).removeClass("bl")
            }
        }
    });

    $("th").click(function () {
        var clase = "c_" + $(this).attr("c");
        if ($(this).hasClass("sc")) {
            $("." + clase).removeClass("sc")
        } else {
            $("." + clase).addClass("sc")
        }
    });

    $("body").keyup(function (ev) {
        if (ev.keyCode === 17)
            ctrl = 0;
        if (ev.keyCode === 16)
            ctrl = 0;
        if (ev.keyCode === 37) {
            var leftPos = $('.scroll-pane').scrollLeft();
            $(".scroll-pane").animate({scrollLeft: leftPos - (300 + ctrl)}, 800);

        }
        if (ev.keyCode == 39) {
            var leftPos = $('.scroll-pane').scrollLeft();
            $(".scroll-pane").animate({scrollLeft: leftPos + 300 + ctrl}, 800);
        }
    });

    $("#buscar").click(function () {
        buscarColumna();
    });

    function buscarColumna(){
        var par = $("#texto_busqueda").val();
        var primero = null;
        if (par.length > 0) {
            var mayus = par.toUpperCase();
            $("th").each(function () {
                if ($(this).html().toUpperCase().match(mayus)) {
                    if (!$(this).hasClass("sc"))
                        $(this).click();
                    if (!primero)
                        primero = $(this)
                }
            });
            if (primero) {
                var leftPos = $('.scroll-pane').scrollLeft() + 500;
                var pos = primero.position().left - 500;
                $(".scroll-pane").animate({scrollLeft: leftPos + pos - 500}, 800);
            }
        }
    }

    $("#reset").click(function () {
        $(".a1").addClass($(".a1").attr("color")).removeClass("a1");
        $(".sc").removeClass("sc")
    });

    function fp(url) {
        $("#dlgLoad").dialog("open");
        $.ajax({
            async: false,
            type: "POST",
            url: url,
            success: function (msg2) {
                var arr = msg2.split("_");
                var msg_ok = arr[0];
                var sbpr = arr[1];
                if (msg_ok === "ok" || msg_ok === "OK") {
                    location.href = "${createLink(controller: 'formulaPolinomica', action: 'coeficientes', id:obra)}?sbpr=" + sbpr;
                }
            }
        });
    }

    $(".btnFormula").click(function () {
        var url = $(this).attr("href");
        $.ajax({
            type    : "POST",
            async   : false,
            url     : "${createLink(controller: 'obra', action: 'existeFP')}",
            data    : {
                obra : "${obra}"
            },
            success : function (msg) {
                if (msg === "true" || msg === true) {
                    fp(url);
                } else {
                    bootbox.confirm({
                        title: "Confirmación",
                        message: "<strong style='font-size: 14px'> Asegúrese de que ya ha ingresado todos los rubros para generar la fórmula polinómica. </strong>",
                        buttons: {
                            cancel: {
                                label: '<i class="fa fa-times"></i> Cancelar',
                                className: 'btn-primary'
                            },
                            confirm: {
                                label: '<i class="fa fa-check"></i> Aceptar',
                                className: 'btn-success'
                            }
                        },
                        callback: function (result) {
                            if(result){
                                var g = cargarLoader("Borrando...");
                                <g:if test="${params.sbpr}">
                                fp(url);
                                </g:if>
                                <g:else>
                                g.modal("hide");
                                bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "No existen valores ingresados" + '</strong>');
                                </g:else>
                            }
                        }
                    });
                }
            }
        });
        return false;
    });

    $( document ).ready(function() {
        var rowCount = $('#matriz tr').length;
        var ht = 0;
        var contador = ${cont + 1}
        for (i = 0; i < rowCount; i++) {
            ht = $("#r" + (i + contador)).innerHeight();
            $("#rf" + (i + contador)).css({"height": ht})
        }
    });

    $("#texto_busqueda").keydown(function (ev) {
        if (ev.keyCode === 13) {
            buscarColumna();
        }
    });

</script>

</body>
</html>