
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Emparejar items
    </title>
</head>
<body>

<div id="busqueda" style="overflow: hidden">
    <fieldset class="borde" style="border-radius: 4px">
        <div class="row-fluid">
            <div class="col-md-1 btn-group" role="navigation">
                <a href="#" class="btn btn-primary" id="btnRegresarPrincipal">
                    <i class="fa fa-arrow-left"></i>
                    Regresar
                </a>
            </div>
            <div id="list-grupo" class="col-md-11" role="main" style="margin-top: 10px;margin-left: -10px">

                <div class="col-md-12">
                    <div class="col-md-3">
                        <b style="margin-left: 20px">Obra Ofertada:</b>
                    </div>
                    <div class="col-md-9">
                        <g:select name="obra"
                                  from="${obras}" optionKey="key" optionValue="value"
                                  style="width: 100%; margin-left: -80px"/>
                    </div>
                </div>
            </div>

            <div class="col-md-2">
                Grupo
                <g:select name="buscarGrupo_name" id="buscarGrupo" from="['MT': 'Materiales', 'MO': 'Mano de Obra', 'EQ': 'Equipos']" optionKey="key" optionValue="value" class="form-control" />
            </div>
            <div class="col-md-1" style="width: 140px">
                Buscar Por
                <g:select name="buscarPor" class="buscarPor form-control" from="${[1: 'Nombre', 2: 'Código']}" style="width: 100%" optionKey="key" optionValue="value"/>
            </div>
            <div class="col-md-3">
                Criterio
                <g:textField name="criterio" class="criterio form-control"/>
            </div>
            <div class="col-md-1 btn-group" style="margin-top: 20px; width: 120px">
                <button class="btn btn-info" id="btnBuscar"><i class="fa fa-search"></i></button>
                <button class="btn btn-warning" id="btnLimpiar" title="Limpiar Búsqueda"><i class="fa fa-eraser"></i></button>
            </div>
            <div class="col-md-3 btn-group" style="margin-top: 20px">
                <button class="btn btn-success" id="btnEmparejaCdgo"><i class="fa fa-edit"></i>Emp. por Código</button>
                <button class="btn btn-success" id="btnEmparejaNmbr" title="Limpiar Búsqueda">
                    <i class="fa fa-edit"></i>Emp. por Nombre</button>
            </div>
        </div>
    </fieldset>

    <fieldset class="borde">
        <div id="divTablaBusqueda">
        </div>
    </fieldset>
</div>

<div class="col-md-12" id="divTablaEmpatados" style="margin-top: 10px">

</div>


<script type="text/javascript">
    var di;

    $("#btnRegresarPrincipal").click(function () {
        <g:if test="${tipo == '1'}">
        location.href = "${createLink(controller: 'rubroOf', action: 'index')}";
        </g:if>
        <g:else>
        location.href="${createLink(controller: 'rubroOf', action: 'rubroCon')}";
        </g:else>
    });

    $("#buscarGrupo").change(function () {
        cargarTablaBusqueda();
    });

    $("#btnBuscar").click(function () {
        cargarTablaBusqueda();
    });

    $("#btnLimpiar").click(function  () {
        $("#buscarGrupo").val('MT');
        $("#buscarPor").val(1);
        $("#criterio").val('');
        $("#ordenar").val(1);
        cargarTablaBusqueda();
    });

    $("#btnEmparejaCdgo").click(function  () {
        var obra = $("#obra").val();
        bootbox.dialog({
            title   : "Alerta",
            message : "<i class='fa fa-trash fa-2x pull-left text-danger text-shadow'></i>" +
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
                            url     : '${createLink(controller: 'rubroOf', action: 'empjCdgo')}',
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

    $("#btnEmparejaNmbr").click(function  () {
        var obra = $("#obra").val();
        bootbox.dialog({
            title   : "Alerta",
            message : "<i class='fa fa-trash fa-2x pull-left text-danger text-shadow'></i>" +
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
                            url     : '${createLink(controller: 'rubroOf', action: 'empjNmbr')}',
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


    $("#criterio").keydown(function (ev) {
        if (ev.keyCode === 13) {
            cargarTablaBusqueda();
            return false;
        }
        return true;
    });

    cargarTablaBusqueda();
    cargarTablaEmpatados();

    function cargarTablaBusqueda() {
        var d = cargarLoader("Cargando...");
        var grupo = $("#buscarGrupo option:selected").val();
        var buscarPor = $("#buscarPor option:selected").val();
        var criterio = $(".criterio").val();
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'rubroOf', action:'tablaBusqueda_ajax')}",
            data: {
                buscarPor: buscarPor,
                criterio: criterio,
                grupo: grupo,
                obra: $("#obra").val()
            },
            success: function (msg) {
                d.modal("hide");
                $("#divTablaBusqueda").html(msg);
            }
        });
        cargarTablaEmpatados()
    }

    function cargarTablaEmpatados() {
        var d = cargarLoader("Cargando...");
        var tipo = $("#buscarGrupo").val();
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'rubroOf', action:'tablaEmpatados_ajax')}",
            data: {
                tipo: tipo,
                obra: $("#obra").val()
            },
            success: function (msg) {
                d.modal("hide");
                $("#divTablaEmpatados").html(msg);
            }
        });
    }

</script>

</body>
</html>
