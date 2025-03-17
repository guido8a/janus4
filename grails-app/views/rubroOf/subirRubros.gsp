<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Subir excel de Rubros</title>
    <style type="text/css">
    table, th, td {
        border: 1px solid white;
    }

    .contenedor {
        width: 100%;
        border: 1px solid #888;
        /*overflow-x: scroll;*/
        /*overflow-y: hidden;*/
        white-space: nowrap;
        background-color: #b8c8d8;
        height: 35px;
        padding: 2px;
        margin-bottom: 5px;
        border-radius: 4px;
    }

    .inside {
        /*width: 50%;*/
        height: 25px;
        /*border: 1px solid black;*/
        display: inline-block;
        font-size: 12pt;
        text-align: left;
        color: #0A246A;
    }

    </style>
</head>

<body>

<div class="row">
    <div class="col-md-3">
        <a href="#" class="btn btn-primary" id="btnRegresar">
            <i class="fa fa-arrow-left"></i>
            Regresar
        </a>
        <a href="#"  class="btn btn-danger" id="btnBorrar">
            <i class="fa fa-trash"></i>
            Eliminar los APU
        </a>
    </div>

    <div class="col-md-9" style="margin-top: -15px;">
        <h3>Cargar los Rubros del oferente: ${oferente.nombre} ${oferente.apellido}</h3>
    </div>

</div>

<g:if test="${flash.message}">
    <div class="alert alert-error">
        ${flash.message}
    </div>
</g:if>

<g:uploadForm controller="rubroOf" action="uploadRubros" method="post" name="frmUpload" id="${contrato?.id}"
              style="padding: 10px">
    <div id="list-grupo" class="col-md-12" role="main">
        <div class="col-md-2">
            <b style="margin-left: 20px">Obra Ofertada:</b>
        </div>
        <div class="col-md-10">
            <g:select name="obra"
                      from="${obras}" optionKey="key" optionValue="value"
                      style="width: 100%; margin-left: -80px"/>
        </div>

        <div style="border-style: groove; border-color: #0d7bdc; margin-top: 40px; margin-bottom: 10px">
            <fieldset style="padding: 0px 20px 0px 20px">
                <h6 style="text-align: left">Formato del archivo de excel (se puede usar todos los decimales)</h6>
                <table class="table" style="background-color: #5a7ab2; color: #fff; margin-bottom: 30px">
                    <tr>
                        <th style="border: 1px solid #ddd; text-align: center">
                            A - RUBRO NÚMERO
                        </th>
                        <th style="border: 1px solid #ddd; text-align: center">
                            B - DESCRIPCIÓN
                        </th>
                        <th style="border: 1px solid #ddd; text-align: center">
                            C - UNIDAD
                        </th>
                        <th style="border: 1px solid #ddd; text-align: center">
                            D - CANTIDAD
                        </th>
                        <th style="border: 1px solid #ddd; text-align: center">
                            E - PRECIO UNITARIO
                        </th>
                        <th style="border: 1px solid #ddd; text-align: center">
                            F - PRECIO TOTAL
                        </th>
                    </tr>
                    <tr style="background-color: #ddd; color: #444;">
                        <td style="border: 1px solid #ddd; text-align: center">
                            1
                        </td>
                        <td style="border: 1px solid #ddd; text-align: center">
                            ACERO DE REFUERZO EN BARRAS- F'Y=4200 Kg/CM2
                        </td>
                        <td style="border: 1px solid #ddd; text-align: center">
                            kg
                        </td>
                        <td style="border: 1px solid #ddd; text-align: center">
                            1200
                        </td>
                        <td style="border: 1px solid #ddd; text-align: center">
                            2.01
                        </td>
                        <td style="border: 1px solid #ddd; text-align: center">
                            2412.00
                        </td>
                    </tr>
                </table>
            </fieldset>
        </div>




        <div class="col-md-12" style="margin-top: 20px;">
            <div class="col-md-5">
                <label>Ingrese el nombre de la página excel que contiene los rubros en el formato indicado</label>
            </div>
            <div class="col-md-2" style="margin-left: -50px">
                <g:textField name="rbro" class="form-control" value="Rubros"/>
            </div>
        </div>

        <div class="col-md-12" style="margin-top: 20px; margin-bottom: 20px">
            <div class="col-md-2"><b>Archivo Excel a subir, no contiene rubros repetidos:</b></div>

            <div class="col-md-8">
                <input type="file" class="required" name="file" multiple accept=".xlsx"
                       style="width: 100%; font-size: 12pt" value="Arch"/>
            </div>

            <div class="col-md-2">
                <a href="#" class="btn btn-success" id="btnSubmitRubro"><i class="fa fa-upload"></i>
                    Procesar archivo de Rubros</a>
            </div>
        </div>

    </div>


</g:uploadForm>

<script type="text/javascript">

    $("#btnRegresar").click(function () {
        <g:if test="${tipo == '1'}">
        location.href = "${createLink(controller: 'rubroOf', action: 'index')}";
        </g:if>
        <g:else>
        location.href = "${createLink(controller: 'rubroOf', action: 'rubroPrincipalOf')}";
        </g:else>
    });

    $("#btnBorrar").click(function () {
        bootbox.confirm({
            title: "Eliminar los APUS del oferente",
            message: "<i class='fa fa-exclamation-triangle text-warning fa-3x'></i> Está seguro de que desea borrar " +
            "todos los APU cargados del oferente para la obra:<br><strong>" + $("#obra").text() + "</strong>",
            buttons: {
                cancel: {
                    label: '<i class="fa fa-times"></i> Cancelar',
                    className: 'btn-primary'
                },
                confirm: {
                    label: '<i class="fa fa-check"></i> Aceptar',
                    className: 'btn-success'
                }
            },
            callback: function (result) {
                if(result){
                    var g = cargarLoader("Cargando...");
                    $.ajax({
                        type: "POST",
                        url: "${createLink(controller: 'rubroOf', action: 'borrarApus')}",
                        data: {
                            obra: $("#obra").val()
                        },
                        success: function (msg) {
                            g.modal("hide");
                            var parts = msg.split("_");
                            if(parts[0] === 'Ok'){
                                log("Borrados correctamente","success");
                                setTimeout(function () {
                                    location.reload();
                                }, 800);
                            }else{
                                log("Error al borrar", "error")
                            }
                        }
                    })
                }
            }
        });

        %{--location.href = "${createLink(controller: 'rubroOf', action: 'borrarApus')}?obra=" +--}%
        %{--    $("#obra").val()--}%
    });

    $("#btnSubmitRubro").click(function () {
        if ($("#frmUpload").valid()) {
            $("#frmUpload").submit();
        }
    });

</script>
</body>
</html>