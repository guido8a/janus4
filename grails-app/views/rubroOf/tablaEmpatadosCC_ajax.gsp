
<g:if test="${!materiales}">
    <div class="alert alert-success" style="text-align: center; font-size: 14px">
        <i class="fa fa fa-thumbs-up text-info fa-2x"></i> <strong style="font-size: 14px"> Todos los materiales emparejados </strong>
    </div>
</g:if>
<g:else>
    <div class="alert alert-warning" style="text-align: center; font-size: 14px">
        <i class="fa fa-exclamation-triangle text-info fa-2x"></i> <strong style="font-size: 14px"> Existen materiales no emparejados </strong>
    </div>
</g:else>

<g:if test="${!mano}">
    <div class="alert alert-success" style="text-align: center; font-size: 14px">
        <i class="fa fa fa-thumbs-up text-info fa-2x"></i> <strong style="font-size: 14px"> Todos la mano de obra emparejada </strong>
    </div>
</g:if>
<g:else>
    <div class="alert alert-warning" style="text-align: center; font-size: 14px">
        <i class="fa fa-exclamation-triangle text-info fa-2x"></i> <strong style="font-size: 14px"> Existe mano de obra no emparejada </strong>
    </div>
</g:else>

<g:if test="${!equipos}">
    <div class="alert alert-success" style="text-align: center; font-size: 14px">
        <i class="fa fa-thumbs-up text-info fa-2x"></i> <strong style="font-size: 14px"> Todos los equipos emparejados </strong>
    </div>
</g:if>
<g:else>
    <div class="alert alert-warning" style="text-align: center; font-size: 14px">
        <i class="fa fa-exclamation-triangle text-info fa-2x"></i> <strong style="font-size: 14px"> Existen equipos no emparejados </strong>
    </div>
</g:else>

<g:if test="${!materiales}">
    <g:if test="${!mano}">
        <g:if test="${!equipos}">
            <div class="row-fluid">
                <div class="col-md-4" style="margin-top: 10px">
                </div>
                <div class="col-md-4" style="margin-top: 10px; width: 33%">
                    <a href="#" class="btn btn-info" id="btnCopiar" style="text-align: center; width: 100%">
                        <i class="fa fa-edit"></i>
                        Copiar composición a los APU del Oferente
                    </a>
                </div>
            </div>
        </g:if>
    </g:if>
</g:if>

<script type="text/javascript">

    $("#btnCopiar").click(function () {
        var v = cargarLoader("Copiando...");
        var obra = '${obra?.id}';
        $.ajax({
            type    : "POST",
            url     : '${createLink(controller: 'rubroOf', action: 'copiarRubros')}',
            data    : {
                obra : obra
            },
            success : function (msg) {
                v.modal("hide");
                var parts = msg.split("_");
                if(parts[0] === 'ok'){
                    // log("Copiados correctamente","success");

                    bootbox.alert('<i class="fa fa-thumbs-up text-success fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Copiados correctamente" + '</strong>');

                    // setTimeout(function () {
                    //     location.reload()
                    // }, 1000);
                }else{
                    log("Error al copiar","error")
                }
            }
        });
    });


</script>