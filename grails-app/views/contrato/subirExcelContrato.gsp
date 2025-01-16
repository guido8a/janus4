<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Subir archivo excel contrato</title>
</head>

<body>

<a href="#" class="btn btn-primary btnRegresar">
    <i class="fa fa-arrow-left"></i>
    Regresar
</a>

<g:if test="${flash.message}">
    <div class="alert alert-error">
        ${flash.message}
    </div>
</g:if>

<g:uploadForm controller="cronogramaContrato" action="uploadFile" method="post" name="frmUpload" id="${contrato?.id}" style="padding: 10px">
    <g:hiddenField name="id" value="${contrato?.id}"/>
    <div id="list-grupo" class="col-md-12" role="main" style="margin: 10px 0 0 0;">
        <div class="" style="margin: 0 0 20px 0;">
            <div class="col-md-9">
                <div class="alert alert-info">
                    <strong style="font-size: 14px"> Cronograma Valorado </strong> <br>
                    <strong style="font-size: 14px"><i class="fa fa-exclamation-triangle fa-2x text-warning"></i>   El archivo debe contener al menos 6 columnas (los nombres de las columnas no son importantes):</strong>
                </div>

%{--                <div class="col-md-2" >--}%
%{--                    <label> Cantidad de Meses </label>--}%
%{--                </div>--}%
%{--                <div class="col-md-2" align="center">--}%
%{--                    <g:textField name="meses" class="form-control" value="0" />--}%
%{--                </div>--}%

                <table class="table" style="background-color: #5a7ab2; color: #fff; margin-top: 70px">
                    <tr>
                        <th style="border: 1px solid #ddd; text-align: center">
                            A - NÚMERO
                        </th>
                        <th style="border: 1px solid #ddd; text-align: center">
                            B - DESCRIPCIÓN DEL RUBRO
                        </th>
%{--                        <th style="border: 1px solid #ddd; text-align: center">--}%
%{--                            C - UNIDAD--}%
%{--                        </th>--}%
                        <th style="border: 1px solid #ddd; text-align: center">
                            C - CANTIDAD
                        </th>
                        <th style="border: 1px solid #ddd; text-align: center">
                            D - PRECIO UNITARIO OFERTADO
                        </th>
                        <th style="border: 1px solid #ddd; text-align: center">
                            E - PRECIO TOTAL
                        </th>
                        <th style="border: 1px solid #ddd; text-align: center">
                            F - MESES 1 2 3...
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

    $(".btnRegresar").click(function () {
        location.href="${createLink(controller: 'contrato', action: 'registroContrato')}?contrato=" + '${contrato?.id}'
    });

    $("#btnSubmitCrono").click(function () {
        if ($("#frmUpload").valid()) {
            $("#frmUpload").submit();
        }
     });

</script>
</body>
</html>