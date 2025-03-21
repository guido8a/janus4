
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Histórico de especificaciones del rubro</title>

</head>

<body>


<div class="col-md-12" style="text-align: center; font-size: 14px; font-weight: bold; margin-top: -30px">
    <div class="col-md-2">

    </div>
    <div class="col-md-8 alert alert-info">
        ${rubro?.nombre}
    </div>
</div>

<div role="main" style="margin-top: 5px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
%{--            <th style="width: 10%">Fecha</th>--}%
            <th style="width: 80%">Nombre</th>
            <th style="width: 10%">Acciones</th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
        <tbody>
        <g:if test="${datos}">
                    <g:each in="${datos}" status="i" var="dato">
                        <tr>
%{--                            <td style="width: 10%">${dato?.}</td>--}%
                            <td style="width: 80%">${dato?.ruta}</td>
                            <td style="width: 10%; text-align: center">
                                <a href="#" class="btn btn-xs btn-warning btnDownload" data-id="${dato?.id}" title="Descargar">
                                    <i class="fas fa-download"></i>
                                </a>
                            </td>
                        </tr>
                    </g:each>
        </g:if>
        <g:else>
            <td class="alert alert-warning"><i class="fa fa-exclamation-triangle fa-2x text-info"></i>
                <strong style="font-size: 16px"> No existen registros </strong>
            </td>
        </g:else>
        </tbody>
    </table>
</div>

<script type="text/javascript">


</script>

</body>
</html>