
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Lista de Rubros
    </title>
</head>
<body>

<div class="row" style="margin-bottom: 10px">
    <div class="span9 btn-group" role="navigation">
        <a href="#" class="btn btn-primary" id="btnRegresarPrincipal">
            <i class="fa fa-arrow-left"></i>
            Regresar
        </a>
    </div>
</div>


%{--<div style="overflow: hidden">--}%
%{--    <fieldset class="borde" style="border-radius: 4px; margin-bottom: 10px">--}%
%{--        <div class="row-fluid" style="margin-left: 10px">--}%
%{--            <span class="grupo">--}%
%{--                <span class="col-md-2">--}%
%{--                    <label class="control-label text-info">Buscar Por</label>--}%
%{--                    <g:select name="buscarPor" class="buscarPor col-md-12 form-control" from="${[1: 'RUC', 2: 'Nombre']}" optionKey="key"--}%
%{--                              optionValue="value"/>--}%
%{--                </span>--}%
%{--                <span class="col-md-2">--}%
%{--                    <label class="control-label text-info">Criterio</label>--}%
%{--                    <g:textField name="criterio" id="criterio" class="form-control"/>--}%
%{--                </span>--}%
%{--            </span>--}%
%{--            <div class="col-md-1" style="margin-top: 20px">--}%
%{--                <button class="btn btn-info" id="btnBuscarEmpresa"><i class="fa fa-search"></i></button>--}%
%{--            </div>--}%
%{--            <div class="col-md-1" style="margin-top: 20px">--}%
%{--                <button class="btn btn-warning" id="btnLimpiar" title="Limpiar Búsqueda"><i class="fa fa-eraser"></i></button>--}%
%{--            </div>--}%
%{--        </div>--}%
%{--    </fieldset>--}%

%{--    <fieldset class="borde" style="border-radius: 4px">--}%
%{--        <div id="divTablaEmpresas" >--}%
%{--        </div>--}%
%{--    </fieldset>--}%
%{--</div>--}%

<div id="busqueda" style="overflow: hidden">
    <fieldset class="borde" style="border-radius: 4px">
        <div class="row-fluid">
            <div class="col-md-2">
                Grupo
                <g:select name="buscarGrupo_name" id="buscarGrupo" from="['1': 'Materiales', '2': 'Mano de Obra', '3': 'Equipos']" optionKey="key" optionValue="value" class="form-control" />
            </div>

            <div class="col-md-2">
                Buscar Por
                <g:select name="buscarPor" class="buscarPor form-control" from="${[1: 'Nombre', 2: 'Código']}" style="width: 100%" optionKey="key" optionValue="value"/>
            </div>

            <div class="col-md-2">
                Criterio
                <g:textField name="criterio" class="criterio form-control"/>
            </div>

            <div class="col-md-2">
                Ordenado por
                <g:select name="ordenar" class="ordenar form-control" from="${[1: 'Nombre', 2: 'Código']}"   style="width: 100%" optionKey="key"
                          optionValue="value"/>
            </div>
            <div class="col-md-2 btn-group" style="margin-top: 20px">
                <button class="btn btn-info" id="btnBuscar"><i class="fa fa-search"></i></button>
                <button class="btn btn-warning" id="btnLimpiar" title="Limpiar Búsqueda"><i class="fa fa-eraser"></i></button>
            </div>
            %{--            <div class="col-md-1" style="margin-top: 20px">--}%
            %{--             --}%
            %{--            </div>--}%
        </div>
    </fieldset>

    <fieldset class="borde col-md-12">
        <div class="col-md-7" id="divTabla">
        </div>
        <div class="col-md-5" id="divTablaSeleccionados" >
        </div>
    </fieldset>

</div>


<script type="text/javascript">
    var di;


    $("#btnRegresarPrincipal").click(function () {
        location.href="${createLink(controller: 'rubro', action: 'rubroPrincipal')}/${rubro?.id}"
    });

    $("#btnBuscar").click(function () {
        cargarTablaBusqueda();
    });

    // $(".btnNuevaEmpresa").click(function () {
    //     createEditRow();
    // });
    //
    $("#btnLimpiar").click(function  () {
        $("#buscarGrupo").val(1);
        $("#buscarPor").val(1);
        $("#criterio").val('');
        $("#ordenar").val(1);
        cargarTablaBusqueda();
    });
    //
    // $("#btnBuscarEmpresa").click(function () {
    //     cargarTablaBusqueda();
    // });

    $("#criterio").keydown(function (ev) {
        if (ev.keyCode === 13) {
            cargarTablaBusqueda();
            return false;
        }
        return true;
    });

    cargarTablaBusqueda();
    cargarTablaSeleccionados();

    function cargarTablaBusqueda() {
        var d = cargarLoader("Cargando...");
        var grupo = $("#buscarGrupo option:selected").val();
        var buscarPor = $("#buscarPor option:selected").val();
        var criterio = $(".criterio").val();
        var ordenar = $("#ordenar option:selected").val();

        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'rubro', action:'tablaBusqueda_ajax')}",
            data: {
                buscarPor: buscarPor,
                criterio: criterio,
                ordenar: ordenar,
                grupo: grupo,
                rubro: '${rubro?.id}'
            },
            success: function (msg) {
                d.modal("hide");
                $("#divTabla").html(msg);
            }
        });
    }

    function cargarTablaSeleccionados() {
        var d = cargarLoader("Cargando...");
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'rubro', action:'tablaSeleccionados_ajax')}",
            data: {
                id: '${rubro?.id}'
            },
            success: function (msg) {
                d.modal("hide");
                $("#divTablaSeleccionados").html(msg);
            }
        });
    }

    function createEditRow(id) {
        var title = id ? "Editar " : "Crear ";
        var data = id ? {id : id}: {};

        $.ajax({
            type    : "POST",
            url: "${createLink(action:'form_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : title + " Consultorio",
                    class: "modal-lg",
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
                                return submitFormEmpresa();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    } //createEdit


    function deleteRow(itemId) {
        bootbox.dialog({
            title   : "Alerta",
            message : "<i class='fa fa-trash fa-2x pull-left text-danger text-shadow'></i><p style='font-weight: bold'> Está seguro que desea eliminar esta empresa? Esta acción no se puede deshacer.</p>",
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
                        var v = cargarLoader("Eliminando...");
                        $.ajax({
                            type    : "POST",
                            url     : '${createLink(action:'borrarEmpresa_ajax')}',
                            data    : {
                                id : itemId
                            },
                            success : function (msg) {
                                v.modal("hide");
                                var parts = msg.split("_");
                                if(parts[0] === 'ok'){
                                    log(parts[1],"success");
                                    cargarTablaEmpresa();
                                }else{
                                    log(parts[1],"error")
                                }
                            }
                        });
                    }
                }
            }
        });
    }


    function cerrarDialogoImagen () {
        di.modal("hide");
    }
</script>

</body>
</html>
