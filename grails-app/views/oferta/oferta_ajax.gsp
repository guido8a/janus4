<g:if test="${concurso}">
    <div class="row alert alert-info">
        <div class="col-md-12 breadcrumb" style="font-size: 18px; text-align: center; font-weight: bold">
            Oferta
        </div>
        <div class="col-md-12" >
            <g:if test="${!oferta}">
                <div class="col-md-2" style="margin-top: 2px; float: right">
                    <a href="#" class="btn btn-success btnNuevaOferta"><i class="fa fa-file"></i> Nuevo Oferta</a>
                </div>
            </g:if>

            <div>
                <table class="table table-bordered table-striped table-condensed table-hover" >
                    <thead>
                    <tr>
                        <th style="width: 20%;">Proveedor</th>
                        <th style="width: 40%;">Descripción</th>
                        <th style="width: 10%">Monto</th>
                        <th style="width: 10%;">Fecha entrega</th>
                        <th style="width: 10%;">Plazo</th>
                        <th style="width: 10%;">Acciones</th>
                    </tr>
                    </thead>
                </table>

                <div class="" style="width: 100%;height: 70px; overflow-y: auto;float: right; margin-top: -20px; font-size: 14px" tabindex="-1" id="divTablaOferta">
                    <table class="table-bordered table-condensed table-hover table-striped" style="width: 100%">
                        <tbody>
                        <g:if test="${oferta}">
                            <tr >
                                <td style="width: 20%" >${oferta?.proveedor?.nombre}</td>
                                <td style="width: 40%" >${oferta?.descripcion}</td>
                                <td style="width: 10%; text-align: right">${oferta?.monto}</td>
                                <td style="width: 10%; text-align: center"><g:formatDate date="${oferta.fechaEntrega}" format="dd-MM-yyyy"/></td>
                                <td style="width: 10%; text-align: center">${oferta?.plazo}</td>
                                <td style="width: 10%; text-align: center">
                                    <a href="#" class="btn btn-success btn-xs btnEditarOferta" data-id="${oferta?.id}" ><i class="fa fa-edit"></i></a>
                                    <a href="#" class="btn btn-danger btn-xs btnBorrarOferta" data-id="${oferta?.id}" ><i class="fa fa-trash"></i></a>
                                </td>
                            </tr>
                        </g:if>
                        <g:else>
                            <tr>
                                <td class="alert alert-warning" colspan="6" style="text-align: center;"> <h3><i class="fa fa-exclamation-triangle"></i> No existen registros</h3> </td>
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
</g:else>

%{--<g:if test="${!concursoComplementario}">--}%
%{--    <div class="row">--}%
%{--        <div class="col-md-12" style="text-align: center">--}%
%{--            <a href="#" class="btn btn-success btnCargarConcursoComplementario" data-id="${oferta?.concurso?.pac?.id}" ><i class="fa fa-file"></i> Cargar Concurso complementario</a>--}%
%{--        </div>--}%
%{--    </div>--}%
%{--</g:if>--}%

<script type="text/javascript">

%{--    <g:if test="${concursoComplementario}">--}%
    cargarConcursoComplentario('${concurso.pac.id}');
%{--    </g:if>--}%
%{--    <g:else>--}%
%{--    --}%
%{--    </g:else>--}%

    // $(".btnCargarConcursoComplementario").click(function () {
    //     var pac = $(this).data("id");
    //     $("#divOferta").focus();
    //     cargarConcursoComplentario(pac)
    // });

    $(".btnEditarOferta").click(function () {
        var id = $(this).data("id");
        createEditOferta(id);
    });

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
        var $form = $("#frmSave-Oferta");
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
                        $("#divTablaOferta").focus();
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
        createEditOferta(null, '${concurso?.id}');
    });

    $(".btnBorrarOferta").click(function () {
        var id = $(this).data("id");
        deleteRow(id)
    });

    function deleteRow(itemId) {
        var concurso = '${concurso?.id}';
        bootbox.dialog({
            title   : "Alerta",
            message : "<i class='fa fa-trash fa-2x pull-left text-danger text-shadow'></i><p style='font-weight: bold; font-size: 14px'> Está seguro que desea eliminar esta oferta?.</p>",
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
                            url     : '${createLink(controller: 'oferta', action:'delete')}',
                            data    : {
                                id : itemId
                            },
                            success : function (msg) {
                                v.modal("hide");
                                var parts = msg.split("_");
                                if(parts[0] === 'ok'){
                                    log(parts[1],"success");
                                    cargarOferta(concurso);
                                    $("#divTablaOferta").focus();
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