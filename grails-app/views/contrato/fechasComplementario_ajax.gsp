<div class="row">
    <div class="col-md-12">
        <span class="grupo">
            <label for="datetimepicker1" class="col-md-3 control-label text-info">
                Fecha Inicio
            </label>
            <span class="col-md-5">
                <input name="fechaInicioComplementario" id='datetimepicker1' type='text' class="form-control"
                       value="${contrato?.fechaInicio?.format("dd-MM-yyyy ") ?: new java.util.Date()?.format("dd-MM-yyyy")}"/>
            </span>
        </span>
    </div>
    <div class="col-md-12" style="margin-top: 10px">
        <span class="grupo">
            <label for="datetimepicker2" class="col-md-3 control-label text-info">
                Fecha Vencimiento
            </label>
            <span class="col-md-5">
                <input name="fechaFinComplementario" id='datetimepicker2' type='text' class="form-control"
                       value="${contrato?.fechaFin?.format("dd-MM-yyyy ") ?: new java.util.Date()?.format("dd-MM-yyyy")}"/>
            </span>
        </span>
    </div>
</div>


<script type="text/javascript">

    $(function () {
        $('#datetimepicker1, #datetimepicker2').datetimepicker({
            locale: 'es',
            format: 'DD-MM-YYYY',
            showClose: true,
            icons: {
                close: 'cerrar'
            }
        });
    });

</script>