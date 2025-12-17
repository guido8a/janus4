<div id="listaRbro" style="overflow: hidden">
    <fieldset class="borde" style="border-radius: 4px">
        <div class="row-fluid" style="margin-left: 10px">
            <div class="col-md-2">
                Buscar Por
                <g:select name="buscarObraPor" class="buscarObraPor form-control" from="${[2: 'Descripción' , 1: 'Código']}" style="width: 100%" optionKey="key" optionValue="value"/>
            </div>
            <div class="col-md-5">
                Criterio
                <g:textField name="criterioObra" class="criterioObra form-control"/>
            </div>
            <div class="col-md-2 btn-group" style="margin-top: 20px">
                <button class="btn btn-info" id="btnBuscadorObra"><i class="fa fa-search"></i></button>
                <button class="btn btn-warning" id="btnLimpiarObra" title="Limpiar Búsqueda"><i class="fa fa-eraser"></i></button>
            </div>
        </div>
    </fieldset>

    <fieldset class="borde" style="border-radius: 4px">
        <div id="divTablaObras" style="height: 460px; overflow: auto; margin-top: 5px">
        </div>
    </fieldset>
</div>

<script type="text/javascript">

    $("#btnLimpiarObra").click(function () {
        $("#buscarObraPor").val(2);
        $("#criterioObra").val('');
        cargarObras();
    });

    cargarObras();

    $("#btnBuscadorObra").click(function () {
        cargarObras();
    });

    function cargarObras() {
        var buscarPor = $("#buscarObraPor option:selected").val();
        var criterio = $(".criterioObra").val();
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'concurso', action:'tablaBuscarObras_ajax')}",
            data: {
                buscarPor: buscarPor,
                criterio: criterio,
                tipo: '${tipo}'
            },
            success: function (msg) {
                <g:if test="${tipo == '1'}">
                $("#obraNameC").focus();
                </g:if>
                <g:else>
                $("#obraName").focus();
                </g:else>
                $("#divTablaObras").html(msg);
            }
        });
    }

    $("#criterioObra").keydown(function (ev) {
        if (ev.keyCode === 13) {
            ev.preventDefault();
            cargarObras();
            return false;
        }
    })
</script>