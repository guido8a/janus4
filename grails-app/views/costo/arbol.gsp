<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 22/01/15
  Time: 03:51 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Cuentas presupuestarias</title>
        <asset:javascript src="/jstree-3.0.8/dist/jstree.min.js"/>
        <asset:stylesheet src="/jstree-3.0.8/dist/themes/default/style.min.css"/>
        <asset:stylesheet src="/apli/jstree-context.css"/>

        <style type="text/css">
        #tree {
            overflow-y : auto;
            height     : 440px;
        }

        .jstree-search {
            color : #5F87B2 !important;
        }
        </style>

    </head>

    <body>

    <div id="cargando" class="text-center">
        <p>Cargando...</p>

        <img src="${resource(dir: 'images', file: 'spinner.gif')}" alt='Cargando...' width="64px" height="64px"/>

        <p>Por favor espere</p>
    </div>


    <div class="row" style="margin-bottom: 10px;">
        <div class="btn-group">
            <g:link controller="inicio" action="parametros" class="btn btn-default">
                <i class="fa fa-arrow-left"></i> Regresar
            </g:link>

            <div class="col-md-4">
                <div class="input-group input-group-sm">
                    <g:textField name="searchArbol" class="form-control input-sm" placeholder="Buscador"/>
                    <span class="input-group-btn">
                        <a href="#" id="btnSearchArbol" class="btn btn-sm btn-info">
                            <i class="fa fa-search"></i>&nbsp;
                        </a>
                    </span>
                </div><!-- /input-group -->
            </div>

            <div class="col-md-3 hidden" id="divSearchRes">
                <span id="spanSearchRes">
                    5 resultados
                </span>

                <div class="btn-group">
                    <a href="#" class="btn btn-xs btn-default" id="btnNextSearch" title="Siguiente">
                        <i class="fa fa-chevron-down"></i>&nbsp;
                    </a>
                    <a href="#" class="btn btn-xs btn-default" id="btnPrevSearch" title="Anterior">
                        <i class="fa fa-chevron-up"></i>&nbsp;
                    </a>
                    <a href="#" class="btn btn-xs btn-default" id="btnClearSearch" title="Limpiar búsqueda">
                        <i class="fa fa-close"></i>&nbsp;
                    </a>
                </div>
            </div>

            <div class="col-md-1">
                <div class="btn-group">
                    <a href="#" class="btn btn-xs btn-default" id="btnCollapseAll" title="Cerrar todos los nodos">
                        <i class="fas fa-folder"></i> Cerrar todos las cuentas
                    </a>
                </div>
            </div>
        </div>
    </div>
        <div class="col-md-8">
            <div id="tree" class="well" style="height: 600px;">
                <elm:poneHtml textoHtml="${arbol}"/>
            </div>
        </div>

        <div class="col-md-4">
            <div id="precios" class="well" style="height: 600px; float: right">
                <table class="table table-bordered table-striped table-condensed table-hover">
                    <thead>
                    <tr>
                        <th style="width: 140px;">
                            Fecha
                        </th>
                        <th style="width: 200px;">
                            Precio
                        </th>
                    </tr>
                    </thead>
                </table>
                    <div id="tabla_prcs">
                    </div>
            </div>
        </div>

        <script type="text/javascript">
            var searchRes = [];
            var posSearchShow = 0;
            var $treeContainer = $("#tree");

            function submitFormCosto() {
                var $form = $("#frmCosto");
                var $btn = $("#dlgCreateEditPresupuesto").find("#btnSave");
                if ($form.valid()) {
                    $btn.replaceWith(spinner);
                    openLoader("Guardando Presupuesto");
                    $.ajax({
                        type    : "POST",
                        url     : $form.attr("action"),
                        data    : $form.serialize(),
                        success : function (msg) {
                            var parts = msg.split("*");
                            log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                            setTimeout(function () {
                                if (parts[0] == "SUCCESS") {
                                    location.reload(true);
                                } else {
                                    spinner.replaceWith($btn);
                                    return false;
                                }
                            }, 1000);
                        }
                    });
                } else {
                    return false;
                } //else
            }
            function deletePresupuesto(itemId) {
                bootbox.dialog({
                    title   : "Eliminar el Registro",
                    message : "<i class='fa fa-trash fa-3x pull-left text-danger text-shadow'> </i><p style='margin-left: 40px'>¿Está seguro " +
                        "que desea eliminar el Presupuesto seleccionado?<br/>Esta acción no se puede deshacer.</p>",
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        eliminar : {
                            label     : "<i class='fa fa-trash'></i> Eliminar",
                            className : "btn-danger",
                            callback  : function () {
                                openLoader("Eliminando Presupuesto");
                                $.ajax({
                                    type    : "POST",
                                    url     : '${createLink(controller: 'costo', action:'delete_ajax')}',
                                    data    : {
                                        id : itemId
                                    },
                                    success : function (msg) {
                                        var parts = msg.split("*");
                                        log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                                        if (parts[0] == "SUCCESS") {
                                            setTimeout(function () {
                                                location.reload(true);
                                            }, 1000);
                                        } else {
                                            closeLoader();
                                        }
                                    },
                                    error   : function () {
                                        log("Ha ocurrido un error interno", "error");
                                    }
                                });
                            }
                        }
                    }
                });
            }

            function createEditPresupuesto(padreId, id) {
                var title = id ? "Editar" : "Crear";
                var data = id ? {id : id} : {};
                if (padreId) {
                    data.padre = padreId;
                }
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(controller: 'costo', action:'form_ajax')}",
                    data    : data,
                    success : function (msg) {
                        var b = bootbox.dialog({
                            id    : "dlgCreateEditPresupuesto",
                            title : title + " Presupuesto",

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
                                        return submitFormCosto();
                                    } //callback
                                } //guardar
                            } //buttons
                        }); //dialog
                        setTimeout(function () {
                            b.find(".form-control").first().focus()
                        }, 500);
                    } //success
                }); //ajax
            } //createEdit

            function createEditPrecio(padreId, id) {
                var title = id ? "Editar" : "Crear";
                var data = id ? {id : id} : {};
                if (padreId) {
                    data.padre = padreId;
                }
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(controller: 'costo', action:'precio_ajax')}",
                    data    : {
                        id: id,
                        padre: padreId
                    },
                    success : function (msg) {
                        var b = bootbox.dialog({
                            id    : "dlgCreateEditPresupuesto",
                            title : title + " Presupuesto",

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
                                        return submitFormPrecio();
                                    } //callback
                                } //guardar
                            } //buttons
                        }); //dialog
                        setTimeout(function () {
                            b.find(".form-control").first().focus()
                        }, 500);
                    } //success
                }); //ajax
            } //createEdit

            function cargaPrecios(id) {
                console.log('nodo:', id);
                var data = id ? {id : id} : {};
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(controller: 'costo', action:'tablaPrecio_ajax')}",
                    data    : data,
                    success : function (msg) {
                        $("#tabla_prcs").html(msg)
                    } //success
                }); //ajax
            } //createEdit

            function createContextMenu(node) {
                $(".lzm-dropdown-menu").hide();

                var nodeStrId = node.id;
                var $node = $("#" + nodeStrId);
                var nodeId = nodeStrId.split("_")[1];
                var nodeType = $node.data("jstree").type;

                var nodeText = $node.children("a").first().text();

//                var $parent = $node.parent().parent();
//                var parentStrId = $parent.attr("id");
//                var parentId = parentStrId.split("_")[1];
//                var tienePadre = parentId !== undefined;

                var esRoot = nodeType == "root";
                var esPadre = nodeType == "padre";
                var esHijo = nodeType == "hijo";

                var items = {};

                var crearHijo = {
                    label           : "Crear Hijo",
                    icon            : "far fa-edit text-success",
                    separator_after : true,
                    action          : function () {
                        createEditPresupuesto(nodeId);
                    }
                };
                var editar = {
                    label           : "Editar",
                    icon            : "fa fa-pen text-info",
                    separator_after : true,
                    action          : function () {
                        createEditPresupuesto(null, nodeId);
                    }
                };
                var eliminar = {
                    label           : "Eliminar",
                    icon            : "fa fa-trash text-danger",
                    separator_after : true,
                    action          : function () {
                        deletePresupuesto(nodeId);
                    }
                };

                var precio = {
                    label           : "Precio Unitario",
                    icon            : "fa fa-edit text-info",
                    separator_after : true,
                    action          : function () {
                        createEditPrecio(nodeId);
                    }
                };

                items.crearHijo = crearHijo;
                if (esPadre || esHijo) {
                    items.editar = editar;
                }
                if (esHijo) {
                    items.eliminar = eliminar;
                    items.precio   = precio;
                }
                return items;
            }

            function scrollToNode($scrollTo) {
                $treeContainer.jstree("deselect_all").jstree("select_node", $scrollTo).animate({
                    scrollTop : $scrollTo.offset().top - $treeContainer.offset().top + $treeContainer.scrollTop() - 50
                });
            }

            function scrollToRoot() {
                var $scrollTo = $("#root");
                scrollToNode($scrollTo);
            }

            function scrollToSearchRes() {
                var $scrollTo = $(searchRes[posSearchShow]).parents("li").first();
                $("#spanSearchRes").text("Resultado " + (posSearchShow + 1) + " de " + searchRes.length);
                scrollToNode($scrollTo);
            }

            $(function () {

                $treeContainer.on("loaded.jstree", function () {
                    $("#cargando").hide();
                    $("#tree").removeClass("hidden");
                }).on("select_node.jstree", function (node, selected, event) {
                }).jstree({
                    plugins     : ["types", "state", "contextmenu", "search"],
                    core        : {
                        multiple       : false,
                        check_callback : true,
                        themes         : {
                            variant : "small",
                            dots    : true,
                            stripes : true
                        }
                    },
                    contextmenu : {
                        show_at_node : false,
                        items        : createContextMenu
                    },
                    state       : {
                        key : "presupuesto"
                    },
                    search      : {
                        fuzzy             : false,
                        show_only_matches : false,
                        ajax              : {
                            url     : "${createLink(controller: 'costo', action:'arbolSearch_ajax')}",
                            success : function (msg) {
                                var json = $.parseJSON(msg);
                                $.each(json, function (i, obj) {
                                    $('#tree').jstree("open_node", obj);
                                });
                                setTimeout(function () {
                                    searchRes = $(".jstree-search");
                                    var cantRes = searchRes.length;
                                    posSearchShow = 0;
                                    $("#divSearchRes").removeClass("hidden");
                                    $("#spanSearchRes").text("Resultado " + (posSearchShow + 1) + " de " + cantRes);
                                    scrollToSearchRes();
                                }, 300);

                            }
                        }
                    },
                    types       : {
                        root  : {
                            icon : "fa fa-folder text-warning"
                        },
                        padre : {
                            icon : "far fa-folder text-info"
                        },
                        hijo  : {
                            icon : "fas fa-minus text-success"
                        }
                    },
                }).bind("select_node.jstree", function (node, selected) {
                    cargaPrecios(selected.node.id.split('_')[1]);
//                    console.log('xxxxxx', selected.node.text);
                    console.log('xxxxxx', selected.node.id, selected.node.id.split('_')[1] );
                });

                $("#btnExpandAll").click(function () {
                    $treeContainer.jstree("open_all");
                    scrollToRoot();
                    return false;
                });

                $("#btnCollapseAll").click(function () {
                    $treeContainer.jstree("close_all");
                    scrollToRoot();
                    return false;
                });

                $('#btnSearchArbol').click(function () {
                    $treeContainer.jstree("open_all");
                    $treeContainer.jstree(true).search($.trim($("#searchArbol").val()));
                    return false;
                });
                $("#searchArbol").keypress(function (ev) {
                    if (ev.keyCode == 13) {
                        $treeContainer.jstree("open_all");
                        $treeContainer.jstree(true).search($.trim($("#searchArbol").val()));
                        return false;
                    }
                });

                $("#btnPrevSearch").click(function () {
                    if (posSearchShow > 0) {
                        posSearchShow--;
                    } else {
                        posSearchShow = searchRes.length - 1;
                    }
                    scrollToSearchRes();
                    return false;
                });

                $("#btnNextSearch").click(function () {
                    if (posSearchShow < searchRes.length - 1) {
                        posSearchShow++;
                    } else {
                        posSearchShow = 0;
                    }
                    scrollToSearchRes();
                    return false;
                });

                $("#btnClearSearch").click(function () {
                    $treeContainer.jstree("clear_search");
                    $("#searchArbol").val("");
                    posSearchShow = 0;
                    searchRes = [];
                    scrollToRoot();
                    $("#divSearchRes").addClass("hidden");
                    $("#spanSearchRes").text("");
                });

            });
        </script>

    </body>
</html>