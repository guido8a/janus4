<div role="main" style="margin-top: 5px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 12%">Número</th>
            <th style="width: 72%">Descripción</th>
            <th style="width: 10%">Unitario</th>
            <th style="width: 8%">Porcentaje</th>
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
                    <td style="width: 9%">${dt.cstonmro}</td>
                    <td style="width: 69%">${dt.cstodscr}</td>
                    <td style="width: 10%">${dt.prcspcun}</td>
                    <td style="width: 10%">${dt.prcspcnt} %</td>
                    <td style="width: 9%">
                            <a href="#" class="btn btn-success btn-xs btnSeleccionar" data-id="${dt?.csto__id}"><i class="fa fa-check"></i></a>
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



    // $(".btnSeleccionar").click(function () {
    //     var rubro = $(this).data("id");
    //     var existe = verificarEstadoVO(rubro);
    //
    //     if(existe){
    //         formVolObraExistente(rubro)
    //     }else{
    //         editarFormVolObra(null, rubro);
    //     }
    // });

</script>