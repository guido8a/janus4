<style>
.desalojo { color: #4d2868; }
.historico { color: #804a4c; }

table {
    table-layout: fixed;
    overflow-x: scroll;
}
th, td {
    overflow: hidden;
    text-overflow: ellipsis;
    word-wrap: break-word;
}

</style>

<div class="row-fluid" style="margin-left: 0px">
    <g:if test="${msg}">
        <div class="alert ${flash.clase ?: 'alert-info'}" role="status" style="width: 80%">${msg}</div>
    </g:if>
    <div class="span-6" style="margin-bottom: 5px">
        <b>Subpresupuesto:</b>
        <g:select name="subpresupuesto" from="${subPres}" optionKey="${{it.id}}" optionValue="${{it.descripcion}}"
                  style="width: 240px;font-size: 10px" id="subPres_desc" value="${subPre}"
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
        <a href="#" class="btn btn-sm  btn-info" id="btnReordenar">
            <i class="fa fa-retweet"></i>
            Reordenar
        </a>
    </div>
</div>
<div role="main" style="margin-top: 5px;">
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
                Especifi.
            </th>
            <th style="width: 24%;">
                Rubro
            </th>
            <th style="width: 5%" class="col_unidad">
                Unidad
            </th>
            <th style="width: 7%">
                Cantidad
            </th>
            <th class="col_precio" style="display: none; width: 7%">Unitario</th>
            <th class="col_total" style="display: none; width: 10%">C.Total</th>
            <th style="width: 10%" class="col_delete">Acciones</th>
        </tr>
        </thead>
    </table>
</div>
<div class="" style="width: 99.7%;height: 500px; overflow-y: auto;float: right; margin-top: -20px">
    <g:set var="vols" value="[]"/>

    <table class="table-bordered table-striped table-condensed table-hover">
        <tbody>
        <g:each in="${valores}" var="val" status="j">
            <tr style="width: 100%" class="item_row ${val.rbrocdgo[0..1] == 'TR'? 'desalojo': (val.rbrocdgo[0] == 'H'? 'historico': '')}" id="${val.vlob__id}"  item="${val}"
                dscr="${val.vlobdscr}" sub="${val.sbpr__id}" cdgo="${val.item__id}" title="${val.vlobdscr}">
                <td style="width: 5%" class="orden">${val.vlobordn}</td>
                <td style="width: 15%" class="sub">${val.sbprdscr.trim()}</td>
                <td class="cdgo" style="width: 11%">${val.rbrocdgo.trim()}</td>
                <td class="cdes" style="width: 6%">${val.itemcdes?.trim()}</td>
                <td class="nombre" style="width: 24%">${val.rbronmbr.trim()}</td>
                <td style="width: 5%;text-align: center" class="col_unidad" >${val.unddcdgo.trim()}</td>
                <td style="width: 7%; text-align: right" class="cant">
                    <g:formatNumber number="${val.vlobcntd}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/>
                </td>
                <td class="col_precio" style="display: none;text-align: right;width: 7%" id="i_${val.item__id}"><g:formatNumber
                        number="${val.pcun}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/></td>
                <td class="col_total total" style="display: none;text-align: right; width: 10%">
                    <g:formatNumber number="${val.totl}" format="##,##0" minFractionDigits="4"  maxFractionDigits="4" locale="ec"/>
                </td>

                <td style="width: 10%;text-align: center" class="col_delete">
                    <g:if test="${obra.estado!='R' && duenoObra == 1}">
                        <a class="btn btn-xs btn-success editarItem" href="#" rel="tooltip" title="Editar" iden="${val.vlob__id}"
                           data-orden="${val.vlobordn}" data-nom="${val.rbronmbr}" data-can="${val.vlobcntd}"
                           data-cod="${val.rbrocdgo}" item="${val}"  dscr="${val.vlobdscr}" sub="${val.sbpr__id}"
                           cdgo="${val.item__id}">
                            <i class="fa fa-edit"></i>
                        </a>
                        <a class="btn btn-xs btn-danger borrarItem" href="#" rel="tooltip" title="Eliminar" iden="${val.vlob__id}">
                            <i class="fa fa-trash"></i>
                        </a>
                    </g:if>
                </td>
                <g:set var="vols" value="${vols +=(val.vlob__id)}"/>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>

<div id="borrarSubpreDialog">
    <fieldset>
        <div class="span3">
            Esta seguro que desea borrar este subpresupuesto con todos sus rubros?
        </div>
    </fieldset>
</div>

<script type="text/javascript">

    $("#btnReordenar").click(function () {
        bootbox.confirm({
            title: "Reordenar rubros",
            message: "<i class='fa fa-exclamation-triangle text-info fa-3x'></i> <strong style='font-size: 14px'> Está seguro que desea reordenar los rubros automáticamente?</strong> ",
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
                if(result){
                    var d = cargarLoader("Borrando...");
                    $.ajax({
                        type : "POST",
                        url : "${g.createLink(controller: 'volumenObra',action:'reordenar_ajax')}",
                        data     : {
                            rubros: '${vols}'
                        },
                        success  : function (msg) {
                            d.modal("hide");
                            if(msg === "ok"){
                                log("Rubros reordenados correctamente", "success");
                                cargarTabla()
                            }else{
                                bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + msg +'</strong>');
                            }
                        }
                    });
                }
            }
        });
    });

    $.contextMenu({
        selector: '.item_row',
        callback: function (key, options) {
            var m = "clicked: " + $(this).attr("id");
            if (key === "print") {
            }

            if (key === "foto") {
                var child = window.open('${createLink(controller:"rubro", action:"showFoto")}/' + $(this).attr("cdgo") +
                    '?tipo=il', 'GADLR', 'width=850,height=800,toolbar=0,resizable=0,menubar=0,scrollbars=1,status=0');
                if (child.opener == null)
                    child.opener = self;
                window.toolbar.visible = false;
                window.menubar.visible = false;
            }

            if (key === "espc") {
                var child = window.open('${createLink(controller:"rubro", action:"showFoto")}/' + $(this).attr("cdgo") +
                    '?tipo=dt', 'GADLR', 'width=850,height=800,toolbar=0,resizable=0,menubar=0,scrollbars=1,status=0');
                if (child.opener == null)
                    child.opener = self;
                window.toolbar.visible = false;
                window.menubar.visible = false;
            }

            if (key === 'print-key1') {
                var dsps =
                ${obra.distanciaPeso}
                var dsvs =
                ${obra.distanciaVolumen}
                var clickImprimir = $(this).attr("id");
                var fechaSalida1 = '${obra.fechaOficioSalida?.format('dd-MM-yyyy')}';
                var datos = "fecha=${obra.fechaPreciosRubros?.format('dd-MM-yyyy')}&id=" + clickImprimir + "&obra=${obra.id}" + "&fechaSalida=" + fechaSalida1 + "&desglose=" + '0';
                location.href = "${g.createLink(controller: 'reportesRubros',action: 'reporteRubrosVolumen')}?" + datos;
            }

            if (key === 'print-key2') {
                var dsps =
                ${obra.distanciaPeso}
                var dsvs =
                ${obra.distanciaVolumen}
                var clickImprimir = $(this).attr("id");
                var fechaSalida2 = '${obra.fechaOficioSalida?.format('dd-MM-yyyy')}';
                var datos = "fecha=${obra.fechaPreciosRubros?.format('dd-MM-yyyy')}&id=" + clickImprimir + "&obra=${obra.id}" + "&fechaSalida=" + fechaSalida2 + "&desglose=" + '1';
                location.href = "${g.createLink(controller: 'reportesRubros',action: 'reporteRubrosVolumen')}?" + datos;
            }

            if (key === 'print-key3') {
                var dsps =
                ${obra.distanciaPeso}
                var dsvs =
                ${obra.distanciaVolumen}
                var clickImprimir = $(this).attr("id");
                var fechaSalida1 = '${obra?.fechaOficioSalida?.format('dd-MM-yyyy')}';
                var datos = "fecha=${obra.fechaPreciosRubros?.format('dd-MM-yyyy')}&id=" + clickImprimir + "&obra=${obra.id}" + "&fechaSalida=" + fechaSalida1 + "&desglose=" + '0';
                location.href = "${g.createLink(controller: 'reportesRubros',action: 'reporteRubrosVaeVolumen')}?" + datos;
            }

            if (key === 'print-key4') {
                var dsps = ${obra.distanciaPeso}
                var dsvs = ${obra.distanciaVolumen}
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

    function editarFormRubro(id) {
        $.ajax({
            type    : "POST",
            url: "${createLink(controller: 'volumenObra', action:'formRubroVolObra_ajax')}",
            data    : {
                id: id
            },
            success : function (msg) {
                var er = bootbox.dialog({
                    id      : "dlgEditRubroVO",
                    title   : "Editar rubro",
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
                                return submitFormRubro();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    } //createEdit

    function submitFormRubro() {
        var $form = $("#frmRubroVolObra");
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
                        cargarTabla();
                    }else{
                        if(parts[0] === 'err'){
                            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                            return false;
                        }else{
                            log(parts[1], "error");
                            return false;
                        }
                    }
                }
            });
        } else {
            return false;
        }
    }

    $(".editarItem").click(function () {
        var id = $(this).attr("iden");
        editarFormRubro(id);
    });

    $(".borrarItem").click(function () {
        var id = $(this).attr("iden");
        bootbox.confirm({
            title: "Eliminar",
            message: "<i class='fa fa-exclamation-triangle text-info fa-3x'></i> <strong style='font-size: 14px'> Está seguro de eliminar este rubro?</strong> ",
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
                                log("Rubro borrado correctamente", "success");
                                cargarTabla()
                            }else{
                                bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + msg +'</strong>');
                            }
                        }
                    });
                }
            }
        });
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

    %{--$("#borrarDialog").dialog({--}%
    %{--    autoOpen: false,--}%
    %{--    resizable: false,--}%
    %{--    modal: true,--}%
    %{--    draggable: false,--}%
    %{--    width: 350,--}%
    %{--    height: 200,--}%
    %{--    position: 'center',--}%
    %{--    title: 'Borrar',--}%
    %{--    buttons: {--}%
    %{--        "Aceptar": function () {--}%
    %{--            $.ajax({type: "POST", url: "${g.createLink(controller: 'volumenObra',action:'eliminarRubro')}",--}%
    %{--                data: "id=" + $(this).attr("iden"),--}%
    %{--                success: function (msg) {--}%
    %{--                    clearInterval(interval);--}%
    %{--                    $("#detalle").html(msg)--}%
    %{--                }--}%
    %{--            });--}%
    %{--            $("#borrarDialog").dialog("close");--}%
    %{--        },--}%

    %{--        "Cancelar" : function () {--}%
    %{--            $("#borrarDialog").dialog("close");--}%
    %{--        }--}%
    %{--    }--}%
    %{--});--}%

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
                $(this).replaceWith(spinner);
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
                        if(parts[0] === 'OK'){
                            $("#spinner").hide();
                            $("#borrarSubpreDialog").dialog("close");
                            $("#divError").hide();
                            $("#spanOk").html(parts[1]);
                            $("#divOk").show();
                            setTimeout(function() {
                                location.reload();
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

    calcularSiempre();

</script>