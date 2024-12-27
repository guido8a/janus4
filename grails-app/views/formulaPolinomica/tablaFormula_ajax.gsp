<div role="main" style="margin-top: 5px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 15%">Coef.</th>
            <th style="width: 45%">Nombre del indice</th>
            <th style="width: 15%">Valor</th>
            <th style="width: 14%">Acciones</th>
            <th style="width: 1%"></th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 350px; overflow-y: auto; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%;">
        <tbody>
        <g:if test="${res}">
            <g:each in="${res}" var="indice" status="i">
                <tr class="trFP" data-id="${indice?.id}">
                    <td style="width: 15%">${indice?.numero}</td>
                    <td style="width: 45%">${indice?.indice?.descripcion}</td>
                    <td style="width: 15%">${indice?.valor}</td>
                    <td style="width: 15%; text-align: center">
                        <g:if test="${indice?.numero != 'p01'}">
                            <g:if test="${indice?.numero != 'px '}">
                                <a href="#" class="btn btn-success btn-xs btnBuscarIndice" data-id="${indice?.id}"><i class="fa fa-info"></i></a>
                            </g:if>
                        </g:if>
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

<script type="text/javascript">

    $(".trFP").click(function () {
        var id = $(this).data("id");
        cargarItemsNuevos(id);
    });

    var bi;

    $(".btnBuscarIndice").click(function () {
        var id = $(this).data("id");
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'formulaPolinomica', action:'buscarIndices_ajax')}",
            data    : {
                obra: '${obra?.id}',
                subpresupuesto: '${subpresupuesto?.id}',
                id: id,
                tipo: '${tipo}'
            },
            success : function (msg) {
               bi = bootbox.dialog({
                    id    : "dlgBuscarIndices",
                    title : "Buscar Indices",
                    // class : "modal-lg",
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

    function cerrarBusquedaIndices(){
        bi.modal("hide");
    }

</script>