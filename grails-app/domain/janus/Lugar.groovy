package janus

import audita.Auditable

//import janus.construye.Empresa

class Lugar implements Auditable {
    int codigo
    String descripcion
    String tipo
    TipoLista tipoLista
//    Empresa empresa
    static auditable = true
    static mapping = {
        table 'lgar'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'lgar__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'lgar__id'
            codigo column: 'lgarcdgo'
            descripcion column: 'lgardscr'
            tipo column: 'lgartipo'
            tipoLista column: 'tpls__id'
//            empresa column: 'empr__id'
        }
    }
    static constraints = {
        codigo(blank: false, attributes: [title: 'codigo'])
        tipo(size: 1..1, blank: true, nullable: true, inList: ['C', 'V'], attributes: [title: 'tipo'])
        descripcion(size: 1..40, blank: false, attributes: [title: 'descripcion'])
//        empresa(blank: false, nullable: false)
    }
}