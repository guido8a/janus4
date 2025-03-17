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
        height: 225px;
        float: left;
        margin: 4px;
        font-family: 'open sans condensed';
        background-color: #e7f5f1;
        border: 1px;
        border-color: #5c6e80;
        border-style: solid;
    }
    .item2 {
        width: 660px;
        height: 160px;
        float: left;
        margin: 4px;
        font-family: 'open sans condensed';
        background-color: #eceeff;
        border: 1px;
        border-color: #5c6e80;
        border-style: solid;
    }

    .imagen {
        width: 200px;
        height: 140px;
        margin: auto;
        margin-top: 10px;
    }
    .imagen2 {
        width: 200px;
        height: 140px;
        margin: auto;
        margin-top: 10px;
        margin-right: 40px;
        float: right;
    }

    .texto {
        width: 90%;
        /*height: 50px;*/
        padding-top: 0px;
        margin: auto;
        margin: 8px;
        font-size: 16px;
        font-style: normal;
    }

    .fuera {
        margin-left: 15px;
        margin-top: 20px;
        /*background-color: #317fbf; */
        background-color: rgba(114, 131, 147, 0.9);
        border: none;
    }

    .titl {
        font-family: 'open sans condensed';
        font-weight: bold;
        text-shadow: -2px 2px 1px rgba(0, 0, 0, 0.25);
        color: #0070B0;
        margin-top: 20px;
    }

    body {
        background : #e5e4e7;
    }

    .color1 {
        background : #e7f5f1;
    }

    .color2 {
        background : #FFF;
    }


    section {
        padding-top: 4rem;
        padding-bottom: 5rem;
        background-color: #f1f4fa;
    }
    .wrap {
        display: flex;
        background: white;
        padding: 1rem 1rem 1rem 1rem;
        border-radius: 0.5rem;
        box-shadow: 7px 7px 30px -5px rgba(0,0,0,0.1);
        margin-bottom: 1rem;
        width: 553px; height: 130px
    }

    .wrap:hover {
        /*background: linear-gradient(135deg,#6394ff 0%,#0a193b 100%);*/
        background: linear-gradient(135deg, #e0fff8 0%,#e6f0f8 100%);
        /*color: white;*/
    }

    .ico-wrap {
        margin: auto;
    }

    .mbr-iconfont {
        font-size: 4.5rem !important;
        color: #313131;
        margin: 1rem;
        padding-right: 1rem;
    }
    .vcenter {
        margin: auto;
    }

    .mbr-section-title3 {
        text-align: left;
    }
    h2 {
        margin-top: 0.5rem;
        margin-bottom: 0.5rem;
    }
    .display-5 {
        font-family: 'Source Sans Pro',sans-serif;
        font-size: 1.4rem;
    }
    .mbr-bold {
        font-weight: 700;
    }

    p {
        padding-top: 0.5rem;
        padding-bottom: 0.5rem;
        line-height: 25px;
    }
    .display-6 {
        font-family: 'Source Sans Pro',sans-serif;
        font-size: 1re
    }


    </style>
</head>

<body>
<div class="dialog">
    <div style="text-align: center;">
        <h1 class="titl" style="font-size: 26px;">
            <elm:poneHtml textoHtml="Cargado del presupuesto y rubros desde los archivos excel del Oferente"/>
        </h1>
    </div>

    <div class="row mbr-justify-content-center">

        <a href= "${createLink(controller:'rubroOf', action: 'subirRubros')}" style="text-decoration: none">
            <div class="col-lg-6 mbr-col-md-10">
                <div class="wrap">
                    <div style="width: 200px; height: 140px; text-align: center">
                        <span style="font-size: 72px">1</span>
                    </div>

                    <div style="width: 450px; height: 220px">
                        <h2 class="mbr-fonts-style mbr-bold mbr-section-title3 display-5"><span>Subir Rubros</span></h2>
                        <p class="mbr-fonts-style text1 mbr-text display-6">Desde una hoja donde se hallen todos los rubros
                        que figuran en la obra se suben los nombres y precios unitarios. Los rubros no deben repetirse.</p>
                    </div>
                </div>
            </div>
        </a>

        <a href= "${createLink(controller:'rubroOf', action: 'emparejarRubros')}" style="text-decoration: none">
            <div class="col-lg-6 mbr-col-md-10">
                <div class="wrap">
                    <div style="width: 200px; height: 140px; text-align: center">
                        <span style="font-size: 72px">2</span>
                    </div>

                    <div style="width: 450px; height: 220px">
                        <h2 class="mbr-fonts-style mbr-bold mbr-section-title3 display-5"><span>Emparejar Rubros</span></h2>
                        <p class="mbr-fonts-style text1 mbr-text display-6">Se determina la correspondencia entre los rubros
                        del contratista con los rubros del presupeusto preparado en el sistemas SEP-GADPP.</p>
                    </div>
                </div>
            </div>
        </a>

        <a href= "${createLink(controller:'rubroOf', action: 'subirExcelApu')}" style="text-decoration: none">
            <div class="col-lg-6 mbr-col-md-10">
                <div class="wrap">
                    <div style="width: 200px; height: 140px; text-align: center">
                        <span style="font-size: 72px">3</span>
                    </div>

                    <div style="width: 450px; height: 220px">
                        <h2 class="mbr-fonts-style mbr-bold mbr-section-title3 display-5"><span>Cargar el excel de los APU</span></h2>
                        <p class="mbr-fonts-style text1 mbr-text display-6">Cargar datos desde el excel que contiene
                        la composciión de LOS APU del contratista.</p>
                    </div>
                </div>
            </div>
        </a>

        <a href= "${createLink(controller:'rubroOf', action: 'rubroEmpatado')}" style="text-decoration: none">
            <div class="col-lg-6 mbr-col-md-10">
                <div class="wrap">
                    <div style="width: 200px; height: 140px; text-align: center">
                        <span style="font-size: 72px">4</span>
                    </div>

                    <div style="width: 450px; height: 220px">
                        <h2 class="mbr-fonts-style mbr-bold mbr-section-title3 display-5"><span>Emparejamiento de Ítems</span></h2>
                        <p class="mbr-fonts-style text1 mbr-text display-6">Se determina la correspondencia entre los ítems
                        del contratista con los del presupeusto preparado en el sistemas SEP-GADPP.</p>
                    </div>
                </div>
            </div>
        </a>

        <a href= "${createLink(controller:'rubroOferta', action: 'list')}" style="text-decoration: none">
            <div class="col-lg-6 mbr-col-md-10">
                <div class="wrap">
                    <div style="width: 200px; height: 140px; text-align: center">
                        <span style="font-size: 72px">5</span>
                    </div>

                    <div style="width: 450px; height: 220px">
                        <h2 class="mbr-fonts-style mbr-bold mbr-section-title3 display-5"><span>Comprobar valors de rubros</span></h2>
                        <p class="mbr-fonts-style text1 mbr-text display-6">Se comprueba los valores presentados por el oferente
                        con el precio unitario de cda APU.</p>
                    </div>
                </div>
            </div>
        </a>

        <a href= "${createLink(controller:'rubroOf', action: 'rubroCon')}" style="text-decoration: none">
            <div class="col-lg-6 mbr-col-md-10">
                <div class="wrap">
                    <div style="width: 200px; height: 140px; text-align: center">
                        <span style="font-size: 72px">6</span>
                    </div>

                    <div style="width: 450px; height: 220px">
                        <h2 class="mbr-fonts-style mbr-bold mbr-section-title3 display-5"><span>Revisar los APU del Oferetne</span></h2>
                        <p class="mbr-fonts-style text1 mbr-text display-6">Se visualiza la composición delos APU para
                        poder corregir valores y su composición</p>
                    </div>
                </div>
            </div>
        </a>

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
