<%@ page import="janus.DepartamentoItem" %>

<g:form class="form-horizontal" name="frmSave" action="saveDp_ajax">
    <g:hiddenField name="id" value="${departamentoItemInstance?.id}"/>

    <div class="form-group ${hasErrors(bean: departamentoItemInstance, field: 'grupo', 'error')} ">
        <span class="grupo">
            <label for="subgrupo" class="col-md-2 control-label text-info">
                Grupo
            </label>
            <span class="col-md-8">
               <g:select name="subgrupo" from="${subgrupos}" value="${departamentoItemInstance?.subgrupo?.id}" optionValue="descripcion" optionKey="id" class="form-control" />
            </span>
        </span>
    </div>
    <div class="form-group ${hasErrors(bean: departamentoItemInstance, field: 'codigo', 'error')} ">
        <span class="grupo">
            <label for="codigo" class="col-md-2 control-label text-info">
                Código
            </label>
            <span class="col-md-2" id="divCodigoGrupo">
            </span>
            <span class="col-md-2">
                <g:textField name="codigo" maxlength="3" minlength="3" class="form-control allCaps number required" value="${departamentoItemInstance?.codigo ?: ''}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
    <div class="form-group ${hasErrors(bean: departamentoItemInstance, field: 'descripcion', 'error')} ">
        <span class="grupo">
            <label for="descripcion" class="col-md-2 control-label text-info">
                Descripción
            </label>
            <span class="col-md-8">
                <g:textField name="descripcion" maxlength="63" class="form-control allCaps required" value="${departamentoItemInstance?.descripcion}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
    <g:if test="${grupo?.codigo?.toInteger() != 1}">
        <div class="form-group ${hasErrors(bean: departamentoItemInstance, field: 'transporte', 'error')} ">
            <span class="grupo">
                <label for="transporte" class="col-md-2 control-label text-info">
                    Grupo asociado a transporte
                </label>
                <span class="col-md-8">
                    <g:select name="transporte" from="${janus.Transporte.list()}" optionValue="descripcion" optionKey="id" class="form-control" value="${departamentoItemInstance?.transporte?.id}" noSelection="['null': 'Ninguno']"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>
    </g:if>
</g:form>

<script type="text/javascript">

    cargarCodigoGrupo();

    $("#subgrupo").change(function () {
        cargarCodigoGrupo()
    });

    function cargarCodigoGrupo(){
        var idGrupo = $("#subgrupo option:selected").val();
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'mantenimientoItems', action: 'codigoGrupo_ajax')}',
            data:{
                id: idGrupo
            },
            success: function (msg) {
                $("#divCodigoGrupo").html(msg)
            }
        })
    }

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

    var sub = $("#subgrupo option:selected").val()

    var validator = $("#frmSave").validate({
        rules          : {
            codigo      : {
                remote : {
                    url  : "${createLink(action:'checkCdDp_ajax')}",
                    type : "POST",
                    data : {
                        id : "${departamentoItemInstance?.id}",
                        sg : sub
                    }
                }
            },
            descripcion : {
                remote : {
                    url  : "${createLink(action:'checkDsDp_ajax')}",
                    type : "POST",
                    data : {
                        id : "${departamentoItemInstance?.id}",
                        subgrupo : $("#subgrupo option:selected").val()
                    }
                }
            }
        },
        messages       : {
            codigo      : {
                remote : "El código se encuentra duplicado"
            },
            descripcion : {
                remote : "La descripción se encuentra duplicada"
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
