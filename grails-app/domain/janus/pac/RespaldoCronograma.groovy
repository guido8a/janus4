package janus.pac

import janus.VolumenContrato

class RespaldoCronograma {

    ModificacionCronograma modificacionCronograma
    VolumenContrato volumenObra
    RespaldoPeriodoEjecucion periodo
    Integer cronogramaOriginal
    Double precio
    Double porcentaje
    Double cantidad
    static auditable = true

    static mapping = {
        table 'crbk'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'crbk__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'crbk__id'
            modificacionCronograma column: 'mdcr__id'
            volumenObra column: 'vocr__id'
            cronogramaOriginal column: 'creo__id'
            periodo column: 'pebk__id'
            precio column: 'crbkprco'
            porcentaje column: 'crbkprct'
            cantidad column: 'crbkcntd'
        }
    }
    static constraints = {
        cronogramaOriginal(blank: false, nullable: false)
        modificacionCronograma(blank: false, nullable: false)
        volumenObra(blank: false, nullable: false)
        periodo(blank: false, nullable: false, attributes: [title: 'periodo'])
        precio(blank: false, nullable: false, attributes: [title: 'precio'])
        porcentaje(blank: false, nullable: false, attributes: [title: 'porcentaje'])
        cantidad(blank: false, nullable: false, attributes: [title: 'cantidad'])
    }
}
