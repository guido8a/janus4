<div id="listaRbro" style="overflow: hidden">
    <fieldset class="borde" style="border-radius: 4px">
        <div class="row-fluid" style="margin-left: 10px">
            <div class="col-md-2">
                Buscar Por
                <g:select name="buscarProveedorPor" class="buscarProveedorPor form-control" from="${[2: 'Nombre' , 1: 'RUC']}" style="width: 100%" optionKey="key" optionValue="value"/>
            </div>
            <div class="col-md-5">
                Criterio
                <g:textField name="criterioProveedor" class="criterioProveedor form-control"/>
            </div>
            <div class="col-md-2 btn-group" style="margin-top: 20px">
                <button class="btn btn-info" id="btnBuscadorProveedor"><i class="fa fa-search"></i></button>
                <button class="btn btn-warning" id="btnLimpiarProveedor" title="Limpiar Búsqueda"><i class="fa fa-eraser"></i></button>
            </div>
        </div>
    </fieldset>

    <fieldset class="borde" style="border-radius: 4px">
        <div id="divTablaProveedores" style="height: 460px; overflow: auto; margin-top: 5px">
        </div>
    </fieldset>
</div>

<script type="text/javascript">

    $("#btnLimpiarProveedor").click(function () {
        $("#buscarProveedorPor").val(2);
        $("#criterioProveedor").val('');
        cargarProveedores();
    });

    cargarProveedores();

    $("#btnBuscadorProveedor").click(function () {
        cargarProveedores();
    });

    function cargarProveedores() {
        var buscarPor = $("#buscarProveedorPor option:selected").val();
        var criterio = $("#criterioProveedor").val();
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'oferta', action:'tablaBuscarProveedores_ajax')}",
            data: {
                buscarPor: buscarPor,
                criterio: criterio
            },
            success: function (msg) {
                $("#divTablaOferta").focus();
                $("#divTablaProveedores").html(msg);
            }
        });
    }

    $("#criterioProveedor").keydown(function (ev) {
        if (ev.keyCode === 13) {
            ev.preventDefault();
            cargarProveedores();
            return false;
        }
    })
</script>