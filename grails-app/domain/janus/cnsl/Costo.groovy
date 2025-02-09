package janus.cnsl

import audita.Auditable

class Costo implements Auditable {
    Nivel nivel
    Costo padre
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
            nivel column: 'nvel__id'
            padre column: 'cstopdre'
            numero column: 'cstonmro'
            descripcion column: 'cstodscr'
            movimiento column: 'cstomvmt'
            estado column: 'cstoetdo'
        }
    }
    static constraints = {
        nivel(blank: false, nullable: false, attributes: [title: 'nivel'])
        padre(blank: true, nullable: true, attributes: [title: 'padre'])
        numero(size: 1..20, blank: false, nullable: false, attributes: [title: 'descripcion'])
        descripcion(size: 1..15, blank: false, nullable: false, attributes: [title: 'descripcion'])
        movimiento(size: 1..1, blank: false, nullable: false, attributes: [title: 'movimiento'])
        estado(size: 1..1, blank: false, nullable: false, attributes: [title: 'estado'])
    }
}