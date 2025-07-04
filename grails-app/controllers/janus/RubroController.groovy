package janus

import com.lowagie.text.pdf.PdfReader
import groovy.io.FileType
import janus.apus.ArchivoEspecificacion

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Persona

import javax.imageio.ImageIO
import java.awt.image.BufferedImage

class RubroController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def buscadorService
    def preciosService
    def dbConnectionService

    def index() {
        redirect(action: "rubroPrincipal", params: params)
    } //index

    def factor_ajax(){

    }

    def gruposPorClase() {
        def clase = Grupo.get(params.id)
        def grupos = SubgrupoItems.findAllByGrupo(clase)
        def rubro = Item.get(params.rubro)
        return[grupos:grupos, rubro: rubro]
//        def sel = g.select(id: "selGrupo", name: "rubro.suggrupoItem.id", from: grupos, "class": "span12", optionKey: "id", optionValue: "descripcion", noSelection: ["": "--Seleccione--"])
//        def js = "<script type='text/javascript'>"
//        js += '$("#selGrupo").change(function () {'
//        js += 'var grupo = $(this).val();'
//        js += '$.ajax({'
//        js += 'type    : "POST",'
//        js += 'url     : "' + createLink(action: 'subgruposPorGrupo') + '",'
//        js += 'data    : {'
//        js += 'id : grupo'
//        js += '},'
//        js += 'success : function (msg) {'
//        js += '$("#selSubgrupo").replaceWith(msg);'
//        js += '}'
//        js += '});'
//        js += '});'
//        js += "</script>"
//        render sel + js
    }

    def subgruposPorGrupo() {
        def grupo = SubgrupoItems.get(params.id)
        def subgrupos = DepartamentoItem.findAllBySubgrupo(grupo)
        def rubro = Item.get(params.rubro)
//        def sel = g.select(id: "selSubgrupo", name: "rubro.departamento.id", from: subgrupos, "class": "span2", optionKey: "id", optionValue: "descripcion", noSelection: ["": "--Seleccione--"])
//        render sel
        return[subgrupos: subgrupos, rubro: rubro]
    }

    def ciudadesPorTipo() {
        def tipo = params.id
        def ciudades = Lugar.findAllByTipo(tipo)
        def sel = g.select(id: "ciudad", name: "item.ciudad.id", from: ciudades, "class": "span10", optionKey: "id", optionValue: "descripcion")
        render sel
    }

    def saveEspc() {
        def rubro = Item.get(params.id)
        rubro.especificaciones = params.espc
        if (rubro.save(flush: true))
            render "ok"
        else
            render "no"
    }

    def rubroPrincipal() {
        println "rubroPrincipal params: $params"
        def rubro
        def campos = ["codigo": ["Código", "string"], "nombre": ["Descripción", "string"]]
        def grupos = []
        def volquetes = []
        def volquetes2 = []
        def choferes = []
        def aux = Parametros.get(1)
        def grupoTransporte = DepartamentoItem.findAllByTransporteIsNotNull()
        def dpto = Departamento.findAllByPermisosIlike("APU")
        def resps = Persona.findAllByDepartamentoInList(dpto)
        def listaRbro = [1: 'Materiales', 2: 'Mano de obra', 3: 'Equipos']
        def listaItems = [1: 'Nombre', 2: 'Código']
        def contieneH

        def dptoUser = Persona.get(session.usuario.id).departamento
        def modifica = false
        if (dpto.size()>0) {
            dpto.each {d->
                if (d.id.toInteger() == dptoUser.id.toInteger())
                    modifica = true
            }
        }

        grupoTransporte.each {
            if (it.transporte.codigo == "H")
                choferes = Item.findAllByDepartamento(it)
            if (it.transporte.codigo == "T")
                volquetes = Item.findAllByDepartamento(it)

            volquetes2 += volquetes
        }

        grupos=Grupo.findAll("from Grupo  where id>3")

        if (params.id) {
            rubro = Item.get(params.id)
            contieneH = rubro.codigo[0]?.contains("H")

            def items = Rubro.findAllByRubro(rubro)
            items.sort { it.item.codigo }
            resps = rubro.responsable

            println "items: $items"
            def volumenes =  verificarVolumnesXRubro(rubro?.id)

            [campos: campos, rubro: rubro, grupos: grupos, items: items, choferes: choferes, volquetes: volquetes,
             aux: aux, volquetes2: volquetes2, dpto: dpto, modifica: modifica, resps: resps,
             listaRbro: listaRbro, listaItems: listaItems, volumenes:  volumenes, contieneH: contieneH]
        } else {
            [campos: campos, grupos: grupos, choferes: choferes, volquetes: volquetes, aux: aux,
             volquetes2: volquetes2, dpto: dpto, modifica: modifica, resps: resps,
             listaRbro: listaRbro, listaItems: listaItems]
        }
    }

    def verificarVolumnesXRubro(id){
        def cn = dbConnectionService.getConnection()
        def sql = "select count(*) cnta from vlob, obra where obraetdo = 'R' and vlob.obra__id = obra.obra__id and " +
                "item__id = ${id}"
        println "sql: $sql"
        def existe = cn.rows(sql)[0].cnta

//        def rubro = Item.get(id)
//
//        def volumenes = VolumenesObra.withCriteria{
//            eq("item",rubro)
//            obra{
//                distinct("nombre")
//                resultTransformer org.hibernate.Criteria.DISTINCT_ROOT_ENTITY
//            }
//        }
//        volumenes.unique{it.obra.nombre}
//
//        println "verificarVolumnesXRubro: ${volumenes?.size()}"
//
//        return volumenes?.size()

        println "verificarVolumnesXRubro: ${existe}"
        return existe
    }


    def listaRubros(){
//        println "listaRubros" + params
        def datos;
        def listaItems = ['itemnmbr', 'itemcdgo']

        def select = "select item__id, itemnmbr, itemcdgo, unddcdgo " +
                "from item, undd, dprt, sbgr "
        def txwh = "where tpit__id = 2 and undd.undd__id = item.undd__id and dprt.dprt__id = item.dprt__id and " +
                "sbgr.sbgr__id = dprt.sbgr__id "
        def sqlTx = ""
        def bsca = listaItems[params.buscarPor.toInteger()-1]
        def ordn = listaItems[params.ordenar.toInteger()-1]

        txwh += " and $bsca ilike '%${params.criterio}%'"
        sqlTx = "${select} ${txwh} order by ${ordn} limit 100 ".toString()
//        println "sql: $sqlTx"

        def cn = dbConnectionService.getConnection()
        datos = cn.rows(sqlTx)
//        println "data: ${datos[0]}"
        [data: datos, tipo: params.tipo, rubro: params.rubro, oferente: params.oferente]

    }


    def getDatosItem() {
//        println "get datos items "+params
        def item = Item.get(params.id)
        def nombre = item.nombre
        // println "nombre antes de "+item.nombre
        nombre = nombre.replaceAll(/>/, / mayor que /)
        nombre = nombre.replaceAll(/</, / menor que /)
        nombre = nombre.replaceAll(/&gt;/, / mayor que /)
        nombre = nombre.replaceAll(/&lt;/, / menor que /)
        // println "nombre despues de "+nombre
        //println "render "+  item.id + "&" + item.codigo + "&" + nombre + "&" + item.unidad.codigo + "&" + item.rendimiento+"&"+((item.tipoLista)?item.tipoLista?.id:"0")
        render "" + item.id + "&" + item.codigo + "&" + nombre + "&" + item.unidad?.codigo?.trim() + "&" + item.rendimiento + "&" + ((item.tipoLista) ? item.tipoLista?.id : "0")+"&"+item.departamento.subgrupo.grupo.id
    }

    def addItem() {
        println "add item " + params
        def rubro = Item.get(params.rubro)
        def item = Item.get(params.item)
        def detalle
        detalle = Rubro.findByItemAndRubro(item, rubro)
        if (!detalle)
            detalle = new Rubro()
        detalle.rubro = rubro
        detalle.item = item
        detalle.cantidad = params.cantidad.toDouble()
        if (detalle.item.codigo=~"103.001.00") {
            detalle.cantidad = 1
            detalle.rendimiento = 1
        } else {
            detalle.rendimiento = params.rendimiento.toDouble()
        }
        if (detalle.item.departamento.subgrupo.grupo.id == 2)
            detalle.cantidad = Math.ceil(detalle.cantidad)
        detalle.fecha = new Date()
        if (detalle.item.departamento.subgrupo.grupo.id == 1)
            detalle.rendimiento = 1
        if (!detalle.save(flush: true)) {
            println "detalle " + detalle.errors
        } else {
            rubro.fechaModificacion = new Date()
            rubro.save(flush: true)
            render "" + item.departamento.subgrupo.grupo.id + ";" + detalle.id + ";" + detalle.item.id + ";" +
                    detalle.cantidad + ";" + detalle.rendimiento + ";" + ((item.tipoLista) ? item.tipoLista?.id : "0")
        }
    }

    def buscaItem() {
        //println "busca item "+params
        def persona = Persona.get(session.usuario.id)
        def empresa = persona.empresa
        def listaTitulos = ["Código", "Descripción"]
        def listaCampos = ["codigo", "nombre"]
        def funciones = [null, null]
        def url = g.createLink(action: "buscaItem", controller: "rubro")
        def funcionJs = "function(){"
        funcionJs += 'var idReg = $(this).attr("regId");'
        funcionJs += '$.ajax({type: "POST",url: "' + g.createLink(controller: 'rubro', action: 'getDatosItem') + '",'
        funcionJs += ' data: "id="+idReg,'
        funcionJs += ' success: function(msg){'
        // funcionJs += 'console.log("desc " +msg);'
        funcionJs += 'var parts = msg.split("&");'
        funcionJs += ' $("#item_id").val(parts[0]);'
        funcionJs += ' $("#item_id").attr("tipo",parts[6]);'
        funcionJs += '$("#cdgo_buscar").val(parts[1]);'
        funcionJs += 'var desc =parts[2]; '
        //funcionJs += 'console.log("desc "+desc);'
        funcionJs += 'desc =desc.replace(/>/g, " mayor "); '
        funcionJs += 'desc =desc.replace(/</g, " menor "); '
        // funcionJs += 'console.log("desc "+desc);'
        funcionJs += '$("#item_desc").val(parts[2]);'
        funcionJs += '$("#item_unidad").val(parts[3]);'
        funcionJs += '$("#item_tipoLista").val(parts[5]);'
        funcionJs += '$("#modal-rubro").modal("hide");'
        funcionJs += '}'
        funcionJs += '});'
        funcionJs += '}'
        def numRegistros = 20

        def tipo=params.tipo
        def extras = " and tipoItem = 1 and empr__id = ${empresa.id} and departamento in ("

        SubgrupoItems.findAllByGrupo(Grupo.get(tipo)).each {
            DepartamentoItem.findAllBySubgrupo(it).each{ dp->
                extras+=dp.id+","
            }
        }
        extras+="-1)";
//        println "extras "+extras

        if (!params.reporte) {
            def lista = buscadorService.buscar(Item, "Item", "excluyente", params, true, extras) /* Dominio, nombre del dominio , excluyente o incluyente ,params tal cual llegan de la interfaz del buscador, ignore case */
            lista.pop()
            render(view: '../tablaBuscador', model: [listaTitulos: listaTitulos, listaCampos: listaCampos, lista: lista, funciones: funciones, url: url, controller: "llamada", numRegistros: numRegistros, funcionJs: funcionJs])
        } else {
//            println "entro reporte"
            /*De esto solo cambiar el dominio, el parametro tabla, el paramtero titulo y el tamaño de las columnas (anchos)*/
            session.dominio = Item
            session.funciones = funciones
            def anchos = [20, 80] /*el ancho de las columnas en porcentajes... solo enteros*/
            redirect(controller: "reportes", action: "reporteBuscador", params: [listaCampos: listaCampos, listaTitulos: listaTitulos, tabla: "Item", orden: params.orden, ordenado: params.ordenado, criterios: params.criterios, operadores: params.operadores, campos: params.campos, titulo: "Rubros", anchos: anchos, extras: extras, landscape: true])
        }
    }

    def buscaRubro() {
        def persona = Persona.get(session.usuario.id)
        def empresa = persona.empresa
        println "buscar rubro --> empresa: ${empresa.id}, $empresa"
        def listaTitulos = ["Código", "Descripción", "Unidad"]
        def listaCampos = ["codigo", "nombre", "unidad"]
        def funciones = [null, null]
        def url = g.createLink(action: "buscaRubro", controller: "rubro")
        def funcionJs = "function(){"
        funcionJs += '$("#modal-rubro").modal("hide");'
        funcionJs += 'location.href="' + g.createLink(action: 'rubroPrincipal', controller: 'rubro') + '/"+$(this).attr("regId");'
        funcionJs += '}'
        def numRegistros = 20
        def extras = " and tipoItem = 2 and empr__id = ${empresa.id}"
        if (!params.reporte) {
            if (params.excel) {
                session.dominio = Item
                session.funciones = funciones
                def anchos = [40,100,30] /*anchos para el set column view en excel (no son porcentajes)*/
                redirect(controller: "reportes", action: "reporteBuscadorExcel", params: [listaCampos: listaCampos,
                                                                                          listaTitulos: listaTitulos, tabla: "Item", orden: params.orden, ordenado: params.ordenado,
                                                                                          criterios: params.criterios, operadores: params.operadores, campos: params.campos, titulo: "Rubros",
                                                                                          anchos: anchos, extras: extras, landscape: true])
            } else {
                def lista = buscadorService.buscar(Item, "Item", "excluyente", params, true, extras) /* Dominio, nombre del dominio , excluyente o incluyente ,params tal cual llegan de la interfaz del buscador, ignore case */
                lista.pop()
                render(view: '../tablaBuscador', model: [listaTitulos: listaTitulos, listaCampos: listaCampos,
                                                         lista: lista, funciones: funciones, url: url, controller: "llamada", numRegistros: numRegistros,
                                                         funcionJs: funcionJs])
            }

        } else {
//            println "entro reporte"
            /*De esto solo cambiar el dominio, el parametro tabla, el paramtero titulo y el tamaño de las columnas (anchos)*/
            session.dominio = Item
            session.funciones = funciones
            def anchos = [20, 70,10] /*el ancho de las columnas en porcentajes... solo enteros*/
            redirect(controller: "reportes", action: "reporteBuscador", params: [listaCampos: listaCampos, listaTitulos: listaTitulos, tabla: "Item", orden: params.orden, ordenado: params.ordenado, criterios: params.criterios, operadores: params.operadores, campos: params.campos, titulo: "Rubros", anchos: anchos, extras: extras, landscape: false])
        }
    }

    def buscaRubroComp() {
        def persona = Persona.get(session.usuario.id)
        def empresa = persona.empresa
        def listaTitulos = ["Código", "Descripción"]
        def listaCampos = ["codigo", "nombre"]
        def funciones = [null, null]
        def url = g.createLink(action: "buscaRubro", controller: "rubro")
        def funcionJs = "function(){"
        funcionJs += 'if($("#rubro__id").val()*1>0){ '
        funcionJs += '   if(confirm("Esta seguro?")){'
        funcionJs += '        $("#rub_select").val($(this).attr("regId"));'
        funcionJs += '        $("#copiar_dlg").dialog("open");$("#modal-rubro").modal("hide");'
        funcionJs += '    } '
        funcionJs += '}else{ '
        funcionJs += '    $.box({ '
        funcionJs += '       imageClass: "box_info",'
        funcionJs += '        text      : "Primero guarde el rubro o escoja un de la lista",'
        funcionJs += '       title     : "Alerta", '
        funcionJs += '        iconClose : false,'
        funcionJs += '       dialog    : {'
        funcionJs += '           resizable    : false,'
        funcionJs += '            draggable    : false,'
        funcionJs += '           buttons      : {'
        funcionJs += '                "Aceptar" : function () {}'
        funcionJs += '           }'
        funcionJs += '        }'
        funcionJs += '    });'
        funcionJs += '}'
        funcionJs += '}'
        def numRegistros = 20
//        def extras = " and tipoItem = 2 and empresa = ${empresa.id}"
        def extras = " and tipoItem = 2 "
        if (!params.reporte) {
            def lista = buscadorService.buscar(Item, "Item", "excluyente", params, true, extras) /* Dominio, nombre del dominio , excluyente o incluyente ,params tal cual llegan de la interfaz del buscador, ignore case */
            lista.pop()
            render(view: '../tablaBuscador', model: [listaTitulos: listaTitulos, listaCampos: listaCampos, lista: lista, funciones: funciones, url: url, controller: "llamada", numRegistros: numRegistros, funcionJs: funcionJs])
        } else {
//            println "entro reporte"
            /*De esto solo cambiar el dominio, el parametro tabla, el paramtero titulo y el tamaño de las columnas (anchos)*/
            session.dominio = Item
            session.funciones = funciones
            def anchos = [20, 80] /*el ancho de las columnas en porcentajes... solo enteros*/
            redirect(controller: "reportes", action: "reporteBuscador", params: [listaCampos: listaCampos, listaTitulos: listaTitulos, tabla: "Item", orden: params.orden, ordenado: params.ordenado, criterios: params.criterios, operadores: params.operadores, campos: params.campos, titulo: "Rubros", anchos: anchos, extras: extras, landscape: true])
        }
    }

    def copiarComposicion() {
//        println "copiar!!! " + params + "  " + request.method
//        if (request.method == "POST") {
        def rubro = Item.get(params.rubro)
        def copiar = Item.get(params.copiar)
        def detalles = Rubro.findAllByRubro(copiar)

        def factor
        if (!params.factor)
            params.factor = "1"
        factor = params.factor?.toDouble()
        detalles.each {
            println ""+it.item.departamento.subgrupo.grupo.descripcion+"  "+it.item.departamento.subgrupo.grupo.codigo
            def tmp = Rubro.findByRubroAndItem(rubro, it.item)
            if (!tmp) {
//                    println "no temnp "
                def nuevo = new Rubro()
                nuevo.rubro = rubro
                nuevo.item = it.item
//                    println " asd "  +it.item.nombre

                if(it.item.departamento.subgrupo.grupo.id.toInteger()==1){
                    nuevo.cantidad = it.cantidad * factor
                }else{
                    if (!(it.item.nombre =~ "HERRAMIENTA MENOR")) {
                        nuevo.rendimiento = it.rendimiento * factor
                        nuevo.cantidad=it.cantidad
                    }
                }

                nuevo.fecha = new Date()
                if (!nuevo.save(flush: true)) {
                    println "Error: copiar composicion " + nuevo.errors
                }
                rubro.fecha = new Date()
                rubro.save(flush: true)

            } else {
//                    println "else si hay "
                if (!(it.item.nombre =~ "HERRAMIENTA MENOR")) {
//                        println "entro 2 "+factor
                    if(it.item.departamento.subgrupo.grupo.id.toInteger()==2){
                        //println "es mano de obra"
                        def maxCant = Math.max(tmp.cantidad,it.cantidad)
                        def sum = tmp.cantidad*tmp.rendimiento+(it.cantidad*factor*it.rendimiento)
                        //println "maxcant "+maxCant+" sum "+sum
                        def rend = sum/maxCant
                        tmp.cantidad = maxCant
                        tmp.rendimiento=rend
                        tmp.fecha = new Date()
                        tmp.save(flush: true)


                    }else{
                        if(it.item.departamento.subgrupo.grupo.id.toInteger()==3){
                            //println "es mano de obra"
                            def maxCant = Math.max(tmp.cantidad,it.cantidad)
                            def sum = tmp.cantidad*tmp.rendimiento+(it.cantidad*it.rendimiento)
                            //println "maxcant "+maxCant+" sum "+sum
                            def rend = sum/maxCant
                            tmp.cantidad = maxCant
                            tmp.rendimiento=rend
                            tmp.fecha = new Date()
                            tmp.save(flush: true)
                        }else{
                            tmp.cantidad = tmp.cantidad + it.cantidad * factor
                            tmp.fecha = new Date()
                            tmp.save(flush: true)
                        }
                    }
                }
            }
        }
        render "ok"
//        } else {
//            response.sendError(403)
//        }
    }

    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [rubroInstanceList: Rubro.list(params), rubroInstanceTotal: Rubro.count(), params: params]
    } //list

    def form_ajax() {
        def rubroInstance = new Rubro(params)
        if (params.id) {
            rubroInstance = Rubro.get(params.id)
            if (!rubroInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Rubro con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [rubroInstance: rubroInstance]
    } //form_ajax

    def save() {
//        println "save rubro " + params.rubro
        println("params sr " +  params)

        def usuarioActual = Persona.get(session.usuario.id)

        params.rubro.codigo = params.rubro.codigo.toUpperCase()
        params.rubro.codigoEspecificacion = params.rubro.codigoEspecificacion.toUpperCase()

        def rubro
        if (params.rubro.id) {
            rubro = Item.get(params.rubro.id)
            params.remove("rubro.fecha")
            rubro.tipoItem = TipoItem.get(2)
            rubro.fechaModificacion = new Date()
        } else {
            rubro = new Item(params)
            params.rubro.fecha = new Date()
            rubro.tipoItem = TipoItem.get(2)
        }

        if (params.rubro.registro != "R") {
            params.rubro.registro = "N"
            rubro.fechaRegistro = null
        } else {
            rubro.fechaRegistro = new Date()
        }
        if (params.responsable && params.responsable != "-1") {
            rubro.responsable = Persona.get(params.responsable)
        }

        rubro.properties = params.rubro
        rubro.tipoItem = TipoItem.get(2)


//        println "ren " + rubro.rendimiento
        if (!rubro.save(flush: true)) {
            println "error " + rubro.errors
        }else{

            rubro.modifica = usuarioActual
            rubro.fechaModificacion = new Date()
            rubro.save(flush:true)

            if(rubro.codigoEspecificacion!="" && rubro.codigoEspecificacion){
                def rubros = Item.findByCodigoNotEqualAndCodigoEspecificacion(rubro.codigo,rubro.codigoEspecificacion,[sort:"codigo"])
                if(rubros){
                    rubro.especificaciones=rubros.especificaciones
                    rubro.save(flush: true)
                }
            }

        }

        redirect(action: 'rubroPrincipal', params: [id: rubro.id])
    } //save

    def repetido = {
        if (!params.id) {
            def hayOtros = Item.findAllByCodigo(params.codigo?.toUpperCase()).size() > 0
//        println "repetido: " + hayOtros
            render hayOtros ? "repetido" : "ok"
        } else
            render "ok"
    }

    def show_ajax() {
        def rubroInstance = Rubro.get(params.id)
        if (!rubroInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Rubro con id " + params.id
            redirect(action: "list")
            return
        }
        [rubroInstance: rubroInstance]
    } //show

    def eliminarRubroDetalle() {

        def usuarioActual = Persona.get(session.usuario.id)
        def rubro = Rubro.get(params.id)
        def item = Item.get(rubro.rubro.id)

        try {
            rubro.delete(flush: true)
            item.modifica = usuarioActual
            item.fechaModificacion = new Date()
            item.save(flush:true)
            render "Registro eliminado"
        }
        catch (DataIntegrityViolationException e) {
            render "No se pudo eliminar el rubro"
        }
    }

    def borrarRubro() {
//        println "borrar rubro "+params
        def rubroInstance = Item.get(params.id)
        if (!rubroInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Rubro con id " + params.id
            redirect(action: "list")
            return
        }

        def vo = VolumenesObra.findAllByItem(rubroInstance)
        def obras = Obra.findAllByChoferOrVolquete(rubroInstance, rubroInstance)
//        println "vo "+vo
//        println "obras "+obras
        def ob = [:]
        if (vo.size() + obras.size() > 0) {
            vo.each { v ->

                ob.put(v.obra.codigo, v.obra.nombre)

            }
            obras.each { o ->
                ob.put(o.codigo, o.nombre)
            }
            render "" + ob.collect { "<span class='label-azul'>" + it.key + "</span>: " + it.value }.join('<br>')
            return
        } else {
            try {
                def comp = Rubro.findAllByRubro(rubroInstance)
                comp.each {
                    it.delete(flush: true)
                }
                rubroInstance.delete(flush: true)
                PrecioRubrosItems.findAllByItem(rubroInstance).each {
                    it.delete(flush: true)
                }
                render "ok"
                return
            }
            catch (DataIntegrityViolationException e) {
                println "error del rubro " + e
                render "Error"
                return
            }
        }
    } //delete

    def getPrecios() {
        println "get precios " + params.fecha
        def lugar = Lugar.get(params.ciudad)
//        println ".........1"
        def fecha = new Date().parse('dd-MM-yyyy', params.fecha)
//        println "frecha convertida: $fecha"
        def tipo = params.tipo
        def items = []
        def parts = params.ids.split("#")
        def listas = []
        def conLista = []
        listas = params.listas.split("#")
//        println "listas...: " + listas
        parts.each {
            if (it.size() > 0) {
                def item = Rubro.get(it).item
                if (item.tipoLista) {
                    conLista.add(item)
//                    println "con lista "+item.tipoLista
                } else {
                    items.add(item)
                }
            }
        }
        def precios = ""
//        println "items " + items + "  con lista " + conLista+"  fecha "+fecha
        if (items.size() > 0) {
            precios = preciosService.getPrecioItemsString(fecha, lugar, items)
        }

        conLista.each {
            precios += preciosService.getPrecioItemStringListaDefinida(fecha, listas[it.tipoLista.id.toInteger() - 1], it.id)
        }

//        println "precios final !! " + precios
//        println "--------------------------------------------------------------------------"
        render precios
    }

    def getPreciosItem() {
//        println "get precios item " + params
        def lugar = Lugar.get(params.ciudad)
        def fecha = new Date().parse("dd-MM-yyyy", params.fecha)
        def tipo = params.tipo
        def items = []
        def parts = params.ids.split("#")
        def listas = []
        def conLista = []
        listas = params.listas.split("#")
//        println "listas " + listas
        parts.each {
            if (it.size() > 0) {
                def item = Item.get(it)
                if (item.tipoLista) {
                    conLista.add(item)
//                    println "con lista "+item.tipoLista
                } else {
                    items.add(item)
                }
            }
        }

        def precios = ""
//        println "items " + items + "  con lista " + conLista
        if (items.size() > 0) {
            precios = preciosService.getPrecioItemsString(fecha, lugar, items)
        }

        conLista.each {
            precios += preciosService.getPrecioItemStringListaDefinida(fecha, listas[it.tipoLista.id.toInteger() - 1], it.id)
        }

//        println "precios final " + precios
//        println "--------------------------------------------------------------------------"
        render precios
    }

    def getPreciosTransporte() {
        println "get precios fecha: "+params.fecha
        def lugar = Lugar.get(params.ciudad)
        //def fecha = new Date().parse("dd-MM-yyyy", params.fecha)
        def fecha = new Date().parse("dd-MM-yyyyy", params.fecha)
        def tipo = params.tipo
        def items = []
        def parts = params.ids.split("#")
        parts.each {
            if (it.size() > 0)
                items.add(Item.get(it))
        }
        def precios = preciosService.getPrecioItemsString(fecha, lugar, items)
        println "precios " + precios
        render precios
    }

    def getUnidad () {
        def item = Item.get(params.id)
        render item.unidad
    }

    def buscarRubroCodigo() {
//        println "buscar rubro "+params
        def rubro = Item.findByCodigoAndTipoItem(params.codigo?.trim(), TipoItem.get(1))
        if (rubro) {
            def nombre = rubro.nombre
            nombre = nombre.replaceAll(/>/, / mayor /)
            nombre = nombre.replaceAll(/</, / menor /)
            nombre = nombre.replaceAll(/&gt;/, / mayor /)
            nombre = nombre.replaceAll(/&lt;/, / menor /)
            render "" + rubro.id + "&&" + rubro.tipoLista?.id + "&&" + nombre + "&&" + rubro.unidad?.codigo
            return
        } else {
            render "-1"
            return
        }
    }

    def transporte() {
//        println "transporte "+params
        def idRubro = params.id
        def fecha = new Date().parse("dd-MM-yyyy", params.fecha)
        def listas = params.listas
        def parametros

        if(params.id){
            parametros = "" + idRubro + ",'" + fecha.format("yyyy-MM-dd") + "'," + listas + "," + params.dsp0 + "," + params.dsp1 + "," + params.dsv0 + "," + params.dsv1 + "," + params.dsv2 + "," + params.chof + "," + params.volq
        }else{
            parametros = "" + null + ",'" + fecha.format("yyyy-MM-dd") + "'," + listas + "," + params.dsp0 + "," + params.dsp1 + "," + params.dsv0 + "," + params.dsv1 + "," + params.dsv2 + "," + params.chof + "," + params.volq
        }

//        println "paramtros " +parametros

        def res = preciosService.rb_precios(parametros, "")

        def tabla = '<table class="table table-bordered table-striped table-condensed table-hover"> '
        def total = 0
        tabla += "<thead><tr><th colspan=8>TRANSPORTE</th></tr><tr><th style='width: 80px;'>CODIGO</th><th style='width:610px'>DESCRIPCION</th><th>PESO</th><th>VOL</th><th>CANTIDAD</th><th>DISTANCIA</th><th>TARIFA</th><th>C.TOTAL</th></thead><tbody>"
//        println "rends "+rendimientos

//        println "res "+res
        res.each { r ->
            if (r["grpocdgo"] == 1) {
//                println "en tabla "+r
                tabla += "<tr>"
                tabla += "<td style='width: 80px;'>" + r["itemcdgo"] + "</td>"
                tabla += "<td>" + r["itemnmbr"] + "</td>"
                if (r["tplscdgo"] =~ "P") {
                    tabla += "<td style='width: 50px;text-align: right'>" + r["itempeso"] + "</td>"
                    tabla += "<td></td>"
                }
                if (r["tplscdgo"] =~ "V") {
                    tabla += "<td></td>"
                    tabla += "<td style='width: 50px;text-align: right'>" + r["itempeso"] + "</td>"
                }

                tabla += "<td style='width: 50px;text-align: right'>" + r["rbrocntd"] + "</td>"
                tabla += "<td style='width: 50px;text-align: right'>" + r["distancia"] + "</td>"
                tabla += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["tarifa"], format: "##,#####0", minFractionDigits: 5, maxFractionDigits: 5, locale: "ec") + "</td>"
                tabla += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["parcial_t"], format: "##,#####0", minFractionDigits: 5, maxFractionDigits: 5, locale: "ec") + "</td>"
                total += r["parcial_t"]
                tabla += "</tr>"
            }
//            <g:formatNumber number="${rub.cantidad}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7"  locale="ec"  />
        }
        tabla += "<tr><td><b>SUBTOTAL</b></td><td></td><td></td><td></td><td></td><td></td><td></td><td style='width: 50px;text-align: right;font-weight: bold' class='valor_total'>${g.formatNumber(number: total, format: "##,#####0", minFractionDigits: 5, maxFractionDigits: 5, locale: "ec")}</td>"
        tabla += "</tbody></table>"

        render(tabla)
//
//        pg: select * from rb_precios(293, 4, '1-feb-2008', 50, 70, 0.1015477897561282, 0.1710401760227313);
    }

    def showFoto() {
        def rubro = Item.get(params.id)
        def tipo = params.tipo
        def ares = ArchivoEspecificacion.findByCodigo(rubro.codigoEspecificacion)
        println "show foto params: $params"
        def ret

        if(ares){
            ret = ares?.item
        } else {
            ret = rubro
        }

        def filePath
        def titulo
        switch (tipo) {
            case "il":
                titulo = "Ilustración"
                filePath = rubro.foto
                break;
            case "dt":
                titulo = "Especificaciones"
                filePath = ares?.ruta
                break;
        }

        def ext = ""

        if (filePath) {
            ext = filePath.split("\\.")
            ext = ext[ext.size() - 1]
        }
        println "ruta: $filePath"
        return [rubro: rubro, ext: ext, tipo: tipo, titulo: titulo, filePath: filePath, ares: ares?.id]
//        return [rubro: rubro, ext: ext, tipo: tipo, titulo: "Ilustración", ares: ares?.id]
    }

    def getFoto(){
        println "getFoto: $params"
        def path = "/var/janus/rubros/${params.ruta}"
        def fileext = path.substring(path.indexOf(".")+1, path.length())

        println "ruta: $path"

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

        def rubro = Item.get(params.id)
        def ares = ArchivoEspecificacion.findByCodigo(rubro?.codigoEspecificacion)

        def tipo = params.tipo
        def filePath

        switch (tipo) {
            case "il":
                filePath = rubro.foto
                break;
            case "dt":
                filePath = ares?.ruta
                break;
            case "wd":
                filePath = ares?.especificacion
                break;
        }

        def ext = filePath.split("\\.")
        ext = ext[ext.size() - 1]
        def folder = "rubros"
        def path = "/var/janus/" + folder + File.separatorChar + filePath
        println "path "+path
        def file = new File(path)
        if(file.exists()){
            def b = file.getBytes()
            response.setContentType(ext == 'pdf' ? "application/pdf" : "image/" + ext)
            response.setHeader("Content-disposition", "attachment; filename=" + filePath)
            response.setContentLength(b.length)
            response.getOutputStream().write(b)
        }else{
//            flash.message="El archivo seleccionado no se encuentra en el servidor."
//            redirect(action: "especificaciones_ajax",params: [id:rubro.id])
        }
    }

    def downloadFileAres() {
//        println "downloadFileAres: $params"
        def ares = ArchivoEspecificacion.get(params.id)

        def tipo = params.tipo
        def filePath = ares.ruta

        def ext = filePath.split("\\.")
        ext = ext[ext.size() - 1]
        def folder = "rubros"
        def path = "/var/janus/" + folder + File.separatorChar + filePath
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
            redirect(action: "showFoto",params: [id: params.rubro, tipo: "dt"])
        }
    }

    def uploadFile() {
        println "upload "+params

        def acceptedExt = ["jpg", "png", "gif", "jpeg", "pdf", "doc", "docx"]

        def tipo = params.tipo

        def path = "/var/janus/" + "rubros/"   //web-app/rubros
        new File(path).mkdirs()
        def rubro = Item.get(params.rubro)
        println("rrr " + rubro?.id)
        def usuario = Persona.get(session.usuario.id)
        def archivEsp
        if(ArchivoEspecificacion.findByCodigo(rubro.codigoEspecificacion)) {
            archivEsp = ArchivoEspecificacion.findByCodigo(rubro.codigoEspecificacion)
        } else {
            archivEsp = new ArchivoEspecificacion()
            archivEsp.item = rubro
            archivEsp.codigo = rubro.codigoEspecificacion
        }


        println("arc " + archivEsp.id)

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
            if (acceptedExt.contains(ext.toLowerCase())) {
                def ahora = new Date()
                fileName = "r_" + tipo + "_" + rubro.id + "_" + ahora.format("dd_MM_yyyy_hh_mm_ss")
                fileName = fileName + "." + ext
                def pathFile = path + fileName
                def file = new File(pathFile)
                println "subiendo archivo: $fileName"

                f.transferTo(file)

                def old = tipo == "il" ? rubro.foto : (  tipo == 'dt' ? archivEsp?.ruta : archivEsp?.especificacion)
                if (old && old.trim() != "") {
//                    def oldPath = servletContext.getRealPath("/") + "rubros/" + old
                    def oldPath =  "/var/janus/" + "rubros/" + old
                    def oldFile = new File(oldPath)
                    if (oldFile.exists()) {
                        oldFile.delete()
                    }
                }

                switch (tipo) {
                    case "il":
                        rubro.foto = /*g.resource(dir: "rubros") + "/" + */ fileName
                        rubro.save(flush: true)
                        break;
                    case "dt":
//                        rubro.especificaciones = /*g.resource(dir: "rubros") + "/" + */ fileName
                        archivEsp?.ruta = /*g.resource(dir: "rubros") + "/" + */ fileName
                        archivEsp.save(flush:true)
                        break;
                    case "wd":
                        archivEsp?.especificacion = fileName
                        archivEsp.save(flush:true)
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
//                flash.message = "Error: Los formatos permitidos son: JPG, JPEG, GIF, PNG y PDF"
                render "no_" + params.tipo == 'il' ? ("Error: Los formatos permitidos son: JPG, JPEG, GIF, PNGF") : (params.tipo == 'dt' ? ("Error: Los formatos permitidos son: PDF") : ("Error: Los formatos permitidos son: DOC, DOCX"))
            }
        } else {
//            flash.clase = "alert-error"
//            flash.message = "Error: Seleccione un archivo JPG, JPEG, GIF, PNG ó PDF"
            render "no_" + params.tipo == 'il' ? ("Error: Los formatos permitidos son: JPG, JPEG, GIF, PNGF") : (params.tipo == 'dt' ? ("Error: Los formatos permitidos son: PDF") : ("Error: Los formatos permitidos son: DOC, DOCX"))

        }

//        redirect(action: "showFoto", id: rubro.id, params: [tipo: tipo])
//        return
    }


    def verificaRubro(){
        def rubro = Item.get(params.id)
        def respuesta = "<ul>"

        /* todo con SQL */
        def volumenes = VolumenesObra.withCriteria{
            eq("item",rubro)
            obra{
                eq("estado", 'R')
                distinct("nombre")
                resultTransformer org.hibernate.Criteria.DISTINCT_ROOT_ENTITY
            }
        }

        volumenes.unique{it.obra.nombre}

        if(volumenes.size()>0) {
            volumenes.each {
                respuesta += "<li>" + it.obra.codigo + " - " + it.obra.nombre + "</li>"
            }
            respuesta += "</ul>"
            render "1_${respuesta}"
        } else {
            render "0"
        }
    }

    def listaObrasUsadas_ajax(){
        def rubro = Item.get(params.id)

        def volumenes = VolumenesObra.withCriteria{
            eq("item",rubro)
            obra{
                distinct("nombre")
                resultTransformer org.hibernate.Criteria.DISTINCT_ROOT_ENTITY
            }
        }

        volumenes.unique{it.obra.nombre}

        return [volumenes: volumenes, tipo: params.tipo]
    }

    def copiaRubro(){
        println "copia rubro "+params

        def rubro = Item.get(params.id)
        def error = false
        def textoError = ''
        def nuevo = new Item()

        /** todo: actualizar el campo codigoHistorico de todos los rubros H */

        println "codigoHist: ${rubro.codigoHistorico}"
        if(!rubro?.codigoHistorico){

            nuevo.properties=rubro.properties
            def codigo ="H"
            def copias = Item.findAllByCodigoIlike(codigo+'%'+rubro.codigo)

            println "copias: ${copias?.size()}"
            if(copias.size() > 0){
                while(copias.size()!= 0){
                    codigo=codigo+"H"
                    copias = Item.findAllByCodigo(codigo+rubro.codigo)
                }
            }

            rubro.codigoHistorico = rubro.codigo
            rubro.codigo = codigo+rubro.codigo
            rubro.fechaModificacion = new Date()
            rubro.save(flush: true)

            nuevo.fecha = new Date()
            nuevo.padre = rubro
            nuevo.fechaModificacion=null

            if(!nuevo.save(flush: true)){
                println "erro copiar rubro "+nuevo.errors
                error=true
                textoError = 'Error al generar histórico del rubro'
            }else{
                Rubro.findAllByRubro(rubro).each{
                    def r = new Rubro()
                    r.rubro=nuevo
                    r.item=it.item
                    r.cantidad=it.cantidad
                    r.fecha=it.fecha
                    r.rendimiento=it.rendimiento
                    if(!r.save(flush: true)){
                        println "error copiar comp "+r.errors
                        error=true
                        textoError = 'Error al generar histórico del rubro'
                    }
                }
            }
        }else{
            error = true
            textoError = 'No se puede crear un histórico del rubro, ya tiene un histórico creado'
        }

        if(!error){
            render "ok_" + nuevo?.id
        }else{
            render "no_" + textoError
        }
//            error=nuevo.id

//        render error
    }

    def registrar_ajax () {
        def rubro = Item.get(params.id)
        rubro.aprobado = 'R'
        try{
            rubro.save(flush: true)
            render 'ok'
        }catch (e){
            render 'no'
            println("error al cambiar de estado el rubro" + rubro.errors)
        }
    }

    def desregistrar_ajax () {
        def rubro = Item.get(params.id)
        rubro.aprobado = null
        try{
            rubro.save(flush: true)
            render 'ok'
        }catch (e){
            render 'no'
            println("error al cambiar de estado el rubro" + rubro.errors)
        }
    }

    def precio_ajax () {
        def item = Item.get(params.item)
        def precioRubrosItemsInstance = new PrecioRubrosItems()
        precioRubrosItemsInstance.item = item
        return [precioRubrosItemsInstance: precioRubrosItemsInstance, params: params, item: item]
    }

    def listaItem() {
        println "listaItem" + params
        def listaItems = ['itemnmbr', 'itemcdgo']
        def datos;
        def usuario = Persona.get(session.usuario.id)
        def empresa = Parametros.get('1').empresa

        def select = "select item.item__id, itemcdgo, itemnmbr, item.tpls__id, unddcdgo " +
                "from item, undd, dprt, sbgr "
        def txwh = "where tpit__id = 1 and undd.undd__id = item.undd__id and dprt.dprt__id = item.dprt__id and " +
                "sbgr.sbgr__id = dprt.sbgr__id and itemetdo = 'A'"
        def sqlTx = ""
        def bsca = listaItems[params.buscarPor.toInteger()-1]
        def ordn = listaItems[params.ordenar.toInteger()-1]
        txwh += " and $bsca ilike '%${params.criterio}%' and grpo__id = ${params.grupo}"

        sqlTx = "${select} ${txwh} order by ${ordn} limit 100 ".toString()
        println "sql: $sqlTx"

        def cn = dbConnectionService.getConnection()
        datos = cn.rows(sqlTx)
        println "data: ${datos[0]}"
        [data: datos]
    }

    def getPrecioOferente(){
        println "get precio of "+params
        def item = Item.get(params.id)
        def oferente = Persona.get(session.usuario.id)
        def obra = Obra.get(params.obra)
        def precio = 0
        def vae = 100
        println "item: ${item.id} prsn: ${oferente.id} obra: ${obra.id}"
        def tmp = Precio.findByItemAndOferenteAndObra(item,session.usuario, obra)
        if (tmp){
            precio = tmp.precio
            vae = tmp.vae
        }

        render "" + precio + "_" + vae
    }

    def buscarRubro(){
        def rubro = Item.get(params.id)
        return [rubro: rubro]
    }

    def tablaBusqueda_ajax(){
        println "listaItem" + params
        def listaItems = ['itemnmbr', 'itemcdgo']
        def rubro = Item.get(params.rubro)
        def volumenes =  verificarVolumnesXRubro(rubro?.id)
        def datos;
        def usuario = Persona.get(session.usuario.id)
        def empresa = Parametros.get('1').empresa

        def select = "select item.item__id, itemcdgo, itemnmbr, item.tpls__id, unddcdgo " +
                "from item, undd, dprt, sbgr "
        def txwh = "where tpit__id = 1 and undd.undd__id = item.undd__id and dprt.dprt__id = item.dprt__id and " +
                "sbgr.sbgr__id = dprt.sbgr__id and itemetdo = 'A'"
        def sqlTx = ""
        def bsca = listaItems[params.buscarPor.toInteger()-1]
        def ordn = listaItems[params.ordenar.toInteger()-1]
        txwh += " and $bsca ilike '%${params.criterio}%' and grpo__id = ${params.grupo}"

        sqlTx = "${select} ${txwh} order by ${ordn} limit 100 ".toString()
        println "sql: $sqlTx"

        def cn = dbConnectionService.getConnection()
        datos = cn.rows(sqlTx)
        println "data: ${datos[0]}"
        [data: datos, rubro: rubro, volumenes: volumenes]
    }

    def tablaSeleccionados_ajax(){
        def cn = dbConnectionService.getConnection()
        def sql = "select rbro__id, item.item__id, itemcdgo, itemnmbr, grpo__id from rbro, item, dprt, sbgr " +
                "where rbrocdgo = ${params.id} and item.item__id = rbro.item__id and " +
                "dprt.dprt__id = item.dprt__id and sbgr.sbgr__id = dprt.sbgr__id " +
                "order by grpo__id desc"
        println "sql: $sql"
        def rubro = Item.get(params.id)
//        def items = Rubro.findAllByRubro(rubro).sort { it.item.departamento.subgrupo.grupo.id}
//        def items = Rubro.findAllByRubro(rubro, [sort: 'it.item.departamento.subgrupo.grupo.descripcion', order: 'desc'] )
        def items = cn.rows(sql.toString())

//        def volumenes =  verificarVolumnesXRubro(rubro?.id)
        return [items: items, rubro: rubro]
    }

    def agrearItem_ajax(){

        def usuarioActual = Persona.get(session.usuario.id)

        def rubro = Item.get(params.rubro)
        def item = Item.get(params.id)

        def existe = Rubro.findAllByRubroAndItem(rubro, item)

        if(existe){
            render "err_El rubro seleccionado ya se encuentra en la composición"
        }else{
            def nuevoRubro = new Rubro()

            nuevoRubro.rubro = rubro
            nuevoRubro.item = item
            nuevoRubro.fecha = new Date()
            nuevoRubro.cantidad = 1
            nuevoRubro.rendimiento = 1


            if(!nuevoRubro.save(flush:true)){
                println("Error al guardar el nuevo rubro " + nuevoRubro.errors)
                render "no_Error al guardar"
            }else{

                rubro.modifica = usuarioActual
                rubro.fechaModificacion = new Date()
                rubro.save(flush:true)

                render "ok_Agregado correctamente"
            }
        }
    }

    def eliminarRubro_ajax(){
//        println "eliminarRubro_ajax: $params"

        def usuarioActual = Persona.get(session.usuario.id)
        def rubro = Rubro.get(params.id)
        def item = Item.get(rubro.rubro.id)

        if(rubro){
            try{
                rubro.delete(flush:true)
                item.modifica = usuarioActual
                item.fechaModificacion = new Date()
                item.save(flush:true)
                render "ok_Borrado correctamente"
            }catch(e){
                println("Error al borrar el rubro " + rubro.delete(flush:true))
                render "no_Error al borrar el rubro"
            }
        }else{
            render "no_Error al borrar el rubro"
        }
    }

    def editarRubro_ajax(){
        def rubro = Rubro.get(params.id)
        def rendimiento = params.rendimiento ? params.rendimiento.toDouble() : 1
        return [rubro: rubro, rendimiento: rendimiento]
    }

    def saveRubro_ajax(){

        println("params sr" + params)

        def usuarioActual = Persona.get(session.usuario.id)

        def rubro = Rubro.get(params.id)
        def item = Item.get(rubro.rubro.id)

        if(rubro){
            if(params.cantidad){
                if(params.rendimiento){

                    params.cantidad = params.cantidad.toDouble()
                    params.rendimiento = params.rendimiento.toDouble()

                    rubro.properties = params

                    if(!rubro.save(flush:true)){
                        println("error al guardar la cantidad y el rendimiento " + rubro.errors)
                        render "no_Error al guardar"
                    }else{

                        item.modifica = usuarioActual
                        item.fechaModificacion = new Date()
                        item.save(flush:true)

                        render"ok_Guardado correctamente"
                    }
                }else{
                    "err_Ingrese el rendimiento"
                }
            }else{
                render "err_Ingrese la cantidad"
            }
        }else{
            render "err_No se encontró el registro"
        }
    }

    def rendimientoTodos_ajax(){


        def usuarioActual = Persona.get(session.usuario.id)

        def rubro = Item.get(params.id)
        def items = Rubro.findAllByRubro(rubro)
        def errores = ''

        items.each {

            it.rendimiento = params.rendimiento.toDouble()
            if(!it.save(flush:true)){
                errores += it.errors
            }else{
                errores += ''
            }
        }

        if(errores != ''){
            render "no_Error al guardar el rendimiento"
        }else{

            rubro.modifica = usuarioActual
            rubro.fechaModificacion = new Date()
            rubro.save(flush:true)

            render "ok_Guardado correctamente"
        }
    }


    def infoModifica_ajax(){
        def rubro = Item.get(params.id)
        def sql = "select audtcmpo, audtantr, audtactl, audtfcha from audt " +
                "where audtfcha > '${rubro?.fecha}' and (audtrgid = ${rubro?.id} or audtrgid in " +
                "(select rbro__id from rbro where rbrocdgo = ${rubro?.id})) and " +
                "audtcmpo in ('valor', 'nombre', 'item', 'cantidad', 'rendimiento') order by audtfcha"
        def cn = dbConnectionService.getConnection()
        def res = cn.rows(sql.toString())

        return [res: res]
    }

    def especificaciones_ajax(){

        println("params es"  + params)

        def item = Item.get(params.id)
        def ares = ArchivoEspecificacion.findByCodigo(item.codigoEspecificacion)
        println("ares "  + ares?.id)
        def usuario = Persona.get(session.usuario.id)
        def existeUtfpu = false
        if(usuario.departamento?.codigo == 'CRFC'){
            existeUtfpu = true
        }

        return [item: item, ares: ares, existe: existeUtfpu, tipo: params.tipo]
    }



    def borrarArchivo_ajax(){
        println("params bb " + params)
        def rubro = Item.get(params.id)
        def archivoEspe = ArchivoEspecificacion.findByCodigo(rubro.codigoEspecificacion)

        def old = params.tipo == 'dt' ?  archivoEspe?.ruta : ( params.tipo == 'wd' ?  archivoEspe?.especificacion :rubro?.foto)

        if (old) {
            def oldPath = "/var/janus/" + "rubros/" + old
            def oldFile = new File(oldPath)
            if (oldFile.exists()) {
                oldFile.delete()

                if(params.tipo == 'dt'){
                    archivoEspe.ruta = null
                    archivoEspe.save(flush:true)
                }else{
                    if(params.tipo == 'wd'){
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


    def faltan() {
        def ares = ArchivoEspecificacion.findAllByRutaIsNotNull()
        def extEspecificacion = "", pathEspecificacion = "", cntaexiste = 0, cntafalta = 0, archivo, arch = ""
        def existe = new File('/tmp/existe.csv')
        def falta = new File('/tmp/falta.csv')
        def dir = new File("/var/janus/rubros")
        def busca = ""
        def archivos = [], nombre
        println "ares: ${ares.size()}"

        dir.eachFileRecurse (FileType.FILES) { file ->
            nombre = file.toString()
            if(nombre.contains('.pdf')) {
                nombre = nombre.replaceAll('/var/janus/rubros/', '')
                archivos.add(nombre)
            }
        }

        println "<<<< $archivos"
        println "--${archivos.contains('r_dt_907_24_04_2014_10_43_59.pdf')}"
        println "--${archivos.contains('907')}"

        ares.each { a ->
            arch = ""
//            println "procesa: ${a.item.codigo}"
            if (a?.ruta?.size() > 4) {
//                println "rubro: ${a?.item?.codigo}ruta: ${ares.ruta}"
                extEspecificacion = a.ruta.split("\\.")
                extEspecificacion = extEspecificacion[extEspecificacion.size() - 1]
                pathEspecificacion = "/var/janus/" + "rubros" + File.separatorChar + a?.ruta
//                println "ruta: --> ${a?.ruta} path: ${pathEspecificacion.toLowerCase()}"
                if (pathEspecificacion.toLowerCase().contains("pdf")) {
                    try {
                        archivo = new FileInputStream(pathEspecificacion)
//                        salida.append = "${a.item.codigo},${a.item.nombre},${a.ruta}"
                        existe.append("${a.item.codigo}|${a.item.nombre}|${a.ruta}\n\r")
                        cntaexiste++
                    } catch (e) {
                        busca = a?.ruta.split('_')[2]
                        busca = busca.toString().replaceAll('.pdf', '')
                        archivos.each { ar ->
                            //println l
                            if(ar.toString().indexOf(busca) >= 0) {
                                arch += '|' + ar
                            }
                        }
                        falta.append("${a.item.codigo}|${a.item.nombre}|${a.ruta}|${arch}\n\r")
                        cntafalta++
                    }
                }
            }
        }

        render "existe ${cntaexiste} y falta: ${cntafalta} <hr> Se ha generado los archivos /tmp/existe.csv y falta.csv " +
                "utilizando '|' como separador CSV"
    }

    def listarArchivos() {
        File[] archivos
        def ruta = '/var/janus/rubros'
        File carpeta = new File(ruta)
        if(carpeta.exists()) {
            if(carpeta.isDirectory()) {
                archivos = carpeta.listFiles()
                for(int i=0; i<archivos.length; i++) {
                    if(i<100){
                        println "${archivos[i].getName()}"
                        println "${archivos[i].getName().endsWith('pdf')}"
                    }
                }
            }
        }
        println "se han halla ${archivos.size()} archivos en la carpeta: $ruta"
        render "se han hallado ${archivos.size()} archivos en la carpeta: $ruta"
    }

    def codigoEspecificacion_ajax(){
        def rubro = Item.get(params.id)
        return [rubro: rubro]
    }

    def guardarCodigoEspecificacion_ajax(){
        def rubro = Item.get(params.id)
        rubro.codigoEspecificacion = params.codigo

        if(!rubro.save(flush:true)){
            println("error al guardar el código " + rubro.errors)
            render "no_Error al guardar el código"
        }else{
            render "ok_Código guardado correctamente"
        }
    }


    def verificarEspecificacion(){
        def tipo = TipoItem.get(2)
        def rubros = Item.findAllByTipoItem(tipo)
        def ares = ArchivoEspecificacion.findAllByItemInList(rubros).sort{it.item.id}
        def pdfs = []
        def noPdfs = []
        def borrarPdfs = []
        def todosPdfs = []
        def words = []
        def noWords = []
        def borrarWords = []
        def todosWords = []
        def imagenes = []
        def noImagenes = []
        def borrarImagenes = []
        def todasImagenes = []
        def pathOriginal = "/var/janus/rubros/"
        def dir = new File("/var/janus/rubros")

        ares.each {
            def path = pathOriginal + it?.ruta
            def file = new File(path)
            if(file.exists()){
                pdfs.add(it)
            }else{
                noPdfs.add(it)
            }
        }

        ares.each {
            def path = pathOriginal + it?.especificacion
            def file = new File(path)
            if(file.exists()){
                words.add(it)
            }else{
                noWords.add(it)
            }
        }

        rubros.each {
            def path = pathOriginal + it?.foto
            def file = new File(path)
            if(file.exists()){
                imagenes.add(it)
            }else{
                noImagenes.add(it)
            }
        }

        dir.eachFileRecurse (FileType.FILES) { file ->
            def nombre = file.toString()
            if(nombre.contains('.png') || nombre.contains('.jpg') || nombre.contains('.jpeg') || nombre.contains('.gif')) {
                nombre = nombre.replaceAll('/var/janus/rubros/', '')
                todasImagenes.add(nombre)
            }

            if(nombre.contains('.pdf')) {
                nombre = nombre.replaceAll('/var/janus/rubros/', '')
                todosPdfs.add(nombre)
            }

            if(nombre.contains('.doc') || nombre.contains('.docx')) {
                nombre = nombre.replaceAll('/var/janus/rubros/', '')
                todosWords.add(nombre)
            }

        }

        todosPdfs.each {
            if(!pdfs?.ruta?.contains(it)){
                borrarPdfs.add(it)
            }
        }

        todosWords.each {
            if(!words?.especificacion?.contains(it)){
                borrarWords.add(it)
            }
        }

        todasImagenes.each {
            if(!imagenes?.foto?.contains(it)){
                borrarImagenes.add(it)
            }
        }

        return [especificaciones: ares, imagenes: imagenes, noImagenes: noImagenes, borrarImagenes: borrarImagenes, pdfs: pdfs, noPdfs: noPdfs, borrarPdfs: borrarPdfs, words: words, noWords: noWords, borrarWords: borrarWords]
    }

    def borrarArchivoFisico_ajax(){
        def tipo = TipoItem.get(2)
        def rubros = Item.findAllByTipoItem(tipo)
        def ares = ArchivoEspecificacion.findAllByItemInList(rubros).sort{it.item.id}
        def pdfs = []
        def noPdfs = []
        def borrarPdfs = []
        def todosPdfs = []
        def words = []
        def noWords = []
        def borrarWords = []
        def todosWords = []
        def imagenes = []
        def noImagenes = []
        def borrarImagenes = []
        def todasImagenes = []
        def pathOriginal = "/var/janus/rubros/"
        def dir = new File("/var/janus/rubros")
        def texto = ''

        ares.each {
            def path = pathOriginal + it?.ruta
            def file = new File(path)
            if(file.exists()){
                pdfs.add(it)
            }else{
                noPdfs.add(it)
            }
        }

        ares.each {
            def path = pathOriginal + it?.especificacion
            def file = new File(path)
            if(file.exists()){
                words.add(it)
            }else{
                noWords.add(it)
            }
        }

        rubros.each {
            def path = pathOriginal + it?.foto
            def file = new File(path)
            if(file.exists()){
                imagenes.add(it)
            }else{
                noImagenes.add(it)
            }
        }

        dir.eachFileRecurse (FileType.FILES) { file ->
            def nombre = file.toString()
            if(nombre.contains('.png') || nombre.contains('.jpg') || nombre.contains('.jpeg')) {
                nombre = nombre.replaceAll('/var/janus/rubros/', '')
                todasImagenes.add(nombre)
            }

            if(nombre.contains('.pdf')) {
                nombre = nombre.replaceAll('/var/janus/rubros/', '')
                todosPdfs.add(nombre)
            }

            if(nombre.contains('.doc') || nombre.contains('.docx')) {
                nombre = nombre.replaceAll('/var/janus/rubros/', '')
                todosWords.add(nombre)
            }
        }


        switch (params.tipo) {
            case "pdf":
                todosPdfs.each {
                    if(!pdfs?.ruta?.contains(it)){
                        println("--- " + it)
                        def path = pathOriginal + it
                        def file = new File(path)
                        file.delete()
                    }
                }

                texto = "ok_Pdfs borrados correctamente"

                break;
            case "word":
                todosWords.each {
                    if(!words?.especificacion?.contains(it)){
                        def path = pathOriginal + it
                        def file = new File(path)
                        file.delete()
                    }
                }
                texto = "ok_Words borrados correctamente"
                break;
            case "imas":
                todasImagenes.each {
                    if(!imagenes?.foto?.contains(it)){
                        def path = pathOriginal + it
                        def file = new File(path)
                        file.delete()
                    }
                }
                texto = "ok_Imagenes borradas correctamente"
                break;
        }

        render texto
    }

} //fin controller
