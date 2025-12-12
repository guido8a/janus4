package janus.oferentes

import janus.*
import org.apache.poi.xssf.usermodel.XSSFCell
import org.apache.poi.xssf.usermodel.XSSFRow
import org.apache.poi.xssf.usermodel.XSSFSheet
import org.apache.poi.xssf.usermodel.XSSFWorkbook
import org.springframework.dao.DataIntegrityViolationException
import seguridad.Persona

class RubroOfController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def buscadorService
    def preciosService
    def dbConnectionService

    def gruposPorClase() {
        def clase = Grupo.get(params.id)
        def grupos = SubgrupoItems.findAllByGrupo(clase)
        def sel = g.select(id: "selGrupo", name: "rubro.suggrupoItem.id", from: grupos, "class": "span12", optionKey: "id", optionValue: "descripcion", noSelection: ["": "--Seleccione--"])
        def js = "<script type='text/javascript'>"
        js += '$("#selGrupo").change(function () {'
        js += 'var grupo = $(this).val();'
        js += '$.ajax({'
        js += 'type    : "POST",'
        js += 'url     : "' + createLink(action: 'subgruposPorGrupo') + '",'
        js += 'data    : {'
        js += 'id : grupo'
        js += '},'
        js += 'success : function (msg) {'
        js += '$("#selSubgrupo").replaceWith(msg);'
        js += '}'
        js += '});'
        js += '});'
        js += "</script>"
        render sel + js
    }

    def subgruposPorGrupo() {
        def grupo = SubgrupoItems.get(params.id)
        def subgrupos = DepartamentoItem.findAllBySubgrupo(grupo)
        def sel = g.select(id: "selSubgrupo", name: "rubro.departamento.id", from: subgrupos, "class": "span12", optionKey: "id", optionValue: "descripcion", noSelection: ["": "--Seleccione--"])
        render sel
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

    def rubroPrincipalOf() {
        println("params  " + params)
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

        def rubro
        def campos = ["codigo": ["Código", "string"], "nombre": ["Descripción", "string"]]
        def grupos = []
        def volquetes = []
        def choferes = []
        def aux = Parametros.get(1)
        def grupoTransporte = DepartamentoItem.findAllByTransporteIsNotNull()
//        def obra = Obra.findByOferente(session.usuario)
        def listaRbro = [1: 'Materiales', 2: 'Mano de obra', 3: 'Equipos']
        def listaItems = [1: 'Nombre', 2: 'Código']

        grupoTransporte.each {
            if (it.transporte.codigo == "H")
                choferes = Item.findAllByDepartamento(it)
            if (it.transporte.codigo == "T")
                volquetes = Item.findAllByDepartamento(it)
        }
        grupos.add(Grupo.get(4))
        grupos.add(Grupo.get(5))
        grupos.add(Grupo.get(6))
        def obra
        if (params.idRubro) {
            obra = Obra.get(params.obra)
            rubro = Item.get(params.idRubro)
            def items = RubroOferente.findAllByRubroAndObra(rubro, obra)
            items.sort { it.item.codigo }
            println "items: ${items.id} ${items.item.id} rend: ${items.rendimiento}"
            [campos  : campos, listaRbro: listaRbro, listaItems: listaItems, rubro: rubro, grupos: grupos, items: items,
             choferes: choferes, volquetes: volquetes, aux: aux, obra: obra, obras: obras]
        } else {
            [campos   : campos, listaRbro: listaRbro, listaItems: listaItems, grupos: grupos, choferes: choferes,
             volquetes: volquetes, aux: aux, obra: obra, obras: obras]
        }
    }

    def getDatosItem() {
//        println "get datos items "+params
        def item = Item.get(params.id)
        def precio = Precio.findByItemAndPersona(item, session.usuario)
//        println "render "+  item.id + "&" + item.codigo + "&" + item.nombre + "&" + item.unidad.codigo + "&" + item.rendimiento+"&"+((item.tipoLista)?item.tipoLista?.id:"0")
        render "" + item.id + "&" + item.codigo + "&" + item.nombre + "&" + item.unidad?.codigo?.trim() + "&" +
                item.rendimiento + "&" + ((item.tipoLista) ? item.tipoLista?.id : "0") + "&" +
                item.departamento.subgrupo.grupo.id + "&" + ((precio) ? precio.precio : "1")
    }

    def addItem() {
        println "addItem $params"
        def obra = Obra.get(params.obra)
        def rubro = Item.get(params.rubro)
        def item = Item.get(params.item)
        def oferente = seguridad.Persona.get(session.usuario.id)
        def detalle
        def existe
        existe = RubroOferente.findByItemAndRubroAndObra(item, rubro, obra)
        if (!existe){
            detalle = new RubroOferente()
        }else{
            detalle = existe
        }

        detalle.obra = obra
        detalle.oferente = oferente
        detalle.rubro = rubro
        detalle.item = item
        detalle.cantidad = params.cantidad.toDouble()
        if (detalle.item.id.toInteger() == 2868 || detalle.item.id.toInteger() == 2869 || detalle.item.id.toInteger() == 2870) {
            detalle.cantidad = 1
            if (detalle.item.id.toInteger() == 2868)
                detalle.rendimiento = 1
            if (detalle.item.id.toInteger() == 2869)
                detalle.rendimiento = 1
            if (detalle.item.id.toInteger() == 2870)
                detalle.rendimiento = 1
        } else {
            detalle.rendimiento = params.rendimiento.toDouble()
        }
        if (detalle.item.departamento.subgrupo.grupo.id == 2)
            detalle.cantidad = Math.ceil(detalle.cantidad)
        detalle.fecha = new Date()
        if (detalle.item.departamento.subgrupo.grupo.id == 1)
            detalle.rendimiento = 1

        println "antes de grabar: ${detalle.cantidad}"

        if (!detalle.save(flush: true)) {
            println "detalle " + detalle.errors
        } else {

            rubro.fechaModificacion = new Date()

            if(rubro.save(flush: true)){
                def precio = Precio.findByItemAndOferenteAndObra(item, session.usuario, obra)
                if (!precio) {
                    precio = new Precio()
                    precio.item = item
                    precio.oferente = oferente
                    precio.fecha = new Date()
                    precio.obra = obra
                }
                precio.precio = params.precio.toDouble()
                precio.vae = params.vae.toDouble()
                if (precio.save(flush: true)){
                    render "" + item.departamento.subgrupo.grupo.id + ";" + detalle.id + ";" + detalle.item.id + ";" +
                            detalle.cantidad + ";" + detalle.rendimiento + ";" + ((item.tipoLista) ? item.tipoLista?.id : "0")
                }else{
                    println("error al gudardar el precio " + precio.errors)
                }
            }else{
                println("error al gudardar el rubro " + rubro.errors)
            }
        }
    }

    def getPrecioOferente() {
//        println "get precio of "+params
        def item = Item.get(params.id)
        def precio = 0
        def vae = 100
        def tmp = Precio.findByItemAndPersona(item, session.usuario)
        if (tmp) {
            precio = tmp.precio
            vae = tmp.vae
        }

        render "" + precio + "_" + vae
    }

    def buscaItem() {
//        println "busca item "+params
        def listaTitulos = ["Código", "Descripción"]
        def listaCampos = ["codigo", "nombre"]
        def funciones = [null, null]
        def url = g.createLink(action: "buscaItem", controller: "rubro")
        def funcionJs = "function(){"
        funcionJs += 'var idReg = $(this).attr("regId");'
        funcionJs += '$.ajax({type: "POST",url: "' + g.createLink(controller: 'rubro', action: 'getDatosItem') + '",'
        funcionJs += ' data: "id="+idReg,'
        funcionJs += ' success: function(msg){'
        funcionJs += 'var parts = msg.split("&");'
        funcionJs += ' $("#item_id").val(parts[0]);'
        funcionJs += ' $("#item_id").attr("tipo",parts[6]);'
        funcionJs += '$("#cdgo_buscar").val(parts[1]);'
        funcionJs += '$("#item_desc").val(parts[2]);'
        funcionJs += '$("#item_unidad").val(parts[3]);'
        funcionJs += '$("#item_tipoLista").val(parts[5]);'
        funcionJs += '$("#modal-rubro").modal("hide");'
        funcionJs += '$("#item_precio").val(parts[7]);'
        funcionJs += '}'
        funcionJs += '});'
        funcionJs += '}'
        def numRegistros = 20

        def tipo = params.tipo
        def extras = " and tipoItem = 1 "
//        println "extras "+extras

        if (!params.reporte) {
            def lista = buscadorService.buscar(Item, "Item", "excluyente", params, true, extras)
            /* Dominio, nombre del dominio , excluyente o incluyente ,params tal cual llegan de la interfaz del buscador, ignore case */
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

        def listaTitulos = ["Código", "Descripción", "Unidad"]
        def listaCampos = ["codigo", "nombre", "unidad"]
        def funciones = [null, null]
        def url = g.createLink(action: "buscaRubro", controller: "rubro")
        def funcionJs = "function(){"
        funcionJs += '$("#modal-rubro").modal("hide");'
        funcionJs += 'location.href="' + g.createLink(action: 'rubroPrincipal', controller: 'rubro') + '?idRubro="+$(this).attr("regId");'
        funcionJs += '}'
        def numRegistros = 20
        def extras = " and tipoItem = 2 and persona = ${session.usuario.id}"
        if (!params.reporte) {
            def lista = buscadorService.buscar(Item, "Item", "excluyente", params, true, extras)
            /* Dominio, nombre del dominio , excluyente o incluyente ,params tal cual llegan de la interfaz del buscador, ignore case */
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

    def buscaRubroComp() {
        def listaTitulos = ["Código", "Descripción"]
        def listaCampos = ["codigo", "nombre"]
        def funciones = [null, null]
        def url = g.createLink(action: "buscaRubro", controller: "rubro")
        def funcionJs = "function(){"
        funcionJs += 'if($("#rubro__id").val()*1>0){ '
        funcionJs += '   if(confirm("Esta seguro?")){'
        funcionJs += '        var idReg = $(this).attr("regId");'
        funcionJs += '        var datos="rubro="+$("#rubro__id").val()+"&copiar="+idReg;'
        funcionJs += '       $.ajax({type: "POST",url: "' + g.createLink(controller: 'rubro', action: 'copiarComposicion') + '",'
        funcionJs += '            data: datos, '
        funcionJs += '            success: function(msg){ '
        funcionJs += '            $("#modal-rubro").modal("hide");'
        funcionJs += '               window.location.reload(true) '
        funcionJs += '           }   '
        funcionJs += '        });'
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
        def extras = " and tipoItem = 2"
        if (!params.reporte) {
            def lista = buscadorService.buscar(Item, "Item", "excluyente", params, true, extras)
            /* Dominio, nombre del dominio , excluyente o incluyente ,params tal cual llegan de la interfaz del buscador, ignore case */
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
        rubro.properties = params.rubro
        rubro.tipoItem = TipoItem.get(2)
        rubro.persona = Persona.get(session.usuario.id)
//        println "ren " + rubro.rendimiento
        if (!rubro.save(flush: true)) {
            println "error " + rubro.errors
        }

        redirect(action: 'rubroPrincipal', params: [idRubro: rubro.id])
    } //save

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
//        println "eliminarRubroDetalle "+params
        if (request.method == "POST") {
            def rubro = RubroOferente.get(params.id)
            try {
                rubro.delete(flush: true)
                render "Registro eliminado correctamente"
            }
            catch (DataIntegrityViolationException e) {
                render "No se pudo eliminar el rubro"
            }
        } else {
            response.sendError(403)
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
        println "get precios sin item " + params
        def items = []
        def parts = params.ids.split("#")
        def obra = Obra.get(params.obra)
        def res = ""
        parts.each {
            if (it.size() > 0) {
                def item = RubroOferente.get(it).item
                def precio = Precio.findByItemAndOferenteAndObra(item, session.usuario, obra)
                println("precio " + precio)
                if (!precio) {
                    res += item.id + ";0&"
                } else {
                    res += item.id + ";" + precio.precio + "&"
                }
            }
        }
        render res
    }

    def getPreciosItem() {
        def items = []
        def parts = params.ids.split("#")
        def res = ""
        parts.each {
            if (it.size() > 0) {
                def item = Item.get(it)
                def precio = Precio.findByItemAndPersona(item, session.usuario)
                if (!precio) {
                    res += item.id + ";0&"
                } else {
                    res += item.id + ";" + precio.precio + "&"
                }
            }
        }
        render res
    }

    def getPreciosTransporte() {
//        println "get precios "+params
        def lugar = Lugar.get(params.ciudad)
        def fecha = new Date().parse("dd-MM-yyyy", params?.fecha)
        def tipo = params.tipo
        def items = []
        def parts = params.ids.split("#")
        parts.each {
            if (it.size() > 0)
                items.add(Item.get(it))
        }
        def precios = preciosService.getPrecioItemsString(fecha, lugar, items)
//        println "precios transporte " + precios
        render precios
    }


    def buscarRubroCodigo() {
//        println "buscar rubro "+params
        def rubro = Item.findByCodigoAndTipoItem(params.codigo?.trim(), TipoItem.get(1))
        if (rubro) {
            render "" + rubro.id + "&&" + rubro.tipoLista?.id + "&&" + rubro.nombre + "&&" + rubro.unidad?.codigo
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
        def parametros = "" + idRubro + ",'" + fecha.format("yyyy-MM-dd") + "'," + listas + "," + params.dsp0 + "," + params.dsp1 + "," + params.dsv0 + "," + params.dsv1 + "," + params.dsv2 + "," + params.chof + "," + params.volq
//        println "paramtros " +parametros
        def res = preciosService.rb_precios(parametros, "")

        def tabla = '<table class="table table-bordered table-striped table-condensed table-hover"> '
        def total = 0
        tabla += "<thead><tr><th colspan=8>Transporte</th></tr><tr><th style='width: 80px;'>Código</th><th style='width:610px'>Descripción</th><th>Peso</th><th>Vol.</th><th>Cantidad</th><th>Distancia</th><th>Unitario</th><th>C.Total</th></thead><tbody>"
//        println "rends "+rendimientos

//        println "res "+res
        res.each { r ->
            if (r["parcial_t"] > 0) {
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

//        println("entro:" + params)

        def rubro = Item.get(params.id)
        def tipo = params.tipo

        def filePath
        def titulo
        switch (tipo) {
            case "il":
                titulo = "Ilustración"
                filePath = rubro.foto
                break;
            case "dt":
                titulo = "Especificaciones"
                filePath = rubro.especificaciones
                break;
        }

        def ext = ""

        if (filePath) {
            ext = filePath.split("\\.")
            ext = ext[ext.size() - 1]
        }
        return [rubro: rubro, ext: ext, tipo: tipo, titulo: titulo, filePath: filePath]
    }

    def downloadFile() {
        def rubro = Item.get(params.id)

        def ext = rubro.foto.split("\\.")
        ext = ext[ext.size() - 1]
        def folder = "rubros"
        def path = servletContext.getRealPath("/") + folder + File.separatorChar + rubro.foto

        def file = new File(path)
        def b = file.getBytes()
        response.setContentType(ext == 'pdf' ? "application/pdf" : "image/" + ext)
        response.setHeader("Content-disposition", "attachment; filename=" + rubro.foto)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def uploadFile() {
//        println "upload "+params

        def acceptedExt = ["jpg", "png", "gif", "jpeg", "pdf"]

        def path = servletContext.getRealPath("/") + "rubros/"   //web-app/rubros
        new File(path).mkdirs()
        def rubro = Item.get(params.rubro)
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
                fileName = "r_" + rubro.id + "_" + ahora.format("dd_MM_yyyy_hh_mm_ss")
                fileName = fileName + "." + ext
                def pathFile = path + fileName
                def file = new File(pathFile)
                f.transferTo(file)

                def old = rubro.foto
                if (old && old.trim() != "") {
                    def oldPath = servletContext.getRealPath("/") + "rubros/" + old
                    def oldFile = new File(oldPath)
                    if (oldFile.exists()) {
                        oldFile.delete()
                    }
                }

                rubro.foto = /*g.resource(dir: "rubros") + "/" + */ fileName
                rubro.save(flush: true)
            } else {
                flash.clase = "alert-error"
                flash.message = "Error: Los formatos permitidos son: JPG, JPEG, GIF, PNG y PDF"
            }
        } else {
            flash.clase = "alert-error"
            flash.message = "Error: Seleccione un archivo JPG, JPEG, GIF, PNG ó PDF"
        }
        redirect(action: "showFoto", id: rubro.id)
    }


    def listaRubros() {
        println "listaItems" + params
        def datos;
        def listaRbro = ['grpo__id', 'grpo__id', 'grpo__id']
        def listaItems = ['itemnmbr', 'itemcdgo']

        def select = "select item.item__id, itemnmbr, itemcdgo, unddcdgo " +
                "from item, undd, dprt, sbgr "
        def txwh = "where tpit__id = 2 and undd.undd__id = item.undd__id and dprt.dprt__id = item.dprt__id and " +
                "sbgr.sbgr__id = dprt.sbgr__id and item.item__id in (select item__id from vlof, obra, obof " +
                "where obof.prsn__id =  ${session.usuario.id} and obra.obra__id = obof.obra__id and " +
                "obratipo in ('F', 'O') and vlof.obra__id = obra.obra__id and obra.obra__id = ${params.obra} ) "
        def sqlTx = ""
//        def item = listaRbro[params.buscarTipo.toInteger()-1]
        def bsca = listaItems[params.buscarPor.toInteger() - 1]
        def ordn = listaRbro[params.ordenar.toInteger() - 1]

        txwh += " and $bsca ilike '%${params.criterio}%'"
        sqlTx = "${select} ${txwh} order by ${ordn} limit 100 ".toString()
        println "sql: $sqlTx"

        def cn = dbConnectionService.getConnection()
        datos = cn.rows(sqlTx)
//        println "data: ${datos[0]}"
        [data: datos, tipo: params.tipo, rubro: params.rubro, obra_id: params.obra]
    }

    def buscadorItemsOferente_ajax() {

    }

//    def copiarComposicion() {
//        if (request.method == "POST") {
//            def rubro = Item.get(params.rubro)
//            def copiar = Item.get(params.copiar)
//            def detalles = Rubro.findAllByRubro(copiar)
//            detalles.each {
//                def tmp = Rubro.findByRubroAndItem(rubro, it.item)
//                if (!tmp) {
//                    def nuevo = new Rubro()
//                    nuevo.rubro = rubro
//                    nuevo.item = it.item
//                    nuevo.cantidad = it.cantidad
//                    nuevo.fecha = new Date()
//                    if (!nuevo.save(flush: true))
//                        println "Error: copiar composicion " + nuevo.errors
//
//                }
//            }
//            rubro.fechaModificacion = new Date()
//            rubro.save(flush: true)
//            render "ok"
//        } else {
//            response.sendError(403)
//        }
//    }


    def copiarComposicion() {
        println "copiar OF!!! " + params + "  " + request.method
//        if (request.method == "POST") {
        def rubro = Item.get(params.rubro)
        def copiar = Item.get(params.copiar)
        def detalles = RubroOferente.findAllByRubro(copiar)
        def persona = seguridad.Persona.get(session.usuario.id)

        detalles.each {
            println "" + it.item.departamento.subgrupo.grupo.descripcion + "  " + it.item.departamento.subgrupo.grupo.codigo
            def tmp = RubroOferente.findByRubroAndItem(rubro, it.item)
            println "rubro --> $tmp"
            if (!tmp) {
//                    println "no temnp "
                def nuevo = new RubroOferente()
                nuevo.rubro = rubro
                nuevo.item = it.item
                nuevo.oferente = persona
//                    println " asd "  +it.item.nombre

                if (it.item.departamento.subgrupo.grupo.id.toInteger() == 1) {
                    nuevo.cantidad = it.cantidad
                } else {
                    if (!(it.item.nombre =~ "HERRAMIENTA MENOR")) {
                        nuevo.rendimiento = it.rendimiento
                        nuevo.cantidad = it.cantidad
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
//                        println "entro 2 "
                    if (it.item.departamento.subgrupo.grupo.id.toInteger() == 2) {
                        //println "es mano de obra"
                        def maxCant = Math.max(tmp.cantidad, it.cantidad)
                        def sum = tmp.cantidad * tmp.rendimiento + (it.cantidad * it.rendimiento)
                        //println "maxcant "+maxCant+" sum "+sum
                        def rend = sum / maxCant
                        tmp.cantidad = maxCant
                        tmp.rendimiento = rend
                        tmp.fecha = new Date()
                        tmp.save(flush: true)


                    } else {
                        if (it.item.departamento.subgrupo.grupo.id.toInteger() == 3) {
                            //println "es mano de obra"
                            def maxCant = Math.max(tmp.cantidad, it.cantidad)
                            def sum = tmp.cantidad * tmp.rendimiento + (it.cantidad * it.rendimiento)
                            //println "maxcant "+maxCant+" sum "+sum
                            def rend = sum / maxCant
                            tmp.cantidad = maxCant
                            tmp.rendimiento = rend
                            tmp.fecha = new Date()
                            tmp.save(flush: true)
                        } else {
                            tmp.cantidad = tmp.cantidad + it.cantidad
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

    def listaItem() {
        println "listaItem" + params
        def listaItems = ['itemnmbr', 'itemcdgo']
        def datos;
        def usuario = seguridad.Persona.get(session.usuario.id)
        def empresa = Parametros.get('1').empresa

        def select = "select * from lsta_itemof(${usuario.id}, ${params.grupo}) "
        def txwh = " where itemnmbr is not null  "

        def sqlTx = ""
        def bsca = listaItems[params.buscarPor.toInteger() - 1]
        def ordn = listaItems[params.ordenar.toInteger() - 1]
        txwh += " and $bsca ilike '%${params.criterio}%' and grpo__id = ${params.grupo}"

        sqlTx = "${select} ${txwh} order by ${ordn} limit 100 ".toString()
        println "sql: $sqlTx"

        def cn = dbConnectionService.getConnection()
        datos = cn.rows(sqlTx)
        println "data: ${datos[0]}"
        [data: datos]
    }


    def subirExcel() {
        def oferente = session.usuario
        def cn = dbConnectionService.getConnection()
        def obras = [:]
        def sql = "select distinct obra.obra__id id, obracdgo||' - '||obranmbr nombre " +
                "from obra, obof " +
                "where obof.obra__id = obra.obra__id and obof.prsn__id = ${oferente.id} " +
                "order by 1"
        println "sql: $sql"
        cn.eachRow(sql.toString()) { r ->
            obras[r.id] = r.nombre
        }
        [obras: obras, oferente: oferente]
    }

    def subirExcelApu() {
        def oferente = session.usuario
        def cn = dbConnectionService.getConnection()
        def obras = [:]
        def sql = "select distinct obra.obra__id id, obracdgo||' - '||obranmbr nombre " +
                "from obra, obof " +
                "where obof.obra__id = obra.obra__id and obof.prsn__id = ${oferente.id} " +
                "order by 1"
//        println "sql: $sql"
        cn.eachRow(sql.toString()) { r ->
            obras[r.id] = r.nombre
        }

        [obras: obras, oferente: oferente, tipo: params.tipo]
    }

    def uploadApus() {
        println "uploadApus $params"
//        params.obra = 4255
        def obra = params.obra
        def cn = dbConnectionService.getConnection()
        def filasNO = [0, 1]
        def filasTodasNo = []
        def oferente = session.usuario
        def path = "/var/janus/" + "xlsOfertas/" + params.obra + "/"   //web-app/archivos
        new File(path).mkdirs()
        def sql = ""
        def cols = [A: 0, B: 1, C: 2, D: 3, E: 4, F: 5, G: 6, H: 7, I: 8, J: 9, K: 10, L: 11, M: 12, N: 13]
        def rbronmbr = "", rbroundd = ""

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

            if (ext == "xlsx") {

                fileName = "xlsApus_" + params.obra

                def fn = fileName
                fileName = fileName + "." + ext

                def pathFile = path + fileName
                def src = new File(pathFile)

                def i = 1
                while (src.exists()) {
                    pathFile = path + fn + "_" + i + "." + ext
                    src = new File(pathFile)
                    i++
                }

                f.transferTo(new File(pathFile)) // guarda el archivo subido al nuevo path

                //procesar excel
                def htmlInfo = "", errores = "", doneHtml = "", done = 0
                InputStream ExcelFileToRead = new FileInputStream(pathFile);
                XSSFWorkbook workbook = new XSSFWorkbook(ExcelFileToRead);

                XSSFRow row;
                XSSFCell cell;

                int hojas = workbook.getNumberOfSheets(); //Obtenemos el número de hojas que contiene el documento
//                int hojas = 3
                println "Número Hojas: $hojas"

                def sccnEq = false, sccnMo = false, sccnMt = false, sccnTr = false, sccnRubro = false
                def cdgo, nmbr, undd, peso, cntd, trfa, pcun, rndm, csto, dstn
                def tipo = ""

                //for que recorre las hojas existentes
                for (int hj = 1; hj < hojas; hj++) {
                    XSSFSheet sheet = workbook.getSheetAt(hj);
                    sheet = workbook.getSheetAt(hj);
                    def ordn = sheet.getSheetName().toString().toInteger()
                    Iterator rows = sheet.rowIterator();
                    println "Porcesando hoja: $hj --> $ordn"

                    def fila = 0
                    while (rows.hasNext() && (fila < 76)) {
                        row = (XSSFRow) rows.next()
                        if (!(row.rowNum in filasNO)) {
                            def ok = true
                            cdgo = ''; nmbr = ''; undd = ''; cntd = 0; trfa = 0; pcun = 0; rndm = 0; csto = 0; peso = 0;
                            dstn = 0
                            Iterator cells = row.cellIterator()
                            def rgst = []
                            def meses = []
                            println "fila: ${row.rowNum}"
                            while (cells.hasNext()) {
                                cell = (XSSFCell) cells.next()
                                if (row.rowNum == 57) {
                                    println "Cell: ${cell.getCellType()} ${cell.getRawValue()}"
                                }
                                if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
                                    rgst.add(cell.getNumericCellValue())
                                } else if (cell.getCellType() == XSSFCell.CELL_TYPE_STRING) {
                                    rgst.add(cell.getStringCellValue())
                                } else if (cell.getCellType() == XSSFCell.CELL_TYPE_FORMULA) {
//                                    rgst.add(cell.getNumericCellValue())
                                    rgst.add(cell.getRawValue())
                                } else {
                                    rgst.add('')
                                }
                            }

//                            println "reg: $rgst"

                            /** va antes que ssnRbro = true porque se analiza en la siguiente pasada **/
                            if (sccnRubro) {
                                rbroundd = rgst[cols[params.rbroundd]]
                                sccnEq = false; sccnMo = false; sccnMt = false; sccnTr = false; sccnRubro = false
//                                println "Rubro: $rbronmbr $rbroundd"
                                /** insertar rubro */
                                if (rbroundd) {
                                    rbronmbr = rbronmbr.toString().replaceAll("'", "''")
                                    sql = "select item__id from vlof where obra__id = ${params.obra} and vlofordn = ${ordn}"
                                    def item_id = cn.rows(sql.toString())[0]?.item__id
                                    if (!item_id) {
                                        errores += "<li>No se encontró rurbo ${ordn} (linea: ${row.rowNum + 1})</li>"
                                        println "No se encontró rubro con id ${ordn}"
                                        ok = false
                                    } else {
                                        sql = "select ofrb__id from ofrb where prsn__id = ${oferente.id} and " +
                                                "obra__id = ${params.obra} and ofrbordn = ${ordn} and ofrbjnid = $item_id"
                                        def ofrb_id = cn.rows(sql.toString())[0]?.ofrb__id ?: 0
                                        if (ofrb_id) {
                                            sql = "update ofrb set ofrbnmbr = '${rbronmbr}', ofrbundd = '${rbroundd}' " +
                                                    "where ofrb__id = ${ofrb_id}"
                                        } else {
                                            sql = "insert into ofrb(prsn__id, obra__id, ofrbnmbr, ofrbundd, ofrbordn, ofrbjnid) " +
                                                    "values (${oferente.id}, ${params.obra}, '${rbronmbr}', '${rbroundd}', " +
                                                    "$ordn, $item_id)"
                                        }
                                        println "sql: $sql"
                                        try {
                                            cn.execute(sql.toString())
                                        } catch (e) {
                                            println " no se pudo guardar $rgst: ${e.erros()}"
                                        }
                                    }
                                }
                            }

                            if (rgst[cols[params.cldarbro]] == params.rbro) {
                                rbronmbr = rgst[cols[params.rbronmbr]]
                                sccnRubro = true
                                println "Rubro: $rbronmbr"
                            }

                            /** --------------- Equipos del rbro ordn ---------------**/
                            if (rgst[cols[params.cldaEq]] == params.titlEq) {
                                sccnEq = true; sccnMo = false; sccnMt = false; sccnTr = false; sccnRubro = false
//                                println "Equipos..... $sccnEq --> rbro: $ordn $rbronmbr"
                            }
                            if (sccnEq) {
//                                cdgo, undd, nmbr, cntd, trfa, pcun, rndm, csto
                                try {
                                    cdgo = rgst[cols[params.cdgoEq]]
                                    nmbr = rgst[cols[params.nmbrEq]]
                                    undd = params.unddEq ? rgst[cols[params.unddEq]] : ''
                                    cntd = rgst[cols[params.cntdEq]].toDouble() //cantidad
                                    trfa = rgst[cols[params.trfaEq]].toDouble() //tarifa, jornal dtrbpcun
                                    pcun = rgst[cols[params.pcunEq]].toDouble() //costo
                                    rndm = rgst[cols[params.rndmEq]] ? rgst[cols[params.rndmEq]].toDouble() : 1
                                    csto = rgst[cols[params.cstoEq]].toDouble()
                                } catch (e) {
                                    cntd = 0
                                }
                                if (cntd && sccnEq) {
//                                    insertaDtrb(oferente, obra, ordn, cdgo, nmbr, undd, cntd, trfa, pcun, rndm, csto, tipo) {
                                    errores += insertaDtrb(oferente.id, obra, ordn, cdgo, nmbr, undd, cntd, trfa, pcun, rndm, csto, "EQ")
                                }
                            }

                            /** --------------- Mano de Obra del rbro ordn ---------------**/
                            if (rgst[cols[params.cldaMo]] == params.titlMo) {
                                sccnEq = false; sccnMo = true; sccnMt = false; sccnTr = false; sccnRubro = false
//                                println "Mano de Obra.... $sccnMo --> rbro: $ordn $rbronmbr"
                            }
                            if (sccnMo) {
//                                cdgo, undd, nmbr, cntd, trfa, pcun, rndm, csto
                                try {
                                    cdgo = rgst[cols[params.cdgoMo]]
                                    nmbr = rgst[cols[params.nmbrMo]]
                                    undd = params.unddMo ? rgst[cols[params.unddMo]] : ''
                                    cntd = rgst[cols[params.cntdMo]].toDouble() //cantidad
                                    trfa = rgst[cols[params.trfaMo]].toDouble() //tarifa, jornal dtrbpcun
                                    pcun = rgst[cols[params.pcunMo]].toDouble() //costo
                                    rndm = rgst[cols[params.rndmMo]].toDouble()
                                    csto = rgst[cols[params.cstoMo]].toDouble()
                                } catch (e) {
                                    cntd = 0
                                }
                                if (cntd && sccnMo) {
                                    errores += insertaDtrb(oferente.id, obra, ordn, cdgo, nmbr, undd, cntd, trfa, pcun, rndm, csto, "MO")
                                }
                            }

                            /** --------------- Materiales del rbro ordn ---------------**/
                            if (rgst[cols[params.cldaMt]] == params.titlMt) {
                                sccnEq = false; sccnMo = false; sccnMt = true; sccnTr = false; sccnRubro = false
//                                println "Mano de Mat... $sccnMt --> rbro: $ordn $rbronmbr"
                            }
                            if (sccnMt) {
//                                cdgo, undd, nmbr, cntd, trfa, pcun, rndm, csto
                                try {
                                    cdgo = rgst[cols[params.cdgoMt]]
                                    nmbr = rgst[cols[params.nmbrMt]]
                                    undd = params.unddMt ? rgst[cols[params.unddMt]] : ''
                                    cntd = rgst[cols[params.cntdMt]].toDouble() //cantidad
//                                    trfa = rgst[cols[params.trfaMt]].toDouble() //tarifa, jornal dtrbpcun
                                    pcun = rgst[cols[params.pcunMt]].toDouble() //costo
//                                    rndm = rgst[cols[params.rndmMt]].toDouble()
                                    csto = rgst[cols[params.cstoMt]].toDouble()
                                } catch (e) {
                                    cntd = 0
                                }
                                if (cntd && sccnMt) {
                                    errores += insertaDtrb(oferente.id, obra, ordn, cdgo, nmbr, undd, cntd, pcun, pcun, 0, csto, "MT")
                                }
                            }

                            /** --------- Transporte de Materiales del rbro ordn ---------**/
                            if (rgst[cols[params.cldaTr]] == params.titlTr) {
                                sccnEq = false; sccnMo = false; sccnMt = false; sccnTr = true; sccnRubro = false
//                                println "Transp... $sccnTr --> rbro: $ordn $rbronmbr"
                            }
                            if (sccnTr) {
//                                cdgo, undd, nmbr, cntd, trfa, pcun, rndm, csto
//                                println "transporte: $rgst"
                                try {
                                    cdgo = rgst[cols[params.cdgoTr]]
                                    nmbr = rgst[cols[params.nmbrTr]]
                                    undd = params.unddTr ? rgst[cols[params.unddTr]] : ''
                                    peso = params.pesoTr ? rgst[cols[params.pesoTr]].toDouble() : ''
                                    println "ok-peso"
                                    dstn = params.dstnTr ? rgst[cols[params.dstnTr]].toDouble() : ''
                                    println "ok-dstn"
                                    cntd = rgst[cols[params.cntdTr]].toDouble() //cantidad
                                    println "ok-cntd"
                                    trfa = rgst[cols[params.pcunTr]].toDouble() //tarifa, jornal dtrbpcun
                                    println "ok-trfa"
//                                    pcun = rgst[cols[params.pcunTr]].toDouble() //costo
                                    csto = rgst[cols[params.cstoTr]].toDouble()
                                    println "ok-transporte"
                                } catch (e) {
                                    csto = 0
                                }
                                if (csto && sccnTr) {
//                                    println "inserta transporte $ordn $nmbr $csto"
//                                    insertaTrnp(oferente, obra, ordn, cdgo, nmbr, undd, peso, cntd, trfa, pcun, csto, dstn)
                                    errores += insertaTrnp(oferente.id, obra, ordn, cdgo, nmbr, undd, peso, cntd, trfa, trfa, csto, dstn)
                                }
                            }

                        }
                        fila++
                    } //sheets.each
                    htmlInfo += "<p>Hoja : " + sheet.getSheetName() + " Rubro: " + rbronmbr + "</p>"
                } //sheets.each
                if (done > 0) {
                    doneHtml = "<div class='alert alert-success'>Se han ingresado correctamente " + done + " registros</div>"
                }

                def str = doneHtml
                str += htmlInfo
                if (errores != "") {
                    str += "<ol>" + errores + "</ol>"
                }

                flash.message = str

                println "DONE!!"
                redirect(action: "mensajeUploadApu", id: params.id)
            } else {
                flash.message = "Seleccione un archivo Excel xlsx para procesar (archivos xls deben ser convertidos a xlsx primero)"
                redirect(action: 'formArchivo')
            }
        } else {
            flash.message = "Seleccione un archivo para procesar"
            redirect(action: 'subirExcel')
        }
    }

    /* sube desde excel los APU una vez cargados los rubros con subirRubros: página Rubros */

    def uploadAPU() {
        println "uploadAPU $params"
        def obra = params.obra
        def cn = dbConnectionService.getConnection()
        def filasNO = [0, 1]
        def filasTodasNo = []
        def oferente = session.usuario
        def path = "/var/janus/" + "xlsOfertas/" + params.obra + "/"   //web-app/archivos
        new File(path).mkdirs()
        def sql = ""
        def cols = [A: 0, B: 1, C: 2, D: 3, E: 4, F: 5, G: 6, H: 7, I: 8, J: 9, K: 10, L: 11, M: 12, N: 13]
        def rbronmbr = "", rbroundd = ""

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

            if (ext == "xlsx") {

                fileName = "xlsApus_" + params.obra

                def fn = fileName
                fileName = fileName + "." + ext

                def pathFile = path + fileName
                def src = new File(pathFile)

                def i = 1
                while (src.exists()) {
                    pathFile = path + fn + "_" + i + "." + ext
                    src = new File(pathFile)
                    i++
                }

                f.transferTo(new File(pathFile)) // guarda el archivo subido al nuevo path

                //procesar excel
                def htmlInfo = "", errores = "", doneHtml = "", done = 0
                InputStream ExcelFileToRead = new FileInputStream(pathFile);
                XSSFWorkbook workbook = new XSSFWorkbook(ExcelFileToRead);

                XSSFRow row;
                XSSFCell cell;

                int hojas = workbook.getNumberOfSheets(); //Obtenemos el número de hojas que contiene el documento
//                int hojas = 3
                println "Número Hojas: $hojas"

                def sccnEq = false, sccnMo = false, sccnMt = false, sccnTr = false, sccnRubro = false, hojaRubro = false
                def cdgo, nmbr, undd, peso, cntd, trfa, pcun, rndm, csto, dstn
                def txRubro = "", tipo = ""
                def ofrb_id = 0

                //for que recorre las hojas existentes
                def hj = 0
//                for (int hj = 1; hj < hojas; hj++) {
                while (hj < hojas) {
                    XSSFSheet sheet = workbook.getSheetAt(hj);
                    sheet = workbook.getSheetAt(hj);
                    def ordn = sheet.getSheetName().toString()
                    try {
                        ordn = ordn.toInteger()
                    } catch (e) {
                        ordn = 0
                    }
                    Iterator rows = sheet.rowIterator();
                    hojaRubro = false

                    println "Porcesando hoja: $hj --> " + sheet.getSheetName()

//                    if(ordn > 0) {
                    def fila = 0
                    while (rows.hasNext() && (fila < 76)) {
                        row = (XSSFRow) rows.next()
//                        if (!(row.rowNum in filasNO)) {
                        if (true) {
                            def ok = true
                            cdgo = ''; nmbr = ''; undd = ''; cntd = 0; trfa = 0; pcun = 0; rndm = 0; csto = 0; peso = 0;
                            dstn = 0
                            Iterator cells = row.cellIterator()
                            def rgst = []
                            def meses = []
//                            println "fila: ${row.rowNum}"
                            while (cells.hasNext()) {
                                cell = (XSSFCell) cells.next()
                                if (row.rowNum == 57) {
                                    println "Cell: ${cell.getCellType()} ${cell.getRawValue()}"
                                }
                                if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
                                    rgst.add(cell.getNumericCellValue())
                                } else if (cell.getCellType() == XSSFCell.CELL_TYPE_STRING) {
                                    rgst.add(cell.getStringCellValue())
                                } else if (cell.getCellType() == XSSFCell.CELL_TYPE_FORMULA) {
//                                    rgst.add(cell.getNumericCellValue())
                                    rgst.add(cell.getRawValue())
                                } else {
                                    rgst.add('')
                                }
                            }

                            println "reg: $rgst"

                            if (rgst[cols[params.cldatitl]] == params.rbrotitl) { //ANÁLISIS DE PRECIOS UNITARIOS
                                println "hoja: " + sheet.getSheetName().toString() + " Ok"
                                hojaRubro = true
                            }

                            if (hojaRubro) { //ANÁLISIS DE PRECIOS UNITARIOS
                                println "Procesa: " + sheet.getSheetName().toString()

                                if(rgst[cols[params.cldarbro]]){
                                    println "${rgst[cols[params.cldarbro]]} == ${params.rbro} && txRubro: ${txRubro}"
//                                    if (rgst[cols[params.cldarbro]]?.size() >= params.rbro.size()) {
                                    if ( (rgst[cols[params.cldarbro]] == params.rbro) && (txRubro == '')) {
                                        if(params.prefijo) {
                                            txRubro = rgst[cols[params.cldarbro]] ? rgst[cols[params.cldarbro]][0..(params.rbro.size() - 1)] : ''
                                        } else {
                                            txRubro = rgst[cols[params.rbronmbr]] ? rgst[cols[params.rbronmbr]] : ''
                                        }
                                    } else {
                                        txRubro = ''
                                    }

                                }
                                println "txRubro --> $txRubro"
//                                if (rgst[cols[params.cldarbro]] == params.rbro) {
                                if ( (txRubro != '') && (ofrb_id == 0) ) {
//                                    rbronmbr = rgst[cols[params.rbronmbr]]
//                                    rbronmbr = rbronmbr.toString().replaceAll(txRubro, '').trim()
//                                    rbronmbr = rbronmbr.toString().replaceAll("'", "''")
                                    rbronmbr = txRubro
                                    if(params.prefijo) {
                                        rbronmbr = rbronmbr.toString().replaceAll(txRubro, '').trim()
                                        rbronmbr = rbronmbr.toString().replaceAll("'", "''")
                                    } else {
                                        rbronmbr = rbronmbr.toString().replaceAll("'", "''")
                                    }
                                    sccnRubro = true
                                    println "Rubro: $rbronmbr"
                                    sql = "select ofrb__id from ofrb where prsn__id = ${oferente.id} and " +
                                            "obra__id = ${obra} and ofrbnmbr = '${rbronmbr}'"
                                    println "---sql: $sql"
                                    ofrb_id = cn.rows(sql.toString())[0]?.ofrb__id ?: 0
                                    if (!ofrb_id) {
                                        errores += "<li>No se encontró rurbo ${ordn} de la hoja: <strong>${sheet.getSheetName().toString()}</strong></li>"
                                        println "No se encontró rubro con id ${ordn} ${sheet.getSheetName().toString()}"
                                        break
                                    } else {
                                        println "---OFRB: $ofrb_id"
                                        if(ordn > 0) {
                                            sql = "update ofrb set ofrbordn = ${ordn} where ofrb__id = '${ofrb_id}'"
                                            cn.execute(sql.toString())
                                        }
                                    }

                                }

                                /** --------------- Equipos del rbro ordn ---------------**/
                                if (rgst[cols[params.cldaEq]] == params.titlEq) {
                                    sccnEq = true; sccnMo = false; sccnMt = false; sccnTr = false; sccnRubro = false
                                    println "Equipos..... $sccnEq --> rbro: $ordn $rbronmbr"
                                }
                                if (sccnEq && ofrb_id) {
                                    rgst.each { r ->
                                        rgst[]
                                    }
                                    if(ordn == 1) println "...1 id: $ofrb_id"
                                    try {
                                        cdgo = params.cdgoEq ? rgst[cols[params.cdgoEq]] : ''
                                        println "---> $rgst"
                                        if(ordn == 1) println "..2"
                                        println "..2"
                                        nmbr = rgst[cols[params.nmbrEq]]
                                        if(ordn == 1) println "..3"
                                        println "..3"
                                        cntd = rgst[cols[params.cntdEq]].toDouble() //cantidad
                                        println "..4"
                                        trfa = rgst[cols[params.trfaEq]] == '' ? 0 : rgst[cols[params.trfaEq]].toDouble()
                                        pcun = rgst[cols[params.pcunEq]] ? rgst[cols[params.pcunEq]].toDouble() : trfa //costo
                                        println "..5"

                                        rndm = rgst[cols[params.rndmEq]] ? rgst[cols[params.rndmEq]].toDouble() : 1
                                        println "..6"
                                        csto = rgst[cols[params.cstoEq]].toDouble()
                                        println "..7"
                                        if(ordn == 'C-001-016') println "..8 -- rndm: ${rgst[cols[params.rndmEq]]}"
                                        println "..8 -- rndm: ${rgst[cols[params.rndmEq]]}"
                                    } catch (e) {
                                        cntd = 0
                                        trfa = 0
                                        pcun = 0
                                        rndm = 0
                                    }
                                    try {
                                        nmbr = nmbr.replaceAll("\\n|\r", "").trim()
                                        nmbr = nmbr.toString().replaceAll("'", "''")
                                    } catch (e) {
                                        nmbr = ''
                                    }
                                    println "Equipos -> rbro: $ofrb_id nombre: $nmbr cantidad: $cntd"
                                    if (cntd && sccnEq) {
                                        println "inserta equipo: $nmbr, $cntd, $trfa, $rndm, $csto"
//                                        insertaEq(ofrb_id, cdgo, nmbr, undd, cntd, trfa, pcun, rndm, csto, tipo)
                                        errores += insertaEq(ofrb_id, cdgo, nmbr, undd, cntd, trfa, pcun, rndm, csto, "EQ")
                                    }
                                }

                                /** --------------- Mano de Obra del rbro ordn ---------------**/
                                if (rgst[cols[params.cldaMo]] == params.titlMo) {
                                    sccnEq = false; sccnMo = true; sccnMt = false; sccnTr = false; sccnRubro = false
//                                println "Mano de Obra.... $sccnMo --> rbro: $ordn $rbronmbr"
                                }
                                if (sccnMo && ofrb_id) {
//                                cdgo, undd, nmbr, cntd, trfa, pcun, rndm, csto
                                    try {
                                        cdgo = params.cdgoMo ? rgst[cols[params.cdgoMo]] : ''
                                        nmbr = rgst[cols[params.nmbrMo]]
                                        cntd = rgst[cols[params.cntdMo]].toDouble() //cantidad
                                        trfa = rgst[cols[params.trfaMo]] == '' ? 0: rgst[cols[params.trfaMo]].toDouble() //tarifa, jornal dtrbpcun
                                        pcun = rgst[cols[params.pcunMo]].toDouble() //costo
                                        rndm = rgst[cols[params.rndmMo]].toDouble()
                                        csto = rgst[cols[params.cstoMo]].toDouble()
                                    } catch (e) {
                                        cntd = 0
                                    }
                                    try {
                                        nmbr = nmbr.replaceAll("\\n|\r", "").trim()
                                        nmbr = nmbr.toString().replaceAll("'", "''")
                                    } catch (e) {
                                        nmbr = ''
                                    }
                                    println "MO -> rbro: $ofrb_id nombre: $nmbr cantidad: $cntd"
                                    if (cntd && sccnMo) {
//                                        errores += insertaDtrb(oferente.id, obra, ordn, cdgo, nmbr, undd, cntd, trfa, pcun, rndm, csto, "MO")
                                        errores += insertaEq(ofrb_id, cdgo, nmbr, undd, cntd, trfa, pcun, rndm, csto, "MO")
                                    }
                                }

                                /** --------------- Materiales del rbro ordn ---------------**/
                                if (rgst[cols[params.cldaMt]] == params.titlMt) {
                                    sccnEq = false; sccnMo = false; sccnMt = true; sccnTr = false; sccnRubro = false
//                                println "Mano de Mat... $sccnMt --> rbro: $ordn $rbronmbr"
                                }
                                if (sccnMt && ofrb_id) {
//                                cdgo, undd, nmbr, cntd, trfa, pcun, rndm, csto
                                    try {
                                        cdgo = params.cdgoMt ? rgst[cols[params.cdgoMt]] : ''
                                        nmbr = rgst[cols[params.nmbrMt]]
                                        undd = params.unddMt ? rgst[cols[params.unddMt]] : ''
                                        cntd = rgst[cols[params.cntdMt]].toDouble() //cantidad
                                        pcun = rgst[cols[params.pcunMt]].toDouble() //costo
                                        csto = rgst[cols[params.cstoMt]].toDouble()
                                    } catch (e) {
                                        cntd = 0
                                    }
                                    try {
                                        nmbr = nmbr.replaceAll("\\n|\r", "").trim()
                                        nmbr = nmbr.toString().replaceAll("'", "''")
                                    } catch (e) {
                                        nmbr = ''
                                    }
                                    if (cntd && sccnMt) {
//                                        errores += insertaDtrb(oferente.id, obra, ordn, cdgo, nmbr, undd, cntd, pcun, pcun, 0, csto, "MT")
                                        errores += insertaEq(ofrb_id, cdgo, nmbr, undd, cntd, pcun, pcun, rndm, csto, "MT")
                                    }
                                }

                                /** --------------- Transporte ---------------**/
                                if (rgst[cols[params.cldaTr]] == params.titlTr) {
                                    sccnEq = false; sccnMo = false; sccnMt = false; sccnTr = true; sccnRubro = false
//                                println "Mano de Mat... $sccnMt --> rbro: $ordn $rbronmbr"
                                }
                                if (sccnTr && ofrb_id) {
//                                cdgo, undd, nmbr, cntd, trfa, pcun, rndm, csto
                                    try {
                                        cdgo = params.cdgoTr ? rgst[cols[params.cdgoTr]] : ''
                                        nmbr = rgst[cols[params.nmbrTr]]
                                        undd = params.unddTr ? rgst[cols[params.unddTr]] : ''
                                        cntd = rgst[cols[params.cntdTr]].toDouble() //cantidad
                                        pcun = rgst[cols[params.pcunTr]].toDouble() //costo
                                        csto = rgst[cols[params.cstoTr]].toDouble()
                                    } catch (e) {
                                        cntd = 0
                                    }
                                    try {
                                        nmbr = nmbr.replaceAll("\\n|\r", "").trim()
                                        nmbr = nmbr.toString().replaceAll("'", "''")
                                    } catch (e) {
                                        nmbr = ''
                                    }
                                    if (csto && sccnTr) {
//                                    println "inserta transporte $ordn $nmbr $csto"
//                                        def insertaTr(ofrb_id, cdgo, nmbr, undd, cntd, trfa, pcun, rndm, csto, peso, dstn)

//                                        errores += insertaTr(oferente.id, obra, ordn, cdgo, nmbr, undd, peso, cntd, trfa, trfa, csto, dstn)
                                        errores += insertaTr(ofrb_id, cdgo, nmbr, undd, cntd, trfa, trfa, rndm, csto, peso, dstn)

                                    }
                                }

                            } else {
                                println "No es hoja de Rubro: ${sheet.getSheetName().toString()}"
                                break
                            }
                            /** va antes que ssnRbro = true porque se analiza en la siguiente pasada **/

                        }
                        fila++
                    } //sheets.each
                    htmlInfo += "<p>Hoja : " + sheet.getSheetName() + " Rubro: " + rbronmbr + "</p>"
                    hj++
                    hojaRubro = false
                    ofrb_id = 0
//                    }
                } //sheets.each
                if (done > 0) {
                    doneHtml = "<div class='alert alert-success'>Se han ingresado correctamente " + done + " registros</div>"
                }

                def str = doneHtml
                str += htmlInfo
                if (errores != "") {
                    str += "<ol>" + errores + "</ol>"
                }

                flash.message = str

                println "DONE!!"
                redirect(action: "mensajeUploadApu", id: params.id)
            } else {
                flash.message = "Seleccione un archivo Excel xlsx para procesar (archivos xls deben ser convertidos a xlsx primero)"
                redirect(action: 'formArchivo')
            }
        } else {
            flash.message = "Seleccione un archivo para procesar"
            redirect(action: 'subirExcel')
        }
    }

    def uploadRubros() {
        println "uploadRubros $params"
//        params.obra = 4255
        def obra = params.obra
        def cn = dbConnectionService.getConnection()
        def filasNO = []
        def oferente = session.usuario
        def path = "/var/janus/" + "xlsOfertas/" + params.obra + "/"   //web-app/archivos
        new File(path).mkdirs()
        def sql = ""

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

            if (ext == "xlsx") {

                fileName = "xlsApus_" + params.obra

                def fn = fileName
                fileName = fileName + "." + ext

                def pathFile = path + fileName
                def src = new File(pathFile)

                def i = 1
                while (src.exists()) {
                    pathFile = path + fn + "_" + i + "." + ext
                    src = new File(pathFile)
                    i++
                }

                f.transferTo(new File(pathFile)) // guarda el archivo subido al nuevo path

                //procesar excel
                def htmlInfo = "", errores = "", doneHtml = "", done = 0
                InputStream ExcelFileToRead = new FileInputStream(pathFile);
                XSSFWorkbook workbook = new XSSFWorkbook(ExcelFileToRead);

                XSSFRow row;
                XSSFCell cell;

                int hojas = workbook.getNumberOfSheets(); //Obtenemos el número de hojas que contiene el documento
//                int hojas = 3
                println "Número Hojas: $hojas - oferente: ${oferente?.id}"

                def nmro, nmbr, undd, cntd, pcun, pctt
                sql = "select inditotl from obra where obra__id = ${obra}"
                println "sql: $sql"
                def indi = cn.rows(sql.toString())[0]?.inditotl

                //for que recorre las hojas existentes
                for (int hj = 0; hj < hojas; hj++) {
                    XSSFSheet sheet = workbook.getSheetAt(hj);
                    sheet = workbook.getSheetAt(hj);
                    def hoja = sheet.getSheetName().toString()
                    Iterator rows = sheet.rowIterator();

                    if (params.rbro.toString().toLowerCase() == hoja.toString().toLowerCase()) {
                        println "Porcesando hoja: $hj --> $hoja"
                        def fila = 0
                        while (rows.hasNext()) {
                            row = (XSSFRow) rows.next()
                            if (!(row.rowNum in filasNO)) {
                                def ok = true
                                nmro = ''; nmbr = ''; undd = ''; cntd = 0; pcun = 0; pctt = 0
                                Iterator cells = row.cellIterator()
                                def rgst = []
//                                println "fila: ${row.rowNum}"
                                while (cells.hasNext()) {
                                    cell = (XSSFCell) cells.next()
                                    if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
                                        rgst.add(cell.getNumericCellValue())
                                    } else if (cell.getCellType() == XSSFCell.CELL_TYPE_STRING) {
                                        rgst.add(cell.getStringCellValue())
                                    } else if (cell.getCellType() == XSSFCell.CELL_TYPE_FORMULA) {
//                                    rgst.add(cell.getNumericCellValue())
                                        rgst.add(cell.getRawValue())
                                    } else {
                                        rgst.add('')
                                    }
                                }

                                println "reg: $rgst --> ${rgst[3]}"

                                try {
                                    nmro = rgst[0]
                                    nmbr = rgst[1]
                                    undd = rgst[2]
                                    cntd = rgst[3].toDouble() //cantidad
                                    pcun = rgst[4].toDouble() //costo
//                                    pctt = rgst[5].toDouble()
                                } catch (e) {
                                    cntd = 0
                                }

                                /** va antes que ssnRbro = true porque se analiza en la siguiente pasada **/
                                println "cntd: $cntd, undd: $undd --> nmbr: $nmbr"
                                if (cntd != 0) {
                                    /** insertar rubro */
                                    if (undd) {
                                        nmbr = nmbr.toString().replaceAll("'", "''")
//                                        sql = "select item__id from item where itemnmbr ilike '%${nmbr}%' and itemcdgo not like 'H%'"
//                                        println "sql: $sql"
//                                        def item_id = cn.rows(sql.toString())[0]?.item__id
//                                        if (!item_id) {
//                                            errores += "<li>No se encontró el nombre del rubro: ${nmbr} (linea: ${row.rowNum + 1})</li>"
//                                            println "No se encontró rubro con id ${hoja}"
//                                            ok = false
//                                        }
                                        sql = "select ofrb__id from ofrb where prsn__id = ${oferente.id} and " +
                                                "obra__id = ${params.obra} and ofrbordn = $nmro"
                                        def ofrb_id = cn.rows(sql.toString())[0]?.ofrb__id ?: 0
                                        if (ofrb_id) {
                                            sql = "update ofrb set ofrbordn = ${nmro}, ofrbnmbr = '${nmbr}', " +
                                                    "ofrbundd = '${undd}', ofrbpcun = ${pcun}, ofrbindi = ${indi} " +
                                                    "where ofrb__id = ${ofrb_id}"
                                        } else {
                                            sql = "insert into ofrb(prsn__id, obra__id, ofrbnmbr, ofrbundd, ofrbordn, ofrbjnid, " +
                                                    "ofrbpcun, ofrbindi) " +
                                                    "values (${oferente.id}, ${params.obra}, '${nmbr}', '${undd}', " +
                                                    "$nmro, 0, $pcun, $indi)"
                                        }
                                        println "sql: $sql"
                                        try {
                                            cn.execute(sql.toString())
                                        } catch (e) {
                                            println " no se pudo guardar $rgst: ${e.erros()}"
                                        }

                                    }
                                }
                            }
                            fila++
                        } //sheets.each
                        htmlInfo += "<h3>Se ha procesado la Hoja: " + sheet.getSheetName() + "</h3>"
                    }

                } //sheets.each
                if (done > 0) {
                    doneHtml = "<div class='alert alert-success'>Se han ingresado correctamente " + done + " registros</div>"
                }

                def str = doneHtml
                str += htmlInfo
                if (errores != "") {
                    str += "<ol>" + errores + "</ol>"
                }

                flash.message = str

                println "DONE!!"
                redirect(action: "mensajeUploadRubro", id: params.id)
            } else {
                flash.message = "Seleccione un archivo Excel xlsx para procesar (archivos xls deben ser convertidos a xlsx primero)"
                redirect(action: 'formArchivo')
            }
        } else {
            flash.message = "Seleccione un archivo para procesar"
            redirect(action: 'subirExcel')
        }
    }

    def mensajeUploadApu() {

    }

    def mensajeUploadRubro() {

    }


    def insertaDtrb(oferente, obra, ordn, cdgo, nmbr, undd, cntd, trfa, pcun, rndm, csto, tipo) {
        def cn = dbConnectionService.getConnection()
        def errores = ""
        def sql = "select ofrb__id from ofrb where prsn__id = ${oferente} and " +
                "obra__id = ${obra} and ofrbordn = ${ordn}"
        def ofrb_id = cn.rows(sql.toString())[0]?.ofrb__id ?: 0
        if (!ofrb_id) {
            errores += "<li>No se encontró rurbo ${ordn}</li>"
            println "No se encontró rubro con id ${ordn}"
        } else {
            sql = "select dtrb__id from dtrb where ofrb__id = ${ofrb_id} and " +
                    "dtrbnmbr = '${nmbr}' and dtrbtipo = '${tipo}'"
            def dtrb_id = cn.rows(sql.toString())[0]?.dtrb__id ?: 0
            if (dtrb_id) {
                sql = "update dtrb set dtrbcdgo = '${cdgo}', dtrbnmbr = '${nmbr}', " +
                        "dtrbundd = '${undd}', dtrbcntd = $cntd, dtrbpcun = $trfa, " +
                        "dtrbcsto = $pcun, dtrbrndm = $rndm, dtrbsbtt = $csto, dtrbtipo = '${tipo}' " +
                        "where dtrb__id = ${dtrb_id}"
            } else {
                sql = "insert into dtrb(ofrb__id, dtrbcdgo, dtrbnmbr, dtrbundd, dtrbcntd, dtrbpcun, " +
                        "dtrbcsto, dtrbrndm, dtrbsbtt, dtrbtipo) " +
                        "values (${ofrb_id}, '${cdgo}', '${nmbr}', '${undd}', $cntd, $trfa, " +
                        "$pcun, $rndm, $csto, '${tipo}' )"
            }
            println "sql $tipo: $sql"
            try {
                cn.execute(sql.toString())
            } catch (e) {
                println " no se pudo guardar dtrb: ${e.erros()}"
            }
        }
        return errores
    }

    def insertaTrnp(oferente, obra, ordn, cdgo, nmbr, undd, peso, cntd, trfa, pcun, csto, dstn) {
        def cn = dbConnectionService.getConnection()
        def errores = ""
        def sql = "select ofrb__id from ofrb where prsn__id = ${oferente} and " +
                "obra__id = ${obra} and ofrbordn = ${ordn}"
        def ofrb_id = cn.rows(sql.toString())[0]?.ofrb__id ?: 0
        println "insertaTrnp $oferente, $obra, $ordn, $cdgo, $nmbr, $undd, $peso, $cntd, $trfa, $pcun, $csto, $dstn"
        if (!ofrb_id) {
            errores += "<li>No se encontró rurbo ${ordn}</li>"
            println "No se encontró rubro con id ${ordn}"
        } else {
            println "porcesa transporte: dstn: $dstn"
            sql = "select dtrb__id from dtrb where ofrb__id = ${ofrb_id} and " +
                    "dtrbnmbr = '${nmbr}' and dtrbdstn > 0 and dtrbtipo = 'TR'"
            def dtrb_id = cn.rows(sql.toString())[0]?.dtrb__id ?: 0
            if (dtrb_id) {
                sql = "update dtrb set dtrbcdgo = '${cdgo}', dtrbnmbr = '${nmbr}', " +
                        "dtrbundd = '${undd}', dtrbcntd = $cntd, dtrbpcun = $trfa, " +
                        "dtrbcsto = $pcun, dtrbrndm = 1, dtrbsbtt = $csto, dtrbpeso = $peso," +
                        "dtrbdstn = $dstn" +
                        "where dtrb__id = ${ofrb_id}"
            } else {
                sql = "insert into dtrb(ofrb__id, dtrbcdgo, dtrbnmbr, dtrbundd, dtrbcntd, dtrbpcun, " +
                        "dtrbcsto, dtrbrndm, dtrbsbtt, dtrbpeso, dtrbdstn, dtrbtipo) " +
                        "values (${ofrb_id}, '${cdgo}', '${nmbr}', '${undd}', $cntd, $trfa, " +
                        "$pcun, 1, $csto, $peso, $dstn, 'TR' )"
            }
            println "sql: $sql"
            try {
                cn.execute(sql.toString())
            } catch (e) {
                println " no se pudo guardar dtrb: ${e.erros()}"
            }
        }
        return errores
    }

    def insertaEq(ofrb_id, cdgo, nmbr, undd, cntd, trfa, pcun, rndm, csto, tipo) {
        println "sinsertaEq++"
        def cn = dbConnectionService.getConnection()
        def sql = ""
        def errores = ""
        sql = "select dtrb__id from dtrb where ofrb__id = ${ofrb_id} and " +
                "dtrbnmbr = '${nmbr}' and dtrbtipo = '${tipo}'"
        println "sql dtrb: $sql"
        def dtrb_id = cn.rows(sql.toString())[0]?.dtrb__id ?: 0
        if (dtrb_id) {
            sql = "update dtrb set dtrbcdgo = '${cdgo}', dtrbnmbr = '${nmbr}', " +
                    "dtrbundd = '${undd}', dtrbcntd = $cntd, dtrbpcun = $trfa, " +
                    "dtrbcsto = $pcun, dtrbrndm = $rndm, dtrbsbtt = $csto, dtrbtipo = '${tipo}' " +
                    "where dtrb__id = ${dtrb_id}"
        } else {
            sql = "insert into dtrb(ofrb__id, dtrbcdgo, dtrbnmbr, dtrbundd, dtrbcntd, dtrbpcun, " +
                    "dtrbcsto, dtrbrndm, dtrbsbtt, dtrbtipo) " +
                    "values (${ofrb_id}, '${cdgo}', '${nmbr}', '${undd}', $cntd, $trfa, " +
                    "$pcun, $rndm, $csto, '${tipo}' )"
        }
        println "sql $tipo: $sql"
        try {
            cn.execute(sql.toString())
        } catch (e) {
            println " no se pudo guardar dtrb: ${e.erros()}"
        }
        return errores
    }

    def insertaTr(ofrb_id, cdgo, nmbr, undd, cntd, trfa, pcun, rndm, csto, peso, dstn) {
        println "sinsertaEq++"
        def cn = dbConnectionService.getConnection()
        def sql = ""
        def errores = ""
        sql = "select dtrb__id from dtrb where ofrb__id = ${ofrb_id} and " +
                "dtrbnmbr = '${nmbr}' and dtrbtipo = 'TR'"
        println "sql dtrb: $sql"
        def dtrb_id = cn.rows(sql.toString())[0]?.dtrb__id ?: 0
        println "--> dtrb_id: $dtrb_id"

        if (dtrb_id) {
            sql = "update dtrb set dtrbcdgo = '${cdgo}', dtrbnmbr = '${nmbr}', " +
                    "dtrbundd = '${undd}', dtrbcntd = $cntd, dtrbpcun = $trfa, " +
                    "dtrbcsto = $pcun, dtrbrndm = 1, dtrbsbtt = $csto, dtrbpeso = $peso," +
                    "dtrbdstn = $dstn" +
                    "where dtrb__id = ${ofrb_id}"
        } else {
            sql = "insert into dtrb(ofrb__id, dtrbcdgo, dtrbnmbr, dtrbundd, dtrbcntd, dtrbpcun, " +
                    "dtrbcsto, dtrbrndm, dtrbsbtt, dtrbpeso, dtrbdstn, dtrbtipo) " +
                    "values (${ofrb_id}, '${cdgo}', '${nmbr}', '${undd}', $cntd, $trfa, " +
                    "$pcun, 1, $csto, $peso, $dstn, 'TR' )"
        }

//        if (dtrb_id) {
//            sql = "update dtrb set dtrbcdgo = '${cdgo}', dtrbnmbr = '${nmbr}', " +
//                    "dtrbundd = '${undd}', dtrbcntd = $cntd, dtrbpcun = $trfa, " +
//                    "dtrbcsto = $pcun, dtrbrndm = $rndm, dtrbsbtt = $csto, dtrbtipo = '${tipo}' " +
//                    "where dtrb__id = ${dtrb_id}"
//        } else {
//            sql = "insert into dtrb(ofrb__id, dtrbcdgo, dtrbnmbr, dtrbundd, dtrbcntd, dtrbpcun, " +
//                    "dtrbcsto, dtrbrndm, dtrbsbtt, dtrbtipo) " +
//                    "values (${ofrb_id}, '${cdgo}', '${nmbr}', '${undd}', $cntd, $trfa, " +
//                    "$pcun, $rndm, $csto, '${tipo}' )"
//        }
        println "sql TR: $sql"
        try {
            cn.execute(sql.toString())
        } catch (e) {
            println " no se pudo guardar dtrb: ${e.erros()}"
        }
        return errores
    }


    def rubroCon() {
        println "rubroCon: $params"
        def oferente = session.usuario
        def cn = dbConnectionService.getConnection()
        def obras = []
        def sql = "select distinct obra.obra__id id, obracdgo||' - '||obranmbr nombre, inditotl " +
                "from obra, obof " +
                "where obof.obra__id = obra.obra__id and obof.prsn__id = ${oferente.id}" +
//                "where obof.obrajnid = obra.obra__id " +
                "order by 1"
        cn.eachRow(sql.toString()) { r ->
            obras.add([id: r.id, nombre: r.nombre, indi: r.inditotl])
//            obras[r.id] = r.nombre + "_" + r.inditotl
        }

        println "obras: $obras"

        [obras: obras, oferente: oferente, tipo: params.tipo]

    }

    def listaRubros_ajax() {
        println("params " + params)
//        params.id = 4255
        def oferente = session.usuario
        def cn = dbConnectionService.getConnection()
        def rubros = [:]
        def sql = "select ofrb.ofrb__id id, ofrbordn||' - '||ofrbnmbr nombre " +
                "from ofrb " +
                "where ofrb.obra__id = ${params.id} and ofrb.prsn__id = ${oferente.id} " +
                "order by ofrbordn"
        println "sql: $sql"
        cn.eachRow(sql.toString()) { r ->
            rubros[r.id] = r.nombre
        }
        return [rubros: rubros, obra: params.id]
    }

    def tablaComposicion_ajax() {
        println "tablaComposicion_ajax $params"
        def rubro = RubroOferta.get(params.id)
        def obra = Obra.get(params.obra)
//        def detalles = DetalleRubro.findAllByRubroOferta(rubro, [sort: 'tipo'])
        def equipos = DetalleRubro.findAllByRubroOfertaAndTipo(rubro, 'EQ')
        def manos = DetalleRubro.findAllByRubroOfertaAndTipo(rubro, 'MO')
        def materiales = DetalleRubro.findAllByRubroOfertaAndTipo(rubro, 'MT')
        def transporte = DetalleRubro.findAllByRubroOfertaAndTipo(rubro, 'TR')

        def precioUnitario = (equipos.subtotal.sum() ?: 0) + (manos.subtotal.sum() ?: 0) +
                (materiales.subtotal.sum() ?: 0) + (transporte.subtotal.sum() ?: 0)


        println "mano: $manos"
        return [equipos: equipos, manos: manos, materiales: materiales, transporte: transporte,
                precioUnitario: precioUnitario, indirectos: obra.totales]
    }

    def procesarRubrosOf() {
        println "procesarRubrosOf $params"
//        params.id = 4255
        def oferente = session.usuario
        def cn = dbConnectionService.getConnection()
        def sql = ""
        def cmpos = ['dtrbpeso', 'dtrbcntd', 'dtrbrndm', 'dtrbdstn', 'dtrbpcun', 'dtrbcsto', 'dtrbsbtt']
        for (i in cmpos) {
            sql = "update dtrb set ${i} = 0 where ${i} is null"
            println "sql: $sql"
            cn.execute(sql.toString())
        }
        def indi = 1 + params.indi.toDouble() / 100

        /** los valores se cargan al cargar el presupuesto para cuadrar valores del APU
         * si no cuadran hay que corregir --- ? */

//        sql = "update ofrb set ofrbpcun = (select sum(dtrbsbtt* ${indi} ) from dtrb " +
//                "where dtrb.ofrb__id = ofrb.ofrb__id) where obra__id = ${params.obra}"
//        println "sql: $sql"
//        cn.execute(sql.toString())
        sql = "update ofrb set ofrbjnid = 0 where ofrbjnid is null"
        cn.execute(sql.toString())
        sql = "update dtrb set dtrbjnid = 0 where dtrbjnid is null"
        cn.execute(sql.toString())

        sql = "update ofrb set ofrbindi = ( select inditotl from obra where obra.obra__id = ${params.obra} and " +
                "ofrb.obra__id = obra.obra__id )"
        println "sql: $sql"
        cn.execute(sql.toString())
        cn.close()
        render "ok"
    }

    def rubroEmpatado() {
        def oferente = session.usuario
        def cn = dbConnectionService.getConnection()
        def obras = [:]
        def sql = "select distinct obra.obra__id id, obracdgo||' - '||obranmbr nombre " +
                "from obra, obof " +
                "where obof.obra__id = obra.obra__id and obof.prsn__id = ${oferente.id}" +
//                "where obof.obrajnid = obra.obra__id " +
                "order by 1"
        cn.eachRow(sql.toString()) { r ->
            obras[r.id] = r.nombre
        }
        [obras: obras, oferente: oferente, tipo: params.tipo]
    }

    def tablaBusqueda_ajax() {
        def cn = dbConnectionService.getConnection()
        def obra = Obra.get(params.obra)
//        def oferente = session.usuario
        println "tablaBusqueda_ajax: $params"
//        def obra = Obra.get(params.id)
        def listaItems = ['dtrbnmbr', 'dtrbcdgo']
        def sql = "select distinct dtrb__id, dtrbcdgo codigo, dtrbnmbr nombre, dtrbtipo tipo from dtrb, ofrb " +
                "where ofrb.obra__id = ${obra?.id} and dtrb.ofrb__id = ofrb.ofrb__id and dtrbjnid = 0 and " +
                "dtrbtipo != 'TR'"
        def bsca = listaItems[params.buscarPor.toInteger() - 1]
        sql += " and $bsca ilike '%${params.criterio}%' and dtrb.dtrbtipo = '${params.grupo}' "
        def sqlTx = "${sql} order by 3, 1".toString()
//        println("sql " + sqlTx)
        def datos = cn.rows(sqlTx)
        return [datos: datos, obra: obra]
    }

    def buscarRubros_ajax() {
//        def rubro = DetalleRubro.findAllByNombreAndTipoNotEqual(params.dscr, 'TR')?.first()
        def rubro = DetalleRubro.get(params.rubro)
        def tipo = rubro.tipo == 'EQ' ? ['3': 'Equipos'] : (rubro.tipo == 'MT' ? ['1': 'Materiales'] : ['2': 'Mano de obra'])
        return [rubro: rubro, tipo: tipo, obra: params.obra]
    }

    def tablaBuscarRubros_ajax() {
        println "tablaBuscarRubros_ajax: $params"
        def cn = dbConnectionService.getConnection()
        def listaItems = ['itemnmbr', 'itemcdgo']
//        def rubro = Item.get(params.rubro)
        def rubro = DetalleRubro.get(params.rubro)
        def datos;

        def longitud = params.nmbr.size()
        def recorte = longitud > 10 ? longitud * 0.75 : longitud - 2
//        params.criterio = params.criterio ?: params.nmbr[0..(recorte)]
        params.criterio = params.criterio ?: params.nmbr

        def select = "select item.item__id, itemcdgo, itemnmbr, item.tpls__id, unddcdgo " +
                "from item, undd, dprt, sbgr "
        def txwh = "where tpit__id = 1 and undd.undd__id = item.undd__id and dprt.dprt__id = item.dprt__id and " +
                "sbgr.sbgr__id = dprt.sbgr__id and itemetdo = 'A'"
        def sqlTx = ""
        def bsca = listaItems[params.buscarPor.toInteger() - 1]
        def ordn = listaItems[params.ordenar.toInteger() - 1]
//        txwh += " and $bsca ilike '%${params.criterio}%' and grpo__id = ${params.grupo}"
        if(params.criterio != params.nmbr) {
            txwh += " and grpo__id = ${params.grupo} and itemnmbr ilike '%${params.criterio}%' "
        } else {
            txwh += " and grpo__id = ${params.grupo} and levenshtein(itemnmbr, '${params.nmbr}') < 3 "
        }


        sqlTx = "${select} ${txwh} order by ${ordn} limit 100 ".toString()
        println "sql: $sqlTx"
        datos = cn.rows(sqlTx)
//        println "data: ${datos[0]}"
        [data: datos, rubro: rubro, obra: params.obra]
    }

    def tablaEmpatados_ajax() {
        println "tablaEmpatados_ajax: $params"
        def cn = dbConnectionService.getConnection()
        def sql = "select distinct dtrbjnid dtrb__id, dtrbtipo, dtrbcdgo, dtrbnmbr, dtrbundd, dtrbtipo, itemnmbr, itemcdgo from dtrb, item, ofrb " +
                "where item.item__id = dtrbjnid and dtrbtipo = '${params.tipo}' and ofrb.ofrb__id = dtrb.ofrb__id and " +
                "obra__id = ${params.obra}" + // "and obra__id = ${params.obra}"
                "order by itemcdgo"
        println "sql: $sql"
        def empatados = cn.rows(sql.toString())
        return [data: empatados, obra: params.obra]
    }


    def empatarRubros_ajax() {
        println "empatar: $params"
        def cn = dbConnectionService.getConnection()
        def oferente = session.usuario
//        def sql = "select dtrbnmbr from dtrb where dtrb__id = ${params.rubro}"
//        println "sql: $sql"

        def sql = "update dtrb set dtrbjnid = ${params.id} where dtrbnmbr = ( select dtrbnmbr from dtrb " +
                "where dtrb__id = ${params.rubro} ) and ofrb__id in (" +
                "select ofrb__id from ofrb where prsn__id = ${oferente.id} and obra__id = ${params.obra})"
        println "sql: $sql"
        cn.execute(sql.toString())

        render "ok_Guardado correctamente"
    }

    def copiarRubros() {
        println "copiarRubros: $params"
        def cn = dbConnectionService.getConnection()
        def sql = "select * from sp_rubro_of(${params.obra})"
        def resl = cn.execute(sql.toString())
        render "ok"
    }

    def borrarApus() {
        println "borrarApus: $params"
        def cn = dbConnectionService.getConnection()
        def sql = "delete from dtrb where ofrb__id in (select ofrb__id from ofrb " +
                "where obra__id = ${params.obra})"
        cn.execute(sql.toString())

        /* borra los rubros subidos */
        sql = "delete from ofrb where obra__id = ${params.obra}"
        cn.execute(sql.toString())

        /* borra los rubros migrados */
        sql = "delete from rbof where obra__id = ${params.obra}"
        cn.execute(sql.toString())

        /* borra los precios migrados */
        sql = "delete from prco where obra__id = ${params.obra}"
        cn.execute(sql.toString())

        render "Ok"
    }

    def subirRubros() {
        println("params " + params)
        def oferente = session.usuario
        def cn = dbConnectionService.getConnection()
        def obras = [:]
        def sql = "select distinct obra.obra__id id, obracdgo||' - '||obranmbr nombre " +
                "from obra, obof " +
                "where obof.obra__id = obra.obra__id and obof.prsn__id = ${oferente.id} " +
                "order by 1"
        println "sql: $sql"
        cn.eachRow(sql.toString()) { r ->
            obras[r.id] = r.nombre
        }
        [obras: obras, oferente: oferente, tipo: params.tipo]
    }


//    def quitarEmpateRubros_ajax() {
    def quitarEmpateRubros_ajax(){
        println "quita: $params"
        def cn = dbConnectionService.getConnection()
        def oferente = session.usuario
        def sql = "update dtrb set dtrbjnid = 0 where dtrbjnid = ${params.id} and ofrb__id in (" +
                "select ofrb__id from ofrb where prsn__id = ${oferente.id} and obra__id = ${params.obra})"
        println "sql: $sql"
        cn.execute(sql.toString())

        render "ok_Guardado correctamente"
    }

    def emparejarRubros(){
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
        [obras: obras, oferente: oferente, tipo: params.tipo]
    }

    def tablaBusquedaRubros_ajax(){
        println "tablaBusquedaRubros_ajax: $params"
        def cn = dbConnectionService.getConnection()
        def obra = Obra.get(params.obra)
        def oferente = session.usuario
        def sql = "update ofrb set ofrbjnid = 0 where ofrbjnid is null"
        cn.execute(sql.toString())

        sql = "select * from ofrb " +
                "where ofrb.obra__id = ${params.obra} and ofrbjnid = 0 and " +
                "prsn__id = ${oferente.id}"
        def sqlTx = "${sql} order by ofrbnmbr".toString()
        println "sql: $sqlTx"
        def datos = cn.rows(sqlTx)


        sql = "select count(*) cnta from vlof where item__id not in " +
                "(select ofrbjnid from ofrb where obra__id = ${params.obra}) and obra__id = ${params.obra}"
        println "sql: $sql"
        def faltan = cn.rows(sql.toString())[0].cnta
        return [datos: datos, obra: obra, faltan: faltan]
    }

    def tablaEmpatadosRubros_ajax(){
        println "tablaEmpatadosRubros_ajax: $params"
        def cn = dbConnectionService.getConnection()
        def sql = "select ofrb.*, itemcdgo, itemnmbr from ofrb, item " +
                "where item.item__id = ofrbjnid and obra__id = ${params.obra} " + // "and obra__id = ${params.obra}"
                "order by itemnmbr"
        println "sql: $sql"
        def empatados = cn.rows(sql.toString())
        return [data: empatados, obra: params.obra]
    }

    def buscarRubrosRubros_ajax(){
        def rubro = RubroOferta.get(params.id)
        return [rubro: rubro, obra: params.obra]
    }

    def tablaBuscarRubrosRubros_ajax(){
        println "tablaBuscar Rubros: $params"
        def cn = dbConnectionService.getConnection()
        def obrajnid = cn.rows("select obrajnid from obof where obra__id = ${params.obra}".toString())[0].obrajnid
        def datos;

//        def txto = params.nmbr.toString().replaceAll('  ', ' ')
        def longitud = params.nmbr.size()
        def recorte = longitud > 10 ? longitud * 0.44 : longitud - 2
//        params.criterio = params.criterio ?: params.nmbr[0..(recorte)]
        params.criterio = params.criterio ?: params.nmbr
        println "crite:  ${params.criterio}"

//        def select = "select distinct item.item__id, itemcdgo, itemnmbr, unddcdgo " +
//                "from item, undd, vlob "
//        def txwh = "where item.item__id = vlob.item__id and undd.undd__id = item.undd__id and obra__id = $obrajnid "
//        def sqlTx = ""
//        txwh += " and itemnmbr ilike '%${params.criterio}%' "
        def select = "select distinct item.item__id, itemcdgo, itemnmbr, unddcdgo " +
                "from item, undd, vlof "
//        def txwh = "where item.item__id = vlof.item__id and undd.undd__id = item.undd__id and obra__id = $obrajnid "
        def txwh = "where item.item__id = vlof.item__id and undd.undd__id = item.undd__id and obra__id = ${params.obra} "
        def sqlTx = ""
//        txwh += " and levenshtein(itemnmbr, '${params.criterio}') < 2 "
        if(params.criterio != params.nmbr) {
            txwh += " and itemnmbr ilike '%${params.criterio}%' "
        } else {
            txwh += " and levenshtein(itemnmbr, '${params.nmbr}') < 3 "
        }

        sqlTx = "${select} ${txwh} order by itemnmbr".toString()
        println "sql: $sqlTx"
        datos = cn.rows(sqlTx)
        println "data: ${datos[0]}"
        [data: datos, obra: params.obra, rubro: params.rubro]

    }

    def costosIndirectos_ajax(){
        def obra = Obra.get(params.id)
        return [obra: obra]
    }

    def quitarEmpateRubrosRubros_ajax(){
        println "quita rurbos: $params"
        def cn = dbConnectionService.getConnection()
        def oferente = session.usuario
        def sql = "update ofrb set ofrbjnid = 0 where ofrb__id = ${params.id} and obra__id = ${params.obra}"
        println "sql: $sql"
        cn.execute(sql.toString())
        render "ok_Guardado correctamente"
    }

    def emparejarRubros_ajax(){
        println "empareja rubro: $params"
        def cn = dbConnectionService.getConnection()
        def oferente = session.usuario
//        def sql = "select dtrbnmbr from dtrb where dtrb__id = ${params.rubro}"
//        println "sql: $sql"

        def sql = "update ofrb set ofrbjnid = ${params.id} where ofrb__id = ${params.rubro} "
        println "sql: $sql"
        cn.execute(sql.toString())

        render "ok_Guardado correctamente"
    }

    def formEquipo_ajax(){
        def detalle = DetalleRubro.get(params.id)
        return [detalle: detalle]
    }

    def save_ajax(){

        def detalle = DetalleRubro.get(params.id)

        params.cantidad = params.cantidad.toDouble()
        params.precio = params.precio.toDouble()
        params.rendimiento =  params.rendimiento.toDouble()
        params.subtotal =  params.subtotal.toDouble()

        detalle.properties = params

        if(!detalle.save(flush:true)){
            println("error al guardar el rubro " + detalle.errors)
            render "no_Error al guardar el rubro"
        }else{
            render "ok_Guardado correctamente"
        }
    }

    def empjCdgo() {
        println "empareja rubro: $params"
        def cn = dbConnectionService.getConnection()
        def sql = "update dtrb set dtrbjnid = (select item__id from item where item.itemcdgo = dtrb.dtrbcdgo) " +
                "where dtrbjnid = 0 and obra__id = ${params.obra})"
        println "sql: $sql"
        cn.execute(sql.toString())

        sql = "update dtrb set dtrbjnid = 0 where dtrbjnid is null"
        cn.execute(sql.toString())
        cn.close()

        render "ok_Guardado correctamente"
    }

    def empjNmbr() {
        println "empareja por nombre: $params"
        def cn = dbConnectionService.getConnection()
        def sql = "update dtrb set dtrbjnid = (select item__id from item where item.itemnmbr = dtrb.dtrbnmbr and " +
                "tpit__id = 1) where dtrbjnid = 0 and ofrb__id in (select ofrb__id from ofrb " +
                "where dtrbjnid = 0 and obra__id = ${params.obra})"
        println "sql: $sql"
        cn.execute(sql.toString())

        sql = "update dtrb set dtrbjnid = 0 where dtrbjnid is null"
        cn.execute(sql.toString())
        cn.close()
        render "ok_Guardado correctamente"
    }

    def empjNmbrRbro() {
        println "empareja por nombre rubros: $params"
        def cn = dbConnectionService.getConnection()
        def sql = "update ofrb set ofrbjnid = (select item.item__id from item, vlof " +
                "where item.item__id = vlof.item__id and vlof.obra__id = ${params.obra} and " +
                "item.itemnmbr = ofrb.ofrbnmbr and tpit__id = 2 and item.itemcdgo not ilike 'h%' limit 1) " +
                "where ofrbjnid = 0 and obra__id = ${params.obra}"
        println "sql: $sql"
        cn.execute(sql.toString())

        sql = "update ofrb set ofrbjnid = 0 where ofrbjnid is null"
        cn.execute(sql.toString())
        cn.close()
        render "ok_Guardado correctamente"
    }

    def formMaterial_ajax(){
        def detalle = DetalleRubro.get(params.id)
        return [detalle: detalle]
    }

    def formTransporte_ajax(){
        def detalle = DetalleRubro.get(params.id)
        return [detalle: detalle]
    }

    def borrarRubroOferente_ajax(){

        def detalle = DetalleRubro.get(params.id)

        try{
            detalle.delete(flush:true)
            render "ok"
        }catch(e){
            println("error al borrar el rubro " + detalle.errors)
            render "no"
        }
    }

    def index(){

    }

    def copiarComposicionOferente() {
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

        [obras: obras, oferente: oferente, tipo: params.tipo]
    }

    def tablaEmpatadosCC_ajax(){
        println "tablaEmpatados_ajax: $params"
        def cn = dbConnectionService.getConnection()
//        def sql = "select distinct dtrbjnid dtrb__id, dtrbtipo, dtrbcdgo, dtrbnmbr, dtrbundd, dtrbtipo, itemnmbr, itemcdgo from dtrb, item, ofrb " +
//                "where item.item__id = dtrbjnid and ofrb.ofrb__id = dtrb.ofrb__id and " +
//                "obra__id = ${params.obra} " +
//                "order by itemcdgo"
//        println "sql: $sql"
//        def empatados = cn.rows(sql.toString())


        def obra = Obra.get(params.obra)

        def sql2 = "select distinct dtrbcdgo codigo, dtrbnmbr nombre, dtrbtipo tipo from dtrb, ofrb " +
                "where ofrb.obra__id = ${obra?.id} and dtrb.ofrb__id = ofrb.ofrb__id and dtrbjnid = 0 and " +
                "dtrbtipo != 'TR'   and dtrb.dtrbtipo = 'MT' "
        def sqlTx = "${sql2} order by 3, 1".toString()
        def materiales = cn.rows(sqlTx)

        def sql3 = "select distinct dtrbcdgo codigo, dtrbnmbr nombre, dtrbtipo tipo from dtrb, ofrb " +
                "where ofrb.obra__id = ${obra?.id} and dtrb.ofrb__id = ofrb.ofrb__id and dtrbjnid = 0 and " +
                "dtrbtipo != 'TR'   and dtrb.dtrbtipo = 'MO' "
        def sqlTx3 = "${sql3} order by 3, 1".toString()
        def mano = cn.rows(sqlTx3)


        def sql4 = "select distinct dtrbcdgo codigo, dtrbnmbr nombre, dtrbtipo tipo from dtrb, ofrb " +
                "where ofrb.obra__id = ${obra?.id} and dtrb.ofrb__id = ofrb.ofrb__id and dtrbjnid = 0 and " +
                "dtrbtipo != 'TR'   and dtrb.dtrbtipo = 'EQ' "
        def sqlTx4 = "${sql4} order by 3, 1".toString()
        def equipos = cn.rows(sqlTx4)

//        return [data: empatados, obra: params.obra, datos: datos]
        return [obra: obra, materiales: materiales, mano: mano, equipos: equipos]
    }

    def guardarCostoIndirecto_ajax(){
        def obra = Obra.get(params.obra)

        if(params.costo){
            obra.totales = params.costo.toDouble()

            if(!obra.save(flush:true)){
                println("error al guardar el costo indirecto " + obra.errors)
                render"no_Error al guardar el costo indirecto"
            }else{
                render "ok_Guardado correctamente"
            }
        }else{
            render "err_Ingrese un costo indirecto"
        }

    }

} //fin controller
