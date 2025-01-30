
<div class="col-md-12 breadcrumb" style="margin-top: -10px; font-size: 14px">
    <div class="col-md-2">
        <label>
            Item:
        </label>
    </div>
    <div class="col-md-8">
        ${item.nombre} (${item.unidad?.codigo?.trim()})
    </div>
</div>
<div class="col-md-12 breadcrumb" style="margin-top: -10px; font-size: 14px">
    <div class="col-md-2">
        <label>
            Lista:
        </label>
    </div>
    <div class="col-md-8">
        ${lugarNombre}
    </div>
</div>

<div style="height: 35px; width: 100%;">
    <g:if test="${session.perfil.codigo in ['CSTO', 'RBRO']}">
        <div class="btn-group pull-left">
            <a href="#" class="btn btn-danger btnBorrarTodos" >
                <i class="fa fa-trash"></i>
                Borrar todos
            </a>
        </div>
    </g:if>
</div>

<div id="divTabla" style="height: 400px; width: 100%; overflow-x: hidden; overflow-y: auto;">
    <table class="table table-striped table-bordered table-hover table-condensed" id="tablaPrecios">
        <thead>
        <tr style="width: 100%">
                <th style="width: 29%">Lugar</th>
            <th style="width: 20%">Fecha</th>
            <th class="precio" style="width: 20%">Precio</th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${precios}" var="precio" status="i">
            <tr style="width: 100%">
                    <td style="width: 29%">
                        ${precio.lugar.descripcion}
                    </td>
                <td style="width: 20%">
                    <g:formatDate date="${precio.fecha}" format="dd-MM-yyyy"/>
                </td>
                <td class="precio textRight " style="width: 20%; text-align: right" data-original="${precio.precioUnitario}" data-valor="${precio.precioUnitario}" id="${precio.id}" >
                    <g:formatNumber number="${precio.precioUnitario}" maxFractionDigits="5" minFractionDigits="5" format="##,#####0" locale='ec'/>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>

<script type="text/javascript">

    function borrarPrecio(id) {
        var lugar = '${lugar?.id}';
        var item = '${item?.id}';
        bootbox.dialog({
            title   : "Alerta",
            message : "<i class='fa fa-trash fa-2x pull-left text-danger text-shadow'></i><p style='font-weight: bold'> Está seguro que desea eliminar este precio? Esta acción no se puede deshacer.</p>",
            buttons : {
                cancelar : {
                    label     : "Cancelar",
                    className : "btn-primary",
                    callback  : function () {
                    }
                },
                eliminar : {
                    label     : "<i class='fa fa-trash'></i> Eliminar",
                    className : "btn-danger",
                    callback  : function () {
                        var v = cargarLoader("Eliminando...");
                        $.ajax({
                            type    : "POST",
                            url     : '${createLink(action:'deletePrecio_ajax')}',
                            data    : {
                                id : id
                            },
                            success : function (msg) {
                                v.modal("hide");
                                var parts = msg.split("_");
                                if(parts[0] === 'OK'){
                                    log(parts[1],"success");
                                    cargarTablaItemsPrecios();
                                    cerrarTablaHistoricos();
                                    cargarTablaHistoricoPrecios(item, lugar)
                                }else{
                                    log(parts[1],"error")
                                }
                            }
                        });
                    }
                }
            }
        });
    }



</script>