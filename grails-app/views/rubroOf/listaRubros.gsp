<table class="table table-bordered table-striped table-hover table-condensed" id="tabla">
    <thead>
    <tr>
        <th style="width: 10%">Código</th>
        <th style="width: 72%">Descripción</th>
        <th style="width: 8%">Unidad</th>
        <th style="width: 8%">Seleccionar</th>
        <th style="width: 1%"></th>
    </tr>
    </thead>
</table>

<div class="" style="width: 99.7%;height: 420px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover" style="width: 100%">
        <g:each in="${data}" var="dt" status="i">
            <tr>
                <td style="width: 9%">${dt.itemcdgo}</td>
                <td style="width: 71%">${dt.itemnmbr}</td>
                <td style="width: 8%">
                    ${dt.unddcdgo}
                </td>
                <td style="width: 8%">
                    <div style="text-align: center" class="selecciona" id="reg_${i}"
                         regNmbr="${dt?.itemnmbr}" regCdgo="${dt?.itemcdgo}"
                         regUn="${dt?.unddcdgo}" data-id="${dt?.item__id}">
                        <button class="btn btn-xs btn-success"><i class="fa fa-check"></i></button>
                    </div></td>
            </tr>
        </g:each>
    </table>
</div>

<script type="text/javascript">

    $(".selecciona").click(function () {
        var ad = $(this).data("id");
        $("#modal-rubro").dialog("close");

        if(${tipo == 'composicion'}){
            bootbox.confirm({
                title: "Copiar Composición",
                message:  '<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' +
                  "Está seguro de copiar la composición de este rubro?" + '</strong>' ,
                buttons: {
                    cancel: {
                        label: '<i class="fa fa-times"></i> Cancelar',
                        className: 'btn-primary'
                    },
                    confirm: {
                        label: '<i class="fa fa-check"></i> Copiar',
                        className: 'btn-success'
                    }
                },
                callback: function (result) {
                    if(result){
                        copiarRubroComposicionOferente(ad);
                    }
                }
            });
        }else{
            $("#listaRbro").dialog("close");
            var cd = cargarLoader("Cargando...");
            location.href = "${g.createLink(controller: 'rubroOf', action: 'rubroPrincipalOf')}?idRubro=" + ad + '&obra=' + '${obra_id}'
        }
    });

    function copiarRubroComposicionOferente(id){
        var cp = cargarLoader("Copiando...");
        var datos = "rubro=" + ${rubro} + "&copiar=" + id;
        $.ajax({
            type : "POST",
            url : "${g.createLink(controller: 'rubroOf', action: 'copiarComposicion')}",
            data     : datos,
            success  : function (msg) {
                cp.modal("hide");
                location.reload()
            }
        });
    }

</script>