package janus

import janus.pac.Anio
import janus.pac.Concurso

class PresupuestoController {

    def dbConnectionService

    def list(){
        def anio = new Date().format("yyyy")
        def actual = Anio.findByAnio(anio.toString())
        if(!actual){
            actual=Anio.list([sort: "id"])?.pop()
        }
        return [actual: actual]
    }

    def form_ajax(){

        def anio = new Date().format("yyyy")
        def actual = Anio.findByAnio(anio.toString())
        if(!actual){
            actual=Anio.list([sort: "id"])?.pop()
        }

        def presupuesto

        if(params.id){
            presupuesto = Presupuesto.get(params.id)
        }else{
            presupuesto = new Presupuesto()
        }

        return [presupuestoInstance: presupuesto, actual: actual]
    }


    def tablaPresupuesto_ajax(){

//        println("tabla pre " + params)

        def anio = Anio.get(params.anio)
        def datos;
        def sqlTx = ""
        def listaItems = ['prspnmro', 'prspdscr']
        def bsca = listaItems[params.buscarPor.toInteger()-1]

        def select = "select * from prsp"
        def txwh = " where $bsca ilike '%${params.criterio}%' and anio__id = ${anio?.id}"
        sqlTx = "${select} ${txwh} order by prspproy limit 30 ".toString()
        println "sql: $sqlTx"

        def cn = dbConnectionService.getConnection()
        datos = cn.rows(sqlTx)

//        println("data " + datos)
        return[presupuestos: datos, anio: anio]

    }

    def savePartida_ajax(){

        def presupuesto
        def existe = Presupuesto.findByNumero(params.numero)

        if(params.id){
            presupuesto = Presupuesto.get(params.id)

            if(existe){
                if(existe.id != presupuesto?.id){
                    render "err_Ya existe una partida con ese código"
                    return
                }
            }

        }else{
            presupuesto = new Presupuesto()

            if(existe){
                render "err_Ya existe una partida con ese código"
                return
            }

        }

        presupuesto.properties = params

        if(!presupuesto.save(flush:true)){
            println("Error al guardar la partida " + presupuesto.errors)
            render "no_Error al guardar la partida"
        }else{
            render "ok_Guardado correctamente"
        }
    }

    def borrarPartida_ajax(){

        def presupuesto = Presupuesto.get(params.id)

        if(presupuesto){

            try{
                presupuesto.delete(flush:true)
                render "ok_Borrado correctamente"
            }catch(e){
                println("Error al borrar la partida " + presupuesto.errors)
                render "no_Error al borrar la partida"
            }

        }else{
            render "err_No existe la partida"
        }
    }

    def partida(){
        def anio = new Date().format("yyyy")
        def actual = Anio.findByAnio(anio.toString())
        if(!actual){
            actual=Anio.list([sort: "id"])?.pop()
        }

        def concurso = null

        if(params.id){
            concurso = Concurso.get(params.id)
        }

        return [actual: actual, concurso: concurso]
    }

    def listaPartidas_ajax(){
        def anio = Anio.get(params.anio)
        def partidas = Presupuesto.findAllByAnio(anio)
        def concurso = null

        if(params.id){
            concurso = Concurso.get(params.id)
        }

        return [partidas:partidas, concurso: concurso]
    }

    def partida2(){
        def concurso = null

        if(params.id){
            concurso = Concurso.get(params.id)
        }

        return [concurso: concurso]
    }

    def buscadorPartida_ajax(){
        def anio = new Date().format("yyyy")
        def actual = Anio.findByAnio(anio.toString())
        if(!actual){
            actual=Anio.list([sort: "id"])?.pop()
        }

        return [anio: anio, actual: actual]
    }

    def tablaBuscarPartida_ajax(){

        def anio = Anio.get(params.anio)
        def datos;
        def sqlTx = ""
        def listaItems = ['prspnmro', 'prspdscr']
        def bsca = listaItems[params.buscarPor.toInteger()-1]

        def select = "select * from prsp"
        def txwh = " where $bsca ilike '%${params.criterio}%' and anio__id = ${anio?.id}"
        sqlTx = "${select} ${txwh} order by prspproy limit 30 ".toString()
        println "sql: $sqlTx"

        def cn = dbConnectionService.getConnection()
        datos = cn.rows(sqlTx)

        return[presupuestos: datos, anio: anio]
    }

} //fin controller
