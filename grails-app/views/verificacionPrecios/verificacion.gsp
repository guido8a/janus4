<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Verificación de Precios de la obra: ${obra?.descripcion}</title>
</head>

<body>
<div class="hoja">
    <div class="row">
        <div class="col-md-12">
            <div class="col-md-1 btn-toolbar">
                <div class="btn-group">
                    <a href="${g.createLink(controller: 'obra', action: 'registroObra', params: [obra: obra?.id])}"
                       class="btn btn-primary" title="Regresar a la obra">
                        <i class="fa fa-arrow-left"></i>
                        Regresar
                    </a>
                </div>
            </div>
            <div class="col-md-10">
                <div class="breadcrumb" style="font-size: 14px">
                    Verificación de precios en obra: ${obra?.descripcion} <br>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-2"></div>
        <div class="col-md-8 alert alert-info" style="font-size: 14px; text-align: center">
            <i class="fa fa-exclamation-triangle text-info"></i>
            Precios no actualizados o sin valor a la fecha de referencia:
            <strong>  ${obra?.fechaCreacionObra?.format('dd-MM-yyyy')} (Fecha creación de obra)</strong>
        </div>
    </div>

    <div class="body">
        <table class="table table-bordered table-condensed table-hover table-striped" id="tbl">
            <thead>
            <tr style="width: 100%">
                <th style="width: 10%">Código</th>
                <th style="width: 50%">Item</th>
                <th style="width: 5%">U</th>
                <th style="width: 15%">P. Unitario</th>
                <th style="width: 10%">Fecha</th>
                <th style="width: 10%">Acciones</th>
            </tr>
            </thead>
        </table>
        <div class="" style="width: 99.7%; height: 450px; overflow-y: auto;float: right; margin-top: -20px">
            <table class="table-bordered table-condensed table-striped table-hover" style="width: 100%; font-size: 14px">
                <tbody>
                <g:each in="${res}" var="r">

                    <tr style="background-color:  ${r?.fecha > fechaReferencia ? '#72AF97' : '#FEB718'}">
                        <td style="width: 10%">${r?.codigo}</td>
                        <td style="width: 50%">${r?.item}</td>
                        <td style="text-align: center; width: 5%">${r?.unidad}</td>
                        <td style="text-align: right; width: 15%"><g:formatNumber number="${r?.punitario}" minFractionDigits="5" maxFractionDigits="5" format="##,##0" locale="ec"/></td>
                        <td style="text-align: center; width: 10%"><g:formatDate date="${r?.fecha}" format="dd-MM-yyyy"/></td>
                        <td style="text-align: center; width: 10%">
                            <a href="#" class="btn btn-success btn-xs btnEditar" data-id="${r?.item__id}"
                               data-nmbr="${r?.item}<br>Precio actual: $${r?.punitario}"><i class="fa fa-edit"></i></a>
                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>
    </div>
</div>


<script type="text/javascript">

    $(".btnEditar").click(function () {
        var id = $(this).data("id");
        var item = $(this).data("nmbr");
        var g = cargarLoader("Cargando...");
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'editarPrecio_ajax')}",
            data    : {
                id: id,
                obra: "${obra.id}"
            },
            success : function (msg) {
                g.modal("hide");
                var tbr= bootbox.dialog({
                    id    : "dlgEditarPrecios",
                    title : "Item: " + item,
                    // class : "modal-lg",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        acpetar : {
                            label     : "Guardar",
                            className : "btn-success",
                            callback  : function () {
                                guardarValor(id)
                            }
                        }
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    });

    function guardarValor(id){
        var g = cargarLoader("Cargando...");
        var valor = $("#precio").val();
        var fecha = $("#fecha option:selected").val();
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'savePrecio_ajax')}",
            data    : {
                id: id,
                fecha: fecha,
                valor: valor,
                obra: "${obra?.id}"
            },
            success : function (msg) {
                g.modal("hide");
                var parts = msg.split("_");
                if(parts[0] === 'ok'){
                    log("Guardado correctamente", "success");
                    setTimeout(function () {
                        location.reload()
                    }, 800);
                }else{
                    bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Error al guardar" + '</strong>');
                    return false;
                }
            } //success
        }); //ajax
    }


</script>

</body>
</html>