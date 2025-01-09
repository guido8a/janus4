<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Subir archivo excel mantenimiento precios</title>
</head>

<body>

<g:link class="btn btn-primary" controller="item" action="mantenimientoPrecios"> <i class="fa fa-arrow-left"></i>  Regresar </g:link>

<g:if test="${flash.message}">
    <div class="alert alert-error">
        ${flash.message}
    </div>
</g:if>

<div style="border-style: groove; border-color: #0d7bdc; margin-top: 10px; margin-bottom: 10px">
    <fieldset style="margin-bottom: 10px">
        <div class="row">

            <div class="col-md-2"></div>

            <div class="col-md-3">
                <g:textField name="materialesPetreos" value="${"Materiales Pétreos"}" class="form-control" readonly=""/>
            </div>

            <div class="btn-group col-md-1">
                <a href="#" class="btn btn-warning" id="btnCrearExcelMaterialesPetreos"><i class="fa fa-download"></i> Generar excel</a>
            </div>
        </div>
    </fieldset>
</div>

%{--<div style="border-style: groove; border-color: #0d7bdc; margin-bottom: 10px">--}%
%{--    <fieldset style="margin-bottom: 10px">--}%
%{--        <div class="row">--}%

%{--            <div class="col-md-2"></div>--}%

%{--            <div class="col-md-3" id="divGrupos_1">--}%

%{--            </div>--}%

%{--            <div class="btn-group col-md-1">--}%
%{--                <a href="#" class="btn btn-warning" id="btnCrearExcelGrupo"><i class="fa fa-download"></i> Generar excel</a>--}%
%{--            </div>--}%
%{--        </div>--}%
%{--    </fieldset>--}%
%{--</div>--}%


<div style="border-style: groove; border-color: #0d7bdc">
    <fieldset style="margin-bottom: 10px">
        <div class="row">

            <div class="col-md-2"></div>

            <div class="col-md-3" id="divGrupos_2">

            </div>

            <div class="col-md-3" id="divSubgrupo">

            </div>

            <div class="btn-group col-md-1">
                <a href="#" class="btn btn-warning" id="btnCrearExcelSubgrupo"><i class="fa fa-download"></i> Generar excel</a>
            </div>
        </div>
    </fieldset>
</div>


<g:uploadForm action="uploadFileMP" method="post" name="frmUpload" style="padding: 10px">
    <div id="list-grupo" class="col-md-12" role="main" style="margin: 10px 0 0 0; height: 380px">
        <div class="" style="margin: 0 0 20px 0;">
            <div class="col-md-9">
                <div class="alert alert-info">
                    <strong style="font-size: 14px"> Mantenimiento Items </strong> <br>
                    <strong style="font-size: 14px"><i class="fa fa-exclamation-triangle fa-2x text-warning"></i>  El archivo debe contener 4 columnas (los nombres de las columnas no son importantes):</strong>
                </div>

%{--                <div class="col-md-2" >--}%
%{--                    <label>    Lista de precios </label>--}%
%{--                </div>--}%
%{--                <div class="col-md-4" align="center">--}%
%{--                    <g:select class="form-control listPrecio span2" name="listaPrecio"--}%
%{--                              from="${janus.Lugar.list([sort: 'descripcion'])}" optionKey="id"--}%
%{--                              optionValue="${{ it.descripcion }}"--}%
%{--                              disabled="false" />--}%
%{--                </div>--}%

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
        <a href="#" class="btn btn-success" id="btnSubmit"><i class="fa fa-upload"></i> Subir Archivo</a>
    </div>


</g:uploadForm>

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