<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Subir archivo excel CPC</title>
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
    <div class="col-md-9">
        <div class="breadcrumb" style="font-size: 14px; text-align: center">Formato del archivo: <strong>Excel xlsx</strong></div>
    </div>
</div>

<g:uploadForm controller="codigoComprasPublicas" action="uploadFile" method="post" name="frmUpload" style="padding: 5px">
    <g:hiddenField name="id" value="${contrato?.id}"/>
    <div id="list-grupo" class="col-md-12" role="main">
        <div class="col-md-1"></div>
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

    <div class="col-md-12">
        <div class="col-md-1"></div>
        <div class="col-md-9 alert alert-warning" style="font-size: 16px; font-weight: bold; text-align: center">
            <i class="fa fa-exclamation-triangle fa-2x text-danger"></i>
            Antes de cargar el archivo revise la fecha de registro
        </div>
    </div>

    <div class="col-md-12" style="margin-top: 20px;  height: 300px">
        <div class="col-md-1"></div>
        <div class="col-md-2">
            <div class="col-md-12">
                <div><b>Fecha de Registro:</b></div>
            </div>
            <input aria-label="" name="fecha" id='fechaRegistro' type='text' class="form-control required"
                   value="${new Date().format("dd-MM-yyyy")}" title="Fecha Registro"/>
        </div>
        <div class="col-md-5">
            <div class="col-md-12" style="text-align: center"><b>Archivo Excel a subir:</b></div>
            <input type="file" class="required" id="fileCrono" name="file" multiple accept=".xlsx"
                   style="width: 100%; font-size: 12pt" value="Arch"/>
        </div>
        <div class="col-md-2" style="margin-top: 10px">
            <a href="#" class="btn btn-success" id="btnSubmitCrono"><i class="fa fa-upload"></i>
                Subir archivo</a>
        </div>
    </div>

</g:uploadForm>

<script type="text/javascript">

    $('#fechaRegistro').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        icons: {
        }
    });

    $(".btnRegresar").click(function () {
        location.href="${createLink(controller: 'codigoComprasPublicas', action: 'list')}"
    });

    $("#btnSubmitCrono").click(function () {
        var fecha = $("#fechaRegistro").val();
        if ($("#frmUpload").valid()) {
            bootbox.confirm({
                title: "Cargar archivo excel CPC",
                message: "<i class='fa fa-exclamation-triangle text-warning fa-3x'></i> Está seguro de querer cargar el archivo excel y fijar valores del vae a la fecha de registro : " + '<strong>' + fecha  + '</strong>',
                buttons: {
                    cancel: {
                        label: '<i class="fa fa-times"></i> Cancelar',
                        className: 'btn-primary'
                    },
                    confirm: {
                        label: '<i class="fa fa-check"></i> Aceptar',
                        className: 'btn-success'
                    }
                },
                callback: function (result) {
                    if(result){
                        submitFormExcel();
                    }
                }
            });
        }else{
            return false
        }
    });

    function submitFormExcel() {
        var $form = $("#frmUpload");
        var formData = new FormData($("#frmUpload")[0]);
        var dialog = cargarLoader("Guardando...");
        $.ajax({
            type    : "POST",
            url     : $form.attr("action"),
            data    : formData,
            processData: false,
            contentType: false,
            success : function (msg) {
                dialog.modal('hide');
                var parts = msg.split("_");
                if(parts[0] === 'ok'){
                    bootbox.alert('<i class="fa fa-check text-success fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                    return false;
                }else{
                    bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                    return false;
                }
            }
        });
    }

</script>
</body>
</html>