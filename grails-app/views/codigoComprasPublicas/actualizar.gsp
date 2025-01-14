<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Descarga e ingreso del CPC</title>
</head>

<body>

%{--<g:link class="btn btn-primary" controller="mantenimientoItems" action="precios">--}%
%{--    <i class="fa fa-arrow-left"></i>  Regresar--}%
%{--</g:link>--}%

<div style="border-style: groove; border-color: #0d7bdc; margin-top: 10px; margin-bottom: 10px">
    <fieldset style="margin-bottom: 10px; padding: 0px 20px 0px 20px">
        <div class="col-md-3">

        </div>
        <div class="col-md-4" style="margin-top: 10px; font-size: 14px; font-weight: bold">
            Página de descarga del archivo excel del CPC
        </div>
        <div class="col-md-2" style="margin-top: 10px">
            <a href="https://app.powerbi.com/view?r=eyJrIjoiYjRlZjg5YzItOWM4Ni00MGNkLWI1OGYtZDA4M
            DAxNGYyNDQyIiwidCI6ImQ2NDk2NzM4LWY5MTItNGExZS04NDE1LTQwY2E2ZjRhOTRlZCJ9" target="_blank" class="btn btn-warning"> <i class="fa fa-download"></i> Link de descarga </a>.
        </div>
    </fieldset>
</div>

<div style="border-style: groove; border-color: #0d7bdc; margin-top: 10px; margin-bottom: 10px">
    <fieldset style="margin-bottom: 10px; padding: 0px 20px 0px 20px">
        <h6 style="text-align: left">Formato del archivo de excel</h6>
        <table class="table" style="background-color: #5a7ab2; color: #fff; margin-bottom: 30px">
            <tr>
                <th style="border: 1px solid #ddd; text-align: center">
                    A - IDENTIFICADOR DEL PRODUCTO CPC
                </th>
                <th style="border: 1px solid #ddd; text-align: center">
                    B - DESCRIPCIÓN DEL PRODUCTO
                </th>
                <th style="border: 1px solid #ddd; text-align: center">
                    C - UMBRAL VAE
                </th>
            </tr>
        </table>
    </fieldset>
</div>

<div style="border-style: groove; border-color: #0d7bdc; margin-top: 10px; margin-bottom: 10px">
    <fieldset style="margin-bottom: 10px; padding: 0px 20px 0px 20px">
        <h3 style="text-align: center">Actualizar CPC</h3>
        <div class="row">
            <div class="col-md-12" style="background-color: #dadad0;
            border-style: solid; border-color: #606060; border-radius: 4px; border-width: thin;
            padding: 10px; margin-top: -10px">
                <g:uploadForm action="uploadCpc" method="post" name="frmCPC" style="margin-top: -20px">
                    <div id="list-grupo" class="col-md-12" style="margin: 0px 0 0 0">
                        <div class="col-md-7" style="margin-top: 20px; margin-left: -20px">
                            <div class="col-md-3"><b>Archivo excel a subir:</b></div>
                            <input type="file" class="required col-md-9" id="fileCpc" name="file"
                                   multiple accept=".xlsx" style="margin-top: 10px"/>
                        </div>

                        <div class="col-md-2" style="margin-top: 20px">
                            <div class="col-md-2">
                                <a href="#" class="btn btn-success" id="btnSubirCpc">
                                    <i class="fa fa-upload"></i> Subir Archivo</a>
                            </div>
                        </div>
                    </div>

                </g:uploadForm>
            </div>
        </div>

    </fieldset>
</div>

<script type="text/javascript">

    $("#btnIrUrl").click(function () {
        location.href = new URL('https://app.powerbi.com/view?r=eyJrIjoiYjRlZjg5YzItOWM4Ni00MGNkLWI1OGYtZDA4MDAxNGYyNDQyIiwidCI6ImQ2NDk2NzM4LWY5MTItNGExZS04NDE1LTQwY2E2ZjRhOTRlZCJ9')
    });

    $("#btnSubirCpc").click(function(){
        var fecha = $("#fechaMO").find(":selected").text();
        bootbox.confirm({
            title: "Subir archivo excel",
            message: "<i class='fa fa-exclamation-triangle text-warning fa-3x'></i> " +
                "Se actualizará el CPC <strong style='font-size: 14px'> " +
                fecha + "</strong> ",
            buttons: {
                cancel: {
                    label: '<i class="fa fa-times"></i> Cancelar',
                    className: 'btn-primary'
                },
                confirm: {
                    label: '<i class="fa fa-upload"></i> Aceptar',
                    className: 'btn-success'
                }
            },
            callback: function (result) {
                if(result){
                    if ($("#frmCPC").valid()) {
                        var g = cargarLoader("Cargando...");
                        $("#frmCPC").submit();
                        g.modal("hide");
                    }else{

                    }
                }
            }
        });
    });

</script>
</body>
</html>