<%@ page contentType="text/html;charset=UTF-8" %>
<html>

<head>
    <meta name="layout" content="main">
    <title>Registrar Precios</title>
    <asset:javascript src="/apli/tableHandler.js"/>
    <asset:javascript src="/apli/tableHandlerBody.js"/>
    <asset:stylesheet src="/tableHandler.css"/>
</head>

<body>

<div class="row">
    <div class="col-md-12">
        <div class="btn-group col-md-1" style="margin-top: 20px">
            <a href="${g.createLink(controller: 'mantenimientoItems', action: 'precios')}" class="btn btn-primary" title="Regresar">
                <i class="fa fa-arrow-left"></i>
                Regresar
            </a>
        </div>
        <div class="col-md-4" align="center">
            <label>Lista de Precios</label>
            <g:select class="form-control listPrecio span2" name="listaPrecio"
                      from="${janus.Lugar.findAllByEstado('A',[sort: 'descripcion'])}" optionKey="id"
                      optionValue="${{ it.descripcion }}"
                      disabled="false" style="width: 300px;"/>
        </div>

        <div class="col-md-2" align="center">
            <label>Ver</label>
            <g:select name="tipo" from="${janus.Grupo.findAllByIdLessThanEquals(3)}" class="form-control" optionKey="id"
                      optionValue="descripcion" noSelection="['-1': 'Todos']"/>
        </div>

        <div class="btn-group col-md-2" style="margin-top: 20px">
            <a href="#" class="btn btn-consultar btn-info"><i class="fa fa-search"></i>Consultar</a>
            <a href="#" class="btn btn-actualizar btn-success"><i class="fa fa-save"></i>Guardar</a>
        </div>
    </div>
</div>

<div id="divTablaRegistrarPrecios" style="height: auto; overflow-y:auto; overflow-x: hidden; margin-top: 5px">

</div>


<script type="text/javascript">

    $(".btn-consultar").click(function () {
        consultarRegistrados();
    });

    function consultarRegistrados() {
        var d = cargarLoader("Cargando...");
        var lgar = $("#listaPrecio option:selected").val();
        var tipo = $("#tipo option:selected").val();

        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'item', action:'tablaRegistrar')}",
            data    : {
                lgar : lgar,
                tipo : tipo,
                max  : 100,
                pag  : 1
            },
            success : function (msg) {
                d.modal("hide");
                $("#divTablaRegistrarPrecios").html(msg)
            }
        });
    }

    $(".btn-actualizar").click(function () {
        $("#dlgLoad").dialog("open");
        var data = "";

        $(".editable").each(function () {
            var id = $(this).attr("id");
            var valor = $(this).data("valor");
            var data1 = $(this).data("original");

            var chk = $(this).siblings(".chk").children("input").is(":checked");

            if (chk || (parseFloat(valor) > 0 && parseFloat(data1) !== parseFloat(valor))) {
                if (data !== "") {
                    data += "&";
                }
                var val = valor ? valor : data1;
                data += "item=" + id + "_" + val + "_" + chk;
            }
        });

        $.ajax({
            type    : "POST",
            url     : "${createLink(action: 'actualizarRegistro')}",
            data    : data,
            success : function (msg) {
                $("#dlgLoad").dialog("close");
                var parts = msg.split("_");
                var ok = parts[0];
                var no = parts[1];

                $(ok).each(function () {
                    $(this).removeClass("editable").removeClass("selected");
                    var $tdChk = $(this).siblings(".chk");
                    var chk = $tdChk.children("input").is(":checked");
                    if (chk) {
                        $tdChk.html('<i class="icon-ok"></i>');
                    }
                });
                $(".editable").first().addClass("selected");
                doHighlight({elem : $(ok), clase : "ok"});
                doHighlight({elem : $(no), clase : "no"});
            }
        });
        return false;
    });

</script>
</body>
</html>