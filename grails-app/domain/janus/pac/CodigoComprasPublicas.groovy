package janus.pac

class CodigoComprasPublicas {

    CodigoComprasPublicas padre
    String numero
    String descripcion
    int nivel = 1
    Date fecha
    int movimiento
    double umbralVae

    static auditable = true

    static mapping = {
        table 'cpac'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'cpac__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'cpac__id'
            padre column: 'cpacpdre'
            numero column: 'cpacnmro'
            descripcion column: 'cpacdscr'
            nivel column: 'cpacnvel'
            fecha column: 'cpacfcha'
            movimiento column: 'cpacmvnt'
            umbralVae column: 'cpacumve'
        }
    }
    static constraints = {
        numero(nullable: false,blank: false,size: 1..32)
        descripcion(nullable: true,blank: true,size: 1..512)
        fecha(nullable: true,blank:true)
        padre(nullable: true,blank:true)
        umbralVae(nullable: true, blank:true)
    }

}
