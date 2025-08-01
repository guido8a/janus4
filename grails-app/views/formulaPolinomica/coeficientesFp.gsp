<%@ page import="janus.Grupo" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        FP y Cuadrilla tipo
    </title>

    <asset:javascript src="/jquery/plugins/jquery-validation-1.9.0/jquery.validate.min.js"/>
    <asset:javascript src="/jquery/plugins/jquery-validation-1.9.0/messages_es.js"/>
    <asset:javascript src="/jquery/plugins/jstree/jquery.jstree.js"/>
    <asset:javascript src="/jquery/plugins/jstree/_lib/jquery.cookie.js"/>
    <asset:javascript src="/jquery/plugins/jquery.livequery.js"/>
    <asset:javascript src="/jquery/plugins/box/js/jquery.luz.box.js"/>
    <asset:javascript src="/jquery/plugins/jgrowl/jquery.jgrowl.js"/>
    <asset:javascript src="/jquery/plugins/jstree/jstreegrid.js"/>
    <asset:stylesheet src="/jquery/plugins/box/css/jquery.luz.box.css"/>
    <asset:stylesheet src="/jquery/plugins/editable/bootstrap-editable/css/bootstrap-editable.css"/>
    <asset:stylesheet src="/jquery/plugins/editable/inputs-ext/coords/coords.css"/>
    <asset:stylesheet src="/jquery/plugins/jgrowl/jquery.jgrowl.css"/>
    <asset:stylesheet src="/jquery/plugins/jgrowl/jquery.jgrowl.customThemes.css"/>
    <asset:stylesheet src="apli/tree.css"/>

    <style type="text/css">
    #tree {
        width      : 100%;
        background : none;
        border     : none;
    }

    /*.area {*/
    /*    height : 500px;*/
    /*}*/

    /*.left, .right {*/
    /*    height     : 750px;*/
    /*    float      : left;*/
    /*    overflow-x : hidden;*/
    /*    overflow-y : auto;*/
    /*    border     : 1px solid #E2CBA1;*/
    /*    background : #E5DED3;*/
    /*}*/

    /*.left {*/
    /*    width : 465px;*/
    /*}*/

    /*.right {*/
    /*    width       : 685px;*/
    /*    margin-left : 15px;*/
    /*}*/

    .jstree-grid-cell {
        cursor : pointer;
    }

    .editable {
        background : #98A8B5 !important;
    }

    .selected, .selected td {
    <g:if test="${janus.Parametros.findByEmpresaLike(message(code: 'ambiente2'))}">
        background : #42a151 !important;
    </g:if>
    <g:else>
        background : #A4CCEA !important;
    </g:else>

    }

    .hovered {

    <g:if test="${janus.Parametros.findByEmpresaLike(message(code: 'ambiente2'))}">
        background : #42a151;
    </g:if>
    <g:else>
        background : #C4E5FF;
    </g:else>
    }

    .table-hover tbody tr:hover td,
    .table-hover tbody tr:hover th {
    <g:if test="${janus.Parametros.findByEmpresaLike(message(code: 'ambiente2'))}">
        background-color : #c0efc2 !important;
    </g:if>
    <g:else>
        background-color : #C4E5FF !important;
    </g:else>

        cursor           : pointer;
    }

    table.dataTable tr.odd.selected td.sorting_1, table.dataTable tr.even.selected td.sorting_1 {
    <g:if test="${janus.Parametros.findByEmpresaLike(message(code: 'ambiente2'))}">
        background : #42a151 !important;
    </g:if>
    <g:else>
        background : #88AFCC !important;
    </g:else>

    }

    .jstree-apple a {
        border-radius : 0 !important;
    }

    /*.contenedorTabla {*/
    /*    max-height : 500px;*/
    /*    overflow   : auto;*/
    /*}*/
    </style>

</head>

<body>

<div class="tituloTree">
    <div class="alert alert-info " style="margin-top: 5px">FP obra: ${obra.descripcion + " (" + obra.codigo + ")"}</div>
</div>

<div class="btn-toolbar" style="margin-top: 15px;">

    <div class="btn-group">
        <a href="#" id="btnRegresarObras" class="btn " title="Regresar a la obra">
            <i class="fa fa-arrow-left"></i>
            Regresar
        </a>
    </div>

    <div class="btn-group">
        <g:link action="coeficientesFp" id="${obra.id}" params="[tipo: 'p', sbpr: params.sbpr]"
                class="btn btn-info ${tipo == 'p' ? 'active' : ''} btn-tab">
            <i class="fa fa-cogs"></i>
            Fórmula polinómica
        </g:link>
        <g:link action="coeficientesFp" id="${obra.id}" params="[tipo: 'c', sbpr: params.sbpr]"
                class="btn btn-info  ${tipo == 'c' ? 'active' : ''} btn-tab">
            <i class="fa fa-users"></i>
            Cuadrilla Tipo
        </g:link>
    </div>

    <div class="btn-group"  style="margin-top: 10px">
        <g:if test="${(obra?.responsableObra?.departamento?.direccion?.id == persona?.departamento?.direccion?.id && duenoObra == 1)}">
            <a href="#" class="btn " title="Reiniciar la Fórmula Polinómica"
               style="margin-top: -10px;" id="btnReiniciarFP">
                <i class="fa fa-eraser"></i>
                Reiniciar la Fórmula Polinomica
            </a>
        </g:if>
        <g:link controller="reportes5" action="imprimirCoeficientes" id="${obra?.id}" class="btn btnImprimir"
                title="Imprimir la Fórmula Polinómica" style="margin-top: -10px;">
            <i class="fa fa-print"></i>
            Imprimir coeficientes
        </g:link>

        <g:if test="${(obra?.responsableObra?.departamento?.direccion?.id == persona?.departamento?.direccion?.id && duenoObra == 1)}">
            <a href="#" class="btn" title="Borrar la Fórmula Polinómica"
               style="margin-top: -10px;" id="btnEliminarFP">
                <i class="fa fa-trash"></i>
                Eliminar Fórmula
            </a>
        </g:if>
    </div>
    <div class="btn-group"  style="margin-top: 10px">
        <g:if test="${session?.perfil?.nombre == 'CRFC'}">
            <a href="#" class="btn text-success" title="Borrar la Fórmula Polinómica"
               style="margin-top: -10px;" id="btnAprender">
                <i class="fa fa-user"></i>
                Aprender Fórmulas
            </a>
        </g:if>
    </div>
    <div class="btn-group"  style="margin-top: 10px">
        <a href="#" class="btn btn-info" style="margin-top: -10px;" id="btnOrdenarIndices">
            <i class="fa fa-retweet"></i>
            Ordenar coeficientes
        </a>
    </div>
</div>

<div class="col-md-1"></div>
<div class="col-md-3 ${total < 1 ? 'alert-danger' : 'alert-success'} " style="margin-left: 0">
    <div class="col-md-2"></div>
    <div class="col-md-2" style="font-weight: bold; font-size: 14px; color: #0c6dc4">Total: </div>
    <div class="col-md-2" style="font-weight: bold; font-size: 14px; color: #0c6dc4" id="spanTotal" data-valor='${total}'>
        <g:formatNumber number="${total}" maxFractionDigits="3" minFractionDigits="3" locale="ec"/>
    </div>
</div>

<div id="list-grupo" class="col-md-12" role="main" style="margin-top: 3px;margin-left: 0;">
    <div class="area ui-corner-all" id="formula">

        <div id="formulaLeft" class="col-md-6">
            <div id="tree" style="height: 400px">asdada</div>
        </div>

        <div id="formulaRight" class="col-md-6">
            <div id="rightContents">
                <div class="btn-toolbar" style="margin-left: 10px; margin-bottom:0;">
                    <div class="btn-group">
                        <g:if test="${obra?.liquidacion == 1 || obra.estado != 'R' || obra?.codigo[-1..-2] != 'OF'}">
                            <a href="#" id="btnAgregarItems" class="btn btn-success disabled">
                                <i class="fa fa-plus"></i>
                                Agregar a <span id="spanCoef"></span> <span id="spanSuma" data-total="0"></span>
                            </a>
                            <a href="#" id="btnRemoveSelection" class="btn disabled">
                                <i class="fa fa-minus"></i>
                                Quitar selección
                            </a>
                            <a href="#" id="btnMarcarTodos" class="btn btn-info">
                                <i class="fa fa-plus-circle"></i>
                                Marcar todos
                            </a>
                        </g:if>
                    </div>
                </div>
            </div>
            <div class="span-12" id="tablaBusquedaItems">

            </div>
        </div>
    </div>
</div>

<div class="col-md-12" role="main" style="margin-top: 330px;margin-left: 0;">
    <div class="area ui-corner-all" >

        <div class="col-md-6">

        </div>

        <div class="col-md-6" style="margin-top: -320px">
            <div class="col-md-12" id="divItemsNuevos">

            </div>
        </div>

    </div>
</div>


<div id="modal-formula">
    <div class="modal-body" id="modalBody-formula">
    </div>

    <div class="modal-footer" id="modalFooter-formula">
    </div>
</div>

<div id="modal-sugeridos">
    <div class="modal-body" id="modalBody-sugeridos">
    </div>

    <div class="modal-footer" id="modalFooter-sugeridos">
    </div>
</div>

<div id="modal-sugeridosCt">
    <div class="modal-body" id="modalBody-sugeridosCt"  style="background-color: #e8efe8">
    </div>

    <div class="modal-footer" id="modalFooter-sugeridosCt">
    </div>
</div>

<div class="modal hide fade" id="modal-indice" style="width: 640px;">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">×</button>
        <h3 id="modalTitle-Indc"></h3>
    </div>

    <div class="modal-body" id="modalBody-Indc">
    </div>

    <div class="modal-footer" id="modalFooter-Indc">
    </div>
</div>

<div class="modal hide fade" id="modalMover" style="width: 640px;">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">×</button>
        <h3 id="modalTitleMover">Mover Item</h3>
    </div>

    <div class="modal-body" id="modalBodyMover"> </div>

    <div class="modal-footer" id="modalFooterMover">
        <a href="#" class="btn btn-danger" id="btnMoverCancelar">Cancelar</a>
        <a href="#" class="btn btn-success" id="btnMoverAceptar">Aceptar</a>
    </div>
</div>

<script type="text/javascript">

    $("#btnOrdenarIndices").click(function () {
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'formulaPolinomica', action: 'ordenarIndices_ajax')}',
            data:{
                id: '${obra?.id}',
                tipo: '${tipo}'
            },
            success: function (msg) {
                if(msg === 'ok'){
                    log("Ordenado correctamente", "success");
                    setTimeout(function() {
                        location.reload();
                    }, 1000);
                }
            }
        });
    });


    $("#btnMarcarTodos").click(function () {
        clicTodos();
    });

    cargarFormulaPolinomica('${tipo}');

    function cargarFormulaPolinomica(tipo){
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'formulaPolinomica', action: 'tablaFormula_ajax')}',
            data:{
                id: '${obra?.id}',
                tipo: tipo,
                subpresupuesto: '${subpre}'
            },
            success: function (msg) {
                $("#divFormula").html(msg)
            }
        });
    }

    function cargarItemsNuevos(formula){
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'formulaPolinomica', action: 'tablaItemsNuevos_ajax')}',
            data:{
                obra: '${obra?.id}',
                subpresupuesto: '${subpre}',
                formula: formula
            },
            success: function (msg) {
                $("#divItemsNuevos").html(msg)
            }
        });
    }

    $("#btnBuscarItem").click(function () {
        var codigo = $("#buscaCodigo").val();
        var descripcion = $("#buscaDescrip").val();
        cargarTablaItems(${obra?.id}, '${tipo}', ${subpre}, codigo, descripcion)
    });

    cargarTablaItems(${obra?.id}, '${tipo}', ${subpre});

    function cargarTablaItems (obra, tipo, sub, cod, desc) {
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'formulaPolinomica', action: 'tablaItems')}',
            data:{
                id: obra,
                tipo: tipo,
                subpr: sub,
                codigo: cod,
                descripcion: desc
            },
            success: function (msg) {
                $("#tablaBusquedaItems").html(msg)
            }
        });
    }

    var $tree = $("#tree");
    var $tabla = $("#tblDisponibles");

    var icons = {
        mover:  "${assetPath(src:"tree/box.png")}",
        it:  "${assetPath(src:"tree/box.png")}",
        fp:  "${assetPath(src:"tree/boxes.png")}"
    };

    function updateCoef($row) {
        var nombreOk = true;
        if ($.trim($row.attr("nombre")) === "") {
            nombreOk = false;
        }
        $("#spanCoef").text($.trim($row.attr("numero")) + ": " + $.trim($row.attr("nombre"))).parent().data("nombreOk", nombreOk);
    }

    function updateTotal(val) {
        $("#spanSuma").text("(" + number_format(val, 6, ".", ",") + ")").data("total", val);
    }

    function treeSelection($item) {

        var $parent = $item.parent();
        var strId = $parent.attr("id");
        var parts = strId.split("_");

        var tipo = parts[0];
        var index = $parent.index();
        var numero = $parent.attr("numero");

        var $seleccionados = $("a.selected, div.selected, a.editable, div.editable");

        if (tipo === 'fp') {
            if ("${tipo}" === 'p' && index === 0) { //el primero (p01) de la formula no es seleccionable (el de cuadrilla tipo si es)
                $seleccionados.removeClass("selected editable");
                $parent.children("a, .jstree-grid-cell").addClass("editable parent");
            } else {
                $seleccionados.removeClass("selected editable");
                $parent.children("a, .jstree-grid-cell").addClass("selected editable parent");
                updateCoef($item.parents("li"));


                cargarItemsNuevos(parts[1]);

            }
        } else if (tipo === 'it') {
            $seleccionados.removeClass("selected editable");
            $parent.children("a, .jstree-grid-cell").addClass("editable child");
            var $upper = $parent.parent().parent();
            if ($upper.index() > 0) {
                $seleccionados.removeClass("selected");
                $upper.children("a, .jstree-grid-cell").addClass("selected editable parent");
                updateCoef($upper);

            } else {
                $seleccionados.removeClass("selected");
                $upper.children("a, .jstree-grid-cell").addClass("editable parent");
            }
        }
    }

    function treeNodeEvents($items) {
        $items.bind({
            mouseenter : function (e) {
                var $parent = $(this).parent();
                $parent.children("a, .jstree-grid-cell").addClass("hovered");
            },
            mouseleave : function (e) {
                $(".hovered").removeClass("hovered");
            },
            click      : function (e) {
                treeSelection($(this));
            }
        });
    }

    function updateSumaTotal() {
        var total = 0;

        $("#tree").children("ul").children("li").each(function () {
            var val = $(this).attr("valor");
            val = val.replace(",", ".");
            val = parseFloat(val);
            total += val;
        });
        $("#spanTotal").text(number_format(total, 3, ".", "")).data("valor", total);
    }

    $("#modal-formula").dialog({
        autoOpen: false,
        resizable: true,
        modal: true,
        draggable: false,
        width: 500,
        height: 280,
        position: 'center',
        title: 'Nombre del Indice'
    });

    $("#modal-sugeridos").dialog({
        autoOpen: false,
        resizable: true,
        modal: true,
        draggable: false,
        width: 500,
        height: 230,
        position: 'center',
        title: 'Indices Sugeridos'
    });

    $("#modal-sugeridosCt").dialog({
        autoOpen: false,
        resizable: true,
        modal: true,
        draggable: false,
        width: 500,
        height: 230,
        position: 'center',
        title: 'Indices Sugeridos Cuadrilla Tipo'
    });

    function createContextmenu(node) {

        var parent = node.parent().parent();
        var nodeStrId = node.attr("id");
        var nodeText = $.trim(node.attr("nombre"));
        var parentStrId = parent.attr("id");
        var parentText = $.trim(parent.attr("nombre"));
        var nodeTipo = node.attr("rel");
        var parentTipo = parent.attr("rel");
        var parts = nodeStrId.split("_");
        var nodeId = parts[1];
        var nodeV = node.attr("valor");

        var sugiere = node.attr("sgrc");

        parts = parentStrId.split("_");
        var parentId = parts[1];
        var nodeHasChildren = node.hasClass("hasChildren");
        var cantChildren = node.children("ul").children().size();
        var menuItems = {}, lbl = "", item = "";
        var num = $.trim(node.attr("numero"));
        var hijos = node.children("ul").length;

        switch (nodeTipo) {
            case "fp":

                if(num !== 'p01'){
                    var btnCancel = $('<a href="#" class="btn">Cancelar</a>');
                    var btnCancelSgrc = $('<a href="#" class="btn">Cancelar</a>');
                    var btnCancelSgrcCt = $('<a href="#" class="btn">Cancelar</a>');
                    var btnSave = $('<a href="#"  class="btn btn-success" style="color: #fff;"><i class="fa fa-save"></i> Guardar</a>');
                    var btnSaveSgrc = $('<a href="#"  class="btn btn-success" style="color: #fff;">' +
                        '<i class="fa fa-save"></i> Guardar Sugerencia</a>');
                    var btnSaveSgrcCt = $('<a href="#"  class="btn btn-success" style="color: #fff;">' +
                        '<i class="fa fa-save"></i> Guardar Sgrc</a>');

                    btnCancel.click(function () {
                        $("#modal-formula").dialog("close");
                    });

                    btnCancelSgrc.click(function () {
                        $("#modal-sugeridos").dialog("close");
                    });

                    btnCancelSgrcCt.click(function () {
                        $("#modal-sugeridosCt").dialog("close");
                    });

                    btnSave.click(function () {
                        var indice = $("#indice").val();

                        var valor = $.trim($("#valor").val());
                        var indiceNombre = $("#indice option:selected").text();
                        var cantNombre = 0;

                        var $spans = $("#tree").find("span:contains('" + indiceNombre + "')");
                        $spans.each(function () {
                            var t = $.trim($(this).text());
                            if (t === indiceNombre) {
                                cantNombre++;
                            }
                        });

                        if (indiceNombre === nodeText) {
                            cantNombre = 0;
                        }

                        if (cantNombre === 0) {
                            if (valor !== "") {
                                btnSave.replaceWith(spinner);
                                $.ajax({
                                    type    : "POST",
                                    url     : "${createLink(action: 'guardarGrupo')}",
                                    data    : {
                                        id     : nodeId,
                                        indice : indice,
                                        valor  : valor
                                    },
                                    success : function (msg) {
                                        if (msg === "OK") {
                                            node.attr("nombre", indiceNombre).trigger("change_node.jstree");
                                            node.attr("valor", valor).trigger("change_node.jstree");
                                            $("#modal-formula").dialog("close");
                                            updateSumaTotal();
                                            // location.reload();
                                        }
                                    }
                                });
                            } else {
                            }
                        } else {
                            bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + "No puede ingresar dos coeficientes con el mismo nombre" + '</strong>');
                            return false;
                        }
                    });

                    btnSaveSgrc.click(function () {
                        var indice = $("#indice").val();

                        var valor = $.trim($("#valorSgrc").val());
                        var indiceNombre = $("#indice option:selected").text();
                        var cantNombre = 0;
                        var $spans = $("#tree").find("span:contains('" + indiceNombre + "')");

                        $spans.each(function () {
                            var t = $.trim($(this).text());
                            if (t === indiceNombre) {
                                cantNombre++;
                            }
                        });

                        if (indiceNombre === nodeText) {
                            cantNombre = 0;
                        }

                        if (cantNombre === 0) {
                            btnSaveSgrc.replaceWith(spinner);
                            $.ajax({
                                type    : "POST",
                                url     : "${createLink(action: 'guardarGrupoSgrc')}",
                                data    : {
                                    id     : nodeId,
                                    indice : indice,
                                    valor  : valor,
                                    obra: ${obra.id},
                                    sbpr: ${subpre}
                                },
                                success : function (msg) {
                                    if (msg === "OK") {
                                        node.attr("nombre", indiceNombre).trigger("change_node.jstree");
                                        node.attr("valor", valor).trigger("change_node.jstree");
                                        $("#modal-sugeridos").dialog("close");
                                        updateSumaTotal();
                                        location.reload();
                                    }
                                }
                            });
                        } else {
                            bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' +
                                '<strong style="font-size: 14px">' + "No puede ingresar dos coeficientes con el mismo nombre" +
                                '</strong>');
                            return false;
                        }
                    });

                    btnSaveSgrcCt.click(function () {
                        var indice = $("#indice").val();

                        var valor = $.trim($("#valorSgrc").val());
                        var indiceNombre = $("#indice option:selected").text();
                        var cantNombre = 0;
                        console.log('Compara');
                        var $spans = $("#tree").find("span:contains('" + indiceNombre + "')");

                        $spans.each(function () {
                            var t = $.trim($(this).text());
                            if (t === indiceNombre) {
                                cantNombre++;
                            }
                        });

                        if (indiceNombre === nodeText) {
                            cantNombre = 0;
                        }

                        if (cantNombre === 0) {
                            btnSaveSgrc.replaceWith(spinner);
                            $.ajax({
                                type    : "POST",
                                url     : "${createLink(action: 'guardarGrupoSgrcCt')}",
                                data    : {
                                    id     : nodeId,
                                    indice : indice,
                                    valor  : valor,
                                    obra: ${obra.id},
                                    sbpr: ${subpre}
                                },
                                success : function (msg) {
                                    if (msg === "OK") {
                                        node.attr("nombre", indiceNombre).trigger("change_node.jstree");
                                        node.attr("valor", valor).trigger("change_node.jstree");
                                        $("#modal-sugeridos").dialog("close");
                                        updateSumaTotal();
                                        location.reload();
                                    }
                                }
                            });
                        } else {
                            bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' +
                                '<strong style="font-size: 14px">' + "No puede ingresar dos coeficientes con el mismo nombre" +
                                '</strong>');
                            return false;
                        }
                    });

                    menuItems.editar = {
                        label            : "<i class='fa fa-edit'></i> Editar índice (todos)",
                        separator_before : false,
                        separator_after  : false,
                        action           : function (obj) {
                            <g:if test="${obra?.liquidacion==1 || obra?.estado!='R' || obra?.codigo[-1..-2] != 'OF'}">
                            $.ajax({
                                type    : "POST",
                                url     : "${createLink(action: 'editarGrupo')}",
                                data    : {
                                    id : nodeId
                                },
                                success : function (msg) {
                                    $("#modalTitle-formula").html("Editar grupo");
                                    $("#modalBody-formula").html(msg);
                                    $("#modalFooter-formula").html("").append(btnCancel).append(btnSave);
                                    $("#modal-formula").dialog("open");

                                }
                            });
                            </g:if>
                            <g:else>
                            bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + "No puede modificar los coeficientes de una obra ya registrada" + '</strong>');
                            </g:else>
                        }
                    };

                    if(sugiere === 'false' && num[0] === 'p'){
                        menuItems.sugeridos = {
                            label            : "<i class='fa fa-edit'></i> Índices sugeridos",
                            separator_before : false,
                            separator_after  : false,
                            action           : function (obj) {
                                <g:if test="${obra?.liquidacion==1 || obra?.estado!='R' || obra?.codigo[-1..-2] != 'OF'}">
                                $.ajax({
                                    type    : "POST",
                                    url     : "${createLink(action: 'editarSugeridos')}",
                                    data    : {
                                        id : nodeId,
                                        sbpr: ${subpre},
                                        obra: ${obra.id}
                                    },
                                    success : function (msg) {
                                        $("#modalTitle-sugeridos").html("Editar grupo");
                                        $("#modalBody-sugeridos").html(msg);
                                        $("#modalFooter-sugeridos").html("").append(btnCancelSgrc).append(btnSaveSgrc);
                                        $("#modal-sugeridos").dialog("open");
                                    }
                                });
                                </g:if>
                                <g:else>
                                bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + "No puede modificar los coeficientes de una obra ya registrada" + '</strong>');
                                </g:else>
                            }
                        };
                    }

                    if(sugiere === 'false' && num[0] === 'c'){
                        menuItems.sugeridosCt = {
                            label            : "<i class='fa fa-edit'></i> Índices sugeridos Cuadrilla",
                            separator_before : false,
                            separator_after  : false,
                            action           : function (obj) {
                                <g:if test="${obra?.liquidacion==1 || obra?.estado!='R' || obra?.codigo[-1..-2] != 'OF'}">
                                $.ajax({
                                    type    : "POST",
                                    url     : "${createLink(action: 'editarSugeridosCt')}",
                                    data    : {
                                        id : nodeId,
                                        sbpr: ${subpre},
                                        obra: ${obra.id}
                                    },
                                    success : function (msg) {
                                        $("#modalTitle-sugeridosCt").html("Editar grupo");
                                        $("#modalBody-sugeridosCt").html(msg);
                                        $("#modalFooter-sugeridosCt").html("").append(btnCancelSgrcCt).append(btnSaveSgrcCt);
                                        $("#modal-sugeridosCt").dialog("open");
                                    }
                                });
                                </g:if>
                                <g:else>
                                bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + "No puede modificar los coeficientes de una obra ya registrada" + '</strong>');
                                </g:else>
                            }
                        };
                    }

                    if(nodeV === '0.000' && num.contains("c")){
                        menuItems.borrar = {
                            label            : "<i class='fa fa-trash text-danger'></i> Eliminar nodo",
                            separator_before : false,
                            separator_after  : false,
                            action           : function (obj) {
                                <g:if test="${obra?.liquidacion==1 || obra?.estado!='R' || obra?.codigo[-1..-2] != 'OF'}">
                                bootbox.confirm({
                                    title: "Alerta",
                                    message: "<i class='fa fa-trash text-danger fa-2x'></i>" + "<strong style='font-size: 14px'>" +  "Está seguro de eliminar este nodo?"  + "</strong>",
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
                                        if (result) {
                                            $.ajax({
                                                type    : "POST",
                                                url     : "${createLink(controller: 'formulaPolinomica', action:'borrarNodo_ajax')}",
                                                data    : {
                                                    id   : nodeStrId.split("_")[1]
                                                },
                                                success : function (msg) {
                                                    var parts = msg.split("_");
                                                    if(parts[0] === 'ok'){
                                                        log("Borrado correctamente", "success");
                                                        setTimeout(function() {
                                                            location.reload();
                                                        }, 1000);
                                                    }else{
                                                        bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-2x"></i> ' + '<strong style="font-size: 12px">' + "No puede borrar la formula" + '</strong>');
                                                    }
                                                }
                                            });
                                        }
                                    }
                                });
                                </g:if>
                                <g:else>
                                bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + "No puede modificar los coeficientes de una obra ya registrada" + '</strong>');
                                </g:else>
                            }
                        };
                    }
                }
                break;

            case "it":
                var nodeCod = node.attr("numero");
                var nodeDes = node.attr("nombre");
                var nodeValor = node.attr("valor");
                var nodeItem = node.attr("item");
                var nodePrecio = node.attr("precio");
                var nodeGrupo = node.attr("grupo");

                var $seleccionados = $("a.selected, div.selected, a.editable, div.editable");
                $seleccionados.removeClass("selected editable");
                node.children("a, .jstree-grid-cell").addClass("editable child");
                $seleccionados.removeClass("selected");
                node.parent().parent().children("a, .jstree-grid-cell").addClass("selected editable parent");

                menuItems.agregar = {
                    label            : "<i class='fa fa-list'></i> agregar",
                    separator_before : false,
                    separator_after  : false,
                    action           : function (obj) {
                        <g:if test="${obra?.liquidacion==1 || obra?.estado!='R' || obra?.codigo[-1..-2] != 'OF'}">
                        bootbox.confirm({
                            title: "Alerta",
                            message: "Está seguro de eliminar " + nodeText + " del grupo " + parentText + "?",
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
                                if (result) {
                                    $.ajax({
                                        type    : "POST",
                                        url     : "${createLink(action:'delItemFormula')}",
                                        data    : {
                                            tipo : nodeTipo,
                                            id   : nodeId
                                        },
                                        success : function (msg) {
                                            var msgParts = msg.split("_");
                                            if (msgParts[0] === "OK") {
                                                var totalInit = parseFloat($("#spanTotal").data("valor"));
                                                $("#tree").jstree('delete_node', $("#" + nodeStrId));
                                                var tr = $("<tr>");
                                                var tdItem = $("<td>").append(nodeCod);
                                                var tdDesc = $("<td>").append(nodeDes);
                                                var tdApor = $("<td class='numero'>").append(number_format(nodeValor, 5, '.', ''));
                                                var tdPrec = $("<td class='numero'>").append(number_format(nodePrecio, 5, '.', ''));

                                                tr.append(tdItem).append(tdDesc);
//                                                            if (nodeGrupo.toString() == "2") {
                                                if ("${params.tipo}" === "c") {
                                                    tr.append(tdPrec);
                                                }
                                                tr.append(tdApor);
                                                tr.data({
                                                    valor  : nodeValor,
                                                    nombre : nodeDes,
                                                    codigo : nodeCod,
                                                    item   : nodeItem,
                                                    precio : nodePrecio,
                                                    grupo  : nodeGrupo
                                                });
                                                tr.click(function () {
                                                    clickTr(tr);
                                                });
                                                $("#tblDisponibles").children("tbody").prepend(tr);
                                                tr.show("pulsate");
                                                parent.attr("valor", number_format(msgParts[1], 3, '.', '')).trigger("change_node.jstree");
                                                totalInit -= parseFloat(nodeValor);
                                                $("#spanTotal").text(number_format(totalInit, 3, ".", "")).data("valor", totalInit);
                                                if (parent.children("ul").length === 0) {
                                                    parent.attr("nombre", "").trigger("change_node.jstree");
                                                }
                                            }
                                        }
                                    });
                                }
                            }
                        });
                        </g:if>
                        <g:else>
                        bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + "No puede modificar los coeficientes de una obra ya registrada" + '</strong>');
                        </g:else>
                    }
                };
                menuItems.delete = {
                    label            : "<i class='fa fa-trash'></i> Eliminar",
                    separator_before : false,
                    separator_after  : false,
                    action           : function (obj) {
                        <g:if test="${obra?.liquidacion==1 || obra?.estado!='R' || obra?.codigo[-1..-2] != 'OF'}">
                        bootbox.confirm({
                            title: "Alerta",
                            message: "Está seguro de eliminar " + nodeText + " del grupo " + parentText + "?",
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
                                if (result) {
                                    $.ajax({
                                        type    : "POST",
                                        url     : "${createLink(action:'delItemFormula')}",
                                        data    : {
                                            tipo : nodeTipo,
                                            id   : nodeId
                                        },
                                        success : function (msg) {
                                            var msgParts = msg.split("_");
                                            if (msgParts[0] === "OK") {
                                                var totalInit = parseFloat($("#spanTotal").data("valor"));
                                                $("#tree").jstree('delete_node', $("#" + nodeStrId));
                                                var tr = $("<tr>");
                                                var tdItem = $("<td>").append(nodeCod);
                                                var tdDesc = $("<td>").append(nodeDes);
                                                var tdApor = $("<td class='numero'>").append(number_format(nodeValor, 5, '.', ''));
                                                var tdPrec = $("<td class='numero'>").append(number_format(nodePrecio, 5, '.', ''));

                                                tr.append(tdItem).append(tdDesc);
                                                if ("${params.tipo}" === "c") {
                                                    tr.append(tdPrec);
                                                }
                                                tr.append(tdApor);
                                                tr.data({
                                                    valor  : nodeValor,
                                                    nombre : nodeDes,
                                                    codigo : nodeCod,
                                                    item   : nodeItem,
                                                    precio : nodePrecio,
                                                    grupo  : nodeGrupo
                                                });
                                                tr.click(function () {
                                                    clickTr(tr);
                                                });
                                                $("#tblDisponibles").children("tbody").prepend(tr);
                                                tr.show("pulsate");
                                                parent.attr("valor", number_format(msgParts[1], 3, '.', '')).trigger("change_node.jstree");
                                                totalInit -= parseFloat(nodeValor);
                                                $("#spanTotal").text(number_format(totalInit, 3, ".", "")).data("valor", totalInit);
                                                if (parent.children("ul").length === 0) {
                                                    parent.attr("nombre", "").trigger("change_node.jstree");
                                                }

                                                cargarItemsNuevos(parentId)
                                            }
                                        }
                                    });
                                }
                            }
                        });
                        </g:if>
                        <g:else>
                        bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + "No puede modificar los coeficientes de una obra ya registrada" + '</strong>');
                        </g:else>
                    }
                };
                break;
        }
        return menuItems;
    }

    $("#btnMoverAceptar").click(function () {
        var $seleccionado = $(".idCoefi option:selected").val();
        var nd = $(".idNodo").val();
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'formulaPolinomica', action: 'moverSave')}",
            data    : {
                coef : $seleccionado,
                obra : '${obra?.id}',
                nodo : nd
            },
            success : function (msg) {
                if(msg === 'OK'){
                    $("#modalMover").modal("hide");
                    $("#divError").hide();
                    $("#spanOk").html("Item reasignado correctamente");
                    $("#divOk").show();
                    setTimeout(function() {
                        location.reload();
                    }, 1000);

                }else{
                    $("#modalMover").modal("hide");
                    $("#spanError").html("Error al reasignar el item!");
                    $("#divError").show()
                }

            }
        });
    });

    $("#btnMoverCancelar").click(function () {
        $("#modalMover").modal("hide");
    });

    function clickTr($tr) {
        var $sps = $("#spanSuma");
        var total = parseFloat($sps.data("total"));

        if ($tr.hasClass("selected")) {
            $tr.removeClass("selected");
            total -= parseFloat($tr.data("valor"));
        } else {
            $tr.addClass("selected");
            total += parseFloat($tr.data("valor"));
        }
        if ($tabla.children("tbody").children("tr.selected").length > 0) {
            $("#btnRemoveSelection, #btnAgregarItems").removeClass("disabled");
        } else {
            $("#btnRemoveSelection, #btnAgregarItems").addClass("disabled");
        }
        updateTotal(total);
    }

    $(function () {

        $("#btnRegresarObras").click(function () {

            var total = parseFloat($("#spanTotal").data("valor"));
            var liCont = 0;
            var liEq = 0;
            $("#tree").find("li[rel=fp]").each(function () {
                var liNombre = $.trim($(this).attr("nombre"));
                var liValor = parseFloat($(this).attr("valor"));
                var liUl = $(this).children("ul").length;
                var liNextNombre = $.trim($(this).next().attr("nombre"));
                if ((liValor > 0 && liNombre === "") || (liUl > 0 && liNombre === "")) {
                    liCont++;
                }
                if (liNombre !== "" && liNombre === liNextNombre) {
                    liEq++;
                }
            });
            if (liCont > 0) {
                bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Seleccione un nombre para todos los coeficientes con items." + '</strong>');
                return false;
            }
            if (liEq > 0) {
                bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Seleccione un nombre único para cada coeficiente con items." + '</strong>');
                return false;
            }

            var tipo = "${tipo}";
            if (Math.abs(total - 1) <= 0.0001) {
                location.href="${g.createLink(controller: 'obra', action: 'registroObra', params: [obra: obra?.id])}";
                return true;
            }

            bootbox.confirm({
                title: "Alerta",
                message: "La fórmula polinómica no suma 1. ¿Está seguro de querer salir de esta página?",
                buttons: {
                    confirm: {
                        label: '<i class="fa fa-times"></i> Salir',
                        className: 'btn-primary'
                    },
                    cancel: {
                        label: '<i class="fa fa-check"></i> Continuar en la página',
                        className: 'btn-success'
                    }
                },
                callback: function (result) {
                    if (result) {
                        location.href="${g.createLink(controller: 'obra', action: 'registroObra', params: [obra: obra?.id])}"
                    }
                }
            });
            return false;
        });

        $("#btnRemoveSelection").click(function () {
            if (!$(this).hasClass("disabled")) {
                $tabla.children("tbody").children("tr.selected").removeClass("selected");
                $("#btnRemoveSelection").addClass("disabled");
                updateTotal(0);
                $("#btnRemoveSelection, #btnAgregarItems").addClass("disabled");
            }
            return false;
        });

        $("#btnReiniciarFP").click(function () {
            bootbox.confirm({
                title: "Reiniciar Fórmula Polinómica",
                message: "Está seguro que desea reiniciar la fórmula polinómica?",
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
                    if (result) {

                        $.ajax({
                            async   : false,
                            type    : "POST",
                            url     : "${createLink(action:'borrarFP')}",
                            data    : {
                                obra : ${obra.id}
                            },
                            success : function (msg) {
                                $.ajax({
                                    async   : false,
                                    type    : "POST",
                                    url     : "${createLink(action:'insertarVolumenesItem')}",
                                    data    : {
                                        obra : ${obra.id},
                                        sbpr: ${subpre}
                                    },
                                    success : function (msg1) {
                                        location.reload();
                                    }
                                });
                            }
                        });
                    }
                }
            })
        });

        $("#btnEliminarFP").click(function () {
            bootbox.confirm({
                title: "Eliminar item",
                message: "Está seguro de borrar esta fórmula polinómica? Esta acción no puede deshacerse.",
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
                        var dialog = cargarLoader("Borrando...");
                        $.ajax({
                            async   : false,
                            type    : "POST",
                            url     : "${createLink(action:'borrarFP')}",
                            data    : {
                                obra : ${obra.id}
                            },
                            success : function (msg) {
                                location.reload();
                            }
                        });
                    }
                }
            });
        });

        $("#btnAprender").click(function () {
            bootbox.confirm({
                title: "Actualizar el aprendizaje de la FP",
                message: "Está seguro que desea actualizar el aprendizaje de las fórmulas polinómicas?",
                buttons: {
                    cancel: {
                        label: '<i class="fa fa-times"></i> Cancelar',
                        className: 'btn-primary'
                    },
                    confirm: {
                        label: '<i class="fa fa-user"></i> Aprender',
                        className: 'btn-success'
                    }
                },
                callback: function (result) {
                    if(result){
                        var dialog = cargarLoader("Borrando...");
                        $.ajax({
                            async   : false,
                            type    : "POST",
                            url     : "${createLink(action:'aprenderFP')}",
                            data    : {
                                obra : ${obra.id}
                            },
                            success : function (msg) {
                                location.reload();
                            }
                        });
                    }
                }
            });
        });

        $("#btnAgregarItems").click(function () {
            var $btn = $(this);
            if (!$btn.hasClass("disabled")) {
                if ($(this).data("nombreOk")) {
                    $btn.hide().after(spinner);
                    var $target = $("a.selected").parent();

                    var total = parseFloat($target.attr("valor"));

                    var rows2add = [];
                    var dataAdd = {
                        formula : $target.attr("id"),
                        items   : []
                    };

                    var numero = $target.attr("numero");
                    var msg = "";

                    $tabla.children("tbody").children("tr.selected").each(function () {
                        var data = $(this).data();
                        if ($.trim(numero.toLowerCase()) === "px" && total + parseFloat(data.valor) > 0.2) {
                            msg += "<li>No se puede agregar " + data.nombre + " pues el valor de px no puede superar 0.20</li>";
                        } else {
                            rows2add.push({add : {attr : {item : data.item, numero : data.codigo, nombre : data.nombre, valor : data.valor, precio : data.precio, grupo : data.grupo}, data : "   "}, remove : $(this)});
                            total += parseFloat(data.valor);
                            dataAdd.items.push(data.item + "_" + data.valor);
                        }
                    });

                    if (msg !== "") {
                        $("#divError").html("<ul>" + msg + "</ul>").show("pulsate", 2000, function () {
                            setTimeout(function () {
                                $("#divError").hide("blind");
                            }, 5000);
                        });
                        $btn.show();
                        spinner.remove();
                    } else {
                        $.ajax({                                    async   : false,
                            type    : "POST",
                            url     : "${createLink(action:'addItemFormula')}",
                            data    : dataAdd,
                            success : function (msg) {
                                var msgParts = msg.split("_");
                                if (msgParts[0] === "OK") {

                                    var totalInit = parseFloat($("#spanTotal").data("valor"));

                                    var insertados = {};
                                    var inserted = msgParts[1].split(",");
                                    for (var i = 0; i < inserted.length; i++) {
                                        var j = inserted[i];
                                        if (j !== "") {
                                            var p = j.split(":");
                                            insertados[p[0]] = p[1];
                                        }
                                    }
                                    for (i = 0; i < rows2add.length; i++) {
                                        var it = rows2add[i];
                                        var add = it.add;
                                        var rem = it.remove;

                                        add.attr.id = "it_" + insertados[add.attr.item];
                                        totalInit += parseFloat(add.attr.valor);
                                        $tree.jstree("create_node", $target, "first", add);
                                        if (!$target.hasClass("jstree-open")) {
                                            $('#tree').jstree("open_node", $target);
                                        }
                                        rem.remove();
                                    }
                                    $("#spanTotal").text(number_format(totalInit, 3, ".", "")).data("valor", totalInit);
                                }
                            }
                        });

                        $target.find("li").children("a, .jstree-grid-cell").unbind("hover").unbind("click");
                        treeNodeEvents($target.find("li").children("a, .jstree-grid-cell"));

                        $target.attr("valor", number_format(total, 3, ".", ",")).trigger("change_node.jstree");
                        $("#btnRemoveSelection, #btnAgregarItems").addClass("disabled");
                        updateTotal(0);
                        $btn.show();
                        spinner.remove();
                        setTimeout(function() {
                            var t = cargarLoader("Cargando...");
                            location.reload();
                        }, 1000);
                    }

                } else {
                    bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Por favor seleccione el nombre del índice antes de agregar ítems." + '</strong>');
                    return false;
                }
            }
            return false;
        });

        $tabla.children("tbody").children("tr").click(function () {
            clickTr($(this));
        });

        $(".modal").draggable({
            handle : ".modal-header"
        });

        $tree.bind("loaded.jstree",
            function (event, data) {
                var $first = $tree.children("ul").first().children("li").eq(1);
                $first.children("a, .jstree-grid-cell").addClass("selected");
                updateCoef($first);
                updateTotal(0);

                treeNodeEvents($("#tree").find("a"));
                treeNodeEvents($(".jstree-grid-cell"));

                $("#rightContents").show();

                updateSumaTotal();
            }).jstree({
            plugins   : ["themes", "json_data", "grid", "types", "contextmenu", "search", "crrm", "cookies", "types" ],
            json_data : {data : <elm:poneHtml textoHtml="${json.toString()}"/>},
            themes    : {
                theme : "apple"
            },
            contextmenu : {
                items : createContextmenu
            },
            types : {
                valid_children : [ "fp", "it"],
                types          : {
                    fp                : {
                        icon : {image: icons.fp}
                    },
                    it : {
                        icon       : {
                            image : icons.it
                        },
                        valid_children : [""]
                    }
                }
            },
            grid  : {
                columns : [
                    {
                        header : "Coef.",
                        value  : "numero",
                        title  : "numero",
                        width  : 80
                    },
                    {
                        header : "Nombre del Indice",
                        value  : "nombre",
                        title  : "nombre",
                        width  : 425
                    },
                    {
                        header : "Valor",
                        value  : "valor",
                        title  : "valor",
                        width  : 90
                    }
                ]
            }
        });

        $("#creaIndice").click(function () {
            if (confirm("¿Crear un nuevo Indice INEC?. \nSe deberá luego solicitar al INEC su calificación.\n" +
                "¿Continuar?")) {
                $.ajax({
                    type    : "POST",
                    url :  "${createLink(action:'creaIndice')}",
                    success : function (msg) {
                        var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                        var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-ok"></i> Guardar</a>');

                        btnSave.click(function () {
                            if ($("#frmSave-Indice").valid()) {
                                btnSave.replaceWith(spinner);
                                $.ajax({
                                    type    : "POST",
                                    url     : "${createLink(controller: 'indice', action:'grabar')}",
                                    data    : $("#frmSave-Indice").serialize(),
                                    success : function (msg) {
                                        if(msg === 'ok'){
                                            $("#modal-indice").modal("hide");
                                        }
                                    }
                                });
                                location.reload();
                            }
                        });
                        $("#modalTitle-Indc").html("Crear Índices   INEC");
                        $("#modalBody-Indc").html(msg);
                        $("#modalFooter-Indc").html("").append(btnOk).append(btnSave);
                        $("#modal-indice").modal("show");
                    }
                });
                return false;
            }
        });
    });
</script>

</body>
</html>