

<div class="row" style="margin-bottom: 1px">
    <div class="col-md-12">
        <div class="col-md-12 breadcrumb" style="font-weight: bold; font-size: 16px">
            ${"Código: " +  rubro?.codigo + " - " + "Nombre: " + rubro?.nombre}
        </div>
    </div>
</div>

<div id="busqueda" style="overflow: hidden">
    <fieldset class="borde" style="border-radius: 4px">
        <div class="row-fluid">
            <div class="col-md-2">
                Grupo
                <g:select name="buscarGrupoRubro_name" id="buscarGrupoRubro" from="${tipo}" optionKey="key" optionValue="value" class="form-control" />
            </div>
            <div class="col-md-2">
                Buscar Por
                <g:select name="buscarPorRubro" class="buscarPorRubro form-control" from="${[1: 'Nombre', 2: 'Código']}" style="width: 100%" optionKey="key" optionValue="value"/>
            </div>
            <div class="col-md-4">
                Criterio
                <g:textField name="criterioRubro" class="criterioRubro form-control"/>
            </div>
            <div class="col-md-2">
                Ordenado por
                <g:select name="ordenarRubro" class="ordenarRubro form-control" from="${[1: 'Nombre', 2: 'Código']}"   style="width: 100%" optionKey="key"
                          optionValue="value"/>
            </div>
            <div class="col-md-2 btn-group" style="margin-top: 20px">
                <button class="btn btn-info" id="btnBuscarRubro"><i class="fa fa-search"></i></button>
                <button class="btn btn-warning" id="btnLimpiarRubro" title="Limpiar Búsqueda"><i class="fa fa-eraser"></i></button>
            </div>
        </div>
    </fieldset>

    <fieldset class="borde col-md-12">
        <div class="col-md-12" id="divTabla">
        </div>
    </fieldset>
</div>

<script type="text/javascript">
    var di;

    $("#btnBuscarRubro").click(function () {
        cargarTablaBusquedaRubro();
    });

    $("#btnLimpiarRubro").click(function  () {
        $("#buscarPorRubro").val(1);
        $("#criterioRubro").val('');
        $("#ordenarRubro").val(1);
        cargarTablaBusquedaRubro();
    });

    $("#criterioRubro").keydown(function (ev) {
        if (ev.keyCode === 13) {
            cargarTablaBusquedaRubro();
            return false;
        }
        return true;
    });

    cargarTablaBusquedaRubro();

    function cargarTablaBusquedaRubro() {
        var d = cargarLoader("Cargando...");
        var grupo = $("#buscarGrupoRubro option:selected").val();
        var buscarPor = $("#buscarPorRubro option:selected").val();
        var criterio = $(".criterioRubro").val();
        var ordenar = $("#ordenarRubro option:selected").val();

        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'rubroOf', action:'tablaBuscarRubros_ajax')}",
            data: {
                buscarPor: buscarPor,
                criterio: criterio,
                ordenar: ordenar,
                grupo: grupo,
                rubro: '${rubro?.id}',
                nmbr:  '${rubro?.nombre}',
                obra: '${obra}'
            },
            success: function (msg) {
                d.modal("hide");
                $("#divTabla").html(msg);
            }
        });
    }

</script>