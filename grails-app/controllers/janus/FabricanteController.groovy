package janus

class FabricanteController {

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
        def fabricantes = Fabricante.list([sort: 'nombre'])
        return [fabricantes: fabricantes]
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


}
