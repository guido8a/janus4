<div role="main" style="margin-top: 5px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 12%">Código</th>
            <th style="width: 72%">Descripción</th>
            <th style="width: 8%">Seleccionar</th>
            <th style="width: 1%"></th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover">
        <tbody>
        <g:if test="${datos}">
            <g:each in="${datos}" var="dt" status="i">
                <tr>
                    <td style="width: 9%">${dt.codigo}</td>
                    <td style="width: 69%">${dt.nombre}</td>
                    <td style="width: 9%">
                            <a href="#" class="btn btn-success btn-xs btnSeleccionar" data-id="${dt?.dtrb__id}"><i class="fa fa-arrow-right"></i></a>
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

%{--    $(".btnSeleccionar").click(function () {--}%
%{--        var id = $(this).data("id");--}%

%{--        var g = cargarLoader("Guardando...");--}%
%{--        $.ajax({--}%
%{--            type: "POST",--}%
%{--            url: "${createLink(controller: 'rubro', action:'agrearItem_ajax')}",--}%
%{--            data: {--}%
%{--                id: id,--}%
%{--                rubro: '${rubro?.id}'--}%
%{--            },--}%
%{--            success: function (msg) {--}%
%{--                g.modal("hide");--}%
%{--                var parts = msg.split("_");--}%
%{--                if(parts[0] === 'ok'){--}%
%{--                    log(parts[1], "success");--}%
%{--                    cargarTablaSeleccionados();--}%
%{--                }else{--}%
%{--                    if(parts[0] === 'err'){--}%
%{--                        bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');--}%
%{--                        return false;--}%
%{--                    }else{--}%
%{--                        log(parts[1], "error")--}%
%{--                    }--}%
%{--                }--}%
%{--            }--}%
%{--        });--}%
%{--    })--}%

</script>