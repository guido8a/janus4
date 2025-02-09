package janus.cnsl

import audita.Auditable

class Nivel implements Auditable {
    String descripcion

    static auditable = true
    static mapping = {
        table 'nvel'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'nvel__id'
        id generator: 'identity'
        version false
        columns {
            descripcion column: 'nveldscr'
        }
    }
    static constraints = {
        descripcion(size: 1..15, blank: false, nullable: false, attributes: [title: 'descripcion'])
    }
}