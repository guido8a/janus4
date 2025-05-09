<g:form class="form-horizontal" name="frmPac" role="form" controller="pac" action="savePac_ajax" method="POST">
    <g:hiddenField name="id" value="${pac?.id}" />

    <div class="form-group ${hasErrors(bean: pac, field: 'anio', 'error')} required">
        <span class="grupo">
            <label for="anio" class="col-md-2 control-label text-info">
                Año
            </label>
            <span class="col-md-3">
                <g:select class="form-control" name="anio" from="${janus.pac.Anio.list(sort: 'anio')}" value="${pac?.anio?.id ? pac?.anio?.id  : ( asignacion?.anio?.id ?: actual?.id)}" optionKey="id" optionValue="anio"/>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: pac, field: 'presupuesto', 'error')} required">
        <span class="grupo">
            <label for="presupuestoName" class="col-md-2 control-label text-info">
                Partida
            </label>
            <span class="col-md-8">
                <g:hiddenField name="presupuesto" value="${pac?.presupuesto?.id ?: asignacion?.prespuesto?.id}" required="" />
                <g:textArea name="presupuestoName" required="" readonly="" class="form-control required" value="${pac?.presupuesto?.descripcion ?: asignacion?.prespuesto?.descripcion}" style="height: 100px; resize: none"/>
            </span>

            <span class="col-md-1">
                <a href="#" class="btn btn-info btnPartida" ><i class="fa fa-search"></i></a>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: pac, field: 'codigo', 'error')}">
        <span class="grupo">
            <label for="presupuestoCodigo" class="col-md-2 control-label text-info">
                Número
            </label>
            <span class="col-md-8">
                <g:textField name="presupuestoCodigo" readonly="" class="form-control" value="${pac?.presupuesto?.numero ?: asignacion?.prespuesto?.numero}"/>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: pac, field: '', 'error')}">
        <span class="grupo">
            <label for="techo" class="col-md-2 control-label text-info">
                Techo
            </label>
            <span class="col-md-2">
                <input type="text" id="techo" disabled="" style="text-align: right" class="form-control">
            </span>
            <label for="usado" class="col-md-1 control-label text-info">
                Comprometido
            </label>
            <span class="col-md-2">
                <input type="text" id="usado" disabled="" style="text-align: right" class="form-control">
            </span>
            <label for="disponible" class="col-md-1 control-label text-info">
                Disponible
            </label>
            <span class="col-md-2">
                <input type="text" id="disponible" disabled="" style="text-align: right" class="form-control">
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: pac, field: 'descripcion', 'error')} required">
        <span class="grupo">
            <label for="descripcion" class="col-md-2 control-label text-info">
                Descripción
            </label>
            <span class="col-md-8">
                <g:textArea name="descripcion" required="" class="form-control required" value="${pac?.descripcion}" style="height: 100px; resize: none"/>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: pac, field: 'cantidad', 'error')} ${hasErrors(bean: pac, field: 'costo', 'error')} required">
        <span class="grupo">
            <label for="cantidad" class="col-md-2 control-label text-info">
                Cantidad
            </label>
            <span class="col-md-2">
                <g:textField name="cantidad" class="form-control required" value="${g.formatNumber(number: pac?.cantidad, maxFractionDigits: 2, minFractionDigits: 2,
                        locale: 'ec')}" />
            </span>
            <label for="costo" class="col-md-2 control-label text-info">
                Costo
            </label>
            <span class="col-md-4">
                <g:textField name="costo" class="form-control required" value="${g.formatNumber(number: pac?.costo, maxFractionDigits: 2, minFractionDigits: 2,
                        locale: 'ec')}" />
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: pac, field: 'unidad', 'error')} ${hasErrors(bean: pac, field: 'memo', 'error')}">
        <span class="grupo">
            <label for="unidad" class="col-md-2 control-label text-info">
                Unidad
            </label>
            <span class="col-md-2">
                <g:select name="unidad" from="${janus.pac.UnidadIncop.list()}" optionKey="id" optionValue="codigo" class="form-control" value="${pac?.unidad?.id}" />
            </span>
            <label for="memo" class="col-md-2 control-label text-info">
                Memo
            </label>
            <span class="col-md-4">
                <g:textField name="memo" class="form-control required" required="" value="${pac?.memo}" />
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: pac, field: 'requiriente', 'error')} ">
        <span class="grupo">
            <label for="requiriente" class="col-md-2 control-label text-info">
                Requirente
            </label>
            <span class="col-md-8">
                <g:textField name="requiriente" maxlength="100" required="" class="form-control required" value="${pac?.requiriente}"/>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: pac, field: 'departamento', 'error')}">
        <span class="grupo">
            <label for="departamento" class="col-md-2 control-label text-info">
                Coordinación
            </label>
            <span class="col-md-8">
                <g:select name="departamento" from="${janus.Departamento.list([sort: 'descripcion'])}" optionKey="id" optionValue="descripcion" class="form-control" value="${pac?.departamento?.id}" />
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: pac, field: 'tipoCompra', 'error')} ${hasErrors(bean: pac, field: 'tipoProcedimiento', 'error')}">
        <span class="grupo">
            <label for="tipoCompra" class="col-md-2 control-label text-info">
                Tipo Compra
            </label>
            <span class="col-md-2">
                <g:select name="tipoCompra" from="${janus.pac.TipoCompra.list([sort: 'descripcion'])}" optionKey="id" optionValue="descripcion" class="form-control" value="${pac?.tipoCompra?.id}" />
            </span>
            <label for="tipoProcedimiento" class="col-md-2 control-label text-info">
                Tipo Procedimiento
            </label>
            <span class="col-md-4">
                <g:select name="tipoProcedimiento" from="${janus.pac.TipoProcedimiento.list([sort: 'descripcion'])}" optionKey="id" optionValue="descripcion" class="form-control" value="${pac?.tipoProcedimiento?.id}" />
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: pac, field: 'cpp', 'error')} ">
        <span class="grupo">
            <g:hiddenField name="cpp" value="${pac?.cpp?.id}" />
            <label for="requiriente" class="col-md-2 control-label text-info">
                Código CP
            </label>
            <span class="col-md-3">
                <g:textField name="cppCodigo" readonly="" class="form-control required" required="" value="${pac?.cpp?.numero}"/>
            </span>
            <span class="col-md-5">
                <g:textField name="cppName" readonly="" class="form-control required" required="" value="${pac?.cpp?.descripcion}"/>
            </span>
            <span class="col-md-1">
                <a href="#" class="btn btn-info btnBuscarCPP" ><i class="fa fa-search"></i></a>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: pac, field: 'c1', 'error')} ">
        <span class="grupo">
            <label class="col-md-2 control-label text-info">
                Cuatrimestre 1
            </label>
            <span class="col-md-1">
                <g:select name="c1" from="${['': 'NO', 'S' : 'SI']}" optionKey="key" optionValue="value" class="form-control" value="${pac?.c1}" style="width: 50px" />
            </span>

            <label class="col-md-2 control-label text-info">
                Cuatrimestre 2
            </label>
            <span class="col-md-1">
                <g:select name="c2" from="${['': 'NO', 'S' : 'SI']}" optionKey="key" optionValue="value" class="form-control" value="${pac?.c2}" style="width: 50px" />
            </span>

            <label class="col-md-2 control-label text-info">
                Cuatrimestre 3
            </label>
            <span class="col-md-1">
                <g:select name="c3" from="${['': 'NO', 'S' : 'SI']}" optionKey="key" optionValue="value" class="form-control" value="${pac?.c3}" style="width: 50px" />
            </span>
        </span>
    </div>

</g:form>

<script type="text/javascript">

    var bpc, bcpc;

    $(".btnBuscarCPP").click(function () {
        $.ajax({
            type    : "POST",
            url: "${createLink(controller: 'mantenimientoItems', action:'buscadorCPC')}",
            data    : {
                tipo: 1
            },
            success : function (msg) {
                bcpc = bootbox.dialog({
                    id      : "dlgBuscarCPC",
                    title   : "Buscar Código Compras Públicas",
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
    });

    function cerrarBuscadorCPC(){
        bcpc.modal("hide")
    }


    $(".btnPartida").click(function () {
        var anio = $("#anio").val();
        $.ajax({
            type    : "POST",
            url: "${createLink(controller: 'pac', action:'buscadorPartida_ajax')}",
            data    : {
                anio: anio
            },
            success : function (msg) {
                bpc = bootbox.dialog({
                    id      : "dlgBuscarPR",
                    title   : "Buscar Partida",
                    class: 'modal-lg',
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
    });

    function cerrarBuscarPartida(){
        bpc.modal("hide");
    }

    function validarNum(ev) {
        /*
         48-57      -> numeros
         96-105     -> teclado numerico
         188        -> , (coma)
         190        -> . (punto) teclado
         110        -> . (punto) teclado numerico
         8          -> backspace
         46         -> delete
         9          -> tab
         37         -> flecha izq
         39         -> flecha der
         */
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
            (ev.keyCode >= 96 && ev.keyCode <= 105) ||
            ev.keyCode === 190 || ev.keyCode === 110 ||
            ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
            ev.keyCode === 37 || ev.keyCode === 39);
    }

    $("#costo, #cantidad").keydown(function (ev) {
        return validarNum(ev);
    });

    cargarTecho();

    function cargarTecho() {
        $.ajax({
            type : "POST",
            url : "${g.createLink(controller: 'pac',action:'cargarTechoNuevoPac')}",
            data:{
                id: $("#presupuesto").val(),
                anio: $("#anio option:selected").val(),
                pac_id: $("#id").val()
            },
            success  : function (msg) {
                var parts = msg.split(";");
                $("#techo").val(number_format(parts[0], 2, ".", ""));
                $("#usado").val(number_format(parts[1], 2, ".", ""));
                var dis = parts[0] - parts[1];
                if ($("#id").val() * 1 > 1) {
                    var act = $("#item_cantidad").val() * $("#item_precio").val();
                    if (isNaN(act) || act === "")
                        act = 0;
                    dis += act
                }
                $("#disponible").val(number_format(dis, 2, ".", ""))
            }
        });
    }


    $("#frmPac").validate({
        errorClass     : "help-block",
        errorPlacement : function (error, element) {
            if (element.parent().hasClass("input-group")) {
                error.insertAfter(element.parent());
            } else {
                error.insertAfter(element);
            }
            element.parents(".grupo").addClass('has-error');
        },
        success        : function (label) {
            label.parents(".grupo").removeClass('has-error');
        }
    });

</script>