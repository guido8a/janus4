
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Costos
    </title>
</head>
<body>

<div class="row" style="margin-bottom: 1px">
    <div class="col-md-1 btn-group" role="navigation">
        <a href="#" class="btn btn-primary" id="btnRegresar">
            <i class="fa fa-arrow-left"></i>
            Regresar
        </a>
    </div>

    <div class="col-md-10 breadcrumb" style="font-weight: bold; font-size: 16px">
        Obra: ${" (" + obra.codigo + ") - " + obra.nombre}
    </div>

</div>

<div id="busqueda" style="overflow: hidden">
    <fieldset class="borde" style="border-radius: 4px">

        <div class="row-fluid">
            <div class="col-md-12">
                <div class="col-md-1"> <label> Tipo de costo: </label> </div>
                <div class="col-md-4">
                    <g:select name="tipoName" id="tipo" class="form-control btn-success" from="${datos}"
                              optionKey="${{it.cstonmro}}" optionValue="${{it.cstodscr}}" />
                </div>

%{--                <div class="col-md-2"> <label> Subpresupuesto de la obra</label> </div>--}%
%{--                <div class="col-md-6" id="divSubpresupuesto">--}%

%{--                </div>--}%
            </div>
        </div>

%{--        <div class="row-fluid" style="margin-top: 50px !important;">--}%
%{--            <div class="col-md-12">--}%
%{--                <div class="col-md-1"> <label> Buscar Por </label> </div>--}%
%{--                <div class="col-md-2">--}%
%{--                    <g:select name="buscarPor" class="buscarPor form-control" from="${[1: 'Nombre', 2: 'Código']}"--}%
%{--                              optionKey="key" optionValue="value"/>--}%
%{--                </div>--}%
%{--                <div class="col-md-1"> <label> Criterio </label> </div>--}%
%{--                <div class="col-md-3">--}%
%{--                    <g:textField name="criterio" class="criterio form-control"/>--}%
%{--                </div>--}%
%{--                <div class="col-md-1"> <label> Ordenado por </label> </div>--}%
%{--                <div class="col-md-2">--}%
%{--                    <g:select name="ordenar" class="ordenar form-control" from="${[1: 'Nombre', 2: 'Código']}"  optionKey="key"--}%
%{--                              optionValue="value"/>--}%
%{--                </div>--}%
%{--                <div class="col-md-2 btn-group">--}%
%{--                    <button class="btn btn-info" id="btnBuscar"><i class="fa fa-search"></i></button>--}%
%{--                    <button class="btn btn-warning" id="btnLimpiar" title="Limpiar Búsqueda">--}%
%{--                        <i class="fa fa-eraser"></i></button>--}%
%{--                </div>--}%
%{--            </div>--}%
%{--        </div>--}%
    </fieldset>

    <fieldset class="borde col-md-12">
        <div class="col-md-7" id="divTablaBusquedaCostos">
        </div>

        <div class="col-md-5">
            <div class="alert alert-info" style="margin-top: 10px; text-align: center">
                <i class="fa fa-list"></i> <strong style="font-size: 16px"> Costos seleccionados</strong>
            </div>

%{--            <div class="row-fluid">--}%
%{--                <div class="col-md-12">--}%
%{--                    <div class="col-md-3"> <label> Ver rubros del Subpresupuesto </label> </div>--}%
%{--                    <div class="col-md-9" id="divSubpresupuestoSeleccionado">--}%

%{--                    </div>--}%
%{--                </div>--}%
%{--            </div>--}%

            <div class="col-md-12" id="divTablaCostosSeleccionados" >

            </div>
        </div>


    </fieldset>
</div>

<script type="text/javascript">
    var di;

    $("#btnRegresar").click(function () {
        location.href="${createLink(controller: 'volumenObra', action: 'costos')}/${obra?.id}"
    });

    $("#tipo").change(function () {
        cargarTablaBusquedaCostos();
    });

    $("#btnBuscar").click(function () {
        cargarTablaBusquedaCostos();
    });

    cargarTablaBusquedaCostos();
    cargarTablaCostosSeleccionados();

    function cargarTablaBusquedaCostos() {
        var d = cargarLoader("Cargando...");
        var tipo = $("#tipo option:selected").val();

        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'volumenObra', action:'tablaBusquedaCostos_ajax')}",
            data: {
                tipo: tipo,
                obra: '${obra?.id}'
            },
            success: function (msg) {
                d.modal("hide");
                $("#divTablaBusquedaCostos").html(msg);
            }
        });
    }

    function cargarTablaCostosSeleccionados() {
        var d = cargarLoader("Cargando...");
        var subpresupuesto = $("#subpresupuestoSeleccionado option:selected").val();
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'volumenObra', action:'tablaCostosSeleccionados_ajax')}",
            data: {
                tipo: '',
                obra: '${obra?.id}'
            },
            success: function (msg) {
                d.modal("hide");
                $("#divTablaCostosSeleccionados").html(msg);
            }
        });
    }

    $(".btnBorrarCosto").click(function () {
        var id = $(this).data("id");
        borrarCosto(id);
    });

    function formCosto(id, costo){
        $.ajax({
            type    : "POST",
            url: "${createLink(controller: 'volumenObra', action:'formCosto_ajax')}",
            data    : {
                id: id,
                costo: costo,
                obra: '${obra?.id}'
            },
            success : function (msg) {
                var er = bootbox.dialog({
                    id      : "dlgCreateEditCosto",
                    title   : "Costo",
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
            } //success
        }); //ajax
    }

    function submitFormCosto() {
        var $form = $("#frmCosto");
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
                        cargarTablaBusquedaCostos();
                        cargarTablaCostosSeleccionados();
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


    function borrarCosto(id){
        bootbox.confirm({
            title: "Eliminar",
            message: "<i class='fa fa-exclamation-triangle text-info fa-3x'></i> <strong style='font-size: 14px'> Está seguro de eliminar este costo?</strong> ",
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
                        url : "${g.createLink(controller: 'volumenObra',action:'deleteCosto_ajax')}",
                        data     : {
                            id: id
                        },
                        success  : function (msg) {
                            d.modal("hide");
                            var parts = msg.split("_");
                            if(parts[0] === "ok"){
                                log(parts[1], "success");
                                cargarTablaBusquedaCostos();
                                cargarTablaCostosSeleccionados();
                            }else{
                                bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] +'</strong>');
                            }
                        }
                    });
                }
            }
        });
    }

</script>

</body>
</html>
