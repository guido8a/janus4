<style type="text/css">
table {
    table-layout: fixed;
    overflow-x: scroll;
}
th, td {
    overflow: hidden;
    text-overflow: ellipsis;
    word-wrap: break-word;
}
</style>

<div style="margin-top: 15px;">
    <table class="table table-bordered table-hover table-condensed" style="width: 100%; background-color: #a39e9e">
        <thead>
        <tr>
            <th style="width: 15%">
                Fecha
            </th>
            <th style="width: 20%;">
                Campo
            </th>
            <th style="width: 30%">
                Valor anterior
            </th>
            <th style="width: 35%">
                Valor actual
            </th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%; max-height: 240px; overflow-y: auto;float: right; margin-top: -20px; margin-bottom: 20px">
    <table class="table-bordered table-condensed table-striped table-hover" style="width: 100%">
        <g:each in="${res}" var="dato" >
            <tr style="width: 100%">
                <td style="width: 15%">${dato.audtfcha.format("dd-MM-yyyy HH:mm")}</td>
                <td style="width: 20%; font-size: 12px">${dato.audtcmpo}</td>
                <td style="width: 30%; font-size: 12px">${dato.audtantr}</td>
                <td style="width: 35%">${dato.audtactl}</td>
            </tr>
        </g:each>
    </table>
</div>