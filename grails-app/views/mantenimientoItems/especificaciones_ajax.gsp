<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Especificaciones e Ilustraciones de: ${item?.nombre}</title>

    <asset:javascript src="/jquery/jquery-2.2.4.js"/>
    <asset:javascript src="/jquery/jquery-ui-1.10.2.custom.js"/>
    <asset:stylesheet src="/bootstrap-3.3.2/dist/css/bootstrap.css"/>
    <asset:stylesheet src="/bootstrap-3.3.2/dist/css/bootstrap-theme.css"/>
    <asset:javascript src="/apli/fontawesome.all.min.js"/>
    <asset:stylesheet src="/apli/font-awesome.min.css"/>
    <asset:javascript src="/apli/functions.js"/>
    <asset:stylesheet src="/jquery/jquery-ui-1.10.3.custom.min.css"/>
    %{--    <asset:stylesheet src="/apli/custom.css"/>--}%

</head>

<body style="padding: 20px;">
<g:if test="${flash.message}">
    <div class="row">
        <div class="span12">
            <div class="alert ${flash.clase ?: 'alert-info'}" role="status">
                <a class="close" data-dismiss="alert" href="#">×</a>
                ${flash.message}
            </div>
        </div>
    </div>
</g:if>
<div class="alert alert-info col-md-12" style="font-weight: bold; font-size: 14px; text-align: center">
    Nombre: ${item?.nombre}<br/>
    Código: ${item?.codigo} - Especificación: ${item?.codigoEspecificacion}
</div>

<div class="alert alert-success col-md-12" style="font-size: 14px; font-weight: bold">
    <i class="fa fa-file-pdf fa-2x"></i> Especificación PDF
</div>

<div class="col-md-6">
    <g:uploadForm action="uploadFileEspecificacion" method="post" name="frmUploadEspe" enctype="multipart/form-data">
        <g:hiddenField name="item" value="${item?.id}"/>
        <g:hiddenField name="tipo" value="pdf"/>
        <div class="fieldcontain required">
            <b>Cargar archivo PDF:</b>
            <input type="file" id="fileEspePDF" name="file" class="" multiple accept=".pdf"/>

            <div class="btn-group" style="margin-top: 20px;">
                <a href="#" id="salir" class="btn btn-primary">
                    <i class="fa fa-times"></i> Salir
                </a>
            </div>
            <div class="btn-group" style="margin-top: 20px;">
                <a href="#" class="btn btn-success submitEspe">
                    <i class="fa fa-save"></i> Guardar
                </a>
            </div>

            <div class="btn-group" style="margin-top: 20px;">
                <g:if test="${ares?.ruta}">
                    <g:link action="downloadFile" id="${item.id}" params="[tipo: 'pdf']" class="btn btn-info">
                        <i class="fa fa-download"></i> Descargar
                    </g:link>
                </g:if>
            </div>
        </div>
    </g:uploadForm>

    <div class="alert alert-warning">
        <g:if test="${!ares?.ruta}">
            <p style="color: #800; font-size: 14px"><i class="fa fa-exclamation-triangle fa-2x"></i>  No se ha cargado ninguna especificación PDF para este material</p>
        </g:if>
        <g:else>
            <i class="fa fa-file-pdf fa-2x"></i>  Especificación actual PDF: <strong style="font-size: 14px"> ${ares?.ruta} </strong>
        </g:else>
    </div>
</div>

<div class="alert alert-success col-md-12" style="font-size: 14px; font-weight: bold">
    <i class="fa fa-file-word fa-2x"></i> Especificación WORD
</div>

<g:if test="${existe}">
    <div class="col-md-6">
        <g:uploadForm action="uploadFileEspecificacion" method="post" name="frmUploadWord" enctype="multipart/form-data">
            <g:hiddenField name="item" value="${item?.id}"/>
            <g:hiddenField name="tipo" value="word"/>
            <div class="fieldcontain required">
                <b>Cargar archivo WORD:</b>
                <input type="file" id="fileEspe" name="file" class=""  multiple accept=".doc, .docx"/>

                <div class="btn-group" style="margin-top: 20px;">
                    <a href="#" id="submitWord" class="btn btn-success">
                        <i class="fa fa-save"></i> Guardar
                    </a>
                </div>

                <div class="btn-group" style="margin-top: 20px;">
                    <g:if test="${ares?.especificacion}">
                        <g:link action="downloadFile" id="${item.id}" params="[tipo: 'wd']" class="btn btn-info">
                            <i class="fa fa-download"></i> Descargar
                        </g:link>
                    </g:if>
                </div>
            </div>
        </g:uploadForm>

        <div class="alert alert-warning">
            <g:if test="${!ares?.especificacion}">
                <p style="color: #800; font-size: 14px"><i class="fa fa-exclamation-triangle fa-2x"></i>  No se ha cargado ninguna especificación WORD para este material</p>
            </g:if>
            <g:else>
                <i class="fa fa-file-word fa-2x"></i> Especificación actual WORD: <strong style="font-size: 14px"> ${ares?.especificacion} </strong>
            </g:else>
        </div>
    </div>
</g:if>


<div class="alert alert-success" style="font-size: 14px; font-weight: bold">
    <i class="fa fa-image fa-2x"></i> Ilustración
</div>

<fieldset class="borde_abajo" style="position: relative;width: 670px;padding-left: 50px;">
    <g:uploadForm action="uploadFileIlustracion" method="post" name="frmUpload" enctype="multipart/form-data">
        <g:hiddenField name="item" value="${item?.id}"/>
        <div class="fieldcontain required">
            <b>Cargar archivo:</b>
            <input type="file" id="file" name="file" class="" multiple accept=".jpg, .jpeg, .png, .gif"/>

            <div class="btn-group" style="margin-top: 20px;">
                %{--                <a href="#" id="salir" class="btn btn-primary">--}%
                %{--                    <i class="fa fa-times"></i> Salir--}%
                %{--                </a>--}%
            </div>
            <div class="btn-group" style="margin-top: 20px;">
                <a href="#" id="submit" class="btn btn-success">
                    <i class="fa fa-save"></i> Guardar
                </a>
            </div>

            <div class="btn-group" style="margin-top: 20px;">
                <g:if test="${item?.foto}">
                    <g:link action="downloadFile" id="${item.id}" params="[tipo: 'il']" class="btn btn-info">
                        <i class="fa fa-download"></i> Descargar
                    </g:link>
                </g:if>
            </div>
        </div>
    </g:uploadForm>

    <div class="alert alert-warning">
        <g:if test="${!item?.foto}">
            <p style="color: #800; font-size: 14px"><i class="fa fa-exclamation-triangle fa-2x"></i>  No se ha cargado ninguna ilustración para este material</p>
        </g:if>
        <g:else>
            Ilustración actual: <strong style="font-size: 14px"> ${item?.foto} </strong>
        </g:else>
    </div>

    <g:if test="${item?.foto}">
        <img src="${request.contextPath}/mantenimientoItems/getFoto?id=${item?.id}" style="width: 400px; height: 400px"/>
    </g:if>

</fieldset>


<script type="text/javascript">
    $("#submit").click(function () {
        $("#frmUpload").submit();
    });

    $(".submitEspe").click(function () {
        $("#frmUploadEspe").submit();
    });

    $("#submitWord").click(function () {
        $("#frmUploadWord").submit();
    });

    $("#salir").click(function () {
        window.close()
    });
</script>

</body>
</html>