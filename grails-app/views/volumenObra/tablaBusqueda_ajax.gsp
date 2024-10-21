<div role="main" style="margin-top: 5px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 12%">Código</th>
            <th style="width: 72%">Descripción</th>
            <th style="width: 10%">Unidad</th>
            <th style="width: 8%">Seleccionar</th>
            <th style="width: 1%"></th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover">
        <tbody>
        <g:if test="${data}">
            <g:each in="${data}" var="dt" status="i">
                <tr>
                    <td style="width: 9%">${dt.itemcdgo}</td>
                    <td style="width: 69%">${dt.itemnmbr}</td>
                    <td style="width: 10%">
                        ${dt.unddcdgo}
                    </td>
                    <td style="width: 9%">
                        <a href="#" class="btn btn-success btn-xs btnSeleccionar" data-id="${dt?.item__id}"><i class="fa fa-check"></i></a>
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


    $(".btnSeleccionar").click(function () {
        var id = $(this).data("id");
        editarFormVolObra(id);
    });

    function editarFormVolObra(id) {
        $.ajax({
            type    : "POST",
            url: "${createLink(controller: 'volumenObra', action:'formRubroVolObra_ajax')}",
            data    : {
                id: id,
                obra: '${}'
            },
            success : function (msg) {
                var er = bootbox.dialog({
                    id      : "dlgCreateEditRubroVO",
                    title   : "Agregar rubro",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        guardar  : {
                            id        : "btnSave",
                            label     : "<i class='fa fa-save'></i> Guardar",
                            className : "btn-success",
                            callback  : function () {
                                return submitFormRubroVolObra();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    } //createEdit



</script>