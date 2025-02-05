package janus

class ItemOferta {

    DetalleRubro detalleRubro
    Item item

    static auditable = true
    static mapping = {
        table 'itof'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'itof__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'itof__id'
            detalleRubro column: 'dtrb__id'
            item column: 'item__id'
        }
    }
    static constraints = {
        detalleRubro(blank: true, nullable: true)
        item(blank: true, nullable: true)
    }

}
