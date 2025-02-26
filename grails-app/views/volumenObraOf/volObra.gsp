<%@ page import="janus.Grupo" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Volumenes de obra
    </title>

    <asset:javascript src="/jquery/plugins/jQuery-contextMenu-gh-pages/src/jquery.contextMenu.js"/>
    <asset:stylesheet src="/jquery/plugins/jQuery-contextMenu-gh-pages/src/jquery.contextMenu.css"/>
</head>
<body>
<div class="span12">
    <g:if test="${flash.message}">
        <div class="alert ${flash.clase ?: 'alert-info'}" role="status">
            <a class="close" data-dismiss="alert" href="#">×</a>
            ${flash.message}
        </div>
    </g:if>
</div>

<div class="alert alert-info" style="font-size: 14px;">
    Volumen de la obra: ${obra.descripcion + " ("+obra.codigo+")"}
</div>

<div class="col-md-12 btn-group" role="navigation" style="margin-left: 35px;">
    <a href="${g.createLink(controller: 'obraOf', action: 'registroObra', params: [obra: obra?.id])}"  class="btn btn-info btn-new" id="atras" title="Regresar a la obra">
        <i class="fa fa-arrow-left"></i>
        Regresar
    </a>
</div>

<div id="list-grupo" style="margin-top: 20px;">
        <div class="col-md-12">
            <div class="col-md-4">
                <b style="font-size: 14px; font-weight: bold">Memo:</b> ${obra?.memoCantidadObra}
            </div>
            <div class="col-md-4">
                <b style="font-size: 14px; font-weight: bold">Ubicación:</b> ${obra?.parroquia?.nombre}
            </div>
            <div class="col-md-2" >
                <b style="font-size: 14px; font-weight: bold">Dist. peso:</b> ${obra?.distanciaPeso}
            </div>
            <div class="col-md-2" >
                <b style="font-size: 14px; font-weight: bold">Dist. volúmen:</b> ${obra?.distanciaVolumen}
            </div>
        </div>
</div>

<div class="borde_abajo" style="position: relative;float: left;padding-left: 45px">
    <p class="css-vertical-text">Composición</p>
    <div class="linea" style="height: 98%;"></div>

    <div id="detalle"></div>
</div>

<script type="text/javascript">


    function cargarTabla(){
        var d = cargarLoader("Cargando...");
        var datos="";
        if($("#subPres_desc").val()*1>0){
            datos = "obra=${obra.id}&sub="+$("#subPres_desc").val()
        }else{
            datos = "obra=${obra.id}"
        }
        $.ajax({
            type : "POST",
            url : "${g.createLink(controller: 'volumenObraOf',action:'tabla')}",
            data     : datos,
            success  : function (msg) {
                d.modal("hide");
                $("#detalle").html(msg)
            }
        });
    }

    cargarTabla();

    $("#vol_id").val("");

</script>
</body>
</html>