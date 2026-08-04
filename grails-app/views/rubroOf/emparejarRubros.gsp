<!doctype html>
<html>
<head>
    <meta name="layout" content="main">

    <title>
        Emparejar rubros
    </title>

</head>
<body>

<div id="busqueda" style="overflow: hidden">
    <fieldset class="borde" style="border-radius: 4px">
        <h3 style="margin-top: -5px; text-align: center">Emparejar los rubros del oferente con los del sistema</h3>
        <div class="row-fluid">
            <div class="col-md-1 btn-group" role="navigation">
                <a href="#" class="btn btn-primary" id="btnRegresarPrincipal">
                    <i class="fa fa-arrow-left"></i>
                    Regresar
                </a>
            </div>

            <div class="col-md-9" role="main" style="margin-top: 0px;margin-left: -25px">
                <div class="col-md-12">
                    <div class="col-md-1">
                        <label>Obra Ofertada:</label>
                    </div>
                    <div class="col-md-11">
%{--                        <g:select name="obra" class="form-control bootstrap-select wrapped-select"--}%
%{--                                  from="${obras}" optionKey="key" optionValue="value"--}%
%{--                                  />--}%

                        <select id="obra" class="selectObras col-md-12" >
                        <g:each in="${obras}" var="obraSeleccionada">
                            <option class="obra" value="${obraSeleccionada?.key}">
                               ${obraSeleccionada?.value}
                            </option>
                        </g:each>
                        </select>
                    </div>
                </div>
            </div>
            <div class="col-md-2" role="main" style="margin-top: 0px;margin-left: -35px">
                <div class="col-md-9 btn-group" >
                    <button class="btn btn-success" id="btnEmparejaNmbr" title="Limpiar Búsqueda">
                        <i class="fa fa-edit"></i>Emp. por Nombre</button>
                </div>
                <div class="col-md-3 btn-group" role="navigation" style="margin-left: 0px">
                    <a href="#" class="btn btn-primary" id="btnSiguiente">
                        Continuar
                        <i class="fa fa-arrow-right"></i>
                    </a>
                </div>
            </div>
        </div>
    </fieldset>

    <fieldset class="borde">
        <div id="divTablaBusquedaRubros">
        </div>
    </fieldset>
</div>

<div class="col-md-12" id="divTablaEmpatadosRubros" style="margin-top: 10px">

</div>

<script type="text/javascript">

    var di;

    $('.selectObras').select2();

    $("#btnRegresarPrincipal").click(function () {
        location.href = "${createLink(controller: 'rubroOf', action: 'index')}";
    });

    $("#btnSiguiente").click(function () {
        location.href = "${createLink(controller: 'rubroOf', action: 'subirExcelApu')}";
    });

    $(".selectObras").change(function () {
        cargarTablaBusquedaRubros();
    });

    cargarTablaBusquedaRubros();

    function cargarTablaBusquedaRubros() {
        var d = cargarLoader("Cargando...");
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'rubroOf', action:'tablaBusquedaRubros_ajax')}",
            data: {
                obra: $("#obra option:selected").val()
            },
            success: function (msg) {
                d.modal("hide");
                $("#divTablaBusquedaRubros").html(msg);
            }
        });
        cargarTablaEmpatadosRubros()
    }

    function cargarTablaEmpatadosRubros() {
        var d = cargarLoader("Cargando...");
        var tipo = $("#buscarGrupo").val();
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'rubroOf', action:'tablaEmpatadosRubros_ajax')}",
            data: {
                tipo: tipo,
                obra: $("#obra option:selected").val()
            },
            success: function (msg) {
                d.modal("hide");
                $("#divTablaEmpatadosRubros").html(msg);
            }
        });
    }

    $("#btnEmparejaNmbr").click(function  () {
        var obra = $("#obra").val();
        bootbox.dialog({
            title   : "Alerta",
            message : "<i class='fa fa-check fa-2x pull-left text-danger text-shadow'></i>" +
            "<p style='font-weight: bold'> Está seguro que desea emparejar items del mismo nombre?</p>",
            buttons : {
                cancelar : {
                    label     : "Cancelar",
                    className : "btn-primary",
                    callback  : function () {
                    }
                },
                aceptar : {
                    label     : "<i class='fa fa-check'></i> Emparejar",
                    className : "btn-info",
                    callback  : function () {
                        var v = cargarLoader("Emparejando...");
                        $.ajax({
                            type    : "POST",
                            url     : '${createLink(controller: 'rubroOf', action: 'empjNmbrRbro')}',
                            data    : {
                                obra : obra
                            },
                            success : function (msg) {
                                v.modal("hide");
                                var parts = msg.split("_");
                                if(parts[0] === 'ok'){
                                    log(parts[1],"success");
                                    setTimeout(function () {
                                        location.reload()
                                    }, 1000);
                                }else{
                                    log(parts[1],"error")
                                }
                            }
                        });
                    }
                }
            }
        });
        return false;
    });


</script>

</body>
</html>
