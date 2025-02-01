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
    }

    .inside {
        /*width: 50%;*/
        height: 25px;
        /*border: 1px solid black;*/
        display: inline-block;
        font-size: large;
        text-align: center;
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
        <h3 style="text-align: center">Cargar valores de los APU del oferente: ${oferente.nombre}</h3>
    </div>

</div>

<g:if test="${flash.message}">
    <div class="alert alert-error">
        ${flash.message}
    </div>
</g:if>

<g:uploadForm controller="cronogramaContrato" action="uploadFile" method="post" name="frmUpload" id="${contrato?.id}"
              style="padding: 10px">
    <div id="list-grupo" class="col-md-12" role="main">

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

        <div style="text-align: center"><h3>Definición de las columnas del archivo excel a subir</h3></div>

        <div style="background-color: #e0e0e0; height: 105px">
            <div class="contenedor">
                <div class="inside" style="width: 30%">Equipos</div>

                <div class="inside" style="width: 70%">
                    <span style="display: inline-block">Tìtulo de la sección Equipos</span>
                    <g:textField name="itemcdgo" id="itemcdgo" class="form-control" value=""
                                 style="width: 400px; display: inline-block; height: 26px"/>
                    <span style="display: inline-block; margin-left: 20px">Celda:</span>
                    <g:textField name="itemcdgo" id="itemcdgo" class="form-control" value="A"
                                 style="width: 80px; display: inline-block; height: 26px"/>
                </div>
            </div>


            <div class="row-fluid">
                <div class="col-md-2">
                    <label>Código del Ítem</label>
                    <g:textField name="itemcdgo" id="itemcdgo" class="form-control" value="A"/>
                </div>

                <div class="col-md-2">
                    <label>Descricón del Ítem Item</label>
                    <g:textField name="itemnmbr" id="itemnmbr" class="form-control" value="B"/>
                </div>

                <div class="col-md-1">
                    <label>Cantidad</label>
                    <g:textField name="rbrocntd" id="rbrocntd" class="form-control" value="D"/>
                </div>

                <div class="col-md-1">
                    <label>Tarifa</label>
                    <g:textField name="rbrotrfa" class="form-control" value="E"/>
                </div>

                <div class="col-md-2">
                    <label>Costo Hora</label>
                    <g:textField name="rbropcun" class="form-control" value="F"/>
                </div>

                <div class="col-md-2">
                    <label>Rendimiento</label>
                    <g:textField name="rbrorndm" class="form-control" value="G"/>
                </div>

                <div class="col-md-2">
                    <label>Costo</label>
                    <g:textField name="rbrocsto" class="form-control" value="H"/>
                </div>
            </div>
        </div>

        <div style="background-color: #e0e0e0; height: 105px; margin-top: 20px">
            <div class="contenedor">
                <div class="inside" style="width: 30%">Mano de Obra</div>

                <div class="inside" style="width: 70%">
                    <span style="display: inline-block">Tìtulo de la sección Mano de Obra</span>
                    <g:textField name="itemcdgo" id="itemcdgo" class="form-control" value=""
                                 style="width: 400px; display: inline-block; height: 26px"/>
                    <span style="display: inline-block; margin-left: 20px">Celda:</span>
                    <g:textField name="itemcdgo" id="itemcdgo" class="form-control" value="A"
                                 style="width: 80px; display: inline-block; height: 26px"/>
                </div>
            </div>


            <div class="row-fluid">
                <div class="col-md-2">
                    <label>Código del Ítem</label>
                    <g:textField name="itemcdgo" id="itemcdgo" class="form-control" value="A"/>
                </div>

                <div class="col-md-2">
                    <label>Descricón del Ítem Item</label>
                    <g:textField name="itemnmbr" id="itemnmbr" class="form-control" value="B"/>
                </div>

                <div class="col-md-1">
                    <label>Cantidad</label>
                    <g:textField name="rbrocntd" id="rbrocntd" class="form-control" value="D"/>
                </div>

                <div class="col-md-1">
                    <label>Tarifa</label>
                    <g:textField name="rbrotrfa" class="form-control" value="E"/>
                </div>

                <div class="col-md-2">
                    <label>Costo Hora</label>
                    <g:textField name="rbropcun" class="form-control" value="F"/>
                </div>

                <div class="col-md-2">
                    <label>Rendimiento</label>
                    <g:textField name="rbrorndm" class="form-control" value="G"/>
                </div>

                <div class="col-md-2">
                    <label>Costo</label>
                    <g:textField name="rbrocsto" class="form-control" value="H"/>
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