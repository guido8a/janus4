<style>
.desalojo { color: #4d2868; }
</style>

<div class="row-fluid" style="margin-left: 0px">
    <g:if test="${msg}">
        <div class="alert ${flash.clase ?: 'alert-info'}" role="status" style="width: 80%">${msg}</div>
    </g:if>
    <div class="span-6" style="margin-bottom: 5px">
        <b>Subpresupuesto:</b>
        <g:select name="subpresupuesto" from="${subPres}" optionKey="id" optionValue="descripcion"
                  style="width: 260px;font-size: 10px" id="subPres_desc" value="${subPre}"
                  noSelection="['-1': 'TODOS']" class="selector"/>

        <a href="#" class="btn btn-xs btn-ajax btn-new" id="ordenarAsc" title="Ordenar Ascendentemente">
            <i class="fa fa-arrow-up"></i>
        </a>
        <a href="#" class="btn btn-xs btn-ajax btn-new" id="ordenarDesc" title="Ordenar Descendentemente">
            <i class="fa fa-arrow-down"></i>
        </a>

        <g:if test="${obra?.estado != 'R' && duenoObra == 1}">
            <a href="#" class="btn btn-xs btn-danger" title="Eliminar subpresupuesto" id="borrarSubpre">
                <i class="fa fa-trash"></i>
            </a>
        </g:if>

        <a href="#" class="btn btn-sm" style="margin-left:40px" id="copiar_rubros" title="Copiar rubros desde un subpresupuesto">
            <i class="fa fa-copy"></i>
            Copiar Rubros
        </a>
        <a href="#" class="btn btn-sm btn-info" id="imprimir_sub">
            <i class="fa fa-print"></i>
            Impr. Subpre.
        </a>
        <a href="#" class="btn btn-sm btn-success" id="imprimir_excel" style="margin-left:0px">
            <i class="fa fa-file-excel"></i>
            Excel
        </a>

        <a href="#" class="btn btn-sm btn-info" id="imprimir_sub_vae">
            <i class="fa fa-print"></i>
            Subpre. VAE
        </a>
        <a href="#" class="btn btn-sm  btn-success" id="imprimir_vae_excel">
            <i class="fa fa-file-excel"></i>
            VAE Excel
        </a>
        <a href="#" class="btn btn-sm  btn-success" id="imprimir_desglose_excel">
            <i class="fa fa-file-excel"></i>
            Desglose
        </a>
    </div>
</div>
<table class="table table-bordered table-striped table-condensed table-hover">
    <thead>
    <tr>
        <th style="width: 5%;">
            #
        </th>
        <th style="width: 15%;">
            Subpresupuesto
        </th>
        <th style="width: 11%;">
            Código
        </th>
        <th style="width: 6%">
            Especificación
        </th>
        <th style="width: 40%;">
            Rubro
        </th>
        <th style="width: 5%" class="col_unidad">
            Unidad
        </th>
        <th style="width: 8%">
            Cantidad
        </th>
        <th class="col_precio" style="display: none;">Unitario</th>
        <th class="col_total" style="display: none;">C.Total</th>
        <g:if test="${obra.estado!='R' && duenoObra == 1}">
            <th style="width: 10%" class="col_delete"></th>
        </g:if>
    </tr>
    </thead>
    <tbody id="tabla_material">

    <g:each in="${valores}" var="val" status="j">
        <tr class="item_row ${val.rbrocdgo[0..1] == 'TR'? 'desalojo':''}" id="${val.vlob__id}"  item="${val}"
            dscr="${val.vlobdscr}" sub="${val.sbpr__id}" cdgo="${val.item__id}" title="${val.vlobdscr}">
            <td style="width: 5%" class="orden">${val.vlobordn}</td>
            <td style="width: 15%" class="sub">${val.sbprdscr.trim()}</td>
            <td class="cdgo" style="width: 11%">${val.rbrocdgo.trim()}</td>
            <td class="cdes" style="width: 6%">${val.itemcdes?.trim()}</td>
            <td class="nombre" style="width: 40%">${val.rbronmbr.trim()}</td>
            <td style="width: 5%;text-align: center" class="col_unidad" >${val.unddcdgo.trim()}</td>
            <td style="width: 8%; text-align: right" class="cant">
                <g:formatNumber number="${val.vlobcntd}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/>
            </td>
            <td class="col_precio" style="display: none;text-align: right" id="i_${val.item__id}"><g:formatNumber
                    number="${val.pcun}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/></td>
            <td class="col_total total" style="display: none;text-align: right">
                <g:formatNumber number="${val.totl}" format="##,##0" minFractionDigits="4"  maxFractionDigits="4" locale="ec"/>
            </td>
%{--            <g:if test="${obra.estado!='R' && duenoObra == 1}">--}%
                <td style="width: 10%;text-align: center" class="col_delete">
                    <a class="btn btn-xs btn-primary editarItem" href="#" rel="tooltip" title="Editar" iden="${val.vlob__id}"
                       data-orden="${val.vlobordn}" data-nom="${val.rbronmbr}" data-can="${val.vlobcntd}"
                       data-cod="${val.rbrocdgo}" item="${val}"  dscr="${val.vlobdscr}" sub="${val.sbpr__id}"
                       cdgo="${val.item__id}" title="${val.vlobdscr}">
                        <i class="fa fa-edit"></i>
                    </a>
                    <a class="btn btn-xs btn-danger borrarItem" href="#" rel="tooltip" title="Eliminar" iden="${val.vlob__id}">
                        <i class="fa fa-trash"></i>
                    </a>
                </td>
%{--            </g:if>--}%
        </tr>
    </g:each>

    </tbody>
</table>

<div id="borrarDialog">
    <fieldset>
        <div class="span3">
            Está seguro que desea borrar este rubro?
        </div>
    </fieldset>
</div>

<div id="borrarSubpreDialog">
    <fieldset>
        <div class="span3">
            Esta seguro que desea borrar este subpresupuesto con todos sus rubros?
        </div>
    </fieldset>
</div>

<script type="text/javascript">

    $.contextMenu({
        selector: '.item_row',
        callback: function (key, options) {
            var m = "clicked: " + $(this).attr("id");
            if (key == "print") {

            }

            if (key == "foto") {
                var child = window.open('${createLink(controller:"rubro", action:"showFoto")}/' + $(this).attr("cdgo") +
                    '?tipo=il', 'GADLR', 'width=850,height=800,toolbar=0,resizable=0,menubar=0,scrollbars=1,status=0');
                if (child.opener == null)
                    child.opener = self;
                window.toolbar.visible = false;
                window.menubar.visible = false;
            }

            if (key == "espc") {
                var child = window.open('${createLink(controller:"rubro", action:"showFoto")}/' + $(this).attr("cdgo") +
                    '?tipo=dt', 'GADLR', 'width=850,height=800,toolbar=0,resizable=0,menubar=0,scrollbars=1,status=0');
                if (child.opener == null)
                    child.opener = self;
                window.toolbar.visible = false;
                window.menubar.visible = false;
            }

            if (key == 'print-key1') {
                var dsps =
                ${obra.distanciaPeso}
                var dsvs =
                ${obra.distanciaVolumen}
                var clickImprimir = $(this).attr("id");
                var fechaSalida1 = '${obra.fechaOficioSalida?.format('dd-MM-yyyy')}';
                var datos = "fecha=${obra.fechaPreciosRubros?.format('dd-MM-yyyy')}&id=" + clickImprimir + "&obra=${obra.id}" + "&fechaSalida=" + fechaSalida1 + "&desglose=" + '0';
                location.href = "${g.createLink(controller: 'reportesRubros',action: 'reporteRubrosVolumen')}?" + datos;
            }

            if (key == 'print-key2') {
                var dsps =
                ${obra.distanciaPeso}
                var dsvs =
                ${obra.distanciaVolumen}
                var clickImprimir = $(this).attr("id");
                var fechaSalida2 = '${obra.fechaOficioSalida?.format('dd-MM-yyyy')}';
                var datos = "fecha=${obra.fechaPreciosRubros?.format('dd-MM-yyyy')}&id=" + clickImprimir + "&obra=${obra.id}" + "&fechaSalida=" + fechaSalida2 + "&desglose=" + '1';
                location.href = "${g.createLink(controller: 'reportesRubros',action: 'reporteRubrosVolumen')}?" + datos;
            }

            if (key == 'print-key3') {
                var dsps =
                ${obra.distanciaPeso}
                var dsvs =
                ${obra.distanciaVolumen}
                var clickImprimir = $(this).attr("id");
                var fechaSalida1 = '${obra?.fechaOficioSalida?.format('dd-MM-yyyy')}';
                var datos = "fecha=${obra.fechaPreciosRubros?.format('dd-MM-yyyy')}&id=" + clickImprimir + "&obra=${obra.id}" + "&fechaSalida=" + fechaSalida1 + "&desglose=" + '0';
                location.href = "${g.createLink(controller: 'reportesRubros',action: 'reporteRubrosVaeVolumen')}?" + datos;
            }

            if (key == 'print-key4') {
                var dsps =
                ${obra.distanciaPeso}
                var dsvs =
                ${obra.distanciaVolumen}
                var clickImprimir = $(this).attr("id");
                var fechaSalida2 = '${obra?.fechaOficioSalida?.format('dd-MM-yyyy')}';
                var datos = "fecha=${obra.fechaPreciosRubros?.format('dd-MM-yyyy')}&id=" + clickImprimir + "&obra=${obra.id}" + "&fechaSalida=" + fechaSalida2 + "&desglose=" + '1';
                location.href = "${g.createLink(controller: 'reportesRubros',action: 'reporteRubrosVaeVolumen')}?" + datos;
            }
        },

        items: {
            "print": {name: "Imprimir", icon: "print",
                items: {
                    "print-key1": {"name": "Imprimir sin Desglose", icon: "print"
                    },
                    "print-key2": {"name": "Imprimir con Desglose", icon: "print"},
                    "print-key3": {"name": "Imprimir VAE sin Desglose", icon: "print"},
                    "print-key4": {"name": "Imprimir VAE con Desglose", icon: "print"}
                }
            },
            "foto": {name: "Ilustración", icon: "doc"},
            "espc": {name: "Especificaciones", icon: "doc"}
        }
    });

    $("#imprimir_sub").click(function () {
        if ($("#subPres_desc").val() !== '') {
            location.href = "${g.createLink(controller: 'reportes3',action: '_imprimirTablaSub')}?obra=" + "${obra.id}&sub=" +  $("#subPres_desc").val();
        } else {
            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Seleccione un subpresupuesto" + '</strong>');
        }
    });

    $("#imprimir_sub_vae").click(function () {
        if ($("#subPres_desc").val() !== '') {
            location.href = "${g.createLink(controller: 'reportes3',action: '_imprimirTablaSubVae')}?obra=" + "${obra.id}&sub=" +  $("#subPres_desc").val();
        } else {
            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Seleccione un subpresupuesto" + '</strong>');
        }
    });

    $("#imprimir_vae_excel").click(function () {
        if ($("#subPres_desc").val() !== '') {
            location.href = "${g.createLink(controller: 'reportesExcel2',action: 'reporteVaeExcel')}?id=" + ${obra?.id} + "&sub=" + $("#subPres_desc").val();
        } else {
            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Seleccione un subpresupuesto" + '</strong>');
        }
    });

    $("#imprimir_excel").click(function () {
        location.href = "${g.createLink(controller: 'reportesExcel2',action: 'reporteExcelVolObra')}?id=" + ${obra?.id} + "&sub=" + $("#subPres_desc").val();
    });

    $("#imprimir_desglose_excel").click(function () {
        location.href = "${g.createLink(controller: 'reportesExcel2',action: 'reporteDesgloseExcelVolObra')}?id=" + ${obra?.id} +  "&sub=" + $("#subPres_desc").val();
    });

    $("#subPres_desc").change(function () {
        $("#ver_todos").removeClass("active");
        $("#divTotal").html("");
        $("#calcular").removeClass("active");

        var datos = "obra=${obra.id}&sub=" + $("#subPres_desc").val() + "&ord=" + 1;
        var interval = loading("detalle");
        $.ajax({type: "POST", url: "${g.createLink(controller: 'volumenObra',action:'tabla')}",
            data: datos,
            success: function (msg) {
                clearInterval(interval);
                $("#detalle").html(msg)
            }
        });
    });

    var datos = "?fecha=${obra.fechaPreciosRubros?.format('dd-MM-yyyy')}Wid=" + $(".item_row").attr("id") + "Wobra=${obra.id}";

    $(".editarItem").click(function () {
        $("#calcular").removeClass("active");
        $(".col_delete").show();
        $(".col_precio").hide();
        $(".col_total").hide();
        $("#divTotal").html("");
        $("#vol_id").val($(this).attr("iden"));   /* gdo: id del registro a editar */
        $("#item_codigo").val($(this).data("cod"));
        $("#item_id").val($(this).attr("item"));
        $("#subPres").val($(this).data("idSub"));
        $("#item_descripcion").val($(this).attr("dscr"));
        $("#item_orden").val($(this).data("orden"));
        $("#item_nombre").val($(this).data("nom"));
        $("#item_cantidad").val($(this).data("can"));

        $.ajax({
            type: "POST",
            url: "${g.createLink(controller: 'volumenObra',action:'cargaCombosEditar')}",
            data: "id=" + $(this).attr("sub"),
            success: function (msg) {
                $("#div_cmb_sub").html(msg)
            }
        });
    });

    $(".borrarItem").click(function () {
        var id = $(this).attr("iden");

        bootbox.confirm({
            title: "Eliminar",
            message: "Está seguro de eliminar este rubro? Esta acción no puede deshacerse.",
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
                if(result){
                    var d = cargarLoader("Borrando...");
                    $.ajax({
                        type : "POST",
                        url : "${g.createLink(controller: 'volumenObra',action:'eliminarRubro')}",
                        data     : {
                            id: id
                        },
                        success  : function (msg) {
                           d.modal("hide");
                            if(msg === "ok"){
                                bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Rubro borrado correctamente" +'</strong>');
                                cargarTabla();
                            }else{
                                bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + msg +'</strong>');
                            }
                        }
                    });
                }
            }
        });



        %{--$.box({--}%
        %{--    imageClass: "box_info",--}%
        %{--    text: "Está seguro de eliminar el rubro?",--}%
        %{--    title: "Alerta",--}%
        %{--    iconClose: false,--}%
        %{--    dialog: {--}%
        %{--        resizable: false,--}%
        %{--        draggable: false,--}%
        %{--        buttons: {--}%
        %{--            "Aceptar": function () {--}%
        %{--                $("#dlgLoad").dialog("open");--}%
        %{--                $.ajax({--}%
        %{--                    type: "POST",--}%
        %{--                    url: "${g.createLink(controller: 'volumenObra',action:'eliminarRubro')}",--}%
        %{--                    data: {--}%
        %{--                        id: id--}%
        %{--                    },--}%
        %{--                    success: function (msg) {--}%
        %{--                        $("#dlgLoad").dialog("close");--}%
        %{--                        if(msg === 'ok'){--}%
        %{--                            $.box({--}%
        %{--                                imageClass: "box_info",--}%
        %{--                                text: "Rubro borrado correctamente",--}%
        %{--                                title: "Alerta",--}%
        %{--                                iconClose: false,--}%
        %{--                                dialog: {--}%
        %{--                                    resizable: false,--}%
        %{--                                    draggable: false,--}%
        %{--                                    buttons: {--}%
        %{--                                        "Aceptar": function () {--}%
        %{--                                            cargarTabla();--}%
        %{--                                        }--}%
        %{--                                    }--}%
        %{--                                }--}%
        %{--                            });--}%
        %{--                        }else{--}%
        %{--                            $.box({--}%
        %{--                                imageClass: "box_info",--}%
        %{--                                text: "Error al borrar el rubro",--}%
        %{--                                title: "Error",--}%
        %{--                                iconClose: false,--}%
        %{--                                dialog: {--}%
        %{--                                    resizable: false,--}%
        %{--                                    draggable: false,--}%
        %{--                                    buttons: {--}%
        %{--                                        "Aceptar": function () {--}%
        %{--                                        }--}%
        %{--                                    }--}%
        %{--                                }--}%
        %{--                            });--}%
        %{--                        }--}%
        %{--                    }--}%
        %{--                });--}%
        %{--            },--}%
        %{--            "Cancelar": function () {--}%
        %{--            }--}%
        %{--        }--}%
        %{--    }--}%
        %{--});--}%
    });

    $("#copiar_rubros").click(function () {
        location.href = "${createLink(controller: 'volumenObra', action: 'copiarRubros')}?obra=" + ${obra?.id};
    });

    $("#ordenarAsc").click(function () {
        $("#divTotal").html("");
        $("#calcular").removeClass("active");
        var orden = 1;
        var datos = "obra=${obra.id}&sub=" + $("#subPres_desc").val() + "&ord=" + orden;
        var interval = loading("detalle");
        $.ajax({type: "POST", url: "${g.createLink(controller: 'volumenObra',action:'tabla')}",
            data: datos,
            success: function (msg) {
                clearInterval(interval)
                $("#detalle").html(msg)
            }
        });
    });

    $("#ordenarDesc").click(function () {
        $("#divTotal").html("")
        $("#calcular").removeClass("active")
        var orden = 2;
        var datos = "obra=${obra.id}&sub=" + $("#subPres_desc").val() + "&ord=" + orden
        var interval = loading("detalle")
        $.ajax({type: "POST", url: "${g.createLink(controller: 'volumenObra',action:'tabla')}",
            data: datos,
            success: function (msg) {
                clearInterval(interval)
                $("#detalle").html(msg)
            }
        });
    });

    $("#borrarDialog").dialog({
        autoOpen: false,
        resizable: false,
        modal: true,
        draggable: false,
        width: 350,
        height: 200,
        position: 'center',
        title: 'Borrar',
        buttons: {
            "Aceptar": function () {
//                   console.log("-->>" + $(this).attr("iden"));
                $.ajax({type: "POST", url: "${g.createLink(controller: 'volumenObra',action:'eliminarRubro')}",
                    data: "id=" + $(this).attr("iden"),
                    success: function (msg) {
                        clearInterval(interval)
                        $("#detalle").html(msg)
                    }
                });
                $("#borrarDialog").dialog("close");
            },

            "Cancelar" : function () {
                $("#borrarDialog").dialog("close");
            }
        }
    });

    var url = "${resource(dir:'images', file:'spinner_24.gif')}";
    var spinner = $("<img style='margin-left:15px;' src='" + url + "' alt='Cargando...'/>");

    $("#borrarSubpreDialog").dialog({
        autoOpen: false,
        resizable: false,
        modal: true,
        draggable: false,
        width: 320,
        height: 180,
        position: 'center',
        title: 'Borrar Subpresupuesto',
        buttons: {
            "Aceptar": function () {
//                $("#spinner").show();
                $(this).replaceWith(spinner)
                var seleccionado = $(".selector option:selected").val();
                $.ajax({
                    type: "POST",
                    url: "${g.createLink(controller: 'volumenObra',action:'eliminarSubpre')}",
                    data: {
                        sub: seleccionado,
                        obra: '${obra?.id}'
                    },
                    success: function (msg) {
                        var parts = msg.split("_");
                        if(parts[0] == 'OK'){
                            $("#spinner").hide();
                            $("#borrarSubpreDialog").dialog("close");
                            $("#divError").hide();
                            $("#spanOk").html(parts[1]);
                            $("#divOk").show();

                            setTimeout(function() {
                                location.reload(true);
                            }, 1000);
                        }else{
                            $("#spinner").hide();
                            $("#borrarSubpreDialog").dialog("close");
                            $("#spanError").html(parts[1]);
                            $("#divError").show()

                        }
                    }
                });

            },
            "Cancelar" : function () {
                $("#borrarSubpreDialog").dialog("close");
            }
        }
    });


    function borrarSupresupuesto () {
        bootbox.confirm({
            title: "Borrar Subpresupuesto",
            message: "<i class='fa fa-exclamation-triangle text-danger fa-3x'></i> Está seguro que desea borrar este subpresupuesto?",
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
                if(result){
                    var g = cargarLoader("Borrando...");
                    var subpresupuesto = $("#subPres_desc option:selected").val();
                    $.ajax({
                        type: "POST",
                        url: "${g.createLink(controller: 'volumenObra',action:'eliminarSubpre')}",
                        data: {
                            sub: subpresupuesto,
                            obra: '${obra?.id}'
                        },
                        success: function (msg) {
                            var parts = msg.split("_");
                            if(parts[0] === 'OK'){
                                log(parts[1], "success");
                                // cargarTabla();
                                setTimeout(function() {
                                    location.reload();
                                }, 1000);
                            }else{
                                log(parts[1], "error")
                            }
                        }
                    });
                }
            }
        });
    }

    $("#borrarSubpre").click(function () {
        var todos = $("#subPres_desc option:selected").val();
        if(todos === '-1'){
            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Seleccione un subpresupuesto" + '</strong>');
        }else{
            borrarSupresupuesto();
        }
    });


</script>