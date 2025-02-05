package janus

class DetalleRubro {

    RubroOferta rubroOferta
    String nombre
    String unidad
    double cantidad
    double precio
    double costo
    double rendimiento
    double subtotal

    static auditable = true
    static mapping = {
        table 'dtrb'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'dtrb__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'dtrb__id'
            rubroOferta column: 'ofrb__id'
            nombre column: 'ofrbnmbr'
            unidad column: 'itemundd'
            cantidad column: 'itemcntd'
            precio column: 'itempcun'
            costo column: 'itemcsto'
            rendimiento column: 'itemrndm'
            subtotal column: 'itemsbtt'
        }
    }
    static constraints = {
        rubroOferta(blank: true, nullable: true)
        nombre(blank: true, nullable: true)
        unidad(blank: false, nullable: false)
        cantidad(blank: true, nullable: true)
        precio(blank: true, nullable: true)
        costo(blank: true, nullable: true)
        rendimiento(blank: true, nullable: true)
        subtotal(blank: true, nullable: true)
    }

}
