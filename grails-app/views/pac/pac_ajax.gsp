<div class="row alert alert-info">
    <div class="col-md-12 breadcrumb" style="font-size: 18px; text-align: center; font-weight: bold">
        P.A.C.
    </div>
    <div class="col-md-12" >
        <div class="col-md-1">
            <label style="font-size: 18px; text-align: center; font-weight: bold">
                P.A.C.
            </label>
        </div>
        <div class="col-md-8">
            <g:select name="pac" from="${pacs}" value="" optionValue="${{it.descripcion + " - " + (it?.c1 ? " C1 " :( it?.c2 ? "C2" : "C3" )) }}" optionKey="id" class="form-control" />
        </div>
        <div class="col-md-2" style="margin-top: 2px; float: right">
            <a href="#" class="btn btn-success btnNuevaAsignacion"><i class="fa fa-file"></i> Nuevo PAC</a>
        </div>

        <div id="divTablaPAC">

        </div>
    </div>
</div>

<script type="text/javascript">

    $("#pac").change(function () {
        cargarDatosPAC();
    });

    cargarDatosPAC();

    function cargarDatosPAC() {
        var pac = $("#pac option:selected").val();
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'pac', action:'tablaDatosPAC_ajax')}",
            data: {
                id: pac
            },
            success: function (msg) {
                $("#divTablaPAC").html(msg);
                cargarConcurso(pac);
            }
        });
    }

</script>