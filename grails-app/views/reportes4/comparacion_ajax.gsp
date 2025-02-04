<div style="margin-top: 15px; min-height: 300px">
    <table class="table table-bordered table-hover table-condensed" style="width: 100%; background-color: #a39e9e">
        <thead>
        <tr>
            <th style="width: 10%">
                Código
            </th>
            <th style="width: 34%;">
                Rubro
            </th>
            <th style="width: 19%">
                Unidad
            </th>
            <th style="width: 8%">
               Cantidad
            </th>
            <th style="width: 10%">
                P. Unitario
            </th>
            <th style="width: 7%">
                Código
            </th>
            <th style="width: 7%">
                P. Unitario
            </th>
            <th style="width: 7%">
                Diferencia
            </th>
        </tr>
        </thead>
    </table>
    <div id="detalleComparacion">
    </div>
</div>

<script type="text/javascript">

    cargarTablaComparacion();

    function cargarTablaComparacion() {
        $.ajax({
            type : "POST",
            url : "${g.createLink(controller: 'reportes4', action: 'tablaComparacion_ajax')}",
            data     : {
                id: '${obra?.id}'
            },
            success  : function (msg) {
                $("#detalleComparacion").html(msg)
            }
        });
    }

</script>