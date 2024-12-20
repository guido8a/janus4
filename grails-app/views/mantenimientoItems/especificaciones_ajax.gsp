%{--<%@ page contentType="text/html;charset=UTF-8" %>--}%
%{--<html>--}%
%{--<head>--}%
%{--    <title>Especificaciones e Ilustraciones de: ${item?.nombre}</title>--}%

%{--    <asset:javascript src="/jquery/jquery-2.2.4.js"/>--}%
%{--    <asset:javascript src="/jquery/jquery-ui-1.10.2.custom.js"/>--}%
%{--    <asset:stylesheet src="/bootstrap-3.3.2/dist/css/bootstrap.css"/>--}%
%{--    <asset:stylesheet src="/bootstrap-3.3.2/dist/css/bootstrap-theme.css"/>--}%
%{--    <asset:javascript src="/apli/fontawesome.all.min.js"/>--}%
%{--    <asset:stylesheet src="/apli/font-awesome.min.css"/>--}%
%{--    <asset:javascript src="/apli/functions.js"/>--}%
%{--    <asset:stylesheet src="/jquery/jquery-ui-1.10.3.custom.min.css"/>--}%

%{--</head>--}%

%{--<body style="padding: 20px;">--}%

<div class="row">

    %{--    <div class="col-md-12">--}%
    <div class="" style="width: 99.7%;height: 500px; overflow-y: auto;float: right; margin-top: -20px">

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

        <div class="breadcrumb col-md-12" style="font-weight: bold; font-size: 14px; text-align: center">
            Nombre: ${item?.nombre}<br/>
            Código: ${item?.codigo} - Especificación: ${item?.codigoEspecificacion}
        </div>

        <div class="col-md-12" style="margin-bottom: 10px">
            <div class="alert-warning col-md-12" style="font-size: 14px; font-weight: bold">
                <div class="col-md-12">
                    <i class="fa fa-file-pdf fa-2x"></i> Especificación PDF
                </div>

                <div class="col-md-12">
                    <g:if test="${!ares?.ruta}">
                        No se ha cargado ninguna especificación PDF para este material
                    </g:if>
                    <g:else>
                        Especificación actual PDF: <strong style="font-size: 14px"> ${ares?.ruta} </strong>
                    </g:else>
                </div>
            </div>

            <div class="col-md-12">
                <g:uploadForm action="uploadFileEspecificacion" method="post" name="frmUploadEspe" enctype="multipart/form-data">
                    <g:hiddenField name="item" value="${item?.id}"/>
                    <g:hiddenField name="tipo" value="pdf"/>
                    <div class="fieldcontain required">
                        <b>Cargar archivo PDF:</b>
                        <input type="file" id="fileEspePDF" name="file" class="" multiple accept=".pdf"/>
                        <div class="btn-group" style="margin-top: 20px;">
                            <a href="#" class="btn btn-success submitEspe">
                                <i class="fa fa-save"></i> Guardar
                            </a>
                        </div>

                        <g:if test="${ares?.ruta}">
                            <div class="btn-group" style="margin-top: 20px;">
                                <g:link action="downloadFile" id="${item.id}" params="[tipo: 'pdf']" class="btn btn-info">
                                    <i class="fa fa-download"></i> Descargar
                                </g:link>
                            </div>
                            <div class="btn-group" style="margin-top: 20px;">
                                <a href="#" id="btnBorrarPDF" class="btn btn-danger">
                                    <i class="fa fa-trash"></i> Borrar
                                </a>
                            </div>
                        </g:if>
                    </div>
                </g:uploadForm>
            </div>
        </div>


        <div class="col-md-12" style="margin-bottom: 10px">
            <div class="alert-info col-md-12" style="font-size: 14px; font-weight: bold">
                <div class="col-md-12">
                    <i class="fa fa-file-word fa-2x"></i> Especificación WORD
                </div>

                <div class="col-md-12">
                    <g:if test="${!ares?.especificacion}">
                        No se ha cargado ninguna especificación WORD para este material
                    </g:if>
                    <g:else>
                        Especificación actual WORD: <strong style="font-size: 14px"> ${ares?.especificacion} </strong>
                    </g:else>
                </div>
            </div>

            <g:if test="${existe}">
                <div class="col-md-12">
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

                            <g:if test="${ares?.especificacion}">
                                <div class="btn-group" style="margin-top: 20px;">

                                    <g:link action="downloadFile" id="${item.id}" params="[tipo: 'wd']" class="btn btn-info">
                                        <i class="fa fa-download"></i> Descargar
                                    </g:link>
                                </div>
                                <div class="btn-group" style="margin-top: 20px;">
                                    <a href="#" id="btnBorrarWord" class="btn btn-danger">
                                        <i class="fa fa-trash"></i> Borrar
                                    </a>
                                </div>
                            </g:if>
                        </div>
                    </g:uploadForm>
                </div>
            </g:if>
        </div>

        <div class="col-md-12">
            <div class="alert-success col-md-12" style="font-size: 14px; font-weight: bold">
                <div class="col-md-12">
                    <i class="fa fa-image fa-2x"></i>  Ilustración
                </div>
                <div class="col-md-12">
                    <g:if test="${!item?.foto}">
                        No se ha cargado ninguna ilustración para este material
                    </g:if>
                    <g:else>
                        Ilustración actual: <strong style="font-size: 14px"> ${item?.foto} </strong>
                    </g:else>
                </div>
            </div>

            <g:uploadForm action="uploadFileIlustracion" method="post" name="frmUpload" enctype="multipart/form-data">
                <g:hiddenField name="item" value="${item?.id}"/>
                <div class="fieldcontain required col-md-12">
                    <b>Cargar archivo:</b>
                    <input type="file" id="file" name="file" class="" multiple accept=".jpg, .jpeg, .png, .gif"/>
                    <div class="btn-group" style="margin-top: 20px;">
                        <a href="#" id="submitImagen" class="btn btn-success">
                            <i class="fa fa-save"></i> Guardar
                        </a>
                    </div>

                    <g:if test="${item?.foto}">
                        <div class="btn-group" style="margin-top: 20px;">
                            <g:link action="downloadFile" id="${item.id}" params="[tipo: 'il']" class="btn btn-info">
                                <i class="fa fa-download"></i> Descargar
                            </g:link>
                        </div>
                        <div class="btn-group" style="margin-top: 20px;">
                            <a href="#" class="btnBorrarImagen btn btn-danger" data-id="${item?.id}">
                                <i class="fa fa-trash"></i> Borrar
                            </a>
                        </div>
                    </g:if>
                </div>
            </g:uploadForm>

            <g:if test="${item?.foto}">
                <div class="col-md-12">
                    <img src="${request.contextPath}/mantenimientoItems/getFoto?id=${item?.id}" style="width: 400px; height: 400px"/>
                </div>
            </g:if>

        </div>
    </div>
</div>

<script type="text/javascript">
    
    $("#submitImagen").click(function () {
        
    })

    $(".btnBorrarImagen").click(function (){
        var id = $(this).data("id");
        deleteImagen(id);
    });

    function deleteImagen(id){
        bootbox.confirm({
            title: "Eliminar imagen",
            message: '<i class="fa fa-trash text-danger fa-3x"></i>' + '<strong style="font-size: 14px">' + "Está seguro de borrar esta imagen? Esta acción no puede deshacerse. " + '</strong>' ,
            buttons: {
                cancel: {
                    label: '<i class="fa fa-times"></i> Cancelar',
                    className: 'btn-primary'
                },
                confirm: {
                    label: '<i class="fa fa-trash"></i> Borrar',
                    className: 'btn-danger'
                }
            },
            callback: function (result) {
                if(result){
                    var dialog = cargarLoader("Borrando...");
                    $.ajax({
                        type: 'POST',
                        url: '${createLink(action: 'borrarImagen_ajax')}',
                        data:{
                            id: id
                        },
                        success: function (msg) {
                            dialog.modal('hide');
                            var parts = msg.split("_");
                            if(parts[0] === 'ok'){
                                log(parts[1],"success");
                                cerrarEspecificaciones();
                                cargarEspecificaciones(id);
                            }else{
                                log(parts[1], "error")
                            }
                        }
                    });
                }
            }
        });
    }

    $("#submit").click(function () {
        $("#frmUpload").submit();
    });

    $(".submitEspe").click(function () {
        $("#frmUploadEspe").submit();
    });

    $("#submitWord").click(function () {
        $("#frmUploadWord").submit();
    });

    // $("#salir").click(function () {
    //     window.close()
    // });
</script>

%{--</body>--}%
%{--</html>--}%