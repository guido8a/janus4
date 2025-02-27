<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-striped table-hover" style="width: 100%">
        <g:each in="${obras}" var="fila" status="j">
            <tr style="width: 100%">
                <td style="width: 8%">${fila.obracdgo}</td>
                <td style="width: 16%; font-size: 10px">${fila.obranmbr}</td>
                <td style="width: 12%; font-size: 10px">${fila.cntnnmbr} - ${fila.parrnmbr} - ${fila.cmndnmbr}</td>
                <td style="width: 8%">${fila.cntrcdgo}</td>
                <td style="width: 10%">${fila.prvenmbr}</td>
                <td style="width: 7%"><g:formatNumber number="${fila.cntrmnto}" maxFractionDigits="2" minFractionDigits="2" format="##,##0.##" locale="ec"/></td>
                <td style="width: 7%"><g:formatDate date="${fila.cntrfcsb}" format="dd-MM-yyyy"/></td>
                <td style="width: 7%"><g:formatDate date="${fila.obrafcin}" format="dd-MM-yyyy"/></td>
                <td style="width: 7%"><g:formatDate date="${fila.mdcefcin}" format="dd-MM-yyyy"/></td>
                <td style="width: 6%"><g:formatNumber number="${fila.cntrplzo}" maxFractionDigits="0" minFractionDigits="0"/> días</td>
                <td style="width: 7%"><g:formatNumber number="${(fila.av_economico) * 100}" maxFractionDigits="2" minFractionDigits="2"/>%</td>
                <td style="width: 5%"><g:formatNumber number="${fila.av_fisico}" maxFractionDigits="2" minFractionDigits="2"/></td>
            </tr>
        </g:each>
    </table>
</div>