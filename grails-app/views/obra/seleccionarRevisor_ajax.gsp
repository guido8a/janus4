<div class="row">
    <div class="col-md-12">
        <div class="col-md-8">
            <g:select name="revisor.id" class="revisor form-control" from="${personasRolRevi}" optionKey="id"
                      optionValue="${{ (it?.titulo ?: '') + ' ' + it.nombre + ' ' + it.apellido }}"
                      value="${obra?.revisor?.id}" title="Persona para la revisión de la Obra"/>
        </div>

        <div class="col-md-2">
            <a href="#" class="btn btn-success" id="btnGuardarRevisor" title="Guardar revisor"
               >
                <i class="fa fa-save"></i> Guardar
            </a>
        </div>
    </div>
</div>


<script type="text/javascript">

    $("#btnGuardarRevisor").click(function () {
        var revisor = $(".revisor option:selected").val();
        var dp = cargarLoader("Guardando...");
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'obra', action: 'guardarRevisor_ajax')}",
            data    : {
                obra: '${obra?.id}',
                revisor: revisor
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



