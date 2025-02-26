package janus

import seguridad.Persona

class Precio {

    Persona oferente
    Item item
    Obra obra
    double precio
    double vae
    Date fecha


    static auditable = true

    static mapping = {
        table 'prco'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'prco__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'prco__id'
            oferente column: 'prsn__id'
            item column: 'item__id'
            precio column: 'prcoprco'
            vae column: 'prco_vae'
            fecha column: 'prcofcha'
            obra column: 'obra__id'
        }
    }

    static constraints = {
        item(blank: false, nullable: false)
        oferente(blank: false, nullable: false)
        precio(blank: false, nullable: false)
        vae(blank: false, nullable: false)
        fecha(blank: true, nullable: true)
        obra(blank: true, nullable: true)
    }
}
