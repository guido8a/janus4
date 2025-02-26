package janus

class VerificacionPreciosController {

    def dbConnectionService

    def verificacion () {
        /** muestra precios no actualizados 7 meses atras */
        def cn = dbConnectionService.getConnection()
        def obra = Obra.get(params.id)

        def sql = "SELECT distinct itemcdgo codigo, itemnmbr item, item__id, unddcdgo unidad, rbpcpcun  punitario, " +
                "rbpcfcha fecha FROM obra_rbpc(${params.id}) " +
                "where rbpcfcha <= (cast('${obra.fechaPreciosRubros.format('yyyy-MM-dd')}' as date) - 1) or " +
                "rbpcfcha is null " +
                "ORDER BY itemnmbr"
        println "verif: $sql"
        def res = cn.rows(sql.toString())

        return[res: res, obra: obra]
    }

    def preciosCero () {
        def cn = dbConnectionService.getConnection()
        def obra = Obra.get(params.id)

        def sql = "select distinct item.itemcdgo codigo, itemnmbr item, unddcdgo unidad, voitpcun  punitario " +
                "from vlobitem, item, undd " +
                "where obra__id = ${params.id} and voitpcun = 0 and item.item__id = vlobitem.item__id and " +
                "undd.undd__id = item.undd__id order by item.itemcdgo"

//        println "sql: $sql"

        def res = cn.rows(sql.toString())

        return[res: res, obra: obra]
    }

    def editarPrecio_ajax() {
        println "editarPrecio_ajax: $params"
        def cn = dbConnectionService.getConnection()
        def obra = Obra.get(params.obra)
        def sql = "select distinct rbpcfcha from rbpc " +
                "where rbpcfcha <= '${obra.fechaPreciosRubros.format('yyyy-MM-dd')}' " +
                "order by rbpcfcha desc limit 5"
        println "sql: $sql"
        def fechas = [:]
        def i = 0
        cn.eachRow(sql.toString()) { d ->
            fechas[i] = d.rbpcfcha.format('dd/MM/yyyy')
            i++
        }
        [fechas: fechas]
    }

//    def poneFechaPrecios() {
//        def anio = new Date().format('yyyy')
//        def fechas = [1: '15/01/' + anio, 2: '1/05/' + anio, 3: '1/09/' + anio]
//        return fechas
//    }
//

    /**
     * se debe actualizar elprecio a la fecha obra.rbpcfcha para que no salga en la lista de valores
     * de Precios no Act.
     * */
    def savePrecio_ajax(){
        println("parmasw " + params)
        def cn = dbConnectionService.getConnection()
        def item = Item.get(params.id)
        def fcha = new Date().parse("dd/MM/yyyy", params.fecha)?.format('yyyy-MM-dd')
        def sql = ""
        def listas = ['MQ': 'lgarlsmq', 'P1': 'lgarps01', 'V1': 'lgarvl01', 'V2': 'lgarvl02', 'V': 'lgarvl00']
        params.valor = params.valor?.toDouble()
        println "listas: $listas --> ${item?.tipoLista.codigo} --> ${listas[item?.tipoLista.codigo]}"

        if(item?.tipoLista.codigo.trim() == 'P') {
            sql = "insert into rbpc(item__id, lgar__id, rbpcfcha, rbpcpcun, rbpcfcin, rbpcrgst) " +
                    "select ${params.id}, lgar__id, '${fcha}', ${params.valor}, now(), 'N' from lgar " +
                    "where tpls__id = 1 order by lgar__id"
        } else {
            sql = "insert into rbpc(item__id, lgar__id, rbpcfcha, rbpcpcun, rbpcfcin, rbpcrgst) " +
                    "select ${params.id}, ${listas[item?.tipoLista.codigo]}, '${fcha}', ${params.valor}, now(), 'N' from obra " +
                    "where obra__id = ${params.obra} order by lgar__id"
        }

        println "sql: $sql"
        cn.execute(sql.toString())
        cn.close()
        render "ok"
    }

}
