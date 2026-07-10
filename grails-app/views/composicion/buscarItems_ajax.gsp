<div id="listaRbro" style="overflow: hidden">
    <fieldset class="borde" style="border-radius: 4px">
        <div class="row-fluid" style="margin-left: 10px">
            <span class="grupo">
                <span class="col-md-3">
                    <label class="control-label text-info">
                        Grupo
                    </label>
                    <g:select name="buscarGrupo" class="col-md-12 form-control" from="${[1: 'Materiales', 2: 'Mano de obra', 3: 'Equipos']}" optionKey="key"
                              optionValue="value"/>
                </span>
                <span class="col-md-3">
                    <label class="control-label text-info">
                        Buscar Por
                    </label>
                    <g:select name="buscarPor" class="col-md-12 form-control" from="${[1: 'Descripción', 2: 'Código']}" optionKey="key"
                              optionValue="value"/>
                </span>
                <span class="col-md-4">
                    <label class="control-label text-info">
                        Criterio
                    </label>
                    <g:textField name="buscarCriterio" id="criterioCriterio" class="form-control"/>
                </span>
            </span>
            <div class="col-md-1" style="margin-top: 20px">
                <button class="btn btn-info" id="btnBuscar"><i class="fa fa-search"></i></button>
            </div>
        </div>
    </fieldset>

    <fieldset class="borde" style="border-radius: 4px">
        <div id="divTablaResultadosItems" style="height: 450px; overflow: auto; margin-top: 5px">
        </div>
    </fieldset>
</div>

<script type="text/javascript">

    busqueda();

    $("#btnBuscar").click(function () {
        busqueda();
    });

    $("#buscarGrupo").change(function () {
        busqueda();
    });

    function busqueda() {
        var buscarPor = $("#buscarPor option:selected").val();
        var criterio = $("#criterioCriterio").val();
        var grupo = $("#buscarGrupo option:selected").val();
        var a =  cargarLoader("Cargando...");
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'composicion', action:'listaItem')}",
            data: {
                buscarPor: buscarPor,
                criterio: criterio,
                grupo: grupo
            },
            success: function (msg) {
                a.modal("hide");
                $("#divTablaResultadosItems").html(msg);
            }
        });
    }

    $("#criterioCriterio").keydown(function (ev) {
        if (ev.keyCode === 13) {
            ev.preventDefault();
            busqueda();
            return false;
        }
    });

</script>