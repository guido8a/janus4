<div class="row">
    <div class="col-md-12">
        <div class="form-group">
            <span class="grupo">
                <label class="col-md-1 control-label text-info">
                    Fecha
                </label>
                <span class="col-md-4">
                    <g:select name="fecha" class="form-control" from="${fechas}"
                              optionKey='value' optionValue="value"/>
                </span>
            </span>
        </div>
        <div class="col-md-2">

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
        /*
         48-57      -> numeros
         96-105     -> teclado numerico
         188        -> , (coma)
         190        -> . (punto) teclado
         110        -> . (punto) teclado numerico
         8          -> backspace
         46         -> delete
         9          -> tab
         37         -> flecha izq
         39         -> flecha der
         */
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
            (ev.keyCode >= 96 && ev.keyCode <= 105) ||
            ev.keyCode === 190 || ev.keyCode === 110 ||
            ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
            ev.keyCode === 37 || ev.keyCode === 39);
    }

    $("#precio").keydown(function (ev) {
        return validarNum(ev);
    });


</script>


