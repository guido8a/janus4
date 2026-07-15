<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Editar precios</title>
</head>
<body>

<div class="row" style="margin-left: 10px">
    <div class="col-md-12">
        <div class="col-md-2 btn-toolbar toolbar" >
            <div class="btn-group">
                <g:link controller="mantenimientoItems" action="precios" class="btn btn-primary">
                    <i class="fa fa-arrow-left"></i> Regresar
                </g:link>
            </div>
        </div>
        <div class="col-md-9 breadcrumb">
            <strong style="font-size: 14px;">${item?.codigo + " - "  +  item?.nombre}</strong>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-12">
        <div class="col-md-2">
        </div>
        <div class="col-md-5">
            <span class="grupo">
                <span class="col-md-3">
                    <label class="control-label text-info" style="text-align: center">Año</label>
                    <g:select style="font-size:large;" name="anio" class="form-control" from="${anio..anio - 1}" />
                </span>
                <span class="col-md-4" id="divFecha" style="text-align: center">

                </span>
            </span>
            <div class="col-md-1" style="margin-top: 20px">
                <button class="btn btn-info" id="btnBuscar" title="Buscar"><i class="fa fa-search"></i> Consultar</button>
            </div>
        </div>
        <div class="col-md-3" style="margin-top: 20px">
%{--            <a href="#" class="btn btn-success btnNuevoPrecio" data-id="${item?.id}" title="Nuevo Precio">--}%
%{--                <i class="fas fa-file"></i> Nuevo Precio--}%
%{--            </a>--}%
%{--        </div>--}%
    </div>
    <div class="col-md-12">
        <div class="col-md-2"></div>
        <div class="col-md-7" id="divTablaPrecios" >
        </div>
    </div>
</div>



<script type="text/javascript">

    $("#btnBuscar").click(function () {
        cargarTablaPrecios();
    });

    function cargarTablaPrecios(){
        var fecha = $("#fecha option:selected").val();
        var anio = $("#anio option:selected").val();
        var id = '${item?.id}';
        if(fecha){
            var d = cargarLoader("Cargando...");
            $.ajax({
                type: 'POST',
                url: '${createLink(controller: 'mantenimientoItems', action: 'tablaEditarPrecios_ajax')}',
                data:{
                    id: id,
                    anio: anio,
                    fecha: fecha
                },
                success: function (msg){
                    d.modal("hide");
                    $("#divTablaPrecios").html(msg)
                }
            })
        }else{
            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 16px">' + "Seleccione una fecha" + '</strong>');
        }
    }

    cargarFechas();

    function cargarFechas(){
        var id = '${item?.id}';
        var anio = $("#anio option:selected").val();
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'mantenimientoItems', action: 'fechasPrecios_ajax')}',
            data:{
                id: id,
                anio: anio
            },
            success: function (msg){
                $("#divFecha").html(msg)
            }
        })
    }

    $("#anio").change(function () {
        cargarFechas();
    });

</script>

</body>
</html>
