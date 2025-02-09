package janus.cnsl

import audita.Auditable
import janus.Obra

class DetalleConsultoria implements Auditable {
    Obra obra
    Costo costo
    int orden
    String descripcion
    Double valor

    static auditable = true
    static mapping = {
        table 'dtcn'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'dtcn__id'
        id generator: 'identity'
        version false
        columns {
            obra column: 'obra__id'
            costo column: 'csto__id'
            orden column: 'dtcnordn'
            descripcion column: 'dtcndscr'
            valor column: 'dtcnvlor'
        }
    }
    static constraints = {
        obra(blank: false, nullable: false, attributes: [title: 'obra'])
        costo(blank: true, nullable: true, attributes: [title: 'costo'])
        orden(blank: false, nullable: false, attributes: [title: 'orden'])
        descripcion(size: 1..127, blank: false, nullable: false, attributes: [title: 'descripcion'])
        valor(blank: false, nullable: false, attributes: [title: 'valor'])
    }
}