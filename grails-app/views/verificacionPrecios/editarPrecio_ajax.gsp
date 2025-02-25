<div class="row">
    <div class="col-md-12">
        <div class="form-group">
            <span class="grupo">
                <label class="col-md-1 control-label text-info">
                    Fecha
                </label>
                <span class="col-md-3">
                    <g:select name="fecha" class="form-control" from="${fechas}"
                              optionKey='value' optionValue="value" style="width: 120px"/>
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


    function validarNum(ev) {
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
            (ev.keyCode >= 96 && ev.keyCode <= 105) ||
            ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
            ev.keyCode === 37 || ev.keyCode === 39);
    }

    $("#precio").keydown(function (ev) {
        return validarNum(ev);
    });


</script>


