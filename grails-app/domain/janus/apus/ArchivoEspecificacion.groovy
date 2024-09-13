package janus.apus

import audita.Auditable
import janus.Item

class ArchivoEspecificacion implements Auditable {
    Item item
    String codigo
    String ruta
    String especificacion

    static auditable = true
    static mapping = {
        table 'ares'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'ares__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'ares__id'
            item column: 'item__id'
            codigo column: 'itemcdes'
            ruta column: 'aresruta'
            especificacion column: 'aresespe'
        }
    }
    static constraints = {
        item(blank: false, nullable: false, attributes: [title: 'item'])
        codigo(size: 1..30, blank: false, nullable: false, attributes: [title: 'código de la especifiación'])
        ruta(size: 1..255, blank: false, nullable: false, attributes: [title: 'ruta del archivo'])
        especificacion(size: 1..255, blank: true, nullable: true, attributes: [title: 'especificacion del archivo'])
    }
    String toString(){
        "${item.codigo} archivo: ${ruta}"
    }
}