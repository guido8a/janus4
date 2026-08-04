
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Copiar Composición de los APUS
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
                    <div class="col-md-2" style="text-align: right">
                        <label>Obra Ofertada:</label>
                    </div>
                    <div class="col-md-9">
%{--                        <g:select name="obra" from="${obras}" optionKey="key" optionValue="value" style="width: 100%; margin-left: -80px"/>--}%

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
        </div>
    </fieldset>
</div>

<div class="col-md-12" id="divTablaEmpatados" style="margin-top: 10px">

</div>

<script type="text/javascript">
    var di;

    $('.selectObras').select2();

    $("#obra").change(function () {
        cargarTablaEmpatados();
    });

    $("#btnRegresarPrincipal").click(function () {
        location.href = "${createLink(controller: 'rubroOf', action: 'index')}";
    });

    cargarTablaEmpatados();

    function cargarTablaEmpatados() {
        var d = cargarLoader("Cargando...");
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'rubroOf', action:'tablaEmpatadosCC_ajax')}",
            data: {
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
