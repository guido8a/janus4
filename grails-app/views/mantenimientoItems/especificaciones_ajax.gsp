<div class="row">
    <div class="" style="width: 99.7%;height: 650px; overflow-y: auto;float: right; margin-top: -20px">

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
                    <i class="fa fa-file-pdf fa-2x"></i> Especificación PDF: ${!ares?.ruta ? 'No se ha cargado ninguna especificación PDF para este material' : ares?.ruta}
                </div>
            </div>

            <div class="col-md-12">
                <g:if test="${!tipo}">
                    <g:uploadForm action="uploadFileEspecificacion" method="post" name="frmUploadEspe" enctype="multipart/form-data">
                        <g:hiddenField name="item" value="${item?.id}"/>
                        <g:hiddenField name="tipo" value="pdf"/>
                        <div class="fieldcontain required">
                            <b>Cargar archivo PDF:</b>
                            <input type="file" id="fileEspePDF" name="file" class="" multiple accept=".pdf"/>
                            <div class="btn-group" style="margin-top: 20px;">
                                <a href="#" class="btn btn-success submitEspe" data-id="${item?.id}">
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
                                    <a href="#" class="btnBorrarPDF btn btn-danger" data-id="${item?.id}">
                                        <i class="fa fa-trash"></i> Borrar
                                    </a>
                                </div>
                            </g:if>
                        </div>
                    </g:uploadForm>
                </g:if>
                <g:else>
                    <g:if test="${ares?.ruta}">
                        <div class="btn-group" style="margin-top: 20px;">
                            <g:link action="downloadFile" id="${item.id}" params="[tipo: 'pdf']" class="btn btn-info">
                                <i class="fa fa-download"></i> Descargar
                            </g:link>
                        </div>
                    </g:if>
                </g:else>
            </div>
        </div>

        <div class="col-md-12" style="margin-bottom: 10px">
            <div class="alert-info col-md-12" style="font-size: 14px; font-weight: bold">
                <div class="col-md-12">
                    <i class="fa fa-file-word fa-2x"></i> Especificación WORD: ${!ares?.especificacion ? 'No se ha cargado ninguna especificación WORD para este material' : ares?.especificacion}
                </div>
            </div>

            <g:if test="${existe}">
                <div class="col-md-12">
                    <g:if test="${!tipo}">
                        <g:uploadForm action="uploadFileEspecificacion" method="post" name="frmUploadWord" enctype="multipart/form-data">
                            <g:hiddenField name="item" value="${item?.id}"/>
                            <g:hiddenField name="tipo" value="word"/>
                            <div class="fieldcontain required">
                                <b>Cargar archivo WORD:</b>
                                <input type="file" id="fileEspe" name="file" class=""  multiple accept=".doc, .docx"/>

                                <div class="btn-group" style="margin-top: 20px;">
                                    <a href="#" class="submitWord btn btn-success" data-id="${item?.id}">
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
                                        <a href="#" class=" btnBorrarWord btn btn-danger" data-id="${item?.id}">
                                            <i class="fa fa-trash"></i> Borrar
                                        </a>
                                    </div>
                                </g:if>
                            </div>
                        </g:uploadForm>
                    </g:if>
                    <g:else>
                        <g:if test="${ares?.especificacion}">
                            <div class="btn-group" style="margin-top: 20px;">

                                <g:link action="downloadFile" id="${item.id}" params="[tipo: 'wd']" class="btn btn-info">
                                    <i class="fa fa-download"></i> Descargar
                                </g:link>
                            </div>
                        </g:if>
                    </g:else>
                </div>
            </g:if>
        </div>

        <div class="col-md-12">
            <div class="alert-success col-md-12" style="font-size: 14px; font-weight: bold">
                <div class="col-md-12">
                    <i class="fa fa-image fa-2x"></i>  Ilustración: ${!item?.foto ? 'No se ha cargado ninguna ilustración para este material' : item?.foto}
                </div>
            </div>
            <g:if test="${!tipo}">
                <g:uploadForm action="uploadFileIlustracion" method="post" name="frmUploadImagen" enctype="multipart/form-data">
                    <g:hiddenField name="item" value="${item?.id}"/>
                    <div class="fieldcontain required col-md-12">
                        <b>Cargar archivo:</b>
                        <input type="file" id="file" name="file" class="" multiple accept=".jpg, .jpeg, .png, .gif"/>
                        <div class="btn-group" style="margin-top: 20px;">
                            <a href="#" class="submit btn btn-success" data-id="${item?.id}">
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
            </g:if>
            <g:else>
                <g:if test="${item?.foto}">
                    <div class="btn-group" style="margin-top: 20px;">
                        <g:link action="downloadFile" id="${item.id}" params="[tipo: 'il']" class="btn btn-info">
                            <i class="fa fa-download"></i> Descargar
                        </g:link>
                    </div>
                </g:if>
            </g:else>

            <g:if test="${item?.foto}">
                <div class="col-md-12" id="divImagenMateriales">
                    %{--                    <img src="${request.contextPath}/mantenimientoItems/getFoto?id=${item?.id}" style="width: 400px; height: 400px"/>--}%
                </div>
            </g:if>

        </div>
    </div>
</div>

<script type="text/javascript">

    $(".submitEspe").click(function () {
        var id = $(this).data("id");
        submitPdf(id);
    });

    $(".submitWord").click(function () {
        var id = $(this).data("id");
        submitWord(id);
    });

    $(".submit").click(function () {
        var id = $(this).data("id");
        submitImagen(id);
    });

    function submitPdf(id) {
        var $form = $("#frmUploadEspe");
        var formData = new FormData($form[0]);
        $.ajax({
            type    : "POST",
            url     : $form.attr("action"),
            data    : formData,
            contentType: false,
            processData: false,
            success : function (msg) {
                var parts = msg.split("_");
                if(parts[0] === 'ok'){
                    log(parts[1], "success");
                    cerrarEspecificaciones();
                    cargarEspecificaciones(id);
                }else{
                    bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                    return false;
                }
            }
        });
    }

    function submitWord(id) {
        var $form = $("#frmUploadWord");
        var formData = new FormData($form[0]);
        $.ajax({
            type    : "POST",
            url     : $form.attr("action"),
            data    : formData,
            contentType: false,
            processData: false,
            success : function (msg) {
                var parts = msg.split("_");
                if(parts[0] === 'ok'){
                    log(parts[1], "success");
                    cerrarEspecificaciones();
                    cargarEspecificaciones(id);
                }else{
                    bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                    return false;
                }
            }
        });
    }

    function submitImagen(id) {
        var $form = $("#frmUploadImagen");
        var formData = new FormData($form[0]);
        $.ajax({
            type    : "POST",
            url     : $form.attr("action"),
            data    : formData,
            contentType: false,
            processData: false,
            success : function (msg) {
                var parts = msg.split("_");
                if(parts[0] === 'ok'){
                    log(parts[1], "success");
                    cerrarEspecificaciones();
                    cargarEspecificaciones(id);
                    cargarImagenMateriales();
                }else{
                    bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                    return false;
                }
            }
        });
    }

    $(".btnBorrarPDF").click(function (){
        var id = $(this).data("id");
        deleteArchivo(id, 'pdf');
    });

    $(".btnBorrarWord").click(function (){
        var id = $(this).data("id");
        deleteArchivo(id, 'word');
    });

    $(".btnBorrarImagen").click(function (){
        var id = $(this).data("id");
        deleteArchivo(id, 'imagen');
    });

    function deleteArchivo(id, tipo){
        bootbox.confirm({
            title: "Eliminar archivo",
            message: '<i class="fa fa-trash text-danger fa-3x"></i>' + '<strong style="font-size: 14px">' + "Está seguro de borrar este documento? Esta acción no puede deshacerse. " + '</strong>' ,
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
                        url: '${createLink(action: 'borrarArchivo_ajax')}',
                        data:{
                            id: id,
                            tipo: tipo
                        },
                        success: function (msg) {
                            dialog.modal('hide');
                            var parts = msg.split("_");
                            if(parts[0] === 'ok'){
                                log(parts[1],"success");
                                cerrarEspecificaciones();
                                cargarEspecificaciones(id);
                                cargarImagenMateriales();
                            }else{
                                log(parts[1], "error")
                            }
                        }
                    });
                }
            }
        });
    }

    cargarImagenMateriales();

    function cargarImagenMateriales() {
        var id = '${item?.id}';
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'mantenimientoItems', action: 'imagenMateriales_ajax')}",
            data    : {
                id: id
            },
            success : function (msg) {
                $("#divImagenMateriales").html(msg)
            }
        });
    }

</script>
