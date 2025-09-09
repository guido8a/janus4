package janus.pac

import janus.Contrato
import janus.Obra

class RespaldoPeriodoEjecucion {

    ModificacionCronograma modificacionCronograma
    Obra obra
    Contrato contrato
    Integer periodoOriginal
    Integer numero
    String tipo
    Date fechaInicio
    Date fechaFin
    double parcialCronograma=0
    double parcialContrato=0
    double parcialCmpl=0

    static auditable = true
    static mapping = {
        table 'pebk'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'pebk__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'pebk__id'
            modificacionCronograma column: 'mdcr__id'
            obra column: "obra__id"
            contrato column: 'cntr__id'
            periodoOriginal column: 'prej__id'
            numero column: 'pebknmro'
            tipo column: 'pebktipo'
            fechaInicio column: 'pebkfcin'
            fechaFin column: 'pebkfcfn'
            parcialCronograma column: 'pebkcrpa'
            parcialContrato column: 'pebkcntr'
            parcialCmpl column: 'pebkcmpl'
        }
    }
    static constraints = {
        modificacionCronograma(blank: false, nullable: false)
        obra(blank: false, nullable: false)
        periodoOriginal(blank: false, nullable: false)
        numero(blank: false, nullable: false, attributes: [title: 'periodo'])
        tipo(blank: false, nullable: false, inList: ['P', 'S', 'A', 'C'], attributes: [title: 'tipo'])
        fechaInicio(blank: false, nullable: false, attributes: [title: 'fecha inicio'])
        fechaFin(blank: false, nullable: false, attributes: [title: 'fecha fin'])
        contrato(blank: false, nullable: false, attributes: [title: 'contrato'])
        parcialCronograma(blank: false, nullable: false)
        parcialContrato(blank: false, nullable: false)
        parcialCmpl(blank: false, nullable: false)
    }

}
