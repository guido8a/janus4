<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="login">

    <title>Login</title>

    <style type="text/css">
    .archivo {
        width: 100%;
        float: left;
        margin-top: 60px;
        text-align: center;
    }

    .titl {
        font-family: 'open sans condensed';
        font-weight: bold;
        text-shadow: -2px 2px 1px rgba(0, 0, 0, 0.25);
    <g:if test="${janus.Parametros.findByEmpresaLike('SEP-C-GADPP')}">
        color: #1a7031;
    </g:if>
    }

    </style>
</head>

<body>

<div style="text-align: center; margin-top: 22px; height: ${(flash.message) ? '680' : '700'}px; background-color: #d8d8df" class="well">

    <elm:flashMessage tipo="${flash.tipo}" icon="${flash.icon}"
                      clase="${flash.clase}">${flash.message}</elm:flashMessage>

    <div class="centrado"><h1 class="titl" style="font-size: 32px;">${empr.empresa}</h1>
        <h1 class="titl" style="font-size: 24px;">${raw(empr.nombre)}</h1>
        <h1 class="titl" style="font-size: 24px; color: #904040">Sistema Mejorado - Producción</h1>

        <div class="dialog ui-corner-all logo">
            <div>
                %{--            <img src="${resource(dir: 'images/bitacora', file: 'bitacora.png')}" style="padding: 40px;"/>--}%
                <asset:image src="apli/portada.png" style="margin-top: 40px;"/>
            </div>
            <div style="width: 100%;height: 40px;float: left; margin-bottom:30px; text-align: center">
                <a href="#" id="ingresar" class="btn btn-primary" style="width: 120px; margin: auto">
                    <i class="icon-off"></i>Ingresar</a>
            </div>

            <div style="text-align: center ; color:#004060; margin-top:90px; ">
                Desarrollado por: TEDEIN S.A. Versión ${message(code: 'version', default: '1.1.0x')}</div>

        </div>
    </div>

</div>


<div class="modal fade" id="modal-ingreso" tabindex="-1" role="dialog" aria-labelledby=""
     aria-hidden="true">
    <div class="modal-dialog" id="modalBody" style="width: 480px;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Ingreso al Sistema</h4>
            </div>

            <p style="padding: 20px" class="${janus.Parametros.findByEmpresaLike('SEP-C-GADPP') ? 'text-success' : 'text-info'}">
                Favor ingrese al sistema con la misma contraseña que usa para ingresar al SAD-WEB</p>
            <div class="modal-body" style="width: 290px; margin: auto">
                <g:form name="frmLogin" action="validar" class="form-horizontal">
                    <div class="form-group">
                        <label class="col-md-5" for="login">Usuario</label>

                        <div class="controls col-md-5">
                            %{--<input type="text" id="login" placeholder="Usuario">--}%
                            <input name="login" id="login" type="text" class="form-control required"
                                   placeholder="Usuario" required autofocus style="width: 160px;">
                        </div>
                    </div>

                    <span style="color: #0b2c89">Favor use su contraseña del SAD-WEB</span>
                    <div class="form-group">
                        <label class="col-md-5" for="pass">Contraseña</label>

                        <div class="controls col-md-5">
                            %{--<input type="password" id="pass" placeholder="Usuario">--}%
                            <input name="pass" id="pass" type="password" class="form-control required"
                                   placeholder="Contraseña" required style="width: 160px;">
                        </div>
                    </div>

                    <div class="divBtn" style="width: 100%">
                        <a href="#" class="btn btn-primary btn-lg btn-block" id="btn-login"
                           style="width: 140px; margin: auto">
                            <i class="fa fa-lock"></i> Validar
                        </a>
                    </div>

                </g:form>
            </div>
        </div>
    </div>
</div>

<div id="cargando" class="text-center hidden">
    <img src="${resource(dir: 'images', file: 'spinner32.gif')}" alt='Cargando...' width="32px" height="32px"/>
</div>

<script type="text/javascript">
    var $frm = $("#frmLogin");
    var recargar = true

    function timedRefresh(timeoutPeriod) {
        if(recargar) {
            setTimeout("location.reload(true);",timeoutPeriod);
        }
        recargar = false
    }


    function doLogin() {
        if ($frm.valid()) {
            // $("#cargando").removeClass('hidden');
            cargarLoader("Cargando...");
            $(".btn-login").replaceWith($("#cargando"));
            $("#frmLogin").submit();
        }
    }

    function doPass() {
        if ($("#frmPass").valid()) {
            $("#btn-pass").replaceWith(spinner);
            $("#frmPass").submit();
        }
    }

    $(function () {

        $("#ingresar").click(function () {
            var initModalHeight = $('#modal-ingreso').outerHeight();
            //alto de la ventana de login: 270
            console.log("ventana")
            $("#modalBody").css({'margin-top': ($(document).height() / 2 - 135)}, {'margin-left': $(window).width() / 2});
            console.log("antes modeal")
            $("#modal-ingreso").modal('show');
            console.log("luego modeal")
            setTimeout(function () {
                $("#login").focus();
            }, 500);

        });

        $("#btnOlvidoPass").click(function () {
            $("#recuperarPass-dialog").modal("show");
            $("#modal-ingreso").modal("hide");
        });

        // $frm.validate();
        $("#btn-login").click(function () {
            doLogin();
        });

        $("#btn-pass").click(function () {
            doPass();
        });

        $("input").keyup(function (ev) {
            if (ev.keyCode == 13) {
                doLogin();
            }
        })

        // window.onload = timedRefresh(5000);

    });

</script>

</body>
</html>