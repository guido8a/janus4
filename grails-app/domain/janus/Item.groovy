package janus

import audita.Auditable

//import janus.construye.Empresa
import janus.pac.CodigoComprasPublicas
import seguridad.Persona

class Item implements Auditable {
    Persona responsable
    Unidad unidad
    TipoItem tipoItem
    DepartamentoItem departamento
    String codigo
    String nombre
    double peso
    Date fecha = new Date()
    Date fechaRegistro
    Date fechaModificacion
    String estado
    double transportePeso
    double transporteVolumen
    Item padre
    String inec
    String transporte
    double rendimiento = 0
    String tipo
    String campo
    String registro
    String combustible
    String observaciones
    String foto
    TipoLista tipoLista
    String especificaciones
    String codigoEspecificacion
    CodigoComprasPublicas codigoComprasPublicas
    CodigoComprasPublicas codigoComprasPublicasTransporte
    String aprobado
    double transporteValor
    Fabricante fabricante
    String codigoHistorico
    double transporetFijo = 0
    Persona modifica
//    Empresa empresa

    static auditable = true

    static mapping = {
        table 'item'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'item__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'item__id'
            responsable column: 'prsn__id'
            unidad column: 'undd__id'
            tipoItem column: 'tpit__id'
            departamento column: 'dprt__id'
            codigo column: 'itemcdgo'
            codigoHistorico column: 'itemcdhs'
            nombre column: 'itemnmbr'
            peso column: 'itempeso'
            fecha column: 'itemfcha'
            fechaRegistro column: 'itemfcrg'
            fechaModificacion column: 'itemfcmd'
            estado column: 'itemetdo'
            transportePeso column: 'itemtrps'
            transporteVolumen column: 'itemtrvl'
            padre column: 'itempdre'
            inec column: 'iteminec'
            transporte column: 'itemtrnp'
            rendimiento column: 'itemrndm'
            tipo column: 'itemtipo'
            campo column: 'itemcmpo'
            registro column: 'itemrgst'
            combustible column: 'itemcmbs'
            observaciones column: 'itemobsr'
            foto column: 'itemfoto'
            tipoLista column: 'tpls__id'
            especificaciones column: 'itemespc'
            codigoEspecificacion column: 'itemcdes'
            codigoComprasPublicas column: 'cpac__id'
            codigoComprasPublicasTransporte column: 'cpactran'
            aprobado column: 'itemaprb'
            transporteValor column: 'itemtrva'
            fabricante column: 'fabr__id'
            transporetFijo column: 'itemtrfj'
            modifica column: 'prsnmdfc'
//            empresa column: 'empr__id'
        }
    }
    static constraints = {
        responsable(nullable: true,blank:true)
//        empresa(nullable: true,blank:true)
        nombre(size: 1..200, blank: false, attributes: [title: 'nombre'])
        codigo(size: 1..30, blank: false, attributes: [title: 'numero'])
        codigoHistorico(blank: true, nullable: true, attributes: [title: 'código histórico'])
        unidad(blank: true, nullable: true, attributes: [title: 'unidad'])
        tipoItem(blank: true, nullable: true, attributes: [title: 'tipoItem'])
        peso(blank: true, nullable: true, attributes: [title: 'peso'])
        departamento(blank: true, nullable: true, attributes: [title: 'departamento'])
        estado(size: 1..1, blank: true, nullable: true, attributes: [title: 'estado'])
        fecha(blank: true, nullable: true, attributes: [title: 'fecha'])
        fechaRegistro(blank: true, nullable: true, attributes: [title: 'fecha de registro'])
        fechaModificacion(blank: true, nullable: true, attributes: [title: 'fecha de ultima modificacion'])
        transportePeso(blank: true, nullable: true, attributes: [title: 'transportePeso'])
        transporteVolumen(blank: true, nullable: true, attributes: [title: 'transporteVolumen'])
        padre(blank: true, nullable: true, attributes: [title: 'padre'])
        inec(size: 1..1, blank: true, nullable: true, attributes: [title: 'inec'])
        rendimiento(blank: true, nullable: true, attributes: [title: 'rendimiento'])
        tipo(size: 1..1, blank: true, nullable: true, attributes: [title: 'tipo'])
        campo(size: 0..29, blank: true, nullable: true, attributes: [title: 'nombre corto'])
        registro(size: 1..1, blank: true, nullable: true, attributes: [title: 'registro'])
        transporte(size: 1..2, blank: true, nullable: true, attributes: [title: 'transporte'])
        combustible(size: 1..1, blank: true, nullable: true, attributes: [title: 'combustible'])
        observaciones(size: 1..127, blank: true, nullable: true, attributes: [title: 'observaciones'])
        foto(size: 1..100, blank: true, nullable: true)
        tipoLista(blank: true, nullable: true)
        especificaciones(blank: true, nullable: true, size: 1..1024)
        codigoEspecificacion(blank: true, nullable: true, size: 1..30)
        codigoComprasPublicas(blank: true, nullable: true, attributes: [title: 'Código de Compras Públicas'])
        codigoComprasPublicasTransporte(blank: true, nullable: true)
        aprobado(blank: true, nullable: true, attributes: [title: 'Aprobado'])
        transporteValor(blank: true, nullable: true, attributes: [title: 'Transporte valor'])
        fabricante(blank: true, nullable: true)
        transporetFijo(blank: true, nullable: true)
        modifica(blank: true, nullable: true)
    }

    String toString() {
        "${this.codigo} - ${this.nombre}"
    }
}