<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Verificación de especificaciones</title>

    <style type="text/css">
    table {
        table-layout: fixed;
        overflow-x: scroll;
    }
    th, td {
        overflow: hidden;
        text-overflow: ellipsis;
        word-wrap: break-word;
    }

    .titulo{
        font-weight: bold;
        font-size: 16px;
    }

    </style>

</head>

<body>

<div class="tab-content ui-corner-bottom">

    <ul class="nav nav-pills">
        <li class="active"><a href="#pdfs" data-toggle="tab"><strong style="font-size: 14px">PDFS</strong></a></li>
        <li><a href="#words" data-toggle="tab"><strong style="font-size: 14px">WORDS</strong></a></li>
        <li><a href="#imas" data-toggle="tab"><strong style="font-size: 14px">IMÁGENES</strong></a></li>
    </ul>

    <div class="tab-pane active" id="pdfs">
        <div class="row">
            <div class="col-md-12 titulo" style="margin-top: 10px">
                <div class="col-md-10 alert alert-success">
                    Registros con pdfs en carpeta
                </div>
                <g:if test="${pdfs}">
                    <div class="col-md-2" style="text-align: center">
                        Registros:  ${pdfs.size()}
                    </div>
                </g:if>
            </div>

            <div role="main" style="margin-top: 5px;">
                <table class="table table-bordered table-striped table-condensed table-hover">
                    <thead>
                    <tr>
                        <th style="width: 7%">ID Ares</th>
                        <th style="width: 7%">ID Item</th>
                        <th style="width: 9%">Código</th>
                        <th style="width: 10%">Cód. Esp.</th>
                        <th style="width: 20%">Nombre</th>
                        <th style="width: 15%">Pdf</th>
                        <th style="width: 1%;"></th>
                    </tr>
                    </thead>
                </table>
            </div>

            <div class="" style="width: 99.7%; ${pdfs.size() > 10 ? "height: 250px;" : '' } overflow-y: auto;float: right; margin-top: -20px">
                <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
                    <tbody>
                    <g:if test="${pdfs}">
                        <g:each in="${pdfs}" status="i" var="pdf">
                            <tr>
                                <td style="width: 7%">${pdf?.id}</td>
                                <td style="width: 7%">${pdf?.item?.id}</td>
                                <td style="width: 9%">${pdf?.item?.codigo}</td>
                                <td style="width: 10%">${pdf?.item?.codigoEspecificacion}</td>
                                <td style="width: 20%">${pdf?.item?.nombre}</td>
                                <td style="width: 15%">${pdf?.ruta}</td>
                                <td style="width: 1%"></td>
                            </tr>
                        </g:each>
                    </g:if>
                    <g:else>
                        <td class="alert alert-info" style="text-align: center"><i class="fa fa-exclamation-triangle fa-2x text-info"></i>
                            <strong style="font-size: 16px"> No existen registros </strong>
                        </td>
                    </g:else>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="row">
            <div class="col-md-12 titulo" style="margin-top: 10px">
                <div class="col-md-10 alert alert-warning">
                    Registros SIN pdfs en carpeta
                </div>
                <g:if test="${noPdfs}">
                    <div class="col-md-2 ">
                        Registros:  ${noPdfs.size()}
                    </div>
                </g:if>
            </div>

            <div role="main" style="margin-top: 5px;">
                <table class="table table-bordered table-striped table-condensed table-hover">
                    <thead>
                    <tr>
                        <th style="width: 9%">ID Ares</th>
                        <th style="width: 9%">ID Item</th>
                        <th style="width: 9%">Código</th>
                        <th style="width: 10%">Cód. Esp.</th>
                        <th style="width: 20%">Nombre</th>
                        <th style="width: 15%">Pdf</th>
                        <th style="width: 1%;"></th>
                    </tr>
                    </thead>
                </table>
            </div>

            <div class="" style="width: 99.7%;height: 250px; overflow-y: auto;float: right; margin-top: -20px">
                <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
                    <tbody>
                    <g:if test="${noPdfs}">
                        <g:each in="${noPdfs}" status="i" var="pdf">
                            <tr>
                                <td style="width: 9%">${pdf?.id}</td>
                                <td style="width: 9%">${pdf?.item?.id}</td>
                                <td style="width: 9%">${pdf?.item?.codigo}</td>
                                <td style="width: 10%">${pdf?.item?.codigoEspecificacion}</td>
                                <td style="width: 20%">${pdf?.item?.nombre}</td>
                                <td style="width: 15%">${pdf?.ruta}</td>
                                <td style="width: 1%"></td>
                            </tr>
                        </g:each>
                    </g:if>
                    <g:else>
                        <td class="alert alert-info" style="text-align: center"><i class="fa fa-exclamation-triangle fa-2x text-info"></i>
                            <strong style="font-size: 16px"> No existen registros </strong>
                        </td>
                    </g:else>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="row">
            <div class="col-md-12" style="margin-top: 10px">
                <div class="col-md-8 alert alert-danger">
                    Pdfs sueltos que no tienen registro asociado
                </div>
                <g:if test="${borrarPdfs}">
                    <div class="col-md-2" style="text-align: center">
                        <a href="#" class="btn btn-danger btnEliminarPdfs" data-tipo="word" title="Eliminar pdfs">
                            <i class="fas fa-trash"></i> Borrar pdfs
                        </a>
                    </div>
                    <div class="col-md-2" style="text-align: center">
                        Registros: ${borrarPdfs.size()}
                    </div>
                </g:if>
            </div>

            <div role="main" style="margin-top: 5px;">
                <table class="table table-bordered table-striped table-condensed table-hover">
                    <thead>
                    <tr>
                        <th style="width: 15%">Pdfs</th>
                        <th style="width: 1%;"></th>
                    </tr>
                    </thead>
                </table>
            </div>

            <div class="" style="width: 99.7%;height: 250px; overflow-y: auto;float: right; margin-top: -20px">
                <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
                    <tbody>
                    <g:if test="${borrarPdfs}">
                        <g:each in="${borrarPdfs}" status="i" var="pdf">
                            <tr>
                                <td style="width: 15%">${pdf}</td>
                                <td style="width: 1%"></td>
                            </tr>
                        </g:each>
                    </g:if>
                    <g:else>
                        <td class="alert alert-info" style="text-align: center"><i class="fa fa-exclamation-triangle fa-2x text-info"></i>
                            <strong style="font-size: 16px"> No existen registros </strong>
                        </td>
                    </g:else>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="tab-pane " id="words">
        <div class="row">
            <div class="col-md-12 titulo" style="margin-top: 10px">
                <div class="col-md-10 alert alert-success">
                    Registros con words en carpeta
                </div>
                <g:if test="${words}">
                    <div class="col-md-2" style="text-align: center">
                        Registros:  ${words.size()}
                    </div>
                </g:if>
            </div>

            <div role="main" style="margin-top: 5px;">
                <table class="table table-bordered table-striped table-condensed table-hover">
                    <thead>
                    <tr>
                        <th style="width: 9%">ID Ares</th>
                        <th style="width: 9%">ID Item</th>
                        <th style="width: 9%">Código</th>
                        <th style="width: 10%">Cód. Esp.</th>
                        <th style="width: 20%">Nombre</th>
                        <th style="width: 15%">Word</th>
                        <th style="width: 1%;"></th>
                    </tr>
                    </thead>
                </table>
            </div>

            <div class="" style="width: 99.7%; ${words.size() > 10 ? "height: 250px;" : '' } overflow-y: auto;float: right; margin-top: -20px">
                <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
                    <tbody>
                    <g:if test="${words}">
                        <g:each in="${words}" status="i" var="word">
                            <tr>
                                <td style="width: 9%">${word?.id}</td>
                                <td style="width: 9%">${word?.item?.id}</td>
                                <td style="width: 9%">${word?.item?.codigo}</td>
                                <td style="width: 10%">${word?.item?.codigoEspecificacion}</td>
                                <td style="width: 20%">${word?.item?.nombre}</td>
                                <td style="width: 15%">${word?.especificacion}</td>
                                <td style="width: 1%"></td>
                            </tr>
                        </g:each>
                    </g:if>
                    <g:else>
                        <td class="alert alert-info" style="text-align: center"><i class="fa fa-exclamation-triangle fa-2x text-info"></i>
                            <strong style="font-size: 16px"> No existen registros </strong>
                        </td>
                    </g:else>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="row">
            <div class="col-md-12 titulo" style="margin-top: 10px">
                <div class="col-md-10 alert alert-warning">
                    Registros SIN words en carpeta
                </div>
                <g:if test="${noWords}">
                    <div class="col-md-2" style="text-align: center">
                        Registros:  ${noWords.size()}
                    </div>
                </g:if>
            </div>

            <div role="main" style="margin-top: 5px;">
                <table class="table table-bordered table-striped table-condensed table-hover">
                    <thead>
                    <tr>
                        <th style="width: 9%">ID Ares</th>
                        <th style="width: 9%">ID Item</th>
                        <th style="width: 9%">Código</th>
                        <th style="width: 10%">Cód. Esp.</th>
                        <th style="width: 20%">Nombre</th>
                        <th style="width: 15%">Word</th>
                        <th style="width: 1%;"></th>
                    </tr>
                    </thead>
                </table>
            </div>

            <div class="" style="width: 99.7%;height: 250px; overflow-y: auto;float: right; margin-top: -20px">
                <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
                    <tbody>
                    <g:if test="${noWords}">
                        <g:each in="${noWords}" status="i" var="word">
                            <tr>
                                <td style="width: 9%">${word?.id}</td>
                                <td style="width: 9%">${word?.item?.id}</td>
                                <td style="width: 9%">${word?.item?.codigo}</td>
                                <td style="width: 10%">${word?.item?.codigoEspecificacion}</td>
                                <td style="width: 20%">${word?.item?.nombre}</td>
                                <td style="width: 15%">${word?.especificacion}</td>
                                <td style="width: 1%"></td>
                            </tr>
                        </g:each>
                    </g:if>
                    <g:else>
                        <td class="alert alert-info" style="text-align: center"><i class="fa fa-exclamation-triangle fa-2x text-info"></i>
                            <strong style="font-size: 16px"> No existen registros </strong>
                        </td>
                    </g:else>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="row">
            <div class="col-md-12" style="margin-top: 10px">
                <div class="col-md-8 alert alert-danger">
                    Words sueltos que no tienen registro asociado
                </div>
                <g:if test="${borrarWords}">
                    <div class="col-md-2" style="text-align: center">
                        <a href="#" class="btn btn-danger btnEliminarWords" data-tipo="word" title="Eliminar words">
                            <i class="fas fa-trash"></i> Borrar Words
                        </a>
                    </div>
                    <div class="col-md-2" style="text-align: center">
                        Registros: ${borrarWords.size()}
                    </div>
                </g:if>
            </div>

            <div role="main" style="margin-top: 5px;">
                <table class="table table-bordered table-striped table-condensed table-hover">
                    <thead>
                    <tr>
                        <th style="width: 15%">Word</th>
                        <th style="width: 1%;"></th>
                    </tr>
                    </thead>
                </table>
            </div>

            <div class="" style="width: 99.7%;height: 250px; overflow-y: auto;float: right; margin-top: -20px">
                <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
                    <tbody>
                    <g:if test="${borrarWords}">
                        <g:each in="${borrarWords}" status="i" var="word">
                            <tr>
                                <td style="width: 15%">${word}</td>
                                <td style="width: 1%"></td>
                            </tr>
                        </g:each>
                    </g:if>
                    <g:else>
                        <td class="alert alert-info" style="text-align: center"><i class="fa fa-exclamation-triangle fa-2x text-info"></i>
                            <strong style="font-size: 16px"> No existen registros </strong>
                        </td>
                    </g:else>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="tab-pane " id="imas">
        <div class="row">
            <div class="col-md-12 titulo" style="margin-top: 10px">
                <div class="col-md-10 alert alert-success">
                    Registros con imágenes en carpeta
                </div>
                <g:if test="${imagenes}">
                    <div class="col-md-2" style="text-align: center">
                        Registros:  ${imagenes.size()}
                    </div>
                </g:if>
            </div>

            <div role="main" style="margin-top: 5px;">
                <table class="table table-bordered table-striped table-condensed table-hover">
                    <thead>
                    <tr>
                        <th style="width: 9%">ID</th>
                        <th style="width: 9%">Código</th>
                        <th style="width: 10%">Cód. Esp.</th>
                        <th style="width: 20%">Nombre</th>
                        <th style="width: 15%">Ilustración</th>
                        <th style="width: 1%;"></th>
                    </tr>
                    </thead>
                </table>
            </div>

            <div class="" style="width: 99.7%; ${imagenes.size() > 10 ? "height: 250px;" : '' } overflow-y: auto;float: right; margin-top: -20px">
                <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
                    <tbody>
                    <g:if test="${imagenes}">
                        <g:each in="${imagenes}" status="i" var="imagen">
                            <tr>
                                <td style="width: 9%">${imagen?.id}</td>
                                <td style="width: 9%">${imagen?.codigo}</td>
                                <td style="width: 10%">${imagen?.codigoEspecificacion}</td>
                                <td style="width: 20%">${imagen?.nombre}</td>
                                <td style="width: 15%">${imagen?.foto}</td>
                                <td style="width: 1%"></td>
                            </tr>
                        </g:each>
                    </g:if>
                    <g:else>
                        <td class="alert alert-info" style="text-align: center"><i class="fa fa-exclamation-triangle fa-2x text-info"></i>
                            <strong style="font-size: 16px"> No existen registros </strong>
                        </td>
                    </g:else>
                    </tbody>
                </table>
            </div>

        </div>

        <div class="row">
            <div class="col-md-12 titulo" style="margin-top: 10px">
                <div class="col-md-10 alert alert-warning">
                    Registros SIN imágenes en carpeta
                </div>
                <g:if test="${noImagenes}">
                    <div class="col-md-2" style="text-align: center">
                        Registros:  ${noImagenes.size()}
                    </div>
                </g:if>
            </div>

            <div role="main" style="margin-top: 5px;">
                <table class="table table-bordered table-striped table-condensed table-hover">
                    <thead>
                    <tr>
                        <th style="width: 9%">ID</th>
                        <th style="width: 9%">Código</th>
                        <th style="width: 10%">Cód. Esp.</th>
                        <th style="width: 20%">Nombre</th>
                        <th style="width: 15%">Ilustración</th>
                        <th style="width: 1%;"></th>
                    </tr>
                    </thead>
                </table>
            </div>

            <div class="" style="width: 99.7%;height: 250px; overflow-y: auto;float: right; margin-top: -20px">
                <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
                    <tbody>
                    <g:if test="${noImagenes}">
                        <g:each in="${noImagenes}" status="i" var="imagen">
                            <tr>
                                <td style="width: 9%">${imagen?.id}</td>
                                <td style="width: 9%">${imagen?.codigo}</td>
                                <td style="width: 10%">${imagen?.codigoEspecificacion}</td>
                                <td style="width: 20%">${imagen?.nombre}</td>
                                <td style="width: 15%">${imagen?.foto}</td>
                                <td style="width: 1%"></td>
                            </tr>
                        </g:each>
                    </g:if>
                    <g:else>
                        <td class="alert alert-info" style="text-align: center"><i class="fa fa-exclamation-triangle fa-2x text-info"></i>
                            <strong style="font-size: 16px"> No existen registros </strong>
                        </td>
                    </g:else>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="row">
            <div class="col-md-12" style="margin-top: 10px">
                <div class="col-md-8 alert alert-danger">
                    Imágenes sueltas que no tienen registro asociado
                </div>
                <g:if test="${borrarImagenes}">
                    <div class="col-md-2" style="text-align: center">
                        <a href="#" class="btn btn-danger btnEliminarImagenes" data-tipo="imas" title="Eliminar imágenes">
                            <i class="fas fa-trash"></i> Borrar Imágenes
                        </a>
                    </div>
                    <div class="col-md-2" style="text-align: center">
                        Registros: ${borrarImagenes.size()}
                    </div>
                </g:if>
            </div>

            <div role="main" style="margin-top: 5px;">
                <table class="table table-bordered table-striped table-condensed table-hover">
                    <thead>
                    <tr>
                        <th style="width: 15%">Ilustración</th>
                        <th style="width: 1%;"></th>
                    </tr>
                    </thead>
                </table>
            </div>

            <div class="" style="width: 99.7%;height: 250px; overflow-y: auto;float: right; margin-top: -20px">
                <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
                    <tbody>
                    <g:if test="${borrarImagenes}">
                        <g:each in="${borrarImagenes}" status="i" var="imagen">
                            <tr>
                                <td style="width: 15%">${imagen}</td>
                                <td style="width: 1%"></td>
                            </tr>
                        </g:each>
                    </g:if>
                    <g:else>
                        <td class="alert alert-info" style="text-align: center"><i class="fa fa-exclamation-triangle fa-2x text-info"></i>
                            <strong style="font-size: 16px"> No existen registros </strong>
                        </td>
                    </g:else>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

</div>


<script type="text/javascript">

    $(".btnEliminarPdfs").click(function () {
        borrarArchivoFisico("pdf")
    });

    $(".btnEliminarWords").click(function () {
        borrarArchivoFisico("word")
    });

    $(".btnEliminarImagenes").click(function () {
        borrarArchivoFisico("imas")
    });

    function borrarArchivoFisico(tipo){
        bootbox.confirm({
            title: "Eliminar archivo",
            message: '<i class="fa fa-trash text-danger fa-3x"></i>' + '<strong style="font-size: 14px">' + "Está seguro de borrar estos archivos? Esta acción no puede deshacerse. " + '</strong>' ,
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
                        url: '${createLink(action: 'borrarArchivoFisico_ajax')}',
                        data:{
                            tipo: tipo
                        },
                        success: function (msg) {
                            dialog.modal('hide');
                            var parts = msg.split("_");
                            if(parts[0] === 'ok'){
                                log(parts[1],"success");
                                location.reload();
                            }else{
                                log(parts[1], "error")
                            }
                        }
                    });
                }
            }
        });
    }


</script>

</body>
</html>