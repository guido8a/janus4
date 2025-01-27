package janus

class Accionista {

    String cedula
    String nombre
    String apellido
    String titulo
    String cargo
    String mail
    String telefono

    static auditable = true
    static mapping = {
        table 'prac'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'prac__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'prac__id'
            cedula column: 'praccdla'
            nombre column: 'pracnmbr'
            apellido column: 'pracapll'
            titulo column: 'practitl'
            cargo column: 'praccrgo'
            mail column: 'pracmail'
            telefono column: 'practelf'
        }
    }
    static constraints = {
        cedula(blank: false, nullable: false)
        nombre(blank: false, nullable: false)
        apellido(blank: false, nullable: false)
        titulo(blank: true, nullable: true)
        cargo(blank: true, nullable: true)
        mail(blank: true, nullable: true)
        telefono(blank: true, nullable: true)
    }
}
