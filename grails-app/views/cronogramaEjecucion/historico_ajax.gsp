
<div class="row">
    <div class="col-md-12 pagination">
        <div class="col-md-10">
            <g:each in="${paginas}" var="pg">
                <a href="#" class="btn btn-warning btnPg" id="btn_${pg}" data-valor="${pg}">
                    <i class="fa fa-file"></i> ${pg}
                </a>
            </g:each>
        </div>

        <div class="btn col-md-2" style="">Páginas de 10 rubros: Página actual: <strong id="divActual"></strong> </div>
    </div>
</div>

<div id="divTablaHistorico" style="height: 600px; overflow: auto; width: 100%">

</div>

<script type="text/javascript">

    $(".btnPg").click(function () {
        var pag = $(this).data("valor");
        $(".btnPg").removeClass("active");
        $("#btn_" + pag).addClass("active");
        $("#divActual").html(pag);
        cargarTablaHistorico(pag);
    });

    primeroActive();

    function primeroActive(){
        $("#btn_" + 1).addClass("active");
        $("#divActual").html("1")
    }

    cargarTablaHistorico();

    function cargarTablaHistorico(pag) {
        var g = cargarLoader("Cargando...");
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'cronogramaEjecucion', action: 'tablaHistoricos_ajax')}",
            data: {
                id: ${contrato.id},
                pag: pag,
                modificacion: '${modificacion.id}'
            },
            success: function (msg) {
                g.modal("hide");
                $("#divTablaHistorico").html(msg);
            }
        });
    }

</script>
