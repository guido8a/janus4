package janus

class RubroOfertaController {

    def dbConnectionService

    def list(){
        def oferente = session.usuario
        def cn = dbConnectionService.getConnection()
        def obras = [:]
        def sql = "select distinct obra.obra__id id, obracdgo||' - '||obranmbr nombre " +
                "from obra, obof " +
                "where obof.obra__id = obra.obra__id and obof.prsn__id = ${oferente.id}" +
                "order by 1"
        cn.eachRow(sql.toString()) { r ->
            obras[r.id] = r.nombre
        }
        [obras: obras, oferente: oferente]
    }

    def tablaRubros_ajax(){

        def obra = Obra.get(params.id)
        def cn = dbConnectionService.getConnection()
        def sql = "select ofrb.ofrb__id, ofrbordn, ofrbnmbr, ofrbpcun, sum(dtrbsbtt*(1+ofrbindi/100)), " +
                "ofrbpcun - sum(dtrbsbtt*(1+ofrbindi/100))::numeric(14,5) as diff from ofrb, dtrb where obra__id = ${obra?.id} " +
                "and dtrb.ofrb__id = ofrb.ofrb__id group by ofrb.ofrb__id, ofrbordn, ofrbnmbr, ofrbpcun order by ofrbordn;"
        println "sql. $sql"
        def data = cn.rows(sql.toString())

        return [data:data]
    }
}
