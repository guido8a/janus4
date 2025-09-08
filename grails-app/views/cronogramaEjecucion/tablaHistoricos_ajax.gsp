<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>

    <title></title>

    <style type="text/css">
    .valor {
        color: #093760;
    }
    .valor2 {
        color: #093760;
        text-align: right;
        font-weight: bold;
    }
    .suspension {
        background-color: #ffffff !important;
        /*color: #444 !important;*/
        color: #ffcc3b !important;
        font-weight: normal !important;
    }
    .numero {
        width: 80px;
        text-align: right;
    }
    .totales {
        width: 80px;
        text-align: right;
        font-weight: bold;
    }
    .pie {
        background-color: #ddd;
    }
    .pie2 {
        background-color: #f0f0f0;
    }

    </style>


</head>

<table class="table table-bordered table-condensed table-hover table-striped" width="1360px">
    <thead>
    <tr style="width: 100%;">
        <th rowspan="2" style="width:70px; background-color: #856c4d !important;">Código</th>
        <th rowspan="2" style="width:150px; background-color: #856c4d !important;">Rubro</th>
        <th rowspan="2" style="width:26px; background-color: #856c4d !important;">*</th>
        <th rowspan="2" style="width:60px; background-color: #856c4d !important;">Cantidad Unitario Total</th>
        <th rowspan="2" style="width:12px; background-color: #856c4d !important;">T.</th>
        <g:each in="${titulo1}" var="t">
            <th style="background-color: #856c4d !important;" class="${t[1] == 'S' ? 'suspension' : 'numero'}">${t[0]}</th>
        </g:each>
        <th style="background-color: #856c4d !important;" rowspan="2">Total rubro</th>
    </tr>
    <tr>
        <g:each in="${titulo2}" var="t">
            <th  style="background-color: #856c4d !important;" class="${t[1] == 'S' ? 'suspension' : 'numero'}">${raw(t[0])}</th>
        </g:each>
    </tr>
    </thead>

    <tbody>
    <g:each in="${rubros}" var="rubro">
        <tr class="click item_row   rowSelected" data-vol="${rubro[1]}" data-vocr="${rubro[0]}">
            <g:each in="${rubro}" var="val" status="i">
                <g:if test="${i > 0}">
                    <g:if test="${i == 3}">
                        <td class="valor2">${raw(val)}</td>
                    </g:if>
                    <g:else>
                        <g:if test="${i<5}">
                            <td class="valor">${raw(val)}</td>
                        </g:if>
                        <g:else>
                            <td class="numero">${raw(val)}</td>
                        </g:else>
                    </g:else>
                </g:if>
            </g:each>
        </tr>
    </g:each>

    <tr class="pie">
        <td class="valor" colspan="3" style="text-align: right; font-weight: bold">TOTAL PARCIAL</td>
        <td class="valor" colspan="2" style="text-align: right; font-weight: bold">${suma}</td>
        <g:each in="${totales}" var="tot" status="i">
            <td class="totales">${raw(tot)}</td>
        </g:each>
    </tr>
    <tr class="pie2">
        <td class="valor" colspan="3" style="text-align: right; font-weight: bold">TOTAL ACUMULADO</td>
        <td colspan="2"></td>
        <g:each in="${total_ac}" var="tot" status="i">
            <td class="totales">${raw(tot)}</td>
        </g:each>
    </tr>
    <tr class="pie">
        <td class="valor" colspan="3" style="text-align: right; font-weight: bold">% TOTAL PARCIAL</td>
        <td colspan="2"></td>
        <g:each in="${ttpc}" var="tot" status="i">
            <td class="totales">${raw(tot)}</td>
        </g:each>
    </tr>
    <tr class="pie2">
        <td class="valor" colspan="3" style="text-align: right; font-weight: bold">% TOTAL ACUMULADO</td>
        <td colspan="2"></td>
        <g:each in="${ttpa}" var="tot" status="i">
            <td class="totales">${raw(tot)}</td>
        </g:each>
    </tr>

    </tbody>
</table>
</html>

