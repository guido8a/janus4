<div class="row alert alert-info">
    <div class="col-md-12 breadcrumb" style="font-size: 18px; text-align: center; font-weight: bold">
        Asignación
    </div>
    <div class="col-md-12" >
        <div class="col-md-1">
            <label style="font-size: 18px; text-align: center; font-weight: bold">
                Asignación
            </label>
        </div>
        <div class="col-md-6">
            <g:select name="asignacion" from="${asignaciones}" value="" optionValue="${{it.prespuesto.proyecto + " - " + it.prespuesto.programa}}" optionKey="id" class="form-control" />
        </div>
        <div class="col-md-1">
            <label style="font-size: 18px; text-align: center; font-weight: bold">
                Valor
            </label>
        </div>
        <div class="col-md-2" id="divValorAsignacion">
        </div>
        <div class="col-md-2" style="margin-top: 2px; float: right">
            <a href="#" class="btn btn-success btnNuevaAsignacion"><i class="fa fa-file"></i> Nueva Asignación</a>
        </div>
    </div>
</div>

<script type="text/javascript">

    $("#asignacion").change(function () {
        cargarValorAsignacion();
    });

    cargarValorAsignacion();

    function cargarValorAsignacion() {
        var asignacion = $("#asignacion option:selected").val();
        var partida = '${partida?.id}';
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'asignacion', action:'valor_ajax')}",
            data: {
                id: asignacion
            },
            success: function (msg) {
                $("#divValorAsignacion").html(msg);
                cargarPAC(partida)
            }
        });
    }



</script>