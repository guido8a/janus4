<style type="text/css">
table {
    table-layout: fixed;
    overflow-x: scroll;
}
th, td {
    overflow: hidden;
    text-overflow: ellipsis;
    word-wrap: break-word;
}
</style>

<table class="table table-bordered table-striped table-condensed table-hover">
    <thead>
    <tr>
%{--        <th style="width: 5%">Año</th>--}%
%{--        <th style="width: 20%">Partida</th>--}%
        <th style="width: 7%;">CCP</th>
        <th style="width: 5%;">Tipo <br>Compra</th>
%{--        <th style="width: 22%;">Descripción</th>--}%
        <th style="width: 5%;">Cant.</th>
        <th style="width: 5%">Unidad</th>
        <th style="width: 7%">Costo <br>Unitario</th>
        <th style="width: 7%">Costo <br>Total</th>
        <th style="width: 3%;">C1</th>
        <th style="width: 3%;">C2</th>
        <th style="width: 3%;">C3</th>
%{--        <th style="width: 4%;">Con-curso.</th>--}%
        <th style="width: 6%;">Acciones</th>
%{--        <th style="width: 1%;"></th>--}%
    </tr>
    </thead>
</table>

<div class="" style="width: 100%;height: 50px; overflow-y: auto;float: right; margin-top: -20px; font-size: 14px">
    <table class="table-bordered table-condensed table-hover table-striped" style="width: 100%">
        <tbody>
        <g:if test="${pac}">
            <g:set var="total" value="${0}"/>
            <tr>
%{--                <td style="width: 5%">${pac?.anio?.anio}</td>--}%
%{--                <td style="width: 20%; font-size: 10px"class="prsp" title="${pac.presupuesto.descripcion} - Fuente: ${pac.presupuesto.fuente} - Programa: ${pac.presupuesto.programa} - Subprograma: ${pac.presupuesto.subPrograma} - Proyecto: ${pac.presupuesto.proyecto}">${pac.presupuesto.numero}</td>--}%
                <td style="width: 7%" title="${pac.cpp?.descripcion}">${pac.cpp?.numero}</td>
                <td style="width: 5%" >${pac.tipoCompra.descripcion}</td>
%{--                <td style="width: 22%">${pac.descripcion}</td>--}%
                <td style="text-align: right; width: 5%">
                    <g:formatNumber number="${pac.cantidad}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/>
                </td>
                <td style="width: 5% !important;text-align: center" class="unidad">${pac.unidad.codigo}</td>
                <td style="text-align: right; width: 7%" class="costo"><g:formatNumber number="${pac.costo}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/></td>
                <td style="text-align: right; width: 7%" class="total"><g:formatNumber number="${pac.cantidad*pac.costo}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/></td>
                <g:set var="total" value="${total+pac.cantidad*pac.costo}"/>
                <td style="text-align: center; width: 3%; ${pac?.c1 ? 'background-color: #c1ffbb' : ''}" class="c1">${pac.c1}</td>
                <td style="text-align: center; width: 3%; ${pac?.c2 ? 'background-color: #c1ffbb' : ''}" class="c2">${pac.c2}</td>
                <td style="text-align: center; width: 3%; ${pac?.c3 ? 'background-color: #c1ffbb' : ''}" class="c3">${pac.c3}</td>
%{--                <td style="text-align: center; width: 4%;" >--}%
%{--                    <a href="#" class="btn btn-info btn-xs btnIrConcurso" data-id="${pac?.id}" ><i class="fa fa-arrow-right"></i></a>--}%
%{--                </td>--}%
                <td style="width: 6%; text-align: center">
                    <a href="#" class="btn btn-success btn-xs btnEditarPac" data-id="${pac?.id}" ><i class="fa fa-edit"></i></a>
                    <a href="#" class="btn btn-danger btn-xs btnBorrarPac" data-id="${pac?.id}" ><i class="fa fa-trash"></i></a>
%{--                <td style="width: 1%"></td>--}%
            </tr>
        </g:if>
        <g:else>
            <tr>
                <td class="alert alert-warning" colspan="7" style="text-align: center;"> <h3><i class="fa fa-exclamation-triangle"></i> No existen registros</h3> </td>
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
        var partida = '${pac?.presupuesto?.id}';
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
                                cargarPAC(partida);
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