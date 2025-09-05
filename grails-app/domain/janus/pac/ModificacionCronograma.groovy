package janus.pac

import janus.Contrato

class ModificacionCronograma {

    Contrato contrato
    String descripcion
    Date fecha

    static auditable = true
    static mapping = {
        table 'mdcr'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'mdcr__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'mdcr__id'
            contrato column: 'cntr__id'
            descripcion column: 'mdcrdscr'
            fecha column: 'mdcrfcha'

        }
    }
    static constraints = {
        contrato(blank: false, nullable: false)
        descripcion(blank: false, nullable: false)
        fecha(blank: false, nullable: false)
    }
}
