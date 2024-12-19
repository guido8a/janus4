<div class="col-md-3 formato" style="width: 280px;">Destino: Dirección
<g:select style="width: 280px;" name="direccionDestino.id" from="${dire}" optionKey="id" optionValue="nombre"
          value="${obra?.direccionDestino?.id}" title="Destino de documentos" noSelection="['null': 'Seleccione ...']"/>
</div>

<div class="col-md-3 formato" style="width: 280px; margin-left: 10px">Destino: Coordinación
<g:select style="width: 280px;" name="departamentoDestino.id" from="${depar}" optionKey="id" optionValue="descripcion" value="${obra?.departamentoDestino?.id}" title="Destino de documentos" noSelection="['null': 'Seleccione ...']"/>
</div>

<div class="col-md-1 formato" style="width: 120px;margin-left: 30px;">Informe
<g:textField name="oficioSalida" class="allCaps" value="${obra?.oficioSalida}" maxlength="20" title="Número Oficio de Salida" style="width: 120px;"/>
</div>

<div class="col-md-1 formato" style="width: 80px; margin-left: 10px;">Fecha
    <input aria-label="" name="fechaOficioSalida" id='fechaOficioSalida' type='text' class="required input-small"
           value="${obra?.fechaOficioSalida?.format('dd-MM-yyyy') ?: fcha.format('dd-MM-yyyy')}"
           style="width: 80px"/>
</div>

<div class="col-md-1 formato" style="width: 120px; margin-left: 20px;">Memorando
<g:textField name="memoSalida" class="allCaps" value="${obra?.memoSalida}" maxlength="20" title="Memorandum de salida" style="width: 120px;"/>
</div>

<g:if test="${obra?.id && obra?.tipo != 'D'}">
    <div class="col-md-2 formato" style="margin-left: 20px;">Fórmula P.
    %{--    <g:if test="${obra?.formulaPolinomica && obra?.formulaPolinomica != ''}">--}%
    <g:textField name="formulaPolinomica" class="allCaps"  maxlength="20" title="Fórmula Polinómica" style="width: 120px;" value="${obra?.formulaPolinomica}" readonly=""/>

        <g:if test="${!obra?.formulaPolinomica}">
            <a href="#" class="btn btn-xs btn-success btnGenerarCodigoFP" data-id="${obra?.id}" title="Generar código de la formula polinómica">
                <i class="fa fa-check"></i>
            </a>
        </g:if>


        %{--    </g:if>--}%
        %{--    <g:else>--}%
        %{--        <g:textField name="formulaPolinomica" class="allCaps"  maxlength="20" title="Fórmula Polinómica" style="width: 120px;"/>--}%
        %{--    </g:else>--}%
    </div>
</g:if>


<script type="text/javascript">

    $('#fechaOficioSalida').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        // daysOfWeekDisabled: [0, 6],
        sideBySide: true,
        widgetPositioning: {
            horizontal: "left",
            vertical: "auto"
        },
        icons: {
        }
    });

    $(".btnGenerarCodigoFP").click(function () {
        var id = $(this).data("id");
        bootbox.confirm({
            title: "Generar código de la Formula Polinómica",
            message: '<i class="fa fa-trash text-danger fa-3x"></i>' + '<strong style="font-size: 14px">' + "Está seguro de generar el código de la Formula Polinómica?" + '</strong>' ,
            buttons: {
                cancel: {
                    label: '<i class="fa fa-times"></i> Cancelar',
                    className: 'btn-primary'
                },
                confirm: {
                    label: '<i class="fa fa-check"></i> Aceptar',
                    className: 'btn-success'
                }
            },
            callback: function (result) {
                if(result){
                    var dialog = cargarLoader("Guardando...");
                    $.ajax({
                        type: 'POST',
                        url: '${createLink(controller: 'obra', action: 'generarCodigoFP_ajax')}',
                        data:{
                            id: id
                        },
                        success: function (msg) {
                            dialog.modal('hide');
                            var parts = msg.split("_");
                            if(parts[0] === 'ok'){
                                log(parts[1],"success");
                                setTimeout(function () {
                                    location.href = "${g.createLink(action: 'registroObra')}" + "?obra=" + "${obra?.id}";
                                }, 1000);
                            }else{
                                log(parts[1], "error")
                            }
                        }
                    });
                }
            }
        });
    });

    %{--$("#btnGenerarFP").click(function () {--}%
    %{--    var btn = $(this);--}%
    %{--    var $btn = btn.clone(true);--}%
    %{--    $.box({--}%
    %{--        imageClass : "box_info",--}%
    %{--        text       : "Una vez generado el número de fórmula polinómica no se puede revertir y se utlizará el siguiente de la secuencia. ¿Está seguro de querer continuar?",--}%
    %{--        title      : "Alerta",--}%
    %{--        iconClose  : false,--}%
    %{--        dialog     : {--}%
    %{--            resizable : false,--}%
    %{--            draggable : false,--}%
    %{--            buttons   : {--}%
    %{--                "Generar"  : function () {--}%
    %{--                    btn.replaceWith(spinner);--}%
    %{--                    $.ajax({--}%
    %{--                        type    : "POST",--}%
    %{--                        url     : "${createLink(action: 'generaNumeroFP')}",--}%
    %{--                        data    : "obra=${obra?.id}",--}%
    %{--                        success : function (msg) {--}%
    %{--                            var parts = msg.split("_");--}%
    %{--                            if (parts[0] == "OK") {--}%
    %{--                                spinner.replaceWith("<div style='font-weight: normal;'>" + parts[1] + "</div>");--}%
    %{--                            } else {--}%
    %{--                                $.box({--}%
    %{--                                    imageClass : "box_info",--}%
    %{--                                    text       : parts[1],--}%
    %{--                                    title      : "Errores",--}%
    %{--                                    iconClose  : false,--}%
    %{--                                    dialog     : {--}%
    %{--                                        resizable : false,--}%
    %{--                                        draggable : false,--}%
    %{--                                        buttons   : {--}%
    %{--                                            "Aceptar" : function () {--}%
    %{--                                            }--}%
    %{--                                        }--}%
    %{--                                    }--}%
    %{--                                });--}%
    %{--                                spinner.replaceWith($btn);--}%
    %{--                            }--}%
    %{--                        }--}%
    %{--                    });--}%
    %{--                },--}%
    %{--                "Cancelar" : function () {--}%
    %{--                }--}%
    %{--            }--}%
    %{--        }--}%
    %{--    });--}%
    %{--    return false;--}%
    %{--});--}%
</script>