<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Registro y Mantenimiento de Items</title>


    <style>

    </style>
</head>

<body>

<div>
    <fieldset class="borde" style="border-radius: 4px; margin-bottom: 10px">
        <div class="row-fluid" style="margin-left: 10px">
            <span class="grupo">
                <span class="col-md-2">
                    <label class="control-label text-info">Buscar Por</label>
                    <g:select name="buscarPor" class="buscarPor col-md-12 form-control btn-success" from="${[1: 'Materiales', 2: 'Mano de Obra', 3: 'Equipos']}" optionKey="key"
                              optionValue="value"/>
                </span>
                <span class="col-md-2">
                    <label class="control-label text-info">Tipo</label>
                    <g:select name="tipo" class="tipo col-md-12 form-control btn-info" from="${[1: 'Grupo', 2: 'Subgrupo', 3: 'Materiales']}" optionKey="key"
                              optionValue="value"/>
                </span>
                <span class="col-md-4">
                    <label class="control-label text-info">Criterio</label>
                    <g:textField name="criterio" id="criterio" class="form-control"/>
                </span>
            </span>
            <div class="col-md-2" style="margin-top: 20px">
                <button class="btn btn-info" id="btnBuscar"><i class="fa fa-search"></i>Buscar</button>
                <button class="btn btn-warning" id="btnLimpiar" title="Limpiar Búsqueda"><i class="fa fa-eraser"></i>Limpiar</button>
            </div>
        </div>
    </fieldset>

    <fieldset class="borde" style="border-radius: 4px">
        <div id="divTablaItems" >
        </div>
    </fieldset>
</div>


<script type="text/javascript">

    var dfi;

    $("#btnLimpiar").click(function () {
        $("#buscarPor, #tipo").val(1);
        $("#criterio").val('');
        cargarTablaItems();
    });

    $("#buscarPor, #tipo").change(function () {
        cargarTablaItems();
    });

    $("#btnBuscar").click(function () {
        cargarTablaItems();
    });

    cargarTablaItems();

    function cargarTablaItems(id) {
        var d = cargarLoader("Cargando...");
        var buscarPor = $("#buscarPor option:selected").val();
        var tipo = $("#tipo option:selected").val();
        var criterio = $("#criterio").val();
        var url = '';

        switch (tipo) {
            case "1":
                url = '${createLink(controller: 'mantenimientoItems', action: 'tablaGrupos_ajax')}';
                break;
            case "2":
                url = '${createLink(controller: 'mantenimientoItems', action: 'tablaSubgrupos_ajax')}';
                break;
            case "3":
                url = '${createLink(controller: 'mantenimientoItems', action: 'tablaMateriales_ajax')}';
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
                $("#divTablaItems").html(msg)
            }
        })
    }

    function createEditItem(id, parentId) {
        var title = id ? "Editar" : "Crear";
        var data = id ? {id : id} : {};
        data.departamento = parentId;
        $.ajax({
            type    : "POST",
            url     : "${createLink( action:'formIt_ajax')}",
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
                        cerrarFormItem();
                        $("#tipo").val(3);
                        cargarTablaItems(parts[2]);
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

    function cerrarFormItem(){
        dfi.modal("hide");
    }

    $("#criterio").keydown(function (ev) {
        if (ev.keyCode === 13) {
            cargarTablaItems();
            return false;
        }
        return true;
    });

</script>

</body>
</html>