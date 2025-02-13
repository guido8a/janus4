package janus.cnsl

import audita.Auditable

class Costo implements Auditable {
    Costo padre
    int nivel
    String numero
    String descripcion
    String movimiento
    String estado

    static auditable = true
    static mapping = {
        table 'csto'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'csto__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'csto__id'
            padre column: 'cstopdre'
            nivel column: 'cstonvel'
            numero column: 'cstonmro'
            descripcion column: 'cstodscr'
            movimiento column: 'cstomvmt'
            estado column: 'cstoetdo'
        }
    }
    static constraints = {
        padre(blank: true, nullable: true, attributes: [title: 'padre'])
        nivel(blank: false, nullable: false, attributes: [title: 'nivel'])
        numero(size: 1..10, blank: false, nullable: false, attributes: [title: 'descripcion'])
        descripcion(size: 1..255, blank: false, nullable: false, attributes: [title: 'descripcion'])
        movimiento(size: 1..1, blank: false, nullable: false, attributes: [title: 'movimiento'])
        estado(size: 1..1, blank: false, nullable: false, attributes: [title: 'estado'])
    }

    String toString() {
        "${this.numero} (${this.descripcion})"
    }
}