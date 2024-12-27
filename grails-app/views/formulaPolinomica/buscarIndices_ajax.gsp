<div class="row">

    <div class="col-md-12">
        <div class="alert alert-info " style="text-align: center; font-weight: bold; font-size: 14px"> Índice actual : ${formula?.indice?.descripcion ?: 'Ninguno'}</div>
    </div>

    <div class="col-md-12" style="margin-bottom: 10px; text-align: center">
        <div class="alert-success" style="text-align: center; font-weight: bold; font-size: 14px; margin-bottom: 10px"> Valor </div>

        <div class="form-group">
            <span class="grupo">
                <span class="col-md-2"></span>

                <label class="col-md-3 control-label text-info">
                    Modificar valor
                </label>
                <span class="col-md-3">
                    <g:textField name="valor" required="" class="form-control allCaps number required" value="${formula?.valor}" />
                </span>
                <span class="col-md-1">
                    <a href="#" class="btn btn-success btnGuardarValor" data-id="${formula?.id}"><i class="fa fa-save"></i>Guardar</a>
                </span>
            </span>
        </div>
    </div>

    <div class="col-md-12">

        <div class="alert-success" style="text-align: center; font-weight: bold; font-size: 14px"> Sugeridos </div>

        <div role="main" style="margin-top: 5px;">
            <table class="table table-bordered table-striped table-condensed table-hover">
                <thead>
                <tr>
                    <th style="width: 15%">Código</th>
                    <th style="width: 70%">Descripción</th>
                    <th style="width: 15%">Seleccionar</th>
                </tr>
                </thead>
            </table>
        </div>

        <div class="" style="width: 99.7%;height: 350px; overflow-y: auto;float: right; margin-top: -20px">
            <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
                <tbody>
                <g:if test="${indices}">
                    <g:each in="${indices}" var="indice" status="i">
                        <tr>
                            <td style="width: 15%">${indice?.indccdgo}</td>
                            <td style="width: 70%">${indice?.indcdscr}</td>
                            <td style="width: 15%">
                                <a href="#" class="btn btn-success btn-xs btnSeleccionarIndice" data-id="${indice?.indc__id}"><i class="fa fa-check"></i></a>
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
    </div>
</div>

<script type="text/javascript">

    $(".btnSeleccionarIndice").click(function () {
        var indice = $(this).data("id");
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'formulaPolinomica', action:'guardarIndice_ajax')}",
            data    : {
                id: '${formula?.id}',
                indice: indice
            },
            success : function (msg) {
                var parts = msg.split("_");
                if(parts[0] === 'ok'){
                    log(parts[1], "success");
                    cerrarBusquedaIndices();
                    cargarFormulaPolinomica('${tipo}');
                    cargarItemsNuevos('${formula?.id}')
                }else{
                    log(parts[1], "error")
                }
            } //success
        }); //ajax
    });

</script>

