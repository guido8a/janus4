<table class="table table-bordered table-striped table-hover table-condensed" id="tabla">
    <thead>
    <tr style="width: 100%">
        <th style="width: 25%">Tipo</th>
        <th style="width: 10%">Código</th>
        <th style="width: 40%">Descripción</th>
        <th style="width: 15%">Estado</th>
        <th style="width: 9%">Acciones</th>
        <th style="width: 1%"></th>
    </tr>
    </thead>
</table>

<div class="" style="width: 99.7%;height: 430px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover" style="width: 100%">
        <g:each in="${listas}" var="lista" >
            <tr style="width: 100%">
                <td style="width: 25%">${lista?.tipoLista?.descripcion}</td>
                <td style="width: 10%">${lista?.codigo}</td>
                <td style="width: 40%">${lista?.descripcion}</td>
                <td style="width: 15%;font-weight: bold; text-align: center;  background-color: ${lista?.estado == 'A' ? '#80b080' : '#c08080'}">${lista?.estado == 'A' ? 'Activo' : 'Inactivo'}</td>
                <td style="width: 9%; text-align: center">
                    <a href="#" class="btn btn-success btn-xs btnEditarLista" title="Editar lista" data-id="${lista.id}">
                        <i class="fa fa-edit"></i>
                    </a>
%{--                    <a href="#" class="btn btn-danger btn-xs btnBorrarLista" title="Borrar lista" data-id="${lista.id}">--}%
%{--                        <i class="fa fa-trash"></i>--}%
%{--                    </a>--}%
                </td>
                <td style="width: 1%"></td>
            </tr>
        </g:each>
    </table>
</div>

<script type="text/javascript">

    $(".btnEditarLista").click(function () {
        var id = $(this).data("id");
        createEditLista(id);
    })


</script>