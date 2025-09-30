<%@ page import="janus.PrecioRubrosItems" %>

<g:form class="form-horizontal" name="frmSaveCantones" action="savePrecioCantones_ajax">
    <g:hiddenField name="id" value="${precioRubrosItemsInstance?.id}"/>
    <g:hiddenField id="lugar" name="lugar.id" value="${lugar ? precioRubrosItemsInstance?.lugar?.id : -1}"/>
    <g:hiddenField id="item" name="item.id" value="${precioRubrosItemsInstance?.item?.id}"/>
    <g:hiddenField name="all" value="${params.all}"/>
    <g:hiddenField name="ignore" value="${params.ignore}"/>

    <div class="col-md-12 breadcrumb" style="margin-top: -10px; font-size: 14px">
        <div class="col-md-2">
            <label>
                Item:
            </label>
        </div>
        <div class="col-md-8">
            ${precioRubrosItemsInstance.item.nombre}
        </div>
    </div>
%{--    <div class="col-md-12 breadcrumb" style="margin-top: -10px; font-size: 14px">--}%
%{--        <div class="col-md-2">--}%
%{--            <label>--}%
%{--                Lista:--}%
%{--            </label>--}%
%{--        </div>--}%
%{--        <div class="col-md-8">--}%
%{--            ${lugarNombre}--}%
%{--        </div>--}%
%{--    </div>--}%

    <div class="form-group ${hasErrors(bean: precioRubrosItemsInstance, field: 'precioUnitario', 'error')} ">
        <span class="grupo col-md-12">
            <span class="col-md-4">
                %{--                <span class="col-md-6">--}%
                %{--                    <label for="precioUnitario" class="control-label text-info">--}%
                %{--                        Precio Unitario--}%
                %{--                    </label>--}%
                %{--                </span>--}%
                %{--                <span class="col-md-5">--}%
                <label for="precioUnitario" class="control-label text-info">
                    Precio Unitario
                </label>
                <g:textField name="precioUnitario" class="form-control number required " value="${precioRubrosItemsInstance?.precioUnitario}"/>
                <p class="help-block ui-helper-hidden"></p>
                %{--                </span>--}%
            </span>
            <span class="col-md-2">
                <label class="control-label text-info">Unidad:</label>
                <span style="font-weight: bold; font-size: 14px"> ${precioRubrosItemsInstance.item.unidad.codigo} </span>
            </span>
            <span class="col-md-4">
                <label class="control-label text-info"> Fecha </label>
                %{--                <strong style="font-size: 14px;"> ${precioRubrosItemsInstance?.fecha?.format("dd-MM-yyyy")}</strong>--}%
                %{--                <g:hiddenField name="fecha" value="${precioRubrosItemsInstance?.fecha}"/>--}%

                <input aria-label="" name="fecha" id='datetimepicker3' type='text' class="form-control required" value="${new Date().format("dd-MM-yyyy")}"/>
            </span>
        </span>
    </div>
</g:form>

<div class="" style="width: 99.7%;height: 500px; overflow-y: auto;float: right; margin-top: 20px">

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
        rules          : {
            fecha : {
                remote : {
                    url  : "${createLink(action:'checkFcPr_ajax')}",
                    type : "post",
                    data : {
                        item  : "${precioRubrosItemsInstance.itemId}",
                        lugar : "${lugar?.id}"
                    }
                }
            }
        },
        messages       : {
            fecha : {
                remote : "Ya existe un precio para esta fecha"
            }
        },
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
