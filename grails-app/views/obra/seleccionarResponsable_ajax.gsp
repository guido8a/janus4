<div class="row">
    <div class="col-md-12">
        <div class="col-md-8">
            <g:select name="responsableObra.id" class="responsable form-control" from="${personasUtfpu}"
                      optionKey="id" optionValue="${{ (it?.titulo ?: '') + ' ' + it?.nombre + ' ' + it?.apellido }}"
                      value="${obra?.responsableObra?.id}" title="Persona responsable de la Obra"
                      />
        </div>

        <div class="col-md-2">
            <a href="#" class="btn btn-success" id="btnGuardarResponsable" title="Guardar responsable"
            >
                <i class="fa fa-save"></i> Guardar
            </a>
        </div>
    </div>
</div>

<script type="text/javascript">

    $("#btnGuardarResponsable").click(function () {
        var responsable = $(".responsable option:selected").val();
        var dp = cargarLoader("Guardando...");
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'obra', action: 'guardarResponsable_ajax')}",
            data    : {
                obra: '${obra?.id}',
                responsable: responsable
            },
            success : function (msg) {
                dp.modal('hide');
                var parts = msg.split("_");
                if(parts[0] === 'ok'){
                    log(parts[1], "success");
                    setTimeout(function () {
                        location.reload();
                    }, 800);
                }else{
                    bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                    return false;
                }
            }
        });
    })

</script>


