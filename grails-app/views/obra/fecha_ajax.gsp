<div class="container">
    <div class="col-md-12">
        <div class="col-md-1">
          <label> Fecha </label>
        </div>
        <div class="col-md-1"  style="width: 170px; margin-left: -40px">
            <input aria-label="" name="fechaModificada" id='fechaModificada' type='text' class="form-control" value="${obra?.fechaCreacionObra?.format('dd-MM-yyyy') ?: new Date().format('dd-MM-yyyy')}"/>
        </div>
    </div>
</div>

<script type="text/javascript">

    $('#fechaModificada').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        icons: {
        }
    });

</script>