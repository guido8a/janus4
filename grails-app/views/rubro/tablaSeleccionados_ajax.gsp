<div class="alert alert-info" style="margin-top: 10px; text-align: center">
       <i class="fa fa-list"></i> <strong style="font-size: 16px"> Rubros en la composición </strong>
</div>

<div class="col-md-12" style="margin-bottom: 5px">
    <div class="col-md-3 alert-warning">Equipos</div>
    <div class="col-md-1"></div>
    <div class="col-md-3 alert-success">Mano Obra</div>
    <div class="col-md-1"></div>
    <div class="col-md-3 alert-info">Materiales</div>
</div>

<div role="main" style="margin-top: 10px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 17%">Código</th>
            <th style="width: 75%">Descripción</th>
            <th style="width: 9%">Acciones</th>
            <th style="width: 1%"></th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
        <tbody>
        <g:if test="${items}">
            %{--<g:each in="${items}" var="item" status="i">--}%
                %{--<tr class="${item?.item?.departamento?.subgrupo?.grupo?.id == 1 ? 'alert alert-info' : (item?.item?.departamento?.subgrupo?.grupo?.id == 2 ? 'alert alert-success' : 'alert alert-warning')}">--}%
                    %{--<td style="width: 15%">${item.item.codigo}</td>--}%
                    %{--<td style="width: 70%">${item.item.nombre}</td>--}%
                    %{--<td style="width: 12%">--}%
                        %{--<g:if test="${!volumenes}">--}%
                            %{--<a href="#" class="btn btn-danger btn-xs btnBorrarSeleccion" data-id="${item?.id}" ><i class="fa fa-trash"></i></a>--}%
                        %{--</g:if>--}%
                    %{--</td>--}%
                %{--</tr>--}%
            %{--</g:each>--}%
            <g:each in="${items}" var="item" status="i">
                <tr class="${item?.grpo__id == 1 ? 'alert alert-info' : (item?.grpo__id == 2 ? 'alert alert-success' : 'alert alert-warning')}">
                    <td style="width: 15%">${item.itemcdgo}</td>
                    <td style="width: 70%">${item.itemnmbr}</td>
                    <td style="width: 12%">
                        %{--<g:if test="${!volumenes}">--}%
                        <a href="#" class="btn btn-danger btn-xs btnBorrarSeleccion" data-id="${item?.rbro__id}">
                        <i class="fa fa-trash"></i></a>
                        %{--</g:if>--}%
                    </td>
                </tr>
            </g:each>
        </g:if>
        <g:else>
            <div class="alert alert-info" style="text-align: center">
                <i class="fa fa-exclamation-triangle text-info fa-2x"></i> <strong style="font-size: 14px"> Ningún item agregado a la composición </strong>
            </div>
        </g:else>
        </tbody>
    </table>
</div>

<script type="text/javascript">

    $(".btnBorrarSeleccion").click(function () {
        var id = $(this).data("id");
        bootbox.confirm({
            title: "Eliminar",
            message: "<i class='fa fa-exclamation-triangle text-info fa-3x'></i> " +
                "<strong style='font-size: 14px'> Está seguro de eliminar este registro?</strong> ",
            buttons: {
                cancel: {
                    label: '<i class="fa fa-times"></i> Cancelar',
                    className: 'btn-primary'
                },
                confirm: {
                    label: '<i class="fa fa-trash"></i> Borrar',
                    className: 'btn-danger'
                }
            },
            callback: function (result) {
                if(result){
                    $.ajax({
                        type : "POST",
                        url : "${g.createLink(controller: 'rubro', action:'eliminarRubro_ajax')}",
                        data     : {
                            id : id
                        },
                        success  : function (msg) {
                            location.reload()
                        }
                    });
                }
            }
        });
    });



</script>