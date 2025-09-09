
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="mainMatriz">
    <title>Histórico de cronograma de ejecución</title>

    <style type="text/css">
    .cmplcss {
        color: #856c4d;
    }

    .center {
        text-align: center;
    }

    .pagination {
        display: inline-block;
    }

    .pagination a {
        color: white;
        float: left;
        padding: 5px 8px;
        text-decoration: none;
        transition: background-color .3s;
        border: 1px solid #ddd;
        margin: 0 4px;
    }

    .pagination a.active {
        background-color: #72af97;
        color: black;
        border: 1px solid #72af97;
    }
    .pagination a:hover:not(.active) {background-color: #ddd;}

    </style>
</head>

<body>

<g:set var="meses" value="${contrato?.obra?.plazoEjecucionMeses + (contrato?.obra?.plazoEjecucionDias > 0 ? 1 : 0)}"/>

<div class="btn-toolbar col-md-12" id="toolbar">
    <div class="btn-group col-md-1">
        <a href="${g.createLink(controller: 'cronogramaEjecucion', action: 'indexNuevo', params: [id: contrato?.id])}"
           class="btn btn-primary btn-new" id="atras" rel="tooltip" title="Regresar al contrato">
            <i class="fa fa-arrow-left"></i>
            Regresar
        </a>
    </div>
    <div class="col-md-10 alert alert-warning" style="font-size: 14px; font-weight: bold">
        Históricos del cronograma de ejecución de la obra: ${contrato?.obra?.nombre} (${meses} mes${meses == 1 ? "" : "es"})
    </div>
</div>


<g:if test="${historicos.size() > 0}">
    <div class="col-md-12">
        <div class="col-md-2">
            <label style="font-size: 18px">
                Cronograma:
            </label>
        </div>
        <div class="col-md-8">
            <g:select name="modificacionSeleccion" from="${janus.pac.ModificacionCronograma.findAllByContrato(contrato).sort{it.fecha}}"  optionKey="id"
                      optionValue="${{it?.fecha?.format("dd-MM-yyyy HH:mm") + " - " + it.descripcion}}" class="form-control btn-warning"/>
        </div>
    </div>

    <div class="col-md-12" id="divHistorico" style="margin-top: 1px">

    </div>
</g:if>
<g:else>
    <div class="col-md-12" style="text-align: center">
        <div class="col-md-2"></div>
        <div class="col-md-8 alert alert-warning" style="font-size: 16px; font-weight: bold">
            <i class="fa fa-exclamation-triangle fa-2x text-info"></i> No existe ningún histórico del cronograma
        </div>
    </div>
</g:else>

<script type="text/javascript">

    <g:if test="${historicos.size() > 0}">
    $("#modificacionSeleccion").change(function () {
        cargarHistorico();
    });

    cargarHistorico();

    function cargarHistorico() {
        var modificacion = $("#modificacionSeleccion option:selected").val();
        var g = cargarLoader("Cargando...");
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'cronogramaEjecucion', action: 'historico_ajax')}",
            data: {
                id: ${contrato.id},
                modificacion: modificacion
            },
            success: function (msg) {
                g.modal("hide");
                $("#divHistorico").html(msg);
            }
        });
    }
    </g:if>

</script>
</body>
</html>