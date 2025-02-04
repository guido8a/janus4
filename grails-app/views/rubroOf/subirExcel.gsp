<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Subir archivo excel contrato</title>
    <style type="text/css">
    table, th, td {
        border: 1px solid white;
    }

    .contenedor {
        width: 100%;
        border: 1px solid #888;
        /*overflow-x: scroll;*/
        /*overflow-y: hidden;*/
        white-space: nowrap;
        background-color: #b8c8d8;
        height: 35px;
        padding: 2px;
        margin-bottom: 5px;
        border-radius: 4px;
    }

    .inside {
        /*width: 50%;*/
        height: 25px;
        /*border: 1px solid black;*/
        display: inline-block;
        font-size: 12pt;
        text-align: center;
        color: #0A246A;
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

    <div class="col-md-11" style="margin-top: -15px">
        <h3 style="text-align: center">Cargar valores de los APU del oferente: ${oferente.nombre} ${oferente.apellido}</h3>
    </div>

</div>

<g:if test="${flash.message}">
    <div class="alert alert-error">
        ${flash.message}
    </div>
</g:if>

<g:uploadForm controller="rubroOf" action="uploadApus" method="post" name="frmUpload" id="${contrato?.id}"
              style="padding: 10px">
    <div id="list-grupo" class="col-md-12" role="main">
        <div class="col-md-2">
            <b style="margin-left: 20px">Obra Ofertada:</b>
        </div>
        <div class="col-md-10">
            <g:select name="obra"
                      from="${obras}" id="obraOf" optionKey="key" optionValue="value"
                      style="width: 100%; margin-left: -80px"/>
        </div>

        <div class="col-md-12" style="margin-top: 20px; margin-bottom: 20px">
            <div class="col-md-2"><b>Archivo Excel a subir:</b></div>

            <div class="col-md-8">
                <input type="file" class="required" id="fileCrono" name="file" multiple accept=".xlsx"
                       style="width: 100%; font-size: 12pt" value="Arch"/>
            </div>

            <div class="col-md-2">
                <a href="#" class="btn btn-success" id="btnSubmitCrono"><i class="fa fa-upload"></i>
                    Subir archivo APUs</a>
            </div>
        </div>

        <div style="text-align: center; margin-left: -180px"><h3>Columnas del archivo excel a subir</h3></div>

        <div style="background-color: #e0e0e8; height: 105px">
            <div class="contenedor">
                <div class="inside" style="width: 30%; font-weight: bold" >Equipos</div>

                <div class="inside" style="width: 70%">
                    <span style="display: inline-block">Tìtulo de la sección Equipos</span>
                    <g:textField name="titlEq" id="titlEq" class="form-control" value=""
                                 style="width: 400px; display: inline-block; height: 26px"/>
                    <span style="display: inline-block; margin-left: 20px">Celda:</span>
                    <g:textField name="cldaEq" id="cldaEq" class="form-control" value="A"
                                 style="width: 80px; display: inline-block; height: 26px"/>
                </div>
            </div>


            <div class="row-fluid">
                <div class="col-md-2">
                    <label>Código del Ítem</label>
                    <g:textField name="itemcdgoEq" id="itemcdgoEq" class="form-control" value="A"/>
                </div>

                <div class="col-md-2">
                    <label>Descricón del Ítem Item</label>
                    <g:textField name="itemnmbrEq" id="itemnmbrEq" class="form-control" value="B"/>
                </div>

                <div class="col-md-1">
                    <label>Cantidad</label>
                    <g:textField name="rbrocntdEq" id="rbrocntdEq" class="form-control" value="D"/>
                </div>

                <div class="col-md-1">
                    <label>Tarifa</label>
                    <g:textField name="rbrotrfaEq" class="form-control" value="E"/>
                </div>

                <div class="col-md-2">
                    <label>Costo Hora</label>
                    <g:textField name="rbropcunEq" class="form-control" value="F"/>
                </div>

                <div class="col-md-2">
                    <label>Rendimiento</label>
                    <g:textField name="rbrorndmEq" class="form-control" value="G"/>
                </div>

                <div class="col-md-2">
                    <label>Costo</label>
                    <g:textField name="rbrocstoEq" class="form-control" value="H"/>
                </div>
            </div>
        </div>

        <div style="background-color: #e0e0e0; height: 105px; margin-top: 20px">
            <div class="contenedor">
                <div class="inside" style="width: 30%; font-weight: bold">Mano de Obra</div>

                <div class="inside" style="width: 70%">
                    <span style="display: inline-block">Tìtulo de la sección Mano de Obra</span>
                    <g:textField name="titlMo" id="titlMo" class="form-control" value=""
                                 style="width: 400px; display: inline-block; height: 26px"/>
                    <span style="display: inline-block; margin-left: 20px">Celda:</span>
                    <g:textField name="cldaMo" id="cldaMo" class="form-control" value="A"
                                 style="width: 80px; display: inline-block; height: 26px"/>
                </div>
            </div>


            <div class="row-fluid">
                <div class="col-md-2">
                    <label>Código del Ítem</label>
                    <g:textField name="itemcdgoMo" id="itemcdgoMo" class="form-control" value="A"/>
                </div>

                <div class="col-md-2">
                    <label>Descricón del Ítem Item</label>
                    <g:textField name="itemnmbrMo" id="itemnmbrMo" class="form-control" value="B"/>
                </div>

                <div class="col-md-1">
                    <label>Cantidad</label>
                    <g:textField name="rbrocntdMo" id="rbrocntdMo" class="form-control" value="D"/>
                </div>

                <div class="col-md-1">
                    <label>Tarifa</label>
                    <g:textField name="rbrotrfaMo" class="form-control" value="E"/>
                </div>

                <div class="col-md-2">
                    <label>Costo Hora</label>
                    <g:textField name="rbropcunMo" class="form-control" value="F"/>
                </div>

                <div class="col-md-2">
                    <label>Rendimiento</label>
                    <g:textField name="rbrorndmMo" class="form-control" value="G"/>
                </div>

                <div class="col-md-2">
                    <label>Costo</label>
                    <g:textField name="rbrocstoMo" class="form-control" value="H"/>
                </div>
            </div>
        </div>

        <div style="background-color: #e8e0e0; height: 105px; margin-top: 20px">
            <div class="contenedor">
                <div class="inside" style="width: 30%; font-weight: bold">Materiales</div>

                <div class="inside" style="width: 70%">
                    <span style="display: inline-block">Tìtulo de la sección Materiales</span>
                    <g:textField name="titlMt" id="titlMt" class="form-control" value=""
                                 style="width: 400px; display: inline-block; height: 26px"/>
                    <span style="display: inline-block; margin-left: 20px">Celda:</span>
                    <g:textField name="cldaMt" id="cldaMt" class="form-control" value="A"
                                 style="width: 80px; display: inline-block; height: 26px"/>
                </div>
            </div>


            <div class="row-fluid">
                <div class="col-md-2">
                    <label>Código del Ítem</label>
                    <g:textField name="itemcdgoMt" id="itemcdgoMt" class="form-control" value="A"/>
                </div>

                <div class="col-md-2">
                    <label>Descricón del Ítem Item</label>
                    <g:textField name="itemnmbrMt" id="itemnmbrMt" class="form-control" value="B"/>
                </div>

                <div class="col-md-1">
                    <label>Cantidad</label>
                    <g:textField name="rbrocntdMt" id="rbrocntdMt" class="form-control" value="D"/>
                </div>

                <div class="col-md-1">
                    <label>Tarifa</label>
                    <g:textField name="rbrotrfaMt" class="form-control" value="E"/>
                </div>

                <div class="col-md-2">
                    <label>Costo Hora</label>
                    <g:textField name="rbropcunMt" class="form-control" value="F"/>
                </div>

                <div class="col-md-2">
                    <label>Rendimiento</label>
                    <g:textField name="rbrorndmMt" class="form-control" value="G"/>
                </div>

                <div class="col-md-2">
                    <label>Costo</label>
                    <g:textField name="rbrocstoMt" class="form-control" value="H"/>
                </div>
            </div>
        </div>

        <div style="background-color: #e8e8e0; height: 105px; margin-top: 20px">
            <div class="contenedor">
                <div class="inside" style="width: 30%; font-weight: bold">Transporte</div>

                <div class="inside" style="width: 70%">
                    <span style="display: inline-block">Tìtulo de la sección Transporte de Materiales</span>
                    <g:textField name="titlTr" id="titlTr" class="form-control" value=""
                                 style="width: 400px; display: inline-block; height: 26px"/>
                    <span style="display: inline-block; margin-left: 20px">Celda:</span>
                    <g:textField name="cldaTr" id="cldaTr" class="form-control" value="A"
                                 style="width: 80px; display: inline-block; height: 26px"/>
                </div>
            </div>


            <div class="row-fluid">
                <div class="col-md-2">
                    <label>Código del Ítem</label>
                    <g:textField name="itemcdgoTr" id="itemcdgoTr" class="form-control" value="A"/>
                </div>

                <div class="col-md-2">
                    <label>Descricón del Ítem Item</label>
                    <g:textField name="itemnmbrTr" id="itemnmbrTr" class="form-control" value="B"/>
                </div>

                <div class="col-md-1">
                    <label>Cantidad</label>
                    <g:textField name="rbrocntdTr" id="rbrocntdTr" class="form-control" value="D"/>
                </div>

                <div class="col-md-1">
                    <label>Tarifa</label>
                    <g:textField name="rbrotrfaTr" class="form-control" value="E"/>
                </div>

                <div class="col-md-2">
                    <label>Costo Hora</label>
                    <g:textField name="rbropcunTr" class="form-control" value="F"/>
                </div>

                <div class="col-md-2">
                    <label>Rendimiento</label>
                    <g:textField name="rbrorndmTr" class="form-control" value="G"/>
                </div>

                <div class="col-md-2">
                    <label>Costo</label>
                    <g:textField name="rbrocstoTr" class="form-control" value="H"/>
                </div>
            </div>
        </div>

    </div>

</g:uploadForm>

<script type="text/javascript">

    $(".btnRegresar").click(function () {
        location.href = "${createLink(controller: 'rubroOf', action: 'rubroPrincipalOf')}?contrato=" +
            '${contrato?.id}'
    });

    $("#btnSubmitCrono").click(function () {
        if ($("#frmUpload").valid()) {
            $("#frmUpload").submit();
        }
    });

</script>
</body>
</html>