package janus

class NumeroController {

    def list(){
        def numeros = Numero.list([sort: 'descripcion'])
        return [numeros: numeros]
    }

    def form_ajax(){
        def numero

        if(params.id){
            numero = Numero.get(params.id)
        }else{
            numero = new Numero()
        }

        return [numero: numero]

    }

    def saveNumero_ajax(){

        def numero = Numero.get(params.id)
        numero.valor = params.valor.toInteger()

        if(!numero.save(flush:true)){
            println("error al guardar el número")
            render "no_Error al guardar el número"
        }else{
            render "ok_Guardado correctamente"
        }

    }

}
