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
    <fieldset style="margin-bottom: 10px; padding: 0px 20px 0px 20px">
        <h3 style="text-align: center">Mantenimiento de precios de Materiales Pétreos</h3>
        <h6 style="text-align: left">Formato del archivo de excel</h6>
        <table class="table" style="background-color: #5a7ab2; color: #fff; margin-bottom: 30px">
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
        <div class="row">

            <div class="btn-group col-md-6" style="margin-left: 10px; height: 65px">
                <p> Generar el archivo excel para actualizar precios, en el archivo generado,
                ingrese los nuevos precios (columna Nuevo Precio) y suba el archivo al sistema para
                    que se registren en el sistema
                </p>
            </div>
            <div class="btn-group col-md-5" style="margin-left: 10px; height: 65px">
                <a href="#" class="btn btn-warning" id="btnCrearExcelMaterialesPetreos">
                    <i class="fa fa-download"></i> Generar archivo de excel</a>
            </div>

            <div class="col-md-12" style="background-color: #dadad0;
                border-style: solid; border-color: #606060; border-radius: 4px; border-width: thin;
                padding: 10px; margin-top: -10px">
            <g:uploadForm action="uploadPetreos" method="post" name="frmPetreos" style="margin-top: -20px">
                <div id="list-grupo" class="col-md-12" style="margin: 0px 0 0 0">

                    <div class="col-md-1" style="margin-top: 20px">
                        <label style="text-align: right; width: 100%"> Fecha de precios </label>
                    </div>

                    <div class="col-md-2" style="margin-top: 20px">
                        <g:select name="fechaPetreos" class="form-control" from="${fechas}"
                                  optionKey='key' optionValue="value" style="width: 120px"/>
                    </div>


                    <div class="col-md-7" style="margin-top: 20px; margin-left: -20px">
                        <div class="col-md-3"><b>Archivo de precios excel a subir (modificado):</b></div>
                        <input type="file" class="required col-md-9" id="fileMP" name="file"
                               multiple accept=".xlsx" style="margin-top: 10px"/>
                    </div>

                    <div class="col-md-2" style="margin-top: 20px">
                        <div class="col-md-2">
                            <a href="#" class="btn btn-success" id="btnPetreos">
                                <i class="fa fa-upload"></i> Subir Archivo</a>
                        </div>
                    </div>
                </div>

            </g:uploadForm>
            </div>
        </div>

    </fieldset>
</div>

<div style="border-style: groove; border-color: #0d7bdc; margin-top: 10px; margin-bottom: 10px">
    <fieldset style="margin-bottom: 10px; padding: 0px 20px 0px 20px">
        <h3 style="text-align: center">Mantenimiento de precios por Grupos y Subgrupos</h3>
        <h6 style="text-align: left">Formato del archivo de excel</h6>

        <table class="table" style="background-color: #5a7ab2; color: #fff; margin-bottom: 30px">
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

        <div class="row">

            <div class="col-md-5" id="divGrupos_2">

            </div>

            <div class="col-md-5" id="divSubgrupo">

            </div>

            <div class="btn-group col-md-1" >
                <a href="#" class="btn btn-warning" id="btnCrearExcelSubgrupo" style="margin-top: 20px">
                    <i class="fa fa-download"></i> Generar archivo de excel</a>
            </div>
        </div>

        <g:uploadForm action="uploadGrupoySubgrupo" method="post" name="frmGrupo" style="padding: 10px">

            <div class="col-md-12" style="background-color: #dadad0;
                border-style: solid; border-color: #606060; border-radius: 4px; border-width: thin;
                padding: 10px; margin-top: 10px">

                <div class="col-md-1" style="margin-top: 20px">
                    <label style="text-align: right; width: 100%"> Fecha de precios </label>
                </div>

                <div class="col-md-2" style="margin-top: 20px">
                    <g:select name="fechaGrupo" class="form-control" from="${fechas}"
                              optionKey='key' optionValue="value" style="width: 120px"/>
                </div>

                <div class="col-md-6" style="margin-top: 20px">
                    <div class="col-md-2"><b>Archivo:</b></div>
                    <input type="file" class="required col-md-10" id="file" name="file" multiple accept=".xlsx"/>
                </div>

                <div class="col-md-2" style="margin-top: 10px">
                    <a href="#" class="btn btn-success" id="btnGrupos"><i class="fa fa-upload"></i> Subir Archivo</a>
                </div>
            </div>
        </g:uploadForm>
    </fieldset>
</div>

<div style="border-style: groove; border-color: #0d7bdc; margin-top: 10px; margin-bottom: 10px">
    <fieldset style="margin-bottom: 10px; padding: 0px 20px 0px 20px">
        <h3 style="text-align: center">Mantenimiento de precios por Mano de obra y equipos</h3>
        <h6 style="text-align: left">Formato del archivo de excel</h6>
        <table class="table" style="background-color: #5a7ab2; color: #fff; margin-bottom: 30px">
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
                    F - ITEM NOMBRE
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
        <div class="row">

            <div class="btn-group col-md-6" style="margin-left: 10px; height: 65px">
                <p> Generar el archivo excel para actualizar precios, en el archivo generado,
                ingrese los nuevos precios (columna Nuevo Precio) y suba el archivo al sistema para
                que se registren en el sistema
                </p>
            </div>
            <div class="btn-group col-md-5" style="margin-left: 10px; height: 65px">
                <a href="#" class="btn btn-warning" id="btnCrearExcelManoObra">
                    <i class="fa fa-download"></i> Generar archivo de excel</a>
            </div>

            <div class="col-md-12" style="background-color: #dadad0;
            border-style: solid; border-color: #606060; border-radius: 4px; border-width: thin;
            padding: 10px; margin-top: -10px">
                <g:uploadForm action="uploadMO" method="post" name="frmMO" style="margin-top: -20px">
                    <div id="list-grupo" class="col-md-12" style="margin: 0px 0 0 0">

                        <div class="col-md-1" style="margin-top: 20px">
                            <label style="text-align: right; width: 100%"> Fecha de precios </label>
                        </div>

                        <div class="col-md-2" style="margin-top: 20px">
                            <g:select name="fechaMO" class="form-control" from="${fechas}"
                                      optionKey='key' optionValue="value" style="width: 120px"/>
                        </div>


                        <div class="col-md-7" style="margin-top: 20px; margin-left: -20px">
                            <div class="col-md-3"><b>Archivo de precios excel a subir (modificado):</b></div>
                            <input type="file" class="required col-md-9" id="fileMO" name="file"
                                   multiple accept=".xlsx" style="margin-top: 10px"/>
                        </div>

                        <div class="col-md-2" style="margin-top: 20px">
                            <div class="col-md-2">
                                <a href="#" class="btn btn-success" id="btnSubirManoObra">
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

    $("#btnCrearExcelSubgrupo").click(function () {
        location.href = "${g.createLink(controller: 'reportesExcel', action:'reporteGruposExcel')}?grupo=" + $("#grupo_2 option:selected").val() + "&subgrupo=" + $("#subgrupo option:selected").val();
    });

    $("#btnCrearExcelManoObra").click(function () {
        location.href = "${g.createLink(controller: 'reportesExcel', action:'reporteManoObraExcel')}";
    });

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

    $("#btnPetreos").click(function () {
        var fecha = $("#fechaPetreos").find(":selected").text();
        bootbox.confirm({
            title: "Subir archivo excel",
            message: "<i class='fa fa-exclamation-triangle text-warning fa-3x'></i> " +
                "Se crearán los precios según el archivo indicado para la fecha de <strong style='font-size: 14px'> " +
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
                    if ($("#frmPetreos").valid()) {
                        var g = cargarLoader("Cargando...");
                        $("#frmPetreos").submit();
                        g.modal("hide");
                    }else{

                    }
                }
            }
        });
    });


    $("#btnSubirManoObra").click(function(){
        var fecha = $("#fechaMO").find(":selected").text();
        bootbox.confirm({
            title: "Subir archivo excel",
            message: "<i class='fa fa-exclamation-triangle text-warning fa-3x'></i> " +
                "Se crearán los precios según el archivo indicado para la fecha de <strong style='font-size: 14px'> " +
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
                    if ($("#frmMO").valid()) {
                        var g = cargarLoader("Cargando...");
                        $("#frmMO").submit();
                        g.modal("hide");
                    }else{

                    }
                }
            }
        });
    });

    $("#btnGrupos").click(function(){
        var fecha = $("#fechaGrupo").find(":selected").text();
        bootbox.confirm({
            title: "Subir archivo excel",
            message: "<i class='fa fa-exclamation-triangle text-warning fa-3x'></i> " +
                "Se crearán los precios según el archivo indicado para la fecha de <strong style='font-size: 14px'> " +
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
                    if ($("#frmGrupo").valid()) {
                        var g = cargarLoader("Cargando...");
                        $("#frmGrupo").submit();
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