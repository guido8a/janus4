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
    </fieldset>
</div>

<div style="border-style: groove; border-color: #0d7bdc; margin-top: 10px; margin-bottom: 10px">
    <fieldset style="margin-bottom: 10px; padding: 0px 20px 0px 20px">
        <h3 style="text-align: center">Mantenimiento de precios de Materiales Pétreos</h3>
        <div class="row">
            <div class="btn-group col-md-6" style="margin-left: 10px; height: 65px">
                <p>




                </p>
            </div>
            <div class="btn-group col-md-5" style="margin-left: 10px; height: 65px">
                <a href="#" class="btn btn-warning" id="btnIrUrl">
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

<script type="text/javascript">

    $("#btnIrUrl").click(function () {
        location.href = new URL('https://app.powerbi.com/view?r=eyJrIjoiYjRlZjg5YzItOWM4Ni00MGNkLWI1OGYtZDA4MDAxNGYyNDQyIiwidCI6ImQ2NDk2NzM4LWY5MTItNGExZS04NDE1LTQwY2E2ZjRhOTRlZCJ9').getText()
    });

</script>
</body>
</html>