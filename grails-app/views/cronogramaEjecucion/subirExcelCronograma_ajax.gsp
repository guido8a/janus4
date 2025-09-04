<div class="row">
    <div class="" style="width: 99.7%;height: 180px; overflow-y: auto;float: right; margin-top: -20px">

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
            Obra: ${contrato?.obra?.nombre}<br/>
        </div>

        <div class="col-md-12" style="margin-bottom: 10px">
            <g:uploadForm action="uploadFileExcel" method="post" name="frmUploadExcel" enctype="multipart/form-data">
                <g:hiddenField name="contrato" value="${contrato?.id}"/>
                <div class="fieldcontain required">
                    <b>Cargar archivo EXCEL(xlsx):</b>
                    <input type="file" id="fileExcel" name="file" class="required" required  multiple accept=".xlsx"/>
                </div>
                <div class="btn-group" style="margin-top: 30px;">
                    <a href="#" class="btn btn-success submitExcelCrono" data-id="${contrato?.id}">
                        <i class="fa fa-upload"></i> Subir
                    </a>
                </div>
            </g:uploadForm>
        </div>
    </div>
</div>

<script type="text/javascript">

    $(".submitExcelCrono").click(function () {
        var id = $(this).data("id");
        submitExcel(id);
    });

    function submitExcel(id) {
        var $form = $("#frmUploadExcel");
        if ($("#frmUploadExcel").valid()) {
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
                        cerrarCargarExcelCronograma();
                    }else{
                        bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                        return false;
                    }
                }
            });
        }
    }

</script>
