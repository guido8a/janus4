package seguridad

class WardInterceptor {

    WardInterceptor () {
//        matchAll().excludes(controller: 'login')
        matchAll().excludes(controller:'login')
                .excludes(controller:'shield')
                .excludes(controller:'provincia')  /** mapa **/
                .excludes(controller:'documento')  /** documentos **/
                .excludes(controller:'descargas')  /** documentos **/
                .excludes(controller:'prfl')
    }

    boolean before() {
//        println "acción: " + actionName + " controlador: " + controllerName + " params: $params"
//        println "shield sesión: " + session
//        println "usuario: " + session.usuario
        def usro
        if(session) {
            usro = session.usuario
            session.an = actionName
            session.cn = controllerName
            session.pr = params
        }

        if(session.an == 'saveTramite' && session.cn == 'tramite'){
//            println("entro")
            return true
        } else {
            if (!session?.usuario && !session?.perfil) {
//                println "...sin sesión"
                if(controllerName != "inicio" && actionName != "index") {
//                    flash.message = "Usted ha superado el tiempo de inactividad máximo de la sesión"
                }
                render "<script type='text/javascript'> window.location.href = '/' </script>"
                session.finalize()
                return false
            }

            if (isAllowed()) {
                return true
            } else {
                println "******Dar permisos a prfl: ${session?.perfil?.codigo} en acción: $actionName controlador: $controllerName"
                return true   /** quitar para manejar permisos **/
            }
        }

        //true
    }

    boolean after() {
//        println "+++++después"
        true
    }

    void afterView() {
//        println "+++++afterview"
        // no-op
    }


    boolean isAllowed() {
//        println "**--> ${session.permisos[controllerName.toLowerCase()]} --> ${actionName}"
//        println "**--> ${session.permisos}"

        try {
            if((request.method == "POST") || (actionName.toLowerCase() =~ 'ajax')) {
//                println "es post no audit"
                return true
            }
//            println "is allowed Accion: ${actionName.toLowerCase()} ---  Controlador: ${controllerName.toLowerCase()} " +
//                    "--- Permisos de ese controlador: "+session.permisos[controllerName.toLowerCase()]
            def puede = session.permisos[controllerName.toLowerCase()]  != null
//            println "puede ${puede}"
//            if (!( session.permisos[controllerName.toLowerCase()]) ) {
            if (!puede) {
                return false
            } else {
                if (session.permisos[controllerName.toLowerCase()].contains(actionName.toLowerCase())) {
                    return true
                } else {
                    return false
                }
            }

        } catch (e) {
            println "Shield execption e: " + e
            return false
        }

//        return true

    }

}
