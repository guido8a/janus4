<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Subir archivo excel contrato</title>
</head>

<body>
<g:if test="${flash.message}">
    <div class="alert alert-error">
        ${flash.message}
    </div>
</g:if>

<g:uploadForm controller="cronogramaContrato" action="uploadFile" method="post" name="frmUpload" id="${contrato?.id}" style="padding: 10px">
    <g:hiddenField name="id" value="${contrato?.id}"/>
    <g:hiddenField name="tipo" value="1"/>
    <div id="list-grupo" class="col-md-12" role="main" style="margin: 10px 0 0 0;">
        <div class="" style="margin: 0 0 20px 0;">
            <div class="col-md-9">
                <div class="alert alert-info">
                    <strong style="font-size: 14px"> Presupuesto final </strong> <br>
                    <strong style="font-size: 14px"><i class="fa fa-exclamation-triangle fa-2x text-warning"></i>  El archivo debe contener 6 columnas (los nombres de las columnas no son importantes):</strong>
                </div>
                <table class="table" style="background-color: #5a7ab2; color: #fff">
                    <tr>
                        <th style="border: 1px solid #ddd; text-align: center">
                            NÚMERO
                        </th>
                        <th style="border: 1px solid #ddd; text-align: center">
                            DESCRIPCIÓN
                        </th>
                        <th style="border: 1px solid #ddd; text-align: center">
                            UNIDAD
                        </th>
                        <th style="border: 1px solid #ddd; text-align: center">
                            CANTIDAD
                        </th>
                        <th style="border: 1px solid #ddd; text-align: center">
                            PRECIO UNITARIO
                        </th>
                        <th style="border: 1px solid #ddd; text-align: center">
                            PRECIO TOTAL
                        </th>
                    </tr>
                </table>

             <br/>
            </div>
        </div>

        <div class="col-md-6" style="margin-top: 20px">
            <div class="col-md-2"><b>Archivo:</b></div>
            <input type="file" class="required" id="file" name="file" multiple accept=".xlsx"/>
        </div>
    </div>

    <div class="col-md-12" style="margin-top: 20px">
        <a href="#" class="btn btn-success" id="btnSubmit"><i class="fa fa-upload"></i>  Subir Presupuesto final</a>
    </div>
</g:uploadForm>

<g:uploadForm controller="cronogramaContrato" action="uploadFile" method="post" name="frmUploadCrono" id="${contrato?.id}" style="padding: 10px">
    <g:hiddenField name="id" value="${contrato?.id}"/>
    <g:hiddenField name="tipo" value="2"/>
    <div id="list-grupo" class="col-md-12" role="main" style="margin: 10px 0 0 0;">
        <div class="" style="margin: 0 0 20px 0;">
            <div class="col-md-9">
                <div class="alert alert-info">
                    <strong style="font-size: 14px"> Cronograma Valorado </strong> <br>
                    <strong style="font-size: 14px"><i class="fa fa-exclamation-triangle fa-2x text-warning"></i>   El archivo debe contener al menos 5 columnas (los nombres de las columnas no son importantes):</strong>
                </div>
                <table class="table" style="background-color: #5a7ab2; color: #fff">
                    <tr>
                        <th style="border: 1px solid #ddd; text-align: center">
                            NÚMERO
                        </th>
                        <th style="border: 1px solid #ddd; text-align: center">
                            DESCRIPCIÓN DEL RUBRO
                        </th>
                        <th style="border: 1px solid #ddd; text-align: center">
                            UNIDAD
                        </th>
                        <th style="border: 1px solid #ddd; text-align: center">
                            CANTIDAD
                        </th>
                        <th style="border: 1px solid #ddd; text-align: center">
                            PRECIO UNITARIO OFERTADO
                        </th>
                        <th style="border: 1px solid #ddd; text-align: center">
                            PRECIO TOTAL
                        </th>
                        <th style="border: 1px solid #ddd; text-align: center">
                            MESES...
                        </th>
                    </tr>
                </table>

                <br/>
            </div>
        </div>

        <div class="col-md-6" style="margin-top: 20px">
            <div class="col-md-2"><b>Archivo:</b></div>
            <input type="file" class="required" id="fileCrono" name="file" multiple accept=".xlsx"/>
        </div>
    </div>

    <div class="col-md-12" style="margin-top: 20px">
        <a href="#" class="btn btn-success" id="btnSubmitCrono"><i class="fa fa-upload"></i>  Subir cronograma valorado</a>
    </div>
</g:uploadForm>

<script type="text/javascript">

    $("#btnSubmit").click(function () {
        if ($("#frmUpload").valid()) {
            $(this).replaceWith(spinner);
            $("#frmUpload").submit();
        }
    });

    $("#btnSubmitCrono").click(function () {
        if ($("#frmUploadCrono").valid()) {
            $(this).replaceWith(spinner);
            $("#frmUpload").submit();
        }
    });

</script>
</body>
</html>