<div class="row">
    <div class="col-md-12">
        <div class="col-md-5">
            <label>
                Fecha Desde
            </label>
            <input aria-label="" name="fechaDesdeCDG" id='fechaDesdeCDG' type='text' class="form-control" value="${new Date().format("dd-MM-yyyy")}"/>
        </div>

        <div class="col-md-5">
            <label>
                Fecha Hasta
            </label>
            <input aria-label="" name="fechaHastaCDG" id='fechaHastaCDG' type='text' class="form-control" value="${new Date().format("dd-MM-yyyy")}"/>
        </div>
    </div>
</div>

<script type="text/javascript">

    $('#fechaDesdeCDG, #fechaHastaCDG').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        icons: {
        }
    });

</script>