<div style="overflow: hidden">
    <fieldset class="borde" style="border-radius: 4px; margin-bottom: 5px">
        <div class="row-fluid" style="margin-left: 10px">
            <span class="grupo">
                <span class="col-md-4">
                    <label class="control-label text-info">Buscar Por</label>
                    <g:select name="buscarPor" class="col-md-12 form-control" from="${[ 1: 'Nombre']}" optionKey="key"  optionValue="value"/>
                </span>
                <span class="col-md-4">
                    <label class="control-label text-info">Criterio</label>
                    <g:textField name="criterio" class="form-control"/>
                </span>
            </span>
            <div class="col-md-3" style="margin-top: 20px">
                <button class="btn btn-info" id="btnBuscarListaRubros"><i class="fa fa-search"></i></button>
                <button class="btn btn-warning" id="btnLimpiar" title="Limpiar Búsqueda"><i class="fa fa-eraser"></i></button>
            </div>
        </div>
    </fieldset>

    <fieldset class="borde" style="border-radius: 4px">
        <div id="divTablaRubros" >
        </div>
    </fieldset>

    <fieldset style="border-radius: 4px; margin-top: 5px">
        <div class="alert alert-warning">
            * Máxima cantidad de registros en pantalla 100
        </div>
    </fieldset>
</div>

<script type="text/javascript">

    cargarListaRubros();

    $("#btnBuscarListaRubros").click(function () {
        cargarListaRubros();
    });

    $("#btnLimpiar").click(function () {
        $("#criterio").val('');
        $("#buscarPor").val(1);
        cargarListaRubros();
    });

    function cargarListaRubros(){
        var e = cargarLoader("Cargando...");
        var buscarPor = $("#buscarPor option:selected").val();
        var criterio = $("#criterio").val();
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'rubroOf', action: 'tablaBuscarCon_ajax')}',
            data:{
                buscarPor: buscarPor,
                criterio: criterio
            },
            success: function (msg){
                e.modal("hide");
                $("#divTablaRubros").html(msg)
            }
        })
    }

    $(".form-control").keydown(function (ev) {
        if (ev.keyCode === 13) {
            cargarListaRubros();
            return false;
        }
        return true;
    })

</script>