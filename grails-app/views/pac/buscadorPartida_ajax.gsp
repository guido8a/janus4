<div id="listaRbro" style="overflow: hidden">
    <fieldset class="borde" style="border-radius: 4px">
        <div class="row-fluid" style="margin-left: 10px">
            <span class="grupo">
                <label class="col-md-2 control-label text-info">
                    Buscar Por
                </label>
                <span class="col-md-3">
                    <g:select name="buscarPorPartida" class="col-md-12 form-control" from="${[2 : 'Descripción', 1 : 'Código']}" optionKey="key"
                              optionValue="value"/>
                </span>
                <label class="col-md-1 control-label text-info">
                    Criterio
                </label>
                <span class="col-md-4">
                    <g:textField name="buscarCriterio" id="criterioCriterio" class="form-control"/>
                </span>
            </span>
            <div class="col-md-2" style="margin-top: 1px">
                <button class="btn btn-info" id="btnBuscarPartida"><i class="fa fa-search"></i></button>
                <button class="btn btn-warning" id="btnLimpiarBuscarPartida" title="Limpiar Búsqueda"><i class="fa fa-eraser"></i></button>
            </div>
        </div>
    </fieldset>

    <fieldset class="borde" style="border-radius: 4px">
        <div id="divTablaPartida" style="height: 460px; overflow: auto; margin-top: 5px">
        </div>
    </fieldset>
</div>

<script type="text/javascript">

    $("#btnLimpiarBuscarPartida").click(function () {
        $("#buscarPorPartida").val(2);
        $("#criterioCriterio").val('');
        buscarPartida();
    });

    buscarPartida();

    $("#btnBuscarPartida").click(function () {
        buscarPartida();
    });

    function buscarPartida() {
        var buscarPor = $("#buscarPorPartida").val();
        var criterio = $("#criterioCriterio").val();
        $.ajax({
            type: "POST",
            url: "${createLink(action:'tablaPartida_ajax')}",
            data: {
                buscarPor: buscarPor,
                criterio: criterio,
                anio: '${anio}'
            },
            success: function (msg) {
                $("#divTablaPartida").html(msg);
            }
        });
    }

    $("#criterioCriterio").keydown(function (ev) {
        if (ev.keyCode === 13) {
            ev.preventDefault();
            buscarPartida();
            return false;
        }
    });

</script>