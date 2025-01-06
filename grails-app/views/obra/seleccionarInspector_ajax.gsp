<div class="row">
    <div class="col-md-12">
        <div class="col-md-8">
            <g:select name="inspector.id" class="inspector form-control" from="${personasRolInsp}"
                      optionKey="id" optionValue="${{ (it?.titulo ?: '') + ' ' + it.nombre + " " + it.apellido }}"
                      value="${obra?.inspector?.id}" title="Persona para Inspección de la Obra"
                      />
        </div>

        <div class="col-md-2">
            <a href="#" class="btn btn-success" id="btnGuardarInspector" title="Guardar inspector"
            >
                <i class="fa fa-save"></i> Guardar
            </a>
        </div>
    </div>
</div>

<script type="text/javascript">
    
    $("#btnGuardarInspector").click(function () {
        var inspector = $(".inspector option:selected").val();
        var dp = cargarLoader("Guardando...");
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'obra', action: 'guardarInspector_ajax')}",
            data    : {
                obra: '${obra?.id}',
                inspector: inspector
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