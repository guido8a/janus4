
<g:uploadForm controller="rubroOf" action="uploadAPU" method="post" name="frmUpload" >

    <div class="col-md-12" style="margin-bottom: 10px">
        <div class="col-md-3"></div>
        <div class="col-md-1">
            <label style="font-size: 14px"> Composición </label>
        </div>
        <div class="col-md-4" id="divComposicion" >
            <g:textField name="composicionName" value="${registro?.nombre ?: ''}" class="form-control" />
        </div>
        <g:if test="${obra}">
            <div class="col-md-2">
                <a href="#" class="btn btn-info" id="btnGuardarComposicion"><i class="fa fa-save"></i>
                    Guardar composición
                </a>
            </div>
        </g:if>
    </div>

    <g:if test="${registro?.id}">
        <div id="list-grupo" class="col-md-12" role="main">
            <div class="col-md-12" style="margin-top: 20px; margin-bottom: 20px">
                <div class="col-md-2"><b>Archivo Excel a subir:</b></div>
                <div class="col-md-4">
                    <input type="file" class="required" name="file" multiple accept=".xlsx" style="width: 100%; font-size: 12pt" value="Arch"/>
                </div>
                <div class="col-md-2">
                    <a href="#" class="btn btn-info" id="btnSubmitCrono"><i class="fa fa-upload"></i>
                        Procesar archivo APUs
                    </a>
                </div>
                <div class="col-md-2">
                    <a href="#" class="btn btn-success" id="btnRubros"><i class="fa fa-check"></i>
                        1. Comprobar Hojas de APUs
                    </a>
                </div>
                <div class="col-md-2">
                    <a href="#" class="btn btn-success" id="btnRevisar"><i class="fa fa-check"></i>
                        2. Comprobar APUs
                    </a>
                </div>
            </div>
        </div>
    </g:if>
    <g:else>
        <div class="col-md-12">
            <div class="alert alert-warning" style="text-align: center; font-size: 16px; font-weight: bold">
                <i class="fa fa-exclamation-triangle text-info fa-2x"></i> Antes de subir el archivo excel es necesario crear una composición
            </div>
        </div>
    </g:else>

    <g:hiddenField name="persona" value="${oferente?.id}" />
    <g:hiddenField name="id" value="${registro?.id}" />
    <g:hiddenField name="revisar" id='inputRevisar' value='0' />
    <g:hiddenField name="obra" id='obra' value='${obra}' />

    <div id="list-grupo" class="col-md-12" style="margin-left: 30px">
        <strong>El título debe estar en la primera línea de cada hoja de los APU</strong>
    </div>
    <div id="list-grupo" class="col-md-12">
        <div class="col-md-1">
            <label class="text-info">Título hoja</label>
        </div>
        <div class="col-md-3" style="margin-left: -40px">
            <g:textField name="rbrotitl" class="form-control" value="${registro?.rbrotitl ?: 'ANÁLISIS DE PRECIOS UNITARIOS'}" style="color: #0b2c89"/>
        </div>

        <div class="col-md-1">
            <label class="text-info">Celda título (debe ser A)</label>
        </div>
        <div class="col-md-1" style="margin-left: -30px; width: 70px">
            <g:textField name="cldatitl" class="form-control allCaps" maxlength="1" value="${registro?.cldatitl ?: 'A'}"/>
        </div>

        <div class="col-md-1">
            <label>Texto para Rubro</label>
        </div>
        <div class="col-md-2" style="margin-left: -40px; width: 180px">
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
            <g:textField name="cldarbro" class="form-control allCaps" maxlength="1" value="${registro?.cldarbro ?: 'A'}"/>
        </div>

        <div class="col-md-1">
            <label>Celda Nombre rubro</label>
        </div>
        <div class="col-md-1" style="margin-left: -20px">
            <g:textField name="rbronmbr" class="form-control allCaps" maxlength="1" value="${registro?.rbronmbr ?: 'A'}"/>
        </div>

        <div class="col-md-12 text-danger" style="font-size: large"><strong>Nota:</strong>
            Las <strong>letras</strong> ingresadas en las celdas deben tener valores <strong>consecutivos</strong> (A, B, C, D, ..)
        en todas las secciones: Equipos, Mano de Obra, Materiales y Transp.</div>

        <div style="background-color: #e0e0e8; height: 105px; margin-top: 70px">
            <div class="contenedor">
                <div class="inside" style="width: 30%; font-weight: bold" >Equipos</div>

                <div class="inside" style="width: 70%; margin-left: 15px">
                    <span style="display: inline-block; margin-left: 44px">Tìtulo de la sección Equipos</span>
                    <g:textField name="titlEq" class="form-control" value="${registro?.titlEq ?: 'EQUIPOS'}"  style="width: 400px; display: inline-block; height: 26px"/>
                    <span style="display: inline-block; margin-left: 20px">Celda:</span>
                    <g:textField name="cldaEq" class="form-control allCaps" value="${registro?.cldaEq ?: 'A'}" maxlength="1" style="width: 80px; display: inline-block; height: 26px"/>
                </div>
            </div>

            <div class="row-fluid">
                <div class="col-md-2">
                    <label>Código del Ítem</label>
                    <g:textField name="cdgoEq" class="form-control allCaps" maxlength="1" value="${registro?.cdgoEq ?: ''}"/>
                </div>

                <div class="col-md-2">
                    <label>Descripción del Ítem</label>
                    <g:textField name="nmbrEq" class="form-control allCaps" maxlength="1" value="${registro?.nmbrEq ?: 'A'}"/>
                </div>

                <div class="col-md-1">
                    <label>Cantidad</label>
                    <g:textField name="cntdEq" class="form-control allCaps" maxlength="1" value="${registro?.cntdEq ?: 'B'}"/>
                </div>

                <div class="col-md-1">
                    <label>Tarifa</label>
                    <g:textField name="trfaEq" class="form-control allCaps" maxlength="1" value="${registro?.trfaEq ?: 'C'}"/>
                </div>

                <div class="col-md-2">
                    <label>Costo Hora</label>
                    <g:textField name="pcunEq" class="form-control allCaps" maxlength="1" value="${registro?.pcunEq ?: 'D'}"/>
                </div>

                <div class="col-md-2">
                    <label>Rendimiento</label>
                    <g:textField name="rndmEq" class="form-control allCaps"  maxlength="1" value="${registro?.rndmEq ?: 'E'}"/>
                </div>

                <div class="col-md-2">
                    <label>Costo (subtotal)</label>
                    <g:textField name="cstoEq" class="form-control allCaps" maxlength="1" value="${registro?.cstoEq ?: 'G'}"/>
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
                    <g:textField name="cldaMo" class="form-control allCaps" value="${registro?.cldaMo ?: 'A'}" maxlength="1" style="width: 80px; display: inline-block; height: 26px"/>
                </div>
            </div>

            <div class="row-fluid">
                <div class="col-md-2">
                    <label>Código del Ítem</label>
                    <g:textField name="cdgoMo" class="form-control allCaps" maxlength="1" value="${registro?.cdgoMo ?: ''}"/>
                </div>

                <div class="col-md-2">
                    <label>Descripción del Ítem</label>
                    <g:textField name="nmbrMo" class="form-control allCaps" maxlength="1" value="${registro?.nmbrMo ?: 'A'}"/>
                </div>

                <div class="col-md-1">
                    <label>Cantidad</label>
                    <g:textField name="cntdMo" class="form-control allCaps" maxlength="1" value="${registro?.cntdMo ?: 'B'}"/>
                </div>

                <div class="col-md-1">
                    <label>Tarifa</label>
                    <g:textField name="trfaMo" class="form-control allCaps" maxlength="1" value="${registro?.trfaMo ?: 'C'}"/>
                </div>

                <div class="col-md-2">
                    <label>Costo Hora</label>
                    <g:textField name="pcunMo" class="form-control allCaps" maxlength="1" value="${registro?.pcunMo ?: 'D'}"/>
                </div>

                <div class="col-md-2">
                    <label>Rendimiento</label>
                    <g:textField name="rndmMo" class="form-control allCaps" maxlength="1" value="${registro?.rndmMo ?: 'E'}"/>
                </div>

                <div class="col-md-2">
                    <label>Costo</label>
                    <g:textField name="cstoMo" class="form-control allCaps" maxlength="1" value="${registro?.cstoMo ?: 'G'}"/>
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
                    <g:textField name="cldaMt" class="form-control allCaps" value="${registro?.cldaMt ?: 'A'}" maxlength="1"  style="width: 80px; display: inline-block; height: 26px"/>
                </div>
            </div>

            <div class="row-fluid">
                <div class="col-md-2">
                    <label>Código del Ítem</label>
                    <g:textField name="cdgoMt" class="form-control allCaps" maxlength="1" value="${registro?.cdgoMt ?: ''}"/>
                </div>

                <div class="col-md-2">
                    <label>Descripción del Ítem</label>
                    <g:textField name="nmbrMt" class="form-control allCaps" maxlength="1" value="${registro?.nmbrMt ?: 'A'}"/>
                </div>

                <div class="col-md-1">
                    <label>Unidad</label>
                    <g:textField name="unddMt" class="form-control allCaps" maxlength="1" value="${registro?.unddMt ?: 'C'}"/>
                </div>

                <div class="col-md-1">
                    <label>Cantidad</label>
                    <g:textField name="cntdMt" class="form-control allCaps" maxlength="1" value="${registro?.cntdMt ?: 'D'}"/>
                </div>

                <div class="col-md-2">
                    <label>Precio Unitario</label>
                    <g:textField name="pcunMt" class="form-control allCaps" maxlength="1" value="${registro?.pcunMt ?: 'E'}"/>
                </div>

                <div class="col-md-2">
                    <label>Costo</label>
                    <g:textField name="cstoMt" class="form-control allCaps" maxlength="1" value="${registro?.cstoMt ?: 'G'}"/>
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
                    <g:textField name="cldaTr" class="form-control allCaps" value="${registro?.cldaTr ?: 'A'}" maxlength="1"
                                 style="width: 80px; display: inline-block; height: 26px"/>
                </div>
            </div>

            <div class="row-fluid">
                <div class="col-md-2">
                    <label>Código del Ítem</label>
                    <g:textField name="cdgoTr" class="form-control allCaps" maxlength="1" value="${registro?.cdgoTr}"/>
                </div>

                <div class="col-md-2">
                    <label>Descripción del Ítem</label>
                    <g:textField name="nmbrTr" class="form-control allCaps" maxlength="1" value="${registro?.nmbrTr ?: 'B'}"/>
                </div>

                <div class="col-md-1">
                    <label>Unidad</label>
                    <g:textField name="unddTr" class="form-control allCaps" maxlength="1" value="${registro?.unddTr ?: 'C'}"/>
                </div>

                <div class="col-md-1">
                    <label>Peso</label>
                    <g:textField name="pesoTr" class="form-control allCaps" maxlength="1" value="${registro?.pesoTr}"/>
                </div>

                <div class="col-md-1">
                    <label>Cantidad</label>
                    <g:textField name="cntdTr" class="form-control allCaps" maxlength="1" value="${registro?.cntdTr ?: 'E'}"/>
                </div>

                <div class="col-md-1">
                    <label>Distancia</label>
                    <g:textField name="dstnTr" class="form-control allCaps" maxlength="1" value="${registro?.dstnTr}"/>
                </div>

                <div class="col-md-2">
                    <label>Tarifa</label>
                    <g:textField name="pcunTr" class="form-control allCaps" maxlength="1" value="${registro?.pcunTr ?:'G'}"/>
                </div>

                <div class="col-md-2">
                    <label>Costo</label>
                    <g:textField name="cstoTr" class="form-control allCaps" maxlength="1" value="${registro?.cstoTr ?: 'H'}"/>
                </div>
            </div>
        </div>
    </div>
</g:uploadForm>

<script type="text/javascript">

    $('.selectObra').select2();

    $("#btnGuardarComposicion").click(function () {
        return submitFormRegistro();
    });

    function submitFormRegistro() {
        var $form = $("#frmUpload");
        if($("#composicionName").val() !== ''){
            var data = $form.serialize();
            var dialog = cargarLoader("Guardando...");
            $.ajax({
                type    : "POST",
                url     : "${createLink(controller: 'registroApu', action: 'saveRegistroApu_ajax')}",
                data    : data,
                // contentType: false,
                processData: false,
                success : function (msg) {
                    dialog.modal('hide');
                    var parts = msg.split("_");
                    if(parts[0] === 'ok'){
                        log(parts[1], "success");
                        setTimeout(function () {
                            location.href = "${createLink(controller: 'rubroOf', action: 'subirExcelApu')}?tipo=1&obra=" + parts[2];
                        }, 800);
                    }else{
                        bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                        return false;
                    }
                }
            });
        }else{
            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Ingrese un nombre para la composición" + '</strong>');
            return false;
        }
    }

    $("#btnSubmitCrono").click(function () {
        $("#inputRevisar").val("0");
        var rev = $("#inputRevisar").val();
        if ($("#frmUpload").valid()) {
            $("#frmUpload").submit();
        }
    });

    $("#btnRevisar").click(function () {
        $("#inputRevisar").val("1")
        var rev = $("#inputRevisar").val()
        if ($("#frmUpload").valid()) {
            $("#frmUpload").submit();
        }
    });

    $("#btnRubros").click(function () {
        $("#inputRevisar").val("R")
        $("#frmUpload").attr("action", "revisaAPU");
        var $form = $("#frmUpload");
        console.log('acción', $form.action)
        if ($form.valid()) {
            $form.submit();
        }
    });

</script>