package janus


class TipoConcursoController {

    def list(){
        def tipoConcurso = TipoConcurso.list().sort{it.codigo}
        return  [tipoConcursoList: tipoConcurso]
    }

    def form_ajax(){

        def tipoConcurso

        if(params.id){
            tipoConcurso = TipoConcurso.get(params.id)
        }else{
            tipoConcurso = new TipoConcurso()
        }

        return  [tipoConcurso: tipoConcurso]
    }

    def saveTipoConcurso_ajax(){

        def tipoConcurso

        if(params.id){
            tipoConcurso = TipoConcurso.get(params.id)
        }else{
            tipoConcurso = new TipoConcurso()
        }

        params.codigo = params.codigo.toUpperCase();
        tipoConcurso.properties = params

        if(!tipoConcurso.save(flush:true)){
            println("Error al guardar el tipo de concurso " + tipoConcurso.errors)
            render "no_Error al guardar el tipo de concurso"
        }else{
            render "ok_Guardado correctamente"
        }

    }

    def deleteTipoConcurso_ajax(){
        def tipoConcurso = TipoConcurso.get(params.id)

        try{
            tipoConcurso.delete(flush:true)
            render "ok_Borrado correctamente"
        }catch(e){
            render "no_Error al borrar el tipo de concurso"
        }
    }

}
