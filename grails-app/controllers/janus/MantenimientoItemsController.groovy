package janus

import janus.apus.ArchivoEspecificacion
import janus.pac.CodigoComprasPublicas

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Persona

import javax.imageio.ImageIO
import java.awt.image.BufferedImage

class MantenimientoItemsController {

    def preciosService
    def oferentesService
    def dbConnectionService

    def buscadorService

    def index() {
        redirect(action: "registro", params: params)
    } //index

    def precios () {
    }

    def loadTreePartPrecios_ajax() {
        render(arbolSearchPrecios_ajax(params))
    }

    def arbolSearchPrecios_ajax(params) {
        println "makeTreeNode.. $params"
        def id = params.id
        def tipo = ""
        def liId = ""
        def ico = ""

        if(id.contains("_")) {
            id = params.id.split("_")[1]
            tipo = params.id.split("_")[0]
        }

        if (!params.order) {
            params.order = "asc"
        }

        String tree = "", clase = "", rel = ""
        def padre
        def hijos = []

//        println "---> id: $id, tipo: $tipo, es #: ${id == '#'}"

        if (id == "#") {
            //root
//            def hh = Provincia.countByZonaIsNull()
            def hh = Provincia.count()
            if (hh > 0) {
                clase = "hasChildren jstree-closed"
            }

            tree = "<li id='root' class='root ${clase}' data-jstree='{\"type\":\"root\"}' data-level='0' >" +
                    "<a href='#' class='label_arbol'>Precios</a>" +
                    "</li>"
        } else {
//            println "---- no es raiz... procesa: $tipo"

            if(id == 'root'){
//                hijos = SubgrupoItems.findAll().sort{it.descripcion}
                hijos = Grupo.get(params.tipo)
                def data = ""
                ico = ", \"icon\":\"fa fa-parking text-success\""
                hijos.each { hijo ->
//                println "procesa ${hijo.nombre}"
//                    clase = SubgrupoItems.findAllByGrupo(hijo)
                    clase = SubgrupoItems.findByGrupo(hijo) ? "jstree-closed hasChildren" : "jstree-closed"

//                    tree += "<ul>"
                    tree += "<li id='prov_" + hijo.id + "' class='" + clase + "' ${data} data-jstree='{\"type\":\"${"principal"}\" ${ico}}' >"
                    tree += "<a href='#' class='label_arbol'>" + hijo?.descripcion + "</a>"
                    tree += "</li>"
                }
            }else{
                switch(tipo) {
                    case "prov":
                        hijos = SubgrupoItems.findAllByGrupo(Grupo.get(id), [sort: 'descripcion'])
//                        hijos = SubgrupoItems.findAllByGrupo(Grupo.get(id), [sort: params.sort])
                        liId = "cntn_"
//                    println "tipo: $tipo, ${hijos.size()}"
                        ico = ", \"icon\":\"fa fa-copyright text-info\""
                        hijos.each { h ->
//                        println "procesa $h"
                            clase = DepartamentoItem.findBySubgrupo(h)? "jstree-closed hasChildren" : ""
                            tree += "<li id='" + liId + h.id + "' class='" + clase + "' data-jstree='{\"type\":\"${"canton"}\" ${ico}}'>"
                            tree += "<a href='#' class='label_arbol'>" + h.descripcion + "</a>"
                            tree += "</li>"
                        }
                        break
                    case "cntn":
                        hijos = DepartamentoItem.findAllBySubgrupo(SubgrupoItems.get(id), [sort: params.sort])
                        liId = "parr_"
//                    println "tipo: $tipo, ${hijos.size()}"
                        ico = ", \"icon\":\"fa fa-registered text-danger\""
                        hijos.each { h ->
//                        println "procesa $h"
//                        clase = Comunidad.findByParroquia(h)? "jstree-closed hasChildren" : ""
                            clase = ""
                            tree += "<li id='" + liId + h.id + "' class='" + clase + "' data-jstree='{\"type\":\"${"parroquia"}\" ${ico}}'>"
                            tree += "<a href='#' class='label_arbol'>" + h.descripcion + "</a>"
                            tree += "</li>"
                        }
                        break
                    case "parr":
//                    hijos = Comunidad.findAllByParroquia(Parroquia.get(id), [sort: params.sort])
//                    liId = "cmnd_"
//                    ico = ", \"icon\":\"fa fa-info-circle text-warning\""
//                    hijos.each { h ->
//                        clase = ""
//                        tree += "<li id='" + liId + h.id + "' class='" + clase + "' data-jstree='{\"type\":\"${"comunidad"}\" ${ico}}'>"
//                        tree += "<a href='#' class='label_arbol'>" + h.nombre + "</a>"
//                        tree += "</li>"
//                    }
                        break
                }
            }
        }
        return tree
    }



    def makeTreeNode(params) {
//        println "makeTreeNode.. $params"
        def id = params.id
        def tipo = ""
        def liId = ""
        def ico = ""

        if(id.contains("_")) {
            id = params.id.split("_")[1]
            tipo = params.id.split("_")[0]
        }

        if (!params.order) {
            params.order = "asc"
        }

        String tree = "", clase = "", rel = ""
        def padre
        def hijos = []

        if (id == "#") {
            //root
            def hh = Grupo.get(params.tipo)
            if (hh) {
                clase = "hasChildren jstree-closed"
            }
            tree = "<li id='root' class='root ${clase}' data-jstree='{\"type\":\"root\"}' data-level='0' >" +
                    "<a href='#' class='label_arbol'></a>" +
                    "</li>"
        } else {
            if(id == 'root'){
                hijos = Grupo.get(params.tipo)
                def data = ""
                ico = ", \"icon\":\"fa fa-parking text-success\""
                hijos.each { hijo ->
                    clase = SubgrupoItems.findAllByGrupo(hijo) ? "jstree-closed hasChildren" : "jstree-closed"
                    tree += "<li id='gp_" + hijo.id + "' class='" + clase + "' ${data} data-tipo='${Grupo.get(params.tipo)?.id}' data-jstree='{\"type\":\"${"principal"}\" ${ico}}' >"
                    tree += "<a href='#' class='label_arbol'>" + hijo?.descripcion + "</a>"
                    tree += "</li>"
                }
            }else{
                switch(tipo) {
                    case "gp":
                        hijos = SubgrupoItems.findAllByGrupo(Grupo.get(id), [sort: 'codigo'])
                        liId = "sg_"
                        ico = ", \"icon\":\"fa fa-copyright text-info\""
                        hijos.each { h ->
                            clase = DepartamentoItem.findBySubgrupo(h) ? "jstree-closed hasChildren" : ""
                            tree += "<li id='" + liId + h.id + "' class='" + clase + "' data-tipo='${Grupo.get(params.tipo)?.id}' data-jstree='{\"type\":\"${"subgrupo"}\" ${ico}}'>"
                            tree += "<a href='#' class='label_arbol'>"  +  "<strong>" + "" + h?.codigo + " "  + "</strong>" +  h.descripcion + "</a>"
                            tree += "</li>"
                        }
                        break
                    case "sg":
                        hijos = DepartamentoItem.findAllBySubgrupo(SubgrupoItems.get(id), [sort: 'codigo'])
                        liId = "dp_"
                        ico = ", \"icon\":\"fa fa-registered text-danger\""
                        hijos.each { h ->
                            clase = Item.findByDepartamento(h)? "jstree-closed hasChildren" : ""
                            tree += "<li id='" + liId + h.id + "' class='" + clase + "'  data-tipo='${Grupo.get(params.tipo)?.id}' data-jstree='{\"type\":\"${"departamento"}\" ${ico}}'>"
                            if(Grupo.get(params.tipo)?.id == 2){
                                tree += "<a href='#' class='label_arbol'>" +  "<strong>"  + "" + h?.codigo + " " + "</strong>"  + h.descripcion + "</a>"
                            }else{
                                tree += "<a href='#' class='label_arbol'>" +  "<strong>"  + "" + h?.subgrupo?.codigo + "." +  h?.codigo + " " + "</strong>"  + h.descripcion + "</a>"
                            }
                            tree += "</li>"
                        }
                        break
                    case "dp":
                        hijos = Item.findAllByDepartamento(DepartamentoItem.get(id), [sort: 'codigo'])
                        liId = "it_"
                        ico = ", \"icon\":\"fa fa-info-circle text-warning\""
                        hijos.each { h ->
                            if(params.vae){
                                clase = VaeItems.findAllByItem(h)? "jstree-closed hasChildren" : ""
                            }else{
                                clase = ""
                            }
                            tree += "<li id='" + liId + h.id + "' class='" + clase + "' data-tipo='${Grupo.get(params.tipo)?.id}' data-jstree='{\"type\":\"${"item"}\" ${ico}}'>"
                            tree += "<a href='#' class='label_arbol'>" +  "<strong>" + "" + h?.codigo + " " + "</strong>" + h.nombre + "</a>"
                            tree += "</li>"
                        }
                        break

                    case "it":
                        hijos =  VaeItems.findAllByItem(Item.get(id),[max:1])
                        liId = "vae_"
                        ico = ", \"icon\":\"fa fa-info-circle text-info\""
                        hijos.each { h ->
                            clase = ""
                            tree += "<li id='" + liId + h.id + "' class='" + clase + "' data-tipo='${Grupo.get(params.tipo)?.id}' data-jstree='{\"type\":\"${"vae"}\" ${ico}}'>"
                            tree += "<a href='#' class='label_arbol'>" +  "<strong>" + "VAE" + "</strong>" + "</a>"
                            tree += "</li>"
                        }
                        break
                }
            }
        }
        return tree
    }

    /**
     * Acción llamada con ajax que permite realizar búsquedas en el árbol
     */
    def arbolSearch_ajax() {
        println "arbolSearch_ajax $params"
        def search = params.str.trim()
        if (search != "") {
            def c = Item.createCriteria()
            def find = c.list(params) {
                or {
                    ilike("nombre", "%" + search + "%")
                    departamento {
                        or {
                            ilike("descripcion", "%" + search + "%")
                        }
                    }
                }
            }
            def departamentos = []
            find.each { pers ->
                if (pers.departamento && !departamentos.contains(pers.departamento)) {
                    departamentos.add(pers.departamento)
                }
            }
            departamentos = departamentos.reverse()
            def ids = "["
            if (find.size() > 0) {
                ids += "\"#root\","
                departamentos.each { dp ->
                    ids += "\"#dp_" + dp.id + "\","
                }
                ids = ids[0..-2]
            }
            ids += "]"
            render ids
        } else {
            render ""
        }
    }

    def makeTreeNodePrecios(params) {
        println "makeTreeNode.. $params"
        def id = params.id
        def tipo = ""
        def liId = ""
        def ico = ""
        def icoTodos = ""

        if(id.contains("_")) {
            id = params.id.split("_")[1]
            tipo = params.id.split("_")[0]
        }

        if (!params.order) {
            params.order = "asc"
        }

        String tree = "", clase = "", rel = ""
        def padre
        def hijos = []

        if (id == "#") {
            //root
            def hh = Grupo.get(params.tipo)
            if (hh) {
                clase = "hasChildren jstree-closed"
            }
            tree = "<li id='root' class='root ${clase}' data-jstree='{\"type\":\"root\"}' data-level='0' >" +
                    "<a href='#' class='label_arbol'></a>" +
                    "</li>"
        } else {
            if(id == 'root'){
                hijos = Grupo.get(params.tipo)
                def data = ""
                ico = ", \"icon\":\"fa fa-parking text-success\""
                hijos.each { hijo ->
                    clase = SubgrupoItems.findAllByGrupo(hijo) ? "jstree-closed hasChildren" : "jstree-closed"
                    tree += "<li id='gp_" + hijo.id + "' class='" + clase + "' ${data} data-tipo='${Grupo.get(params.tipo)?.id}' data-jstree='{\"type\":\"${"principal"}\" ${ico}}' >"
                    tree += "<a href='#' class='label_arbol'>" + hijo?.descripcion + "</a>"
                    tree += "</li>"
                }
            }else{
                switch(tipo) {
                    case "gp":
                        hijos = SubgrupoItems.findAllByGrupo(Grupo.get(id), [sort: 'codigo'])
                        liId = "sg_"
                        ico = ", \"icon\":\"fa fa-copyright text-info\""
                        hijos.each { h ->
                            clase = DepartamentoItem.findBySubgrupo(h) ? "jstree-closed hasChildren" : ""
                            tree += "<li id='" + liId + h.id + "' class='" + clase + "' data-tipo='${Grupo.get(params.tipo)?.id}' data-jstree='{\"type\":\"${"subgrupo"}\" ${ico}}'>"
                            tree += "<a href='#' class='label_arbol'>"  +  "<strong>" + "" + h?.codigo + " "  + "</strong>" +  h.descripcion + "</a>"
                            tree += "</li>"
                        }
                        break
                    case "sg":
                        hijos = DepartamentoItem.findAllBySubgrupo(SubgrupoItems.get(id), [sort: 'codigo'])
                        liId = "dp_"
                        ico = ", \"icon\":\"fa fa-registered text-danger\""
                        hijos.each { h ->
                            clase = Item.findByDepartamento(h)? "jstree-closed hasChildren" : ""
                            tree += "<li id='" + liId + h.id + "' class='" + clase + "'  data-tipo='${Grupo.get(params.tipo)?.id}' data-jstree='{\"type\":\"${"departamento"}\" ${ico}}'>"
                            if(Grupo.get(params.tipo)?.id == 2){
                                tree += "<a href='#' class='label_arbol'>" +  "<strong>"  + "" + h?.codigo + " " + "</strong>"  + h.descripcion + "</a>"
                            }else{
                                tree += "<a href='#' class='label_arbol'>" +  "<strong>"  + "" + h?.subgrupo?.codigo + "." +  h?.codigo + " " + "</strong>"  + h.descripcion + "</a>"
                            }
                            tree += "</li>"
                        }
                        break
                    case "dp":
                        hijos = Item.findAllByDepartamento(DepartamentoItem.get(id), [sort: 'codigo'])
                        liId = "it_"
                        ico = ", \"icon\":\"fa fa-info-circle text-warning\""
                        hijos.each { h ->
                            clase = Lugar.findByTipoLista(h.tipoLista) ? "jstree-closed hasChildren" : ""
                            tree += "<li id='" + liId + h.id + "' class='" + clase + "' data-tipo='${Grupo.get(params.tipo)?.id}' data-jstree='{\"type\":\"${"item"}\" ${ico}}'>"
                            tree += "<a href='#' class='label_arbol'>" +  "<strong>" + "" + h?.codigo + " " + "</strong>" + h.nombre + "</a>"
                            tree += "</li>"
                        }
                        break
                    case "it":
                        hijos = Lugar.findAllByTipoLista(Item.get(id).tipoLista, [sort: 'codigo'])
                        liId = "lg_"
                        ico = ", \"icon\":\"fa fa-underline text-success\""
                        icoTodos = ", \"icon\":\"fa fa-map-marker-alt text-success\""
                        if(params.todos == 'true'){
                            tree += "<li id='" + liId + "all" + "_" + id + "' class='" + "" + "' data-tipo='${Grupo.get(params.tipo)?.id}' data-jstree='{\"type\":\"${"lugar"}\" ${icoTodos}}'>"
                            tree += "<a href='#' class='label_arbol'>" + "Todos los lugares" + "</a>"
                            tree += "</li>"
                        }else{
                            hijos.each { h ->
                                tree += "<li id='" + liId + h.id + "_" + id + "' class='" + "" + "' data-tipo='${Grupo.get(params.tipo)?.id}' data-jstree='{\"type\":\"${"lugar"}\" ${ico}}'>"
                                tree += "<a href='#' class='label_arbol'>" + h.descripcion + "</a>"
                                tree += "</li>"
                            }
                        }
                        break
                }
            }
        }
        return tree
    }


    //printlnborrar


//    String makeBasicTree(params) {
//        println "PARAMS  "+params
//
//        def usuario = Persona.get(session.usuario.id)
//        def id = params.id
//        def tipo = params.tipo
//        def precios = params.precios
//        def all = params.all ? params.all.toBoolean() : false
//        def ignore = params.ignore ? params.ignore.toBoolean() : false
//        def vae = params.vae
//
//        def hijos = []
//
//        switch (tipo) {
//            case "grupo_manoObra":
//            case "grupo_consultoria":
//                hijos = DepartamentoItem.findAllBySubgrupo(SubgrupoItems.get(id), [sort: 'codigo'])
//                break;
//            case "grupo_material":
//            case "grupo_equipo":
//                hijos = SubgrupoItems.findAllByGrupo(Grupo.get(id), [sort: 'codigo'])
//                break;
//            case "subgrupo_manoObra":
//            case "subgrupo_consultoria":
//                hijos = Item.findAllByDepartamento(DepartamentoItem.get(id), [sort: 'codigo'])
//                break;
//            case "subgrupo_material":
//            case "subgrupo_equipo":
//                hijos = DepartamentoItem.findAllBySubgrupo(SubgrupoItems.get(id), [sort: 'codigo'])
//                break;
//            case "departamento_manoObra":
//            case "departamento_consultoria":
//            case "departamento_material":
//            case "departamento_equipo":
//                hijos = Item.findAllByDepartamento(DepartamentoItem.get(id), [sort: 'codigo'])
//                break;
//            case "item_manoObra":
//            case "item_consultoria":
//            case "item_material":
//            case "item_equipo":
//                def tipoLista = Item.get(id).tipoLista
//                if (precios) {
//                    println "....2 tipoLista: ${tipoLista.id}"
//                    if (ignore) {
//                        hijos = ["Todos"]
//                    } else {
//                        hijos = []
//                        if (tipoLista) {
//                            hijos = Lugar.findAllByTipoListaAndTipo(tipoLista, 'B')
//                        }
//                    }
//                } else if(vae){
//                    hijos = VaeItems.findAllByItem(Item.get(params.id),[max:1])
//                }
//                break;
//        }
//
//        String tree = "", clase = "", rel = "", extra = ""
//
//        println "....3 hijos: ${hijos.size()}"
////        tree += "<ul>"
//        tree += "<li id='root' class='root hasChildren jstree-closed' data-jstree='{\"type\":\"root\"}' data-level='0' >" +
//                "<a href='#' class='label_arbol'>División Geográfica</a>" +
//                "</li>"
//
//
//        hijos.each { hijo ->
//            def hijosH, desc, liId
//            println "hijo ... "+tipo
//            switch (tipo) {
//                case "grupo_manoObra":
//                    hijosH = Item.findAllByDepartamento(hijo, [sort: 'codigo'])
//                    desc = hijo.codigo.toString().padLeft(3, '0') + " " + hijo.descripcion
//                    def parts = tipo.split("_")
//                    rel = "departamento_" + parts[1]
//                    liId = "dp" + "_" + hijo.id
//                    break;
//                case "grupo_material":
//                case "grupo_equipo":
//                    hijosH = DepartamentoItem.findAllBySubgrupo(hijo, [sort: 'codigo'])
//                    desc = hijo.codigo.toString().padLeft(3, '0') + " " + hijo.descripcion
//                    def parts = tipo.split("_")
//                    rel = "subgrupo_" + parts[1]
//                    liId = "sg" + "_" + hijo.id
//                    break;
//                case "subgrupo_manoObra":
//                    break;
//                case "subgrupo_material":
//                case "subgrupo_equipo":
//                    hijosH = Item.findAllByDepartamento(hijo, [sort: 'codigo'])
//                    desc = hijo.subgrupo.codigo.toString().padLeft(3, '0') + '.' + hijo.codigo.toString().padLeft(3, '0') + " " + hijo.descripcion
//                    def parts = tipo.split("_")
//                    rel = "departamento_" + parts[1]
//                    liId = "dp" + "_" + hijo.id
//                    break;
//                case "departamento_manoObra":
//                    hijosH = []
//                    def tipoLista = hijo.tipoLista
//                    if (precios) {
//                        if (ignore) {
//                            hijosH = ["Todos"]
//                        } else {
//                            if (tipoLista) {
//                                hijosH = Lugar.findAllByTipoLista(tipoLista)
//                            }
//                        }
//                    } else if(vae){
//                        hijosH = VaeItems.findAllByItem(hijo,[max:1])
//                    }
//                    desc = hijo.codigo + " " + hijo.nombre
//                    def parts = tipo.split("_")
//                    rel = "item_" + parts[1]
//                    liId = "it" + "_" + hijo.id
//                    break;
//                case "departamento_material":
//                case "departamento_equipo":
//                    hijosH = []
//                    def tipoLista = hijo.tipoLista
//                    if (precios) {
//                        if (ignore) {
//                            hijosH = ["Todos"]
//                        } else {
//                            if (tipoLista) {
//                                hijosH = Lugar.findAllByTipoLista(tipoLista)
//                            }
//                        }
//                    } else if(vae){
//                        hijosH = VaeItems.findAllByItem(hijo,[max:1])
//                    }
//                    desc = hijo.codigo + " " + hijo.nombre
//                    def parts = tipo.split("_")
//                    rel = "item_" + parts[1]
//                    liId = "it" + "_" + hijo.id
//                    break;
//                case "item_manoObra":
//                    hijosH = []
//                    if (precios) {
//                        hijosH = []
//                        if (ignore) {
//                            desc = "mo4  " + "Todos los lugares"
//                            rel = "lugar_all"
//                            liId = "lg_" + id + "_all"
//                        } else {
//                            if (all) {
//                                desc = hijo.descripcion + " (" + hijo.tipo + ")"
//                            } else {
//                                desc = hijo.descripcion
//                            }
//                            rel = "lugar"
//                            liId = "lg_" + id + "_" + hijo.id
//
//                            def obras = Obra.countByLugar(hijo)
//                            extra = "data-obras='${obras}'"
//                        }
//                    } else if(vae && hijo){
//                        hijosH = []
//                        desc = "VAE"
//                        rel = "vae"
//                        liId = "vae_"+id+"_"+hijo.id
//                    }
//                    break;
//                case "item_material":
//                case "item_equipo":
//                    println "....2"
//                    if (precios) {
//                        hijosH = []
//                        if (ignore) {
//                            desc = "Todos los lugares"
//                            rel = "lugar_all"
//                            liId = "lg_" + id + "_all"
//                        } else {
//                            if (all) {
//                                desc = hijo.descripcion + " (" + hijo.tipo + ")"
//                            } else {
//                                desc = hijo.descripcion
//                            }
//                            rel = "lugar"
//                            liId = "lg_" + id + "_" + hijo.id
//
//                            def obras = Obra.countByLugar(hijo)
//                            extra = "data-obras='${obras}'"
//                        }
//                    }  else if(vae){
//                        hijosH = []
//                        desc = "VAE"
//                        rel = "vae"
//                        liId = "vae_"+id+"_"+hijo.id
//                    }
//                    break;
//            }
//
//            if (!hijosH) {
//                hijosH = []
//            }
//            clase = (hijosH?.size() > 0) ? "jstree-closed hasChildren" : ""
//
//            tree += "<li id='" + liId + "' class='" + clase + "' rel='" + rel + "' " + extra + ">"
//            tree += "<a href='#' class='label_arbol'>" + desc + "</a>"
//            tree += "</li>"
//
////            println "hijos: ${hijos}, \n hijosH: ${hijosH}"
//        }
////        tree += "</ul>"
//
//        return tree
//    }

    String makeBasicTree_bck(params) {
//        println "PARAMS: "+params
        def id = params.id
        def tipo = params.tipo
        def precios = params.precios
        def all = params.all ? params.all.toBoolean() : false
        def ignore = params.ignore ? params.ignore.toBoolean() : false
        def vae = params.vae

//        println "all:" + all + "     ignore:" + ignore
//        println id
//        println tipo

        def hijos = []

        switch (tipo) {
            case "grupo_manoObra":
            case "grupo_consultoria":
//                hijos = SubgrupoItems.findAllByGrupo(Grupo.get(id), [sort: 'codigo'])[0].id
                hijos = DepartamentoItem.findAllBySubgrupo(SubgrupoItems.get(id), [sort: 'codigo'])
                break;
//            case "grupo_consultoria":
//                hijos = SubgrupoItems.findAllByGrupo(Grupo.get(id), [sort: 'codigo'])
//                if (hijos.size() == 2) {
//                    hijos = hijos[1].id
//                }
//                hijos = DepartamentoItem.findAllBySubgrutipoLispo(SubgrupoItems.get(hijos), [sort: 'codigo'])
//                break;
            case "grupo_material":
            case "grupo_equipo":
                hijos = SubgrupoItems.findAllByGrupo(Grupo.get(id), [sort: 'codigo'])
                break;
            case "subgrupo_manoObra":
            case "subgrupo_consultoria":
                hijos = Item.findAllByDepartamento(DepartamentoItem.get(id), [sort: 'codigo'])
//                println hijos.nombre
                break;
            case "subgrupo_material":
            case "subgrupo_equipo":
                hijos = DepartamentoItem.findAllBySubgrupo(SubgrupoItems.get(id), [sort: 'codigo'])
                break;
            case "departamento_manoObra":
            case "departamento_consultoria":
            case "departamento_material":
            case "departamento_equipo":
                hijos = Item.findAllByDepartamento(DepartamentoItem.get(id), [sort: 'codigo'])
                break;
            case "item_manoObra":
            case "item_consultoria":
            case "item_material":
            case "item_equipo":
                println "ITEMS vae "+vae+"   params="+params
                def tipoLista = Item.get(id).tipoLista
//                println(tipoLista)
//
//                println("id" + id)
//                println("item:" + Item.get(id))

                if (precios) {
                    if (ignore) {
                        hijos = ["Todos"]
                    } else {
                        hijos = []
                        if (tipoLista) {
                            hijos = Lugar.findAllByTipoLista(tipoLista)
                        }

//                        hijos = Lugar.list([sort: "descripcion"])
//                        hijos = Lugar.withCriteria {
//                            and {
//                                order("tipo", "asc")
//                                order("descripcion", "asc")
//                            }
//                        }
//                        if (all) {
//                            hijos = Lugar.withCriteria {
//                                and {
//                                    order("tipo", "asc")
//                                    order("descripcion", "asc")
//                                }
//                            }
//                        } else {
//                            hijos = Lugar.findAllByTipo("C", [sort: 'descripcion'])
//                            /*hijos = Lugar.findAll([sort: 'descripcion'])*/
//                        }
                    }
                } else if(vae){
                    hijos = [VaeItems.findByItem(Item.get(params.id))]
                }
                break;
        }

        String tree = "", clase = "", rel = "", extra = ""

        tree += "<ul>"
//        println "hijos:" + hijos
        hijos.each { hijo ->
            def hijosH, desc, liId
            switch (tipo) {
                case "grupo_manoObra":
//                    println("entro grupo")
                    hijosH = Item.findAllByDepartamento(hijo, [sort: 'codigo'])
                    desc = hijo.codigo.toString().padLeft(3, '0') + " " + hijo.descripcion
                    def parts = tipo.split("_")
                    rel = "departamento_" + parts[1]
                    liId = "dp" + "_" + hijo.id
                    break;
                case "grupo_material":
                case "grupo_equipo":
                    hijosH = DepartamentoItem.findAllBySubgrupo(hijo, [sort: 'codigo'])
                    desc = hijo.codigo.toString().padLeft(3, '0') + " " + hijo.descripcion
                    def parts = tipo.split("_")
                    rel = "subgrupo_" + parts[1]
                    liId = "sg" + "_" + hijo.id
                    break;
                case "subgrupo_manoObra":
//                    println("entro sub")

//                    hijosH = []
//
////                    hijosH = Item.findAllByDepartamento(hijo,[sort: 'codigo'])
//
//                    def tipoLista = hijo.tipoLista
//                    if (precios) {
//                        if (ignore) {
//                            hijosH = ["Todos"]
//                        } else {
//                            if (tipoLista) {
//                                hijosH = Lugar.findAllByTipoLista(tipoLista)
//                            }
//                        }
//                    }
//                    desc = "2 " + hijo.codigo + " " + hijo.nombre
//
//                    def parts = tipo.split("_")
//                    rel = "item_" + parts[1]
//                    liId = "it" + "_" + hijo.id
                    break;
                case "subgrupo_material":
                case "subgrupo_equipo":
                    hijosH = Item.findAllByDepartamento(hijo, [sort: 'codigo'])
                    desc = hijo.subgrupo.codigo.toString().padLeft(3, '0') + '.' + hijo.codigo.toString().padLeft(3, '0') + " " + hijo.descripcion
                    def parts = tipo.split("_")
                    rel = "departamento_" + parts[1]
                    liId = "dp" + "_" + hijo.id
                    break;
                case "departamento_manoObra":
                    //                    println("entro sub")

                    hijosH = []

//                    hijosH = Item.findAllByDepartamento(hijo,[sort: 'codigo'])

                    def tipoLista = hijo.tipoLista
                    if (precios) {
                        if (ignore) {
                            hijosH = ["Todos"]
                        } else {
                            if (tipoLista) {
                                hijosH = Lugar.findAllByTipoLista(tipoLista)
                            }
                        }
                    } else if(vae){
                        hijosH = [VaeItems.findByItem(hijo)]
                    }


                    desc = hijo.codigo + " " + hijo.nombre

                    def parts = tipo.split("_")
                    rel = "item_" + parts[1]
                    liId = "it" + "_" + hijo.id
//                    hijosH = []
//                    if (precios) {
//                        hijosH = []
//                        if (ignore) {
//                            desc = "Todos los lugares"
//                            rel = "lugar_all"
//                            liId = "lg_" + id + "_all"
//                        } else {
//
////                            println("entro")
//
//                            if (all) {
//                                desc = hijo.nombre + " (" + hijo.tipo + ")"
//                            } else {
//                                desc = hijo.nombre
//                            }
////                            rel = "lugar_" + hijo.tipo
//                            rel = "lugar"
//                            liId = "lg_" + id + "_" + hijo.id
//
//                            def obras = Obra.countByLugar(hijo)
////                            println "lugar " + hijo.tipo + " " + hijo.id + " " + hijo.descripcion + "    o: " + obras
//                            extra = "data-obras='${obras}'"
//
//                        }
//                    }
                    break;
                case "departamento_material":
                case "departamento_equipo":
                    hijosH = []

                    def tipoLista = hijo.tipoLista
                    if (precios) {
                        if (ignore) {
                            hijosH = ["Todos"]
                        } else {

                            if (tipoLista) {
                                hijosH = Lugar.findAllByTipoLista(tipoLista)
                            }
                        }
                    } else if(vae){
                        hijosH = VaeItems.findAllByItem(hijo)
                    }
                    desc = hijo.codigo + " " + hijo.nombre
                    def parts = tipo.split("_")
                    rel = "item_" + parts[1]
                    liId = "it" + "_" + hijo.id
                    break;
                case "item_manoObra":
//                    hijosH = []
//                    if (precios) {
//                        hijosH = []
//                        if (ignore) {
//                            desc = "mo4  " + "Todos los lugares"
//                            rel = "lugar_all"
//                            liId = "lg_" + id + "_all"
//                        } else {
//
////                            println("entro")
//
//                            if (all) {
//                                desc = hijo.descripcion + " (" + hijo.tipo + ")"
//                            } else {
//                                desc = hijo.descripcion
//                            }
////                            rel = "lugar_" + hijo.tipo
//                            rel = "lugar"
//                            liId = "lg_" + id + "_" + hijo.id
//
//                            def obras = Obra.countByLugar(hijo)
////                            println "lugar " + hijo.tipo + " " + hijo.id + " " + hijo.descripcion + "    o: " + obras
//                            extra = "data-obras='${obras}'"
//
//                        }
//                    }
                    if(vae && hijo){
                        hijosH = []
                        desc = "VAE"
                        rel = "vae"
                        liId = "vae_"+id+"_"+hijo.id
                    }
                    break;
                case "item_material":
                case "item_equipo":
                    println "AQUI hijo="+hijo
                    if (precios) {
                        hijosH = []
                        if (ignore) {
                            desc = "Todos los lugares"
                            rel = "lugar_all"
                            liId = "lg_" + id + "_all"
                        } else {

//                            println("entro")

                            if (all) {
                                desc = hijo.descripcion + " (" + hijo.tipo + ")"
                            } else {
                                desc = hijo.descripcion
                            }
//                            rel = "lugar_" + hijo.tipo
                            rel = "lugar"
                            liId = "lg_" + id + "_" + hijo.id

                            def obras = Obra.countByLugar(hijo)
//                            println "lugar " + hijo.tipo + " " + hijo.id + " " + hijo.descripcion + "    o: " + obras
                            extra = "data-obras='${obras}'"

                        }
                    }  else if(vae){
                        hijosH = []
                        desc = "VAE"
                        rel = "vae"
                        liId = "vae_"+id+"_"+hijo.id
                    }
                    break;
            }

            if (!hijosH) {
                hijosH = []
            }
            println "hijosH " + hijosH
            clase = (hijosH?.size() > 0) ? "jstree-closed hasChildren" : ""

            tree += "<li id='" + liId + "' class='" + clase + "' rel='" + rel + "' " + extra + ">"
            tree += "<a href='#' class='label_arbol'>" + desc + "</a>"
            tree += "</li>"
        }
        tree += "</ul>"
        return tree
    }

    def loadMO() {
        println "loadMO"
        def hijos = SubgrupoItems.findAllByGrupo(Grupo.get(2), [sort: 'codigo'])
        def html = ""
        def open = ""
        hijos.eachWithIndex { h, i ->
            def hijosH = DepartamentoItem.findAllBySubgrupo(h, [sort: 'codigo'])
            def cl = ""
            if (hijosH.size() > 0) {
                cl = "hasChildren jstree-closed"
                open = "manoObra_${h.id}"
            }
            html += "<li id='manoObra_${h.id}' class='root ${cl}' rel='grupo_manoObra'>"
            html += "<a href='#' class='label_arbol'>"
            html += h.descripcion
            html += "</a>"
            html += "</li>"
        }
        render html + "*" + open
    }

    def loadTreePart() {
        println "loadTreePart ----"
        render(makeBasicTree(params))
    }

    def loadTreePart_nuevo() {
        render(makeTreeNode(params))
    }

    def loadTreePart_precios() {
        render(makeTreeNodePrecios(params))
    }

    def searchTree_ajax() {
//        println params
//        def parts = params.search_string.split("~")
        def search = params.search.trim()
        if (search != "") {
            def id = params.tipo
            def find = Item.withCriteria {
                departamento {
                    subgrupo {
                        grupo {
                            eq("id", id.toLong())
                        }
                    }
                }
                ilike("nombre", "%" + search + "%")
            }
            def departamentos = [], subgrupos = [], grupos = []
            find.each { item ->
                if (!departamentos.contains(item.departamento))
                    departamentos.add(item.departamento)
                if (!subgrupos.contains(item.departamento.subgrupo))
                    subgrupos.add(item.departamento.subgrupo)
                if (!grupos.contains(item.departamento.subgrupo.grupo))
                    grupos.add(item.departamento.subgrupo.grupo)
            }

            def ids = "["

            if (find.size() > 0) {
                ids += "\"#materiales_1\","

                grupos.each { gr ->
                    ids += "\"#gr_" + gr.id + "\","
                }
                subgrupos.each { sg ->
                    ids += "\"#sg_" + sg.id + "\","
                }
                departamentos.each { dp ->
                    ids += "\"#dp_" + dp.id + "\","
                }
                ids = ids[0..-2]
            }
            ids += "]"
//            println ">>>>>>"
//            println ids
//            println "<<<<<<<"
            render ids
        } else {
            render ""
        }
    }

    def search_ajax() {
        def search = params.search.trim()
        def id = params.tipo
        def find = Item.withCriteria {
            departamento {
                subgrupo {
                    grupo {
                        eq("id", id.toLong())
                    }
                }
            }
            ilike("nombre", "%" + search + "%")
        }
        def json = "["
        find.each { item ->
            if (json != "[") {
                json += ","
            }
            json += "\"" + item.nombre + "\""
        }
        json += "]"
        render json
    }

    def registro() {
        //<!--grpo--><!--sbgr -> Grupo--><!--dprt -> Subgrupo--><!--item-->
        //materiales = 1
        //mano de obra = 2
        //equipo = 3
    }

    def moveNode_ajax() {
//        println params

        def node = params.node
        def newParent = params.newParent

        def parts = node.split("_")
        def tipoNode = parts[0]
        def idNode = parts[1]

        parts = newParent.split("_")
        def tipoParent = parts[0]
        def idParent = parts[1]

        switch (tipoNode) {
            case "it":
                def item = Item.get(idNode.toLong())
                def departamento = DepartamentoItem.get(idParent.toLong())
                item.departamento = departamento

                def cod = item.codigo
                def codItem = cod.split("\\.")[2]
//                println "codigo anterior: " + cod
                cod = "" + item.departamento.subgrupo.codigo.toString().padLeft(3, '0') + "." + item.departamento.codigo.toString().padLeft(3, '0') + "." + codItem.toString().padLeft(3, '0')
//                println "codigo nuevo: " + cod

                if (item.save(flush: true)) {
                    def tipo
                    def a
                    switch (item.departamento.subgrupo.grupoId) {
                        case 1:
                            tipo = "Material"
                            a = "o"
                            break;
                        case 2:
                            tipo = "Mano de obra"
                            a = "a"
                            break;
                        case 3:
                            tipo = "Equipo"
                            a = "o"
                            break;
                    }
                    render "OK_" + tipo + " movid" + a + " correctamente"
                } else {
                    render "NO_Ha ocurrid un error al mover"
                }
                break;
            case "dp":
                def departamento = DepartamentoItem.get(idNode.toLong())
                def subgrupo = SubgrupoItems.get(idParent.toLong())
                departamento.subgrupo = subgrupo
                if (departamento.save(flush: true)) {
                    render "OK_Subgrupo movido correctamente"
                } else {
                    render "NO_Ha ocurrid un error al mover"
                }
                break;
            default:
                render "NO"
                break;
        }
    }

    def loadLugarPorTipo() {
        params.tipo = params.tipo.toString().toUpperCase()
        def lugares = Lugar.findAllByTipo(params.tipo, [sort: 'descripcion'])
        def sel = g.select(name: "lugar", from: lugares, optionKey: "id", optionValue: {
            it.descripcion + ' (' + it.tipo + ')'
        })
        render sel
    }

    def reportePreciosUI() {
        def lugares = Lugar.list()
        def grupo = Grupo.get(params.grupo)
        return [lugares: lugares, grupo: grupo]
    }

    def showGr_ajax() {
        def grupoInstance = Grupo.get(params.id)
        return [grupoInstance: grupoInstance]
    }

    def showSg_ajax() {
        def subgrupoItemsInstance = SubgrupoItems.get(params.id)
        return [subgrupoItemsInstance: subgrupoItemsInstance]
    }

    def formSg_ajax() {
        def grupo = Grupo.get(params.grupo)
        def subgrupoItemsInstance

        if (params.id) {
            subgrupoItemsInstance = SubgrupoItems.get(params.id)
        }else{
            subgrupoItemsInstance = new SubgrupoItems()
        }
        return [grupo: grupo, subgrupoItemsInstance: subgrupoItemsInstance]
    }

    def checkDsSg_ajax() {

        if (params.descripcion) {
            params.descripcion = params.descripcion.toString().toUpperCase()
        }

        def grupo = Grupo.get(params.grupo)
        def subgrupos = SubgrupoItems.findAllByDescripcionAndGrupo(params.descripcion, grupo)
        if (params.id) {
            def subgrupo = SubgrupoItems.get(params.id)
            if (params.descripcion == subgrupo.descripcion) {
                render true
            } else {
                if (subgrupos.size() == 0) {
                    render true
                } else {
                    render false
                }
            }
        } else {
            if (subgrupos.size() == 0) {
                render true
            } else {
                render false
            }
        }
    }

    def checkCodigoGrupo_ajax() {

        def grupo = Grupo.get(params.grupo)
        def subgrupos = SubgrupoItems.findAllByCodigoAndGrupo(params.codigo, grupo)

        if (params.id) {
            def subgrupo = SubgrupoItems.get(params.id)
            if (params.codigo == subgrupo.codigo) {
                render true
            } else {
                if (subgrupos.size() == 0) {
                    render true
                } else {
                    render false
                }
            }
        } else {
            if (subgrupos.size() == 0) {
                render true
            } else {
                render false
            }
        }
    }

    def saveSg_ajax() {
        def subgrupo
        def grupo = Grupo.get(params.grupo)
        def existe = SubgrupoItems.findByGrupoAndCodigo(grupo, params.codigo)

        if (params.codigo) {
            params.codigo = params.codigo.toString().toUpperCase()
        }
        if (params.descripcion) {
            params.descripcion = params.descripcion.toString().toUpperCase()
        }

        if (params.id) {
            subgrupo = SubgrupoItems.get(params.id)

            if(existe?.id != subgrupo?.id){
                render "no_El código ingresado se encuentra duplicado"
                return
            }
        }else{
            if(existe){
                render "no_El código ingresado se encuentra duplicado"
                return
            }else{
                subgrupo = new SubgrupoItems()
            }
        }

        subgrupo.properties = params

        if (subgrupo.save(flush: true)) {
            render "ok_Grupo guardado correctamente"
        } else {
            println("error al guardar el grupo " + subgrupo.errors)
            render "no_Error al guardar el grupo"
        }
    }

    def deleteSg_ajax() {
        def subgrupo = SubgrupoItems.get(params.id)
        try {
            subgrupo.delete(flush: true)
            render "ok_Grupo borrado correctamente"
        }
        catch (DataIntegrityViolationException e) {
            println "Error al borrar el grupo " + subgrupo.errors
            render "no_Error al borrar el grupo"
        }
    }

    def showDp_ajax() {
        def departamentoItemInstance = DepartamentoItem.get(params.id)
        return [departamentoItemInstance: departamentoItemInstance]
    }

    def formDp_ajax() {
        def grupo = Grupo.get(params.grupo)
        def subgrupos = SubgrupoItems.findAllByGrupo(grupo, [sort: 'descripcion'])
        def departamentoItemInstance

        if (params.id) {
            departamentoItemInstance = DepartamentoItem.get(params.id)
        }else{
            departamentoItemInstance = new DepartamentoItem()
        }
        return [subgrupos: subgrupos, departamentoItemInstance: departamentoItemInstance, grupo: grupo]
    }

    def checkCdDp_ajax(id, codigo, subgrupoId) {

        def subgrupo = SubgrupoItems.get(subgrupoId)
        def departamentos = DepartamentoItem.findAllByCodigoAndSubgrupo(codigo, subgrupo)

        if (id) {
            def departamento = DepartamentoItem.get(id)

            if (codigo == departamento.codigo.toString()) {
                return true
            } else {
                return departamentos.size() == 0
            }
        } else {
            return departamentos.size() == 0
        }
    }

    def checkDsDp_ajax(id, descripcion, subgrupoId) {

        def subgrupo = SubgrupoItems.get(subgrupoId)
        def departamentos = DepartamentoItem.findAllByDescripcionAndSubgrupo(descripcion, subgrupo)

        if (id) {
            def departamento = DepartamentoItem.get(id)
            if (descripcion == departamento.descripcion) {
                return true
            } else {
                return departamentos.size() == 0
            }
        } else {
            return departamentos.size() == 0
        }
    }

    def saveDp_ajax() {

        def departamento

        if (params.codigo) {
            params.codigo = params.codigo.toString().toUpperCase()
        }
        if (params.descripcion) {
            params.descripcion = params.descripcion.toString().toUpperCase()
        }

        if (params.id) {
            departamento = DepartamentoItem.get(params.id)
            if(!checkCdDp_ajax(departamento?.id, params.codigo, params.subgrupo)){
                render "no_El código ingresado se encuentra duplicado"
                return
            }else{
                if(!checkDsDp_ajax(departamento?.id, params.descripcion, params.subgrupo)){
                    render "no_La descripción ingresada se encuentra duplicada"
                    return
                }
            }
        }else{
            departamento = new DepartamentoItem()
            if(!checkCdDp_ajax(null, params.codigo, params.subgrupo)){
                render "no_El código ingresado se encuentra duplicado"
                return
            }else{
                if(!checkDsDp_ajax(null, params.descripcion, params.subgrupo)){
                    render "no_La descripción ingresada se encuentra duplicada"
                    return
                }
            }
        }

        departamento.properties = params

        if (departamento.save(flush: true)) {
            render "ok_Subgrupo guardado correctamente"
        } else {
            println("error al guardar el subgrupo " + departamento.errors)
            render "no_Error al guardar el subgrupo"
        }

    }

    def deleteDp_ajax() {
        def departamento = DepartamentoItem.get(params.id)

        try {
            departamento.delete(flush: true)
            render "ok_Borrado correctamente"
        }
        catch (DataIntegrityViolationException e) {
            println "Error al borrar" + e
            render "no_Error al borrar"
        }
    }

    def showIt_ajax() {
        def itemInstance = Item.get(params.id)
        return [itemInstance: itemInstance]
    }

    def showPcun_ajax() {
        def itemInstance = Item.get(params.id)
        println "showPcun_ajax $params"
        def cn = dbConnectionService.getConnection()

        def sql = "select item.item__id, itemcdgo, itemnmbr, p.rbpcfcha, rbpcpcun,  rbpc__id, lgardscr,  p.lgar__id " +
                "from item, rbpc p, lgar where p.item__id = item.item__id and p.rbpcfcha = " +
                "(select max(rbpcfcha) " +
                "from rbpc r where r.item__id = p.item__id and r.lgar__id = p.lgar__id) and lgar.lgar__id = p.lgar__id and " +
                "item.item__id = ${params.id} " +
                "order by lgardscr"

        println("showPcun_ajax sql " + sql)
        def items = cn.rows(sql.toString());
        cn.close()

        return [data: items]
    }

//    def formIt_ajax() {
//
//        def departamento = DepartamentoItem.get(params.departamento)
//        def itemInstance = new Item()
//        if (params.id) {
//            itemInstance = Item.get(params.id)
//        }
//
//        def grupo = departamento.codigo.toString().padLeft(3, '0')
//        def subgrupo = departamento.subgrupo.codigo.toString().padLeft(3, '0')
//
////        def sql="select max(substr(itemcdgo, length(itemcdgo)-2,3)::integer+1) from item where itemcdgo ilike " +
//        def sql="select itemcdgo from item where itemcdgo ilike " +
//                "'${grupo.toString() + "." + subgrupo.toString() + ".%"}' "
//        println "sql: $sql"
//        def cn = dbConnectionService.getConnection()
//        def maximo = cn.rows(sql)[-1]
//
//        def grupoGeneral = departamento?.subgrupo?.grupo?.codigo
//
//        def campos = ["numero": ["Código", "string"], "descripcion": ["Descripción", "string"]]
//
//        return [departamento: departamento, itemInstance: itemInstance, grupo: params.grupo, campos: campos, maximo: maximo[0], grupoGeneral: grupoGeneral]
//    }

    def formIt_ajax() {

        def itemInstance
        def departamento = null
        def listaDepartamentos = []
        def grupo
        def subgrupos = SubgrupoItems.findAllByGrupo(Grupo.get(params.grupo))

        if (params.id) {
            itemInstance = Item.get(params.id)
            listaDepartamentos = DepartamentoItem.findAllById(itemInstance?.departamento?.id)
            grupo = itemInstance?.departamento?.subgrupo?.grupo?.id
        }else{
            itemInstance = new Item()

            if(params.departamento){
                departamento = DepartamentoItem.get(params.departamento)
                listaDepartamentos = DepartamentoItem.findAllById(departamento?.id)
            }else{
                listaDepartamentos = DepartamentoItem.findAllBySubgrupoInList(subgrupos, [sort: 'descripcion'])
            }

            grupo = Grupo.get(params.grupo)?.id
        }

        println("grupo " + grupo)

        return [itemInstance: itemInstance, grupo: grupo, departamento: departamento,
                listaDepartamentos: listaDepartamentos, subgrupos: subgrupos]
    }

    def buscaCpac() {
        println("params Cpac" + params)
        def listaTitulos = ["Código", "Descripción"]
        def listaCampos = ["numero", "descripcion"]
        def funciones = [null, null]
        def url = g.createLink(action: "buscaCpac", controller: "pac")
        def funcionJs = "function(){"
        funcionJs += '$("#modal-ccp").modal("hide");'
        funcionJs += '$("#item_cpac").val($(this).attr("regId"));$("#item_codigo").val($(this).attr("prop_numero"));$("#item_codigo").attr("title",$(this).attr("prop_descripcion"))'
        funcionJs += '}'
        def numRegistros = 20
        def extras = " and movimiento=1"
        if (!params.reporte) {
            if(params.excel){
//                println("entro")
                session.dominio = CodigoComprasPublicas
                session.funciones = funciones
                def anchos = [15, 50, 70, 20, 20, 20, 20]
                /*anchos para el set column view en excel (no son porcentajes)*/
                redirect(controller: "reportes", action: "reporteBuscadorExcel", params: [listaCampos: listaCampos, listaTitulos: listaTitulos, tabla: "CodigoComprasPublicas", orden: params.orden, ordenado: params.ordenado, criterios: params.criterios, operadores: params.operadores, campos: params.campos, titulo: "CodigoComprasPublicas", anchos: anchos, extras: extras, landscape: true])

            }else{
                def lista = buscadorService.buscar(CodigoComprasPublicas, "CodigoComprasPublicas", "excluyente", params, true, extras) /* Dominio, nombre del dominio , excluyente o incluyente ,params tal cual llegan de la interfaz del buscador, ignore case */
                lista.pop()
                render(view: '../tablaBuscadorColDer', model: [listaTitulos: listaTitulos, listaCampos: listaCampos, lista: lista, funciones: funciones, url: url, controller: "llamada", numRegistros: numRegistros, funcionJs: funcionJs])
            }
        } else {
//            println "entro reporte"
            /*De esto solo cambiar el dominio, el parametro tabla, el paramtero titulo y el tamaño de las columnas (anchos)*/
            session.dominio = CodigoComprasPublicas
            session.funciones = funciones
            def anchos = [20, 80] /*el ancho de las columnas en porcentajes... solo enteros*/
            redirect(controller: "reportes", action: "reporteBuscador", params: [listaCampos: listaCampos, listaTitulos: listaTitulos, tabla: "CodigoComprasPublicas", orden: params.orden, ordenado: params.ordenado, criterios: params.criterios, operadores: params.operadores, campos: params.campos, titulo: "Código compras publcias", anchos: anchos, extras: extras, landscape: false])
        }
    }


    def checkCdIt_ajax() {

        println("params cit " + params)

        def dep = DepartamentoItem.get(params.dep)

        if (dep.subgrupo.grupo.id != 2)
            params.codigo = dep.subgrupo.codigo.toString().padLeft(3, '0') + "." + dep.codigo.toString().padLeft(3, '0') + "." + params.codigo
        else
            params.codigo = dep.codigo.toString().padLeft(3, '0') + "." + params.codigo

        println("codigo " + params.codigo)

        if (params.id) {
            def item = Item.get(params.id)
            if (params.codigo.toString().trim() == item.codigo.toString().trim()) {
                render true
            } else {
                def items = Item.findAllByCodigo(params.codigo)
                if (items.size() == 0) {
                    render true
                } else {
                    render false
                }
            }
        } else {
            def items = Item.findAllByCodigo(params.codigo)
            if (items.size() == 0) {
                render true
            } else {
                render false
            }
        }
    }

    def checkNmIt_ajax() {
        def usuario = Persona.get(session.usuario.id)
//        def empresa = usuario.empresa
        if (params.id) {
            def item = Item.get(params.id)
            if (params.nombre == item.nombre) {
                render true
            } else {
                def items = Item.findAllByNombre(params.nombre)
                if (items.size() == 0) {
                    render true
                } else {
                    render false
                }
            }
        } else {
//            def items = Item.findAllByNombreAndEmpresa(params.nombre, empresa)
            def items = Item.findAllByNombre(params.nombre)
            if (items.size() == 0) {
                render true
            } else {
                render false
            }
        }
    }

    def checkCmIt_ajax() {
        if (params.id) {
            def item = Item.get(params.id)
            if (params.campo == item.campo) {
                render true
            } else {
                def items = Item.findAllByCampo(params.campo)
                if (items.size() == 0) {
                    render true
                } else {
                    render false
                }
            }
        } else {
            def items = Item.findAllByCampo(params.campo)
            if (items.size() == 0) {
                render true
            } else {
                render false
            }
        }
    }


    def infoItems() {
        def cn = dbConnectionService.getConnection()
        def item = Item.get(params.id)
        def precios = PrecioRubrosItems.findAllByItem(item)
        def fpItems = ItemsFormulaPolinomica.findAllByItem(item)
        def sql = "select r.itemcdgo, r.itemnmbr from item r, rbro " +
                "where rbro.item__id = ${params.id} and r.item__id = rbro.rbrocdgo and " +
                "r.itemcdgo like 'H%' order by r.itemcdgo"
//        println "sql: $sql"
        def rubro_hist = cn.rows(sql.toString())

        sql = "select r.itemcdgo, r.itemnmbr from item r, rbro " +
                "where rbro.item__id = ${params.id} and r.item__id = rbro.rbrocdgo and " +
                "r.itemcdgo not like 'H%' order by r.itemcdgo"
        def rubro = cn.rows(sql.toString())
//        println "rh: ${rubro_hist}"
        return [item: item, rubro: rubro, precios: precios, fpItems: fpItems, delete: params.delete,
                rubrosHist: rubro_hist]
    }

    def copiarOferentes() {
        def item = Item.get(params.id)
        def res=null
        res = oferentesService.exportDominio(janus.Item, "itemjnid", item, null, "ofrt__id",null, "ofrt__id","select * from item where itemcdgo='${item.codigo}'")

//        render "NO_Ha ocurrido un error"
        if(res)
            render "OK"
        else
            render "NO_Ha ocurrido un error"
    }

    def saveIt_ajax() {
//        println 'SAVE ITEM: ' + params
        def item
        def persona = Persona.get(session.usuario.id)
        def dep = DepartamentoItem.get(params.departamento)
        params.tipoItem = TipoItem.findByCodigo("I")
        params.fechaModificacion = new Date()
        params.nombre = params.nombre.toString().toUpperCase()
        params.campo = params.campo.toString().toUpperCase()
        params.observaciones = params.observaciones.toString().toUpperCase()
        params.codigo = params.codigo.toString().toUpperCase()
        params.peso = params.peso.toDouble()
        params.transporteValor = params.transporteValor.toDouble()
        params.codigoComprasPublicas = CodigoComprasPublicas.get(params.codigoComprasPublicas)
        if (!params.id) {
            if (!params.codigo.contains(".")) {
                if (dep.subgrupo.grupoId == 2) {
                    params.codigo = dep.codigo.toString().padLeft(3, '0') + "." + params.codigo
                } else {
                    params.codigo = dep.subgrupo.codigo.toString().padLeft(3, '0') + "." + dep.codigo.toString().padLeft(3, '0') + "." + params.codigo
                }
            }
        } else {
            params.remove("codigo")
        }
        if (params.fecha) {
            params.fecha = new Date().parse("dd-MM-yyyy", params.fecha)
        } else {
            params.fecha = new Date()
        }

        if (!params.tipoLista) {
            params.tipoLista = TipoLista.get(6)
        }

        if (params.id) {
            item = Item.get(params.id)
        }else{
            item = new Item()
        }

        item.properties = params

        if (item.save(flush: true)) {
            render "ok_Item guardado correctamente_" + item?.departamento?.id
        }else {
            println "Error al guardar el item" + item.errors
            render "no_Error al guardar el item"
        }
    }

    def verificaBorrado_ajax(){
        def item = Item.get(params.id)
        def rubros = Rubro.findAllByItem(item)
        def volumenes = []

        rubros.each {
            if(VolumenesObra.findByItem(it.rubro)){
                volumenes +=VolumenesObra.findByItem(it.rubro)
            }
        }

        volumenes.unique{it?.obra?.nombre}

        if(volumenes.size()>0) {
            render "ok"
        }else{
            render "no"
        }
    }

    def rubrosUsados_ajax(){

        def item = Item.get(params.id)
        def rubros = Rubro.findAllByItem(item)
        def volumenes = []

        rubros.each {
            if(VolumenesObra.findByItem(it.rubro)){
                volumenes +=VolumenesObra.findByItem(it.rubro)
            }
        }

        volumenes.unique{it?.obra?.nombre}

        return [volumenes: volumenes]
    }

    def deleteIt_ajax() {
        def item = Item.get(params.id)
        def id = item.departamento.id

        try {
            item.delete(flush: true)
            render "ok_Borrado correctamente_" + id
        }
        catch (DataIntegrityViolationException e) {
            println "Error al borrar " + item.errors
            render "no_Error al borrar"
        }
    }

    def formPrecio_ajax() {
        println "formPrecio_ajax" + params

        def fd = new Date().parse("dd-MM-yyyy", params.fd)

        def precioRubrosItemsInstance
        def lugar

        if(params.id){
            precioRubrosItemsInstance = PrecioRubrosItems.get(params.id)
            lugar = precioRubrosItemsInstance?.lugar
        }else{
            precioRubrosItemsInstance = new PrecioRubrosItems()
            def item = Item.get(params.item)
            lugar = Lugar.get(params.lugar)
            precioRubrosItemsInstance.item = item
            precioRubrosItemsInstance.lugar = lugar
        }

        return [precioRubrosItemsInstance: precioRubrosItemsInstance, lugar: lugar, fecha: params.fecha, params: params, fd: fd, all: params.all]
    }

    def formPreciosLugares_ajax() {
        println("form precios " + params)
        def item = Item.get(params.item)
        def fd = new Date().parse("dd-MM-yyyy", params.fd)
        def lugares = Lugar.findAllByTipoLista(item.tipoLista, [sort: 'codigo'])

        def precioRubrosItemsInstance
        def lugar

        if(params.id){
            precioRubrosItemsInstance = PrecioRubrosItems.get(params.id)
            lugar = precioRubrosItemsInstance?.lugar
        }else{
            precioRubrosItemsInstance = new PrecioRubrosItems()

            lugar = Lugar.get(params.lugar)
            precioRubrosItemsInstance.item = item
            precioRubrosItemsInstance.lugar = lugar
        }

        return [precioRubrosItemsInstance: precioRubrosItemsInstance, lugar: lugar, fecha: params.fecha, params: params, fd: fd, all: params.all, lugares: lugares]
    }

    def checkFcPr_ajax() {
//        println params
        if (!params.lugar) {
            render true
        } else {
            def precios = PrecioRubrosItems.withCriteria {
                and {
                    eq("lugar", Lugar.get(params.lugar))
                    eq("fecha", new Date().parse("dd-MM-yyyy", params.fecha))
                    eq("item", Item.get(params.item))
                }
            }
            if (precios.size() == 0) {
                render true
            } else {
                render false
            }
        }
    }

    def savePrecio_ajax() {
        println "savePrecio_ajax $params"
        def item = Item.get(params.item.id)
        params.fecha = new Date().parse("dd-MM-yyyy", params.fecha)

        if(params.id){
            def precioRubrosItemsInstance = PrecioRubrosItems.get(params.id)
            precioRubrosItemsInstance.precioUnitario = params.precioUnitario.toDouble()

            if(!precioRubrosItemsInstance.save(flush:true)){
                println("error al guardar el precio " + precioRubrosItemsInstance)
                render "NO_Error al guardar el precio"
            }else{
                render "OK_Precio guardado correctamente"
            }
        }else{
            if(params.all){
                def error = 0
                Lugar.findAllByTipoLista(item.tipoLista).each { lugar ->
//                    def precios = PrecioRubrosItems.withCriteria {
//                        and {
//                            eq("lugar", lugar)
//                            eq("fecha", params.fecha)
//                            eq("item", item)
//                        }
//                    }


                    def existe = PrecioRubrosItems.findByItemAndFechaAndLugar(item, params.fecha, lugar)

                    if(existe){
                        error ++
                    }else{
                        def precioRubrosItemsInstance = new PrecioRubrosItems()
                        precioRubrosItemsInstance.precioUnitario = params.precioUnitario.toDouble()
                        precioRubrosItemsInstance.lugar = lugar
                        precioRubrosItemsInstance.item = Item.get(params.item.id)
                        precioRubrosItemsInstance.fecha = params.fecha

                        if (!precioRubrosItemsInstance.save(flush: true)) {
                            println "mantenimiento items controller l 873: " + precioRubrosItemsInstance.errors
                            error++
                        } else {

                        }
                    }
                }

                if (error == 0) {
                    render "OK_Precio guardado correctamente"
                } else {
                    render "NO_Error al guardar el precio"
                }
            }else{
                def lugar = Lugar.get(params."lugar.id")
                def existe = PrecioRubrosItems.findByItemAndFechaAndLugar(item, params.fecha, lugar)

                if(existe){
                    render "NO_Ya existe un precio para esta fecha"
                }else{
                    def precioRubrosItemsInstance = new PrecioRubrosItems(params)
                    precioRubrosItemsInstance.precioUnitario = params.precioUnitario.toDouble()
                    if (!precioRubrosItemsInstance.save(flush: true)) {
                        println "mantenimiento items controller l 846: " + precioRubrosItemsInstance.errors
                        render "NO_Error al guardar el precio"
                    } else {
                        render "OK_Precio guardado correctamente"
                    }
                }
            }

//            if (params.lugar.id != "-1") {
//                def precioRubrosItemsInstance = new PrecioRubrosItems(params)
//                precioRubrosItemsInstance.precioUnitario = params.precioUnitario.toDouble()
//                if (precioRubrosItemsInstance.save(flush: true)) {
//                    render "OK_Precio guardado correctamente"
//                } else {
//                    println "mantenimiento items controller l 846: " + precioRubrosItemsInstance.errors
//                    render "NO_Error al guardar el precio"
//                }
//            } else {
//                println("entro ")
//
//                def error = 0
//                Lugar.findAllByTipoLista(item.tipoLista).each { lugar ->
//                    def precios = PrecioRubrosItems.withCriteria {
//                        and {
//                            eq("lugar", lugar)
//                            eq("fecha", params.fecha)
//                            eq("item", item)
//                        }
//                    }
//                    if (precios.size() == 0) {
//                        def precioRubrosItemsInstance = new PrecioRubrosItems()
//                        precioRubrosItemsInstance.precioUnitario = params.precioUnitario.toDouble()
//                        precioRubrosItemsInstance.lugar = lugar
//                        precioRubrosItemsInstance.item = Item.get(params.item.id)
//                        precioRubrosItemsInstance.fecha = params.fecha
//                        if (precioRubrosItemsInstance.save(flush: true)) {
//                        } else {
//                            println "mantenimiento items controller l 873: " + precioRubrosItemsInstance.errors
//                            error++
//                        }
//                    }
//                }
//                if (error == 0) {
//                    render "OK_Precio guardado correctamente"
//                } else {
//                    render "NO_Error al guardar el precio"
//                }
//            }
        }
    }

    def deletePrecio_ajax() {
//        println("params borrar " + params)
        def rubroPrecioInstance = PrecioRubrosItems.get(params.id);
        def errores = false
        if (params.auto) {
            def usu = Persona.get(session.usuario.id)
            if (params.auto.toString().encodeAsMD5() != usu.autorizacion) {
                errores = true
            }else{
                errores = false
            }
        }

        if(errores){
            render "no_Error con con el ingreso de la autorización"
        }else{
            try {
                rubroPrecioInstance.delete(flush: true)
                render "OK_Precio borrado correctamente"
            }
            catch (DataIntegrityViolationException e) {
                println "mantenimiento items controller l 903: " + e
                render "Error al eliminar el precio."
            }
        }
    }

    def calcPrecEq() {
        def anio = new Date().format("yyyy").toInteger()
        def item = Item.get(params.item.toLong())
        def valoresAnuales = ValoresAnuales.findByAnio(anio)
        return [item: item, valoresAnuales: valoresAnuales]
    }

    def calcPrecioRef_ajax() {
        def precioRef = 0
        try{
            precioRef = formatNumber(number: calcPrecioRef(params.precio.toDouble()), maxFractionDigits: 5, minFractionDigits: 5)
        }catch(e){
            println("error " + e)
            precioRef = "error"
        }
        render precioRef
    }

    def calcPrecioRef(precioAnt) {

        def anio = new Date().format("yyyy").toInteger()
//        def sbuAct = ValoresAnuales.findByAnio(anio).sueldoBasicoUnificado
//        def sbuAnt = ValoresAnuales.findByAnio(anio - 1).sueldoBasicoUnificado
//
//        def delta = sbuAct / sbuAnt
//        def nuevoCosto = precioAnt * delta

//        println precioAnt + " " + anio + " " + sbuAct + " " + sbuAnt + " " + delta + " " + nuevoCosto

        def u = ValoresAnuales.findByAnio(anio)?.sueldoBasicoUnificado
        def b = precioAnt
        def ap = b * 12 * 0.1215
//        ap = new DecimalFormat("#.##").format(ap).toDouble()
        def ta = 14 * b + u + ap
        def jr = ta / 235

        def nuevoCosto = jr / 8
//        nuevoCosto = new DecimalFormat("#.##").format(nuevoCosto).toDouble()
        nuevoCosto = nuevoCosto.toDouble()

        return nuevoCosto
    }

    def calcPrecio(params) {
        println ">>" + params
//        println params.fecha
//        println params.fecha.class

        def lugar = []
        def precios = []
        def precioRef = false
        def fecha = params.fecha

        if (params.fecha == "all") {
            params.todasLasFechas = "true"
        } else {
            params.todasLasFechas = "false"
            params.fecha = new Date()/*.parse("dd-MM-yyyy", fecha)*/
        }
        if (params.todasLasFechas == "true") {
            fecha = null
        }

        if (params.lugarId == "all") {
            def item = Item.get(params.itemId)
            def tipoLista = item.tipoLista
            lugar = Lugar.findAllByTipoLista(tipoLista, [sort: "descripcion"])
        } else {
            lugar.add(Lugar.get(params.lugarId))
        }

        println ">>> " + fecha + "   " + params.itemId + "    " + params.operador + " lugar: " + lugar
        lugar.each {
            def tmp = preciosService.getPrecioRubroItemOperador(fecha, it, params.itemId, params.operador)
            if (tmp.size() > 0)
                precios += tmp
        }
        def res = []
        precios.each {
            res.add(PrecioRubrosItems.get(it))
        }
        precios = res

        def anio = new Date().format("yyyy").toInteger()
        def anioRef = anio - 1
        def precioActual = precios.findAll {
            it.fecha >= new Date().parse("dd-MM-yyyy", "01-01-${anio}") && it.fecha <= new Date().parse("dd-MM-yyyy", "31-12-${anio}")
        }
        precioActual = precioActual.sort { it.fecha }
        if (precioActual) {
            def newest = precioActual[precioActual.size() - 1]
//            println "Precio ${anio} al " + newest.fecha + " " + newest.precioUnitario + ": se muestra este?"
            precioRef = newest.precioUnitario
        } else {
//            println "no hay precio de este anio (${anio})"
            def precioAnterior = precios.findAll {
                it.fecha >= new Date().parse("dd-MM-yyyy", "01-01-${anioRef}") && it.fecha <= new Date().parse("dd-MM-yyyy", "31-12-${anioRef}")
            }
            if (precioAnterior) {
                def newest = precioAnterior[precioAnterior.size() - 1]
//                println "Precio ${anioRef} al " + newest.fecha + " " + newest.precioUnitario + ": se calcula"

//                def sbuAct = ValoresAnuales.findByAnio(anio).sueldoBasicoUnificado
//                def sbuAnt = ValoresAnuales.findByAnio(anioRef).sueldoBasicoUnificado
//
//                def delta = sbuAct / sbuAnt
//                def nuevoCosto = newest.precioUnitario * delta
//                precioRef = nuevoCosto
                precioRef = calcPrecioRef(newest.precioUnitario)
            } else {
//                println "no hay precio del anio pasado (${anioRef}): hay q pedir"
            }
        }

        return [precios: precios, precioRef: precioRef, anioRef: anioRef]
    }

    def showLg_ajax() {
        println "showLg_ajax... params: $params"

        def tipo = params.tipo

        if (params.fecha == "all") {
            params.todasLasFechas = "true"
        } else {
            params.todasLasFechas = "false"
            params.fecha = new Date().parse("dd-MM-yyyy", params.fecha)
        }

        def item = Item.get(params.item)
        def lugar = Lugar.get(params.id)
        def operador = params.operador
        def fecha = params.fecha
        def lugarNombre

        if (params.todasLasFechas == "true") {
            fecha = null
        }

        def tipoLista
        if(lugar) {
            tipoLista = lugar.tipoLista
        } else {
            tipoLista = item.tipoLista
        }

        if (params.id == "all") {
            lugarNombre = "todos los lugares"
        } else {
            lugarNombre = lugar?.descripcion?:'' + " (" + (tipoLista ? tipoLista?.descripcion : 'sin tipo') + ")"
        }

        def r = calcPrecio([
//                lugarId: lugarId,
lugarId: lugar?.id ?: 'all',
fecha: params.fecha,
//                operador: '=',
operador: operador,
//                todasLasFechas: params.todasLasFechas,
todasLasFechas: false,
//                itemId: itemId
itemId: item.id
        ])


//        return [item: item, lugarNombre: lugarNombre, lugarId: lugarId, precios: r.precios, lgar: lugarId == "all", fecha: operador == "=" ? fecha.format("dd-MM-yyyy") : null,
//                params: params, precioRef: r.precioRef, anioRef: r.anioRef]

        return [item: item, lugarNombre: lugarNombre, lugarId: lugar?.id ?: 'all', precios: r.precios, lgar: params.id == "all", fecha: operador == "=" ? fecha.format("dd-MM-yyyy") : null,
                params: params, precioRef: r.precioRef, anioRef: r.anioRef, lugar: lugar, tipo: tipo]

//        return [item: item, lugarNombre: lugarNombre, lugarId: lugar.id, precios: r.precios, lgar: false, fecha: operador == "=" ? fecha.format("dd-MM-yyyy") : null,
//                params: params, precioRef: r.precioRef, anioRef: r.anioRef]
    }

    def formLg_ajax() {
        def lugarInstance = new Lugar()
        def tipo = "C"
        if (params.id) {
            lugarInstance = Lugar.get(params.id)
            tipo = lugarInstance.tipo
        }
        def codigos = []

        def sql

        sql = "select lgarcdgo from lgar "
        sql += "order by lgarcdgo"

        def cn = dbConnectionService.getConnection()

        cn.eachRow(sql.toString()) {row->
            codigos += row[0]
        }
        cn.close()
        def ultimo = codigos.last()

        return [lugarInstance: lugarInstance, all: params.all, tipo: tipo, ultimo: ultimo, id: params.id]
    }


    def formLge_ajax() {


        def lugarInstance = new Lugar()
        def tipo = "C"
        if (params.id) {
            lugarInstance = Lugar.get(params.id)
            tipo = lugarInstance.tipo
        }

        return [lugarInstance: lugarInstance, all: params.all, tipo: tipo]


    }

    def checkCdLg_ajax() {
        if (params.id) {
            def lugar = Lugar.get(params.id)
            if (params.codigo.toString().trim() == lugar.codigo.toString().trim()) {
                render true
            } else {
                def lugares = Lugar.findAllByCodigo(params.codigo)
                if (lugares.size() == 0) {
                    render true
                } else {
                    render false
                }
            }
        } else {
            def lugares = Lugar.findAllByCodigo(params.codigo)
            if (lugares.size() == 0) {
                render true
            } else {
                render false
            }
        }
    }

    def checkDsLg_ajax() {
        if (params.id) {
            def lugar = Lugar.get(params.id)
            if (params.descripcion == lugar.descripcion) {
                render true
            } else {
                def lugares = Lugar.findAllByDescripcion(params.descripcion)
                if (lugares.size() == 0) {
                    render true
                } else {
                    render false
                }
            }
        } else {
            def lugares = Lugar.findAllByDescripcion(params.descripcion)
            if (lugares.size() == 0) {
                render true
            } else {
                render false
            }
        }
    }

    def saveLg_ajax() {
        def usuario = Persona.get(session.usuario.id)
//        def empresa = usuario.empresa
        def accion = "create"
        def lugar = new Lugar()
        params.descripcion = params.descripcion.toString().toUpperCase()
        if (params.id) {
            lugar = Lugar.get(params.id)
            accion = "edit"
        }
        lugar.properties = params
//        lugar.empresa = empresa

        if (lugar.save(flush: true)) {
            render "OK_" + accion + "_" + lugar.id + "_" + (lugar.descripcion + (params.all.toString().toBoolean() ? " (" + lugar.tipo + ")" : "")) + "_c"
        } else {
            println "mantenimiento items controller l 1158: " + lugar.errors
            def errores = g.renderErrors(bean: lugar)
            render "NO_" + errores
        }
    }

    def deleteLg_ajax() {
//        println "DELETE LUGAR "
//        println params
        def lugar = Lugar.get(params.id)

        def seUsa = Obra.countByListaPeso1(lugar)
        seUsa += Obra.countByListaVolumen0(lugar)
        seUsa += Obra.countByListaVolumen1(lugar)
        seUsa += Obra.countByListaVolumen2(lugar)
        seUsa += Obra.countByListaManoObra(lugar)

//        println "esta lis si se usa... $seUsa"
        if (seUsa > 0) {
//            render "NO_No esposible borrar la lista, ya está utilizada en Obras"
            render "NO_No esposible borrar la lista, ya está utilizada en Obras"
        } else {

            def precios = PrecioRubrosItems.findAllByLugar(lugar)
            def cant = 0
            precios.each { p ->
                try {
                    p.delete(flush: true)
//                println "p deleted " + p.id
                    cant++
                } catch (DataIntegrityViolationException e) {
                    println "mantenimiento items controller l 1177: " + e
                    println "\tp not deleted " + p.id
                }
            }

            try {
                lugar.delete(flush: true)
                render "OK"
            } catch (DataIntegrityViolationException e) {
                println "mantenimiento items controller l 1186: " + e
                render "NO"
            }
        }
    }

    def vae() {
        //<!--grpo--><!--sbgr -> Grupo--><!--dprt -> Subgrupo--><!--item-->
        //materiales = 1
        //mano de obra = 2
        //equipo = 3
    }

    def showVa_ajax() {
        def vaeItem = VaeItems.get(params.id)
        def item = vaeItem.item
        def vaeItems = VaeItems.findAllByItem(item, [sort: 'fecha'])
        return [params:params, item:item, vaeItems: vaeItems]
    }

    def formVa_ajax() {
//        println " vae: " + params

        def fd
        if(params.fechaDefecto){
            fd = new Date().parse("dd-MM-yyyy", params.fechaDefecto)
        }else{
            fd = new Date()
        }

        def vaeInstance = new VaeItems()
        if (params.fechaVae)
            vaeInstance.fecha = new Date().parse("dd-MM-yyyy", params.fechaVae)
        def itemInstance = Item.get(params.item)
        if (params.id) {
            vaeInstance = VaeItems.get(params.id)
        }

        return [vaeInstance: vaeInstance, itemInstance: itemInstance, item: params.item, fd: fd]
    }

    def saveVa_ajax() {
        println ("saveVae_ajax" +  params)

        def vaeItem

        if (params.fecha){
            params.fecha = new Date().parse("dd-MM-yyyy", params.fecha)
        }

        params.porcentaje = params.porcentaje.toDouble()

        if(params.id){
            vaeItem = VaeItems.get(params.id)
        }else{
            vaeItem = new VaeItems()
            params.fechaIngreso = new Date()
            vaeItem.item = Item.get(params.item)
        }

        vaeItem.properties = params

        try{
            vaeItem.save(flush:true)
            render "ok_Guardado correctamente"
        }catch(e){
            println("error al guardar el valor del vae" + vaeItem.errors)
            render "no_Error al guardar el valor del vae"
        }

    }

    def actualizarVae_ajax() {
        if (params.item instanceof java.lang.String) {
            params.item = [params.item]
        }

        def oks = "", nos = ""

        params.item.each {
            def parts = it.split("_")

//            println "actualiza vae, parts:" + parts

            def id_itva = parts[0]
            def nuevoVae = parts[1]

            def vaeItems = VaeItems.get(id_itva);
            vaeItems.porcentaje = nuevoVae.toDouble();
//            println "nuevo vae: " + vaeItems.porcentaje

            if (!vaeItems.save(flush: true)) {
                println "mantenimiento items controller l 928: " + "error " + parts
                if (nos != "") {
                    nos += ","
                }
                nos += "#" + id_itva
            } else {
                if (oks != "") {
                    oks += ","
                }
                oks += "#" + id_itva
            }

        }
        render oks + "_" + nos
    }

    def deleteVae_ajax() {
//        println "delete vae..."  + params
        def ok = true
        if (params.auto) {
            def usu = Persona.get(session.usuario.id)
            if (params.auto.toString().encodeAsMD5() != usu.autorizacion) {
                ok = false
                render "no_Ha ocurrido un error en la autorización."
            }
        }
        if (ok) {
            try {
                def vaeItems = VaeItems.get(params.id);
                vaeItems.delete(flush: true)
                render "ok_Borrado correctamente"
            }
            catch (DataIntegrityViolationException e) {
                println ("error al borrar el vae " + e)
                render "no_No se pudo eliminar el vae."
            }
        }
    }

    def buscadorCPC(){
        def listaItems = [1: 'Descripción', 2: 'Código']
        return  [listaItems: listaItems, tipo: params.tipo]
    }

    def tablaCPC(){
        println("params " + params)
        def datos;
        def sqlTx = ""
        def listaItems = ['cpacdscr', 'cpacnmro']
        def bsca
        if(params.buscarPor){
            bsca = listaItems[params.buscarPor?.toInteger()-1]
        }else{
            bsca = listaItems[0]
        }

        def select = "select * from cpac"
        def txwh = " where $bsca ilike '%${params.criterio}%'"
        sqlTx = "${select} ${txwh} order by cpacdscr limit 30 ".toString()

        def cn = dbConnectionService.getConnection()
        datos = cn.rows(sqlTx)
        cn.close()
        [data: datos, tipo: params.tipo]
    }

    def buscadorCPCTransporte_ajax(){
        def listaItems = [1: 'Descripción', 2: 'Código']
        return  [listaItems: listaItems, tipo: params.tipo]
    }

    def tablaCPCTransporte_ajax(){
        println("params " + params)
        def datos;
        def sqlTx = ""
        def listaItems = ['cpacdscr', 'cpacnmro']
        def bsca
        if(params.buscarPor){
            bsca = listaItems[params.buscarPor?.toInteger()-1]
        }else{
            bsca = listaItems[0]
        }

        def select = "select * from cpac "
        def txwh = " where cpacdscr ilike '%transport%' and $bsca ilike '%${params.criterio}%'"
        sqlTx = "${select} ${txwh} order by cpacdscr limit 30 ".toString()

        def cn = dbConnectionService.getConnection()
        datos = cn.rows(sqlTx)
        cn.close()
        [data: datos, tipo: params.tipo]
    }

    def itemsUso () {

    }

    def tablaItemsUso_ajax() {

        def sql = "select * from item_uso()"
        def cn = dbConnectionService.getConnection()
        def res = cn.rows(sql.toString())
        cn.close()
        return[items: res]
    }


    def borrarItem() {
        def cn = dbConnectionService.getConnection()
        def sql1 = "delete from ares where item__id = "
        def sql2 = "delete from itva where item__id = "
        def sql3 = "delete from rbpc where item__id = "
        def sql4 = "delete from item where item__id = "
        def sql = ""
        def res = true
//        println "borrarItem: $params"

        if (params.item instanceof java.lang.String) {
            params.item = [params.item]
        }
        def oks = "", nos = ""
        params.item.each {it ->
//            println ">> ${it.toInteger()}"
            try {
                cn.execute("begin")
                cn.execute("$sql1 ${it.toInteger()}".toString())
                cn.execute("$sql2 ${it.toInteger()}".toString())
                cn.execute("$sql3 ${it.toInteger()}".toString())
                cn.execute("$sql4 ${it.toInteger()}".toString())
                println "borrado id: $it"
                flash.clase = "alert-success"
                flash.message = "Se ha borrado el item con éxito"
                cn.execute("commit")
            } catch (e) {
                println "error: $e"
                flash.clase = "alert-error"
                flash.message = "No se puede borrar el item"
            }
        }
        cn.close()
        render "ok_"
    }

    def formPreciosCantones_ajax(){

        println "formPrecio_ajax" + params
        def item = Item.get(params.item)
        def lugar = null

        if (params.lugar != "all") {
            lugar = Lugar.get(params.lugar)
        }

        def cantones = Lugar.findAllByTipoLista(item.tipoLista, [sort: 'codigo'])

        def precioRubrosItemsInstance

        if(params.id){
            precioRubrosItemsInstance = PrecioRubrosItems.get(params.id)
        }else{
            precioRubrosItemsInstance = new PrecioRubrosItems()
            precioRubrosItemsInstance.item = item
            if (lugar) {
                precioRubrosItemsInstance.lugar = lugar
            }
        }

        return [precioRubrosItemsInstance: precioRubrosItemsInstance, lugar: lugar, lugarNombre: params.nombreLugar, fecha: params.fecha, params: params, cantones: cantones]
    }

    def savePrecioCantones_ajax(){
        println("sv " + params)
        def cn = dbConnectionService.getConnection()
        def fcha = params.fecha[0..9]
        def mnsj = ""
        def sql="update rbpc set rbpcpcun = ${params.precioUnitario} " +
                "where rbpcfcha = '${fcha}' and lgar__id in (${params.lugares}) and " +
                "item__id = ${params.item.id} "
        println "sql: $sql"
        try {
            cn.execute(sql.toString())
            mnsj = "ok_Precios actualizados correctamente"
        }
        catch (e) {
            mnsj = "no_Error al actualizar los precios"
        }
        cn.close()
        render mnsj
    }

    def impresionMinas_ajax(){

    }

    def tablaBusqueda_ajax(){
        def sql = "select itemnmbr, item.dprt__id from item, dprt, sbgr where item.dprt__id = dprt.dprt__id and " +
                "dprt.sbgr__id = sbgr.sbgr__id and sbgr.grpo__id = ${params.tipo} and " +
                "itemnmbr ilike '%${params.criterio}%' order by itemnmbr "
        def cn = dbConnectionService.getConnection()
        def res = cn.rows(sql.toString());
        cn.close()
        return[res: res]
    }


    def tablaGrupos_ajax(){
        def cn = dbConnectionService.getConnection()
        println "tablaGrupos_ajax $params"
        def grupo = Grupo.get(params.buscarPor)
//        def grupos = SubgrupoItems.findAllByGrupoAndDescripcionIlike(grupo, '%' + params.criterio + '%', [sort: 'codigo',
//                     order: 'asc']).take(50)
        def campo, busca
        params.criterio = params.criterio?.toString()?.trim()
        try {
            busca = params.criterio.toString().replaceAll("[.!?]+", "")?.toInteger()
            campo = 'sbgrcdgo' }
        catch (e) {
            campo = 'sbgrdscr'
        }

        def sql = "select * from sbgr where grpo__id = ${grupo?.id} and " +
//                "sbgrdscr ilike '%${params.criterio}%' order by sbgrcdgo"
                "${campo} ilike '%${params.criterio}%' order by sbgrcdgo"
        println "sql: $sql"
        def grupos = cn.rows(sql.toString());
        cn.close()
        return [grupos: grupos, grupo: grupo]
    }

    def tablaSubgrupos_ajax(){
        def cn = dbConnectionService.getConnection()
        println "tablaSubgrupos_ajax $params"
        def grupo = Grupo.get(params.buscarPor)
        def grupos = SubgrupoItems.findAllByGrupo(grupo, [sort: 'codigo'])
        def grupoBuscar = null

        def campo, busca
        params.criterio = params.criterio?.toString()?.trim()
        try {
            busca = params.criterio.toString().replaceAll("[.!?]+", "")?.toInteger()
            campo = 'dprtcdgo' }
        catch (e) {
            campo = 'dprtdscr'
        }


        def subgrupos = []
//        def subgrupos2 = []
        def sql = "select sbgrcdgo, sbgrdscr, dprtcdgo, dprtdscr, dprt.dprt__id, sbgr.sbgr__id from dprt, sbgr where grpo__id = ${params.buscarPor} and " +
                "dprt.sbgr__id = sbgr.sbgr__id and " +
                "${campo} ilike '%${params.criterio}%' or (sbgr.sbgr__id = ${params.id}) order by sbgrcdgo"
        if(params.id) {
//            sql = "select sbgrcdgo, sbgrdscr, dprtcdgo, dprtdscr, dprt.dprt__id, sbgr.sbgr__id " +
//                    "from dprt, sbgr where grpo__id = ${params.buscarPor} and " +
//                    "dprt.sbgr__id = sbgr.sbgr__id and sbgr.sbgr__id = ${params.id} and " +
//                    "dprtdscr ilike '%${params.criterio}%' or (sbgr.sbgr__id = ${params.id}) order by sbgrcdgo"

            sql = "select sbgrcdgo, sbgrdscr, dprtcdgo, dprtdscr, dprt.dprt__id, sbgr.sbgr__id " +
                    "from dprt, sbgr where grpo__id = ${params.buscarPor} and " +
                    "dprt.sbgr__id = sbgr.sbgr__id and sbgr.sbgr__id = ${params.id} and " +
                    "${campo} ilike '%${params.criterio}%' order by sbgrcdgo"

            grupoBuscar = SubgrupoItems.get(params.id)
        }else{

            if(params.criterio){
                grupoBuscar = DepartamentoItem.findByDescripcionAndSubgrupoInList(params.criterio, grupos).subgrupo

                println("-- " + grupoBuscar)
            }

        }
//        if(params.id){
//            def grupoBuscar = SubgrupoItems.get(params.id)
//            subgrupos2 = DepartamentoItem.findAllBySubgrupo(grupoBuscar).sort{a,b -> a.subgrupo.descripcion <=> b.subgrupo.descripcion ?: a.codigo <=> b.codigo }.take(50)
//        }else{
//            subgrupos2 = DepartamentoItem.findAllBySubgrupoInListAndDescripcionIlike(grupos, '%' + params.criterio + '%').sort{a,b -> a.subgrupo.descripcion <=> b.subgrupo.descripcion ?: a.codigo <=> b.codigo }.take(50)
//        }


//        println("ss " + subg*rupos2)


//        println "sql: $sql"
        subgrupos = cn.rows(sql.toString());

        cn.close()

        println("gb " + grupoBuscar)

        return [subgrupos: subgrupos, grupo: grupo, id_grupo: subgrupos.sbgr__id, grupoBuscar: grupoBuscar ]
    }

    def tablaMateriales_ajax(){
        println "tablaMateriales_ajax $params"
        def cn = dbConnectionService.getConnection()
        def grupo = Grupo.get(params.buscarPor)
//        def grupos = SubgrupoItems.findAllByGrupo(grupo)
//        def subgrupos = DepartamentoItem.findAllBySubgrupoInList(grupos)
        def materiales = []
        def subgrupoBuscar = null


        def campo, busca
        params.criterio = params.criterio?.toString()?.trim()
        try {
            busca = params.criterio.toString().replaceAll("[.!?]+", "")?.toInteger()
            campo = 'itemcdgo' }
        catch (e) {
            campo = 'itemnmbr'
        }

        def sql = "select sbgrcdgo, sbgrdscr, dprtcdgo, dprtdscr, dprt.dprt__id, sbgr.sbgr__id, " +
                "itemcdgo, itemnmbr, item__id, itemetdo, itemcdes " +
                "from dprt, sbgr, item where grpo__id = ${params.buscarPor} and " +
                "dprt.sbgr__id = sbgr.sbgr__id and item.dprt__id = dprt.dprt__id and " +
                "${campo} ilike '%${params.criterio}%' order by ${params.ordenar == '1' ? 'itemcdgo' : 'itemnmbr'} limit 100"
        if(params.id) {
            sql = "select sbgrcdgo, sbgrdscr, dprtcdgo, dprtdscr, dprt.dprt__id, sbgr.sbgr__id, " +
                    "itemcdgo, itemnmbr, item__id, itemetdo,itemcdes " +
                    "from dprt, sbgr, item where grpo__id = ${params.buscarPor} and " +
                    "dprt.sbgr__id = sbgr.sbgr__id and dprt.dprt__id = ${params.id} and item.dprt__id = dprt.dprt__id and " +
                    "${campo} ilike '%${params.criterio}%' order by  ${params.ordenar == '1' ? 'itemcdgo' : 'itemnmbr'} "
            subgrupoBuscar = DepartamentoItem.get(params.id)
        }

        println "sql:, $sql"

//        if(params.id){
//            subgrupoBuscar = DepartamentoItem.get(params.id)
//            materiales = Item.findAllByDepartamento(subgrupoBuscar).sort{a,b -> a.departamento.descripcion <=> b.departamento.descripcion ?: a.codigo <=> b.codigo }.take(50)
//        }else{
//            materiales = Item.findAllByDepartamentoInListAndNombreIlike(subgrupos, '%' + params.criterio + '%').sort{a,b -> a.departamento.descripcion <=> b.departamento.descripcion ?: a.codigo <=> b.codigo }.take(50)
//        }

        materiales = cn.rows(sql.toString())
        return [materiales: materiales, grupo: grupo, id: params.id, departamento: subgrupoBuscar]
    }

    def codigoGrupo_ajax(){
        def grupo = SubgrupoItems.get(params.id)
        return [grupo:grupo]
    }

    def especificaciones_ajax(){

        def item = Item.get(params.id)
        def ares = ArchivoEspecificacion.findByItem(item)
        def usuario = Persona.get(session.usuario.id)
        def existeUtfpu = false
//        if(usuario.departamento?.codigo == 'CRFC'){
        if(session.perfil.nombre == 'CRFC'){
            existeUtfpu = true
        }
//        println "dpto: ${usuario.departamento?.codigo} --> $existeUtfpu, tipo: ${params.tipo}"
        return [item: item, ares: ares, existe: existeUtfpu, tipo: params.tipo]
    }

    def uploadFileIlustracion() {
//        println ("subir iamgen " + params)

        def rubro = Item.get(params.item)
        def acceptedExt = ["jpg", "png", "gif", "jpeg"]

        def path = "/var/janus/" + "item/" + rubro?.id + "/"
        new File(path).mkdirs()

        def f = request.getFile('file')  //archivo = name del input type file
        if (f && !f.empty) {
            def fileName = f.getOriginalFilename() //nombre original del archivo
            def ext
            def parts = fileName.split("\\.")
            fileName = ""
            parts.eachWithIndex { obj, i ->
                if (i < parts.size() - 1) {
                    fileName += obj
                } else {
                    ext = obj
                }
            }
            if (acceptedExt.contains(ext.toLowerCase())) {

                def old = rubro?.foto
                if (old) {
                    def oldPath = "/var/janus/" + "item/" + rubro?.id + "/" + old
                    def oldFile = new File(oldPath)
                    if (oldFile.exists()) {
                        oldFile.delete()
                    }
                }

                fileName = "r_" + "il" + "_" + rubro.id
                fileName = fileName + "." + ext
                def pathFile = path + fileName
                def file = new File(pathFile)
                f.transferTo(file)

                rubro.foto = fileName
                rubro.save(flush: true)

            } else {
//                flash.clase = "alert-error"
//                flash.message = "Error: Los formatos permitidos son: JPG, JPEG, GIF, PNG"
//
                render "err_Los formatos permitidos son: JPG, JPEG, GIF, PNG"
                return

            }
        } else {
//            flash.clase = "alert-error"
//            flash.message = "Error: Seleccione un archivo JPG, JPEG, GIF, PNG"

            render "err_Seleccione un archivo JPG, JPEG, GIF, PNG"
            return
        }

        render "ok_Guardado correctamente"

//        redirect(action: "especificaciones_ajax", id: rubro.id)
//        return
    }

    def getFoto(){
//        println "getFoto: $params"
        def item = Item.get(params.id)
        def path = "/var/janus/item/" + item?.id + "/" +  item?.foto
        def fileext = path.substring(path.indexOf(".")+1, path.length())

        BufferedImage imagen = ImageIO.read(new File(path));
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ImageIO.write( imagen, fileext, baos );
        baos.flush();
        byte[] img = baos.toByteArray();
        baos.close();
        response.setHeader('Content-length', img.length.toString())
        response.contentType = "image/"+fileext // or the appropriate image content type
        response.outputStream << img
        response.outputStream.flush()
    }


    def getFotoRubro(){
//        println "getFoto: $params"
        def item = Item.get(params.id)
        def path = "/var/janus/rubros/" +  item?.foto
        def fileext = path.substring(path.indexOf(".")+1, path.length())

        BufferedImage imagen = ImageIO.read(new File(path));
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ImageIO.write( imagen, fileext, baos );
        baos.flush();
        byte[] img = baos.toByteArray();
        baos.close();
        response.setHeader('Content-length', img.length.toString())
        response.contentType = "image/"+fileext // or the appropriate image content type
        response.outputStream << img
        response.outputStream.flush()
    }

    def downloadFile() {

        def item = Item.get(params.id)
        def tipo = params.tipo
        def filePath

        switch (tipo) {
            case "il":
                filePath = item?.foto
                break;
            case "pdf":
                filePath = ArchivoEspecificacion.findByItem(item)?.ruta
                break;
            case "wd":
                filePath = ArchivoEspecificacion.findByItem(item)?.especificacion
                break;
        }

        def ext = filePath.split("\\.")
        ext = ext[ext.size() - 1]
        def path = "/var/janus/" + "item/" + item.id + File.separatorChar + filePath
//        println "path "+path
        def file = new File(path)
        if(file.exists()){
            def b = file.getBytes()
            response.setContentType(ext == 'pdf' ? "application/pdf" : "image/" + ext)
            response.setHeader("Content-disposition", "attachment; filename=" + filePath)
            response.setContentLength(b.length)
            response.getOutputStream().write(b)
        }else{
            flash.message="El archivo seleccionado no se encuentra en el servidor."
            redirect(action: "especificaciones_ajax",params: [id:item.id])
        }
    }

    def uploadFileEspecificacion() {
        println "upload "+params

        def usuario = Persona.get(session.usuario.id)
        def rubro = Item.get(params.item)
        def acceptedWord = ['doc', 'docx']
        def acceptedPdf = ['pdf']

        def path = "/var/janus/" + "item/" + rubro?.id + "/"   //web-app/rubros
        new File(path).mkdirs()

        def archivEsp
        def tipo = params.tipo

        def existe = ArchivoEspecificacion.findByCodigo(rubro.codigoEspecificacion)

        if(existe) {
            archivEsp = existe
        } else {
            archivEsp = new ArchivoEspecificacion()
            archivEsp.item = rubro
            archivEsp.codigo = rubro.codigoEspecificacion
        }

        archivEsp.persona = usuario

        def f = request.getFile('file')  //archivo = name del input type file
        if (f && !f.empty) {
            def fileName = f.getOriginalFilename() //nombre original del archivo
            def ext
            def parts = fileName.split("\\.")
            fileName = ""
            parts.eachWithIndex { obj, i ->
                if (i < parts.size() - 1) {
                    fileName += obj
                } else {
                    ext = obj
                }
            }

            println("ext " + ext)


//            if ( params.tipo == 'pdf' ?  acceptedPdf.contains(ext?.toLowerCase()) : acceptedWord.contains(ext?.toLowerCase())) {
            if ( ext == 'pdf' ?  acceptedPdf.contains(ext?.toLowerCase()) : acceptedWord.contains(ext?.toLowerCase())) {

                println("entro??")

                def old

//                if(tipo == 'pdf'){
                if(ext == 'pdf'){
                    old = archivEsp?.ruta
                }else{
                    old = archivEsp?.especificacion
                }

                if (old) {
                    def oldPath =  "/var/janus/" + "item/" + rubro?.id + "/" + old
                    def oldFile = new File(oldPath)
                    if (oldFile.exists()) {
                        oldFile.delete()
                    }
                }

                fileName = "r_" + "dt" + "_" + rubro.id
                fileName = fileName + "." + ext
                def pathFile = path + fileName
                def file = new File(pathFile)
                f.transferTo(file)

                switch (tipo) {
                    case "pdf":
                        archivEsp?.ruta =  fileName
                        break;
                    case "word":
                        archivEsp?.especificacion =  fileName
                        break;
                }

                if(archivEsp.save(flush: true)){
                    rubro.especificaciones = archivEsp?.ruta
                    rubro.save(flush: true)
                    render "ok_Guardado correctamente"
                } else {
                    println "${archivEsp.errors}"
                    render "no_Error al guardar"
                }
            } else {
//                flash.clase = "alert-error"
//                flash.message = params.tipo == 'pdf' ? ("Error: Los formatos permitidos son: PDF") : ("Error: Los formatos permitidos son: DOC, DOCX")
                render "no_" + params.tipo == 'pdf' ? ("Error: Los formatos permitidos son: PDF") : ("Error: Los formatos permitidos son: DOC, DOCX")
            }
        } else {
//            flash.clase = "alert-error"
//            flash.message =  params.tipo == 'pdf' ? "Error: Seleccione un archivo PDF" : "Error: Seleccione un archivo DOC, DOCX"
            render "no_" + params.tipo == 'pdf' ? "Error: Seleccione un archivo PDF" : "Error: Seleccione un archivo DOC, DOCX"
        }



//        redirect(action: "especificaciones_ajax", id: rubro.id, params: [tipo: tipo])
    }


    def codigos_ajax () {
        def departamento = DepartamentoItem.get(params.id)
        return [departamento: departamento]
    }

    def tablaGruposPrecios_ajax() {
        def cn = dbConnectionService.getConnection()
        def grupo = Grupo.get(params.buscarPor)
        def sql = "select * from sbgr where grpo__id = ${grupo?.id} and " +
                "sbgrdscr ilike '%${params.criterio}%' order by sbgrcdgo"
        def grupos = cn.rows(sql.toString());
        cn.close()
        return [grupos: grupos, grupo: grupo]
    }

    def tablaSubgruposPrecios_ajax() {
        def cn = dbConnectionService.getConnection()
        def grupo = Grupo.get(params.buscarPor)
        def grupos = SubgrupoItems.findAllByGrupo(grupo, [sort: 'codigo'])
        def subgrupos = []

//        def subgrupos2 = []
//        def sql = "select sbgrcdgo, sbgrdscr, dprtcdgo, dprtdscr, dprt.dprt__id, sbgr.sbgr__id from dprt, sbgr where grpo__id = ${params.buscarPor} and " +
//                "dprt.sbgr__id = sbgr.sbgr__id and " +
//                "dprtdscr ilike '%${params.criterio}%' or (sbgr.sbgr__id = ${params.id}) order by sbgrcdgo"
//        if(params.id) {
//            sql = "select sbgrcdgo, sbgrdscr, dprtcdgo, dprtdscr, dprt.dprt__id, sbgr.sbgr__id from dprt, sbgr where grpo__id = ${params.buscarPor} and " +
//                    "dprt.sbgr__id = sbgr.sbgr__id and sbgr.sbgr__id = ${params.id} and " +
//                    "dprtdscr ilike '%${params.criterio}%' or (sbgr.sbgr__id = ${params.id}) order by sbgrcdgo"
//        }

        if(params.id){
            def grupoBuscar = SubgrupoItems.get(params.id)
            subgrupos = DepartamentoItem.findAllBySubgrupo(grupoBuscar).sort{a,b -> a.subgrupo.descripcion <=> b.subgrupo.descripcion ?: a.codigo <=> b.codigo }.take(50)
        }else{
            subgrupos = DepartamentoItem.findAllBySubgrupoInListAndDescripcionIlike(grupos, '%' + params.criterio + '%').sort{a,b -> a.subgrupo.descripcion <=> b.subgrupo.descripcion ?: a.codigo <=> b.codigo }.take(50)
        }

//        println("--> " + subgrupos2)


//        subgrupos = cn.rows(sql.toString());
//        cn.close()
//        return [subgrupos: subgrupos, grupo: grupo, id_grupo: subgrupos.sbgr__id ]
        return [subgrupos: subgrupos, grupo: grupo]
    }

    def tablaMaterialesPrecios_ajax(){
        def persona = Persona.get(session.usuario.id)
        def cn = dbConnectionService.getConnection()
        def grupo = Grupo.get(params.buscarPor)
        def grupos = SubgrupoItems.findAllByGrupo(grupo)
        def subgrupos = DepartamentoItem.findAllBySubgrupoInList(grupos)
        def materiales = []
        def subgrupoBuscar = null
        def sql = ""
//        def perfil = Persona.get(session.usuario.id).departamento?.codigo == 'CRFC'
        def perfil = session.perfil.nombre == 'CRFC'

        if(params.id){
            subgrupoBuscar = DepartamentoItem.get(params.id)
//            sql = "select item.item__id, itemcdgo, itemnmbr, p.rbpcfcha, rbpcpcun, rbpc__id,  lgardscr, p.lgar__id " +
//                    "from item, rbpc p, lgar where p.item__id = item.item__id and p.rbpcfcha = (select max(rbpcfcha) " +
//                    "from rbpc r where r.item__id = p.item__id and r.lgar__id = p.lgar__id) and lgar.lgar__id = p.lgar__id and " +
//                    "item.dprt__id = ${subgrupoBuscar?.id} and item.itemnmbr ilike '%${params.criterio}%' " +
//                    "order by item.itemcdgo, lgardscr limit 100";
            sql = "select item__id, itemcdgo, itemnmbr, rbpcfcha, rbpcpcun, rbpc__id,  lgardscr, lgar__id " +
                    "from ls_item(${params.buscarPor}, '%', '${subgrupoBuscar?.id}', '%${params.criterio}%')" +
//                    "from ls_item(${params.buscarPor}, '%', '${params.id}', '%', '%${params.criterio}%')" +
                    "order by lgardscr limit 100";
        }else{
//            sql = "select item.item__id, itemcdgo, itemnmbr, p.rbpcfcha, rbpcpcun,  rbpc__id, lgardscr,  p.lgar__id " +
//                    "from item, dprt, sbgr, grpo, rbpc p, lgar where p.item__id = item.item__id and p.rbpcfcha = " +
//                    "(select max(rbpcfcha) " +
//                    "from rbpc r where r.item__id = p.item__id and r.lgar__id = p.lgar__id) and lgar.lgar__id = p.lgar__id and " +
//                    "item.dprt__id = dprt.dprt__id and dprt.sbgr__id = sbgr.sbgr__id and " +
//                    "sbgr.grpo__id = grpo.grpo__id and grpo.grpo__id = ${grupo?.id} and " +
//                    "item.itemnmbr ilike '%${params.criterio}%' " +
//                    "order by item.itemcdgo, lgardscr limit 100"
            sql = "select item__id, itemcdgo, itemnmbr, rbpcfcha, rbpcpcun, rbpc__id,  lgardscr, lgar__id " +
                    "from ls_item(${params.buscarPor}, '%', '%', '%${params.criterio}%')" +
                    "order by lgardscr limit 100"
        }

        println("tablaMaterialesPrecios_ajax sql " + sql)
        def items = cn.rows(sql.toString());
        cn.close()

        return [materiales: materiales, grupo: grupo, id: params.id, departamento: subgrupoBuscar, perfil: perfil, items: items, persona: persona]
    }

    def tablaPrecios_ajax(){
        println("--> " + params)
        def persona = Persona.get(session.usuario.id)
        def cn = dbConnectionService.getConnection()
        def grupo = Grupo.get(params.buscarPor)
        def grupos = SubgrupoItems.findAllByGrupo(grupo)
        def subgrupos = DepartamentoItem.findAllBySubgrupoInList(grupos)
        def materiales = []
        def subgrupoBuscar = null
        def sql = ""

//        if(params.id){
//            def item = Item.get(params.id)
//            sql = "select item.item__id, itemcdgo, itemnmbr, p.rbpcfcha, rbpcpcun from item, dprt, sbgr, grpo, rbpc p " +
////                    "where p.item__id = item.item__id and p.rbpcfcha = " +
//                    "where p.item__id = ${item?.id} and p.rbpcfcha = " +
//                    "(select max(rbpcfcha) from rbpc r where r.item__id = p.item__id) and " +
//                    "item.dprt__id = dprt.dprt__id and dprt.sbgr__id = sbgr.sbgr__id and " +
//                    "sbgr.grpo__id = grpo.grpo__id and grpo.grpo__id = ${grupo?.id} and " +
//                    "item.itemnmbr ilike '%${params.criterio}%' " +
//                    "group by item.item__id, itemcdgo, itemnmbr, p.rbpcfcha, rbpcpcun " +
//                    "order by item.itemcdgo limit 100;"
//        }else{
        sql = "select item.item__id, itemcdgo, itemnmbr, p.rbpcfcha, rbpcpcun from item, dprt, sbgr, grpo, rbpc p " +
                "where p.item__id = item.item__id and p.rbpcfcha = " +
                "(select max(rbpcfcha) from rbpc r where r.item__id = p.item__id) and " +
                "item.dprt__id = dprt.dprt__id and dprt.sbgr__id = sbgr.sbgr__id and " +
                "sbgr.grpo__id = grpo.grpo__id and grpo.grpo__id = ${grupo?.id} and " +
                "item.itemnmbr ilike '%${params.criterio}%' " +
                "group by item.item__id, itemcdgo, itemnmbr, p.rbpcfcha, rbpcpcun " +
                "order by item.itemcdgo limit 100;"
//        }



        println("tablaMaterialesPrecios_ajax sql " + sql)
        def items = cn.rows(sql.toString());
        cn.close()

        return [materiales: materiales, grupo: grupo, id: params.id, departamento: subgrupoBuscar, items: items, persona: persona]
    }

    def listas_ajax(){
    }

    def tablaListas_ajax(){
        def listas = Lugar.list([sort: 'descripcion'])
        return [listas: listas]
    }

    def borrarArchivo_ajax(){
        println("params " + params)
        def rubro = Item.get(params.id)
        def archivoEspe = ArchivoEspecificacion.findByCodigo(rubro.codigoEspecificacion)

        def old = params.tipo == 'pdf' ?  archivoEspe?.ruta : ( params.tipo == 'word' ?  archivoEspe?.especificacion :rubro?.foto)

        println("old " + old)

        if (old) {
            def oldPath = "/var/janus/" + "item/" + rubro?.id + "/" + old
            def oldFile = new File(oldPath)
            if (oldFile.exists()) {
                oldFile.delete()

                if(params.tipo == 'pdf'){
                    archivoEspe.ruta = null
                    archivoEspe.save(flush:true)
                }else{
                    if(params.tipo == 'word'){
                        archivoEspe.especificacion = null
                        archivoEspe.save(flush:true)
                    }else{
                        rubro.foto = null
                        rubro.save(flush:true)
                    }
                }
                render "ok_Borrada Correctamente"
            }else{
                render "no_Error al borrar"
            }
        }else{
            render "no_Error al borrar"
        }
    }


    def imagenMateriales_ajax(){

        println("params " + params)


        def item = Item.get(params.id)

//        getFoto();

//        def path = "/var/janus/item/" + item?.id + "/" +  item?.foto
//        def fileext = path.substring(path.indexOf(".")+1, path.length())
//
//        BufferedImage imagen = ImageIO.read(new File(path));
//        ByteArrayOutputStream baos = new ByteArrayOutputStream();
//        ImageIO.write( imagen, fileext, baos );
//        baos.flush();
//        byte[] img = baos.toByteArray();
//        baos.close();
//        response.setHeader('Content-length', img.length.toString())
//        response.contentType = "image/"+fileext // or the appropriate image content type
//        response.outputStream << img
//        response.outputStream.flush()

        return [item: item, tipo: params.tipo]
    }

//    def borrarImagen_ajax(){
//        println("params " + params)
//
//        def rubro = Item.get(params.id)
//        def old = rubro?.foto
//        if (old) {
//            def oldPath = "/var/janus/" + "item/" + rubro?.id + "/" + old
//            def oldFile = new File(oldPath)
//            if (oldFile.exists()) {
//                oldFile.delete()
//                rubro.foto = null
//                rubro.save(flush:true)
//                render "ok_Borrada Correctamente"
//            }else{
//                render "no_Error al borrar"
//            }
//        }else{
//            render "no_Error al borrar"
//        }
//    }

    def comboGrupos_ajax(){
        def cn = dbConnectionService.getConnection()
//        def grupo = Grupo.get(params.buscarPor)
        def grupo = Grupo.get(1)
        def sql = "select * from sbgr where grpo__id = ${grupo?.id} order by sbgrcdgo"
        def grupos = cn.rows(sql.toString());
        cn.close()
        return [grupos: grupos, tipo: params.tipo]
    }

    def comboSubgrupos_ajax(){
        def cn = dbConnectionService.getConnection()
        def grupo = Grupo.get(1)
        def sql = "select sbgrcdgo, sbgrdscr, dprtcdgo, dprtdscr, dprt.dprt__id, sbgr.sbgr__id from dprt, sbgr where grpo__id = ${grupo?.id} and " +
                "dprt.sbgr__id = sbgr.sbgr__id and " +
                "sbgr.sbgr__id = ${params.id} order by sbgrcdgo"
        def subgrupos = cn.rows(sql.toString());
        cn.close()
        return [subgrupos: subgrupos]
    }

    def consultaPrecios(){
        def cn = dbConnectionService.getConnection()
        def anio = new Date().format('yyyy').toInteger()
        def fechas = [:]
        def sql = "select distinct rbpcfcha from rbpc where extract(year from rbpcfcha) = '${anio}'"
        "order by 1"
        println "sql: $sql"
        def i = 0
        cn.eachRow(sql.toString()) { r ->
            fechas[i] = r.rbpcfcha
            i++
        }
        println "fechas: $fechas"
        cn.close()
        [fechas: fechas, anio: anio]
    }

    def tablaConsultaPrecios_ajax(){
        println "tablaConsultaPrecios_ajax: $params"
        def cn = dbConnectionService.getConnection()
        def fecha = params.fecha
        def sql = "select item.item__id, itemcdgo, itemnmbr, p.rbpcfcha, rbpcpcun,  rbpc__id, lgardscr, unddcdgo " +
                "from item, rbpc p, lgar, undd where p.item__id = item.item__id and p.rbpcfcha = '${fecha}' and " +
                "lgar.tpls__id = ${params.lugar} and undd.undd__id = item.undd__id "
        "order by lgardscr"
        def data = cn.rows(sql.toString())
        cn.close()

        return [materiales: data]
    }

    def borrarVariosPrecios_ajax(){
        println("borrar precios " + params)
        render "ok"
    }


    def fechas_ajax(){
        println("parmas  " + params)

        def cn = dbConnectionService.getConnection()
//        def anio = new Date().format('yyyy').toInteger()
        def anio = params.anio
        def fechas = [:]
        def sql = "select distinct rbpcfcha from rbpc where extract(year from rbpcfcha) = '${anio}'"
        "order by 1"
        println "sql: $sql"
        def i = 0
        cn.eachRow(sql.toString()) { r ->
            fechas[i] = r.rbpcfcha
            i++
        }
        println "fechas: $fechas"
        cn.close()
        return [fechas: fechas, anio: anio]
    }

}