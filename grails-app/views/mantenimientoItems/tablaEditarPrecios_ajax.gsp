<style>

    .marco{
        border-color: #00aa00;
        border-style: solid;
        border-width: 3px;
    }

</style>

<div role="main" style="margin-top: 15px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 70%">Lugar</th>
            <th style="width: 20%">Valor</th>
            <th style="width: 10%">Acciones</th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
        <tbody>
        <g:if test="${res.size() > 0}">
            <g:each in="${res}" status="i" var="r">
                <tr>
                    <td style="width: 70%; font-weight: bold; font-size: 14px">${r.lgardscr}</td>
                    <td style="width: 20%">
                        <g:textField name="precio" id="precio_${r?.rbpc__id}" value="${r.rbpcpcun}" class="form-control precio" readonly=""/>
                    </td>
                    <td style="width: 10%; text-align: center">
                        <a href="#" class="btn btn-xs btn-info btnEditarPrecioLugar" id="btnEditar_${r?.rbpc__id}" data-id="${r?.rbpc__id}" title="Editar precios">
                            <i class="fas fa-edit"></i>
                        </a>
                        <a href="#" class="btn btn-xs btn-success btnGuardarPrecioLugar hidden" id="btnGuardar_${r?.rbpc__id}" data-id="${r?.rbpc__id}" title="Guardar precio">
                            <i class="fas fa-save"></i>
                        </a>
                        <a href="#" class="btn btn-xs btn-warning btnCancelarEdicion" data-id="${r?.rbpc__id}" data-precio="${r.rbpcpcun}" title="Cancelar edición de precio">
                            <i class="fas fa-times"></i>
                        </a>
                    </td>
                </tr>
            </g:each>
        </g:if>
        <g:else>
            <tr style="text-align: center">
                <td class="alert alert-warning"><i class="fa fa-exclamation-triangle fa-2x text-info"></i> <strong style="font-size: 16px"> No existen registros </strong></td>
            </tr>
        </g:else>
        </tbody>
    </table>
</div>

<script type="text/javascript">

    var dg;

    function validarNum(ev) {
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
            (ev.keyCode >= 96 && ev.keyCode <= 105) ||
            ev.keyCode === 190 || ev.keyCode === 110 ||
            ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
            ev.keyCode === 37 || ev.keyCode === 39);
    }

    $(".precio").keydown(function (ev) {
        return validarNum(ev);
    });

    $(".btnEditarPrecioLugar").click(function () {
        var id = $(this).data("id");
        $("#precio_" + id).removeAttr("readonly").addClass("marco");
        $("#btnGuardar_" + id).removeClass("hidden");
        $("#btnEditar_" + id).addClass("hidden")
    });

    $(".btnCancelarEdicion").click(function () {
        var id = $(this).data("id");
        var precio = $(this).data("precio");
        $("#precio_" + id).prop("readonly", "true").val(precio).removeClass("marco");
        $("#btnGuardar_" + id).addClass("hidden");
        $("#btnEditar_" + id).removeClass("hidden")
    });

    $(".btnGuardarPrecioLugar").click(function () {
        var id = $(this).data("id");
        var valor =   $("#precio_" + id).val();
        var item = '${item?.id}';
        if(valor && valor > 0){
            $.ajax({
                type    : "POST",
                url     : "${createLink(controller: 'mantenimientoItems', action:'botonesGuardar_ajax')}",
                data    : {
                    id: id,
                    valor: valor,
                    item: item
                },
                success : function (msg) {
                    dg = bootbox.dialog({
                        id    : "dlgGuardarPrecio",
                        title : "Guardar precio",
                        message : msg,
                        buttons : {
                            cancelar : {
                                label     : "Cancelar",
                                className : "btn-primary",
                                callback  : function () {
                                }
                            }
                        } //buttons
                    }); //dialog
                } //success
            }); //ajax
        }else{
            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 16px">' + "El valor debe ser mayor a 0" + '</strong>');
        }
    });

    function guardarPrecio(id, valor, tipo){
        var fecha = $("#fecha option:selected").val();
        var a = cargarLoader("Guardando...");
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'mantenimientoItems', action: 'guardarPrecioLugar_ajax')}',
            data:{
                id: id,
                precio: valor,
                tipo: tipo,
                fecha: fecha,
                item: '${item?.id}'
            },
            success: function (msg) {
                a.modal('hide');
                var parts = msg.split("_");
                if(parts[0] === 'ok'){
                    log(parts[1],"success");
                    cerrarDialogoGuardar();
                    cargarTablaPrecios();
                }else{
                    bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 16px">' + parts[1] + '</strong>');
                }
            }
        });
    }

    function cerrarDialogoGuardar() {
        dg.modal("hide");
    }

</script>