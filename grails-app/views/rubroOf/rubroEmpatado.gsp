
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Lista de Rubros
    </title>
</head>
<body>

%{--<div class="row" style="margin-bottom: 1px">--}%

%{--    <div class="col-md-8 breadcrumb" style="font-weight: bold; font-size: 16px">--}%
%{--        ${"Código: " +  rubro?.codigo + " - " + "Nombre: " + rubro?.nombre}--}%
%{--    </div>--}%

%{--</div>--}%

<div id="busqueda" style="overflow: hidden">
    <fieldset class="borde" style="border-radius: 4px">
        <div class="row-fluid">
            <div class="col-md-2 btn-group" role="navigation">
                <a href="#" class="btn btn-primary" id="btnRegresarPrincipal">
                    <i class="fa fa-arrow-left"></i>
                    Regresar
                </a>
            </div>
            <div id="list-grupo" class="col-md-10" role="main" style="margin-top: 10px;margin-left: -10px">

                <div class="col-md-12">
                    <div class="col-md-3">
                        <b style="margin-left: 20px">Obra Ofertada:</b>
                    </div>
                    <div class="col-md-9">
                        <g:select name="obra"
                                  from="${obras}" optionKey="key" optionValue="value"
                                  style="width: 100%; margin-left: -80px"/>
                    </div>
                </div>
            </div>

            <div class="col-md-2">
                Grupo
                <g:select name="buscarGrupo_name" id="buscarGrupo" from="['MT': 'Materiales', 'MO': 'Mano de Obra', 'EQ': 'Equipos']" optionKey="key" optionValue="value" class="form-control" />
            </div>
            <div class="col-md-2">
                Buscar Por
                <g:select name="buscarPor" class="buscarPor form-control" from="${[1: 'Nombre', 2: 'Código']}" style="width: 100%" optionKey="key" optionValue="value"/>
            </div>
            <div class="col-md-4">
                Criterio
                <g:textField name="criterio" class="criterio form-control"/>
            </div>
            <div class="col-md-2 btn-group" style="margin-top: 20px">
                <button class="btn btn-info" id="btnBuscar"><i class="fa fa-search"></i></button>
                <button class="btn btn-warning" id="btnLimpiar" title="Limpiar Búsqueda"><i class="fa fa-eraser"></i></button>
            </div>
        </div>
    </fieldset>

    <fieldset class="borde">
        <div id="divTablaBusqueda">
        </div>
    </fieldset>
</div>

<div class="col-md-12" id="divTablaEmpatados" style="margin-top: 10px">

</div>

<script type="text/javascript">
    var di;

    $("#btnRegresarPrincipal").click(function () {
        location.href="${createLink(controller: 'rubroOf', action: 'rubroCon')}/${rubro?.id}"
    });

    $("#buscarGrupo").change(function () {
        cargarTablaBusqueda();
    });

    $("#btnBuscar").click(function () {
        cargarTablaBusqueda();
    });

    $("#btnLimpiar").click(function  () {
        $("#buscarGrupo").val('MT');
        $("#buscarPor").val(1);
        $("#criterio").val('');
        $("#ordenar").val(1);
        cargarTablaBusqueda();
    });

    $("#criterio").keydown(function (ev) {
        if (ev.keyCode === 13) {
            cargarTablaBusqueda();
            return false;
        }
        return true;
    });

    cargarTablaBusqueda();
    cargarTablaEmpatados();

    function cargarTablaBusqueda() {
        var d = cargarLoader("Cargando...");
        var grupo = $("#buscarGrupo option:selected").val();
        var buscarPor = $("#buscarPor option:selected").val();
        var criterio = $(".criterio").val();
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'rubroOf', action:'tablaBusqueda_ajax')}",
            data: {
                buscarPor: buscarPor,
                criterio: criterio,
                grupo: grupo,
                obra: $("#obra").val()
            },
            success: function (msg) {
                d.modal("hide");
                $("#divTablaBusqueda").html(msg);
            }
        });
        cargarTablaEmpatados()
    }

    function cargarTablaEmpatados() {
        var d = cargarLoader("Cargando...");
        var tipo = $("#buscarGrupo").val()
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'rubroOf', action:'tablaEmpatados_ajax')}",
            data: {
                tipo: tipo,
                obra: $("#obra").val()
            },
            success: function (msg) {
                d.modal("hide");
                $("#divTablaEmpatados").html(msg);
            }
        });
    }

</script>

</body>
</html>
