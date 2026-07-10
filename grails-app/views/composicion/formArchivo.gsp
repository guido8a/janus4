<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Subir archivo excel composición</title>
</head>

<body>
<g:if test="${flash.message}">
    <div class="alert alert-error">
        ${flash.message}
    </div>
</g:if>


<div class="btn-toolbar" style="margin-top: 15px;">
    <div class="btn-group">
        <a href="${g.createLink(controller: 'obra', action: 'registroObra', params: [obra: obra?.id])}" class="btn btn-primary"
           title="Regresar a la obra">
            <i class="fa fa-arrow-left"></i>
            Regresar Obra
        </a>
        <a href="${g.createLink(controller: 'composicion', action: 'tabla', params: [id: obra?.id])}" class="btn btn-info"
           title="Regresar a la obra">
            <i class="fa fa-arrow-left"></i>
            Regresar Composición
        </a>
    </div>
</div>

<g:uploadForm action="uploadFile" method="post" name="frmUpload" id="${obra?.id}" style="padding: 10px">
    <g:hiddenField name="id" value="${obra?.id}"/>
    <div id="list-grupo" class="col-md-12" role="main" style="margin: 10px 0 0 0;">
        <div class="" style="margin: 0 0 20px 0;">
            <div class="col-md-9">

                <table class="table" style="background-color: #5a7ab2; color: #fff">
                    <tr>
                        <th style="border: 1px solid #ddd; text-align: center">
                            CODIGO
                        </th>
                        <th style="border: 1px solid #ddd; text-align: center">
                            ITEM
                        </th>
                        <th style="border: 1px solid #ddd; text-align: center">
                            UNIDAD
                        </th>
                        <th style="border: 1px solid #ddd; text-align: center">
                            CANTIDAD
                        </th>
                        <th style="border: 1px solid #ddd; text-align: center">
                            NUEVA CANTIDAD
                        </th>
                    </tr>
                </table>

                <div class="alert alert-warning" style="font-size: 14px">
                    <ul>
                        <li>El archivo debe contener al menos 5 columnas (los nombres de las columnas no son importantes)</li>
                        <li>El ítem es ubicado por código</li>
                        <li>La columna que va a ser tomada para modificar la cantidad de cada rubro es la "Nueva cantidad"  <strong> (la columna E del archivo Excel) </strong></li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="col-md-6" style="margin-top: 20px">
            <div class="col-md-2"><b>Archivo:</b></div>
            <input type="file" class="required" id="file" name="file" multiple accept=".xlsx"/>
        </div>
    </div>

    <div class="col-md-12" style="margin-top: 20px">
        <a href="#" class="btn btn-success" id="btnSubmit"><i class="fa fa-upload"></i> Subir archivo Excel</a>
    </div>
</g:uploadForm>

<script type="text/javascript">
    $(function () {
        $("#frmUpload").validate({

        });

        $("#btnSubmit").click(function () {
            if ($("#frmUpload").valid()) {
                $(this).replaceWith(spinner);
                $("#frmUpload").submit();
            }
        });
    });
</script>
</body>
</html>