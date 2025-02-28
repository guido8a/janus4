<%@ page import="janus.ejecucion.PlanillaAdmin" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Planillas de Adm. directa
    </title>
</head>

<body>

<g:if test="${flash.message}">
    <div class="row">
        <div class="span12">
            <div class="alert ${flash.clase ?: 'alert-info'}" role="status">
                <a class="close" data-dismiss="alert" href="#">×</a>
                ${flash.message}
            </div>
        </div>
    </div>
</g:if>

<g:set var="cont" value="${1}"/>

<div class="alert alert-info" style="font-size: 14px">
    Planillas de administración directa de la obra: <strong style="font-weight: bold"> ${obra.descripcion} </strong>
</div>


<div class="row">
    <div class="span9" role="navigation">
        <div class="btn-group">
            <g:link controller="obra" action="registroObra" params="[obra: obra?.id]" class="btn btn-primary" title="Regresar a la obra">
                <i class="fa fa-arrow-left"></i>
                Regresar
            </g:link>
            <g:link action="form" class="btn btn-success" params="[obra: obra.id]">
                <i class="fa fa-file"></i>
                Nueva planilla
            </g:link>

        </div>
    </div>

    <div class="span3" id="busqueda-Planilla"></div>
</div>


<g:form action="delete" name="frmDelete-Planilla">
    <g:hiddenField name="id"/>
</g:form>

<div id="list-Planilla" role="main" style="margin-top: 10px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 10%;">#</th>
            <th style="width: 15%;">Tipo</th>
            <th style="width: 10%;">Fecha ingreso</th>
            <th style="width: 40%;">Descripcion</th>
            <th style="width: 10%;">Valor</th>
%{--            <th style="width: 15%;">Acciones</th>--}%
        </tr>
        </thead>
    </table>
</div>
<div style="width: 100%;height: 600px;overflow-y: auto;float: right; margin-top: -20px" id="detalle">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <tbody class="paginate">
        <g:each in="${list}" status="i" var="planillaInstance">
            <tr>
                <td style="width: 10%;">
                    ${planillaInstance?.numero}
                </td>
                <td style="width: 15%;">
                    ${planillaInstance.tipoPlanilla.nombre}
                </td>
                <td style="width: 10%;">
                    <g:formatDate date="${planillaInstance.fechaIngreso}" format="dd-MM-yyyy"/>
                </td>
                <td style="width: 40%;">
                    ${planillaInstance.descripcion}
                </td>
                <td class="numero" style="width: 10%;">
                    <g:formatNumber number="${planillaInstance.valor}" maxFractionDigits="2" minFractionDigits="2" format="##,##0" locale="ec"/>
                </td>
%{--                <td style="width: 15%;">--}%
%{--                    <g:if test="${planillaInstance.tipoPlanilla.codigo == 'M'}">--}%
%{--                        <g:link controller="detallePlanillaCostoAdmin" action="detalleCosto" id="${planillaInstance.id}" params="[obra: obra.id]" rel="tooltip" title="Detalles" class="btn btn-xs btn-success">--}%
%{--                            <i class="fa fa-search"></i>--}%
%{--                        </g:link>--}%
%{--                        <g:link controller="reportesPlanillasAdmin" action="reporteMateriales" id="${planillaInstance.id}" params="[obra: obra.id]" rel="tooltip" title="Imprimir" class="btn btn-xs btn-info">--}%
%{--                            <i class="fa fa-print"></i>--}%
%{--                        </g:link>--}%
%{--                    </g:if>--}%
%{--                    <g:else>--}%
%{--                        <g:link action="detalle" id="${planillaInstance.id}" params="[obra: obra.id]" rel="tooltip" title="Detalles" class="btn btn-xs btn-success">--}%
%{--                            <i class="fa fa-search"></i>--}%
%{--                        </g:link>--}%
%{--                        <g:link controller="reportesPlanillasAdmin" action="reporteDetalle" id="${planillaInstance.id}" params="[obra: obra.id]" rel="tooltip" title="Imprimir" class="btn btn-xs btn-info">--}%
%{--                            <i class="fa fa-print"></i>--}%
%{--                        </g:link>--}%
%{--                    </g:else>--}%
%{--                </td>--}%
            </tr>
        </g:each>
        </tbody>
    </table>
</div>

%{--<div class="modal hide fade mediumModal" id="modal-Planilla">--}%
%{--    <div class="modal-header" id="modalHeader">--}%
%{--        <button type="button" class="close darker" data-dismiss="modal">--}%
%{--            <i class="icon-remove-circle"></i>--}%
%{--        </button>--}%

%{--        <h3 id="modalTitle"></h3>--}%
%{--    </div>--}%

%{--    <div class="modal-body" id="modalBody">--}%
%{--    </div>--}%

%{--    <div class="modal-footer" id="modalFooter">--}%
%{--    </div>--}%
%{--</div>--}%


%{--<div id="errorImpresion">--}%
%{--    <fieldset>--}%
%{--        <div class="spa3" style="margin-top: 30px; margin-left: 10px">--}%

%{--            Debe ingresar un número de Oficio!--}%

%{--        </div>--}%
%{--    </fieldset>--}%
%{--</div>--}%



<script type="text/javascript">

    function submitForm(btn) {
        if ($("#frmSave-Planilla").valid()) {
            $("#frmSave-Planilla").submit();
        }
    }

        %{--$('[rel=tooltip]').tooltip();--}%

        %{--$(".paginate").paginate({--}%
        %{--    maxRows        : 10,--}%
        %{--    searchPosition : $("#busqueda-Planilla"),--}%
        %{--    float          : "right"--}%
        %{--});--}%

        %{--$(".btnPedidoPagoAnticipo").click(function () {--}%
        %{--    location.href = "${g.createLink(controller: 'reportesPlanillas',action: 'memoPedidoPagoAnticipo')}/" + $(this).data("id");--}%
        %{--    return false;--}%
        %{--});--}%

        %{--$(".btnPedidoPago").click(function () {--}%
        %{--    location.href = "${g.createLink(controller: 'reportesPlanillas',action: 'memoPedidoPago')}/" + $(this).data("id");--}%
        %{--    return false;--}%
        %{--});--}%

        $(".btn-pagar").click(function () {
            var $btn = $(this);
            var tipo = $btn.data("tipo").toString();
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'pago_ajax')}",
                data    : {
                    id   : $btn.data("id"),
                    tipo : tipo
                },
                success : function (msg) {
                    var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                    var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');

                    btnSave.click(function () {
                        submitForm(btnSave);
                        return false;
                    });
                    $("#modalTitle").html($btn.text());

                    $("#modalHeader").removeClass("btn-edit btn-show btn-delete");

                    if (msg === "NO") {
                        $("#modalBody").html("Ha ocurrido un error: No se encontró un administrador activo para el contrato.<br/>Por favor asigne uno desde la página del contrato en la opción Administrador.");
                        btnOk.text("Aceptar");
                        $("#modalFooter").html("").append(btnOk);
                    } else {
                        $("#modalBody").html(msg);
                        if (msg.startsWith("No")) {
                            btnOk.text("Aceptar");
                            $("#modalFooter").html("").append(btnOk);
                        } else {
                            $("#modalFooter").html("").append(btnOk).append(btnSave);
                        }
                    }

                    $("#modal-Planilla").modal("show");
                }
            });
            return false;
        }); //click btn new

        $(".btn-new").click(function () {
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'form_ajax')}",
                success : function (msg) {
                    var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                    var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');

                    btnSave.click(function () {
                        submitForm(btnSave);
                        return false;
                    });

                    $("#modalHeader").removeClass("btn-edit btn-show btn-delete");
                    $("#modalTitle").html("Crear Planilla");
                    $("#modalBody").html(msg);
                    $("#modalFooter").html("").append(btnOk).append(btnSave);
                    $("#modal-Planilla").modal("show");
                }
            });
            return false;
        }); //click btn new

        $(".btn-edit").click(function () {
            var id = $(this).data("id");
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'form_ajax')}",
                data    : {
                    id : id
                },
                success : function (msg) {
                    var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                    var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');

                    btnSave.click(function () {
                        submitForm(btnSave);
                        return false;
                    });

                    $("#modalHeader").removeClass("btn-edit btn-show btn-delete").addClass("btn-edit");
                    $("#modalTitle").html("Editar Planilla");
                    $("#modalBody").html(msg);
                    $("#modalFooter").html("").append(btnOk).append(btnSave);
                    $("#modal-Planilla").modal("show");
                }
            });
            return false;
        }); //click btn edit

        $(".btn-show").click(function () {
            var id = $(this).data("id");
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'show_ajax')}",
                data    : {
                    id : id
                },
                success : function (msg) {
                    var btnOk = $('<a href="#" data-dismiss="modal" class="btn btn-primary">Aceptar</a>');
                    $("#modalHeader").removeClass("btn-edit btn-show btn-delete").addClass("btn-show");
                    $("#modalTitle").html("Ver Planilla");
                    $("#modalBody").html(msg);
                    $("#modalFooter").html("").append(btnOk);
                    $("#modal-Planilla").modal("show");
                }
            });
            return false;
        }); //click btn show

        $(".btn-delete").click(function () {
            var id = $(this).data("id");
            $("#id").val(id);
            var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
            var btnDelete = $('<a href="#" class="btn btn-danger"><i class="icon-trash"></i> Eliminar</a>');

            btnDelete.click(function () {
                btnDelete.replaceWith(spinner);
                $("#frmDelete-Planilla").submit();
                return false;
            });

            $("#modalHeader").removeClass("btn-edit btn-show btn-delete").addClass("btn-delete");
            $("#modalTitle").html("Eliminar Planilla");
            $("#modalBody").html("<p>¿Está seguro de querer eliminar esta Planilla?</p>");
            $("#modalFooter").html("").append(btnOk).append(btnDelete);
            $("#modal-Planilla").modal("show");
            return false;
        });

        %{--$("#imprimir").click(function () {--}%
        %{--    location.href = "${g.createLink(controller: 'reportesPlanillas', action: 'reporteContrato', id: obra?.id)}?oficio=" + $("#oficio").val() + "&firma=" + $("#firma").val();--}%
        %{--});--}%

        // $("#errorImpresion").dialog({
        //     autoOpen  : false,
        //     resizable : false,
        //     modal     : true,
        //     draggable : false,
        //     width     : 320,
        //     height    : 200,
        //     position  : 'center',
        //     title     : 'Error',
        //     buttons   : {
        //         "Aceptar" : function () {
        //             $("#errorImpresion").dialog("close")
        //
        //         }
        //     }
        // });


</script>

</body>
</html>
