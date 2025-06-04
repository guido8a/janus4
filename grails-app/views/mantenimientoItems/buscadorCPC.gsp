<div id="listaRbro" style="overflow: hidden">
    <fieldset class="borde" style="border-radius: 4px">
        <div class="row-fluid" style="margin-left: 10px">
            <span class="grupo">
                <label class="col-md-2 control-label text-info">
                    Buscar Por
                </label>
                <span class="col-md-3">
                    <g:select name="buscarPorCPP" class="col-md-12 form-control" from="${[1: 'Descripción', 2: 'Código']}" optionKey="key"
                              optionValue="value"/>
                </span>
                <label class="col-md-1 control-label text-info">
                    Criterio
                </label>
                <span class="col-md-4">
                    <g:textField name="buscarCriterioCPP" id="criterioCriterioCPP" class="form-control"/>
                </span>
            </span>
            <div class="col-md-1" style="margin-top: 1px">
                <button class="btn btn-info" id="btnBuscarCPC"><i class="fa fa-search"></i></button>
            </div>
        </div>
    </fieldset>

    <fieldset class="borde" style="border-radius: 4px">
        <div id="divTablaCPC" style="height: 500px; overflow: auto; margin-top: 5px">
        </div>
    </fieldset>
</div>

<script type="text/javascript">

    buscarCPC();

    $("#btnBuscarCPC").click(function () {
        buscarCPC();
    });

    function buscarCPC() {
        var buscarPor = $("#buscarPorCPP option:selected").val();
        var criterio = $("#criterioCriterioCPP").val();
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'mantenimientoItems', action:'tablaCPC')}",
            data: {
                buscarPor: buscarPor,
                criterio: criterio,
                tipo: '${tipo}'
            },
            success: function (msg) {
                $("#divTablaCPC").html(msg);
            }
        });
    }

    $("#criterioCriterioCPP").keydown(function (ev) {
        if (ev.keyCode === 13) {
            ev.preventDefault();
            buscarCPC();
            return false;
        }
    });

</script>