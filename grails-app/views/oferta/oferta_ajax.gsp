<g:if test="${concurso}">
    <div class="row alert alert-info">
        <div class="col-md-12 breadcrumb" style="font-size: 18px; text-align: center; font-weight: bold">
            Oferta
        </div>
        <div class="col-md-12" >
            <div class="col-md-2" style="margin-top: 2px; float: right">
                <a href="#" class="btn btn-success btnNuevaOferta"><i class="fa fa-file"></i> Nuevo Oferta</a>
            </div>

            <div>
                <table class="table table-bordered table-striped table-condensed table-hover">
                    <thead>
                    <tr>
                        <th style="width: 7%;">Proveedor</th>
                        <th style="width: 5%;">Descripción</th>
                        <th style="width: 5%">Monto</th>
                        <th style="width: 3%;">Fecha entrega</th>
                        <th style="width: 3%;">Plazo</th>
                        <th style="width: 6%;">Acciones</th>
                    </tr>
                    </thead>
                </table>

                <div class="" style="width: 100%;height: 70px; overflow-y: auto;float: right; margin-top: -20px; font-size: 14px">
                    <table class="table-bordered table-condensed table-hover table-striped" style="width: 100%">
                        <tbody>
                        <g:if test="${oferta}">
                        %{--                            <tr>--}%
                        %{--                                <td style="width: 7%" title="${pac.cpp?.descripcion}">${pac.cpp?.numero}</td>--}%
                        %{--                                <td style="width: 5%" >${pac.tipoCompra.descripcion}</td>--}%
                        %{--                                <td style="text-align: right; width: 5%">--}%
                        %{--                                    <g:formatNumber number="${pac.cantidad}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/>--}%
                        %{--                                </td>--}%
                        %{--                                <td style="width: 5% !important;text-align: center" class="unidad">${pac.unidad.codigo}</td>--}%
                        %{--                                <td style="text-align: right; width: 7%" class="costo"><g:formatNumber number="${pac.costo}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/></td>--}%
                        %{--                                <td style="text-align: right; width: 7%" class="total"><g:formatNumber number="${pac.cantidad*pac.costo}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/></td>--}%
                        %{--                                <g:set var="total" value="${total+pac.cantidad*pac.costo}"/>--}%
                        %{--                                <td style="text-align: center; width: 3%; ${pac?.c1 ? 'background-color: #c1ffbb' : ''}" class="c1">${pac.c1}</td>--}%
                        %{--                                <td style="text-align: center; width: 3%; ${pac?.c2 ? 'background-color: #c1ffbb' : ''}" class="c2">${pac.c2}</td>--}%
                        %{--                                <td style="text-align: center; width: 3%; ${pac?.c3 ? 'background-color: #c1ffbb' : ''}" class="c3">${pac.c3}</td>--}%
                        %{--                                <td style="width: 6%; text-align: center">--}%
                        %{--                                    <a href="#" class="btn btn-success btn-xs btnEditarPac" data-id="${pac?.id}" ><i class="fa fa-edit"></i></a>--}%
                        %{--                                    <a href="#" class="btn btn-danger btn-xs btnBorrarPac" data-id="${pac?.id}" ><i class="fa fa-trash"></i></a>--}%
                        %{--                            </tr>--}%
                        </g:if>
                        <g:else>
                            <tr>
                                <td class="alert alert-warning" colspan="7" style="text-align: center;"> <h3><i class="fa fa-exclamation-triangle"></i> No existen registros</h3> </td>
                            </tr>
                        </g:else>
                        </tbody>
                    </table>
                </div>

            </div>
        </div>
    </div>
</g:if>
<g:else>
    divOferta
</g:else>


<script type="text/javascript">


    function createEditOferta(id, concurso) {
        var title = id ? "Editar " : "Crear ";
        var data = id ? {id : id} : {};
        data.concurso = concurso;

        $.ajax({
            type    : "POST",
            url: "${createLink(controller: 'oferta', action:'formNuevaOferta_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEditOferta",
                    title   : title + " Oferta.",
                    class : "modal-lg",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        guardar  : {
                            id        : "btnSave",
                            label     : "<i class='fa fa-save'></i> Guardar",
                            className : "btn-success",
                            callback  : function () {
                                return submitFormOferta();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    } //createEdit

    function submitFormOferta() {
        var concurso = '${concurso?.id}';
        var $form = $("#frmPac");
        if ($form.valid()) {
            var data = $form.serialize();
            var dialog = cargarLoader("Guardando...");
            $.ajax({
                type    : "POST",
                url     : $form.attr("action"),
                data    : data,
                success : function (msg) {
                    dialog.modal('hide');
                    var parts = msg.split("_");
                    if(parts[0] === 'ok'){
                        log(parts[1], "success");
                        cargarOferta(concurso);
                    }else{
                        if(parts[0] === 'err'){
                            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                            return false;
                        }else{
                            log(parts[1], "error");
                        }
                    }
                }
            });
        } else {
            return false;
        }
    }

    $(".btnNuevaOferta").click(function () {
        submitFormOferta(null, '${concurso?.id}');
    });



</script>