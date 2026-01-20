<html>
<head>
    <meta name="layout" content="main">
    <title>Reportes Contratos</title>

    <style type="text/css">
    .lista, .desc {
        float: left;
        min-height: 150px;
        margin-left: 25px;
    }

    .lista {
        width: 670px;
    }

    .desc {
        width: 265px;
    }

    .link {
        font-weight: bold;
        text-decoration: none;
    }

    .noBullet {
        list-style: none;
        margin: 1em;
        padding: 0;
    }

    .noBullet li {
        margin-bottom: 10px;
    }

    .linkHover {
        text-decoration: overline underline;
    }

    .leyenda {
        float: left;
        width: 260px;
        height: 360px;
        margin-top: 20px;
        margin-left: 30px;
        display: none;
        padding: 15px;
    }

    </style>

</head>

<body>

<div class="contenedor">

    <h2 style="margin-left: 110px"><i class="icon-print"></i> Reportes del Sistema (Contratos)</h2>

    <div class="ui-widget-content ui-corner-all lista">
        <ul class="noBullet">

            <li text="comp" class="item col-md-12" texto="comp">
                <g:link controller="reportesExcel" style="color: #FFFDF4" action="contratoFechas" file=""
                        class="btn btn-warning btn-xs col-md-4">
                    <i class="fa fa-print"></i> Detalle de Contratos <br> y Obras contratadas
                </g:link>
                <p class="col-md-8">Reporte en Excel de los contratos y obras contratadas incluyendo valores
                planillados y fechas de las actas.</p>
            </li>
            <li text="cob" class="item col-md-12" texto="cob">
                <g:link controller="reportes5" style="color: #FFFDF4" action="componentesObraPdf" file=""  class="btn btn-warning btn-xs col-md-4">
                    <i class="fa fa-print"></i> Componentes de obra
                </g:link>
                <p class="col-md-8"> Genera el reporte PDF de componentes de obra detallando precio, cantidad y el
                número de presupuestos en los cuales figura este ítem.</p>
            </li>
            <li text="inu" class="item col-md-12" texto="inu">
                <g:link controller="reportes5" style="color: #FFFDF4" action="itemsNoUsadosPdf" file="" class="btn btn-warning btn-xs col-md-4">
                    <i class="fa fa-print"></i> Items no usados
                </g:link>
                <p class="col-md-8"> Genera el reporte PDF de ítems no usados en los presupuestos.</p>
            </li>

            <li texto="crs" class="item col-md-12">
                <a href="#" id="btnReporteExcelCRS" style="color: #FFFDF4" class="btn btn-success btn-xs col-md-4">
                    <i class="fa fa-file-excel"></i> Contratos resumen
                </a>
                <p class="col-md-8">Hoja de Cálculo y Gráfico del resumen de contratos en un periodo de fechas, este
                reporte muestra una hoja de cálculo con el resumen de cantidad de obras, valores contratados, ..</p>
            </li>
            <li texto="cdg" class="item col-md-12">
                <a href="#" id="btnReporteExcelCDG" style="color: #FFFDF4" class="btn btn-success btn-xs col-md-4">
                    <i class="fa fa-file-excel"></i> Contratos datos generales
                </a>
                <p class="col-md-8">Hoja de cálculo con un reporte de resumen de los contratos con datos de: número de
                contrato, objeto del contrato,	código contrato complementario, tipo de obra, dirección ejecutoria</p>
            </li>
            <li texto="cdp" class="item col-md-12">
                <a href="#" id="btnReporteExcelCDP" style="color: #FFFDF4" class="btn btn-success btn-xs col-md-4">
                    <i class="fa fa-file-excel"></i> Contratos detalle proyectos
                </a>
                <p class="col-md-8">Crea un resumen de contratos con: Datos del proyecto: Análisis económico: Análisis
                físico, Recepciones y datos del Contratista:</p>
            </li>
        </ul>
    </div>

    <div id="tool" class="leyenda ui-widget-content ui-corner-all">
    </div>

    <div id="cob" style="display: none">
        <h3>Reporte de componentes de obra</h3><br>
        <p>Componentes más usados en las obras</p>
    </div>

    <div id="inu" style="display: none">
        <h3>Reporte de items no usados</h3><br>
        <p>Items no usados</p>
    </div>

    <div id="cdg" style="display: none">
        <h3>Reporte excel de contratos</h3><br>
        <p>Datos generales</p>
    </div>
</div>


<script type="text/javascript">

    $("#btnReporteExcelCRS").click(function () {
        $.ajax({
            type    : "POST",
            url: "${createLink(controller: 'reportes5', action:'reporteExcelCDG_ajax')}",
            data    : {},
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgImprimirExcelCRS",
                    title   : "Contratos Resumen (Excel)",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        guardar  : {
                            id        : "btnSave",
                            label     : "<i class='fa fa-file-excel'></i> Excel",
                            className : "btn-success",
                            callback  : function () {
                                location.href="${createLink(controller: 'reportesExcel2', action: 'reporteExcelContratosResumen')}?desde=" + $("#fechaDesdeCDG").val() + "&hasta=" + $("#fechaHastaCDG").val();
                            } //callback
                        }, //guardar
                        grafico  : {
                            id        : "btnGrafico",
                            label     : "<i class='fa fa-file-image'></i> Gráfico",
                            className : "btn-info",
                            callback  : function () {
                                location.href="${createLink(controller: 'reportes6', action: 'graficoContratosResumen')}?desde=" + $("#fechaDesdeCDG").val() + "&hasta=" + $("#fechaHastaCDG").val();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    });

    $("#btnReporteExcelCDP").click(function () {
        $.ajax({
            type    : "POST",
            url: "${createLink(controller: 'reportes5', action:'reporteExcelCDG_ajax')}",
            data    : {},
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgImprimirExcelCDG",
                    title   : "Contratos Datos Proyectos (Excel)",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        guardar  : {
                            id        : "btnSave",
                            label     : "<i class='fa fa-file-excel'></i> Excel",
                            className : "btn-success",
                            callback  : function () {
                                location.href="${createLink(controller: 'reportesExcel2', action: 'reporteExcelContratosDetallesProyectos')}?desde=" + $("#fechaDesdeCDG").val() + "&hasta=" + $("#fechaHastaCDG").val();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    });

    $("#btnReporteExcelCDG").click(function () {
        $.ajax({
            type    : "POST",
            url: "${createLink(controller: 'reportes5', action:'reporteExcelCDG_ajax')}",
            data    : {},
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgImprimirExcelCDG",
                    title   : "Contratos Datos Generales (Excel)",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        guardar  : {
                            id        : "btnSave",
                            label     : "<i class='fa fa-file-excel'></i> Excel",
                            className : "btn-success",
                            callback  : function () {
                                location.href="${createLink(controller: 'reportesExcel2', action: 'reporteExcelContratosDatosGenerales')}?desde=" + $("#fechaDesdeCDG").val() + "&hasta=" + $("#fechaHastaCDG").val();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    });

    $(document).ready(function () {
        $('.item').hover(function () {
            //$('.item').click(function(){
            //entrar
            $('#tool').html($("#" + $(this).attr('texto')).html());
            $('#tool').show();
        }, function () {
            //sale
            $('#tool').hide();
        });

        $('#info').tabs({
            cookie: { expires: 30 },
            event: 'click', fx: {
                opacity: 'toggle',
                duration: 'fast'
            },
            spinner: 'Cargando...',
            cache: true
        });
    });

</script>

</body>
</html>