
<style>

    .marcado{
        background-color: #5e9cff;
    }

</style>


<%@ page import="janus.SubPresupuesto" contentType="text/html;charset=UTF-8" %>

<body>

<table class="table table-bordered table-condensed table-hover">
    <thead>
    <tr>
        <th rowspan="2">N.</th>
        <th rowspan="2">Descripción del rubro</th>
        <th rowspan="2" class="borderLeft">U.</th>
        <th rowspan="2">Precio unitario</th>
        <th rowspan="2">Volumen contrat.</th>
        <th colspan="3" class="borderLeft">Cantidades</th>
        <th colspan="3" class="borderLeft">Valores</th>
    </tr>
    <tr>
        <th class="borderLeft">Anterior</th>
        <th>Actual</th>
        <th>Acumulado</th>
        <th class="borderLeft">Anterior</th>
        <th>Actual</th>
        <th>Acumulado</th>
    </tr>
    </thead>
    <tbody id="tbDetalle">
    <g:set var="totalAnterior" value="${0}"/>
    <g:set var="totalActual" value="${0}"/>
    <g:set var="totalAcumulado" value="${0}"/>

    <g:set var="sp" value="null"/>
    <g:each in="${detalle}" var="vol">
        <g:set var="det" value="${janus.ejecucion.DetallePlanillaEjecucion.findByPlanillaAndVolumenContrato(planilla, vol)}"/>
    %{--                    <g:set var="anteriores" value="${janus.ejecucion.DetallePlanillaEjecucion.findAllByPlanillaInListAndVolumenContrato(planillasAnteriores, vol)}"/>--}%


        <g:if test="${planillasAnteriores?.size() > 0}">
            <g:set var="anteriores" value="${janus.ejecucion.DetallePlanillaEjecucion.findAllByPlanillaInListAndVolumenContrato(planillasAnteriores, vol)}"/>
            <g:set var="cantAnt" value="${anteriores.sum { it.cantidad } ?: 0}"/>
            <g:set var="valAnt" value="${anteriores.sum { it.monto } ?: 0}"/>
        </g:if>
        <g:else>
            <g:set var="cantAnt" value="${0}"/>
            <g:set var="valAnt" value="${0}"/>
        </g:else>



    %{--                    <g:set var="cantAnt" value="${anteriores.sum { it.cantidad } ?: 0}"/>--}%
    %{--                    <g:set var="valAnt" value="${anteriores.sum { it.monto } ?: 0}"/>--}%
        <g:set var="cant" value="${det?.cantidad ?: 0}"/>
        <g:set var="val" value="${det?.monto ?: 0}"/>

        <g:set var="totalAnterior" value="${totalAnterior + valAnt}"/>
        <g:set var="totalActual" value="${totalActual + val.toDouble().round(2)}"/>
        <g:set var="totalAcumulado" value="${totalAcumulado + val.toDouble().round(2) + valAnt}"/>

        <g:if test="${sp != vol.subPresupuestoId}">
            <tr class="subpresupuesto">
                <th colspan="2" style="color: #ffffee; background-color: #0a3a61 !important">
                    Sub Presupuesto: (${vol.subPresupuestoId}) ${vol.subPresupuesto.descripcion}
                </th>
                <td colspan="3" class="espacio borderLeft"></td>
                <td colspan="3" class="espacio borderLeft"></td>
                <td colspan="3" class="espacio borderLeft"></td>
            </tr>
            <g:set var="sp" value="${vol.subPresupuestoId}"/>
        </g:if>
        <tr class="trTodos" id="${det?.id}" style="border-bottom: black solid" data-id="${det ? det.id : 'nuevo'}" data-vol="${vol.id}" data-cant="${cant}" data-val="${val}" data-canto="${cant}" data-valo="${val}" data-valacu="${val + valAnt}">
            <td class="codigo">
                ${vol.item.codigo}
            </td>
            <td class="nombre">
                ${vol.item.nombre}
            </td>
            <td style="text-align: center" class="unidad borderLeft">
                ${vol.item.unidad.codigo}
            </td>
            <td class="num precioU" data-valor="${precios[vol.id.toString()]}">
                <elm:numero number="${precios[vol.id.toString()]}" cero="hide"/>
            </td>
            <td class="num cantidad" data-valor="${vol.volumenCantidad}">
                <elm:numero number="${vol.volumenCantidad}" cero="hide"/>
            </td>

            <!-------------------------------------------------------------------------------------------------------------------------------------------------------------->
            <td class="ant num cant borderLeft" id="ant_${vol.id}_${planilla.id}" data-valor="${cantAnt}" data-valoro="${cantAnt}">
                <elm:numero number="${cantAnt}" cero="hide"/>
            </td>

            <td class="act num cant" data-valor="${cant}" >
                <g:if test="${editable}">
                    <div style="display: inline-block">
                    <g:textField name="val_${vol.id}_${planilla.id}" class="input-mini number act" value="${cant}" style="width:100px"/>
                    %{--<g:textField name="val_${vol.id}_${planilla.id}" class="input-mini number act" value="${cant}"/>--}%
                    <a href="#" class="btn btn-success btn-xs btnGuardarUno" data-id="${det ? det.id : 'nuevo'}"
                       data-vol="${vol.id}" data-cant="${cant}" data-val="${val}" title="Guardar" >
                        <i class="fa fa-save"></i>
                    </a>
                    </div>
                </g:if>
                <g:else>
                    <elm:numero number="${cant}" cero="hide"/>
                </g:else>
            </td>
            <td class="acu num cant" id="acu_${vol.id}_ ${planilla.id}" data-valor="${cant + cantAnt}" data-valoro="${cant + cantAnt}">
                <elm:numero number="${cant + cantAnt}" cero="hide"/>
            </td>
            <!-------------------------------------------------------------------------------------------------------------------------------------------------------------->
            <td class="ant num val borderLeft" data-valor="${valAnt}" data-valoro="${valAnt}">
                <elm:numero number="${valAnt}" cero="hide"/>
            </td>
            <td class="act num val" data-valor="${val}" data-valoro="${val}">
                <elm:numero number="${val}" cero="hide"/>
            </td>
            <td class="acu num val" data-valor="${val + valAnt}" data-valoro="${val + valAnt}">
                <elm:numero number="${val + valAnt}" cero="hide"/>
            </td>
        </tr>
    </g:each>
    </tbody>
    <tfoot>
    <tr style="font-size: smaller">
        <td colspan="5" class="borderTop">
            <b>OBSERVACIONES:</b>
        </td>
        <td colspan="3" class="espacio borderLeft borderTop">
            <b>A) TOTAL AVANCE DE OBRA</b>
        </td>
        <td class="borderLeft borderTop num totalAnt" data-valor="${totalAnterior}" data-valoro="${totalAnterior}" style="font-size: larger">
            <elm:numero number="${totalAnterior}" cero="hide"/>
        </td>
        <td class="borderTop num totalAct" data-valor="${totalActual}" data-valoro="${totalActual}" style="font-size: larger">
            <elm:numero number="${totalActual}" cero="hide"/>
        </td>
        <td class="borderTop num totalAcu" data-valor="${totalAcumulado}" data-valoro="${totalAcumulado}" data-max="${contrato.monto + cmpl}" style="font-size: larger">
            <elm:numero number="${totalAcumulado}" cero="hide"/>
        </td>
    </tr>
    <tr class="breadcrumb">
        <td colspan="9" style="text-align: right; font-weight: bold; font-size: 14px">
            TOTAL
        </td>
        <td colspan="2" id="divTotal">

        </td>
    </tr>
    </tfoot>
</table>

<script type="text/javascript">
    function validarNum(ev) {
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
            ev.keyCode == 190 || ev.keyCode == 110 ||
            ev.keyCode == 8 || ev.keyCode == 46 || ev.keyCode == 9 ||
            ev.keyCode == 37 || ev.keyCode == 39 ||
            ev.keyCode == 173 || ev.keyCode == 109);
    }

    function updateRow($row) {
        var val = $row.find(".number.act").val();
        // esta parte hace los calculos
        var $antCant = $row.find(".ant.num.cant");
        var $acuCant = $row.find(".acu.num.cant");
        var $antVal = $row.find(".ant.num.val");
        var $acuVal = $row.find(".acu.num.val");

        // $("#trTodos").removeClass("marcado");
        // $row.addClass("marcado");

        if (val !== "") {
            val = parseFloat(val);
            //si no es vacio calcula
            var precio = $row.find(".precioU").data("valor");
            var total = (parseFloat(val) * parseFloat(precio));
            total = parseFloat(number_format(total, 2, ".", ""));

            //el valor actual
            $row.find(".act.num.val").text(number_format(total, 2, ".", ",")).data("valor", total);

            //los acumulados
            var anterior = parseFloat($antCant.data("valor"));
            var acuCant = anterior + val;
            numero($acuCant, acuCant);

            anterior = parseFloat($antVal.data("valor"));
            var acuVal = anterior + total;
            numero($acuVal, acuVal);

            // actualiza los valores en el row
            $row.data({
                cant   : val,
                val    : total,
                valacu : acuVal
            });
        } else {
            //si esta vacio solo pone en 0
            $row.find(".act.num.val").text("").data("valor", 0);
            $row.data({
                cant   : $row.data("canto"),
                val    : $row.data("valo"),
                valacu : $acuVal.data("valoro")
            });
            numero($antCant, $antCant.data("valoro"));
            numero($acuCant, $acuCant.data("valoro"));
            numero($antVal, $antVal.data("valoro"));
            numero($acuVal, $acuVal.data("valoro"));
        }
    }

    function numero($item, val) {
//                console.log($item, val);
        if ($item.is("input")) {
            if (val != 0 && val != "" && !isNaN(val)) {
                $item.val(number_format(val, 2, ".", "")).data("valor", val);
            } else {
                $item.val("").data("valor", 0);
            }
        } else {
            if (val !== 0 && val !== "" && !isNaN(val)) {
                $item.text(number_format(val, 2, ".", ",")).data("valor", val);
            } else {
                $item.text("").data("valor", 0);
            }
        }
    }

    cargarTotal();

    function cargarTotal(){
        var id = '${planilla?.id}';
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'planilla', action: 'total_ajax')}',
            data:{
               id: id
            },
            success: function (msg) {
                  $("#divTotal").html(msg)
            }
        })
    }

    $(function () {

        // $("#btnUpdate").click(function() {
        //     return false;
        // });

        $("input.number").first().focus();

//                $("#tbDetalle").children("tr").each(function () {
//                    updateRow($(this));
//                });

        $("#btnSave").click(function () {
            if (!$(this).hasClass("disabled")) {
                $("#dlgLoad").dialog("open");
                var data = "";
                $("#tbDetalle").children("tr").each(function () {
                    var $row = $(this);
                    var vol = $row.data("vol");
                    var cant = $row.data("cant");
                    var val = $row.data("val");
                    var id = $row.data("id");

                    if (vol !== undefined && cant !== undefined) {
                        data += "d=" + vol + "_" + cant + "_" + val;
                        if (id !== "nuevo") {
                            data += "_" + id;
                        }
                        data += "&";
                    }
                });
                if (data === "") {
                    $("#dlgLoad").dialog("close");
                    bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Ingrese el detalle de la planilla" + '</strong>');
                } else {
                    $(this).replaceWith(spinner);
                    data += "id=${planilla.id}&total=" + $(".totalAct").data("valor");
                    location.href = "${createLink(action:'saveDetalleNuevo')}?" + data;
                }

            }
            return false;
        });

        $(".btnGuardarUno").click(function () {
            var volumen = $(this).data("vol");
            var cant = $(this).data("cant");
            var val = $(this).data("val");
            var id = $(this).data("id");
            var planilla = '${planilla.id}';
            var total = $(".totalAct").data("valor");
            var nuevoValor = $("#val_" + volumen + "_" + planilla ).val();

            $.ajax({
                type: 'POST',
                url: '${createLink(controller: 'planilla', action: 'saveDetalleUno_ajax')}',
                data:{
                    vol: volumen,
                    cant: cant,
                    val: val,
                    id: id,
                    planilla: planilla,
                    total: total,
                    nuevoValor:nuevoValor
                },
                success: function (msg) {
                    var parts = msg.split("_");
                    cargarTotal();
                    if(parts[0] === 'ok'){

//                        $(".trTodos").removeClass("marcado");
//                        $("#" + id).addClass("marcado");
                        $("#val_" + volumen + "_" + planilla).focus();

                        log(parts[1], "success")
                    }else{
                        log(parts[1], "error")
                    }
                }
            })

        });

        $(".number").bind({
            keydown : function (ev) {
                // esta parte valida el punto: si empieza con punto le pone un 0 delante, si ya hay un punto lo ignora
                if (ev.keyCode == 190 || ev.keyCode == 110) {
                    var val = $(this).val();
                    if (val.length == 0) {
                        $(this).val("0");
                    }
                    return val.indexOf(".") == -1;
                } else {
                    // esta parte valida q sean solo numeros, punto, tab, backspace, delete o flechas izq/der
                    return validarNum(ev);
                }
            }, //keydown
            keyup   : function (ev) {
                var $input = $(this);
                var val = $(this).val();
                // esta parte valida q no ingrese mas de 2 decimales
                var parts = val.split(".");
                if (parts.length > 1) {
                    if (parts[1].length > 2) {
                        parts[1] = parts[1].substring(0, 2);
                        val = parts[0] + "." + parts[1];
                        $(this).val(val);
                    }
                }
                // esta parte hace los calculos
                updateRow($(this).parents("tr"));

                //esta parte maneja los cambios de input con flechas y enter
                var $td = $input.parent("td");
                var $tr = $input.parents("tr");
                var $nextTr, $nextTd, $nextInput;
                switch (ev.keyCode) {
                    case 13: //enter: cambia al input siguiente si existe. si esta al final no hace nada
                    case 40: //flecha abajo: cambia al input siguiente si existe. si esta al final no hace nada
                        ev.preventDefault();
                        $nextTr = $tr.next();
                        if ($nextTr.hasClass("subpresupuesto")) {
                            $nextTr = $nextTr.next()
                        }
                        $nextTd = $nextTr.children("td").eq($td.index());
                        $nextInput = $nextTd.children(".number");
                        $nextInput.focus();
//                                console.log($input, $td, $tr, $nextTr, $nextTd, $nextInput);
                        break;
                    case 38://flecha arriba: cambia al input anterior si existe. si esta al inicio no hace nada
                        $nextTr = $tr.prev();
                        if ($nextTr.hasClass("subpresupuesto")) {
                            $nextTr = $nextTr.prev()
                        }
                        $nextTd = $nextTr.children("td").eq($td.index());
                        $nextInput = $nextTd.children(".number");
                        $nextInput.focus();
                        ev.preventDefault();
                        break;
                }
            }, //keyup
            blur    : function () {
                // esta parte hace los calculos
                updateRow($(this).parents("tr"));

                // esta parte le pone los 2 decimales si no tiene
                numero($(this), parseFloat($(this).val()));

                var v100 = $(".totalAcu").data("max");
//                        var v125 = parseFloat($(".totalAcu").data("max")) * 1.25;
                var v125 = parseFloat($(".totalAcu").data("max")) * parseFloat(${adicionales});
                if(v125 === 0) v125 = v100;
                var adicionales = Math.round(v125 * 100)/100 + " con el " +
                    parseInt((parseFloat(${adicionales}) - 1) *100) + "% de incremento";
                var respaldo = "";
                if(parseFloat(${adicionales}) === 0) {
                    respaldo = "No se ha subido documento de respaldo de obras adicionales";
                    adicionales = Math.round(v100 * 100)/100  + ", no hay documento de respaldo de obras adicionales";
                } else {
                    respaldo = "El total planillado supera el 100% del monto del contrato"
                }

                var total = 0, totalAcu = 0;
                //esta parte calcula los totales
                $("#tbDetalle").children("tr").each(function () {
                    var $row = $(this);
                    if ($row.data("val")) {
                        total += parseFloat($row.data("val"));
                    }
                    if ($row.data("valacu")) {
                        totalAcu += parseFloat($row.data("valacu"));
                    }
                });

                if (totalAcu > v100 && totalAcu <= v125) {
                    bootbox.alert('<i class="fa fa-exclamation-triangle text-warning fa-3x"></i> ' +
                        '<strong style="font-size: 14px">' + respaldo + '</strong>');
                }

                if (totalAcu > v125) {
                    $("#btnSave").addClass("disabled");
                    bootbox.alert('<i class="fa fa-exclamation-triangle text-warning fa-3x"></i> ' +
                        '<strong style="font-size: 14px">' + "El monto " + Math.round(totalAcu)*100/100 + " supera el máximo de " + adicionales + '</strong>');
                } else {
                    $("#btnSave").removeClass("disabled");
                }

                numero($(".totalAct"), total);
                numero($(".totalAcu"), totalAcu);
            } //blur
        });
    });
</script>

</body>
