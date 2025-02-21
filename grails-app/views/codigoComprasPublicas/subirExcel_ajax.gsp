<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Subir archivo excel contrato</title>
    <style type="text/css">
    table, th, td {
        border: 1px solid white;
    }
    </style>
</head>

<body>

<div class="row">
    <div class="col-md-1">
        <a href="#" class="btn btn-primary btnRegresar">
            <i class="fa fa-arrow-left"></i>
            Regresar
        </a>
    </div>
</div>

<g:if test="${flash.message}">
    <div class="alert alert-error">
        ${flash.message}
    </div>
</g:if>

<g:uploadForm controller="codigoComprasPublicas" action="uploadFile" method="post" name="frmUpload" style="padding: 10px">
    <g:hiddenField name="id" value="${contrato?.id}"/>

    <div id="list-grupo" class="col-md-12" role="main">
        <div class="" style="margin: 0 0 20px 0;">
            <div class="col-md-2 text-info" style="margin-top: 15px">Formato del archivo <strong>Excel xlsx</strong></div>
            <div class="col-md-9">

                <table class="table" style="background-color: #5a7ab2; color: #fff;">
                    <tr>
                        <th style="border: 1px solid #ddd; text-align: center; width: 15%">
                            A - Identificador del Producto CPC N9
                        </th>
                        <th style="border: 1px solid #ddd; text-align: center; width: 70%">
                            B - Descripción del producto CPC N9
                        </th>
                        <th style="border: 1px solid #ddd; text-align: center; width: 15%">
                            C - Umbral VAE (12-12-2024)
                        </th>
                    </tr>
                    <tr style="background-color: #dfdfff; text-align: center; color: #000;">
                        <td style="text-align: left">011200011</td>
                        <td style="text-align: left">SEMILLA DE MAIZ..</td>
                        <td style="text-align: right">19.52%</td>
                    </tr>
                    <tr style="background-color: #dfdfff; text-align: center; color: #000;">
                        <td>..</td>
                        <td></td>
                        <td></td>
                    </tr>
                </table>

                <br/>
            </div>
        </div>

        <div class="col-md-12" style="margin-top: 20px">
                <div class="col-md-2">
                    <div><b>Fecha de Registro:</b></div>
                    <div>
                        <elm:datepicker name="fecha" class="fechaRegistro datepicker input-small required"
                                        value="${new java.util.Date()}" title="Fecha Registro"/>
                    </div>

                </div>

            <div class="col-md-2" style="text-align: right"><b>Archivo Excel a subir:</b></div>
            <div class="col-md-6">
                <input type="file" class="required" id="fileCrono" name="file" multiple accept=".xlsx"
                       style="width: 100%; font-size: 12pt" value="Arch"/>
            </div>
            <div class="col-md-2">
                <a href="#" class="btn btn-success" id="btnSubmitCrono"><i class="fa fa-upload"></i>
                    Subir archivo</a>
            </div>
        </div>
    </div>


</g:uploadForm>

<script type="text/javascript">

    $(".btnRegresar").click(function () {
        location.href="${createLink(controller: 'codigoComprasPublicas', action: 'list')}"
    });

    $("#btnSubmitCrono").click(function () {
        if ($("#frmUpload").valid()) {
            $("#frmUpload").submit();
        }
    });

</script>
</body>
</html>