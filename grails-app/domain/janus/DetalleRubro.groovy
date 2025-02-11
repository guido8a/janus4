package janus

class DetalleRubro {

    RubroOferta rubroOferta
    String tipo
    String codigo
    String nombre
    String unidad
    double peso
    double cantidad
    double rendimiento
    double distancia
    double precio
    double costo
    double subtotal
    int idJanus = 0

    static auditable = true
    static mapping = {
        table 'dtrb'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'dtrb__id'
        id generator: 'identity'
        version false
        columns {
            rubroOferta column: 'ofrb__id'
            tipo column: 'dtrbtipo'
            codigo column: 'dtrbcdgo'
            nombre column: 'dtrbnmbr'
            unidad column: 'dtrbundd'
            peso column: 'dtrbpeso'
            cantidad column: 'dtrbcntd'
            rendimiento column: 'dtrbrndm'
            distancia column: 'dtrbdstn'
            precio column: 'dtrbpcun'
            costo column: 'dtrbcsto'
            subtotal column: 'dtrbsbtt'
            idJanus column: 'dtrbjnid'
        }
    }
    static constraints = {
        rubroOferta(blank: true, nullable: true)
        tipo(blank: false, nullable: false)
        codigo(blank: true, nullable: true)
        nombre(blank: false, nullable: false)
        unidad(blank: true, nullable: true)
        peso(blank: true, nullable: true)
        cantidad(blank: true, nullable: true)
        precio(blank: true, nullable: true)
        costo(blank: true, nullable: true)
        rendimiento(blank: true, nullable: true)
        subtotal(blank: true, nullable: true)
        idJanus(blank: true, nullable: true)
    }

}
