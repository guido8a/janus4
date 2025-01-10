<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Mantenimiento precios desde excel</title>
</head>

<body>

<g:link class="btn btn-primary" controller="mantenimientoItems" action="precios">
    <i class="fa fa-arrow-left"></i>  Regresar </g:link>

<g:if test="${flash.message}">
    <div class="alert alert-error">
        ${flash.message}
    </div>
</g:if>

<div style="border-style: groove; border-color: #0d7bdc; margin-top: 10px; margin-bottom: 10px">
    <fieldset style="margin-bottom: 10px; padding: 20px">
        <h3 style="text-align: center">Mantenimiento de precios de Materiales Pétreos</h3>
        <h6 style="text-align: left">Formato del archivo de excel</h6>
        <table class="table" style="background-color: #5a7ab2; color: #fff; margin-top: 0px">
            <tr>
                <th style="border: 1px solid #ddd; text-align: center">
                    A - LISTA NUMERO
                </th>
                <th style="border: 1px solid #ddd; text-align: center">
                    B - LISTA
                </th>
                <th style="border: 1px solid #ddd; text-align: center">
                    C - TIPO DE LISTA
                </th>
                <th style="border: 1px solid #ddd; text-align: center">
                    D - ITEM NUMERO
                </th>
                <th style="border: 1px solid #ddd; text-align: center">
                    E - ITEM CÓDIGO
                </th>
                <th style="border: 1px solid #ddd; text-align: center">
                    F - MATERIALES PETREOS
                </th>
                <th style="border: 1px solid #ddd; text-align: center">
                    G - FECHA PRECIOS
                </th>
                <th style="border: 1px solid #ddd; text-align: center">
                    H - PRECIO UNITARIO
                </th>
                <th style="border: 1px solid #ddd; text-align: center">
                    I - PRECIO NUMERO
                </th>
                <th style="border: 1px solid #ddd; text-align: center">
                    J - NUEVO PRECIO
                </th>
            </tr>
        </table>
        <div class="row" style="margin-left: 100px">
            <div class="col-md-1">
                <label> Fecha </label>
            </div>

            <div class="col-md-2">
                <g:select name="buscarPorCnsm" class="form-control" from="${fechas}"
                          optionKey='key' optionValue="value" />
            </div>

            <div class="btn-group col-md-1">
                <a href="#" class="btn btn-warning" id="btnCrearExcelMaterialesPetreos">
                    <i class="fa fa-download"></i> Generar excel</a>
            </div>


            <g:uploadForm action="uploadFileMP" method="post" name="frmUpload" style="padding: 10px">
                <div id="list-grupo" class="col-md-12" role="main" style="margin: 10px 0 0 0">
                    <div class="col-md-6" style="margin-top: 20px">
                        <div class="col-md-2"><b>Archivo:</b></div>
                        <input type="file" class="required col-md-10" id="fileMP" name="file" multiple accept=".xlsx"/>
                    </div>

                    <div class="col-md-3" style="margin-top: 20px">
                        <div class="col-md-2">
                            <a href="#" class="btn btn-success" id="btnSubmitMP">
                                <i class="fa fa-upload"></i> Subir Archivo</a>
                        </div>
                    </div>
                </div>

            </g:uploadForm>


        </div>

    </fieldset>
</div>

<div style="border-style: groove; border-color: #0d7bdc">
    <fieldset style="margin-bottom: 10px">
        <div class="row">

            <div class="col-md-2"></div>

            <div class="col-md-3" id="divGrupos_2">

            </div>

            <div class="col-md-3" id="divSubgrupo">

            </div>

            <div class="btn-group col-md-1" >
                <a href="#" class="btn btn-warning" id="btnCrearExcelSubgrupo" style="margin-top: 20px">
                    <i class="fa fa-download"></i> Generar excel</a>
            </div>
        </div>

        <g:uploadForm action="uploadFileMP" method="post" name="frmUpload" style="padding: 10px">
            <div id="list-grupo" class="col-md-12" role="main" style="margin: 10px 0 0 0; height: 250px">
                <div class="" style="margin: 0 0 20px 0;">
                    <div class="col-md-9">
                        <div class="alert alert-info">
                            <strong style="font-size: 14px"><i class="fa fa-exclamation-triangle fa-2x text-warning"></i>  El archivo debe contener las siguientes columnas (los nombres de las columnas no son importantes):</strong>
                        </div>

                        <div class="col-md-1">
                            <label> Fecha </label>
                        </div>

                        <div class="col-md-2" style="align-items: center;">
                            <input aria-label="" name="fecha" id='fecha' type='text' class="fecha form-control" value="${new Date().format("dd-MM-yyyy")}" />
                        </div>

                        <table class="table" style="background-color: #5a7ab2; color: #fff; margin-top: 70px">
                            <tr>
                                <th style="border: 1px solid #ddd; text-align: center">
                                    A - CODIGO
                                </th>
                                <th style="border: 1px solid #ddd; text-align: center">
                                    B - ITEM
                                </th>
                                <th style="border: 1px solid #ddd; text-align: center">
                                    C - PRECIO
                                </th>
                                <th style="border: 1px solid #ddd; text-align: center">
                                    D - NUEVO PRECIO
                                </th>
                            </tr>
                        </table>
                    </div>
                </div>

                <div class="col-md-6" style="margin-top: 20px">
                    <div class="col-md-2"><b>Archivo:</b></div>
                    <input type="file" class="required" id="file" name="file" multiple accept=".xlsx"/>
                </div>
            </div>

            <div class="col-md-12" style="margin-top: 20px">
                <div class="col-md-2">
                    <a href="#" class="btn btn-success" id="btnSubmit"><i class="fa fa-upload"></i> Subir Archivo</a>
                </div>
            </div>
        </g:uploadForm>
    </fieldset>
</div>




<script type="text/javascript">

    $('#fecha').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        icons: {
        }
    });

    $("#btnCrearExcelMaterialesPetreos").click(function () {
        location.href = "${g.createLink(controller: 'reportesExcel', action:'reportePetreosExcel')}";
    });


    // cargarGrupos(1);
    cargarGrupos(2);

    function cargarGrupos(tipo){
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'mantenimientoItems',  action: 'comboGrupos_ajax')}",
            data    : {
                tipo: tipo
            },
            success : function (msg) {
                $("#divGrupos_" + tipo).html(msg)
            }
        });
    }

    $("#btnSubmit").click(function () {
        bootbox.confirm({
            title: "Subir archivo excel",
            message: "<i class='fa fa-exclamation-triangle text-warning fa-3x'></i> <strong style='font-size: 14px'> Antes de subir el archivo verifique la fecha </strong> ",
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
                    if ($("#frmUpload").valid()) {
                        var g = cargarLoader("Cargando...");
                        $("#frmUpload").submit();
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