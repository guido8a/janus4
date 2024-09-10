<%@ page import="janus.SubgrupoItems" %>

<g:form class="form-horizontal" name="frmSave" action="saveSg_ajax">
    <g:hiddenField name="id" value="${subgrupoItemsInstance?.id}"/>
    <g:hiddenField name="grupo" value="${grupo?.id}"/>

    <div class="form-group ${hasErrors(bean: subgrupoItemsInstance, field: 'grupo', 'error')} ">
        <span class="grupo">
            <label for="grupoName" class="col-md-2 control-label text-info">
                Tipo
            </label>
            <span class="col-md-8">
                <g:textField name="grupoName" class="form-control" value="${grupo?.descripcion}" readonly="" />
            </span>
        </span>
    </div>
    <div class="form-group ${hasErrors(bean: subgrupoItemsInstance, field: 'codigo', 'error')} ">
        <span class="grupo">
            <label for="codigo" class="col-md-2 control-label text-info">
                Código
            </label>
            <span class="col-md-2">
                <g:textField name="codigo" maxlength="3" minlength="3" class="form-control allCaps number required" value="${subgrupoItemsInstance?.codigo ?: ''}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
    <div class="form-group ${hasErrors(bean: subgrupoItemsInstance, field: 'descripcion', 'error')} ">
        <span class="grupo">
            <label for="descripcion" class="col-md-2 control-label text-info">
                Descripción
            </label>
            <span class="col-md-8">
                <g:textField name="descripcion" maxlength="63" class="form-control allCaps required" value="${subgrupoItemsInstance?.descripcion}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
</g:form>

<script type="text/javascript">

    function validarNumDec(ev) {
        /*
         48-57      -> numeros
         96-105     -> teclado numerico
         188        -> , (coma)
         190        -> . (punto) teclado
         110        -> . (punto) teclado numerico
         8          -> backspace
         46         -> delete
         9          -> tab
         37         -> flecha izq
         39         -> flecha der
         */
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
            (ev.keyCode >= 96 && ev.keyCode <= 105) ||
            ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
            ev.keyCode === 37 || ev.keyCode === 39);
    }

    $("#codigo").keydown(function (ev) {
        return validarNumDec(ev)
    });

    var validator = $("#frmSave").validate({
        rules          : {
            codigo : {
                remote : {
                    url  : "${createLink(action:'checkCodigoGrupo_ajax')}",
                    type : "POST",
                    data : {
                        id : "${subgrupoItemsInstance?.id}",
                        grupo: '${grupo?.id}'
                    }
                }
            },
            descripcion : {
                remote : {
                    url  : "${createLink(action:'checkDsSg_ajax')}",
                    type : "POST",
                    data : {
                        id : "${subgrupoItemsInstance?.id}",
                        grupo: '${grupo?.id}'
                    }
                }
            }
        },
        messages       : {
            descripcion : {
                remote : "La descripción se encuentra duplicada"
            },
            codigo : {
                remote : "El código se encuentra duplicado"
            }
        },
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
</script>