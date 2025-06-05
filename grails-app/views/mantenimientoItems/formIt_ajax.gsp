<%@ page import="janus.Fabricante; janus.TipoLista; janus.pac.CodigoComprasPublicas; janus.Item" %>

<g:form class="form-horizontal" name="frmSave" action="saveIt_ajax">
    <g:hiddenField name="id" value="${itemInstance?.id}"/>

    <div class="form-group ${hasErrors(bean: itemInstance, field: 'departamento', 'error')} ">
        <span class="grupo">
            <label for="departamento" class="col-md-2 control-label text-info">
                Subgrupo
            </label>
            <span class="col-md-8">
                <g:if test="${itemInstance?.id}">
                    <g:select name="departamento" from="${listaDepartamentos}" required="" optionValue="descripcion" optionKey="id" class="form-control required " value="${departamento?.id ?: itemInstance?.departamento?.id}" />
                </g:if>
                <g:else>
                    <g:select name="departamento" from="${janus.DepartamentoItem.findAllBySubgrupoInList(subgrupos, [sort: 'descripcion'])}" required="" optionValue="descripcion" optionKey="id" class="form-control required " value="${departamento?.id ?: itemInstance?.departamento?.id}" />
                </g:else>
            </span>
        </span>
    </div>
    <div class="form-group ${hasErrors(bean: itemInstance, field: 'codigo', 'error')} ${hasErrors(bean: itemInstance, field: 'fecha', 'error')}  ${hasErrors(bean: itemInstance, field: 'estado', 'error')}">
        <span class="grupo">
            <label for="codigo" class="col-md-2 control-label text-info">
                Código
            </label>
            <g:if test="${itemInstance?.id}">
                <span class="col-md-2">
                    <g:textField name="codigo" maxlength="20" minlength="3" class="form-control" value="${itemInstance?.codigo ?: ''}" readonly="" />
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </g:if>
            <g:else>
                <span class="col-md-3" id="divCodigos">
                </span>
                <span class="col-md-2">
                    <g:textField name="codigo" maxlength="20" minlength="3" required="" class="form-control allCaps number required" value="${itemInstance?.codigo ?: ''}" />
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </g:else>
        </span>

        <span class="grupo">
            <label class="col-md-1 control-label text-info">
                Fecha
            </label>
            <span class="col-md-2">
                <input aria-label="" name="fecha" id='datetimepicker1' type='text' class="form-control"
                       value="${itemInstance?.fecha?.format("dd-MM-yyyy")}"/>
            </span>
        </span>
    </div>
    <div class="form-group ${hasErrors(bean: itemInstance, field: 'nombre', 'error')} ">
        <span class="grupo">
            <label for="nombre" class="col-md-2 control-label text-info">
                Nombre
            </label>
            <span class="col-md-8">
                <g:textField name="nombre" maxlength="200" class="form-control allCaps required" value="${itemInstance?.nombre}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
    <div class="form-group ${hasErrors(bean: itemInstance, field: 'unidad', 'error')} ">
        <span class="grupo">
            <label for="unidad" class="col-md-2 control-label text-info">
                Unidad
            </label>
            <span class="col-md-5">
                <g:select name="unidad" from="${janus.Unidad.list([sort: 'descripcion'])}" optionValue="descripcion" optionKey="id" class="form-control" value="${itemInstance?.unidad?.id}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
        <span class="grupo">
            <label for="estado" class="col-md-1 control-label text-info">
                Estado
            </label>
            <span class="col-md-2">
                <g:select name="estado" from="${['A': 'Activo', 'B': 'Dado de baja']}" optionValue="value" optionKey="key" class="form-control" value="${itemInstance?.estado}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
    <div class="form-group ${hasErrors(bean: itemInstance, field: 'fabricante', 'error')} ">
        <span class="grupo">
            <label for="fabricante" class="col-md-2 control-label text-info">
                Fabricante
            </label>
            <span class="col-md-8">
                <g:select name="fabricante" from="${janus.Fabricante.list([sort: 'nombre'])}" optionValue="nombre" optionKey="id" class="form-control" value="${itemInstance?.fabricante?.id}" noSelection="[null: 'NINGUNO']" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
    <div class="form-group ${hasErrors(bean: itemInstance, field: 'codigoComprasPublicas', 'error')} ">
        <span class="grupo">
            <label for="item_codigo" class="col-md-2 control-label text-info">
                Código CPC (SERCOP)
            </label>
            <span class="col-md-2">
                <g:hiddenField name="codigoComprasPublicas" value="${itemInstance?.codigoComprasPublicas?.id}" />
                <g:textField name="item_codigo" class="form-control required" value="${janus.pac.CodigoComprasPublicas.get(itemInstance?.codigoComprasPublicas?.id)?.numero ?: ''}" readonly=""/>
            </span>
            <span class="col-md-6">
                <g:textField name="item_desc" class="form-control" value="${janus.pac.CodigoComprasPublicas.get(itemInstance?.codigoComprasPublicas?.id)?.descripcion ?: ''}" readonly=""/>
            </span>
            <span class="col-md-1">
                <a href="#" id="btnBuscadrCPC" class="btn btn-info ">
                    <i class="fa fa-search"></i>
                    Buscar
                </a>
            </span>
        </span>
    </div>

    <g:if test="${grupo == 1}">
        <div class="form-group ${hasErrors(bean: itemInstance, field: 'tipoLista', 'error')} ">
            <span class="grupo">
                <label for="tipoLista" class="col-md-2 control-label text-info">
                    Lista de Precios
                </label>
                <span class="col-md-8">
                    <g:select name="tipoLista" from="${janus.TipoLista.findAllByUnidadIsNotNull([sort: 'id'])}" dataAttrs="${['unidad': {it.unidad}]}" optionValue="descripcion" optionKey="id" class="form-control" value="${itemInstance?.tipoLista?.id}" />
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>
        <div id="grupoPeso"  class="form-group ${hasErrors(bean: itemInstance, field: 'peso', 'error')} ">
            <span class="grupo">
                <label for="peso" class="col-md-2 control-label text-info">
                    Peso/Volumen
                </label>
                <span class="col-md-6">
                    <g:textField name="peso" maxlength="20" class="form-control allCaps required" value="${formatNumber(number: itemInstance?.peso, format: '##,######0', minFractionDigits: 6, maxFractionDigits: 6, locale: 'ec')}"
                                 step="${10**-(formatNumber(number: itemInstance?.peso, format: '#,#####0', minFractionDigits: 3, maxFractionDigits: 6, locale: 'ec').toString().size()-2)}"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
                <span class="col-md-2" id="spanPeso">
                    <g:textField name="item_unidad" class="form-control" value="" readonly=""/>
                </span>
            </span>
        </div>
    </g:if>
    <g:else>
        <g:hiddenField name="peso" value="${0}"/>
    </g:else>

    <div class="form-group ${hasErrors(bean: itemInstance, field: 'codigoEspecificacion', 'error')} ">
        <span class="grupo">
            <label class="col-md-2 control-label text-info">
                Código especificación
            </label>
            <span class="col-md-6">
                <g:textField name="codigoEspecificacion" class="form-control" value="${itemInstance?.codigoEspecificacion}" />
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: itemInstance, field: 'codigoComprasPublicasTransporte', 'error')} ">
        <span class="grupo">
            <label for="codigoTransporte" class="col-md-2 control-label text-warning">
                Código CPC Transporte
            </label>
            <span class="col-md-2">
                <g:hiddenField name="codigoComprasPublicasTransporte" value="${itemInstance?.codigoComprasPublicasTransporte?.id}" />
                <g:textField name="codigoTransporte" class="form-control" value="${janus.pac.CodigoComprasPublicas.get(itemInstance?.codigoComprasPublicasTransporte?.id)?.numero ?: ''}" readonly=""/>
            </span>
            <span class="col-md-6">
                <g:textField name="descTransporte" class="form-control" value="${janus.pac.CodigoComprasPublicas.get(itemInstance?.codigoComprasPublicasTransporte?.id)?.descripcion ?: ''}" readonly=""/>
            </span>
            <span class="col-md-1">
                <a href="#" id="btnBuscarCPCTransporte" class="btn btn-info ">
                    <i class="fa fa-search"></i>
                    Buscar
                </a>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: itemInstance, field: 'transporteValor', 'error')} ">
        <span class="grupo">
            <label for="transporteValor" class="col-md-2 control-label text-warning">
                Valor transporte
            </label>
            <span class="col-md-2">
                <g:textField name="transporteValor" class="form-control" value="${itemInstance?.transporteValor ?: 0}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: itemInstance, field: 'transporte', 'error')} ">
        <span class="grupo">
            <label for="transporte" class="col-md-2 control-label text-success">
                Transporte
            </label>
            <span class="col-md-3">
                <g:select name="transporte" from="${['N': 'Normal', "F" : "Fijo"]}" optionValue="value" optionKey="key" class="form-control" value="${itemInstance?.transporte}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
            <span class="col-md-2" id="spanTransporte">
                <g:textField name="transporetFijo" class="form-control hide" value="${itemInstance?.transporetFijo ?: 0}" />
            </span>
        </span>
    </div>

%{--    <g:if test="${departamento?.subgrupo?.grupo?.id == 3}">--}%
    <g:if test="${grupo == 3}">
        <div class="form-group ${hasErrors(bean: itemInstance, field: 'combustible', 'error')} ">
            <span class="grupo">
                <label for="combustible" class="col-md-2 control-label text-info">
                    Combustible
                </label>
                <span class="col-md-2">
                    <g:select name="combustible" from="${['S': 'Sí', 'N': 'No']}" optionValue="value" optionKey="key" class="form-control" value="${itemInstance?.combustible}" />
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>
    </g:if>

    <div class="form-group ${hasErrors(bean: itemInstance, field: 'observaciones', 'error')} ">
        <span class="grupo">
            <label for="observaciones" class="col-md-2 control-label text-info">
                Observaciones
            </label>
            <span class="col-md-8">
                <g:textArea name="observaciones" maxlength="127"  style="resize: none" class="form-control" value="${itemInstance?.observaciones ?: ''}" />
            </span>
        </span>
    </div>

</g:form>

<script type="text/javascript">

    var bcpc;
    var bcpct;

    cargarSpanTransporte($("#transporte option:selected").val());

    $("#transporte").change(function () {
        var s = $(this).val();
        cargarSpanTransporte(s)
    });

    function cargarSpanTransporte(tipo){
        if(tipo === 'F'){
            $("#transporetFijo").removeClass("hide").val(${itemInstance?.transporetFijo})
        }else{
            $("#transporetFijo").addClass("hide").val(0)
        }
    }

    cargarCodigos();

    $("#departamento").change(function () {
        cargarCodigos();
        $("#codigo").val('')
    });

    function cargarCodigos () {
        var d = cargarLoader("Cargando...");
        var departamento = $("#departamento option:selected").val();
        $.ajax({
            type : "POST",
            url : "${g.createLink(controller: 'mantenimientoItems',action:'codigos_ajax')}",
            data     : {
                id: departamento
            },
            success  : function (msg) {
                d.modal("hide");
                $("#divCodigos").html(msg)
            }
        });
    }

    $("#btnBuscarCPCTransporte").click(function () {
        $.ajax({
            type    : "POST",
            url: "${createLink(action:'buscadorCPCTransporte_ajax')}",
            data    : {},
            success : function (msg) {
                bcpct = bootbox.dialog({
                    id      : "dlgBuscarCPCT",
                    title   : "Buscar Código Compras Públicas Transporte",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        }
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    });

    $("#btnBuscadrCPC").click(function () {
        $.ajax({
            type    : "POST",
            url: "${createLink(action:'buscadorCPC')}",
            data    : {},
            success : function (msg) {
                bcpc = bootbox.dialog({
                    id      : "dlgBuscarCPC",
                    title   : "Buscar Código Compras Públicas",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        }
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    });

    function cerrarBuscadorCPC(){
        bcpc.modal("hide")
    }

    function cerrarBuscadorCPCT(){
        bcpct.modal("hide")
    }

    $('#datetimepicker1').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        // daysOfWeekDisabled: [0, 6],
        sideBySide: true,
        icons: {
        }
    });

    function label() {
        var c = $("#tipoLista option:selected").data("unidad");
        if (c === "null") {
            $("#grupoPeso").hide();
        } else {
            $("#grupoPeso").show();
            $("#item_unidad").val(c);
        }
    }

    function validarNum(ev) {
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
            (ev.keyCode >= 96 && ev.keyCode <= 105) ||
            ev.keyCode === 190 || ev.keyCode === 110 ||
            ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
            ev.keyCode === 37 || ev.keyCode === 39);
    }

    function validarNumDec(ev) {
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
            (ev.keyCode >= 96 && ev.keyCode <= 105) ||
            ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode ===9 ||
            ev.keyCode === 37 || ev.keyCode === 39);
    }

    function validarComilla(ev) {
        /*
         48-57      -> numeros
         96-105     -> teclado numerico
         188        -> , (coma)
         190        -> . (punto) teclado
         110        -> . (punto) teclado numerico
         8          -> backspace
         46         -> delete
         9          -> tab
         37         -> flecha izq
         39         -> flecha der
         */
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
            (ev.keyCode >= 96 && ev.keyCode <= 105) ||
            ev.keyCode === 190 || ev.keyCode === 110 ||
            ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
            ev.keyCode === 37 || ev.keyCode === 39 ||
            ev.keyCode >= 65 && ev.keyCode <= 90 );
    }

    $("#codigo").keydown(function (ev) {
        return validarNumDec(ev)
    });

    $("#transporteValor").keydown(function (ev) {
        return validarNum(ev);
    });

    $("#codigoEspecificacion").keydown(function (ev) {
        return validarComilla(ev);
    });

    label();

    $(".peso").bind({
        keydown : function (ev) {
            // esta parte valida el punto: si empieza con punto le pone un 0 delante, si ya hay un punto lo ignora
            if (ev.keyCode === 190 || ev.keyCode === 110) {
                var val = $(this).val();
                if (val.length === 0) {
                    $(this).val("0");
                }
                return val.indexOf(".") === -1;
            } else {
                // esta parte valida q sean solo numeros, punto, tab, backspace, delete o flechas izq/der
                return validarNum(ev);
            }
        }, //keydown
        keyup   : function () {
            var val = $(this).val();
            // esta parte valida q no ingrese mas de 2 decimales
            var parts = val.split(".");
            if (parts.length > 1) {
                if (parts[1].length > 6) {
                    parts[1] = parts[1].substring(0, 6);
                    val = parts[0] + "." + parts[1];
                    $(this).val(val);
                }
            }

        }
    });

    $("#tipoLista").change(function () {
        label();
    });

    $(".allCaps").blur(function () {
        this.value = this.value.toUpperCase();
    });

    // $("#transporte").change(function () {
    //     var v = $(this).val();
    //     var l = "";
    //     if (v === 'P' || v === 'P1') {
    //         l = "Ton";
    //     } else {
    //         l = "M<sup>3</sup>";
    //     }
    //     $("#item_unidad").val(l);
    // });

    $("#frmSave").validate({
        rules          : {
            codigo : {
                remote : {
                    url  : "${createLink(action:'checkCdIt_ajax')}",
                    type : "post",
                    data : {
                        id  : "${itemInstance?.id}",
                        dep : "${itemInstance?.departamento?.id ?: departamento?.id}"
                    }
                }
            },
            nombre : {
                remote : {
                    url  : "${createLink(action:'checkNmIt_ajax')}",
                    type : "post",
                    data : {
                        id : "${itemInstance?.id}"
                    }
                }
            },
            campo  : {
                remote : {
                    url  : "${createLink(action:'checkCmIt_ajax')}",
                    type : "post",
                    data : {
                        id : "${itemInstance?.id}"
                    }
                },
                regex  : /^[A-Za-z\d_]+$/
            }
        },
        messages       : {
            codigo : {
                remote : "El código ya se ha ingresado para otro item"
            },
            nombre : {
                remote : "El nombre ya se ha ingresado para otro item"
            },
            campo  : {
                regex  : "El nombre corto no permite caracteres especiales",
                remote : "El nombre ya se ha ingresado para otro item"
            }
        },
        errorPlacement : function (error, element) {
            if (element.parent().hasClass("input-group")) {
                error.insertAfter(element.parent());
            } else {
                error.insertAfter(element);
            }
            element.parents(".grupo").addClass('has-error');
        },
        success        : function (label) {
            label.parents(".grupo").removeClass('has-error');
        },
        errorClass     : "help-block",
    });

</script>