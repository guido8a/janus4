%{--<%@ page contentType="text/html;charset=UTF-8" %>--}%
%{--<html>--}%
%{--<head>--}%
%{--    <meta name="layout" content="mainMatriz">--}%
%{--    <title>Histórico de cronograma de ejecución</title>--}%

%{--    <style type="text/css">--}%
%{--    .cmplcss {--}%
%{--        color: #0c4c85;--}%
%{--    }--}%

%{--    .center {--}%
%{--        text-align: center;--}%
%{--    }--}%

%{--    .pagination {--}%
%{--        display: inline-block;--}%
%{--    }--}%

%{--    .pagination a {--}%
%{--        color: white;--}%
%{--        float: left;--}%
%{--        padding: 5px 8px;--}%
%{--        text-decoration: none;--}%
%{--        transition: background-color .3s;--}%
%{--        border: 1px solid #ddd;--}%
%{--        margin: 0 4px;--}%
%{--    }--}%

%{--    .pagination a.active {--}%
%{--        background-color: #72af97;--}%
%{--        color: black;--}%
%{--        border: 1px solid #72af97;--}%
%{--    }--}%
%{--    .pagination a:hover:not(.active) {background-color: #ddd;}--}%

%{--    </style>--}%
%{--</head>--}%

%{--<body>--}%

<div class="row" style="margin-top: -20px">
    <div class="col-md-12 pagination">
        <g:each in="${paginas}" var="pg">
            <a href="#" class="btn btn-info btnPg" id="btn_${pg}" data-valor="${pg}">
                <i class="fa fa-file"></i> ${pg}
            </a>
        </g:each>
        <div class="btn" style="position: absolute; top: -115px; right: 2%">Páginas de 10 rubros: Página actual: <strong id="divActual"></strong> </div>
    </div>
</div>

<div id="divTablaHistorico" style="height: 600px; overflow: auto; width: 100%">

</div>

<script type="text/javascript">

    $(".btnPg").click(function () {
        var pag = $(this).data("valor");
        $(".btnPg").removeClass("active");
        $("#btn_" + pag).addClass("active");
        $("#divActual").html(pag);
        cargarTablaHistorico(pag);
    });

    primeroActive();

    function primeroActive(){
        $("#btn_" + 1).addClass("active");
        $("#divActual").html("1")
    }

    cargarTablaHistorico();

    function cargarTablaHistorico(pag) {
        var g = cargarLoader("Cargando...");
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'cronogramaEjecucion', action: 'tablaHistoricos_ajax')}",
            data: {
                id: ${contrato.id},
                pag: pag,
                modificacion: '${modificacion.id}'
            },
            success: function (msg) {
                g.modal("hide");
                $("#divTablaHistorico").html(msg);
            }
        });
    }

</script>
%{--</body>--}%
%{--</html>--}%