<table class="table table-bordered table-striped table-hover table-condensed" id="tabla">
    <thead>
    <tr>
        <th style="width: 10%">Código</th>
        <th style="width: 35%">Nombre</th>
        <th style="width: 29%">Dirección</th>
        <th style="width: 10%">Fecha</th>
        <th style="width: 11%">Estado</th>
        <th style="width: 4%"></th>
        <th style="width: 1%"></th>
    </tr>
    </thead>
</table>

<div class="" style="width: 99.7%;height: 420px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover" style="width: 100%">
        <g:if test="${data}">
            <g:each in="${data}" var="dt" status="i">
                <tr>
                    <td style="width: 10%">${dt.obracdgo}</td>
                    <td style="width: 35%">${dt.obranmbr}</td>
                    <td style="width: 29%"> ${dt.dptodscr}
                    <td style="width: 10%"> ${dt.obrafcha}
                    <td style="width: 11%"> ${dt.obraetdo == 'R' ? 'Registrado' : 'No registrado'}
                    </td>
                    <td style="width: 4%">
                        <div style="text-align: center" class="selecciona" id="reg_${i}" data-codigo="${dt?.obracdgo}" data-id="${dt?.obra__id}" data-valor="${dt?.obravlor}">
                            <button class="btn btn-xs btn-success"><i class="fa fa-check"></i></button>
                        </div>
                    </td>
                    <td style="width: 1%"></td>
                </tr>
            </g:each>
        </g:if>
        <g:else>
            <div class="alert alert-info" style="text-align: center">
                <i class="fa fa-exclamation-triangle text-info fa-2x"></i> <strong style="font-size: 14px"> No se encontraron registros </strong>
            </div>
        </g:else>
    </table>
</div>

<script type="text/javascript">
    $(".selecciona").click(function () {
        var id = $(this).data("id");
        var codigo = $(this).data("codigo");
        var valor = $(this).data("valor");
        <g:if test="${tipo == '1'}">
        $("#obraC").val(id);
        $("#obraNameC").val(codigo).focus();
        </g:if>
        <g:else>
        $("#obra").val(id);
        $("#obraName").val(codigo);
        $("#presupuestoReferencial").val(valor).focus();
        </g:else>

        cerrarBuscadorObras();
    });
</script>