<div class="row">
    <div class="col-md-12">
        <div class="col-md-2"></div>
        <div class="col-md-3">
            <a href="#" class="btn btn-info btnUno" data-id="${id}" title="Guardar precio solo para el lugar">
                <i class="fas fa-save"></i> Guardar individual
            </a>
        </div>
        <div class="col-md-3">
            <a href="#" class="btn btn-success btnVarios" data-id="${id}" title="Guardar precio para todos los lugares">
                <i class="fas fa-tasks"></i> Guardar para todos
            </a>
        </div>
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
