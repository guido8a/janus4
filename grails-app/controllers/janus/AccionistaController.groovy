package janus

import janus.pac.Proveedor

class AccionistaController {

    def list(){
        def proveedor = Proveedor.get(params.id)
        return [proveedor: proveedor]
    }

    def form_ajax(){
        def proveedor = Proveedor.get(params.proveedor)
        def accionista
        def consorcio

        if(params.id){
            consorcio = Consorcio.get(params.id)
            accionista = consorcio.accionista
        }else{
            accionista = new Accionista()
            consorcio = new Consorcio()
        }

        return [accionista: accionista, consorcio: consorcio, proveedor: proveedor]
    }


    def tablaAccionistas_ajax(){
        def proveedor = Proveedor.get(params.proveedor)
        def accionistas = Consorcio.findAllByProveedor(proveedor)

        return [accionistas: accionistas]
    }

    def save_ajax(){

//        println("params " + params)

        def proveedor = Proveedor.get(params.proveedor)
        def accionista
        def consorcio


        if(params.porcentaje != '0'){
            if(params.id){

                consorcio = Consorcio.get(params.id)
                accionista = consorcio.accionista

                accionista.properties = params

                if(!accionista.save(flush:true)){
                    println("error al crear el accionista " + accionista.errors)
                    render "no_Error al guardar el accionista"
                }else {

                    consorcio.porcentaje = params.porcentaje.toDouble()

                    if(!consorcio.save(flush:true)){
                        println("error al crear el consorcio " + consorcio.errors)
                        render "no_Error al guardar el accionista"
                    }else{
                        render "ok_Accionista guardado correctamente"
                    }
                }

            }else{

                accionista = new Accionista()
                accionista.properties = params

                if(!accionista.save(flush:true)){
                    println("error al crear el accionista " + accionista.errors)
                    render "no_Error al guardar el accionista"
                }else{

                    consorcio = new Consorcio()
                    consorcio.proveedor = proveedor
                    consorcio.accionista = accionista
                    consorcio.porcentaje = params.porcentaje.toDouble()

                    if(!consorcio.save(flush:true)){
                        accionista.delete(flush:true)
                        println("error al crear el consorcio " + consorcio.errors)
                        render "no_Error al guardar el accionista"
                    }else{
                        render "ok_Accionista guardado correctamente"
                    }
                }
            }
        }else{
            render "no_Ingrese un porcentaje diferente de 0"
        }


    }


    def delete_ajax(){

        def consorcio = Consorcio.get(params.id)
        def accionista = Accionista.get(consorcio?.accionista?.id)


        try{
            consorcio.delete(flush:true)

            try{
                accionista.delete(flush:true)
                render "ok_Borrado correctamente"
            }catch(f){
                println("error " + accionista.errors)
                render"no_Error al borrar"
            }

        }catch(e){
            println("error " + consorcio.errors)
            render"no_Error al borrar"
        }

    }

}
