<%@ page import="janus.Obra" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="mainMatriz">
    <title>
        ${titulo}
    </title>
    <style type="text/css">
    .gris {
        background-color : #ececec;
    }

    .activo {
        background-color : rgba(255, 172, 55, 0.8);
        font-weight      : bold;
    }

    .blanco {
        background-color : transparent;
    }

    .estaticas {
        background  : linear-gradient(to bottom, #FFFFFF, #E6E6E6);
        font-weight : bold;
    }

    tr {
        cursor : pointer !important;
    }

    th {
        padding-left  : 0px;
        padding-right : 0px;
    }

    td {
        line-height : 12px !important;
        padding     : 3px !important;
    }

    .selectedColumna {
        background-color : rgba(120, 220, 249, 0.4);
        font-weight      : bold;
    }
    .mano{
        background-color :rgba(244,198,162,0.5) ;
    }
    .saldo{
        background-color : #ffcfd6;
    }
    .totalCol{
        background-color : #85d0c9;
    }
    </style>

    <script type="text/javascript">
        $("#dlgLoad").dialog("open");
    </script>
</head>

<body>
<div class="col-md-12">
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

<div id="list-grupo" class="col-md-12" role="main" style="margin-top: 10px;margin-left: 0;width: 100%;max-width: 100%;overflow-x: hidden">
    <div style="width: 1060px;overflow-x: auto;max-width: 1050px;" class="scroll-pane">
        <table class="table table-bordered table-condensed" style="width: ${cols.size() * 120 - 90}px;max-width: ${cols.size() * 120 - 90}px;">
            <thead>
            <tr style="font-size: 10px !important;" id="ht">
                <th style="width: 20px;max-width: 30px;font-size: 12px !important" class="h_0">#</th>
                <th style="width: 60px;;font-size: 12px !important" class="h_1">Código</th>
                <th style="width: 320px !important;;font-size: 12px !important">Rubro</th>
                <th style="width: 30px;;font-size: 12px !important">Unidad</th>
                <th style="width: 60px;;font-size: 12px !important">Cantidad</th>
                <g:each in="${cols}" var="c" status="k">
                    <g:if test="${c[2] != 'R'}">
                        <th style="width: 120px;font-size: 12px !important" class="col_${k}" col="${k}">
                            <elm:poneHtml textoHtml="${c[1]}"/></th>
                    </g:if>
                </g:each>
            </tr>
            </thead>
            <tbody id="tableBody" class="scroll-content">
            </tbody>
            <tfoot>

            </tfoot>
        </table>
    </div>
</div>

<div id="div_hidden" style="display: none">
    <table class="table table-bordered table-condensed  " style="width: ${cols.size() * 120 - 90}px;max-width: ${cols.size() * 120 - 90}px;float:left">
        <thead>
        <tr style="font-size: 10px !important;">
            <th style="width: 20px;max-width: 30px;font-size: 12px !important" class="h_0">#</th>
            <th style="width: 60px;;font-size: 12px !important" class="h_1">Código</th>
            <th style="width: 320px !important;;font-size: 12px !important">Rubro</th>
            <th style="width: 30px;;font-size: 12px !important">Unidad</th>
            <th style="width: 60px;;font-size: 12px !important">Cantidad</th>
            <g:each in="${cols}" var="c">
                <g:if test="${c[2] != 'R'}">
                    <th style="width: 120px;font-size: 12px !important">${c[1]}</th>
                </g:if>
            </g:each>
        </tr>
        </thead>
        <tbody id="tableBody_hid">

        </tbody>
    </table>
</div>
<script type="text/javascript">
    function cargarDatos(inicio, interval, limite) {
        // var p = cargarLoader("Cargando...");
        var band = false;
        $.ajax({
            type    : "POST",
            url     : "${createLink(action: 'matrizPolinomica',controller: 'matriz')}",
            data    : "id=${obra}&inicio=" + inicio + "&limit=" + limite + "&sbpr=${sbpr}",
            success : function (msg) {
                $("#dlgLoad").dialog("close");
                // p.modal("hide");
                if (msg !== "fin") {
                    if (inicio === 0) {
                        $("#tableBody").append(msg);
                        copiaTabla()
                    } else {
                        $("#tableBody_hid").append(msg);
                        appendTabla()
                    }
                } else {
                    band = true
                }
            }
        });
        return band
    }
    function cargarDatosAsinc(inicio, interval, limite) {
        // var p = cargarLoader("Cargando...");
        var band = false;
        $.ajax({
            type    : "POST",
            url     : "${createLink(action: 'matrizPolinomica',controller: 'matriz')}",
            data    : "id=${obra}&inicio=" + inicio + "&limit=" + limite + "&sbpr=${sbpr}",
            async   : false,
            success : function (msg) {
                // p.modal("hide");
                $("#dlgLoad").dialog("close");
                if (msg !== "fin") {

                    if (inicio === 0) {
                        $("#tableBody").append(msg);
                        copiaTabla()
                    } else {
                        $("#tableBody_hid").append(msg);
                        appendTabla()
                    }
                } else {
                    band = true
                }
            }
        });
        return band
    }

    var ban = 0;

    function copiaTabla() {
        var tabla = $('<table class="table table-bordered  table-condensed " id="tablaHeaders" style="width:140px;max-width: 140px;float: left">')
        var ht = $("#ht").innerHeight();
        $("#ht").css({"height" : ht});
        tabla.append('<thead><tr style="height:' + ht + 'px ;" ><th style="width: 20px;max-width: 20px;font-size: 12px !important">#</th><th style="width: 80px;;font-size: 12px !important" >Código</th></tr></thead>');
        var body = $('<tbody id="body_headers">');
        var cnt = 0;
        $(".item_row").each(function () {
            var tr = $("<tr class='item_row fila_" + cnt + "' fila='fila_" + cnt + "'>");
            tr.css({"height" : $(this).innerHeight()});
            tr.attr("color", $(this).attr("color"));
            $(this).css({"height" : $(this).innerHeight()});
            var col0 = $(this).find(".col_0");
            var col1 = $(this).find(".col_1");
            var c0 = col0.clone();
            var c1 = col1.clone();
            c0.removeClass("col_0").addClass("estaticas");
            c1.removeClass("col_1").addClass("estaticas codigos");
            tr.append(c0);
            tr.append(c1);
            cnt++;
            body.append(tr)

        });
        tabla.append(body);
        $("#list-grupo").prepend(tabla);
        $(".h_0").remove();
        $(".h_1").remove();
        $(".col_0").remove();
        $(".col_1").remove();

        $(".item_row").bind("click", function () {
            if(ban === 0){
                if ($(this).hasClass("activo")) {

                    $("." + $(this).attr("fila")).addClass($(".activo").attr("color")).removeClass("activo")
                } else {
                    $(this).addClass("activo");
                    $("." + $(this).attr("fila")).addClass("activo");
                    $("." + $(this).attr("fila")).removeClass("gris");
                    $("." + $(this).attr("fila")).removeClass("blanco");
                }
            }
        });
    }

    function appendTabla() {
        var tabla = $("#body_headers");
        ban = 1;
        $("#tableBody_hid").find(".item_row").each(function () {
            var col0 = $(this).find(".col_0");
            var col1 = $(this).find(".col_1");
            var c0 = col0.clone();
            var c1 = col1.clone();
            var num = $(this).attr("num");
            col0.remove();
            col1.remove();
            $("#tableBody").append($(this));
            var tr = $("<tr class='item_row fila_" + num + "' fila='fila_" + num + "'>");
            tr.css({"height" : $(this).innerHeight()});
            tr.attr("color", $(this).attr("color"));
            $(this).css({"height" : $(this).innerHeight()});
            c0.removeClass("col_0").addClass("estaticas");
            c1.removeClass("col_1").addClass("estaticas");
            tr.append(c0);
            tr.append(c1);
            tabla.append(tr);
        });
        $(".item_row").bind("click", function () {
            if ($(this).hasClass("activo")) {
                $("." + $(this).attr("fila")).addClass($(".activo").attr("color")).removeClass("activo")
            } else {
                $(this).addClass("activo");
                $("." + $(this).attr("fila")).addClass("activo");
                $("." + $(this).attr("fila")).removeClass("gris");
                $("." + $(this).attr("fila")).removeClass("blanco");
            }
        });

    }
    $(function () {
        $("#dlgLoad").dialog("open");
        var inicio = 0;
        cargarDatosAsinc(inicio, "interval", 40);
        inicio = 2;
        var fin = false;
        var ultimo = 1;
        var ctrl = 0;
        $("body").keydown(function (ev) {
            if (ev.keyCode === 17)
                ctrl = 600;
            if (ev.keyCode === 16)
                ctrl = 60000
        });

        var interval = setInterval(function () {
            if ($("#bandera:onScreen").attr("id")) {
                if (!fin) {
                    if (inicio > ultimo) {
                        $("#dlgLoad").dialog("open");
                        fin = cargarDatosAsinc(inicio, "interval", 20);
                        ultimo = inicio;
                        if (!fin)
                            inicio++;
                        $(document).scrollTop($(document).scrollTop() - 300)
                    }
                } else {
                    clearInterval(interval)
                }
            }
        }, 2000);

        $("th").click(function () {
            var clase = "col_" + $(this).attr("col");
            if ($(this).hasClass("selectedColumna")) {
                $("." + clase).removeClass("selectedColumna")
            } else {
                $("." + clase).addClass("selectedColumna")
            }
        });

        $("body").keyup(function (ev) {
            if (ev.keyCode === 17)
                ctrl = 0;
            if (ev.keyCode === 16)
                ctrl = 0;
            if (ev.keyCode === 37) {
                var leftPos = $('.scroll-pane').scrollLeft();
                $(".scroll-pane").animate({scrollLeft : leftPos - (300 + ctrl)}, 800);
            }
            if (ev.keyCode === 39) {
                var leftPos = $('.scroll-pane').scrollLeft();
                $(".scroll-pane").animate({scrollLeft : leftPos + 300 + ctrl}, 800);
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
                        if (!$(this).hasClass("selectedColumna"))
                            $(this).click();
                        if (!primero)
                            primero = $(this)
                    }
                });
                $("#body_headers").find(".codigos").each(function () {
                    var mayus = par.toUpperCase();
                    if ($(this).html().toUpperCase().match(mayus)) {
                        if (!$(this).hasClass("activo"))
                            $(this).click();
                    }
                });

                if (primero) {
                    var leftPos = $('.scroll-pane').scrollLeft() + 500;
                    var pos = primero.position().left - 500;
                    $(".scroll-pane").animate({scrollLeft : leftPos + pos - 500}, 800);
                }
            }
        }

        $("#reset").click(function () {
            $(".activo").addClass($(".activo").attr("color")).removeClass("activo");
            $(".selectedColumna").removeClass("selectedColumna")
        });

        function fp(url) {
            $("#dlgLoad").dialog("open");
            $.ajax({
                async   : false,
                type    : "POST",
                url     : url,
                success : function (msg2) {
                    var arr = msg2.split("_");
                    var msg_ok = arr[0];
                    var sbpr = arr[1];
                    if (msg_ok === "ok" || msg_ok === "OK") {
                        location.href = "${createLink(controller: 'formulaPolinomica', action: 'coeficientesFp', id:obra)}?sbpr="+sbpr;
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
                        //ya hay la fp
                        fp(url);
                    } else {
                        //no hay la fp
                        bootbox.confirm({
                            title: "Confirmación",
                            message: "Asegúrese de que ya ha ingresado todos los rubros para generar la fórmula polinómica.",
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

        $("#texto_busqueda").keydown(function (ev) {
            if (ev.keyCode === 13) {
                buscarColumna();
            }
        });


    });




</script>
</body>
</html>