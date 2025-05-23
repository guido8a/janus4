
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Emparejar rubros
    </title>
</head>
<body>

<div id="busqueda" style="overflow: hidden">
    <fieldset class="borde" style="border-radius: 4px">
        <h3 style="margin-top: -5px; text-align: center">Emparejar los rubros del oferente con los del sistema</h3>
        <div class="row-fluid">
            <div class="col-md-1 btn-group" role="navigation">
                <a href="#" class="btn btn-primary" id="btnRegresarPrincipal">
                    <i class="fa fa-arrow-left"></i>
                    Regresar
                </a>
            </div>

            <div id="list-grupo" class="col-md-9" role="main" style="margin-top: 0px;margin-left: -25px">
                <div class="col-md-12">
                    <div class="col-md-1">
                        <b>Obra Ofertada:</b>
                    </div>
                    <div class="col-md-11">
                        <g:select name="obra" class="form-control"
                                  from="${obras}" optionKey="key" optionValue="value"
                                  style="width: 100%;"/>
                    </div>
                </div>
            </div>
            <div id="list-grupo" class="col-md-2" role="main" style="margin-top: 0px;margin-left: -35px">
                <div class="col-md-9 btn-group" >
                    <button class="btn btn-success" id="btnEmparejaNmbr" title="Limpiar Búsqueda">
                        <i class="fa fa-edit"></i>Emp. por Nombre</button>
                </div>
                <div class="col-md-3 btn-group" role="navigation" style="margin-left: 0px">
                    <a href="#" class="btn btn-primary" id="btnSiguiente">
                        Continuar
                        <i class="fa fa-arrow-right"></i>
                    </a>
                </div>
            </div>


            %{--            <div class="col-md-2">--}%
%{--                Grupo--}%
%{--                <g:select name="buscarGrupo_name" id="buscarGrupo" from="['MT': 'Materiales', 'MO': 'Mano de Obra', 'EQ': 'Equipos']" optionKey="key" optionValue="value" class="form-control" />--}%
%{--            </div>--}%
%{--            <div class="col-md-2">--}%
%{--                Buscar Por--}%
%{--                <g:select name="buscarPor" class="buscarPor form-control" from="${[1: 'Nombre', 2: 'Código']}" style="width: 100%" optionKey="key" optionValue="value"/>--}%
%{--            </div>--}%
%{--            <div class="col-md-4">--}%
%{--                Criterio--}%
%{--                <g:textField name="criterio" class="criterio form-control"/>--}%
%{--            </div>--}%
%{--            <div class="col-md-2 btn-group" style="margin-top: 20px">--}%
%{--                <button class="btn btn-info" id="btnBuscar"><i class="fa fa-search"></i></button>--}%
%{--                <button class="btn btn-warning" id="btnLimpiar" title="Limpiar Búsqueda"><i class="fa fa-eraser"></i></button>--}%
%{--            </div>--}%
        </div>
    </fieldset>

    <fieldset class="borde">
        <div id="divTablaBusquedaRubros">
        </div>
    </fieldset>
</div>

<div class="col-md-12" id="divTablaEmpatadosRubros" style="margin-top: 10px">

</div>


<script type="text/javascript">
    var di;

    $("#btnRegresarPrincipal").click(function () {
        %{--<g:if test="${tipo == '1'}">--}%
        location.href = "${createLink(controller: 'rubroOf', action: 'index')}";
        %{--</g:if>--}%
        %{--<g:else>--}%
        %{--location.href="${createLink(controller: 'rubroOf', action: 'rubroPrincipalOf')}";--}%
        %{--</g:else>--}%
    });

    $("#btnSiguiente").click(function () {
        location.href = "${createLink(controller: 'rubroOf', action: 'subirExcelApu')}";
    });

    // $("#buscarGrupo").change(function () {
    //     cargarTablaBusquedaRubros();
    // });

    // $("#btnBuscar").click(function () {
    //     cargarTablaBusquedaRubros();
    // });

    // $("#btnLimpiar").click(function  () {
    //     $("#buscarGrupo").val('MT');
    //     $("#buscarPor").val(1);
    //     $("#criterio").val('');
    //     $("#ordenar").val(1);
    //     cargarTablaBusquedaRubros();
    // });

    // $("#criterio").keydown(function (ev) {
    //     if (ev.keyCode === 13) {
    //         cargarTablaBusquedaRubros();
    //         return false;
    //     }
    //     return true;
    // });

    cargarTablaBusquedaRubros();
    cargarTablaEmpatadosRubros();

    function cargarTablaBusquedaRubros() {
        var d = cargarLoader("Cargando...");
        // var grupo = $("#buscarGrupo option:selected").val();
        // var buscarPor = $("#buscarPor option:selected").val();
        // var criterio = $(".criterio").val();
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'rubroOf', action:'tablaBusquedaRubros_ajax')}",
            data: {
                // buscarPor: buscarPor,
                // criterio: criterio,
                // grupo: grupo,
                obra: $("#obra option:selected").val()
            },
            success: function (msg) {
                d.modal("hide");
                $("#divTablaBusquedaRubros").html(msg);
            }
        });
        cargarTablaEmpatadosRubros()
    }

    function cargarTablaEmpatadosRubros() {
        var d = cargarLoader("Cargando...");
        var tipo = $("#buscarGrupo").val();
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'rubroOf', action:'tablaEmpatadosRubros_ajax')}",
            data: {
                tipo: tipo,
                obra: $("#obra").val()
            },
            success: function (msg) {
                d.modal("hide");
                $("#divTablaEmpatadosRubros").html(msg);
            }
        });
    }

    $("#btnEmparejaNmbr").click(function  () {
        var obra = $("#obra").val();
        bootbox.dialog({
            title   : "Alerta",
            message : "<i class='fa fa-check fa-2x pull-left text-danger text-shadow'></i>" +
            "<p style='font-weight: bold'> Está seguro que desea emparejar items del mismo nombre?</p>",
            buttons : {
                cancelar : {
                    label     : "Cancelar",
                    className : "btn-primary",
                    callback  : function () {
                    }
                },
                aceptar : {
                    label     : "<i class='fa fa-check'></i> Emparejar",
                    className : "btn-info",
                    callback  : function () {
                        var v = cargarLoader("Emparejando...");
                        $.ajax({
                            type    : "POST",
                            url     : '${createLink(controller: 'rubroOf', action: 'empjNmbrRbro')}',
                            data    : {
                                obra : obra
                            },
                            success : function (msg) {
                                v.modal("hide");
                                var parts = msg.split("_");
                                if(parts[0] === 'ok'){
                                    log(parts[1],"success");
                                    setTimeout(function () {
                                        location.reload()
                                    }, 1000);
                                }else{
                                    log(parts[1],"error")
                                }
                            }
                        });
                    }
                }
            }
        });
        return false;
    });


</script>

</body>
</html>
