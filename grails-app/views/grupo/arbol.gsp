<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Grupo de rubros</title>
</head>

<body>

<div>
    <fieldset class="borde" style="border-radius: 4px; margin-bottom: 10px">
        <div class="row-fluid" style="margin-left: 10px">
            <span class="grupo">

                <span class="col-md-1" style="margin-top: 20px">
                    <button class="btn btn-success btnEditarSolicitante" title="Editar solicitante"><i class="fa fa-edit"></i> </button>
                </span>

                <span class="col-md-2">
                    <label class="control-label text-info">Buscar Por</label>
                    %{--                    <g:select name="buscarPor" class="buscarPor col-md-12 form-control btn-success" from="${solicitantes}" optionKey="id"--}%
                    %{--                              optionValue="descripcion" att="descripcion" onchange="jsFunction(this)" />--}%

                    <g:select name="buscarPor" class="buscarPor col-md-12 form-control btn-success" from="${solicitantes}" optionKey="id"
                              optionValue="descripcion" att="descripcion" />
                </span>

                <span class="col-md-2">
                    <label class="control-label text-info">Tipo</label>
                    <g:select name="tipo" class="tipo col-md-12 form-control btn-info" from="${[1: 'Grupo', 2: 'Subgrupo', 3: 'Rubros']}" optionKey="key"
                              optionValue="value"/>
                </span>
                <span class="col-md-3">
                    <label class="control-label text-info">Criterio</label>
                    <g:textField name="criterio" id="criterio" class="form-control"/>
                </span>
            </span>

            <div class="col-md-2" style="margin-top: 20px">
                <button class="btn btn-info" id="btnBuscar"><i class="fa fa-search"></i>Buscar</button>
                <button class="btn btn-warning" id="btnLimpiar" title="Limpiar Búsqueda"><i class="fa fa-eraser"></i>Limpiar</button>
            </div>

            <span class="col-md-2" style="margin-top: 20px">
                <button class="btn btn-primary btnImprimirPrincipal" title="Imprimir rubros del grupo"><i class="fa fa-print"></i> Imprimir rubros <strong class="pNombre"></strong>  </button>
            </span>

        </div>
    </fieldset>

    <fieldset class="borde" style="border-radius: 4px;">
        <div id="divTablaGrupoRubros" >
        </div>
    </fieldset>
</div>


<script type="text/javascript">

    var dfi, cfs;

    colocarNombre();

    $(".buscarPor").change(function () {
        colocarNombre();
    });

    function colocarNombre(){
        var n = $(".buscarPor option:selected").text();
        $(".pNombre").html(n)
    }

    $(".btnEditarSolicitante").click(function () {
        editarSolicitante();
    });

    $("#btnLimpiar").click(function () {
        $("#buscarPor").val(5);
        $("#tipo").val(1);
        $("#criterio").val('');
        cargarTablaGrupoRubros();
    });

    $("#buscarPor, #tipo").change(function () {
        cargarTablaGrupoRubros();
    });

    $("#btnBuscar").click(function () {
        cargarTablaGrupoRubros();
    });

    cargarTablaGrupoRubros();

    function cargarTablaGrupoRubros(id) {
        var d = cargarLoader("Cargando...");
        var buscarPor = $("#buscarPor option:selected").val();
        var tipo = $("#tipo option:selected").val();
        var criterio = $("#criterio").val();
        var url = '';

        switch (tipo) {
            case "1":
                url = '${createLink(controller: 'grupo', action: 'tablaGrupos_ajax')}';
                break;
            case "2":
                url = '${createLink(controller: 'grupo', action: 'tablaSubgrupos_ajax')}';
                break;
            case "3":
                url = '${createLink(controller: 'grupo', action: 'tablaRubros_ajax')}';
                break;
        }

        $.ajax({
            type: 'POST',
            url: url,
            data:{
                buscarPor: buscarPor,
                tipo: tipo,
                criterio: criterio,
                id: id
            },
            success: function (msg){
                d.modal("hide");
                $("#divTablaGrupoRubros").html(msg)
            }
        })
    }

    function createEditItem(id, parentId) {
        var title = id ? "Editar" : "Crear";
        var data = id ? {id : id} : {};
        data.departamento = parentId;
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'mantenimientoItems', action:'formIt_ajax')}",
            data    : data,
            success : function (msg) {
                dfi= bootbox.dialog({
                    id    : "dlgCreateEditIT",
                    title : title + " item",
                    class : "modal-lg",
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
                                return submitFormItem();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    } //createEdit

    function submitFormItem() {
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
                        cerrarFormGP();
                        $("#tipo").val(3);
                        cargarTablaGrupoRubros(parts[2]);
                    }else{
                        bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                        return false;
                    }
                }
            });
            return false;
        } else {
            return false;
        }
    }

    function cerrarFormGP(){
        dfi.modal("hide");
    }

    $("#criterio").keydown(function (ev) {
        if (ev.keyCode === 13) {
            cargarTablaGrupoRubros();
            return false;
        }
        return true;
    });

    function imprimirRubrosGrupo(id, tipo) {
        $.ajax({
            type    : "POST",
            url: "${createLink(action:'imprimirRubros_ajax')}",
            data    : {
                id: id,
                tipo: tipo
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgImprimir",
                    title   : "Variables de transporte para el grupo",
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
    } //createEdit

    $(".btnImprimirPrincipal").click(function () {
        var id = $("#buscarPor option:selected").val();
        imprimirRubrosGrupo(id, 'gr')
    });

    function editarSolicitante() {
        var id = $("#buscarPor option:selected").val();
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'grupo', action:'formGr_ajax')}",
            data    : {
                id: id
            },
            success : function (msg) {
                cfs = bootbox.dialog({
                    id    : "dlgEditSolicitante",
                    title : "Editar solicitante",
                    class : "modal-lg",
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
                                return submitFormSolicitante();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    } //createEdit

    function submitFormSolicitante() {
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
                        cerrarFormSol();
                        setTimeout(function () {
                            location.reload()
                        }, 1000);
                    }else{
                        bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                        return false;
                    }
                }
            });
            return false;
        } else {
            return false;
        }
    }

    function cerrarFormSol(){
        cfs.modal("hide");
    }

</script>

</body>
</html>