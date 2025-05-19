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

        def registro

        if(params.id){
            registro = RegistroApu.get(params.id)
        }else{
            registro = new RegistroApu()
        }

        if(params.prefijo){
            params.prefijo = 1
        }else{
            params.prefijo = 0
        }

        params.cldatitl = params.cldatitl?.toUpperCase()
        params.cldarbro = params.cldarbro?.toUpperCase()
        params.rbronmbr = params.rbronmbr?.toUpperCase()
        params.cldaEq = params.cldaEq?.toUpperCase()
        params.cdgoEq = params.cdgoEq?.toUpperCase()
        params.nmbrEq = params.nmbrEq?.toUpperCase()
        params.cntdEq = params.cntdEq?.toUpperCase()
        params.trfaEq = params.trfaEq?.toUpperCase()
        params.pcunEq = params.pcunEq?.toUpperCase()
        params.rndmEq = params.rndmEq?.toUpperCase()
        params.cstoEq = params.cstoEq?.toUpperCase()
        params.cldaMo = params.cldaMo?.toUpperCase()
        params.cdgoMo = params.cdgoMo?.toUpperCase()
        params.nmbrMo = params.nmbrMo?.toUpperCase()
        params.cntdMo = params.cntdMo?.toUpperCase()
        params.trfaMo = params.trfaMo?.toUpperCase()
        params.pcunMo = params.pcunMo?.toUpperCase()
        params.rndmMo = params.rndmMo?.toUpperCase()
        params.cstoMo = params.cstoMo?.toUpperCase()
        params.cldaMt = params.cldaMt?.toUpperCase()
        params.cdgoMt = params.cdgoMt?.toUpperCase()
        params.nmbrMt = params.nmbrMt?.toUpperCase()
        params.unddMt = params.unddMt?.toUpperCase()
        params.cntdMt = params.cntdMt?.toUpperCase()
        params.pcunMt = params.pcunMt?.toUpperCase()
        params.cstoMt = params.cstoMt?.toUpperCase()
        params.cldaTr = params.cldaTr?.toUpperCase()
        params.cdgoTr = params.cdgoTr?.toUpperCase()
        params.nmbrTr = params.nmbrTr?.toUpperCase()
        params.unddTr = params.unddTr?.toUpperCase()
        params.pesoTr = params.pesoTr?.toUpperCase()
        params.cntdTr = params.cntdTr?.toUpperCase()
        params.dstnTr = params.dstnTr?.toUpperCase()
        params.pcunTr = params.pcunTr?.toUpperCase()
        params.cstoTr = params.cstoTr?.toUpperCase()

        registro.properties = params

        if(!registro.save(flush:true)){
            println("error al guardar la composicion de registro apu " + registro.errors)
            render "no_Error al guardar la composicion de registro apu"
        }else{
            render "ok_Guardado correctamente"
        }
    }

    def nombre_ajax(){
        def registro = RegistroApu.get(params.id)

        return[registro: registro]
    }


}
