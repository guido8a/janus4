<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Subir excel APU</title>
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
        text-align: left;
        color: #0A246A;
    }

    </style>
</head>

<body>

<div class="row">
    <div class="col-md-3">
        <a href="#" class="btn btn-primary" id="btnRegresar">
            <i class="fa fa-arrow-left"></i>
            Regresar
        </a>
        <a href="#"  class="btn btn-danger" id="btnBorrar">
            <i class="fa fa-trash"></i>
            Eliminar los APU
        </a>
    </div>

    <div class="col-md-9" style="margin-top: -15px;">
        <h3>Cargar valores de los APU del oferente: ${oferente.nombre} ${oferente.apellido}</h3>
    </div>

</div>

<g:if test="${flash.message}">
    <div class="alert alert-error">
        ${flash.message}
    </div>
</g:if>

<g:uploadForm controller="rubroOf" action="uploadAPU" method="post" name="frmUpload" id="${contrato?.id}"
              style="padding: 10px">
    <div id="list-grupo" class="col-md-12" role="main">
        <div class="col-md-2">
            <b style="margin-left: 20px">Obra Ofertada:</b>
        </div>
        <div class="col-md-10">
            <g:select name="obra"
                      from="${obras}" optionKey="key" optionValue="value"
                      style="width: 100%; margin-left: -80px"/>
        </div>

        <div class="col-md-12" style="margin-top: 20px; margin-bottom: 20px">
            <div class="col-md-2"><b>Archivo Excel a subir:</b></div>

            <div class="col-md-8">
                <input type="file" class="required" name="file" multiple accept=".xlsx"
                       style="width: 100%; font-size: 12pt" value="Arch"/>
            </div>

            <div class="col-md-2">
                <a href="#" class="btn btn-success" id="btnSubmitCrono"><i class="fa fa-upload"></i>
                    Procesar archivo APUs</a>
            </div>
        </div>

        <div>
        </div>

        <div class="col-md-2">
            <label>Texto para Rubro</label>
        </div>
        <div class="col-md-1" style="margin-left: -90px">
            <g:textField name="rbro" class="form-control" value="Detalle:"/>
        </div>
        <div class="col-md-1">
            <input type="checkbox" id="prefijo" name="prefijo" checked />
            <label for="prefijo">Prefijo</label>
        </div>

        <div class="col-md-1">
            <label>Celda texto Rubro</label>
        </div>
        <div class="col-md-1" style="margin-left: -40px">
            <g:textField name="cldarbro" class="form-control" value="A"/>
        </div>

        <div class="col-md-1">
            <label>Celda Nombre rubro</label>
        </div>
        <div class="col-md-1" style="margin-left: -20px">
            <g:textField name="rbronmbr" class="form-control" value="A"/>
        </div>

        <div class="col-md-1">
            <label>Título hoja</label>
        </div>
        <div class="col-md-3" style="margin-left: -40px">
            <g:textField name="rbrotitl" class="form-control" value="ANÁLISIS DE PRECIOS UNITARIOS"/>
        </div>

        <div class="col-md-1">
            <label>Celda título</label>
        </div>
        <div class="col-md-1" style="margin-left: -20px">
            <g:textField name="cldatitl" class="form-control" value="A"/>
        </div>

        %{--<div class="col-md-1">--}%
            %{--<label>Celda Unidad</label>--}%
        %{--</div>--}%
        %{--<div class="col-md-1" style="margin-left: -20px">--}%
            %{--<g:textField name="rbroundd" class="form-control" value="H"/>--}%
        %{--</div>--}%

        <div style="background-color: #e0e0e8; height: 105px; margin-top: 150px">
            <div class="contenedor">
                <div class="inside" style="width: 30%; font-weight: bold" >Equipos</div>

                <div class="inside" style="width: 70%; margin-left: 15px">
                    <span style="display: inline-block; margin-left: 44px">Tìtulo de la sección Equipos</span>
                    <g:textField name="titlEq" class="form-control" value="EQUIPOS"
                                 style="width: 400px; display: inline-block; height: 26px"/>
                    <span style="display: inline-block; margin-left: 20px">Celda:</span>
                    <g:textField name="cldaEq" class="form-control" value="A"
                                 style="width: 80px; display: inline-block; height: 26px"/>
                </div>
            </div>


            <div class="row-fluid">
                <div class="col-md-2">
                    <label>Código del Ítem</label>
                    <g:textField name="cdgoEq" class="form-control" value=""/>
                </div>

                <div class="col-md-2">
                    <label>Descripción del Ítem</label>
                    <g:textField name="nmbrEq" class="form-control" value="A"/>
                </div>

                <div class="col-md-1">
                    <label>Cantidad</label>
                    <g:textField name="cntdEq" class="form-control" value="B"/>
                </div>

                <div class="col-md-1">
                    <label>Tarifa</label>
                    <g:textField name="trfaEq" class="form-control" value="C"/>
                </div>

                <div class="col-md-2">
                    <label>Costo Hora</label>
                    <g:textField name="pcunEq" class="form-control" value="D"/>
                </div>

                <div class="col-md-2">
                    <label>Rendimiento</label>
                    <g:textField name="rndmEq" class="form-control" value="E"/>
                </div>

                <div class="col-md-2">
                    <label>Costo (subtotal)</label>
                    <g:textField name="cstoEq" class="form-control" value="G"/>
                </div>
            </div>
        </div>

        <div style="background-color: #e0e0e0; height: 105px; margin-top: 20px">
            <div class="contenedor">
                <div class="inside" style="width: 30%; font-weight: bold">Mano de Obra</div>

                <div class="inside" style="width: 70%; margin-left: 15px">
                    <span style="display: inline-block">Tìtulo de la sección Mano de Obra</span>
                    <g:textField name="titlMo" class="form-control" value="MANO DE OBRA"
                                 style="width: 400px; display: inline-block; height: 26px"/>
                    <span style="display: inline-block; margin-left: 20px">Celda:</span>
                    <g:textField name="cldaMo" class="form-control" value="A"
                                 style="width: 80px; display: inline-block; height: 26px"/>
                </div>
            </div>


            <div class="row-fluid">
                <div class="col-md-2">
                    <label>Código del Ítem</label>
                    <g:textField name="cdgoMo" class="form-control" value="A"/>
                </div>

                <div class="col-md-2">
                    <label>Descripción del Ítem</label>
                    <g:textField name="nmbrMo" class="form-control" value="B"/>
                </div>

                <div class="col-md-1">
                    <label>Cantidad</label>
                    <g:textField name="cntdMo" class="form-control" value="D"/>
                </div>

                <div class="col-md-1">
                    <label>Tarifa</label>
                    <g:textField name="trfaMo" class="form-control" value="E"/>
                </div>

                <div class="col-md-2">
                    <label>Costo Hora</label>
                    <g:textField name="pcunMo" class="form-control" value="F"/>
                </div>

                <div class="col-md-2">
                    <label>Rendimiento</label>
                    <g:textField name="rndmMo" class="form-control" value="G"/>
                </div>

                <div class="col-md-2">
                    <label>Costo</label>
                    <g:textField name="cstoMo" class="form-control" value="H"/>
                </div>
            </div>
        </div>

        <div style="background-color: #e8e0e0; height: 105px; margin-top: 20px">
            <div class="contenedor">
                <div class="inside" style="width: 30%; font-weight: bold">Materiales</div>

                <div class="inside" style="width: 70%; margin-left: 40px">
                    <span style="display: inline-block">Tìtulo de la sección Materiales</span>
                    <g:textField name="titlMt" class="form-control" value="MATERIALES"
                                 style="width: 400px; display: inline-block; height: 26px"/>
                    <span style="display: inline-block; margin-left: 20px">Celda:</span>
                    <g:textField name="cldaMt" class="form-control" value="A"
                                 style="width: 80px; display: inline-block; height: 26px"/>
                </div>
            </div>


            <div class="row-fluid">
                <div class="col-md-2">
                    <label>Código del Ítem</label>
                    <g:textField name="cdgoMt" class="form-control" value="A"/>
                </div>

                <div class="col-md-2">
                    <label>Descripción del Ítem</label>
                    <g:textField name="nmbrMt" class="form-control" value="B"/>
                </div>

                <div class="col-md-1">
                    <label>Unidad</label>
                    <g:textField name="unddMt" class="form-control" value="E"/>
                </div>

                <div class="col-md-1">
                    <label>Cantidad</label>
                    <g:textField name="cntdMt" class="form-control" value="F"/>
                </div>

                %{--<div class="col-md-1">--}%
                    %{--<label>Tarifa</label>--}%
                    %{--<g:textField name="trfaMt" class="form-control" value=""/>--}%
                %{--</div>--}%

                <div class="col-md-2">
                    <label>Precio Unitario</label>
                    <g:textField name="pcunMt" class="form-control" value="G"/>
                </div>

                %{--<div class="col-md-2">--}%
                    %{--<label>Rendimiento</label>--}%
                    %{--<g:textField name="rndmMt" class="form-control" value=""/>--}%
                %{--</div>--}%

                <div class="col-md-2">
                    <label>Costo</label>
                    <g:textField name="cstoMt" class="form-control" value="H"/>
                </div>
            </div>
        </div>

        <div style="background-color: #e8e8e0; height: 105px; margin-top: 20px">
            <div class="contenedor">
                <div class="inside" style="width: 30%; font-weight: bold">Transporte</div>

                <div class="inside" style="width: 70%">
                    <span style="display: inline-block">Tìtulo para Transporte de Materiales</span>
                    <g:textField name="titlTr" class="form-control" value="TRANSPORTE"
                                 style="width: 400px; display: inline-block; height: 26px"/>
                    <span style="display: inline-block; margin-left: 20px">Celda:</span>
                    <g:textField name="cldaTr" class="form-control" value="A"
                                 style="width: 80px; display: inline-block; height: 26px"/>
                </div>
            </div>


            <div class="row-fluid">
                <div class="col-md-2">
                    <label>Código del Ítem</label>
                    <g:textField name="cdgoTr" class="form-control" value="A"/>
                </div>

                <div class="col-md-2">
                    <label>Descripción del Ítem</label>
                    <g:textField name="nmbrTr" class="form-control" value="B"/>
                </div>

                <div class="col-md-1">
                    <label>Unidad</label>
                    <g:textField name="unddTr" class="form-control" value="C"/>
                </div>

                <div class="col-md-1">
                    <label>Peso</label>
                    <g:textField name="pesoTr" class="form-control" value="D"/>
                </div>

                <div class="col-md-1">
                    <label>Cantidad</label>
                    <g:textField name="cntdTr" class="form-control" value="E"/>
                </div>

                <div class="col-md-1">
                    <label>Distancia</label>
                    <g:textField name="dstnTr" class="form-control" value="F"/>
                </div>

                <div class="col-md-2">
                    <label>Tarifa</label>
                    <g:textField name="pcunTr" class="form-control" value="G"/>
                </div>

                %{--<div class="col-md-2">--}%
                    %{--<label>Rendimiento</label>--}%
                    %{--<g:textField name="rndmTr" class="form-control" value="G"/>--}%
                %{--</div>--}%

                <div class="col-md-2">
                    <label>Costo</label>
                    <g:textField name="cstoTr" class="form-control" value="H"/>
                </div>
            </div>
        </div>

    </div>

</g:uploadForm>

<script type="text/javascript">

    $("#btnRegresar").click(function () {
        location.href = "${createLink(controller: 'rubroOf', action: 'rubroPrincipalOf')}?contrato=" +
            '${contrato?.id}'
    });

    $("#btnBorrar").click(function () {


        bootbox.confirm({
            title: "Eliminar los APUS del oferente",
            message: "<i class='fa fa-exclamation-triangle text-warning fa-3x'></i> Está seguro de que desea borrar " +
            "todos los APU cargados del oferente para la obra:<br><strong>" + $("#obra").text() + "</strong>",
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
                    var g = cargarLoader("Cargando...");
                    $.ajax({
                        type: "POST",
                        url: "${createLink(controller: 'rubroOf', action: 'borrarApus')}",
                        data: {
                            obra: $("#obra").val()
                        },
                        success: function (msg) {
                            g.modal("hide");
                            var parts = msg.split("_");
                            if(parts[0] === 'Ok'){
                                log("Borrados correctamente","success");
                                setTimeout(function () {
                                    location.reload();
                                }, 800);
                            }else{
                                log("Error al borrar", "error")
                            }
                        }
                    })
                }
            }
        });

        %{--location.href = "${createLink(controller: 'rubroOf', action: 'borrarApus')}?obra=" +--}%
        %{--    $("#obra").val()--}%
    });

    $("#btnSubmitCrono").click(function () {
        if ($("#frmUpload").valid()) {
            $("#frmUpload").submit();
        }
    });

</script>
</body>
</html>