<%@ page import="janus.PrecioRubrosItems" %>

<div class="row">
    <g:form class="form-horizontal" name="frmSaveCantones" action="savePreciosVarios_ajax">
        <g:hiddenField name="id" value="${precioRubrosItemsInstance?.id}"/>
        <g:hiddenField id="lugar" name="lugar.id" value="${lugar ? precioRubrosItemsInstance?.lugar?.id : -1}"/>
        <g:hiddenField id="item" name="item.id" value="${precioRubrosItemsInstance?.item?.id}"/>
        <g:hiddenField name="all" value="${params.all}"/>
        <g:hiddenField name="ignore" value="${params.ignore}"/>

        <div class="col-md-12 " style="font-size: 14px">
            <div class="col-md-12 breadcrumb">
                <div class="col-md-1">
                    <label>
                        Item:
                    </label>
                </div>
                <div class="col-md-10">
                    ${precioRubrosItemsInstance?.item?.codigo + " - " + precioRubrosItemsInstance.item.nombre}
                </div>
            </div>
        </div>
        <div class="col-md-12 " style="font-size: 14px">
            <div class="col-md-12 breadcrumb">
                <div class="col-md-2">
                    <label>
                        Unidad:
                    </label>
                </div>
                <div class="col-md-10">
                    ${precioRubrosItemsInstance.item.unidad.codigo}
                </div>
            </div>
        </div>

        <div class="col-md-12 ">
            <div class="col-md-12 breadcrumb" >
                <div class="form-group ${hasErrors(bean: precioRubrosItemsInstance, field: 'precioUnitario', 'error')} ">
                    <span class="col-md-4">
                        <label for="precioUnitario" class="control-label text-info">
                            Precio Unitario
                        </label>
                        <g:textField name="precioUnitario" class="form-control number required " value="${precioRubrosItemsInstance?.precioUnitario}"/>
                        <p class="help-block ui-helper-hidden"></p>
                    </span>
                    <span class="col-md-4">
                        <label class="control-label text-info"> Fecha </label>
                        <input aria-label="" name="fecha" id='datetimepicker3' type='text' class="form-control required" value="${fecha?.format("dd-MM-yyyy") ?: new Date().format("dd-MM-yyyy")}"/>
                    </span>
                </div>
            </div>
        </div>
    </g:form>

    <div class="col-md-12" style="width: 99.7%;height: 300px; overflow-y: auto;float: right; margin-top: 20px">
        <ul class="list-group">
            <li class="list-group-item">
                <input class="form-check-input me-1 " type="checkbox" value="" id="chckTodos" data-id="${cantones?.id}">
                <label class="form-check-label" > TODOS </label>
            </li>
        </ul>

        <ul class="list-group">
            <g:each in="${cantones}" var="canton">
                <li class="list-group-item">
                    <input class="form-check-input me-1 seleccionados " type="checkbox" value="" id="${canton?.id}" data-id="${canton?.id}" >
                    <label class="form-check-label" > ${canton?.descripcion}</label>
                </li>
            </g:each>
        </ul>
    </div>
</div>
<script type="text/javascript">

    $("#chckTodos").click(function () {
        var checkboxes = document.querySelectorAll(".seleccionados");
        if($("#chckTodos").is(":checked")){
            checkboxes.forEach(function (it){
                it.setAttribute("checked", true)
            });
            $(".seleccionados").attr("disabled", true)
        }else{
            $(".seleccionados").removeAttr("disabled");
            checkboxes.forEach(function (it){
                it.removeAttribute("checked")
            });
        }
    });

    function chequeados (){
        var arregloSel = [];
        $(".seleccionados:checked").each(function () {
            arregloSel.push($(this).data("id"));
        });
        return arregloSel
    }

    $('#datetimepicker3').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        icons: {
        }
    });

    $("#frmSaveCantones").validate({
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
        },
        errorClass     : "help-block"
    });
</script>
