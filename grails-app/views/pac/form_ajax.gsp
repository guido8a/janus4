<g:form class="form-horizontal" name="frmPac" role="form" controller="pac" action="savePac_ajax" method="POST">
    <g:hiddenField name="id" value="${pac?.id}" />

    <div class="form-group ${hasErrors(bean: pac, field: 'anio', 'error')} required">
        <span class="grupo">
            <label for="anio" class="col-md-2 control-label text-info">
                Año
            </label>
            <span class="col-md-3">
                <g:select class="form-control" name="anio" from="${janus.pac.Anio.list(sort: 'anio')}" value="${pac?.anio?.id ?: actual?.id}" optionKey="id" optionValue="anio"/>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: pac, field: 'presupuesto', 'error')} required">
        <span class="grupo">
            <label for="presupuestoName" class="col-md-2 control-label text-info">
                Partida
            </label>
            <span class="col-md-8">
                <g:hiddenField name="presupuesto" value="${pac?.presupuesto?.id}" required="" />
                <g:textArea name="presupuestoName" required="" readonly="" class="form-control required" value="${pac?.presupuesto?.descripcion}" style="height: 100px; resize: none"/>
            </span>

            <span class="col-md-1">
                <a href="#" class="btn btn-info btnPartida" ><i class="fa fa-search"></i></a>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: pac, field: 'codigo', 'error')}">
        <span class="grupo">
            <label for="presupuestoCodigo" class="col-md-2 control-label text-info">
                Código
            </label>
            <span class="col-md-8">
                <g:textField name="presupuestoCodigo" readonly="" class="form-control" value="${pac?.presupuesto?.numero}"/>
            </span>
        </span>
    </div>

%{--    <div class="form-group ${hasErrors(bean: asignacion, field: 'valor', 'error')} required">--}%
%{--        <span class="grupo">--}%
%{--            <label for="valor" class="col-md-2 control-label text-info">--}%
%{--                Valor--}%
%{--            </label>--}%
%{--            <span class="col-md-4">--}%
%{--                <g:textField name="valor" class="form-control required" value="${g.formatNumber(number: asignacion?.valor, maxFractionDigits: 2, minFractionDigits: 2,--}%
%{--                        locale: 'ec')}" />--}%
%{--            </span>--}%
%{--        </span>--}%
%{--    </div>--}%

</g:form>

<script type="text/javascript">

    var bpc;

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

    $("#valor").keydown(function (ev) {
        return validarNum(ev);
    });

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