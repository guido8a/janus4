<table class="table table-bordered table-striped table-condensed table-hover">
    <thead>
    <tr>
        <th style="width:5%;">Año</th>
        <th style="width:15%;">Proyecto</th>
        <th style="width:32%;">Partida</th>
        <th style="width:15%;">Programa</th>
        <th style="width: 15%;">Subprograma</th>
        <th style="width: 7%;">Acciones</th>
        <th style="width: 1%;"></th>
    </tr>
    </thead>
</table>

<div class="" style="width: 100%;height: 550px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover table-striped" style="width: 100%">
        <tbody>
        <g:if test="${presupuestos.size() > 0}">
            <g:each in="${presupuestos}" var="presupuesto">
                <tr>
                    <td style="text-align: center; width:5%">${anio?.anio}</td>
                    <td style="width:15%;">${presupuesto?.prspproy}</td>
                    <td style="width:32%;">${presupuesto?.prspdscr} <strong style="color: #0d7bdc">(${presupuesto?.prspnmro})</strong> </td>
                    <td style="width:15%;">${presupuesto?.prspprgm}</td>
                    <td style="width:15%;">${presupuesto?.prspsbpr}</td>
                    <td style="width: 7%; text-align: center">
                        <a href="#" class="btn btn-success btn-xs btnEditarPartida" data-id="${presupuesto?.prsp__id}" ><i class="fa fa-edit"></i></a>
                        <a href="#" class="btn btn-danger btn-xs btnBorrarPartida" data-id="${presupuesto?.prsp__id}" ><i class="fa fa-trash"></i></a>
                    </td>
                    <td style="width: 1%"></td>
                </tr>
            </g:each>
        </g:if>
        <g:else>
            <tr>
                <td class="alert alert-info" colspan="7" style="text-align: center"> <h3><i class="fa fa-exclamation-triangle"></i> No exiten registros</h3> </td>
            </tr>
        </g:else>
        </tbody>
    </table>
</div>

<script type="text/javascript">

    $(".btnEditarPartida").click(function () {
        var id = $(this).data("id");
        createEditPresupuesto(id);
    });

    $(".btnBorrarPartida").click(function () {
        var id = $(this).data("id");
        bootbox.confirm({
            title: "Eliminar partida",
            message: "<i class='fa fa-exclamation-triangle text-info fa-3x'></i> <strong style='font-size: 14px'> Está seguro de eliminar esta partida?</strong> ",
            buttons: {
                cancel: {
                    label: '<i class="fa fa-times"></i> Cancelar',
                    className: 'btn-primary'
                },
                confirm: {
                    label: '<i class="fa fa-trash"></i> Borrar',
                    className: 'btn-danger'
                }
            },
            callback: function (result) {
                if(result){
                    var dialog = cargarLoader("Borrando...");
                    $.ajax({
                        type : "POST",
                        url : "${g.createLink(controller: 'presupuesto',action:'borrarPartida_ajax')}",
                        data     : {
                            id : id
                        },
                        success  : function (msg) {
                            dialog.modal('hide');
                            var parts = msg.split("_");
                            if(parts[0] === 'ok'){
                                log(parts[1], "success");
                                cargarPartidas();
                            }else{
                                if(parts[0] === 'err'){
                                    bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                                    return false;
                                }else{
                                    log(parts[1], "error");
                                }
                            }
                        }
                    });
                }
            }
        });
    });

</script>
