<div id="list-Concurso" role="main">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr style="width: 100%;">
            <th style="width: 19%;">Obra</th>
            <th style="width: 25%;">Pac</th>
            <th style="width: 10%;">Código</th>
            <th style="width: 19%;">Objeto</th>
            <th style="width: 7%;">Costo Bases</th>
            <th style="width: 7%;">Documentos</th>
            <th style="width: 7%">Estado</th>
            <th style="width: 4%">PAC</th>
            <th style="width: 1%"></th>
        </tr>
        </thead>

    </table>
</div>

<div class="" style="width: 99.7%;height: 500px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover" style="width: 100%">
        <tbody>
        <g:each in="${data}" status="i" var="cncr">
            <tr style="font-size: 11px" class="item_row" data-id="${cncr.cncr__id}" data-reg="${cncr.cncretdo}">
                <td style="width: 19%;">${cncr.obranmbr}</td>
                <td style="width: 25%;">${cncr.pacpdscr}</td>
                <td style="width: 10%;">${cncr.cncrcdgo}</td>
                <td style="width: 19%;">${cncr.cncrobjt}</td>
                <td style="text-align: right; width: 7%;">${cncr.cncrbase}</td>
                <td style="text-align: center; width: 7%;">${cncr.cuenta}</td>
                <td style="width: 7%;">
                    <strong style="color: ${cncr.cncretdo == "R" ? '#78b665' : '#c42623'} "> ${(cncr.cncretdo == "R") ? "Registrado" : "No registrado"}</strong>
                </td>
                <td style="width: 4%">
                    <a href="#" class="btn btn-success btn-xs btnVolverPac" data-id="${janus.pac.Concurso.get(cncr.cncr__id)?.pac?.id}" ><i class="fa fa-arrow-left"></i></a>
                </td>
                <td style="width: 1%">

                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>

<g:if test="${data.size() > 20}">
   <div class="alert alert-warning"> Su búsqueda ha generado más de 20 resultados, use más letras para especificar mejor la búsqueda </div>
</g:if>

<script type="text/javascript">

    $(".btnVolverPac").click(function () {
        var id = $(this).data("id");
        location.href="${createLink(controller: 'pac', action: 'pac')}?pac=" + id
    });

    $(function () {
        $("tr").contextMenu({
            items  : createContextMenu,
            onShow : function ($element) {
                $element.addClass("trHighlight");
            },
            onHide : function ($element) {
                $(".trHighlight").removeClass("trHighlight");
            }
        });
    });



    function createContextMenu (node){
        var $tr = $(node);
        var id = $tr.data("id");
        var estado = $tr.data("reg");

        var items = {
            header : {
                label : "Sin Acciones",
                header: true
            }
        };

        var ver = {
            label   : 'Ver',
            icon   : "fa fa-search",
            action : function (e) {
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action:'show_ajax')}",
                    data    : {
                        id : id
                    },
                    success : function (msg) {
                        bootbox.dialog({
                            title   : "Ver Concurso",
                            message : msg,
                            buttons : {
                                ok : {
                                    label     : "Aceptar",
                                    className : "btn-primary",
                                    callback  : function () {
                                    }
                                }
                            }
                        });
                    }
                });
            }
        };

        var editar = {
            label   : 'Editar',
            icon   : "fa fa-edit",
            action : function (e) {
                location.href = "${g.createLink(action: 'form_ajax')}/" + id
            }
        };

        var documentos = {
            label   : 'Documentos',
            icon   : "fa fa-file",
            action : function (e) {
                location.href = "${g.createLink(controller: 'documentoProceso',action: 'list')}/" + id
            }
        };

        var oferta = {
            label   : 'Ofertas',
            icon   : "fa fa-book",
            action : function (e) {
                location.href = "${g.createLink(controller: 'oferta',action: 'list')}/" + id
            }
        };

        var eliminar = {
            label   : 'Eliminar',
            icon   : "fa fa-trash",
            action : function (e) {
                deleteRow(id);
            }
        };

        items.header.label = "Acciones";
        items.ver = ver;
        items.editar = editar;
        items.documentos = documentos;
        if(estado === 'R'){
            items.oferta = oferta;
        }
        items.eliminar = eliminar;
        return items
    }



</script>