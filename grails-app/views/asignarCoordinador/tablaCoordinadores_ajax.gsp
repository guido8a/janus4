<table class="table table-bordered table-striped table-hover table-condensed" id="tabla" style="width: 100%; background-color: #a39e9e">
    <thead>
    <tr style="text-align: center">
        <th style="width: 25%">Función</th>
        <th style="width: 55%">Persona</th>
        <th style="width: 19%">Acciones</th>
        <th style="width: 1%"></th>
    </tr>
    </thead>
</table>

<div class="" style="width: 99.7%;height: 450px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-striped table-hover" style="width: 100%; font-size: 14px">
        <g:if test="${coordinadores?.size() > 0}">
            <g:each in="${coordinadores}" var="coordinador">
                <tr style="width: 100%">
                    <td style="width: 25%">${coordinador?.funcion?.descripcion}</td>
                    <td style="width: 55%">${(coordinador?.persona?.apellido ?: '') + " " + (coordinador?.persona?.nombre ?: '') }</td>
                    <td style="width: 19%; text-align: center">
                        <a class="btn btn-xs btnBorrarCoordinador btn-danger" href="#" title="Eliminar" data-id="${coordinador?.id}">
                            <i class="fa fa-trash"></i>
                        </a>
                    </td>
                    <td style="width: 1%"></td>
                </tr>
            </g:each>
        </g:if>
        <g:else>
            <div class="alert alert-warning" style="margin-top: 0px; text-align: center; font-size: 14px; font-weight: bold"><i class="fa fa-exclamation-triangle fa-2x text-info"></i> Sin coordinador asignado</div>
        </g:else>
    </table>
</div>

<script type="text/javascript">

    $(".btnBorrarCoordinador").click(function () {
        var id = $(this).data("id");
        borrarCoordinador(id)
    });

    function borrarCoordinador(itemId) {
        bootbox.dialog({
            title   : "<i class='fa fa-trash fa-2x pull-left text-danger text-shadow'></i> Eliminar Coordinador",
            message : "<strong style='font-size: 14px; font-weight: bold'> ¿Está seguro que desea eliminar el coordinador seleccionado?. </strong>",
            buttons : {
                cancelar : {
                    label     : "Cancelar",
                    className : "btn-primary",
                    callback  : function () {
                    }
                },
                eliminar : {
                    label     : "<i class='fa fa-trash'></i> Eliminar",
                    className : "btn-danger",
                    callback  : function () {
                        var ad = cargarLoader("Eliminando");
                        $.ajax({
                            type    : "POST",
                            url     : '${createLink(controller: 'asignarCoordinador', action:'delete_ajax')}',
                            data    : {
                                id : itemId
                            },
                            success : function (msg) {
                                ad.modal('hide');
                                var parts = msg.split("_");
                                if (parts[0] === "ok") {
                                    log(parts[1], "success");
                                    cargarTablaCoordinadores('${departamento?.id}');
                                }else{
                                    log(parts[1], "error");
                                }
                            }
                        });
                    }
                }
            }
        });
    }
</script>