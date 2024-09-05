<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 01/09/21
  Time: 16:06
--%>

<table class="table table-bordered table-striped table-hover table-condensed" id="tabla">

    <thead>
    <tr>
        <th style="width: 13%">Código</th>
        <th style="width: 60%">Descripción</th>
        <th style="width: 7%">Unidad</th>
        <th style="width: 9%">Precio</th>
        <th style="width: 11%">Seleccionar</th>
    </tr>
    </thead>

    <tbody>
    </tbody>

</table>

<div class="" style="width: 99.7%;height: 420px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover" style="width: 100%">
        <g:each in="${data}" var="dt" status="i">
            <tr>
                <td style="width: 13%">${dt.itemcdgo}</td>
                <td style="width: 60%">${dt.itemnmbr}</td>
                <td style="width: 7%">${dt.unddcdgo}</td>
                <td style="width: 9%">${dt.rbpcpcun}</td>
                <td style="width: 11%"><div style="text-align: center" class="selecciona" id="reg_${i}"
                                           regNmbr="${dt?.itemnmbr}" regCdgo="${dt?.itemcdgo}"
                                           regUn="${dt?.unddcdgo}" data-id="${dt?.item__id}" data-prc="${dt?.rbpcpcun}">
                    <button class="btn btn-xs btn-success"><i class="fa fa-check"></i></button>
                </div></td>
            </tr>
        </g:each>
    </table>
</div>


<script type="text/javascript">
    $(".selecciona").click(function () {
        // var id = $(this).attr("regId");
        $("#item_id").val($(this).data("id"));
        $("#item_codigo").val($(this).attr("regCdgo"));
        $("#item_nombre").val($(this).attr("regNmbr"));
        $("#item_unidad").val($(this).attr("regUn"));
        $("#item_precio").val($(this).data("prc"));
        $("#busqueda").dialog("close");
    });
</script>

