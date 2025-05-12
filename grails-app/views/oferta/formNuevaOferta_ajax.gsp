<%@ page import="janus.pac.Oferta" %>

<div id="create-Oferta" class="span" role="main">
<g:form class="form-horizontal" name="frmSave-Oferta" action="save">
    <g:hiddenField name="id" value="${ofertaInstance?.id}"/>
    <g:hiddenField id="concurso" name="concurso.id" value="${ofertaInstance?.concurso?.id ?: concurso?.id}"/>

    <div class="form-group">
        <span class="grupo">
            <label class="col-md-2 control-label text-info">
                Proceso
            </label>
            <span class="col-md-8">
                <g:if test="${ofertaInstance}">
                    ${ofertaInstance?.concurso?.objeto}
                </g:if>
                <g:else>
                    ${concurso?.objeto}
                </g:else>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: ofertaInstance, field: 'descripcion', 'error')} ">
        <span class="grupo">
            <label for="descripcion" class="col-md-2 control-label text-info">
                Descripción
            </label>
            <span class="col-md-8">
                <g:textField name="descripcion" maxlength="255" class="form-control required" value="${ofertaInstance?.descripcion}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: ofertaInstance, field: 'proveedor', 'error')} ">
        <span class="grupo">
            <label for="proveedor" class="col-md-2 control-label text-info">
                Proveedores
            </label>
            <span class="col-md-8">
                %{--                <g:select id="proveedor" name="proveedor.id" from="${janus.pac.Proveedor.list()}" optionKey="id" class="form-control"--}%
                %{--                          value="${ofertaInstance?.proveedor?.id}" optionValue="nombre" noSelection="['null': 'Seleccione...']" />--}%

                <g:hiddenField name="proveedor" value="${ofertaInstance?.proveedor?.id}" />
                <g:textField name="proveedorName" class="form-control" value="${ofertaInstance?.proveedor?.nombre}" readonly="" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
            <p class="help-block ui-helper-hidden"></p>
        </span>
        <span class="col-md-1">
            <a href="#" class="btn btn-info" id="btnBuscarProveedor" title="Buscar proveedor"><i class="fa fa-search"></i></a>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: ofertaInstance, field: 'monto', 'error')} ">
        <span class="grupo">
            <label for="monto" class="col-md-2 control-label text-info">
                Monto
            </label>
            <span class="col-md-4">
                <g:textField name="monto" class="form-control required" value="${ofertaInstance?.monto}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: ofertaInstance, field: 'plazo', 'error')} ">
        <span class="grupo">
            <label for="plazo" class="col-md-2 control-label text-info">
                Plazo
            </label>
            <span class="col-md-4">
                <g:textField name="plazo" class="form-control required" value="${ofertaInstance?.plazo}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
            <span class="col-md-1">
                días
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: ofertaInstance, field: 'fechaEntrega', 'error')} ">
        <span class="grupo">
            <label for="fechaEntrega" class="col-md-2 control-label text-info">
                Fecha Entrega de la Oferta
            </label>
            <span class="col-md-4">
                <input aria-label="" name="fechaEntrega" id='fechaEntrega' type='text' class="form-control required" value="${ofertaInstance?.fechaEntrega?.format("dd-MM-yyyy") ?: new Date().format("dd-MM-yyyy")}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: ofertaInstance, field: 'hoja', 'error')} ">
        <span class="grupo">
            <label for="plazo" class="col-md-2 control-label text-info">
                Hojas de oferta
            </label>
            <span class="col-md-4">
                <g:textField name="hoja" class="form-control number" value="${ofertaInstance?.hoja ?: 0}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: ofertaInstance, field: 'hoja', 'error')} ">
        <span class="grupo">
            <label for="plazo" class="col-md-2 control-label text-info">
                Garantía
            </label>
            <span class="col-md-4">
                <g:select name="garantia" from="${[0: 'NO', 1 : 'SI']}" optionKey="key" optionValue="value" value="${ofertaInstance?.garantia}" class="form-control " />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: ofertaInstance, field: 'subsecretario', 'error')} ">
        <span class="grupo">
            <label for="subsecretario" class="col-md-2 control-label text-info">
                Secretario C.T.
            </label>
            <span class="col-md-4">
                <g:textField name="subsecretario" maxlength="40" class="form-control" value="${ofertaInstance?.subsecretario}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: ofertaInstance, field: 'responsableProceso', 'error')} ">
        <span class="grupo">
            <label for="subsecretario" class="col-md-2 control-label text-info">
                Responsable del proceso
            </label>
            <span class="col-md-8">
                <g:select name="responsableProceso.id" from="${responsablesProceso}" optionKey="${{it.id}}" optionValue="${{it.apellido + ' ' + it.nombre}}" value="${ofertaInstance?.responsableProcesoId}" class="form-control required" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: ofertaInstance, field: 'observaciones', 'error')} ">
        <span class="grupo">
            <label for="observaciones" class="col-md-2 control-label text-info">
                Observaciones
            </label>
            <span class="col-md-8">
                <g:textField name="observaciones" maxlength="127" class="form-control" value="${ofertaInstance?.observaciones}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

</g:form>

<script type="text/javascript">

    var bcpr;

    $("#btnBuscarProveedor").click(function () {
        $.ajax({
            type    : "POST",
            url: "${createLink(controller: 'oferta', action:'buscarProveedor_ajax')}",
            data    : {},
            success : function (msg) {
                bcpr = bootbox.dialog({
                    id      : "dlgBuscarProveedor",
                    title   : "Buscar Proveedor",
                    class: 'modal-lg',
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
    });

    function cerrarBuscadorProveedor(){
        bcpr.modal("hide");
    }

    $("#divTablaOferta").focus();

    $('#fechaEntrega').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        icons: {
        }
    });

    $("#frmSave-Oferta").validate({
        errorClass     : "help-block",
        errorPlacement : function (error, element) {
            if (element.parent().hasClass("input-group")) {
                error.insertAfter(element.parent());
            } else {
                error.insertAfter(element);
            }
            element.parents(".grupo").addClass('has-error');
        },
        success        : function (label) {
            label.parents(".grupo").removeClass('has-error');
        }
    });

    $(".form-control").keydown(function (ev) {
        if (ev.keyCode === 13) {
            submitFormOferta();
            return false;
        }
        return true;
    });
</script>
