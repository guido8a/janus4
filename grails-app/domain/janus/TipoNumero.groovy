package janus

import audita.Auditable

class TipoNumero implements Auditable {
    String descripcion

    static auditable = true

    static mapping = {
        table 'tpnm'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'tpnm__id'
        id generator: 'identity'
        version false
        columns {
            descripcion column: 'tpnmdscr'
        }
    }
    static constraints = {
        descripcion(size: 1..63, unique: true, blank: false, attributes: [title: 'descripcion'])
    }
}