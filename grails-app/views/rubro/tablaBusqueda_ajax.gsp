<div role="main" style="margin-top: 10px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 10%">Código</th>
            <th style="width: 72%">Descripción</th>
            <th style="width: 8%">Unidad</th>
            <th style="width: 8%">Seleccionar</th>
            <th style="width: 1%"></th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
        <tbody>
        <g:each in="${data}" var="dt" status="i">
            <tr>
                <td style="width: 9%">${dt.itemcdgo}</td>
                <td style="width: 71%">${dt.itemnmbr}</td>
                <td style="width: 8%">
                    ${dt.unddcdgo}
                </td>
                <td style="width: 8%">
                    <div style="text-align: center" class="selecciona" id="reg_${i}"
                         regNmbr="${dt?.itemnmbr}" regCdgo="${dt?.itemcdgo}"
                         regUn="${dt?.unddcdgo}" data-id="${dt?.item__id}" data-tpl="${dt?.tpls__id}">
                        <button class="btn btn-xs btn-success"><i class="fa fa-check"></i></button>
                    </div></td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>

<script type="text/javascript">

    %{--$(".btnLogo").click(function () {--}%
    %{--    var id = $(this).data("id");--}%
    %{--    cargarLogo(id);--}%
    %{--});--}%

    %{--$(".btnEditar").click(function () {--}%
    %{--    var id = $(this).data("id");--}%
    %{--    createEditRow(id);--}%
    %{--});--}%

    %{--$(".btnEliminar").click(function () {--}%
    %{--    var id = $(this).data("id");--}%
    %{--    deleteRow(id);--}%
    %{--});--}%

    %{--$(".btnPacientes").click(function () {--}%
    %{--    var id = $(this).data("id");--}%
    %{--    location.href="${createLink(controller: 'paciente', action: 'list')}/" + id;--}%
    %{--});--}%

    %{--function cargarLogo(id) {--}%
    %{--    $.ajax({--}%
    %{--        type    : "POST",--}%
    %{--        url     : "${createLink(controller: 'empresa', action:'logoEmpresa_ajax')}",--}%
    %{--        data    : {--}%
    %{--            id: id--}%
    %{--        },--}%
    %{--        success : function (msg) {--}%
    %{--            di = bootbox.dialog({--}%
    %{--                id      : "dlgFoto",--}%
    %{--                title   : "Logo",--}%
    %{--                message : msg,--}%
    %{--                buttons : {--}%
    %{--                    cancelar : {--}%
    %{--                        label     : "<i class='fa fa-times'></i> Cerrar",--}%
    %{--                        className : "btn-gris",--}%
    %{--                        callback  : function () {--}%
    %{--                        }--}%
    %{--                    }--}%
    %{--                } //buttons--}%
    %{--            }); //dialog--}%
    %{--        } //success--}%
    %{--    }); //ajax--}%
    %{--} //createEdit--}%
</script>