package janus


import jxl.Cell
import jxl.Sheet
import jxl.Workbook
import seguridad.Persona

class ComposicionController {

    def index() {}
    def dbConnectionService
    def buscadorService
    def preciosService

    def validacion() {
//        println "validacion "+params
        def obra = Obra.get(params.id)
        def comps = Composicion.findAllByObra(obra)
        if (comps.size() == 0) {
            redirect(action: "cargarDatos", id: params.id)
        } else {
            redirect(action: "tabla", id: params.id)
        }
        return
    }

    def recargar() {
//        println "recargar composición de la obra: " + params
        def sql = "delete from comp where obra__id = ${params.id}"
        def cn = dbConnectionService.getConnection()
        cn.execute(sql.toString())
        cn.close()

        def obra = Obra.get(params.id)
        redirect(action: "cargarDatos", id: params.id)

        return
    }

    def cargarDatos() {
        println "cargarDatos $params"
        def sql = "select item__id,voitpcun,voitcntd, voitcoef, voittrnp from vlobitem where obra__id=${params.id} and voitpcun is not null and voitcntd is not null order by 1"
        def obra = Obra.get(params.id)
        def cn = dbConnectionService.getConnection()
        cn.eachRow(sql.toString()) { r ->
            println "r " +r
//            def comp = Composicion.findAll("from Composicion  where obra=${params.id} and item=${r[0]}")
            def comp = Composicion.findAllByObraAndItem(obra, Item.get(r.item__id))
            println "comp "+comp
            if (comp.size() == 0) {
                def item = Item.get(r[0])
                comp = new Composicion([obra: obra, item: item, grupo: item.departamento.subgrupo.grupo, cantidad: r[2], precio: r[1], transporte: r[4]])
                if (!comp.save(flush: true)) {
                    println "error " + comp.errors
                }

            } else {
                comp = comp.pop()
                comp.cantidad += r[2]
                if (!comp.save(flush: true)) {
                    println "error " + comp.errors
                }
            }

        }
        redirect(action: "tabla", id: params.id)
    }


    def getPreciosItem(obra, item) {
//        println "get precios "+item+"  "+obra
        def lugar = obra.listaManoObra
        def fecha = obra.fechaPreciosRubros
        def items = []
        def listas = []
        def conLista = []
        def lista
//        println "listas " + listas
        //println "item tipo lista " + item.tipoLista
        if (item.tipoLista) {
            conLista.add(item)
            switch (item.tipoLista.codigo.trim()) {
                case "MQ":
                    lista = obra.listaManoObra
                    break;
                case "P":
                    lista = obra.lugar
                    break;
                case "P1":
                    lista = obra.listaPeso1
                    break;
                case "V":
                    lista = obra.listaVolumen0
                    break;
                case "V1":
                    lista = obra.listaVolumen1
                    break;
                case "V2":
                    lista = obra.listaVolumen2
                    break;
            }
//                    println "con lista "+item.tipoLista
        } else {
            items.add(item)

        }

        //println "lista " + lista
        def precios = ""
//        println "items " + items + "  con lista " + conLista
        if (items.size() > 0) {
            precios = preciosService.getPrecioItemsString(fecha, lugar.id, items)
        }

//        println "precios "+precios
        conLista.each {
//            println "tipo "+ it.tipoLista.id.toInteger()
            precios += preciosService.getPrecioItemStringListaDefinida(fecha, lista.id, it.id)
        }

//        println "precios final " + precios
//        println "--------------------------------------------------------------------------"
        return precios
    }

    def getPreciosTransporte(obra, item) {

        return 0
    }

    def buscaRubro() {

        def listaTitulos = ["Código", "Descripción", "Unidad"]
        def listaCampos = ["codigo", "nombre", "unidad"]
        def funciones = [null, null]
        def url = g.createLink(action: "buscaRubro", controller: "rubro")
        def funcionJs = "function(){"
        funcionJs += '$("#modal-rubro").modal("hide");precios($(this).attr("regId"));'
        funcionJs += '$("#item_id").val($(this).attr("regId"));$("#item_codigo").val($(this).attr("prop_codigo"));$("#item_nombre").val($(this).attr("prop_nombre"))'
        funcionJs += '}'
        def numRegistros = 20
        def extras = " and tipoItem = 1"
        if (!params.reporte) {
            def lista = buscadorService.buscar(Item, "Item", "excluyente", params, true, extras)
            /* Dominio, nombre del dominio , excluyente o incluyente ,params tal cual llegan de la interfaz del buscador, ignore case */
            lista.pop()
            render(view: '../tablaBuscadorColDer', model: [listaTitulos: listaTitulos, listaCampos: listaCampos, lista: lista, funciones: funciones, url: url, controller: "llamada", numRegistros: numRegistros, funcionJs: funcionJs])
        } else {
//            println "entro reporte"
            /*De esto solo cambiar el dominio, el parametro tabla, el paramtero titulo y el tamaño de las columnas (anchos)*/
            session.dominio = Item
            session.funciones = funciones
            def anchos = [20, 80] /*el ancho de las columnas en porcentajes... solo enteros*/
            redirect(controller: "reportes", action: "reporteBuscador", params: [listaCampos: listaCampos, listaTitulos: listaTitulos, tabla: "Item", orden: params.orden, ordenado: params.ordenado, criterios: params.criterios, operadores: params.operadores, campos: params.campos, titulo: "Rubros", anchos: anchos, extras: extras, landscape: true])
        }
    }

    def precios() {
        def obra = Obra.get(params.obra)
        def item = Item.get(params.item)
        def precios = ""
        def precio
        precios += getPreciosItem(obra, item)

        if (precios.size() > 0) {
            def parts = precios.split("&")
            parts = parts[0].split(";")
            precio = parts[1] + ";"
        } else {
            precio = "0;"
        }
        precio += "0"
        render precio
    }


    def buscarRubroCodigo() {
//        println "aqui "+params
        def rubro = Item.findByCodigoAndTipoItem(params.codigo?.trim(), TipoItem.get(1))
        if (rubro) {
            render "" + rubro.id + "&&" + rubro.tipoLista?.id + "&&" + rubro.nombre + "&&" + rubro.unidad?.codigo
            return
        } else {
            render "-1"
            return
        }
    }

    def addItem() {
//        println "add item "+params
        def obra = Obra.get(params.obra)
        def item = Item.get(params.rubro)
        def cant = params.cantidad.toDouble()
        def comp = Composicion.findByObraAndItem(obra, item)
        def msg = "ok"
        def precio = getPreciosItem(obra, item)
        if (precio.size() > 0) {
            def parts = precio.split("&")
            parts = parts[0].split(";")
            precio = parts[1].toDouble()
        } else {
            precio = 0
        }
//        println "precio "+precio
        def transporte = getPreciosTransporte(obra, item)
        if (comp) {
//            println "si item"
            msg = "El item seleccionado ya se encuentra dentro de la composición, si desea editarlo hagalo mediante las herramientas de edición"
            render msg
            return
        } else {

            comp = new Composicion()
            comp.item = item
            comp.obra = obra
            comp.cantidad = cant
            comp.grupo = item.departamento.subgrupo.grupo
            comp.precio = precio
            comp.transporte = transporte
            if (comp.save(flush: true)) {
                render "ok"
                return
            }

            render "ok"
        }


    }


    def tabla() {
        println "tabla: $params"
        def persona = Persona.get(session.usuario.id)
        def duenoObra = 0
        def cn = dbConnectionService.getConnection()

        if (!params.tipo) {
            params.tipo = "-1"
        }
        if (!params.sp) {
            params.sp = '-1'
        }

        def obra = Obra.get(params.id)
        if (params.tipo == "-1") {
            params.tipo = [1,2,3]
        } else {
            params.tipo = [ params.tipo.toInteger()]
        }

        def campos = ["codigo": ["Código", "string"], "nombre": ["Descripción", "string"]]
        def grupos = Grupo.findAllByIdInList(params.tipo)
//        println "grupos: ${grupos}"
        def res = Composicion.findAllByObraAndGrupoInList(obra, grupos)
        res.sort { it.item.codigo }

        duenoObra = esDuenoObra(obra) ? 1 : 0

        def tieneMatriz = false
        cn.eachRow("select count(*) cuenta from mfrb where obra__id = ${obra.id}".toString()) { d ->
            tieneMatriz = d.cuenta > 0
        }

        println "--> ${obra.id}"
        return [res: res, obra: obra, tipo: params.tipo, rend: params.rend, campos: campos, duenoObra: duenoObra,
                persona: persona, tieneMatriz: tieneMatriz]
    }

    def formArchivo() {
        println "formArchivo: $params"
        return [obra: params.id]
    }

    def uploadFile() {
        println "uploadFile: $params"
        def obra = Obra.get(params.id)
        def path = "/var/janus/" + "xlsComposicion/"   //web-app/archivos
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

            if (ext == "xls") {
//                fileName = fileName.tr(/áéíóúñÑÜüÁÉÍÓÚàèìòùÀÈÌÒÙÇç .!¡¿?&#°"'/, "aeiounNUuAEIOUaeiouAEIOUCc_")

                fileName = "xlsComposicion_" + new Date().format("yyyyMMdd_HHmmss")

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
                def file = new File(pathFile)
                Workbook workbook = Workbook.getWorkbook(file)

                workbook.getNumberOfSheets().times { sheet ->
                    if (sheet == 0) {
                        Sheet s = workbook.getSheet(sheet)
                        if (!s.getSettings().isHidden()) {
//                            println s.getName() + "  " + sheet
                            htmlInfo += "<h2>Hoja " + (sheet + 1) + ": " + s.getName() + "</h2>"
                            Cell[] row = null
                            s.getRows().times { j ->
                                def ok = true
//                                if (j > 19) {
//                                println ">>>>>>>>>>>>>>>" + (j + 1)
                                row = s.getRow(j)
//                                println row*.getContents()
//                                println row.length
                                if (row.length >= 5) {
                                    def cod = row[0].getContents()
                                    def nombre = row[1].getContents()
                                    def cant = row[3].getContents()
                                    def nuevaCant = row[4].getContents()

//                                    println "\t\tcod:" + cod + "\tnombre:" + nombre + "\tcant:" + cant + "\tnCant:" + nuevaCant

                                    if (cod != "CODIGO") {
//                                        println "\t\t**"
                                        def item = Item.findAllByCodigo(cod)
//                                        println "\t\t???" + item
                                        if (item.size() == 1) {
                                            //ok
                                            item = item[0]
                                        } else if (item.size() == 0) {
                                            errores += "<li>No se encontró item con código ${cod} (l. ${j + 1})</li>"
                                            println "No se encontró item con código ${cod}"
                                            ok = false
                                        } else {
                                            println "Se encontraron ${item.size()} items con código ${cod}!! ${item.id}"
                                            errores += "<li>Se encontraron ${item.size()} items con código ${cod}!! (l. ${j + 1})</li>"
                                            ok = false
                                        }
                                        if (ok) {
                                            def comp = Composicion.withCriteria {
                                                eq("item", item)
                                                eq("obra", obra)
                                            }
                                            if (comp.size() == 1) {
                                                comp = comp[0]
//                                                comp.cantidad = nuevaCant.toDouble()
                                                comp.cantidad = nuevaCant? nuevaCant.toString().replaceAll(',', '.').toDouble() : 0

                                                if (comp.save(flush: true)) {
                                                    done++
//                                                    println "Modificado comp: ${comp.id}"
                                                    doneHtml += "<li>Se ha modificado la cantidad para el item ${nombre}</li>"
                                                } else {
                                                    println "No se pudo guardar comp ${comp.id}: " + comp.errors
                                                    errores += "<li>Ha ocurrido un error al guardar la cantidad para el item ${nombre} (l. ${j + 1})</li>"
                                                }
//                                            println comp
//                                            /** **/
//                                            row.length.times { k ->
//                                                if (!row[k].isHidden()) {
//                                                    println "k:" + k + "      " + row[k].getContents()
//                                                }// row ! hidden
//                                            } //row.legth.each
                                            } else if (comp.size() == 0) {
                                                println "No se encontró composición para el item ${nombre}"
                                                errores += "<li>No se encontró composición para el item ${nombre} (l. ${j + 1})</li>"
                                            } else {
                                                println "Se encontraron ${comp.size()} composiciones para el item ${nombre}: ${comp.id}"
                                                errores += "<li>Se encontraron ${comp.size()} composiciones para el item ${nombre} (l. ${j + 1})</li>"
                                            }
                                        }
                                    }
                                } //row ! empty
//                                }//row > 7 (fila 9 + )
                            } //rows.each
                        } //sheet ! hidden
                    }//solo sheet 0
                } //sheets.each
                if (done > 0) {
                    doneHtml = "<div class='alert alert-success'>Se han ingresado correctamente " + done + " registros</div>"
                }

                def str = doneHtml
                str += htmlInfo
                if (errores != "") {
                    str += "<ol>" + errores + "</ol>"
                }
                str += doneHtml

                flash.message = str

                println "DONE!! ${obra?.id}"
                redirect(controller: 'composicion', action: "mensajeUpload", id: obra?.id)
            } else {
                flash.message = "Seleccione un archivo Excel xls para procesar (archivos xlsx deben ser convertidos a xls primero)"
                redirect(action: 'formArchivo')
            }
        } else {
            flash.message = "Seleccione un archivo para procesar"
            redirect(action: 'formArchivo', [params: params])
//            println "NO FILE"
        }
    }

    def mensajeUpload() {
        println "mensajeUpload: $params"
        return [obra: params.id]
    }

    def save() {
        println "save comp " + params

        def parts = params.data.split("X")
        parts.each { p ->
            if (p != "") {
                def data = p.split("I")
                if (data[0] != "") {
                    def comp = Composicion.get(data[0])
                    if (comp) {
                        comp.cantidad = data[1].toDouble()
                        comp.save(flush: true)
                    }
                }
            }
        }
        if (params.data2 && params.data2 != "") {
            parts = params.data2.split("X")
            parts.each { p ->
                if (p != "") {
                    def data = p.split("I")
                    if (data[0] != "") {
                        def comp = Composicion.get(data[0])
                        if (comp) {
                            comp.precio = data[1].toDouble()
                            comp.transporte = 0
                            if (!comp.save(flush: true))
                                println "error sva comp " + comp.errors
                        }
                    }
                }
            }
        }

        render "ok"

    }

    def esDuenoObra(obra) {

        def dueno = false
        def funcionElab = Funcion.findByCodigo('E')
        def personasPRSP = PersonaRol.findAllByFuncionAndPersonaInList(funcionElab, Persona.findAllByDepartamento(Departamento.findByCodigo('UTFPU')))
        def responsableRol = PersonaRol.findByPersonaAndFuncion(obra?.responsableObra, funcionElab)

        if (responsableRol) {
            if (obra?.responsableObra?.departamento?.direccion?.id == Persona.get(session.usuario.id).departamento?.direccion?.id) {
                dueno = true
            } else {
                dueno = personasPRSP.contains(responsableRol) && session.usuario.departamento.codigo == 'UTFPU'
            }
        }
        dueno
    }

    def listaItem() {
//        println "listaItem" + params
        def listaItems = ['itemnmbr', 'itemcdgo']
        def datos
        def persona = Persona.get(session.usuario.id)

        /* salen repetidos debido a las varios lgar__id en rbpc*/
        def select = "select distinct r1.item__id, r1.rbpcpcun, itemcdgo, itemnmbr, unddcdgo, grpo__id " +
                "from item, rbpc r1, dprt, sbgr, undd, lgar "
        def txwh = "where undd.undd__id = item.undd__id and dprt.dprt__id = item.dprt__id and " +
                "sbgr.sbgr__id = dprt.sbgr__id and r1.item__id = item.item__id and " +
                "rbpcfcha = (select max(rbpcfcha) from rbpc where item__id = r1.item__id)"
        def sqlTx = ""
        def bsca = listaItems[params.buscarPor.toInteger()-1]
        def ordn = listaItems[params.ordenar.toInteger()-1]
        txwh += " and $bsca ilike '%${params.criterio}%' and grpo__id = ${params.grupo}"

        sqlTx = "${select} ${txwh} order by ${ordn} limit 100 ".toString()
        println "sql: $sqlTx"

        def cn = dbConnectionService.getConnection()
        datos = cn.rows(sqlTx)
//        println "data: ${datos[0]}"
        [data: datos]
    }

    def borrarItem_ajax(){
//        println("params bi " + params)
        def item = Composicion.get(params.id)

        try{
            item.delete(flush:true)
            render "ok"
        }catch(e){
            println("error al borrar el item de la composicion " + item.errors)
            render "no"
        }
    }

    def guardarEditado_ajax(){
        def obra = Obra.get(params.obra)
        def item = Item.get(params.item)
        def composicion = Composicion.get(params.id)
        def band = false

        def existente = Composicion.findByObraAndItem(obra, item)

        if(existente){
            if(existente.id == composicion.id){
                band = true
            }else{
               band = false
            }
        }else{
            band = true
        }

        if(band){
            composicion.item = item
            composicion.cantidad = params.cantidad.toDouble()

            if(!composicion.save(flush:true)){
                println("error al guardar el item en la composicion " + composicion.errors)
                render "no"
            }else{
                render "ok"
            }
        }else{
            println("error ya existe este item en la composicion")
            render "er"
            return
        }
    }
}
