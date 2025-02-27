<html>
<head>
    <meta name="layout" content="main">
    <title>Reportes</title>

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

    <g:if test="${flash.message}">
        <div class="message ${flash.clase}" role="status"><span
                class="ss_sprite ${flash.ico}">&nbsp;</span>${flash.message}
        </div>
    </g:if>

    <h2 style="margin-left: 110px"><i class="icon-print"></i> Reportes del Sistema</h2>

    <div class="ui-widget-content ui-corner-all lista">
        <ul class="noBullet">
            <li text="obrargst" class="item col-md-12" texto="obrargst">
                <g:link controller="reportes4" action="registradas" class="btn btn-primary btn-xs col-md-4"
                        style="color: #FFFDF4" dialog="dlgContabilidad">
                    <i class="fa fa-print"></i> Obras ingresadas
                </g:link>
                <p class="col-md-8">Listado de obras que se encuentran en el sistema, estas obras están an la fase inicial de estructuración de presupuestos
                y de documentos precontractuales. Estado = 'N'
                </p>
            </li>
            <li text="obraprsp" class="item col-md-12" texto="obraprsp">
                <g:link controller="reportes4" action="presuestadasFinal" class="btn btn-primary btn-xs col-md-4" style="color: #FFFDF4">
                    <i class="fa fa-print"></i> Obras presupuestadas:
                </g:link>
                <p class="col-md-8">  Listado de obras que ya poseen un presupuesto elaborado y se encuentran listas para entrar en el proceso de
                contratación. Estado = 'N'
                </p>
            </li>
            <li text="obraprsp1" class="item col-md-12" texto="obraprsp1">
                <g:link controller="reportes4" action="presupuesto" class="btn btn-primary btn-xs col-md-4" style="color: #FFFDF4">
                    <i class="fa fa-print"></i> Obras para presupuesto:
                </g:link>
                <p class="col-md-8">  Listado de obras que ya poseen un presupuesto elaborado y se encuentran listas para entrar en el proceso de
                contratación. Estado = 'R'
                </p>
            </li>
            <li text="cncr" class="item col-md-12" texto="cncr">
                <g:link controller="concurso" action="concursos" file="concursos" class="btn btn-primary btn-xs col-md-4" style="color: #FFFDF4"
                        dialog="dlgContabilidadPeriodo">
                    <i class="fa fa-print"></i> Procesos de contratación:
                </g:link>
                <p class="col-md-8">Listado de procesos de contratación para la construcción de obras y para consultorías.</p>
            </li>
            <li text="obracntr" class="item col-md-12" texto="obracntr">
                <g:link controller="reportes4" action="contratadas" class="btn btn-primary btn-xs col-md-4" style="color: #FFFDF4"
                        dialog="dlgContabilidad">
                    <i class="fa fa-print"></i> Obras contratadas:
                </g:link>
                <p class="col-md-8"> Listado de obras que se encuentran contratadas </p>
            </li>
            <li text="cntr" class="item col-md-12" texto="cntr">
                <g:link controller="reportes4" action="contratos" class="btn btn-primary btn-xs col-md-4" style="color: #FFFDF4">
                    <i class="fa fa-print"></i> Contratos:
                </g:link>
                <p class="col-md-8">Listado de contratos de obras y consultorías registrados en el sistema.</p>
            </li>

            <li text="prve" class="item col-md-12" texto="prve">
                <g:link controller="reportes4" action="contratistas" class="btn btn-primary btn-xs col-md-4" style="color: #FFFDF4">
                    <i class="fa fa-print"></i> Contratistas:
                </g:link>
                <p class="col-md-8"> Listado de contratistas que han firmado contratos de obras y consultoría con el GADLR. </p>
            </li>

            <li text="asgr" class="item col-md-12" texto="asgr">
                <g:link controller="reportes4" action="aseguradoras" class="btn btn-primary btn-xs col-md-4" style="color: #FFFDF4">
                    <i class="fa fa-print"></i> Aseguradoras:
                </g:link>
                <p class="col-md-8">Listado de aseguradoras que se encuentran registradas en el sistema que han emitido garantías.</p>
            </li>

            %{--<li text="grnt" class="item col-md-12" texto="grnt">--}%
                %{--<g:link controller="reportes4" action="garantias" class="btn btn-primary btn-xs col-md-4" style="color: #FFFDF4">--}%
                    %{--<i class="fa fa-print"></i> Garantías--}%
                %{--</g:link>--}%
                %{--<p class="col-md-8"> Listado de garantías registradas de los distintos contratos para obras y cosultoría, detalladas por contrato. </p>--}%
            %{--</li>--}%
            <li text="avob" class="item col-md-12" texto="avob">
                <g:link controller="reportes5" action="avance" file="Estado_Cambios_Patrimonio.pdf" class="btn btn-primary btn-xs col-md-4" style="color: #FFFDF4" dialog="dlgVentas">
                    <i class="fa fa-print"></i> Avance de obras:
                </g:link>
                <p class="col-md-8">Listado de obras con el respectivo porcentaje de avance.</p>
            </li>
            <li text="obrasus" class="item col-md-12" texto="obrasus">
                <g:link controller="reportes4" action="suspendidas" class="btn btn-primary btn-xs col-md-4" style="color: #FFFDF4">
                    <i class="fa fa-print"></i> Obras suspendidas:
                </g:link>
                <p class="col-md-8"> Listado de obras que se encuentran suspendidas </p>
            </li>
            <li text="obfn" class="item col-md-12" texto="obfn">
                <g:link controller="obra" action="obrasFinalizadas" file="" class="btn btn-primary btn-xs col-md-4" style="color: #FFFDF4" dialog="dlgVentas">
                    <i class="fa fa-print"></i> Obras finalizadas:
                </g:link>
                <p class="col-md-8">Listado de obras finalizadas.</p>
            </li>
            <li text="obcp" class="item col-md-12" texto="obcp">
                <g:link controller="reportes4" action="obrasComparadas" file="" class="btn btn-primary btn-xs col-md-4" style="color: #FFFDF4">
                    <i class="fa fa-print"></i> Comparación de rubros <br>contratados vs Presupuestados
                </g:link>
                <p class="col-md-8">Rubros contratados comparados con los rubros presupuestados para verificación
                de precios y rendimientos. </p>
            </li>
            <li text="comp" class="item col-md-12" texto="comp">
                <g:link controller="reportesExcel" style="color: #FFFDF4" action="contratoFechas" file=""
                        class="btn btn-warning btn-xs col-md-4">
                    <i class="fa fa-print"></i> Detalle de Contratos <br> y Obras contratadas
                </g:link>
                <p class="col-md-8">Reporte en Excel de los contratos y obras contratadas inluyendo valores planillados y fechas de las actas</p>
            </li>
            <li text="cob" class="item col-md-12" texto="cob">
                <g:link controller="reportes5" style="color: #FFFDF4" action="componentesObraPdf" file=""  class="btn btn-warning btn-xs col-md-4">
                    <i class="fa fa-print"></i> Componentes de obra
                </g:link>
                <p class="col-md-8">Genera el reporte PDF de componentes de obra</p>
            </li>
            <li text="inu" class="item col-md-12" texto="inu">
                <g:link controller="reportes5" style="color: #FFFDF4" action="itemsNoUsadosPdf" file="" class="btn btn-warning btn-xs col-md-4">
                    <i class="fa fa-print"></i> Items no usados
                </g:link>
                <p class="col-md-8"> Genera el reporte PDF de items no usados </p>
            </li>
        </ul>
    </div>

    <div id="tool" class="leyenda ui-widget-content ui-corner-all">
    </div>

    <div id="obrargst" style="display: none">
        <h3>Obras Ingresadas</h3><br>

        <p>Listado de obras que están ingresadas al sistema. Estas obras se hallan en la fase inicial de registro de
        cantidades de obra, elaboración de la matriz de la fórmula polinómica, fórmula polinómica, determinación de
        plazos y cronograma de ejecución.</p>
        <p>En esta fase se preparan los documentos precontractuales.</p>
        <p>Estado = 'N'</p>
    </div>

    <div id="obraprsp" style="display: none;">
        <h3>Obras Presupuestadas</h3><br>

        <p>Listado de obras que ya cuentan con presupuestos elaborados. Estas obras se hallan listas para entrar en el proceso de
        contratación.</p>
        <p>Cada una de estas obras cuenta con el registro de volúmenes de obra, la matriz de la fórmula
        polinómica, la fórmula polinómica, el cronograma y los documentos precontractuales.</p>
    </div>

    <div id="cncr" style="display: none">
        <h3>Proceso de contratación</h3><br>
        <p>Listado de procesos para la contratación de obras y consultorías. </p>
        <p>Desde este reporte se puede acceder al presupuesto de la obra y a detalle del proceso de contratación.</p>
    </div>

    <div id="obracntr" style="display: none">
        <h3>Obras Contratadas</h3><br>

        <p>Listado de obras que se hallan contratadas, con los datos más relevantes del contrato.</p>
        <p>Desde este reporte se puede acceder al presupuesto de la obra y a detalle del proceso de contratación.</p>
    </div>

    <div id="cntr" style="display: none">
        <h3>Contratos</h3><br>

        <p> Listado de contratos registrados en el sistema.</p>
        <p>Desde este reprote se puede visualizar el contrato con su cronograma y fórmula polinómica.</p>
    </div>

    <div id="prve" style="display: none">
        <h3>Contratistas</h3><br>
        <p>  Listado de contratistas que han firmado contratos de ejecución de obras y cnsultorías con el GADLR.</p>
    </div>

    <div id="asgr" style="display: none">
        <h3>Aseguradoras</h3><br>
        <p> Listado de aseguradoras que se hallan registradas en el sistema y que han emitido garantías en los diferentes contratos.</p>
    </div>

    <div id="grnt" style="display: none">
        <h3>Garantías por contrato y contratista</h3><br>
        <p> Listado de garantías detalladas por contrato, indicando el tipo de garantía, vigencia y valores</p>
    </div>

    <div id="trnf" style="display: none">
        <h3>Trasferencias y/o cheques pagados</h3><br>

        <p>Listado de pagos de planillas realizados de las distintas obras contratadas. </p>
    </div>

    <div id="avob" style="display: none">
        <h3>Avance de obras</h3><br>

        <p>  Listado de obras con el respectivo porcentaje de avance físico y económico.</p>
    </div>

    <div id="obfn" style="display: none">
        <h3>Obras finalizadas</h3><br>

        <p>Listado de obras finalizadas.</p>
        <p>Estas obras cuentan ya con el acta de entrega - rececpción provicional o definitiva.</p>
        <p>El reprote muestra fechas de inicio de obra y fechas de la firma de actas.</p>
    </div>

    <div id="cnfc" style="display: none">
        <h3>Detalle de contratos</h3><br>

        <p>Listado de contratos</p>
        <p>Obras contratadas, monto, plazo y valores totales planillados</p>
        <p>Fechas de contrato, inicio de obra, recepción de obra y actas de entrega - recepción provisional y definitiva</p>
    </div>

    <div id="comp" style="display: none">
        <h3>Comparación de rubros</h3><br>

        <p>Listado de contratos con preupuesto externo</p>
        <p>Rubros contratados comparados con los rubros presupuestados para verificación de precios y rendimientos.</p>
    </div>

    <div id="cob" style="display: none">
        <h3>Reporte de componentes de obra</h3><br>
        <p>Componentes más usados en las obras</p>
    </div>

    <div id="inu" style="display: none">
        <h3>Reporte de items no usados</h3><br>
        <p>Items no usados</p>
    </div>
</div>

<div id="dlgContabilidad" class="ui-helper-hidden">
    Contratos:
    <g:select name="cont" from="${Contratos.findAll()}" optionKey="id" optionValue="Contrato"
              class="ui-widget-content ui-corner-all"/>
</div>

<div id="dlgComprobante" class="ui-helper-hidden">
    Comprobante: <g:textField type="text" class="ui-widget-content ui-corner-all" name="comprobante"/> <a href="#"
                                                                                                          id="btnComprobantes">Buscar</a>
</div>

<div id="dlgVentas">
    Desde: <elm:datepicker class="field ui-corner-all" title="Desde" name="fechaPago" format="yyyy-MM-dd"
                           style="width: 80px" id="desde"/>
    Hasta: <elm:datepicker class="field ui-corner-all" title="Hasta" name="fechaPago" format="yyyy-MM-dd"
                           style="width: 80px" id="hasta"/>
</div>

<div id="dlgContabilidadPeriodo" class="ui-helper-hidden">
    <div>
        Contabilidad:
        %{--
                        <g:select name="contP" id="contP" from="${cratos.Contabilidad.findAllByInstitucion(session.empresa, [sort: 'fechaInicio'])}" optionKey="id" optionValue="descripcion"
                                  class="ui-widget-content ui-corner-all"/>
        --}%
    </div>

    <div id="divPeriodo">
        Periodo:
    </div>
</div>

<script type="text/javascript">

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
            //event: 'mouseover', fx: {
            cookie: { expires: 30 },
            event: 'click', fx: {
                opacity: 'toggle',
                duration: 'fast'
            },
            spinner: 'Cargando...',
            cache: true
        });
    });

    var actionUrl = "";

    function updatePeriodo() {
        var cont = $("#contP").val();

        $.ajax({
            type: "POST",
            url: "${createLink(action:'updatePeriodo')}",
            data: {
                cont: cont
            },
            success: function (msg) {
                $("#divPeriodo").html(msg);
            }
        });

//                console.log(cont);
    }

    $(function () {

        $(".link").hover(
            function () {
                /*
                                    $(this).addClass("linkHover");
                                    $(".notice").hide();
                                    var id = $(this).parent().attr("text");
                                    $("#" + id).show();
                */
            },
            function () {
                /*
                                    $(this).removeClass("linkHover");
                                    $(".notice").hide();
                */
            }).click(function () {
            %{--var url = $(this).attr("href");--}%
            %{--var file = $(this).attr("file");--}%

            %{--var dialog = trim($(this).attr("dialog"));--}%
            %{--var cont = trim($(this).text());--}%


            %{--$("#" + dialog).dialog("option", "title", cont);--}%
            %{--$("#" + dialog).dialog("open");--}%

            %{--actionUrl = "${createLink(controller:'pdf',action:'pdfLink')}?filename=" + file + "&url=" + url;--}%

            %{--//                            console.log(actionUrl);--}%

            %{--<g:link action="pdfLink" controller="pdf" params="[url: g.createLink(controller: 'reportes', action: 'planDeCuentas'), filename: 'Plan_de_Cuentas.pdf']">--}%
            %{--plan de cuentas--}%
            %{--</g:link>--}%

            %{--//                            console.log(url, file);--}%

            %{--return false;--}%
        });

        $("#contP").change(function () {
            updatePeriodo();
        });

        $("#dlgContabilidad").dialog({
            modal: true,
            resizable: false,
            autoOpen: false,
            buttons: {
                "Aceptar": function () {
                    var cont = $("#cont").val();
                    var url = actionUrl + "?cont=" + cont + "Wemp=${session.empresa?.id}";
//                            console.group("URL");
//                            console.log(actionUrl);
//                            console.log(url);
//                            console.groupEnd();

                    location.href = url;
                },
                "Cancelar": function () {
                    $("#dlgContabilidad").dialog("close");
                }
            }
        });
        $("#dlgVentas").dialog({
            modal: true,
            width: 400,
            height: 300,
            title: "Reporte de ventas",
            autoOpen: false,
            buttons: {
                "Ver": function () {
                    var desde = $("#desde").val()
                    var hasta = $("#hasta").val()
                    location.href = "${g.createLink(action: 'ventas')}?desde=" + desde + "&hasta=" + hasta;
                }
            }
        });

        $("#dlgContabilidadPeriodo").dialog({
            modal: true,
            resizable: false,
            autoOpen: false,
            width: 400,
            open: function () {
                updatePeriodo();
            },
            buttons: {
                "Aceptar": function () {
                    var cont = $("#contP").val();
                    var per = $("#periodo").val();
                    var url = actionUrl + "?cont=" + cont + "Wper=" + per + "Wemp=${session.empresa?.id}";
//                            console.group("URL");
//                            console.log(actionUrl);
//                            console.log(url);
//                            console.groupEnd();
                    location.href = url;
                },
                "Cancelar": function () {
                    $("#dlgContabilidadPeriodo").dialog("close");
                }
            }
        });


        $("#btnComprobantes").button({
            icons: {
                primary: "ui-icon-search"
            }
        });

        $("#dlgComprobante").dialog({
            resizable: false,
            autoOpen: false,
            modal: true,
            width: 400,
            buttons: {
                "Aceptar": function () {
                    var cont = $("#cont").val();
                    var per = $("#periodo").val();
                    var url = actionUrl + "?cont=" + cont + "Wper=" + per + "Wemp=${session.empresa?.id}";
//                            console.group("URL");
//                            console.log(actionUrl);
//                            console.log(url);
//                            console.groupEnd();
                    location.href = url;
                },
                "Cancelar": function () {
                    $("#dlgComprobante").dialog("close");
                }
            }
        });

    });
</script>

</body>
</html>