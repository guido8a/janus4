package janus

import seguridad.Persona

class RubroOferta {

    Persona persona
    String nombre
    String unidad
    int orden
    int idJanus

    static auditable = true
    static mapping = {
        table 'ofrb'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'ofrb__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'ofrb__id'
            persona column: 'prsn__id'
            nombre column: 'ofrbnmbr'
            unidad column: 'ofrbundd'
            orden column: 'ofrbordn'
            idJanus column: 'ofrbjnid'
        }
    }
    static constraints = {
        persona(blank: true, nullable: true)
        nombre(blank: true, nullable: true)
        unidad(blank: false, nullable: false)
        orden(blank: false, nullable: false)
        idJanus(blank: true, nullable: true)
    }

}
