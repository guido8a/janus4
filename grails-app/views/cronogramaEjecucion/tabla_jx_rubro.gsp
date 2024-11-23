%{--<table class="table table-bordered table-condensed table-hover table-striped">--}%
    %{--<thead>--}%
    %{--<tr>--}%
        %{--<th rowspan="2" style="width:70px;">Código</th>--}%
        %{--<th rowspan="2" style="width:220px;">Rubro</th>--}%
        %{--<th rowspan="2" style="width:26px;">*</th>--}%
        %{--<th rowspan="2" style="width:60px;">Cantidad Unitario Total</th>--}%
        %{--<th rowspan="2" style="width:12px;">T.</th>--}%
        %{--<g:each in="${titulo1}" var="t">--}%
            %{--<th class="${t[1] == 'S' ? 'suspension' : ''}">${t[0]}</th>--}%
        %{--</g:each>--}%
        %{--<th rowspan="2">Total rubro</th>--}%
    %{--</tr>--}%
    %{--<tr>--}%
        %{--<g:each in="${titulo2}" var="t">--}%
            %{--<th class="${t[1] == 'S' ? 'suspension' : ''}">${raw(t[0])}</th>--}%
        %{--</g:each>--}%
    %{--</tr>--}%
    %{--</thead>--}%

    %{--<tbody>--}%
        <g:each in="${rubros}" var="rubro">
            <tr class="click item_row   rowSelected" data-vol="${rubro[1]}" data-vocr="${rubro[0]}">
                %{--<g:each in="${rubro}" var="val" status="i">--}%
                    %{--<g:if test="${i > 0}">--}%
                        %{--<g:if test="${i == 3}">--}%
                            %{--<td class="valor2">${raw(val)}</td>--}%
                        %{--</g:if>--}%
                        %{--<g:else>--}%
                            %{--<g:if test="${i < 5}">--}%
                                %{--<td class="valor">${raw(val)}</td>--}%
                            %{--</g:if>--}%
                            %{--<g:else>--}%
                                %{--<td class="numero">${raw(val)}</td>--}%
                            %{--</g:else>--}%
                        %{--</g:else>--}%
                    %{--</g:if>--}%
                %{--</g:each>--}%
                <g:each in="${rubro}" var="val" status="i">
                    <g:if test="${i > 0}">
                        <g:if test="${i == 3}">
                            <td class="valor2">${raw(val)}</td>
                        </g:if>
                        <g:else>
                            <g:if test="${i < 5}">
                                <td class="valor">${raw(val)}</td>
                            </g:if>
                            <g:else>
                                <td class="numero">${raw(val)}</td>
                            </g:else>
                        </g:else>
                    </g:if>
                </g:each>
            </tr>
        </g:each>

        %{--<tr class="pie">--}%
            %{--<td class="valor" colspan="3" style="text-align: right; font-weight: bold">TOTAL PARCIAL</td>--}%
            %{--<td class="valor" colspan="2" style="text-align: right; font-weight: bold">${suma}</td>--}%
            %{--<g:each in="${totales}" var="tot" status="i">--}%
                %{--<td class="totales">${raw(tot)}</td>--}%
            %{--</g:each>--}%
        %{--</tr>--}%
        %{--<tr class="pie2">--}%
            %{--<td class="valor" colspan="3" style="text-align: right; font-weight: bold">TOTAL ACUMULADO</td>--}%
            %{--<td colspan="2"></td>--}%
            %{--<g:each in="${total_ac}" var="tot" status="i">--}%
                %{--<td class="totales">${raw(tot)}</td>--}%
            %{--</g:each>--}%
        %{--</tr>--}%
        %{--<tr class="pie">--}%
            %{--<td class="valor" colspan="3" style="text-align: right; font-weight: bold">% TOTAL PARCIAL</td>--}%
            %{--<td colspan="2"></td>--}%
            %{--<g:each in="${ttpc}" var="tot" status="i">--}%
                %{--<td class="totales">${raw(tot)}</td>--}%
            %{--</g:each>--}%
        %{--</tr>--}%
        %{--<tr class="pie2">--}%
            %{--<td class="valor" colspan="3" style="text-align: right; font-weight: bold">% TOTAL ACUMULADO</td>--}%
            %{--<td colspan="2"></td>--}%
            %{--<g:each in="${ttpa}" var="tot" status="i">--}%
                %{--<td class="totales">${raw(tot)}</td>--}%
            %{--</g:each>--}%
        %{--</tr>--}%

    %{--</tbody>--}%
%{--</table>--}%
%{--</html>--}%

<script type="text/javascript">

    function editarFila(vol){
        $.ajax({
            type: "POST",
            url: "${createLink(action: 'modificacionNuevo_ajax')}",
            data: {
                contrato: "${contrato}",
                vol: vol
            },
            success: function (msg) {

                var b = bootbox.dialog({
                    id      : "dlgCreateEditModif",
                    title   : "Modificación",
                    message : msg,
                    class: 'modal-lg',
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
                                var data = "obra=${janus.Contrato.get(contrato)?.obra?.id}";
                                $(".tiny").each(function () {
                                    var tipo = $(this).data("tipo");
                                    var val = parseFloat($(this).val());
                                    var crono = $(this).data("id");
                                    var periodo = $(this).data("id2");
                                    var vol = $(this).data("id3");
                                    data += "&" + (tipo + "=" + val + "_" + periodo + "_" + vol + "_" + crono);
                                });
                                $.ajax({
                                    type: "POST",
                                    url: "${createLink(action:'modificacionNuevo')}",
                                    data: data,
                                    success: function (msg) {
                                        b.modal("hide");
                                        updateTabla();
                                    }
                                });
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            }
        });
    }



    function createContextMenu(node) {
        var $tr = $(node);
        var items = {
            header: {
                label: "Acciones",
                header: true
            }
        };

        var id = $tr.data("vocr");

        var editar = {
            label: "Modificación",
            icon: "fa fa-edit",
            action : function ($element) {
                editarFila(id);
            }
        };
        var cargar = {
            label: "Cargar",
            icon: "fa fa-check",
            action : function ($element) {
                cargarFila(id);
            }
        };

        if(${janus.Contrato.get(contrato)?.fiscalizador?.id == session.usuario.id}){
            items.editar = editar;
            items.cargar = cargar;
        }

        return items
    }

    $("tr").contextMenu({
        items  : createContextMenu,
        onShow : function ($element) {
            $element.addClass("trHighlight");
        },
        onHide : function ($element) {
            $(".trHighlight").removeClass("trHighlight");
        }
    });


</script>