<span>Faltan: ${faltan}</span>
<div role="main" style="margin-top: 5px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 60%">Rubros del Oferente por ser Emparejados</th>
            <th style="width: 9%">Seleccionar</th>
            <th style="width: 1%"></th>
        </tr>
        </thead>
    </table>
</div>

<div style="width: 100%;height: 300px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
        <tbody>
        <g:if test="${datos.size() > 0}">
            <g:each in="${datos}" var="dt" status="i">
                <tr style="width: 100%">
                    <td style="width: 60%">${dt.ofrbnmbr}</td>
                    <td style="width: 10%; text-align: center">
                        <a href="#" class="btn btn-success btn-xs btnSeleccionarRubro" data-id="${dt?.ofrb__id}">
                            <i class="fa fa-search"></i></a>
                    </td>
                </tr>
            </g:each>
        </g:if>
        <g:else>
            <div class="alert alert-info" style="text-align: center">
                <i class="fa fa-exclamation-triangle text-info fa-2x"></i> <strong style="font-size: 14px"> No se encontraron registros </strong>
            </div>
        </g:else>
        </tbody>
    </table>
</div>


%{--<g:if test="${!datos}">--}%
%{--    <div class="row-fluid">--}%
%{--        <div class="col-md-4" style="margin-top: 10px">--}%
%{--        </div>--}%
%{--        <div class="col-md-4" style="margin-top: 10px; width: 33%">--}%
%{--            <a href="#" class="btn btn-info" id="btnCopiar" style="text-align: center; width: 100%">--}%
%{--                <i class="fa fa-edit"></i>--}%
%{--                Copiar composición a los APU del Oferente--}%
%{--            </a>--}%
%{--        </div>--}%
%{--    </div>--}%
%{--</g:if>--}%


<script type="text/javascript">

    var tbr;

    $(".btnSeleccionarRubro").click(function () {
        var id = $(this).data("id");
        var g = cargarLoader("Cargando...");
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'buscarRubrosRubros_ajax')}",
            data    : {
                id: id,
                obra: '${obra?.id}'
            },
            success : function (msg) {
                g.modal("hide");
                tbr= bootbox.dialog({
                    id    : "dlgBuscarRubro",
                    title : "Buscar rubro",
                    class : "modal-lg",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        }
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    });

    function cerrarDialogoBusquedaRubro(){
        tbr.modal("hide");
    }

    %{--$("#btnCopiar").click(function () {--}%
    %{--    var obra = $("#obra").val();--}%
    %{--    location.href = "${createLink(controller: 'rubroOf', action: 'copiarRubros')}?obra=" + obra--}%
    %{--});--}%


</script>