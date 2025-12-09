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
            <li texto="crs" class="item col-md-12">
                <a href="#" id="btnReporteExcelCRS" style="color: #FFFDF4" class="btn btn-success btn-xs col-md-4">
                    <i class="fa fa-file-excel"></i> Contratos resumen
                </a>
                <p class="col-md-8"> Resumen de contratos </p>
            </li>
            <li texto="cdg" class="item col-md-12">
                <a href="#" id="btnReporteExcelCDG" style="color: #FFFDF4" class="btn btn-success btn-xs col-md-4">
                    <i class="fa fa-file-excel"></i> Contratos datos generales
                </a>
                <p class="col-md-8"> Datos generales de los contratos </p>
            </li>
            <li texto="cdp" class="item col-md-12">
                <a href="#" id="btnReporteExcelCDP" style="color: #FFFDF4" class="btn btn-success btn-xs col-md-4">
                    <i class="fa fa-file-excel"></i> Contratos detalle proyectos
                </a>
                <p class="col-md-8"> Datos generales de los contratos </p>
            </li>
        </ul>
    </div>

    <div id="tool" class="leyenda ui-widget-content ui-corner-all">
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