<table class="table table-bordered table-striped table-condensed table-hover">
    <thead>
    <tr>
        <th style="width: 5%">Año</th>
        <th style="width: 20%">Partida</th>
        <th style="width: 6%;">CCP</th>
        <th style="width: 6%;">Tipo <br>Compra</th>
        <th style="width: 22%;">Descripción</th>
        <th style="width: 5%;">Cant.</th>
        <th style="width: 5%">Unidad</th>
        <th style="width: 7%">Costo <br>Unitario</th>
        <th style="width: 7%">Costo <br>Total</th>
        <th style="width: 3%;">C1</th>
        <th style="width: 3%;">C2</th>
        <th style="width: 3%;">C3</th>
        <th style="width: 6%;">Acciones</th>
        <th style="width: 1%;"></th>
    </tr>
    </thead>
</table>

<div class="" style="width: 100%;height: 550px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover table-striped" style="width: 100%">
        <tbody>
        <g:if test="${pacs.size() > 0}">
            <g:set var="total" value="${0}"/>
            <g:each in="${pacs}" var="pac">
                <g:set var="p" value="${janus.pac.Pac.get(pac?.pacp__id)}"/>
                <tr>
                    <td style="width: 5%">${anio?.anio}</td>
                    <td style="width: 20%; font-size: 10px"class="prsp" title="${p.presupuesto.descripcion} - Fuente: ${p.presupuesto.fuente} - Programa: ${p.presupuesto.programa} - Subprograma: ${p.presupuesto.subPrograma} - Proyecto: ${p.presupuesto.proyecto}">${p.presupuesto.numero}</td>
                    <td style="width: 6%" title="${p.cpp?.descripcion}">${p.cpp?.numero}</td>
                    <td style="width: 6%" >${p.tipoCompra.descripcion}</td>
                    <td style="width: 22%">${p.descripcion}</td>
                    <td style="text-align: right; width: 5%">
                        <g:formatNumber number="${p.cantidad}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/>
                    </td>
                    <td style="width: 5% !important;text-align: center" class="unidad">${p.unidad.codigo}</td>
                    <td style="text-align: right; width: 7%" class="costo"><g:formatNumber number="${p.costo}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/></td>
                    <td style="text-align: right; width: 7%" class="total"><g:formatNumber number="${p.cantidad*p.costo}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/></td>
                    <g:set var="total" value="${total+p.cantidad*p.costo}"/>
                    <td style="text-align: center; width: 3%; ${p?.c1 ? 'background-color: #c1ffbb' : ''}" class="c1">${p.c1}</td>
                    <td style="text-align: center; width: 3%; ${p?.c2 ? 'background-color: #c1ffbb' : ''}" class="c2">${p.c2}</td>
                    <td style="text-align: center; width: 3%; ${p?.c3 ? 'background-color: #c1ffbb' : ''}" class="c3">${p.c3}</td>
                    <td style="width: 6%; text-align: center">
                        <a href="#" class="btn btn-success btn-xs btnEditarPac" data-id="${p?.id}" ><i class="fa fa-edit"></i></a>
                        <a href="#" class="btn btn-danger btn-xs btnBorrarPac" data-id="${p?.id}" ><i class="fa fa-trash"></i></a>
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

    $(".btnEditarPac").click(function () {
        var id = $(this).data("id");
        createEditPac(id);
    });

    $(".btnBorrarPac").click(function () {
        var id = $(this).data("id");
        bootbox.confirm({
            title: "Eliminar PAC",
            message: "<i class='fa fa-exclamation-triangle text-info fa-3x'></i> <strong style='font-size: 14px'> Está seguro de eliminar este PAC?</strong> ",
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
                        url : "${g.createLink(controller: 'pac',action:'borrarPac_ajax')}",
                        data     : {
                            id : id
                        },
                        success  : function (msg) {
                            dialog.modal('hide');
                            var parts = msg.split("_");
                            if(parts[0] === 'ok'){
                                log(parts[1], "success");
                                cargarPacs();
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
