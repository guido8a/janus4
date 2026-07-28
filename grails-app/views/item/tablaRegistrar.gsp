<asset:javascript src="/Toggle-Button-Checkbox/js/bootstrap-checkbox.js"/>

<table class="table table-bordered table-striped table-hover table-condensed" >
    <thead>
    <tr style="width: 100%">
        <th style="width: 15%">Código</th>
        <th style="width: 35%">Item</th>
        <th style="width: 10%">Unidad</th>
        <th style="width: 15%">Precio</th>
        <th style="width: 10%">Fecha</th>
        <th style="width: 15%">
            <a href="#" class="btn btn-success" title="Marcar todos para registrar" id="seleccionar"><i class="icon-check"></i>Marcar Todos</a>
        </th>
    </tr>
    </thead>
</table>

<div class="" style="width: 99.7%;height: 400px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
        <tbody>
        <g:each in="${rubroPrecio}" var="rubro" status="i">
            <tr style="width: 100%">
                <td style="width: 15%" class="itemId">
                    ${rubro?.item?.codigo}
                </td>
                <td style="width: 35%" class="itemNombre">
                    ${rubro?.item?.nombre}
                </td>
                <td style="width: 10%" class="unidad" >
                    ${rubro?.item?.unidad?.descripcion}
                </td>
                <td style="width: 15%" class="editable alineacion" id="${rubro?.id}" data-original="${rubro?.precioUnitario}" data-valor="${rubro?.precioUnitario}">
                    <g:formatNumber number="${rubro?.precioUnitario}" minFractionDigits="5" maxFractionDigits="5" format="##,#####0" locale="ec"/>
                </td>
                <td style="width: 10%" class="fecha" >
                    <g:formatDate date="${rubro?.fecha}" format="dd-MM-yyyy"/>
                </td>
                <td style="width: 15%; text-align: center" class="chk">
                    <g:if test="${rubro?.registrado == 'R'}">
                        <i class="fa fa-check"></i>
                    </g:if>
                    <g:else>
                        <g:checkBox name="chequear" class="chequear form-control" data-on-Label="Si" checked="${rubro?.registrado == 'R' ?: false}"/>
                    </g:else>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>


<script type="text/javascript">

    $(function () {

        $(".chequear").checkboxpicker({
        });

        // $(".editable").first().addClass("selected");

        $("#dlgLoad").dialog("close");
    });

    $("#seleccionar").click(function(){
        $(".chequear")[0].checked ? $(".chequear").prop("checked", false) : $(".chequear").prop("checked", true);
    });
</script>

