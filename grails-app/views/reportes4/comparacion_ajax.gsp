<div style="margin-top: 15px; min-height: 300px">
    <table class="table table-bordered table-hover table-condensed" style="width: 100%; background-color: #a39e9e">
        <thead>
        <tr>
            <th style="width: 10%">
                Código
            </th>
            <th style="width: 34%;">
                Nombre
            </th>
            <th style="width: 19%">
                Cantón-Parroquia-Comunidad
            </th>
            <th style="width: 8%">
                Núm. Contrato
            </th>
            <th style="width: 10%">
                Contratista
            </th>
            <th style="width: 7%">
                Monto
            </th>
            <th style="width: 7%">
                Fecha suscripción
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