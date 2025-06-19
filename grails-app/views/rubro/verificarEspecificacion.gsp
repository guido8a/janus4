<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Verificación de especificaciones</title>

    <style type="text/css">
    table {
        table-layout: fixed;
        overflow-x: scroll;
    }
    th, td {
        overflow: hidden;
        text-overflow: ellipsis;
        word-wrap: break-word;
    }
    </style>

</head>

<body>

<div class="row">
    <div class="alert alert-success">
        Tienen Imágenes en carpeta
    </div>

    <div role="main" style="margin-top: 5px;">
        <table class="table table-bordered table-striped table-condensed table-hover">
            <thead>
            <tr>
                <th style="width: 9%">ID</th>
                <th style="width: 9%">Código</th>
                <th style="width: 10%">Cód. Esp.</th>
                <th style="width: 20%">Nombre</th>
                <th style="width: 15%">Ilustración</th>
                <th style="width: 1%;"></th>
            </tr>
            </thead>
        </table>
    </div>


    <div class="" style="width: 99.7%; ${imagenes.size() > 10 ? "height: 300px;" : '' } overflow-y: auto;float: right; margin-top: -20px">
        <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
            <tbody>
            <g:if test="${imagenes}">
                <g:each in="${imagenes}" status="i" var="imagen">
                    <tr>
                        <td style="width: 9%">${imagen?.id}</td>
                        <td style="width: 9%">${imagen?.codigo}</td>
                        <td style="width: 10%">${imagen?.codigoEspecificacion}</td>
                        <td style="width: 20%">${imagen?.nombre}</td>
                        <td style="width: 15%">${imagen?.foto}</td>
                        <td style="width: 1%"></td>
                    </tr>
                </g:each>
            </g:if>
            <g:else>
                <td class="alert alert-warning" style="text-align: center"><i class="fa fa-exclamation-triangle fa-2x text-info"></i>
                    <strong style="font-size: 16px"> No existen registros </strong>
                </td>
            </g:else>
            </tbody>
        </table>
    </div>

</div>

<div class="row">
    <div class="alert alert-warning" style="margin-top: 10px">
        NO tienen Imágenes en carpeta
    </div>

    <div role="main" style="margin-top: 5px;">
        <table class="table table-bordered table-striped table-condensed table-hover">
            <thead>
            <tr>
                <th style="width: 9%">ID</th>
                <th style="width: 9%">Código</th>
                <th style="width: 10%">Cód. Esp.</th>
                <th style="width: 20%">Nombre</th>
                <th style="width: 15%">Ilustración</th>
                <th style="width: 1%;"></th>
            </tr>
            </thead>
        </table>
    </div>

    <div class="" style="width: 99.7%;height: 300px; overflow-y: auto;float: right; margin-top: -20px">
        <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
            <tbody>
            <g:if test="${noImagenes}">
                <g:each in="${noImagenes}" status="i" var="imagen">
                    <tr>
                        <td style="width: 9%">${imagen?.id}</td>
                        <td style="width: 9%">${imagen?.codigo}</td>
                        <td style="width: 10%">${imagen?.codigoEspecificacion}</td>
                        <td style="width: 20%">${imagen?.nombre}</td>
                        <td style="width: 15%">${imagen?.foto}</td>
                        <td style="width: 1%"></td>
                    </tr>
                </g:each>
            </g:if>
            <g:else>
                <td class="alert alert-warning" style="text-align: center"><i class="fa fa-exclamation-triangle fa-2x text-info"></i>
                    <strong style="font-size: 16px"> No existen registros </strong>
                </td>
            </g:else>
            </tbody>
        </table>
    </div>
</div>

%{--<div role="main" style="margin-top: 5px;">--}%
%{--    <table class="table table-bordered table-striped table-condensed table-hover">--}%
%{--        <thead>--}%
%{--        <tr>--}%
%{--            <th style="width: 9%">ID</th>--}%
%{--            <th style="width: 9%">Código</th>--}%
%{--            <th style="width: 10%">Cód. Esp.</th>--}%
%{--            <th style="width: 20%">Nombre</th>--}%
%{--            <th style="width: 15%">Especificación</th>--}%
%{--            <th style="width: 15%">Word</th>--}%
%{--            <th style="width: 15%">Ilustración</th>--}%
%{--            <th style="width: 1%;"></th>--}%
%{--        </tr>--}%
%{--        </thead>--}%
%{--    </table>--}%
%{--</div>--}%

%{--<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">--}%
%{--    <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">--}%
%{--        <tbody>--}%
%{--        <g:if test="${especificaciones}">--}%
%{--            <g:each in="${especificaciones}" status="i" var="ares">--}%
%{--                <tr>--}%
%{--                    <td style="width: 9%">${ares?.item?.id}</td>--}%
%{--                    <td style="width: 9%">${ares?.item?.codigo}</td>--}%
%{--                    <td style="width: 10%">${ares?.item?.codigoEspecificacion}</td>--}%
%{--                    <td style="width: 20%">${ares?.item?.nombre}</td>--}%
%{--                    <td style="width: 15%">${ares?.ruta}</td>--}%
%{--                    <td style="width: 15%">${ares?.especificacion}</td>--}%
%{--                    <td style="width: 15%">${ares?.item?.foto}</td>--}%
%{--                    <td style="width: 1%"></td>--}%
%{--                </tr>--}%
%{--            </g:each>--}%
%{--        </g:if>--}%
%{--        <g:else>--}%
%{--            <td class="alert alert-warning" style="text-align: center"><i class="fa fa-exclamation-triangle fa-2x text-info"></i>--}%
%{--                <strong style="font-size: 16px"> No existen registros </strong>--}%
%{--            </td>--}%
%{--        </g:else>--}%
%{--        </tbody>--}%
%{--    </table>--}%
%{--</div>--}%

<script type="text/javascript">


</script>

</body>
</html>