<div id="listaRbro" style="overflow: hidden">
    <fieldset class="borde" style="border-radius: 4px">
        <div class="row-fluid" style="margin-left: 10px">

            <div class="col-md-2">
                Año
                <g:select class="form-control" name="anios" from="${janus.pac.Anio.list(sort: 'anio')}" value="${actual?.id}" optionKey="id" optionValue="anio"/>
            </div>
            <div class="col-md-2">
                Buscar Por
                <g:select name="buscarPor" class="buscarPor form-control" from="${[2: 'Descripción' , 1: 'Código']}" style="width: 100%" optionKey="key" optionValue="value"/>
            </div>
            <div class="col-md-3">
                Criterio
                <g:textField name="criterio" class="criterio form-control"/>
            </div>
            <div class="col-md-2 btn-group" style="margin-top: 20px">
                <button class="btn btn-info" id="btnBuscarPartida"><i class="fa fa-search"></i></button>
                <button class="btn btn-warning" id="btnLimpiarPartida" title="Limpiar Búsqueda"><i class="fa fa-eraser"></i></button>
            </div>
        </div>
    </fieldset>

    <fieldset class="borde" style="border-radius: 4px">
        <div id="divTablaPartidas" style="height: 460px; overflow: auto; margin-top: 5px">
        </div>
    </fieldset>
</div>

<script type="text/javascript">

    $("#btnLimpiarPartida").click(function () {
        $("#buscarPor").val(2);
        $("#criterio").val('');
        $("#anios").val('${actual?.id}');
        cargarPartidas();
    });

    $("#anios").change(function () {
        cargarPartidas();
    });

    cargarPartidas();

    $("#btnBuscarPartida").click(function () {
        cargarPartidas();
    });

    function cargarPartidas() {
        var anio = $("#anios option:selected").val();
        var buscarPor = $("#buscarPor option:selected").val();
        var criterio = $("#criterio").val();
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'presupuesto', action:'tablaBuscarPartida_ajax')}",
            data: {
                buscarPor: buscarPor,
                criterio: criterio,
                anio: anio
            },
            success: function (msg) {
                $("#divTablaPartidas").html(msg);
            }
        });
    }

    $("#criterio").keydown(function (ev) {
        if (ev.keyCode === 13) {
            ev.preventDefault();
            cargarPartidas();
            return false;
        }
    })
</script>