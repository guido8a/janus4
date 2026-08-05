<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 28/08/20
  Time: 13:31
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Rubros cargados</title>
</head>

<body>
<div class="row">
    <div class="col-md-12">
        <div class="col-md-2">
            <g:link class="btn btn-primary" controller="rubroOf" action="index" id="${contrato?.id}">
                <i class="fa fa-arrow-left"></i> Regresar
            </g:link>
        </div>

        <div class="col-md-2">
            <g:link class="btn btn-danger" controller="rubroOf" action="subirRubros" id="${contrato?.id}">
                <i class="fa fa-arrow-left"></i> Regresar a Subir Rubros
            </g:link>
        </div>

        <div class="col-md-2">
            <g:link class="btn btn-info" controller="rubroOf" action="emparejarRubros" id="${contrato?.id}">
                Continuar: Emparejar Rubros <i class="fa fa-arrow-right"></i>
            </g:link>
        </div>
    </div>
</div>

<div class="row" style="margin-top: 30px; text-align: center">
    <div class="col-md-12" style="text-align: center">
        <div class="col-md-2"></div>
        <div class="col-md-7" style="font-size: 14px; font-weight: bold">
            <elm:poneHtml textoHtml="${flash.message}"/>
        </div>
    </div>
</div>
</body>
</html>