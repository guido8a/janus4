<div class="row">
    <div class="col-md-12" style="text-align: center; font-size: 14px; font-weight: bold">
        ${item?.codigo + " - " + item?.nombre }
    </div>
</div>

<div class="row">
    <div class="col-md-12" style="text-align: center">
        <a href="#" class="btn btn-info btnUno" data-id="${id}" title="Guardar precio solo para el lugar">
            <i class="fas fa-save"></i> Guardar para ${janus.PrecioRubrosItems.get(id)?.lugar?.descripcion}
        </a>
    </div>
</div>

<div class="row">
    <div class="col-md-12" style="text-align: center">
        <a href="#" class="btn btn-success btnVarios" data-id="${id}" title="Guardar precio para todos los lugares">
            <i class="fas fa-tasks"></i> Guardar para todos
        </a>
    </div>
</div>

<script type="text/javascript">

    $(".btnUno").click(function (){
        guardarPrecio('${id}', '${valor}')
    });

    $(".btnVarios").click(function (){
        guardarPrecio('${id}', '${valor}', 2)
    })


</script>
