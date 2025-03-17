<div style="border-bottom: 1px solid black;padding-left: 50px;position: relative;float: left;width: 95%" id="tablas">
    <p class="css-vertical-text">Composición</p>

    <div class="linea" style="height: 98%;"></div>
    <table class="table table-bordered table-striped table-condensed table-hover" style="margin-top: 10px;">
        <thead>
        <tr>
            <th style="width: 80px;">
                Código
            </th>
            <th style="width: 600px;">
                Descripción Equipo
            </th>
            <th style="width: 80px;">
                Cantidad
            </th>
            <th class="col_tarifa">Tarifa <br>($/hora)</th>
            <th class="col_hora">Costo($)</th>
            <th class="col_rend" style="width: 50px">Rendimiento</th>
            <th class="col_total">C.Total($)<br>($/hora)</th>
            <th style="width: 40px" class="col_delete"></th>
        </tr>
        </thead>
        <tbody id="tabla_equipo">
        <g:if test="${equipos}">
            <g:set var="subtotalEquipos" value="${0}"/>
            <g:each in="${equipos}" var="item" status="i">
                <tr class="item_row" id="${item.id}" tipo="${item.tipo}">
                    <td class="cdgo">${item.codigo}</td>
                    <td>${item.nombre}</td>
                    <td style="text-align: right" class="cant">
                        <g:formatNumber number="${item.cantidad}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7"  locale="ec"  />
                    </td>
                    <td class="col_tarifa" style="text-align: right"><g:formatNumber number="${item.precio}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7" locale="ec" /></td>
                    <td class="col_hora" style="text-align: right">${item.cantidad}</td>
                    <td class="col_rend rend" style="width: 50px;text-align: right"  valor="${item.rendimiento}">
                        <g:formatNumber number="${item.rendimiento}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7" locale="ec" />
                    </td>
                    <td class="col_total" style="text-align: right"><g:formatNumber number="${item.subtotal}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7" locale="ec" /></td>
                    <g:set var="subtotalEquipos" value="${subtotalEquipos += (item?.subtotal ?: 0)}"/>
                    <td style="width: 70px;text-align: center" class="col_delete">
                        <a class="btn btn-xs btn-success btnEditar" href="#" rel="tooltip" title="Editar" data-id="${item.id}"
                           data-item="${item.id}"  data-tipo="${item.tipo}"
                           data-unidad="${item.unidad}" data-codigo="${item.codigo}" data-desc="${item.nombre}" data-cant="${item.cantidad}"
                           data-rend="${item.rendimiento}">
                            <i class="fa fa-edit"></i>
                        </a>
                        <a class="btn btn-xs btn-danger borrarItem" href="#" rel="tooltip" title="Eliminar" data-nombre="${item.nombre}" data-id="${item.id}">
                            <i class="fa fa-trash"></i>
                        </a>
                    </td>
                </tr>
            </g:each>
            <tr style="font-weight: bold">
                <td>SUBTOTAL</td>
                <td colspan="5"></td>
                <td style="text-align: right"> <g:formatNumber number="${subtotalEquipos}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7" locale="ec" /></td>
            </tr>
        </g:if>
        <g:else>
            <tr style="text-align: center">
                <td class="alert alert-warning" colspan="8"><i class="fa fa-exclamation-triangle fa-2x text-info"></i> <strong style="font-size: 16px"> No existen registros </strong></td>
            </tr>
        </g:else>
        </tbody>
    </table>
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 80px;">
                Código
            </th>
            <th style="width: 600px;">
                Descripción Mano de obra
            </th>
            <th style="width: 80px">
                Cantidad
            </th>

            <th class="col_jornal">Jornal<br>($/hora)</th>
            <th class="col_hora">Costo($)</th>
            <th class="col_rend" style="width: 50px;">Rendimiento</th>
            <th class="col_total">C.Total($)</th>
            <th style="width: 40px" class="col_delete"></th>
        </tr>
        </thead>
        <tbody id="tabla_mano">
        <g:if test="${manos}">
            <g:set var="subtotalMano" value="${0}"/>
            <g:each in="${manos}" var="item" status="i">
                <tr class="item_row" id="${item.id}" tipo="${item.tipo}">
                    <td class="cdgo">${item.codigo}</td>
                    <td>${item.nombre}</td>
                    <td style="text-align: right" class="cant">
                        <g:formatNumber number="${item.cantidad}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7" locale="ec"  />
                    </td>

                    <td class="col_jornal" style="text-align: right" id="i_${item.id}">${item.precio}</td>
                    <td class="col_hora" style="text-align: right"></td>
                    <td class="col_rend rend" style="width: 50px;text-align: right"  valor="${item.rendimiento}">
                        <g:formatNumber number="${item.rendimiento}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7" locale="ec"  />
                    </td>
                    <td class="col_total" style="text-align: right">
                        <g:formatNumber number="${item.subtotal}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7" locale="ec"  />
                    </td>
                    <g:set var="subtotalMano" value="${subtotalMano += (item?.subtotal ?: 0)}"/>
                    <td style="width: 70px;text-align: center" class="col_delete">
                        <a class="btn btn-xs btn-success btnEditar" href="#" rel="tooltip" title="Editar" data-id="${item.id}"
                           data-tipo="${item.tipo}"
                           data-unidad="${item.codigo}" data-codigo="${item.codigo}" data-desc="${item.nombre}"
                           data-cant="${item.cantidad}" data-rend="${item.rendimiento}">
                            <i class="fa fa-edit"></i>
                        </a>
                        <a class="btn btn-xs btn-danger borrarItem" href="#" rel="tooltip" title="Eliminar" data-nombre="${item.nombre}" data-id="${item.id}">
                            <i class="fa fa-trash"></i></a>
                    </td>
                </tr>
            </g:each>
            <tr style="font-weight: bold">
                <td>SUBTOTAL</td>
                <td colspan="5"></td>
                <td style="text-align: right"> <g:formatNumber number="${subtotalMano}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7" locale="ec" /></td>
            </tr>
        </g:if>
        <g:else>
            <tr style="text-align: center">
                <td class="alert alert-warning" colspan="8"><i class="fa fa-exclamation-triangle fa-2x text-info"></i> <strong style="font-size: 16px"> No existen registros </strong></td>
            </tr>
        </g:else>
        </tbody>
    </table>

    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 80px;">
                Código
            </th>
            <th style="width: 600px;">
                Descripción Material
            </th>
            <th style="width: 60px" class="col_unidad">
                Unidad
            </th>
            <th style="width: 80px">
                Cantidad
            </th>
            <th style="width: 40px" class="col_delete"></th>
            <th class="col_precioUnit">Unitario</th>
            <th class="col_vacio" style="width: 55px"></th>
            <th class="col_total">C.Total($)</th>
            <th class="col_vacio" style="width: 55px"></th>
        </tr>
        </thead>
        <tbody id="tabla_material">
        <g:if test="${materiales}">
            <g:set var="subtotalMateriales" value="${0}"/>
            <g:each in="${materiales}" var="item" status="i">
                <tr class="item_row" id="${item.id}" data-item="${item.id}"  tipo="${item.tipo}" data-tipo="${item.tipo}" data-unidad="${item.unidad}">
                    <td class="cdgo">${item.codigo}</td>
                    <td>${item.nombre}</td>
                    <td style="width: 60px !important;text-align: center" class="col_unidad">${item.unidad}</td>
                    <td style="text-align: right" class="cant">
                        <g:formatNumber number="${item.cantidad}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7"  locale="ec"  />
                    </td>
                    <td class="col_vacio" style="width: 50px;"></td>
                    <td class="col_precioUnit" style="text-align: right" id="i_${item.id}">${item.precio}</td>
                    <td class="col_vacio" style="width: 50px;"></td>
                    <td class="col_total" style="text-align: right"> <g:formatNumber number="${item.subtotal}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7"  locale="ec"  /></td>
                    <g:set var="subtotalMateriales" value="${subtotalMateriales += (item?.subtotal ?: 0)}"/>
                    <td style="width: 70px;text-align: center" class="col_delete">
                        <a class="btn btn-xs btn-success btnEditarMaterial" href="#" rel="tooltip" title="Editar" data-id="${item.id}" data-tipo="${item.tipo}"
                           data-unidad="${item.unidad}" data-codigo="${item.codigo}" data-desc="${item.nombre}" data-cant="${item.cantidad}" data-rend="${1}">
                            <i class="fa fa-edit"></i>
                        </a>
                        <a class="btn btn-xs btn-danger borrarItem" href="#" rel="tooltip" title="Eliminar material" data-nombre="${item.nombre}" data-id="${item.id}">
                            <i class="fa fa-trash"></i></a>
                    </td>
                </tr>
            </g:each>
            <tr style="font-weight: bold">
                <td>SUBTOTAL</td>
                <td colspan="6"></td>
                <td style="text-align: right"> <g:formatNumber number="${subtotalMateriales}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7" locale="ec" /></td>
            </tr>
        </g:if>
        <g:else>
            <tr style="text-align: center" >
                <td class="alert alert-warning" colspan="9"><i class="fa fa-exclamation-triangle fa-2x text-info"></i>
                    <strong style="font-size: 16px"> No existen registros </strong></td>
            </tr>
        </g:else>
        </tbody>
    </table>

    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr><th colspan="10">Transporte</th></tr>
        <tr>
            <th style="width: 80px;">
                Código
            </th>
            <th style="width: 600px;">
                Descripción Material
            </th>
            <th style="width: 60px" class="col_unidad">
                Unidad
            </th>
            <th style="width: 60px">
                Peso/Vol
            </th>
            <th style="width: 80px">
                Cantidad
            </th>
            <th style="width: 40px" class="col_delete">Distancia</th>
            <th class="col_precioUnit">Unitario</th>
            <th class="col_vacio" style="width: 55px">Tarifa</th>
            <th class="col_total">C.Total($)</th>
            <th class="col_vacio" style="width: 55px"></th>
        </tr>
        </thead>
        <tbody id="tabla_transporte">
        <g:if test="${transporte}">
            <g:set var="subtotalTransporte" value="${0}"/>
            <g:each in="${transporte}" var="item" status="i">
                <tr class="item_row" id="${item.id}" data-item="${item.id}"  tipo="${item.tipo}" data-tipo="${item.tipo}" data-unidad="${item.unidad}">
                    <td class="cdgo">${item.codigo}</td>
                    <td>${item.nombre}</td>
                    <td style="width: 60px !important;text-align: center" class="col_unidad">${item.unidad}</td>
                    <td style="text-align: right" class="cant">
                        <g:formatNumber number="${item.peso}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7"  locale="ec"  />
                    </td>
                    <td style="text-align: right" class="cant">
                        <g:formatNumber number="${item.cantidad}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7"  locale="ec"  />
                    </td>
                    <td class="col_vacio" style="width: 50px;">${item.distancia}</td>
                    <td class="col_precioUnit" style="text-align: right" id="i_${item.id}">${item.precio}</td>
                    <td style="text-align: right" class="cant">
                        <g:formatNumber number="${item.costo}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7"  locale="ec"  />
                    </td>
                    <td class="col_total" style="text-align: right">
                        <g:formatNumber number="${item.subtotal}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7"  locale="ec"  />
                    </td>
                    <g:set var="subtotalTransporte" value="${subtotalTransporte += (item?.subtotal ?: 0)}"/>
                    <td style="width: 75px;text-align: center" class="col_delete">
                        <a class="btn btn-xs btn-success btnEditarTransporte" href="#" rel="tooltip" title="Editar" data-id="${item.id}" data-tipo="${item.tipo}"
                           data-unidad="${item.unidad}" data-codigo="${item.codigo}" data-desc="${item.nombre}" data-cant="${item.cantidad}" data-rend="${1}">
                            <i class="fa fa-edit"></i>
                        </a>
                        <a class="btn btn-xs btn-danger borrarItem" href="#" rel="tooltip" title="Eliminar material" data-nombre="${item.nombre}" data-id="${item.id}">
                            <i class="fa fa-trash"></i></a>
                    </td>
                </tr>
            </g:each>
            <tr style="font-weight: bold">
                <td>SUBTOTAL</td>
                <td colspan="7"></td>
                <td style="text-align: right"> <g:formatNumber number="${subtotalTransporte}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7" locale="ec" /></td>
            </tr>
        </g:if>
        <g:else>
            <tr style="text-align: center" >
                <td class="alert alert-warning" colspan="11"><i class="fa fa-exclamation-triangle fa-2x text-info"></i>
                    <strong style="font-size: 16px"> No existen registros </strong></td>
            </tr>
        </g:else>
        </tbody>
    </table>
    <div id="tabla_costos" style="height: 120px;float: right;width: 30%;margin-bottom: 5px;">
        <table class="table table-bordered table-striped table-condensed table-hover" >
            <tr>
                <td style="font-weight: bold">
                    Costo unitario directo
                </td>
                <td style="text-align: right; font-weight: bold">
                    <g:formatNumber number="${precioUnitario}" format="##,#####0" minFractionDigits="5" maxFractionDigits="5"  locale="ec" />
                </td>
            </tr>
            <tr>
                <td style="font-weight: bold">
                    Costos indirectos
                </td>
                <td style="text-align: right; font-weight: bold">
                    <g:formatNumber number="${precioUnitario * indirectos/100}" format="##,#####0" minFractionDigits="5"
                                    maxFractionDigits="5"  locale="ec" />
                </td>
            </tr>
            <tr>
                <td style="font-weight: bold">
                    Costo total
                </td>
                <td style="text-align: right; font-weight: bold">
                    <g:formatNumber number="${precioUnitario*(1 + indirectos/100)}" format="##,#####0" minFractionDigits="5" maxFractionDigits="5"  locale="ec" />
                </td>
            </tr>
        </table>
    </div>
</div>

<script type="text/javascript">

    $(".btnEditar").click(function () {
        var id = $(this).data("id");
        createEditEquipo(id);
    });

    $(".btnEditarMaterial").click(function () {
        var id = $(this).data("id");
        createEditMaterial(id);
    });

    $(".btnEditarTransporte").click(function () {
        var id = $(this).data("id");
        createEditTransporte(id);
    });

    function createEditEquipo(id) {
        var title = id ? "Editar" : "Crear";
        var data = id ? {id : id} : {};
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'rubroOf', action:'formEquipo_ajax')}",
            data    : data,
            success : function (msg) {
                dfg = bootbox.dialog({
                    id    : "dlgCreateEditE",
                    title : title + " ",
                    class: 'modal-lg',
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        guardar  : {
                            id        : "btnSave",
                            label     : "<i class='fa fa-save'></i> Guardar",
                            className : "btn-success",
                            callback  : function () {
                                return submitFormEquipo();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    } //createEdit

    function createEditMaterial(id) {
        var title = id ? "Editar" : "Crear";
        var data = id ? {id : id} : {};
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'rubroOf', action:'formMaterial_ajax')}",
            data    : data,
            success : function (msg) {
                dfg = bootbox.dialog({
                    id    : "dlgCreateEditM",
                    title : title + " Material",
                    class: 'modal-lg',
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        guardar  : {
                            id        : "btnSave",
                            label     : "<i class='fa fa-save'></i> Guardar",
                            className : "btn-success",
                            callback  : function () {
                                return submitFormEquipo();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    } //createEdit

    function createEditTransporte(id) {
        var title = id ? "Editar" : "Crear";
        var data = id ? {id : id} : {};
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'rubroOf', action:'formTransporte_ajax')}",
            data    : data,
            success : function (msg) {
                dfg = bootbox.dialog({
                    id    : "dlgCreateEditT",
                    title : title + " Transporte",
                    class: 'modal-lg',
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        guardar  : {
                            id        : "btnSave",
                            label     : "<i class='fa fa-save'></i> Guardar",
                            className : "btn-success",
                            callback  : function () {
                                return submitFormEquipo();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    } //createEdit

    function submitFormEquipo() {
        var $form = $("#frmSave");
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
                        cargarComposicion($("#rubro option:selected").val());
                    }else{
                        bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                        return false;
                    }
                }
            });
            // return false;
        } else {
            return false;
        }
    }

    $(".borrarItem").click(function () {
        var id = $(this).data("id");
        var nombre = $(this).data("nombre");
        bootbox.confirm({
            title: "Eliminar rubro",
            message: "<i class='fa fa-exclamation-triangle text-warning fa-3x'></i> Está seguro de que desea borrar el rubro: <br><strong>" + nombre + "</strong>",
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
                        url: "${createLink(controller: 'rubroOf', action: 'borrarRubroOferente_ajax')}",
                        data: {
                            id: id
                        },
                        success: function (msg) {
                            g.modal("hide");
                            var parts = msg.split("_");
                            if(parts[0] === 'ok'){
                                log("Borrado correctamente","success");
                                cargarComposicion($("#rubro option:selected").val());
                            }else{
                                log("Error al borrar", "error")
                            }
                        }
                    })
                }
            }
        });
    });

</script>

