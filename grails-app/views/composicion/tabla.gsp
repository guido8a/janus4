<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Composición de la obra</title>

    <style>

    .active{
        color: #ffffff !important;
        background-color: #0A246A !important;
        font-weight: bold;
    }

    </style>
</head>

<body>
<div class="hoja">
    <div class="span12 breadcrumb" style="font-size: 18px; margin-bottom: 10px"><strong>Valores para la obra: ${obra?.descripcion}</strong> </div>

    <g:if test="${flash.message}">
        <div class="col-md-12">
            <div class="alert ${flash.clase ?: 'alert-info'}" role="status">
                <a class="close" data-dismiss="alert" href="#">×</a>
                ${flash.message}
            </div>
        </div>
    </g:if>

    <div class="btn-toolbar" style="margin-top: 15px;">
        <div class="btn-group">
            <a href="${g.createLink(controller: 'obra', action: 'registroObra', params: [obra: obra?.id])}" class="btn btn-primary"
               title="Regresar a la obra">
                <i class="fa fa-arrow-left"></i>
                Regresar Obra
            </a>
            <a href="${g.createLink(controller: 'variables', action: 'composicion', params: [id: obra?.id])}" class="btn btn-info"
               title="Regresar a la obra">
                <i class="fa fa-arrow-left"></i>
                Regresar Composición
            </a>
        </div>

        <div class="btn-group" style="margin-left: 40px">
            <g:if test="${(obra?.responsableObra?.departamento?.direccion?.id == persona?.departamento?.direccion?.id &&
                    duenoObra == 1 && obra?.estado != 'R')}">
                <a href="${g.createLink(action:'formArchivo', params: [id: obra?.id])}" class="btn btn-success" id="${obra.id}">
                    <i class="fa fa-upload"></i> Cargar Excel
                </a>
                <a href="#" class="btn recargarComposicion btn-warning" title="Recargar Composición" id="${obra.id}">
                    <i class="fa fa-retweet"></i>
                    Recargar Composición
                </a>
            </g:if>
        </div>

        <div class="btn-group" data-toggle="buttons-radio" style="margin-left: 80px">
            <a href="#" id="btnTodos" class="btn btn-info toggle pdf ${tipo.toString().contains(",") ? 'active' : ''} -1">
                <i class="fa fa-cogs"></i>
                Todos
            </a>
            <a href="#" id="btnMateriales" class="btn btn-info toggle pdf ${tipo.toString() == '[1]' ? 'active' : ''} 1">
                <i class="fa fa-briefcase"></i>
                Materiales
            </a>
            <a href="#" id="btnManoObra" class="btn btn-info toggle pdf ${tipo.toString() == '[2]' ? 'active' : ''} 2">
                <i class="fa fa-users"></i>
                Mano de obra
            </a>
            <a href="#" id="btnEquipos" class="btn btn-info toggle pdf ${tipo.toString() == '[3]' ? 'active' : ''} 3">
                <i class="fa fa-truck"></i>
                Equipos
            </a>
        </div>
    </div>

    <div class="col-md-12" style="margin-bottom: 10px; margin-top: 10px">
        <div class="col-md-1" style="width: 100px;">
            <b>Código</b>
            <input type="hidden" style="width: 60px" id="item_id">
            <g:textField name="item_codigo" style="width: 100px;font-size: 12px" id="item_codigo" readonly="true" class="form-control" />
            <g:hiddenField name="id_existente"/>
        </div>
        <div class="col-md-6" style="margin-left: 10px;">
            <b>Descripción</b>
            <g:textField name="item_nombre" style="font-size: 14px" id="item_nombre" readonly="" class="form-control"/>
        </div>
        <div class="col-md-1" style="margin-top: 20px;">
            <a class="btn btn-sm btn-success btn-ajax" href="#" rel="tooltip" title="Agregar Item" id="btnBuscarItem">
                <i class="fa fa-search"></i> Buscar
            </a>
        </div>

        <div class="col-md-2" style="margin-left: 0px; width: 60px;">
            <b>Unidad</b>
            <g:textField name="item_unidad" style="width: 45px;text-align: right" id="item_unidad" value="" readonly="true" class="form-control"/>
        </div>

        <div class="col-md-2" style="margin-left: 0px; width: 120px;">
            <b>Cantidad</b>
            <g:textField name="item_cantidad" style="width: 110px;text-align: right" id="item_cantidad" value="" class="form-control" />
        </div>

        <div class="col-md-2" style="margin-left: 10px;width: 100px;">
            <b>Precio</b>
            <g:textField name="item_precio" style="width: 95px;text-align: right" id="item_precio" value="" readonly="true" class="form-control" />
        </div>

        <div class="col-md-1" style="margin-top:35px">
            <input type="hidden" value="" id="vol_id">
            <g:if test="${(obra?.responsableObra?.departamento?.direccion?.id == persona?.departamento?.direccion?.id && duenoObra == 1 && obra?.estado != 'R')}">
                <a href="#" class="btn btn-sm btn-success" title="agregar" style="margin-top: -25px" id="item_agregar">
                    <i class="fa fa-plus"></i>
                </a>
                <a href="#" class="btn btn-sm btn-small btn-success hidden" title="Guardar" style="margin-top: -25px" id="guardarEdicion">
                    <i class="fa fa-save"></i>
                </a>
                <a href="#" class="btn btn-sm btn-small btn-warning " title="Cancelar" style="margin-top: -25px" id="cancelar">
                    <i class="fa fa-times"></i>
                </a>
            </g:if>
        </div>
    </div>

    <div class="body">
        <table class="table table-bordered table-condensed table-hover table-striped" id="tbl">
            <thead>
            <tr style="width: 100%">
                <g:if test="${tipo.toString().contains(",") || tipo.toString() == '[1]'}">
                    <th style="width: 8%">Código</th>
                    <g:if test="${tipo.toString().contains(",")}">
                        <th style="width: 35%">Item</th>
                    </g:if>
                    <g:else>
                        <th style="width: 44%">Item</th>
                    </g:else>
                    <th style="width: 5%">U</th>
                    <th style="width: 7%">Cantidad</th>
                    <th style="width: 7%">P. Unitario</th>
                    <th style="width: 7%">Transporte</th>
                    <th style="width: 7%">Costo</th>
                    <th style="width: 7%">Total</th>
                    <g:if test="${tipo.toString().contains(",")}">
                        <th style="width: 9%">Tipo</th>
                    </g:if>
                    <th style="width: 8px">Acciones</th>
                </g:if>
                <g:elseif test="${tipo.toString() == '[2]'}">
                    <th style="width: 8%">Código</th>
                    <th style="width: 58%">Mano de obra</th>
                    <th style="width: 5%">U</th>
                    <th style="width: 7%">Horas hombre</th>
                    <th style="width: 7%">Costo</th>
                    <th style="width: 7%">Total</th>
                    <th style="width: 8px">Acciones</th>
                </g:elseif>
                <g:elseif test="${tipo.toString() == '[3]'}">
                    <th style="width: 8%">Código</th>
                    <th style="width: 51%">Equipo</th>
                    <th style="width: 5%">U</th>
                    <th style="width: 7%">Cantidad</th>
                    <th style="width: 7%">Tarifa</th>
                    <th style="width: 7%">Costo</th>
                    <th style="width: 7%">Total</th>
                    <th style="width: 8px">Acciones</th>
                </g:elseif>

            </tr>
            </thead>
        </table>
        <div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px; margin-bottom: 10px">
            <table class="table table-bordered table-condensed table-hover table-striped">
                <tbody>
                <g:set var="totalEquipo" value="${0}"/>
                <g:set var="totalMano" value="${0}"/>
                <g:set var="totalMaterial" value="${0}"/>
                <g:if test="${res.size() > 0}">
                    <g:each in="${res}" var="r">
                        <tr style="width: 100%">
                            <td style="width: 8%">${r.item.codigo}</td>
                            <td style="width: ${tipo.toString() == '[1]' ? 44 : (tipo.toString() == '[2]' ? 58 : (tipo.toString() == '[3]' ? 51 : 35))} %">${r.item.nombre}</td>
                            <td style="width: 5%">${r.item.unidad.codigo}</td>
                            <td style="width: 7%" class="numero cantidad texto " iden="${r.id}" width="100px">
                                <g:formatNumber number="${r.cantidad}" minFractionDigits="3" maxFractionDigits="3" format="##,##0" locale="ec"/>
                            </td>
                            <g:if test="${tipo.toString() != '[2]'}">
                                <td style="width: 7%" class="numero ${r.id} ">
                                    <g:formatNumber number="${r.precio}" minFractionDigits="3" maxFractionDigits="3" format="##,##0" locale="ec"/>
                                </td>
                            </g:if>
                            <g:if test="${tipo.toString().contains(",") || tipo.toString() == '[1]'}">
                                <td style="width: 7%" class="numero ${r.id} transporte">
                                    <g:formatNumber number="${r.transporte}" minFractionDigits="3" maxFractionDigits="3" format="##,##0" locale="ec"/>
                                </td>
                            </g:if>
                            <td style="width: 7%" class="numero ${r.id} precio ${(tipo.toString() =='[2]')?'textoPrecio':''}" iden="${r.id}">
                                <g:formatNumber number="${r.transporte + r.precio}" minFractionDigits="3" maxFractionDigits="3" format="##,##0" locale="ec"/>
                            </td>
                            <td style="width: 7%" class="numero ${r.id} total">
                                <g:formatNumber number="${(r.transporte + r.precio) * r.cantidad}" minFractionDigits="3" maxFractionDigits="3" format="##,##0" locale="ec"/>
                                <g:if test="${r?.grupo?.id == 1}">
                                    <g:set var="totalMaterial" value="${totalMaterial + ((r.transporte + r.precio) * r.cantidad)}"/>
                                </g:if>
                                <g:elseif test="${r.grupo.id == 2}">
                                    <g:set var="totalMano" value="${totalMano + ((r.transporte + r.precio) * r.cantidad)}"/>
                                </g:elseif>
                                <g:elseif test="${r.grupo.id == 3}">
                                    <g:set var="totalEquipo" value="${totalEquipo + ((r.transporte + r.precio) * r.cantidad)}"/>
                                </g:elseif>
                            </td>
                            <g:if test="${tipo.toString().contains(",")}">
                                <td style="width: 9%">${r?.grupo}</td>
                            </g:if>
                            <td style="width: 8%; text-align: center;" class="col_delete">
                                <a class="btn btn-xs btn-success editarItem" href="#" rel="tooltip" title="Editar"
                                   data-id="${r.id}" data-precio="${g.formatNumber(number: r.precio, maxFractionDigits: 3, minFractionDigits: 3, format: '##,##0', locale: 'ec')}" data-cant="${g.formatNumber(number: r.cantidad, maxFractionDigits: 3, minFractionDigits: 3, locale: 'ec')}"
                                   data-uni="${r.item.unidad.codigo}" data-cod="${r.item.codigo}" data-nom="${r.item.nombre}" data-item="${r.item.id}">
                                    <i class="fa fa-edit"></i>
                                </a>
                                <a class="btn btn-xs btn-danger borrarItem" href="#" rel="tooltip" title="Eliminar"
                                   data-id="${r.id}">
                                    <i class="fa fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                    </g:each>
                </g:if>
                <g:else>
                    <tr>
                        <td colspan="9" style="text-align: center">
                            <i class="fa fa-exclamation-triangle fa-2x text-warning"></i>  <strong style="font-size: 14px">No se encontraron datos</strong>
                        </td>
                    </tr>
                </g:else>
                </tbody>
            </table>
        </div>

        <div id="totales" style="width:100%; margin-top: 10px">
            <input type='text' id='txt' style='height:20px;width:110px;margin: 0px;padding: 0px;padding-right:2px;text-align: right !important;display: none;margin-left: 0px;margin-right: 0px;'>
            <table class="table table-bordered ta195ble-condensed pull-right" style="width: 40%;">
                <thead>
                <tr>
                    <th>MATERIALES</th>
                    <th>MANO DE OBRA</th>
                    <th>EQUIPOS</th>
                    <th>TOTAL DIRECTO</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td  class="numero " style="text-align: right; font-size: 14px; font-weight: bold"><g:formatNumber number="${totalMaterial}" minFractionDigits="2" maxFractionDigits="2" format="##,##0" locale="ec"/></td>
                    <td  class="numero " style="text-align: right; font-size: 14px; font-weight: bold"><g:formatNumber number="${totalMano}" minFractionDigits="2" maxFractionDigits="2" format="##,##0" locale="ec"/></td>
                    <td  class="numero" style="text-align: right; font-size: 14px; font-weight: bold"><g:formatNumber number="${totalEquipo}" minFractionDigits="2" maxFractionDigits="2" format="##,##0" locale="ec"/></td>
                    <td  class="numero" style="text-align: right; font-size: 14px; font-weight: bold"><g:formatNumber number="${totalEquipo + totalMano + totalMaterial}" minFractionDigits="2" maxFractionDigits="2" format="##,##0" locale="ec"/></td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script type="text/javascript">

    var bcit;

    $("#guardarEdicion").click(function (){
        $("#dlgLoad").dialog("open");

        var id =  $("#id_existente").val();
        var item = $("#item_id").val();
        var cantidad = $("#item_cantidad").val();
        var obra = '${obra?.id}';

        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'composicion', action: 'guardarEditado_ajax')}',
            data:{
                id: id,
                item: item,
                cantidad: cantidad,
                obra: obra
            },
            success: function (msg) {
                $("#dlgLoad").dialog("close");
                if(msg === 'ok'){
                    log("Item guardado correctamente", "success");
                    cancelar();
                    location.reload();
                }else{
                    bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Error al guardar el item" + '</strong>');
                    cancelar();
                }
            }
        })
    });

    function validarNumDec(ev) {
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
            (ev.keyCode >= 96 && ev.keyCode <= 105) ||
            ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
            ev.keyCode === 37 || ev.keyCode === 39 || ev.keyCode === 190 || ev.keyCode === 110);
    }

    $("#item_cantidad").keydown(function (ev) {
        return validarNumDec(ev)
    });

    $(".editarItem").click(function () {
        var id = $(this).data("id");
        var item = $(this).data("item");
        var precio = $(this).data("precio");
        var cantidad = $(this).data("cant");
        var unidad = $(this).data("uni");
        var codigo = $(this).data("cod");
        var nombre = $(this).data("nom");

        $("#id_existente").val(id);
        $("#item_id").val(item);
        $("#item_precio").val(precio);
        $("#item_cantidad").val(cantidad);
        $("#item_unidad").val(unidad);
        $("#item_nombre").val(nombre);
        $("#item_codigo").val(codigo);
        // $("#cancelar").removeClass("hidden");
        $("#guardarEdicion").removeClass("hidden");
        $("#item_agregar").addClass("hidden")
    });

    $("#cancelar").click(function () {
        cancelar();
    });

    function cancelar(){
        $("#id_existente").val('');
        $("#item_id").val('');
        $("#item_precio").val('');
        $("#item_cantidad").val('');
        $("#item_unidad").val('');
        $("#item_nombre").val('');
        $("#item_codigo").val('');
        // $("#cancelar").addClass("hidden");
        $("#guardarEdicion").addClass("hidden");
        $("#item_agregar").removeClass("hidden")
    }

    $(".borrarItem").click(function (){
        var id = $(this).data("id");
        bootbox.confirm({
            title: "<i class='fa fa-trash text-danger'></i> Eliminar item",
            message: "<strong style='font-size: 14px'> Está seguro de querer eliminar este item de la composición? </strong>",
            buttons: {
                cancel: {
                    label: '<i class="fa fa-times"></i> Cancelar',
                    className: 'btn-primary'
                },
                confirm: {
                    label: '<i class="fa fa-trash"></i> Borrar',
                    className: 'btn-danger'
                }
            },
            callback: function (result) {
                if (result) {
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(controller: 'composicion', action: 'borrarItem_ajax')}",
                        data    : {
                            id : id
                        },
                        success : function (msg) {
                            if (msg === "ok") {
                                log("Item borrado correctamente", "success");
                                cancelar();
                                location.reload();
                            } else {
                                bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Error al borrar el item" + '</strong>');
                            }
                        }
                    });
                }
            }
        });
    });

    function caja(texto, titulo){
        return $.box({
            imageClass: "box_info",
            text: texto,
            title: titulo,
            iconClose: false,
            dialog: {
                resizable: false,
                draggable: false,
                buttons: {
                    "Aceptar": function () {
                    }
                }
            }
        });
    }

    $("#btnBuscarItem").click(function () {
        cancelar();
        $.ajax({
            type    : "POST",
            url: "${createLink(controller: 'composicion',  action:'buscarItems_ajax')}",
            data    : {},
            success : function (msg) {
                bcit = bootbox.dialog({
                    id      : "dlgBuscarItems",
                    title   : "Buscar Items",
                    class : "modal-lg",
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

    function cerrarBuscarItems() {
        bcit.modal("hide");
    }

    function precios(item) {
        var obra = ${obra.id}
            $.ajax({
                type    : "POST",
                url     : "${g.createLink(controller: 'composicion',action:'precios')}",
                data    : "obra=" + obra + "&item=" + item,
                success : function (msg) {
                    var parts = msg.split(";")
                    $("#item_precio").val(parts[0])
                    $("#item_transporte").val(parts[1])
                }
            });
    }

    function updateTotal(celda) {
        if(celda.parent().hasClass("precio")){
            var val = celda.val()
            val = val.replace(",", "")
            var cant = celda.parent().parent().find(".cantidad").html()
            cant = cant.replace(",", "")
            celda.parent().parent().find(".total").html(number_format(cant * val, 2, ".", ""))
        }else{
            var val = celda.val()
            val = val.replace(",", "")
            var precio = celda.parent().parent().find(".precio").html()
            precio = precio.replace(",", "")
            celda.parent().parent().find(".total").html(number_format(precio * val, 2, ".", ""))
        }
    }


    $("#item_codigo").dblclick(function () {
        var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cerrar</a>');
        $("#modalTitle").html("Lista de items");
        $("#modalFooter").html("").append(btnOk);
        $("#modal-rubro").modal("show");
        $("#buscarDialog").unbind("click");
        $("#buscarDialog").bind("click", enviar)
    });

    $("#btn-comp").click(function () {
        location.href = "${createLink(controller: 'variables', action: 'composicion', id: obra?.id)}"
    });

    $("#item_codigo").blur(function () {
        if ($("#item_id").val() == "" && $("#item_codigo").val() != "") {
            $.ajax({type : "POST", url : "${g.createLink(controller: 'composicion',action:'buscarRubroCodigo')}",
                data     : "codigo=" + $("#item_codigo").val(),
                success  : function (msg) {
                    if (msg != "-1") {
                        var parts = msg.split("&&");
                        $("#item_id").val(parts[0]);
                        precios(parts[0]);
                        $("#item_nombre").val(parts[2])
                    } else {
                        $("#item_id").val("");
                        $("#item_nombre").val("")
                    }
                }
            });
        }
    });

    $("#item_codigo").keydown(function (ev) {
        if (ev.keyCode * 1 !== 9 && (ev.keyCode * 1 < 37 || ev.keyCode * 1 > 40)) {
            $("#item_id").val("");
            $("#item_nombre").val("");
            $("#item_precio").val("");
            $("#item_transporte").val("")
        } else {
        }
    });

    $("#item_agregar").click(function () {
        var cantidad = $("#item_cantidad").val();
        cantidad = str_replace(",", "", cantidad);
        var rubro = $("#item_id").val();
        if (isNaN(cantidad))
            cantidad = 0;
        var msn = "";
        if (cantidad * 1 <= 0) {
            msn = "La cantidad debe ser un número positivo mayor a 0"
        }
        if (rubro * 1 < 1)
            msn = "Seleccione un item";

        if (msn.length === 0) {
            var datos = "rubro=" + rubro + "&cantidad=" + cantidad + "&obra=${obra.id}";

            $.ajax({type : "POST", url : "${g.createLink(controller: 'composicion',action:'addItem')}",
                data     : datos,
                success  : function (msg) {
                    if (msg === "ok") {
                        log("Item guardado correctamente", "success");
                        cancelar();
                        location.reload()
                    } else {
                        bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Error al guardar el item" + '</strong>');
                    }
                }
            });
        } else {
            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + msn + '</strong>');
        }
    });

    $("#guardar").click(function () {
        var data = "data=";
        var data2="&data2=";
        $(".changed").each(function () {
            var val = $(this).html();
            val = val.replace(",", "");
            if($(this).hasClass("cantidad"))
                data += $(this).attr("iden") + "I" + val + "X";
            else
                data2 += $(this).attr("iden") + "I" + val + "X"
        });
        $.ajax({
            type    : "POST",
            url     : "${g.createLink(controller: 'composicion',action:'save')}",
            data    : data+data2,
            success : function (msg) {
                if (msg === "ok")
                    location.reload()
            }
        });
    });

    $("#txt").keyup(function (event) {
//            console.log(event.which)
        if (event.which == 13) {
            updateTotal($(this))
            var valor = $(this).val()
//                console.log("eenter ",valor)
            $(this).val("")
            $(this).hide()
            var padre = $(this).parent()
            $("#totales").append($(this))
            padre.html(valor)
            padre.addClass("changed")
            if(padre.hasClass("precio"))
                padre.addClass("textoPrecio")
            else
                padre.addClass("texto")
        }
        if (event.which == 40) {
            updateTotal($(this))
            var valor = $(this).val()
            $(this).val("")
            $(this).hide()
            var padre = $(this).parent()
            $("#totales").append($(this))
            padre.html(valor)
            if(padre.hasClass("precio"))
                padre.addClass("textoPrecio")
            else
                padre.addClass("texto")
            padre.addClass("changed")
//                console.log(padre.parent(),padre.parent(),padre.parent().next())
            if(padre.hasClass("precio"))
                padre.parent().next().find(".precio").click()
            else
                padre.parent().next().find(".cantidad").click()
        }
        if (event.which == 38) {
            updateTotal($(this))
            var valor = $(this).val()
            $(this).val("")
            $(this).hide()
            var padre = $(this).parent()
            $("#totales").append($(this))
            padre.html(valor)
            padre.addClass("changed")
            if(padre.hasClass("precio"))
                padre.addClass("textoPrecio")
            else
                padre.addClass("texto")
//                console.log(padre.parent(),padre.parent(),padre.parent().next())
            if(padre.hasClass("precio"))
                padre.parent().next().find(".precio").click()
            else
                padre.parent().next().find(".cantidad").click()
        }

    })
    $("#txt").blur(function () {
//            console.log("blur")
        if ($("#txt").val() != "") {
            updateTotal($(this))
            var valor = $(this).val()
            $(this).val("")
            $(this).hide()
            var padre = $(this).parent()
            $("#totales").append($(this))
            padre.addClass("changed")
            padre.html(valor)
            if(padre.hasClass("precio"))
                padre.addClass("textoPrecio")
            else
                padre.addClass("texto")
        }
    })
    var txt = $("#txt")
    $(".cantidad").click(function () {
        if ($(this).hasClass("texto")) {
            txt.width($(this).innerWidth() - 25)
            var valor = $(this).html().trim()
            $(this).html("")
            txt.val(valor)
            $(this).append(txt)
            txt.show()
            $(this).removeClass("texto")
            txt.focus()
        }

    });
    <g:if test="${tipo=='2'}">
    $(".precio").click(function () {
        if ($(this).hasClass("textoPrecio")) {
            txt.width($(this).innerWidth() - 25)
            var valor = $(this).html().trim()
            $(this).html("")
            txt.val(valor)
            $(this).append(txt)
            txt.show()
            $(this).removeClass("textoPrecio")
            txt.focus()
        }

    });
    </g:if>

    $(".recargarComposicion").click(function () {
        bootbox.confirm({
            title: "<i class='fa fa-retweet text-danger'></i> Recargar Composición",
            message: "<strong style='font-size: 14px'>  Está seguro de querer volver a cargar la composición de la obra: ${obra?.nombre} ? </strong> </br> <strong style='font-size:14px' class='text-danger'> Este proceso elimina todos los datos de la composición actual. </strong> ",
            buttons: {
                cancel: {
                    label: '<i class="fa fa-times"></i> Cancelar',
                    className: 'btn-primary'
                },
                confirm: {
                    label: '<i class="fa fa-retweet"></i> Aceptar',
                    className: 'btn-success'
                }
            },
            callback: function (result) {
                if (result) {
                    var b = cargarLoader("Cargando...");
                    $.ajax({
                        type    : "POST",
                        url     : "${g.createLink(controller: 'composicion',  action: 'recargar')}",
                        data    : "id=${obra?.id}",
                        success : function (msg) {
                            b.modal("hide");
                            location.reload()
                        }
                    })
                }
            }
        });
    });

    $("#btnTodos").click(function () {
        location.href = "${g.createLink(controller: 'composicion', action: 'tabla', params: [id: obra?.id, tipo: -1])}"
    });

    $("#btnMateriales").click(function () {
        location.href = "${g.createLink(controller: 'composicion', action: 'tabla', params: [id: obra?.id, tipo: 1])}"
    });

    $("#btnManoObra").click(function () {
        location.href = "${g.createLink(controller: 'composicion', action: 'tabla', params: [id: obra?.id, tipo: 2])}"
    });

    $("#btnEquipos").click(function () {
        location.href = "${g.createLink(controller: 'composicion', action: 'tabla', params: [id: obra?.id, tipo: 3])}"
    });

</script>
</body>
</html>