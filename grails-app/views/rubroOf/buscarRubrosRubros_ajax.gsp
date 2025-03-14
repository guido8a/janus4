

<div class="row" style="margin-bottom: 1px">
    <div class="col-md-12">
        <div class="col-md-12 breadcrumb" style="font-weight: bold; font-size: 16px">
            ${"Nombre: " + rubro?.nombre}
        </div>
    </div>
</div>

<div id="busqueda" style="overflow: hidden">
    <fieldset class="borde" style="border-radius: 4px">
        <div class="row-fluid">
            <div class="col-md-4">
                Criterio
                <g:textField name="criterioRubro" class="criterioRubro form-control"/>
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
        cargarTablaBusquedaRubro2();
    });

    $("#btnLimpiarRubro").click(function  () {
        $("#criterioRubro").val('');
        cargarTablaBusquedaRubro2();
    });

    $("#criterioRubro").keydown(function (ev) {
        if (ev.keyCode === 13) {
            cargarTablaBusquedaRubro2();
            return false;
        }
        return true;
    });

    cargarTablaBusquedaRubro2();

    function cargarTablaBusquedaRubro2() {
        var d = cargarLoader("Cargando...");
        var criterio = $(".criterioRubro").val();

        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'rubroOf', action:'tablaBuscarRubrosRubros_ajax')}",
            data: {
                criterio: criterio,
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