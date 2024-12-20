package janus

class FabricanteController {

    def dbConnectionService

    def list(){
        def tipo = params.tipo
        return [tipo: tipo]
    }

    def form_ajax(){

        def fabricante

        if(params.id){
            fabricante = Fabricante.get(params.id)
        }else{
            fabricante = new Fabricante()
        }

        return [fabricante: fabricante]
    }

    def tablaFabricantes_ajax(){
        def datos;
        def sqlTx = ""
        def listaItems = ['fabrnmbr', 'fabr_ruc']
        def bsca
        if(params.buscarPor){
            bsca = listaItems[params.buscarPor?.toInteger()-1]
        }else{
            bsca = listaItems[0]
        }

        def select = "select * from fabr "
        def txwh = " where fabr__id is not null and $bsca ilike '%${params.criterio}%'"
        sqlTx = "${select} ${txwh} order by fabrnmbr limit 30 ".toString()
        println "sql: $sqlTx"
        def cn = dbConnectionService.getConnection()
        datos = cn.rows(sqlTx)
        cn.close()
        return [data: datos]
    }

    def save_ajax(){

        def fabricante

        if(params.id){
            fabricante = Fabricante.get(params.id)
        }else{
            fabricante = new Fabricante()
            fabricante.fecha = new Date()
        }

        fabricante.properties = params

        if(!fabricante.save(flush: true)){
            println("Error al guardar el fabricante " + fabricante.errors)
            render "no_Error al guardar el fabricante"
        }else{
            render "ok_Guardado correctamente"
        }
    }

    def delete_ajax(){

        def fabricante = Fabricante.get(params.id)

        if(fabricante){
            try{
                fabricante.delete(flush:true)
                render "ok_Borrado correctamente"
            }catch(e){
                println("Error al borrar el fabricante " + fabricante.errors)
                render "no_Error al borrar el fabricante"
            }
        }else{
            render "Error al borrar el fabricante "
        }
    }

    def show_ajax(){
        def fabricante = Fabricante.get(params.id)
        return [fabricante: fabricante]
    }

}
