package janus.cnsl

import org.springframework.dao.DataIntegrityViolationException

//import vesta.seguridad.Shield

/**
 * Controlador que muestra las pantallas de manejo de Costo
 */
class CostoController {

    def dbConnectionService

    static allowedMethods = [save_ajax: "POST", delete_ajax: "POST"]

    /**
     * Acción que muestra las partidas presupuestarias en forma de árbol
     */
    def arbol() {
        println "arbol: $params"
        return [arbol: makeTree()]
    }

    /**
     * Acción llamada con ajax que permite realizar búsquedas en el árbol
     */
    def arbolSearch_ajax() {
        println "arbolSearch_ajax: $params"
        def search = params.str.trim()
        if (search != "") {
            def c = Costo.createCriteria()
            def find = c.list(params) {
                or {
                    ilike("numero", "%" + search + "%")
                    ilike("descripcion", "%" + search + "%")
                }
            }
            println find
            def costos = []
            find.each { pres ->
                if (pres && !costos.contains(pres.descripcion)) {
                    def pr = pres
                    println "pr: ${pr.descripcion}"
//                    while (pr) {
                        if (pr.descripcion && !costos.contains(pr.descripcion)) {
                            costos.add(pr)
                        }
//                        pr = pr.descripcion
//                    }
                }
            }
            costos = costos.reverse()

            def ids = "["
            if (find.size() > 0) {
                ids += "\"#root\","
                costos.each { pr ->
                    ids += "\"#lid_" + pr.id + "\","
                }
                ids = ids[0..-2]
            }
            ids += "]"
            render ids
        } else {
            render ""
        }
    }

    /**
     * Función que genera el árbol de partidas presupuestarias
     */
    def makeTree() {
        println "makeTree: $params"
        def lista = Costo.findAllByNivel(1, [sort: "numero"]).id//Costo.list(sort: "codigo")
        def res = ""
        res += "<ul>"
        res += "<li id='root' data-level='0' class='root jstree-open' data-jstree='{\"type\":\"root\"}'>"
        res += "<a href='#' class='label_arbol'>Costo</a>"
        res += "<ul>"
        lista.each {
            res += imprimeHijos(it)
        }
        res += "</ul>"
        res += "</ul>"
    }

    /**
     * Función que genera las hojas del árbol de un padre específico
     */
    def imprimeHijos(padre) {
        println "imprimeHijos: $padre"
        def band = true
        def t = ""
        def txt = ""

        def costo = Costo.get(padre)

        def l = Costo.findAllByPadre(costo, [sort: 'numero']);

        l.each {
            band = false;
            t += imprimeHijos(it.id)
        }

        if (!band) {
            def clase = "jstree-open"
            if (costo.nivel >= 2) {
                clase = "jstree-closed"
            }
            txt += "<li id='li_" + costo.id + "' data-level='" + costo.nivel + "' class='padre " + clase + "' data-jstree='{\"type\":\"padre\"}'>"
            txt += "<a href='#' class='label_arbol'>" + costo + "</a>"
            txt += "<ul>"
            txt += t
            txt += "</ul>"
        } else {
            txt += "<li id='li_" + costo.id + "' data-level='" + costo.nivel + "' class='hijo jstree-leaf' data-jstree='{\"type\":\"hijo\"}'>"
            txt += "<a href='#' class='label_arbol'>" + costo + "</a>"
        }
        txt += "</li>"
        return txt
    }

//    def imprimeHijos(padre, pcun) {
//        println "imprimeHijos: $padre"
//        def band = true
//        def t = ""
//        def txt = ""
//
//        def costo = Costo.get(padre)
//
//        def l = Costo.findAllByPadre(costo, [sort: 'numero']);
//        def precios, precio
//
//        l.each {
//            band = false;
//            precios = PrecioCostos.findAllByCosto(l, [sort: 'fecha', order: 'desc'])
//            println "--> ${l.numero} ${precios}"
//            precio = (precios?.size() > 0)? precios.last().precioUnitario : ''
//            println "precio: $precio"
//            t += imprimeHijos(it.id, precio)
//        }
//
//        def tx_pcun = pcun ? ' -> $' + pcun : ''
//        if (!band) {
//            def clase = "jstree-open"
//            if (costo.nivel >= 2) {
//                clase = "jstree-closed"
//            }
//            txt += "<li id='li_" + costo.id + "' data-level='" + costo.nivel + "' class='padre " + clase + "' data-jstree='{\"type\":\"padre\"}'>"
//            txt += "<a href='#' class='label_arbol'>" + costo + "</a>"
//            txt += "<ul>"
//            txt += t
//            txt += "</ul>"
//        } else {
//            txt += "<li id='li_" + costo.id + "' data-level='" + costo.nivel + "' class='hijo jstree-leaf' data-jstree='{\"type\":\"hijo\"}'>"
//            txt += "<a href='#' class='label_arbol'>" + costo + tx_pcun + "</a>"
//        }
//        txt += "</li>"
//        return txt
//    }

    /**
     * Acción que redirecciona a la lista (acción "list")
     */
    def index() {
        redirect(action: "list", params: params)
    }

    /**
     * Función que saca la lista de elementos según los parámetros recibidos
     * @param params objeto que contiene los parámetros para la búsqueda:: max: el máximo de respuestas, offset: índice del primer elemento (para la paginación), search: para efectuar búsquedas
     * @param all boolean que indica si saca todos los resultados, ignorando el parámetro max (true) o no (false)
     * @return lista de los elementos encontrados
     */
    def getList(params, all) {
        params = params.clone()
        params.max = params.max ? Math.min(params.max.toInteger(), 100) : 10
        params.offset = params.offset ?: 0
        if (all) {
            params.remove("max")
            params.remove("offset")
        }
        def list
        if (params.search) {
            def c = Costo.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("descripcion", "%" + params.search + "%")
                    ilike("numero", "%" + params.search + "%")
                }
            }
        } else {
            list = Costo.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return costoInstanceList: la lista de elementos filtrados, costoInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def costoInstanceList = getList(params, false)
        def costoInstanceCount = getList(params, true).size()
        return [costoInstanceList: costoInstanceList, costoInstanceCount: costoInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return costoInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if (params.id) {
            def costoInstance = Costo.get(params.id)
            if (!costoInstance) {
                render "ERROR*No se encontró Costo."
                return
            }
            return [costoInstance: costoInstance]
        } else {
            render "ERROR*No se encontró Costo."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formulario para crear o modificar un elemento
     * @return costoInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def costoInstance = new Costo()
        if (params.id) {
            costoInstance = Costo.get(params.id)
            if (!costoInstance) {
                render "ERROR*No se encontró Costo."
                return
            }
        }
        costoInstance.properties = params
        def nivel = 1
        if (!params.id) {
            costoInstance.movimiento = 0
        } else {
            nivel = costoInstance.nivel
        }
        if (params.padre) {
            def padre = Costo.get(params.padre.toLong())
            nivel = padre.nivel + 1
            costoInstance.padre = padre
        }

        costoInstance.nivel = nivel

        return [costoInstance: costoInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        println "save_ajax: $params"
        def costoInstance = new Costo()
        if (params.id) {
            costoInstance = Costo.get(params.id)
            if (!costoInstance) {
                render "ERROR*No se encontró Costo."
                return
            }
        }
        costoInstance.properties = params
        costoInstance.estado = params.estado ?: 'A'

        if (!costoInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Costo: " + renderErrors(bean: costoInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Costo exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        println "delete_ajax, $params"
        def error = ""
        if (params.id) {
            def costo = Costo.get(params.id)
            if (!costo) {
                render "ERROR*No se encontró Costo."
                return
            }
            def hijos = DetalleConsultoria.findAllByCosto(costo)
            error += hijos? "Tiene referencia en Detalle de Costos (Presupuesto)" : ''
            hijos = PrecioCostos.findAllByCosto(costo)
            error += "Tiene referencia en Precios"
            if (hijos.size() == 0) {
                try {
                    costo.delete(flush: true)
                    render "SUCCESS*Eliminación de Costo exitosa."
                    return
                } catch (DataIntegrityViolationException e) {
                    render "ERROR*$error"
                    return
                }
            } else {
                render "ERROR*El costo tiene costos asociados, no puede eliminarlo"
            }
        } else {
            render "ERROR*No se encontró Costo."
            return
        }
    } //delete para eliminar via ajax

    def precio_ajax() {
        println "precio_ajax: $params"
        def costoInstance = new Costo()
        if (params.id) {
            costoInstance = Costo.get(params.padre)
            if (!costoInstance) {
                render "ERROR*No se encontró Costo."
                return
            }
        }
        costoInstance.properties = params
        def nivel = 1
        if (!params.id) {
            costoInstance.movimiento = 0
        } else {
            nivel = costoInstance.nivel
        }
        if (params.padre) {
            def padre = Costo.get(params.padre.toLong())
            nivel = padre.nivel + 1
            costoInstance.padre = padre
        }

        costoInstance.nivel = nivel

        return [costoInstance: costoInstance]
    } //form para cargar con ajax en un dialog

    def savePrecio_ajax() {
        println "savePrecio_ajax: $params"
        def precio = new PrecioCostos()
        if (params.id) {
            precio = PrecioCostos.get(params.id)
            if (!precio) {
                render "ERROR*No se encontró Costo."
                return
            }
        }
        precio.properties = params
        precio.estado = params.estado ?: 'N'

        if (!precio.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Costo: " + renderErrors(bean: costoInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Costo exitosa."
        return
    } //save para grabar desde ajax

    def tablaPrecio_ajax() {
        def cn = dbConnectionService.getConnection()
        def txto = "<table class='table table-bordered table-striped table-condensed table-hover'><tbody><tr>"
        def sql = "select p.prcsfcha, p.prcspcun from prcs p where p.prcsfcha = (select max(prcsfcha) from prcs " +
                "where prcs.csto__id = p.csto__id) and p.csto__id = ${params.id}"
        println "sql: $sql"
        def data = []
        cn.eachRow(sql.toString()) { d ->
            txto += "<td width='140px'>${d.prcsfcha}</td><td width='200px'>${d.prcspcun}</td>"
        }
        txto += "</tr></tbody></table>"
        println "txto: $txto"
        render txto
    }

}
