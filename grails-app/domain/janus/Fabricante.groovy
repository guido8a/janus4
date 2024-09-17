package janus

class Fabricante {

    String ruc
    String nombre
    String nombreContacto
    String apellidoContacto
    String gerente
    String direccion
    String telefono
    Date fecha
    String mail
    String ttlr
    String estado
    String observaciones

    static auditable = true
    static mapping = {
        table 'fabr'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'fabr__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'fabr__id'
            ruc column: 'fabr_ruc'
            nombre column: 'fabrnmbr'
            nombreContacto column: 'fabrnbct'
            apellidoContacto column: 'fabrapct'
            gerente column: 'fabrgrnt'
            direccion column: 'fabrdire'
            telefono column: 'fabrtelf'
            fecha column: 'fabrfccn'
            mail column: 'fabrmail'
            ttlr column: 'fabrttlr'
            estado column: 'fabretdo'
            observaciones column: 'fabrobsr'
        }
    }
    static constraints = {
        ruc(size: 1..13, blank: false, nullable: false)
        nombre(size: 1..20, blank: false, nullable: false)
        nombreContacto(size: 1..31, blank: true, nullable: true)
        apellidoContacto(size: 1..31, blank: true, nullable: true)
        gerente(size: 1..40, blank: true, nullable: true)
        direccion(size: 1..60, blank: true, nullable: true)
        telefono(size: 1..40, blank: true, nullable: true)
        fecha(blank: false, nullable: false)
        mail(size: 1..40, blank: true, nullable: true)
        ttlr(size: 1..4, blank: true, nullable: true)
        estado(blank: true, nullable: true)
        observaciones(size: 1..127, blank: true, nullable: true)
    }
}
