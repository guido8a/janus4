package janus

import seguridad.Persona

class RegistroApuController {

    def dbConnectionService

    def tablaRegistro_ajax(){

        def oferente = session.usuario
        def registroApu

        if(params.id){
            registroApu = RegistroApu.get(params.id)
        }else{
            registroApu = new RegistroApu()
        }

        def cn = dbConnectionService.getConnection()
        def obras = [:]
        def sql = "select distinct obra.obra__id id, obracdgo||' - '||obranmbr nombre " +
                "from obra, obof " +
                "where obof.obra__id = obra.obra__id and obof.prsn__id = ${oferente.id} " +
                "order by 1"
        cn.eachRow(sql.toString()) { r ->
            obras[r.id] = r.nombre
        }

        return [oferente: oferente, registro: registroApu, obras: obras]
    }

    def saveRegistroApu_ajax(){
        println("-- " + params)
        def registro

        if(params.id){
            registro = RegistroApu.get(params.id)
        }else{
            registro = new RegistroApu()
        }

        registro.properties = params

        if(!registro.save(flush:true)){
            println("error al guardar la composicion de registro apu " + registro.errors)
            render "no_Error al guardar la composicion de registro apu"
        }else{
            render "ok_Guardado correctamente"
        }
    }


}
