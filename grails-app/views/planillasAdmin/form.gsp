
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        <g:if test="${planillaInstance.id}">
            Editar planilla
        </g:if>
        <g:else>
            Nueva Planilla
        </g:else>
    </title>
    %{--        <script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.9.0', file: 'jquery.validate.min.js')}"></script>--}%
    %{--        <script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.9.0', file: 'messages_es.js')}"></script>--}%

    <style type="text/css">
    .formato {
        font-weight : bolder;
    }

    select.label-important, textarea.label-important {
        background  : none !important;
        color       : #555 !important;
        text-shadow : none !important;
    }
    </style>
</head>

<body>

<div class="btn-toolbar" style="margin-bottom: 20px;">
    <div class="btn-group">
        <g:link action="list" id="${obra.id}" class="btn btn-primary">
            <i class="fa fa-arrow-left"></i>
            Cancelar
        </g:link>
        <a href="#" id="btnSave" class="btn btn-success">
            <i class="fa fa-save"></i>
            Guardar
        </a>
    </div>
</div>

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

<g:form name="frmSave-Planilla" action="save">
    <fieldset style="height: 450px">
        <g:hiddenField name="id" value="${planillaInstance?.id}"/>
        <g:hiddenField id="obra" name="obra.id" value="${planillaInstance?.obra?.id}"/>

        <div class="alert alert-info" style="font-size: 14px">
            <h3>Administración directa</h3>
            <g:if test="${existe.contains('P')}">
                <p>
                    Las planillas de tipo  <strong> "Avance de obra" </strong> se utilizan para registrar el avance de la obra.
                </p>
            </g:if>
            <g:if test="${existe.contains('M')}">
                <p>
                    La planilla de tipo  <strong> "Resumen de materiales" </strong> se utiliza para registrar los materiales utilizados en la obra.
                </p>
            </g:if>
        </div>


        <div class="form-group col-md-12">
            <span class="grupo">
                <label class="col-md-2 control-label text-info">
                    Tipo de Planilla
                </label>
                <span class="col-md-3">
                    <g:select id="tipoPlanilla" name="tipoPlanilla.id" from="${tiposPlanilla}" optionKey="key" optionValue="value" class="form-control many-to-one span3 required" value="${planillaInstance?.tipoPlanilla?.id}"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>

                <label class="col-md-2 control-label text-info">
                    Número planilla
                </label>
                <span class="col-md-2">
                    <g:textField name="numero" maxlength="30" class="form-control required allCaps" value="${planillaInstance?.numero}"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

        <div class="form-group col-md-12">
            <span class="grupo">
                <label class="col-md-2 control-label text-info">
                    Memorando de entrada
                </label>
                <span class="col-md-3">
                    <g:textField name="oficioEntradaPlanilla" class="form-control required allCaps" value="${planillaInstance.oficioEntradaPlanilla}" maxlength="20"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
                <label class="col-md-2 control-label text-info">
                    Fecha de memorando
                </label>
                <span class="col-md-3">
                    <input aria-label="" name="fechaOficioEntradaPlanilla" id='fechaOficioEntradaPlanilla' type='text' class="form-control required" value="${planillaInstance?.fechaOficioEntradaPlanilla?.format("dd-MM-yyyy") ?: new Date()}" />
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>


        <div class="form-group col-md-12">
            <span class="grupo">
                <label class="col-md-2 control-label text-info">
                    Descripción
                </label>
                <span class="col-md-8">
                    <g:textArea name="descripcion" maxlength="254" class="form-control required" value="${planillaInstance?.descripcion}" style="resize: none; height: 60px"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

        <div class="form-group col-md-12">
            <span class="grupo">
                <label class="col-md-2 control-label text-info">
                    Observaciones
                </label>
                <span class="col-md-8">
                    <g:textArea name="observaciones" maxlength="127" class="form-control" value="${planillaInstance?.observaciones}" style="resize: none; height: 100px"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>
    </fieldset>
</g:form>


<script type="text/javascript">

    $('#fechaOficioEntradaPlanilla').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        minDate: new Date(${fechaMin.format('yyyy')},${fechaMin.format('MM').toInteger() - 1},${fechaMin.format('dd')},0,0,0,0),
        maxDate: new Date(),
        sideBySide: true,
        icons: {
        }
    });


    // function checkPeriodo() {
    //     if ($("#tipoPlanilla").val() == "3") { //avance
    //         $(".periodo,.presentacion,#divMultaDisp").show();
    //     } else {
    //         $("#divMultaDisp").hide();
    //         if ($("#tipoPlanilla").val() == "2" || $("#tipoPlanilla").val() == "5") {
    //             $(".presentacion").show();
    //             $(".periodo").hide();
    //         } else {
    //             $(".periodo").hide();
    //             $(".presentacion").hide();
    //         }
    //     }
    // }

    // function fechas() {
    //     if ($.trim($("#fechaPresentacion").val()) == "") {
    //         $("#fechaPresentacion").val($("#fechaIngreso").val());
    //     }
    // }

    $("#frmSave-Planilla").validate({
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

    $("#btnSave").click(function () {
        if ($("#frmSave-Planilla").valid()) {
            $(this).replaceWith(spinner);
            $("#frmSave-Planilla").submit();
        }
    });

</script>

</body>
</html>