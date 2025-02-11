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
        tipo(blank: true, nullable: true)
        codigo(blank: true, nullable: true)
        nombre(blank: true, nullable: true)
        unidad(blank: false, nullable: false)
        peso(blank: false, nullable: false)
        cantidad(blank: false, nullable: false)
        precio(blank: false, nullable: false)
        costo(blank: false, nullable: false)
        rendimiento(blank: false, nullable: false)
        subtotal(blank: false, nullable: false)
        idJanus(blank: false, nullable: false)
    }

}
