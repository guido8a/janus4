
<table class="table table-bordered table-striped table-hover table-condensed" id="tabla">
    <thead>
    <tr>
        <th style="width: 10%">Año</th>
        <th style="width: 35%">Código</th>
        <th style="width: 45%">Descripción</th>
        <th style="width: 9%">Acciones</th>
        <th style="width: 1%"></th>
    </tr>
    </thead>
</table>

<div class="" style="width: 100%;height: 430px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover">
        <g:each in="${presupuestos}" var="presupuesto" status="i">
            <tr style="width: 100%">
                <td style="width: 10%">${anioSeleccionado}</td>
                <td style="width: 35%">${presupuesto.prspnmro}</td>
                <td style="width: 45%">${presupuesto.prspdscr}</td>
                <td style="width: 9%; text-align: center">
                    <a href="#" class="btn btn-xs btn-success btnSeleccionar" data-id="${presupuesto.prsp__id}" data-nombre="${presupuesto.prspdscr}" data-codigo="${presupuesto.prspnmro}" ><i class="fa fa-check"></i></a>
                </td>
                <td style="width: 1%"></td>
            </tr>
        </g:each>
    </table>
</div>

<script type="text/javascript">

    $(".btnSeleccionar").click(function () {
        var id = $(this).data("id");
        var nombre = $(this).data("nombre");
        var codigo = $(this).data("codigo");

        $("#prespuesto").val(id);
        $("#presupuestoName").val(nombre);
        $("#presupuestoCodigo").val(codigo);

        cerrarBuscarPartida();
    });

</script>