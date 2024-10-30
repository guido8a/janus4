package janus

import janus.pac.Anio

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

        println("tabla pre " + params)

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

} //fin controller
