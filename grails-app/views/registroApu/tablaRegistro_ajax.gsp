<g:uploadForm controller="rubroOf" action="uploadAPU" method="post" name="frmUpload" id="${contrato?.id}" style="padding: 10px">

    <div id="list-grupo" class="col-md-12" role="main">
        <div class="col-md-2">
            <b style="margin-left: 20px">Obra Ofertada:</b>
        </div>
        <div class="col-md-10">
            <g:select name="obra" from="${obras}" optionKey="key" optionValue="value" style="width: 100%; margin-left: -80px"/>
        </div>

        <div class="col-md-12" style="margin-top: 20px; margin-bottom: 20px">
            <div class="col-md-2"><b>Archivo Excel a subir:</b></div>
            <div class="col-md-8">
                <input type="file" class="required" name="file" multiple accept=".xlsx" style="width: 100%; font-size: 12pt" value="Arch"/>
            </div>
            <div class="col-md-2">
                <a href="#" class="btn btn-success" id="btnSubmitCrono"><i class="fa fa-upload"></i>
                    Procesar archivo APUs
                </a>
            </div>
        </div>
    </div>
</g:uploadForm>

<g:form class="form-horizontal" name="frmRegistro" action="saveRegistroApu_ajax">
    <g:hiddenField name="persona" value="${oferente?.id}" />
    <g:hiddenField name="id" value="${registro?.id}" />
    <div id="list-grupo" class="col-md-12" role="main">
        <div class="col-md-1">
            <label class="text-info">Título hoja</label>
        </div>
        <div class="col-md-3" style="margin-left: -40px">
            <g:textField name="rbrotitl" class="form-control" value="${registro?.rbrotitl ?: 'ANÁLISIS DE PRECIOS UNITARIOS'}" style="color: #0b2c89"/>
        </div>

        <div class="col-md-1">
            <label>Celda título</label>
        </div>
        <div class="col-md-1" style="margin-left: -20px">
            <g:textField name="cldatitl" class="form-control" value="${registro?.cldatitl ?: 'A'}"/>
        </div>

        <div class="col-md-2">
            <label>Texto para Rubro</label>
        </div>
        <div class="col-md-1" style="margin-left: -90px">
            <g:textField name="rbro" class="form-control" value="${registro?.rbro ?: 'Detalle:'}"/>
        </div>
        <div class="col-md-1">
            <input class="form-control" type="checkbox" id="prefijo" name="prefijo"  ${registro?.prefijo == 1 ? 'checked' : ''}  />
            <label for="prefijo">Prefijo</label>
        </div>

        <div class="col-md-1">
            <label>Celda texto Rubro</label>
        </div>
        <div class="col-md-1" style="margin-left: -40px">
            <g:textField name="cldarbro" class="form-control" value="${registro?.cldarbro ?: 'A'}"/>
        </div>

        <div class="col-md-1">
            <label>Celda Nombre rubro</label>
        </div>
        <div class="col-md-1" style="margin-left: -20px">
            <g:textField name="rbronmbr" class="form-control" value="${registro?.rbronmbr ?: 'A'}"/>
        </div>

        <div style="background-color: #e0e0e8; height: 105px; margin-top: 50px">
            <div class="contenedor">
                <div class="inside" style="width: 30%; font-weight: bold" >Equipos</div>

                <div class="inside" style="width: 70%; margin-left: 15px">
                    <span style="display: inline-block; margin-left: 44px">Tìtulo de la sección Equipos</span>
                    <g:textField name="titlEq" class="form-control" value="${registro?.titlEq ?: 'EQUIPOS'}"  style="width: 400px; display: inline-block; height: 26px"/>
                    <span style="display: inline-block; margin-left: 20px">Celda:</span>
                    <g:textField name="cldaEq" class="form-control" value="${registro?.cldaEq ?: 'A'}" style="width: 80px; display: inline-block; height: 26px"/>
                </div>
            </div>

            <div class="row-fluid">
                <div class="col-md-2">
                    <label>Código del Ítem</label>
                    <g:textField name="cdgoEq" class="form-control" value="${registro?.cdgoEq ?: ''}"/>
                </div>

                <div class="col-md-2">
                    <label>Descripción del Ítem</label>
                    <g:textField name="nmbrEq" class="form-control" value="${registro?.nmbrEq ?: 'A'}"/>
                </div>

                <div class="col-md-1">
                    <label>Cantidad</label>
                    <g:textField name="cntdEq" class="form-control" value="${registro?.cntdEq ?: 'B'}"/>
                </div>

                <div class="col-md-1">
                    <label>Tarifa</label>
                    <g:textField name="trfaEq" class="form-control" value="${registro?.trfaEq ?: 'C'}"/>
                </div>

                <div class="col-md-2">
                    <label>Costo Hora</label>
                    <g:textField name="pcunEq" class="form-control" value="${registro?.pcunEq ?: 'D'}"/>
                </div>

                <div class="col-md-2">
                    <label>Rendimiento</label>
                    <g:textField name="rndmEq" class="form-control" value="${registro?.rndmEq ?: 'E'}"/>
                </div>

                <div class="col-md-2">
                    <label>Costo (subtotal)</label>
                    <g:textField name="cstoEq" class="form-control" value="${registro?.cstoEq ?: 'G'}"/>
                </div>
            </div>
        </div>

        <div style="background-color: #e0e0e0; height: 105px; margin-top: 20px">
            <div class="contenedor">
                <div class="inside" style="width: 30%; font-weight: bold">Mano de Obra</div>

                <div class="inside" style="width: 70%; margin-left: 15px">
                    <span style="display: inline-block">Tìtulo de la sección Mano de Obra</span>
                    <g:textField name="titlMo" class="form-control" value="${registro?.titlMo ?: 'MANO DE OBRA'}" style="width: 400px; display: inline-block; height: 26px"/>
                    <span style="display: inline-block; margin-left: 20px">Celda:</span>
                    <g:textField name="cldaMo" class="form-control" value="${registro?.cldaMo ?: 'A'}"  style="width: 80px; display: inline-block; height: 26px"/>
                </div>
            </div>

            <div class="row-fluid">
                <div class="col-md-2">
                    <label>Código del Ítem</label>
                    <g:textField name="cdgoMo" class="form-control" value="${registro?.cdgoMo ?: ''}"/>
                </div>

                <div class="col-md-2">
                    <label>Descripción del Ítem</label>
                    <g:textField name="nmbrMo" class="form-control" value="${registro?.nmbrMo ?: 'A'}"/>
                </div>

                <div class="col-md-1">
                    <label>Cantidad</label>
                    <g:textField name="cntdMo" class="form-control" value="${registro?.cntdMo ?: 'B'}"/>
                </div>

                <div class="col-md-1">
                    <label>Tarifa</label>
                    <g:textField name="trfaMo" class="form-control" value="${registro?.trfaMo ?: 'C'}"/>
                </div>

                <div class="col-md-2">
                    <label>Costo Hora</label>
                    <g:textField name="pcunMo" class="form-control" value="${registro?.pcunMo ?: 'D'}"/>
                </div>

                <div class="col-md-2">
                    <label>Rendimiento</label>
                    <g:textField name="rndmMo" class="form-control" value="${registro?.rndmMo ?: 'E'}"/>
                </div>

                <div class="col-md-2">
                    <label>Costo</label>
                    <g:textField name="cstoMo" class="form-control" value="${registro?.cstoMo ?: 'G'}"/>
                </div>
            </div>
        </div>

        <div style="background-color: #e8e0e0; height: 105px; margin-top: 20px">
            <div class="contenedor">
                <div class="inside" style="width: 30%; font-weight: bold">Materiales</div>

                <div class="inside" style="width: 70%; margin-left: 40px">
                    <span style="display: inline-block">Tìtulo de la sección Materiales</span>
                    <g:textField name="titlMt" class="form-control" value="${registro?.titlMt ?: 'MATERIALES'}"   style="width: 400px; display: inline-block; height: 26px"/>
                    <span style="display: inline-block; margin-left: 20px">Celda:</span>
                    <g:textField name="cldaMt" class="form-control" value="${registro?.cldaMt ?: 'A'}"  style="width: 80px; display: inline-block; height: 26px"/>
                </div>
            </div>

            <div class="row-fluid">
                <div class="col-md-2">
                    <label>Código del Ítem</label>
                    <g:textField name="cdgoMt" class="form-control" value="${registro?.cdgoMt ?: ''}"/>
                </div>

                <div class="col-md-2">
                    <label>Descripción del Ítem</label>
                    <g:textField name="nmbrMt" class="form-control" value="${registro?.nmbrMt ?: 'A'}"/>
                </div>

                <div class="col-md-1">
                    <label>Unidad</label>
                    <g:textField name="unddMt" class="form-control" value="${registro?.unddMt ?: 'C'}"/>
                </div>

                <div class="col-md-1">
                    <label>Cantidad</label>
                    <g:textField name="cntdMt" class="form-control" value="${registro?.cntdMt ?: 'D'}"/>
                </div>

                <div class="col-md-2">
                    <label>Precio Unitario</label>
                    <g:textField name="pcunMt" class="form-control" value="${registro?.pcunMt ?: 'E'}"/>
                </div>

                <div class="col-md-2">
                    <label>Costo</label>
                    <g:textField name="cstoMt" class="form-control" value="${registro?.cstoMt ?: 'G'}"/>
                </div>
            </div>
        </div>

        <div style="background-color: #e8e8e0; height: 105px; margin-top: 20px">
            <div class="contenedor">
                <div class="inside" style="width: 30%; font-weight: bold">Transporte</div>

                <div class="inside" style="width: 70%">
                    <span style="display: inline-block">Tìtulo para Transporte de Materiales</span>
                    <g:textField name="titlTr" class="form-control" value="${registro?.titlTr ?: 'TRANSPORTE'}"
                                 style="width: 400px; display: inline-block; height: 26px"/>
                    <span style="display: inline-block; margin-left: 20px">Celda:</span>
                    <g:textField name="cldaTr" class="form-control" value="${registro?.cldaTr ?: 'A'}"
                                 style="width: 80px; display: inline-block; height: 26px"/>
                </div>
            </div>

            <div class="row-fluid">
                <div class="col-md-2">
                    <label>Código del Ítem</label>
                    <g:textField name="cdgoTr" class="form-control" value="${registro?.cdgoTr ?: 'A'}"/>
                </div>

                <div class="col-md-2">
                    <label>Descripción del Ítem</label>
                    <g:textField name="nmbrTr" class="form-control" value="${registro?.nmbrTr ?: 'B'}"/>
                </div>

                <div class="col-md-1">
                    <label>Unidad</label>
                    <g:textField name="unddTr" class="form-control" value="${registro?.unddTr ?: 'C'}"/>
                </div>

                <div class="col-md-1">
                    <label>Peso</label>
                    <g:textField name="pesoTr" class="form-control" value="${registro?.pesoTr ?: 'D'}"/>
                </div>

                <div class="col-md-1">
                    <label>Cantidad</label>
                    <g:textField name="cntdTr" class="form-control" value="${registro?.cntdTr ?: 'E'}"/>
                </div>

                <div class="col-md-1">
                    <label>Distancia</label>
                    <g:textField name="dstnTr" class="form-control" value="${registro?.dstnTr ?: 'F'}"/>
                </div>

                <div class="col-md-2">
                    <label>Tarifa</label>
                    <g:textField name="pcunTr" class="form-control" value="${registro?.pcunTr ?:'G'}"/>
                </div>

                <div class="col-md-2">
                    <label>Costo</label>
                    <g:textField name="cstoTr" class="form-control" value="${registro?.cstoTr ?: 'H'}"/>
                </div>
            </div>
        </div>
    </div>
</g:form>


<div class="col-md-12" style="margin-top: 10px">
    <div class="col-md-5"></div>
    <div class="col-md-2">
        <a href="#" class="btn btn-success" id="btnGuardarRegistro"><i class="fa fa-save"></i>
            Guardar composición
        </a>
    </div>
</div>


<script type="text/javascript">

    $("#btnGuardarRegistro").click(function () {
        return submitFormRegistro();
    });

    function submitFormRegistro() {
        var $form = $("#frmRegistro");
        if ($form.valid()) {
        var data = $form.serialize();
        var dialog = cargarLoader("Guardando...");
        $.ajax({
            type    : "POST",
            url     : $form.attr("action"),
            data    : data,
            success : function (msg) {
                dialog.modal('hide');
                var parts = msg.split("_");
                if(parts[0] === 'ok'){
                    log(parts[1], "success");
                    setTimeout(function () {
                        location.reload();
                    }, 800);
                }else{
                    bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                    return false;
                }
            }
        });
        } else {
            return false;
        }
    }

    $("#btnSubmitCrono").click(function () {
        if ($("#frmUpload").valid()) {
            $("#frmUpload").submit();
        }
    });


</script>