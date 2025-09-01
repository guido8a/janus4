
<label class="col-md-2 control-label text-info formato">
    Fecha de Aprobación
</label>
<span class="col-md-3">
    <input aria-label="" name="fechaIngreso" id='fechaIngreso' type='text' class="form-control required" value="${planilla?.fechaIngreso?.format("dd-MM-yyyy")}" />
</span>

<script type="text/javascript">

    var minDate;

    <g:if test="${fecha}">

    minDate = new Date('${fecha}');

    %{--$('#fechaIngreso').datetimepicker({--}%
    %{--    locale: 'es',--}%
    %{--    format: 'DD-MM-YYYY',--}%
    %{--    minDate: new Date('${fecha}'),--}%
    %{--    maxDate: new Date(${fechaMax.format('yyyy')},${fechaMax.format('MM').toInteger() - 1},${fechaMax.format('dd')},0,0,0,0),--}%
    %{--    sideBySide: true,--}%
    %{--    icons: {--}%
    %{--    }--}%
    %{--}).on('dp.change', function(e){--}%
    %{--    var minDate = new Date(e.date);--}%
    %{--    $('#fechaPresentacion').data("DateTimePicker").date(moment(minDate).format('DD/MM/YYYY'));--}%
    %{--});--}%
    </g:if>
    <g:else>

    minDate = new Date(${contrato.fechaSubscripcion.format('yyyy')},${contrato.fechaSubscripcion.format('MM').toInteger() - 1},${contrato.fechaSubscripcion.format('dd')},0,0,0,0)

        %{--$('#fechaIngreso').datetimepicker({--}%
        %{--        locale: 'es',--}%
        %{--        format: 'DD-MM-YYYY',--}%
        %{--        minDate: new Date(${contrato.fechaSubscripcion.format('yyyy')},${contrato.fechaSubscripcion.format('MM').toInteger() - 1},${contrato.fechaSubscripcion.format('dd')},0,0,0,0),--}%
        %{--        maxDate: new Date(${fechaMax.format('yyyy')},${fechaMax.format('MM').toInteger() - 1},${fechaMax.format('dd')},0,0,0,0),--}%
        %{--        sideBySide: true,--}%
        %{--        icons: {--}%
        %{--        }--}%
        %{--    }).on('dp.change', function(e){--}%
        %{--        var minDate = new Date(e.date);--}%
        %{--        $('#fechaPresentacion').data("DateTimePicker").date(moment(minDate).format('DD/MM/YYYY'));--}%
        %{--    });--}%
        </g:else>


        $('#fechaIngreso').datetimepicker({
            locale: 'es',
            format: 'DD-MM-YYYY',
            minDate: minDate,
            maxDate: new Date(${fechaMax.format('yyyy')},${fechaMax.format('MM').toInteger() - 1},${fechaMax.format('dd')},0,0,0,0),
            sideBySide: true,
            icons: {
            }
        }).on('dp.change', function(e){
            var minDate = new Date(e.date);
            $('#fechaPresentacion').data("DateTimePicker").date(moment(minDate).format('DD/MM/YYYY'));
        });


</script>