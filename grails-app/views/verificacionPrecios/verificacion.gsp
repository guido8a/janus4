<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Verificación de Precios de la obra</title>
</head>

<body>
<div class="hoja">

    <div class="btn-toolbar" style="margin-top: 15px;">
        <div class="btn-group">
            <a href="${g.createLink(controller: 'obra', action: 'registroObra', params: [obra: obra?.id])}" class="btn btn-primary" title="Regresar a la obra">
                <i class="fa fa-arrow-left"></i>
                Regresar
            </a>
        </div>
    </div>

    <div class="tituloGrande" style="width: 100%">
        <div  class="alert alert-info" style="margin-top: 5px">  Verificación de precios en obra: ${obra?.descripcion}: Precios no actualizados o sin valor</div>
    </div>

    <div class="body">
        <table class="table table-bordered table-condensed table-hover table-striped" id="tbl">
            <thead>
            <tr>
                <th>Código</th>
                <th>Item</th>
                <th>U</th>
                <th>P. Unitario</th>
                <th>Fecha</th>
                <th>Acciones</th>
            </tr>
            </thead>
            <tbody>
            <g:each in="${res}" var="r">
                <tr>
                    <td>${r?.codigo}</td>
                    <td>${r?.item}</td>
                    <td style="text-align: center">${r?.unidad}</td>
                    <td style="text-align: right"><g:formatNumber number="${r?.punitario}" minFractionDigits="5" maxFractionDigits="5" format="##,##0" locale="ec"/></td>
                    <td style="text-align: center"><g:formatDate date="${r?.fecha}" format="dd-MM-yyyy"/></td>
                    <td style="text-align: center">
                        <a href="#" class="btn btn-success btn-xs btnEditar" data-id="${r?.item__id}"><i class="fa fa-edit"></i></a>
                    </td>
                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
</div>


<script type="text/javascript">

    $(".btnEditar").click(function () {
        var id = $(this).data("id");
        var g = cargarLoader("Cargando...");
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'editarPrecio_ajax')}",
            data    : {
                id: id
            },
            success : function (msg) {
                g.modal("hide");
                var tbr= bootbox.dialog({
                    id    : "dlgEditarPrecios",
                    title : "Editar",
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
                valor: valor
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