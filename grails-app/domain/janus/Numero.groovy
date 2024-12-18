package janus

class Numero {
    TipoNumero tipoNumero
    String descripcion
    int valor

    static auditable = false

    static mapping = {

        table 'nmro'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'nmro__id'
        id generator: 'identity'
        version false
        columns {
            tipoNumero column: 'tpnm__id'
            descripcion column: 'nmrodscr'
            valor column: 'nmrovlor'
        }
    }

    static constraints = {
       descripcion(size: 1..31, blank: false, attributes: [title: 'descripcion'])
       valor(blank: false, nullable: false, attributes: [title: 'valor'])
    }
}
