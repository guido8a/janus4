<%@ page contentType="text/html;charset=UTF-8" %>
<html xmlns="http://www.w3.org/1999/html">
<head>
    <title>${"Oferentes"}</title>
    <meta name="layout" content="main"/>
    <style type="text/css">
    @page {
        size: 8.5in 11in;  /* width height */
        margin: 0.25in;
    }

    .item {
        width: 260px;
        height: 220px;
        float: left;
        margin: 4px;
        font-family: 'open sans condensed';
        border: none;
    }

    .imagen {
        width: 167px;
        height: 100px;
        margin: auto;
        margin-top: 10px;
    }

    .texto {
        width: 90%;
        height: 50px;
        padding-top: 0px;
        margin: auto;
        margin: 8px;
        font-family: "Open Sans", "Helvetica Neue", Helvetica, Arial, sans-serif;
        font-size: 13px;
        font-style: normal;
    }

    .fuera {
        margin-left: 15px;
        margin-top: 20px;
        background-color: rgba(200, 200, 200, 0.9);
        border: none;

    }

    .titl {
        font-family: 'open sans condensed';
        font-weight: bold;
        text-shadow: -2px 2px 1px rgba(0, 0, 0, 0.25);
    <g:if test="${janus.Parametros.findByEmpresaLike('SEP-C-GADPP')}">
        color: #418073;
    </g:if>
    <g:else>
        color: #00485a;
    </g:else>

        margin-top: 20px;
    }

    .bordes {
    <g:if test="${janus.Parametros.findByEmpresaLike('SEP-C-GADPP')}">
        background: #317063;
    </g:if>
    <g:else>
        background: #40525e;
    </g:else>

    }

    </style>
</head>

<body>
<div class="dialog">
    <div style="text-align: center;">
        <h1 class="titl" style="font-size: 26px;">
            <elm:poneHtml textoHtml="${"SEGUIMIENTO Y EJECUCIÓN DE PROYECTOS DE OBRAS Y CONSULTORÍAS GOBIERNO AUTÓNOMO DESCENTRALIZADO PROVINCIA DE PICHINCHA"}"/>
        </h1>
    </div>

    <div class="body ui-corner-all bordes" style="width: 850px;position: relative;margin: auto;margin-top: 0px;height: 510px;">

        <div class="ui-corner-all  item fuera">
            <div class="ui-corner-all ui-widget-content item">
                <a href="${createLink(controller: 'rubroOf', action: 'subirRubros')}" title="Subir Rubros">
                    <div class="imagen">
                        <img src="${resource(dir: 'images', file: 'apu1.png')}" width="100%" height="100%"/>
                    </div>

                    <div class="texto"><b>Subir rubros</b>: ...</div>
                </a>
            </div>
        </div>

        <div class="ui-corner-all item fuera">
            <div class="ui-corner-all ui-widget-content item">
                <a href="${createLink(controller: 'rubroOf', action: 'emparejarRubros')}" title="Emparejar Rubros">
                    <div class="imagen">
                        <img src="${resource(dir: 'images', file: 'obra100.png')}" width="100%" height="100%"/>
                    </div>

                    <div class="texto"><b>Emparejar rubros</b>: ...</div>
                </a>
            </div>
        </div>

        <div class="ui-corner-all item fuera">
            <div class="ui-corner-all ui-widget-content item">
                <a href="${createLink(controller: 'rubroOf', action: 'subirExcelApu')}" title="Cargar excel apu">
                    <div class="imagen">
                        <img src="${resource(dir: 'images', file: 'bodega.png')}" width="100%" height="100%"/>
                    </div>

                    <div class="texto"><b>Subir Excel APU</b>: ...</div>
                </a>
            </div>
        </div>

        <div class="ui-corner-all  item fuera">
            <div class="ui-corner-all ui-widget-content item">
                <a href="${createLink(controller: 'rubroOf', action: 'subirExcel')}" title="Cargar excel anterior">
                    <div class="imagen">
                        <img src="${resource(dir: 'images', file: 'fiscalizar.png')}" width="100%" height="100%"/>
                    </div>

                    <div class="texto"><b>Subir Excel anterior</b>: ...</div>
                </a>
            </div>
        </div>

        <div class="ui-corner-all  item fuera">
            <div class="ui-corner-all ui-widget-content item">
                <a href="${createLink(controller: 'rubroOferta', action: 'list')}" title="Comprobar rubros">
                    <div class="imagen">
                        <img src="${resource(dir: 'images', file: 'reporte.png')}" width="100%" height="100%"/>
                    </div>

                    <div class="texto"><b>Comprobar rubros</b>: ...</div>
                </a>
            </div>
        </div>



        <div class="ui-corner-all  item fuera">

            <div class="ui-corner-all ui-widget-content item">
                <div class="imagen">
                    <img src="${resource(dir: 'images', file: 'manuales1.png')}" width="100%" height="100%" title="Manuales del sistema"/>
                </div>

                <div class="texto"><b></b>

                </div>
            </div>
        </div>

        <div style="text-align: center ; color:#ffffff"> Desarrollado por: TEDEIN S.A. Versión ${message(code: 'version', default: '1.1.0x')} </div>

    </div>
</div>

<script type="text/javascript">
    $(".fuera").hover(function () {
        var d = $(this).find(".imagen");
        d.width(d.width() + 10);
        d.height(d.height() + 10)
    }, function () {
        var d = $(this).find(".imagen");
        d.width(d.width() - 10);
        d.height(d.height() - 10)
    })
</script>
</body>
</html>
