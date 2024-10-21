<div class="alert alert-info" style="margin-top: 10px; text-align: center">
    <i class="fa fa-list"></i> <strong style="font-size: 16px"> Rubros en volúmenes de obra</strong>
</div>

<div role="main" style="margin-top: 10px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 25%">Subpresupuesto</th>
            <th style="width: 16%">Código</th>
            <th style="width: 43%">Descripción</th>
            <th style="width: 10%">Cantidad</th>
            <th style="width: 8%">Acciones</th>
            <th style="width: 1%"></th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 525px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
        <tbody>
        <g:if test="${valores}">
            <g:each in="${valores}" var="val" status="i">
                <tr>
                    <td style="width: 24%; font-size: 10px">${val.sbprdscr}</td>
                    <td style="width: 15%; font-size: 10px">${val.rbrocdgo}</td>
                    <td style="width: 40%; font-size: 12px">${val.rbronmbr}</td>
                    <td style="width: 10%"><g:formatNumber number="${val.vlobcntd}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/></td>
                    <td style="width: 9%">
                        <a href="#" class="btn btn-danger btn-xs btnBorrarSeleccion" data-id="${val.vlob__id}" ><i class="fa fa-trash"></i></a>
                    </td>
                    <td style="width: 1%"></td>
                </tr>
            </g:each>
        </g:if>
        <g:else>
            <div class="alert alert-info" style="text-align: center">
                <i class="fa fa-exclamation-triangle text-info fa-2x"></i> <strong style="font-size: 14px"> Ningún rubro agregado al subpresupuesto </strong>
            </div>
        </g:else>
        </tbody>
    </table>
</div>

<script type="text/javascript">

    %{--$(".btnBorrarSeleccion").click(function () {--}%
    %{--    var id = $(this).data("id");--}%
    %{--    bootbox.confirm({--}%
    %{--        title: "Eliminar",--}%
    %{--        message: "<i class='fa fa-exclamation-triangle text-info fa-3x'></i> <strong style='font-size: 14px'> Está seguro de eliminar este registro?</strong> ",--}%
    %{--        buttons: {--}%
    %{--            cancel: {--}%
    %{--                label: '<i class="fa fa-times"></i> Cancelar',--}%
    %{--                className: 'btn-primary'--}%
    %{--            },--}%
    %{--            confirm: {--}%
    %{--                label: '<i class="fa fa-trash"></i> Borrar',--}%
    %{--                className: 'btn-danger'--}%
    %{--            }--}%
    %{--        },--}%
    %{--        callback: function (result) {--}%
    %{--            if(result){--}%
    %{--                $.ajax({--}%
    %{--                    type : "POST",--}%
    %{--                    url : "${g.createLink(controller: 'rubro',action:'verificaRubro')}",--}%
    %{--                    data     : {--}%
    %{--                        id : '${rubro?.id}'--}%
    %{--                    },--}%
    %{--                    success  : function (msg) {--}%
    %{--                        var resp = msg.split('_');--}%
    %{--                        if(resp[0] === "1"){--}%
    %{--                            var ou = cargarLoader("Cargando...");--}%
    %{--                            $.ajax({--}%
    %{--                                type : "POST",--}%
    %{--                                url : "${g.createLink(controller: 'rubro',action:'listaObrasUsadas_ajax')}",--}%
    %{--                                data     : {--}%
    %{--                                    id : '${rubro?.id}'--}%
    %{--                                },--}%
    %{--                                success  : function (msg) {--}%
    %{--                                    ou.modal("hide");--}%
    %{--                                    var b = bootbox.dialog({--}%
    %{--                                        id      : "dlgLOU",--}%
    %{--                                        title   : "Lista de obras usadas",--}%
    %{--                                        message : msg,--}%
    %{--                                        buttons : {--}%
    %{--                                            cancelar : {--}%
    %{--                                                label     : "Cancelar",--}%
    %{--                                                className : "btn-primary",--}%
    %{--                                                callback  : function () {--}%
    %{--                                                }--}%
    %{--                                            }--}%
    %{--                                        } //buttons--}%
    %{--                                    }); //dialog--}%
    %{--                                }--}%
    %{--                            });--}%
    %{--                        }else{--}%
    %{--                            $.ajax({--}%
    %{--                                type : "POST",--}%
    %{--                                url : "${g.createLink(controller: 'rubro',action:'eliminarRubroDetalle')}",--}%
    %{--                                data     : "id=" + boton.attr("iden"),--}%
    %{--                                success  : function (msg) {--}%
    %{--                                    if (msg === "Registro eliminado") {--}%
    %{--                                        cargarTablaSeleccionados();--}%
    %{--                                    }else{--}%
    %{--                                        bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + msg  + '</strong>');--}%
    %{--                                    }--}%
    %{--                                }--}%
    %{--                            });--}%
    %{--                        }--}%
    %{--                    }--}%
    %{--                });--}%
    %{--            }--}%
    %{--        }--}%
    %{--    });--}%
    %{--});--}%



</script>