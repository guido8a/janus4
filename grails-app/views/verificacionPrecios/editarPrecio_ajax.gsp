<div class="row">
    <div class="col-md-12">
        <div class="form-group">
            <span class="grupo">
                <label class="col-md-1 control-label text-info">
                    Fecha
                </label>
                <span class="col-md-3">
                    <input aria-label="" name="fecha" id='datetimepicker3' type='text' class="form-control required"
                           value="${new Date().format("dd-MM-yyyy")}"/>
                </span>
            </span>
        </div>
        <div class="form-group">
            <span class="grupo">
                <label class="col-md-1 control-label text-info">
                    Precio
                </label>
                <span class="col-md-3">
                  <g:textField name="precio" value="${0}" class="form-control required"/>
                </span>
            </span>
        </div>
    </div>
</div>



<script type="text/javascript">

    $('#datetimepicker3').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        icons: {
        }
    });

</script>