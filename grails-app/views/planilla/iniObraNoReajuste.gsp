<style type="text/css">
.formato {
    font-weight : bold;
}

.dpto {
    font-size  : smaller;
    font-style : italic;
}
</style>
<g:form name="frmSave-Planilla" action="iniciarObra" id="${cntr}">
    <g:hiddenField name="tipo" value="${tipo}"/>
    <fieldset>
        <div class="row">
            <div class="col-md-5">
                ${extra}
            </div>
        </div>

        <div class="row">
            <div class="col-md-2 formato">
                ${lblMemo}
            </div>

            <div class="col-md-4">
                <g:textField name="memo" class="span3 form-control required allCaps" maxlength="20"/>
                <p class="help-block ui-helper-hidden"></p>
            </div>
        </div>

        <div class="row">
            <div class="col-md-2 formato">
                ${lblFecha}
            </div>

            <div class="col-md-4">
                <input aria-label="" name="fecha" id='fecha' type='text' class="form-control required" value="${fecha?.format("dd-MM-yyyy")}" />
                <p class="help-block ui-helper-hidden"></p>
            </div>
        </div>

        <div class="alert alert-danger" style="font-size: large; margin-top: 10px">
            <strong>
               * Los datos ingresados para la impresión del oficio son definitivos. <br>  * Una vez guardados no podrán ser modificados.
            </strong>
        </div>
    </fieldset>
</g:form>

<script type="text/javascript">

    $('#fecha').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        minDate: new Date(${fechaMin}),
        maxDate: new Date(${fechaMax}),
        icons: {
        }
    });

    $("#frmSave-Planilla").validate({
        errorPlacement : function (error, element) {
            element.parent().find(".help-block").html(error).show();
        },
        success        : function (label) {
            label.parent().hide();
        },
        errorClass     : "label label-important",
        submitHandler  : function (form) {
            $("[name=btnSave-rubroInstance]").replaceWith(spinner);
            form.submit();
        }
    });
</script>