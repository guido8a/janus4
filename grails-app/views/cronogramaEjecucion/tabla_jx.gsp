<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>

    <title></title>

    <meta name="layout" content="mainCrono">


    <style type="text/css">
    .valor {
        color: #093760;
    }
    .valor2 {
        color: #093760;
        text-align: right;
        font-weight: bold;
    }
    .suspension {
        background-color: #ffffff !important;
        color: #444 !important;
        font-weight: normal !important;
    }
    .numero {
        width: 80px;
        text-align: right;
    }
    .totales {
        /*width: 80px;*/
        text-align: right;
        font-weight: bold;
    }
    .pie {
        background-color: #ddd;
    }
    .pie2 {
        background-color: #f0f0f0;
    }
    </style>


</head>

<table class="table table-bordered table-condensed table-hover table-striped">
    <thead>
    <tr>
        <th rowspan="2" style="width:70px;">Código</th>
        <th rowspan="2" style="width:220px;">Rubro</th>
        <th rowspan="2" style="width:26px;">*</th>
        <th rowspan="2" style="width:60px;">Cantidad Unitario Total</th>
        <th rowspan="2" style="width:12px;">T.</th>
        <g:each in="${titulo1}" var="t">
            <th class="${t[1] == 'S' ? 'suspension' : ''}">${t[0]}</th>
        </g:each>
        <th rowspan="2">Total rubro</th>
    </tr>
    <tr>
        <g:each in="${titulo2}" var="t">
            <th class="${t[1] == 'S' ? 'suspension' : ''}">${raw(t[0])}</th>
        </g:each>
    </tr>
    </thead>

    <tbody class="paginate">

    <g:each in="${rubros}" var="rubro">
        <tr id="rubro_${rubro[0]}" data-vol="${rubro[1]}" data-vocr="${rubro[0]}">
        <tr id="rubro_8709" onclick="cargarFila(${rubro[0]})">
            %{--    <td colspan="10">${rubro[0]}</td>--}%
            %{--    <td colspan="10"></td>--}%
        </tr>
    </g:each>
    </tbody>
</table>

<div class="row"  style="margin-top: -10px">
    <div class="col-md-12" id="divTotalesTabla">
    </div>
</div>



</html>

<script type="text/javascript">

    <g:each in="${rubros}" var="rubro">
    document.getElementById("rubro_${rubro[0]}").addEventListener("load", cargarFila(${rubro[0]}));
    </g:each>

    function editarFila(vol){
        $.ajax({
            type: "POST",
            url: "${createLink(action: 'modificacionNuevo_ajax')}",
            data: {
                contrato: "${contrato}",
                vol: vol
            },
            success: function (msg) {

                var b = bootbox.dialog({
                    id      : "dlgCreateEditModif",
                    title   : "Modificación",
                    message : msg,
                    class: 'modal-lg',
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
                                var data = "obra=${janus.Contrato.get(contrato)?.obra?.id}";
                                $(".tiny").each(function () {
                                    var tipo = $(this).data("tipo");
                                    var val = parseFloat($(this).val());
                                    var crono = $(this).data("id");
                                    var periodo = $(this).data("id2");
                                    var vol = $(this).data("id3");
                                    data += "&" + (tipo + "=" + val + "_" + periodo + "_" + vol + "_" + crono);
                                });
                                $.ajax({
                                    type: "POST",
                                    url: "${createLink(action:'modificacionNuevo')}",
                                    data: data,
                                    success: function (msg) {
                                        b.modal("hide");
                                        // updateTabla();
                                        cargarFila(vol);
                                        cargarTotalesTabla();
                                    }
                                });
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            }
        });
    }

    function cargarFila(vol){
        $.ajax({
            type: "POST",
            url: "${createLink(action: 'tabla_jx_rubro')}",
            data: {
                contrato: "${contrato}",
                vol: vol
            },
            success: function (msg) {
                $("#rubro_" + vol).html(msg);
                cargarTotalesTabla();
            }
        });
    }

    // cargarTotalesTabla();

    function cargarTotalesTabla () {
        $.ajax({
            type: "POST",
            url: "${createLink(action: 'totales_ajax')}",
            data: {
                id: "${contrato}"
            },
            success: function (msg) {
                $("#divTotalesTabla").html(msg)
            }
        });
    }

    function createContextMenu(node) {
        var $tr = $(node);
        var items = {
            header: {
                label: "Acciones",
                header: true
            }
        };

        var id = $tr.data("vocr");

        var editar = {
            label: "Modificación",
            icon: "fa fa-edit",
            action : function ($element) {
                editarFila(id);
            }
        };
        // var cargar = {
        //     label: "Cargar",
        //     icon: "fa fa-check",
        //     action : function ($element) {
        //         cargarFila(id);
        //     }
        // };

        if(${janus.Contrato.get(contrato)?.fiscalizador?.id == session.usuario.id}){
            items.editar = editar;
            // items.cargar = cargar;
        }

        return items
    }

    $("tr").contextMenu({
        items  : createContextMenu,
        onShow : function ($element) {
            $element.addClass("trHighlight");
        },
        onHide : function ($element) {
            $(".trHighlight").removeClass("trHighlight");
        }
    });

</script>