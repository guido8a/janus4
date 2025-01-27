package janus

import janus.pac.Proveedor

class Consorcio {

    Accionista accionista
    Proveedor proveedor
    double porcentaje

    static auditable = true
    static mapping = {
        table 'cnsc'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'cnsc__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'cnsc__id'
            accionista column: 'prac__id'
            proveedor column: 'prve__id'
            porcentaje column: 'cnscpcnt'
        }
    }
    static constraints = {
        accionista(blank: false, nullable: false)
        proveedor(blank: false, nullable: false)
        porcentaje(blank: true, nullable: true)
    }

}
