%{--<div style="position: fixed; top: 150px; right: 1100px;">--}%
%{--    <strong>Número de rubros desplegados: ${numero}</strong>--}%
%{--</div>--}%
%{--<div class="col-md-12" style="text-align: center; font-size: 14px; font-weight: bold">--}%
%{--    <div class="col-md-4"></div>--}%
%{--    <div class="col-md-2" role="alert">--}%
%{--        <ol class="breadcrumb" style="font-weight: bold">--}%
%{--            <li class="active"><i class="fa fa-${grupo?.descripcion == 'OBRAS VIALES' ? 'car' : (grupo?.descripcion == 'OBRAS DE RIEGO' ? 'water' : 'hammer') } text-warning"></i> ${grupo?.descripcion}</li>--}%
%{--        </ol>--}%
%{--    </div>--}%
%{--    <div class="col-md-4" role="alert">--}%
%{--        <ol class="breadcrumb" style="font-weight: bold">--}%
%{--            <li class="active">GRUPO</li>--}%
%{--            <li class="active">SUBGRUPO</li>--}%
%{--            <li class="active">RUBROS</li>--}%
%{--        </ol>--}%
%{--    </div>--}%
    %{--    <div class="col-md-2">--}%
    %{--        <a href="#" class="btn btn-sm btn-success btnNuevoMaterial" title="Crear nuevo material">--}%
    %{--            <i class="fas fa-file"></i> Nuevo Material--}%
    %{--        </a>--}%
    %{--    </div>--}%
%{--    <div class="col-md-2">--}%
%{--        <a href="#" class="btn btn-sm btn-success btnRegresarMaterial" title="Regresar">--}%
%{--            <i class="fas fa-arrow-left"></i>--}%
%{--        </a>--}%
%{--    </div>--}%
%{--</div>--}%

<div role="main" style="margin-top: 5px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 7%">Código Grupo</th>
            <th style="width: 15%">Grupo</th>
            <th style="width: 7%">Código Subgrupo</th>
            <th style="width: 15%">Subgrupo</th>
            <th style="width: 10%">Código</th>
            <th style="width: 35%">Descripción</th>
            <th style="width: 12%">Acciones</th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
        <tbody>
        <g:each in="${materiales}" status="i" var="material">
            <tr data-id="${material?.id}">
                <td style="width: 7%">${material?.departamento?.subgrupo?.codigo}</td>
                <td style="width: 15%">${material?.departamento?.subgrupo?.descripcion}</td>
                <td style="width: 7%">${material?.departamento?.codigo}</td>
                <td style="width: 15%">${material?.departamento?.descripcion}</td>
                <td style="width: 10%">${material?.codigo}</td>
                <td style="width: 35%">${material?.nombre}</td>
                <td style="width: 12%; text-align: center">
                    <a href="#" class="btn btn-xs btn-info btnVerMaterial" data-id="${material?.id}" title="Ver">
                        <i class="fas fa-search"></i>
                    </a>
                    <a href="#" class="btn btn-xs btn-primary btnImprimirRubro" data-id="${material?.id}" title="Imprimir rubro">
                        <i class="fas fa-print"></i>
                    </a>
                    %{--                    <a href="#" class="btn btn-xs btn-warning btnEspecificacionesMaterial" data-id="${material?.id}" title="Especificaciones e Ilustración" ${material?.codigoEspecificacion ?: 'disabled'}>--}%
                    %{--                        <i class="fas fa-book"></i>--}%
                    %{--                    </a>--}%
                    %{--                    <a href="#" class="btn btn-xs btn-success btnEditarMaterial" data-id="${material?.id}" data-sub="${material?.departamento?.id}" title="Editar">--}%
                    %{--                        <i class="fas fa-edit"></i>--}%
                    %{--                    </a>--}%
                    %{--                    <a href="#" class="btn btn-xs btn-danger btnEliminarMaterial" data-id="${material?.id}" title="Eliminar">--}%
                    %{--                        <i class="fas fa-trash"></i>--}%
                    %{--                    </a>--}%
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>

<script type="text/javascript">


    $(".btnEspecificacionesMaterial").click(function () {
        var id = $(this).data("id");
        var child = window.open('${createLink(controller:"mantenimientoItems",action:"especificaciones_ajax")}?id=' + id,
            'janus4', 'width=850,height=800,toolbar=0,resizable=0,menubar=0,scrollbars=1,status=0');

        if (child.opener == null)
            child.opener = self;
        window.toolbar.visible = false;
        window.menubar.visible = false;
    });

    $(".btnVerMaterial").click(function () {
        var id = $(this).data("id");
        verMaterial(id);
    });

    $(".btnRegresarMaterial").click(function () {
        $("#buscarPor").val(${grupo?.id});
        $("#tipo").val(2);
        if('${id}'){
            $("#criterio").val('${materiales?.size() > 0 ? materiales?.first()?.departamento?.descripcion : ''}');
        }else{
            $("#criterio").val('');
        }

        cargarTablaGrupoRubros();
    });

    $(".btnEditarMaterial").click(function () {
        var id = $(this).data("id");
        var sub =$(this).data("sub");
        createEditItem(id, sub)
    });

    $(".btnEliminarMaterial").click(function () {
        var id = $(this).data("id");
        deleteMaterial(id);
    });

    function deleteMaterial(id){
        bootbox.confirm({
            title: "Eliminar Grupo",
            message: '<i class="fa fa-trash text-danger fa-3x"></i>' + '<strong style="font-size: 14px">' + "Está seguro de borrar este material? Esta acción no puede deshacerse. " + '</strong>' ,
            buttons: {
                cancel: {
                    label: '<i class="fa fa-times"></i> Cancelar',
                    className: 'btn-primary'
                },
                confirm: {
                    label: '<i class="fa fa-trash"></i> Borrar',
                    className: 'btn-danger'
                }
            },
            callback: function (result) {
                if(result){
                    var dialog = cargarLoader("Borrando...");
                    $.ajax({
                        type: 'POST',
                        url: '${createLink(controller: 'mantenimientoItems', action: 'deleteIt_ajax')}',
                        data:{
                            id: id
                        },
                        success: function (msg) {
                            dialog.modal('hide');
                            var parts = msg.split("_");
                            if(parts[0] === 'ok'){
                                log(parts[1],"success");
                                cargarTablaGrupoRubros(parts[2]);
                            }else{
                                log(parts[1], "error")
                            }
                        }
                    });
                }
            }
        });
    }

    function verMaterial(id) {
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'grupo', action:'showRb_ajax')}",
            data    : {
                id: id
            },
            success : function (msg) {
                var e = bootbox.dialog({
                    id    : "dlgVerMaterial",
                    title : "Datos del rubro",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        }
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    } //createEdit


    $(".btnImprimirRubro").click(function () {
        var id = $(this).data("id");
        imprimirRubrosGrupo(id, 'rb');
    });

</script>