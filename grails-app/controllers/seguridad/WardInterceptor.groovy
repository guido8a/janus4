package seguridad

class WardInterceptor {
    def dbConnectionService

    WardInterceptor () {
//        matchAll().excludes(controller: 'login')
        matchAll().excludes(controller:'login')
                .excludes(controller:'shield')
                .excludes(controller:'provincia')  /** mapa **/
                .excludes(controller:'documento')  /** documentos **/
                .excludes(controller:'descargas')  /** documentos **/
                .excludes(controller:'prfl')
                .excludes(controller:'images')
    }

    boolean before() {
        println "acción: " + actionName + " controlador: " + controllerName + " params: $params"
        def usro
        if(session) {
            usro = session.usuario
            session.an = actionName
            session.cn = controllerName
            session.pr = params
        }

        if(session.an == 'saveTramite' && session.cn == 'tramite'){
            return true
        } else {
            if (!session?.usuario || !session?.perfil) {
                println "...sin sesión"
                if(controllerName != "inicio" && actionName != "index") {
                }
                render "<script type='text/javascript'> window.location.href = '/' </script>"
                session.finalize()
                return false
            }

            if (isAllowed() || controllerName == 'js') {
                return true
            } else {
                println "******Dar permisos a prfl: ${session?.perfil?.codigo} en acción: $actionName controlador: $controllerName"

                if(controllerName && (controllerName?.toLowerCase() != 'js') ) {
                    def cn = dbConnectionService.getConnection()
                    def sql = ""
                    sql = "select ctrl__id from ctrl where ctrlnmbr ilike '${controllerName.toLowerCase()}'"
                    def ctrl = cn.rows(sql.toString())[0].ctrl__id
                    sql = "select accn__id from accn where ctrl__id = ${ctrl} and accnnmbr ilike '${actionName.toLowerCase()}'"
                    def accn = cn.rows(sql.toString())[0].accn__id
                    sql = "insert into prms(prms__id, accn__id, prfl__id) " +
                            "values ( default, $accn, ${session?.perfil?.id} )"
//                    println ">>> permiso faltante, consedido a: $sql"
                    cn.execute(sql.toString())
                    println ">>>nuevo permiso añadido ($accn, ${session?.perfil?.id}) <<<<"
                    return true   /** quitar para manejar permisos **/

                } else {
                    return true   /** quitar para manejar permisos **/
                }
            }
        }
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
        println "**--> ${controllerName?.toLowerCase()} --> ${actionName}"

        try {
            if((request.method == "POST") || (actionName.toLowerCase() =~ 'ajax') )  {
                return true
            }
            def cn = dbConnectionService.getConnection()
//            Con SQL
            def sql = ""
            def puede = false
            if(session?.perfil) {
                sql = "select count(*) cnta from prms, ctrl, accn " +
                        "where prfl__id = ${session?.perfil?.id} and accn.accn__id = prms.accn__id and " +
                        "ctrl.ctrl__id = accn.ctrl__id and accnnmbr not ilike '%ajax%' and " +
                        "ctrlnmbr ilike '${controllerName.toLowerCase()}' and " +
                        "accnnmbr ilike '${actionName.toLowerCase()}'"
                puede = cn.rows(sql.toString())[0].cnta > 0
                println "sql--: $sql --> puede: $puede"
                println "sql--: $sql --> puede: $puede"
            }
            return puede

//            def puede = session.permisos[controllerName.toLowerCase()]  != null
//            if (!puede) {
//                return false
//            } else {
//                if (session.permisos[controllerName.toLowerCase()].contains(actionName.toLowerCase())) {
//                    return true
//                } else {
//                    return false
//                }
//            }

        } catch (e) {
            println "Shield execption e: " + e
            return false
        }

//        return true

    }

}
