<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Editar precios</title>
</head>
<body>

<div class="row" style="margin-left: 10px">
    <div class="col-md-12">
        <div class="col-md-2 btn-toolbar toolbar" >
            <div class="btn-group">
                <a href="#" class="btn btn-primary btnRegresarAItems" title="Regresar a Items">
                    <i class="fa fa-arrow-left"></i> Regresar
                </a>
            </div>
        </div>
        <div class="col-md-9 breadcrumb">
            <strong style="font-size: 14px;">${item?.codigo + " - "  +  item?.nombre}</strong>
        </div>
    </div>
</div>

<g:if test="${item?.tipoItem?.codigo == 'I'}">
    <div class="row">
        <div class="col-md-12">
            <div class="col-md-2">
            </div>
            <div class="col-md-4">
                <span class="grupo">
                    <span class="col-md-4">
                        <label class="control-label text-info" style="text-align: center">Año</label>
                        <g:select style="font-size:large;" name="anio" class="form-control" from="${anio..anio - 1}" />
                    </span>
                    <span class="col-md-5" id="divFecha" style="text-align: center">

                    </span>
                </span>
                <div class="col-md-1" style="margin-top: 20px">
                    <button class="btn btn-info" id="btnBuscar" title="Buscar"><i class="fa fa-search"></i> Consultar</button>
                </div>
            </div>
            <div class="col-md-1" style="margin-top: 20px">
                <a href="#" class="btn btn-success btnNuevoPrecio" data-id="${item?.id}" title="Nuevo Precio">
                    <i class="fas fa-file"></i> Nuevo Precio
                </a>
            </div>
            <div class="col-md-2 breadcrumb" style="margin-left: 20px; margin-top: 18px; width: 190px">
                <label class="control-label text-info" style="text-align: center">Fecha por defecto:</label>
                ${fd}
            </div>
        </div>
        <div class="col-md-12">
            <div class="col-md-2"></div>
            <div class="col-md-7" id="divTablaPrecios" >
            </div>
        </div>
    </div>

    <script type="text/javascript">

        var np, cepc;

        $(".btnRegresarAItems").click(function () {
            location.href="${createLink(controller: 'mantenimientoItems', action: 'precios')}?r=" + 1
        });

        $("#btnBuscar").click(function () {
            cargarTablaPrecios();
        });

        function cargarTablaPrecios(){
            var fecha = $("#fecha option:selected").val();
            var anio = $("#anio option:selected").val();
            var id = '${item?.id}';
            if(fecha){
                var d = cargarLoader("Cargando...");
                $.ajax({
                    type: 'POST',
                    url: '${createLink(controller: 'mantenimientoItems', action: 'tablaEditarPrecios_ajax')}',
                    data:{
                        id: id,
                        anio: anio,
                        fecha: fecha
                    },
                    success: function (msg){
                        d.modal("hide");
                        $("#divTablaPrecios").html(msg)
                    }
                })
            }else{
                $("#divTablaPrecios").html(' <div class="alert alert-warning" style="text-align: center"><i class="fa fa-exclamation-triangle fa-2x text-info"></i> <strong style="font-size: 16px"> No existen registros </strong></div>')
                bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 16px">' + "Seleccione una fecha" + '</strong>');
            }
        }

        cargarFechas();

        function cargarFechas(fecha){
            var id = '${item?.id}';
            var anio = $("#anio option:selected").val();
            $.ajax({
                type: 'POST',
                url: '${createLink(controller: 'mantenimientoItems', action: 'fechasPrecios_ajax')}',
                data:{
                    id: id,
                    anio: anio,
                    fecha: fecha
                },
                success: function (msg){
                    $("#divFecha").html(msg)
                }
            })
        }

        $("#anio").change(function () {
            cargarFechas();
        });

        $(".btnNuevoPrecio").click(function () {
            // nuevoPrecio();
            createEditPrecioVarios();
        });

        function nuevoPrecio() {
            var fechaAnterior = $("#fecha option:last").val();
            $.ajax({
                type    : "POST",
                url     : "${createLink(controller: 'mantenimientoItems', action:'formNuevoPrecio_ajax')}",
                data    : {
                    item : "${item.id}",
                    fechaDefecto: '${fd}',
                    fechaAnterior: fechaAnterior
                },
                success : function (msg) {
                    np = bootbox.dialog({
                        id    : "dlgNuevoPrecio",
                        title : "Nuevo precio",
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
                                    return submitFormNuevoPrecio();
                                } //callback
                            } //guardar
                        } //buttons
                    }); //dialog
                } //success
            }); //ajax
        } //createEdit

        function submitFormNuevoPrecio() {
            var $form = $("#frmSaveNuevoPrecio");
            if ($form.valid()) {
                var valor = $("#precioUnitario").val();
                if(valor > 0){
                    var data = $form.serialize();
                    var df = cargarLoader("Guardando...");
                    $.ajax({
                        type    : "POST",
                        url     : $form.attr("action"),
                        data    : data,
                        success : function (msg) {
                            df.modal('hide');
                            var parts = msg.split("_");
                            if(parts[0] === 'ok'){
                                log(parts[1], "success");
                                setTimeout(function () {
                                    cargarFechas(parts[2]);
                                },100);
                                setTimeout(function () {
                                    $("#fecha").change(function () {
                                        $(this).val(parts[2])
                                    });
                                    cargarTablaPrecios();
                                },200);
                                cerrarNuevoPrecioxLugar();
                            }else{
                                bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                                return false;
                            }
                        }
                    });
                    return false;
                }else{
                    bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Ingrese un valor diferente de 0" + '</strong>');
                    return false;
                }
            } else {
                return false;
            }
        }

        function cerrarNuevoPrecioxLugar(){
            np.modal("hide");
        }

        function createEditPrecioVarios() {
            $.ajax({
                type    : "POST",
                url     : "${createLink(controller: 'mantenimientoItems',  action:'formPreciosVarios_ajax')}",
                data    : {
                    item        : "${item.id}",
                    fecha: '${fd}'
                },
                success : function (msg) {
                    cepc = bootbox.dialog({
                        id    : "dlgCreateEditP",
                        title : "Nuevo precio",
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
                                    return submitFormPrecioVarios();
                                } //callback
                            } //guardar
                        } //buttons
                    }); //dialog
                } //success
            }); //ajax
        } //createEdit

        function submitFormPrecioVarios() {
            var $form = $("#frmSaveCantones");
            if ($form.valid()) {
                var data = $form.serialize();
                var lugares = chequeados();
                var dialog = cargarLoader("Guardando...");
                $.ajax({
                    type    : "POST",
                    url     : $form.attr("action"),
                    data    : data + "&lugares=" + lugares,
                    success : function (msg) {
                        dialog.modal('hide');
                        var parts = msg.split("_");
                        if(parts[0] === 'ok'){
                            log(parts[1], "success");
                            cargarFechas();
                            cargarTablaPrecios();
                            cerrarEditarPreciosVarios();
                        }else{
                            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                            return false;
                        }
                    }
                });
                return false
            } else {
                return false;
            }
        }

        function cerrarEditarPreciosVarios() {
            cepc.modal("hide");
        }

    </script>

</g:if>
<g:else>
    <div class="row">
        <div class="col-md-12">
            <div class="col-md-2"></div>
            <div class="col-md-9 alert alert-warning" style="text-align: center">
                <i class="fa fa-exclamation-triangle fa-2x text-info"></i> <strong style="font-size: 16px">No es posible modificar un rubro en esta pantalla</strong>
            </div>
        </div>
    </div>

    <script type="text/javascript">

        $(".btnRegresarAItems").click(function () {
            location.href="${createLink(controller: 'mantenimientoItems', action: 'precios')}?r=" + 1
        });
    </script>
</g:else>

</body>
</html>