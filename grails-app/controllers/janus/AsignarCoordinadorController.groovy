package janus

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Persona

class AsignarCoordinadorController {

    def index() {}

    def getDepartamento () {
        def direccion = Direccion.get(params.id)
        def departamento = Departamento.findAllByDireccion(direccion).sort{it.descripcion}
        return[departamento: departamento, id: params.id]
    }

    def asignarCoordinador () {
    }

    def getPersonas () {
        def departamento = Departamento.get(params.id)
        def personas

        if (departamento){
            personas = Persona.findAllByDepartamento(departamento).sort{it.apellido}
        }else {
            personas = []
        }
        return [personas: personas, departamento: departamento]
    }

    def sacarFunciones () {
        def departamento = Departamento.get(params.id)
        def personas = Persona.findAllByDepartamento(departamento, [sort: 'nombre'])
        def funcion = Funcion.get(10)
        def roles = PersonaRol.findAllByPersonaInListAndFuncion(personas, funcion )
        render roles.size()
    }

    def guardarCoordinador_ajax(){
        def funcionCoordinador = Funcion.get(10)
        def persona = Persona.get(params.id)

        def existe = PersonaRol.findByPersonaAndFuncion(persona, funcionCoordinador)

        if(existe){
            render "no_La persona seleccionada ya se encuentra asignada como coordinador del departamento"
        }else{
            def personaRol = new PersonaRol()
            personaRol.persona = persona
            personaRol.funcion = funcionCoordinador

            if(!personaRol.save(flush:true)){
                println("Error al guardar el coordinador")
                render "no_Error al guardar el coordinador"
            }else{
                render "ok_Coordinador guardado correctamente"
            }
        }

    }

//    def grabarFuncion () {
//        def funcion = Funcion.get(10)
//
//        if(params.direccion != '-1'){
//            if(params.departamento){
//                if(params.id){
//                    def departamento = Departamento.get(params.departamento)
//                    def persona = Persona.get(params.id)
//                    def personasDepartamento = Persona.findAllByDepartamento(departamento)
//                    def existeCoordinador
//
//                    if(personasDepartamento.size() > 0){
//                        existeCoordinador  = PersonaRol.findAllByPersonaInListAndFuncion(personasDepartamento, funcion)
//                    }else{
//                        existeCoordinador = []
//                    }
//
//                    if(existeCoordinador.size() > 0){
//                        render "no_El departamento ya posee un coordinador asignado"
//                        return true
//                    }else{
//
//                        def personaRol = new PersonaRol()
//                        personaRol.persona = Persona.get(params.id)
//                        personaRol.funcion = funcion
//
//                        if (!personaRol.save([flush: true])) {
//                            render "no_Error al asignar el coordinador"
//                            println "ERROR al asignar el coordinador : "+personaRol.errors
//                        } else {
//                            render "ok_Asignado correctamente"
//                        }
//                    }
//
//                }else{
//                    render "no_Seleccione una persona"
//                }
//            }else{
//                render "no_Seleccione un departamento"
//            }
//        }else{
//            render "no_Seleccione una dirección"
//        }
//    }

    def obtenerFuncionCoor () {
        def persona = Persona.get(params.id);
        def funcion = Funcion.get(10)
        def rol = PersonaRol.findByPersonaAndFuncion(persona, funcion)
        return [persona: persona, rol: rol]
    }

    def mensajeCoordinador () {
        def departamento = Departamento.get(params.id)
        def personas

        if(departamento){
            personas = Persona.findAllByDepartamento(departamento)
        }else{
            personas = []
        }

        def funcionCoor = Funcion.get(10)

        def getCoordinador

        if(personas != []){
            getCoordinador = PersonaRol.findAllByFuncionAndPersonaInList(funcionCoor, personas)
        }else {
            getCoordinador = null
        }

        println("coordinador " + getCoordinador)

        return [personas: personas, getCoordinador: getCoordinador, id: params.id]
    }

    def tablaCoordinadores_ajax(){
        def departamento = Departamento.get(params.id)
        def personas

        if(departamento){
            personas = Persona.findAllByDepartamento(departamento)
        }else{
            personas = []
        }

        def funcionCoordinador = Funcion.get(10)

        def coordinadores = []

        if(personas?.size() > 0){
            coordinadores = PersonaRol.findAllByFuncionAndPersonaInList(funcionCoordinador, personas)
        }else {
            coordinadores = []
        }

        return [coordinadores: coordinadores, departamento:departamento]
    }

    def delete_ajax(){
        def personaRol = PersonaRol.get(params.id)

        try {
            personaRol.delete(flush:true)
            render "ok_Coordinador borrado correctamente"
        }catch(e){
            println("Error al borrar el coordinador " + personaRol.errors)
            render "no_Error al borrar el coordinador"
        }
    }

}