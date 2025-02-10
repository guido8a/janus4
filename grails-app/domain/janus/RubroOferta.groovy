package janus

import seguridad.Persona

class RubroOferta {

    Persona persona
    Obra obra
    String nombre
    String unidad
    int orden
    int idJanus
    Double precioUnitario
    Double indirectos

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
            obra column: 'obra__id'
            nombre column: 'ofrbnmbr'
            unidad column: 'ofrbundd'
            orden column: 'ofrbordn'
            idJanus column: 'ofrbjnid'
            precioUnitario column: 'ofrbpcun'
            indirectos column: 'ofrbindi'
        }
    }
    static constraints = {
        persona(blank: false, nullable: false)
        obra(blank: false, nullable: false)
        nombre(blank: false, nullable: false)
        unidad(blank: false, nullable: false)
        orden(blank: false, nullable: false)
        idJanus(blank: true, nullable: true)
        precioUnitario(blank: true, nullable: true)
        indirectos(blank: true, nullable: true)
    }

}
