package janus.cnsl

import audita.Auditable
import janus.Obra

class PrecioCostos implements Auditable {
    Costo costo
    Double precioUnitario
    Date fecha
    Date fechaIngreso
    String registro = 'N'

    static auditable = true
    static mapping = {
        table 'prcs'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'prcs__id'
        id generator: 'identity'
        version false
        columns {
            costo column: 'csto__id'
            precioUnitario column: 'prcspcun'
            fecha column: 'prcsfcha'
            fechaIngreso column: 'prcsfcin'
            registro column: 'prcsrgst'
        }
    }
    static constraints = {
        costo(blank: true, nullable: true, attributes: [title: 'costo'])
        precioUnitario(blank: false, nullable: false, attributes: [title: 'precio'])
        fecha(blank: false, nullable: false, attributes: [title: 'fecha'])
        fechaIngreso(blank: false, nullable: false, attributes: [title: 'fecha registro'])
        registro(blank: false, nullable: false, attributes: [title: 'regsitrado'])
    }
}