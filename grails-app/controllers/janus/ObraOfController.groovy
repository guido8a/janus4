package janus

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Persona

class ObraOfController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]
    def buscadorService
    def obraService
    def dbConnectionService
    def preciosService



    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [obraInstanceList: Obra.list(params), obraInstanceTotal: Obra.count(), params: params]
    } //list

    def biblioteca() {

    }


    def regitrarObra() {
        println "regitrarObra Oferentes: $params"
        def obra = Obra.get(params.id)
        def obrafp = new ObraFPController()

        def msg = ""
//        def vols = VolumenesObra.findAllByObra(obra)
        def vols = VolumenObraOferente.findAllByObra(obra)
        if (vols.size() < 1) {
            msg = "Error: la obra no tiene volumenes de obra registrados"
            render msg
            return
        }

        println "...1"
        obraService.registrarObra_of(obra)
        obra.estado = "R"

        println(obra.id)
        println(obra.estado)


        if (obra.save(flush: true)) {
            render "ok"
            return
        } else {
            println obra.errors
        }
    }

    def desregitrarObra() {
        def obra = Obra.get(params.id)
        obra.estado = "N"
        if (obra.save(flush: true))
            render "ok"
        return
    }


    def registroObra() {

        def obra
        def obraOferente
        def titulo = "Obras Oferentes"

        def usuario = session.usuario.id

        def persona = Persona.get(usuario)

//        def prov = Provincia.list();
        def campos = ["codigo": ["Código", "string"], "nombre": ["Nombre", "string"], "descripcion": ["Descripción", "string"], "oficioIngreso": ["Memo ingreso", "string"], "oficioSalida": ["Memo salida", "string"], "sitio": ["Sitio", "string"], "plazo": ["Plazo", "int"], "parroquia": ["Parroquia", "string"], "comunidad": ["Comunidad", "string"], "canton": ["Canton", "string"]]
        def listaObra = [1: 'Código', 2: 'Nombre', 5: 'Estado']


        if (params.obra) {
            obra = Obra.get(params.obra)
            def valores = preciosService.rbro_pcun_v4_of(obra.id, 'asc')?.vlobpcun?.sum()
            println "valores: ${valores} "
//            def subs = VolumenesObra.findAllByObra(obra, [sort: "orden"]).subPresupuesto.unique()
//            def volumen = VolumenesObra.findByObra(obra)
//            def formula = FormulaPolinomica.findByObra(obra)
            obraOferente = ObraOferente.findByObraAndOferente(obra, persona)
            titulo = "Oferentes - Obra: ${obra.nombre}"
//            [campos: campos, prov: prov, obra: obra, persona: persona, listaObra: listaObra, titulo: titulo, obraOferente: obraOferente]
            [campos: campos, obra: obra, persona: persona, listaObra: listaObra, titulo: titulo, obraOferente: obraOferente,
            total: valores]
        } else {
//            obra = new Obra();
//             si no se listan las obras, carga la primera obra que halle
//            obra = Obra.findByOferente(persona)
//            if (obra) {
//            def subs = VolumenesObra.findAllByObra(obra, [sort: "orden"]).subPresupuesto.unique()
//            def volumen = VolumenesObra.findByObra(obra)
//            def formula = FormulaPolinomica.findByObra(obra)
//            [campos: campos, prov: prov, obra: obra, subs: subs, persona: persona, formula: formula, volumen: volumen, listaObra: listaObra]
//            } else {
//                [campos: campos, prov: prov,persona: persona, listaObra: listaObra]
//            }

            [obra: obra, listaObra: listaObra, titulo: titulo]
        }


    }

    def buscarObra() {

        def extraParr = ""
        def extraCom = ""
        if (params.campos instanceof java.lang.String) {
            if (params.campos == "parroquia") {
                def parrs = Parroquia.findAll("from Parroquia where nombre like '%${params.criterios.toUpperCase()}%'")
                params.criterios = ""
                parrs.eachWithIndex { p, i ->
                    extraParr += "" + p.id
                    if (i < parrs.size() - 1)
                        extraParr += ","
                }
                if (extraParr.size() < 1)
                    extraParr = "-1"
                params.campos = ""
                params.operadores = ""
            }
            if (params.campos == "comunidad") {
                def coms = Comunidad.findAll("from Comunidad where nombre like '%${params.criterios.toUpperCase()}%'")
                params.criterios = ""
                coms.eachWithIndex { p, i ->
                    extraCom += "" + p.id
                    if (i < coms.size() - 1)
                        extraCom += ","
                }
                if (extraCom.size() < 1)
                    extraCom = "-1"
                params.campos = ""
                params.operadores = ""
            }
        } else {
            def remove = []
            params.campos.eachWithIndex { p, i ->
                if (p == "comunidad") {
                    def coms = Comunidad.findAll("from Comunidad where nombre like '%${params.criterios[i].toUpperCase()}%'")

                    coms.eachWithIndex { c, j ->
                        extraCom += "" + c.id
                        if (j < coms.size() - 1)
                            extraCom += ","
                    }
                    if (extraCom.size() < 1)
                        extraCom = "-1"
                    remove.add(i)
                }
                if (p == "parroquia") {
                    def parrs = Parroquia.findAll("from Parroquia where nombre like '%${params.criterios[i].toUpperCase()}%'")

                    parrs.eachWithIndex { c, j ->
                        extraParr += "" + c.id
                        if (j < parrs.size() - 1)
                            extraParr += ","
                    }
                    if (extraParr.size() < 1)
                        extraParr = "-1"
                    remove.add(i)
                }
            }
            remove.each {
                params.criterios[it] = null
                params.campos[it] = null
                params.operadores[it] = null
            }
        }


        def extras = " "
        if (extraParr.size() > 1)
            extras += " and parroquia in (${extraParr})"
        if (extraCom.size() > 1)
            extras += " and comunidad in (${extraCom})"

        extras += " and oferente=${session.usuario.id}"

        def parr = { p ->
            return p.parroquia?.nombre
        }
        def comu = { c ->
            return c.comunidad?.nombre
        }
        def listaTitulos = ["Código", "Nombre", "Descripción", "Fecha Reg.", "M. ingreso", "M. salida", "Sitio", "Plazo", "Parroquia", "Comunidad", "Inspector", "Revisor", "Responsable", "Estado Obra"]
        def listaCampos = ["codigo", "nombre", "descripcion", "fechaCreacionObra", "oficioIngreso", "oficioSalida", "sitio", "plazo", "parroquia", "comunidad", "inspector", "revisor", "responsable", "estadoObra"]
        def funciones = [null, null, null, ["format": ["dd/MM/yyyy hh:mm"]], null, null, null, null, ["closure": [parr, "&"]], ["closure": [comu, "&"]], null, null, null, null]
        def url = g.createLink(action: "buscarObra", controller: "obra")
        def funcionJs = "function(){"
        funcionJs += '$("#modal-busqueda").modal("hide");'
        funcionJs += 'location.href="' + g.createLink(action: 'registroObra', controller: 'obra') + '?obra="+$(this).attr("regId");'
        funcionJs += '}'
        def numRegistros = 20

        if (!params.reporte) {
            def lista = buscadorService.buscar(Obra, "Obra", "excluyente", params, true, extras) /* Dominio, nombre del dominio , excluyente o incluyente ,params tal cual llegan de la interfaz del buscador, ignore case */
            lista.pop()
            render(view: '../tablaBuscador', model: [listaTitulos: listaTitulos, listaCampos: listaCampos, lista: lista, funciones: funciones, url: url, controller: "llamada", numRegistros: numRegistros, funcionJs: funcionJs, width: 1800, paginas: 12])
        } else {
//            println "entro reporte"
            /*De esto solo cambiar el dominio, el parametro tabla, el paramtero titulo y el tamaño de las columnas (anchos)*/
            session.dominio = Obra
            session.funciones = funciones
            def anchos = [7, 10, 7, 7, 7, 7, 7, 4, 7, 7, 7, 7, 7, 7] /*el ancho de las columnas en porcentajes... solo enteros*/
            redirect(controller: "reportes", action: "reporteBuscador", params: [listaCampos: listaCampos, listaTitulos: listaTitulos, tabla: "Obra", orden: params.orden, ordenado: params.ordenado, criterios: params.criterios, operadores: params.operadores, campos: params.campos, titulo: "Obras", anchos: anchos, extras: extras, landscape: true])
        }
    }


    def mapaObra() {
        def obra = Obra.get(params.id)

        def coordsParts = obra.coordenadas.split(" ")
        def lat, lng

        lat = (coordsParts[0] == 'N' ? 1 : -1) * (coordsParts[1].toInteger() + (coordsParts[2].toDouble() / 60))
        lng = (coordsParts[3] == 'N' ? 1 : -1) * (coordsParts[4].toInteger() + (coordsParts[5].toDouble() / 60))

        return [obra: obra, lat: lat, lng: lng]
    }


    def situacionGeografica() {
        def comunidades

        def orden;

        def colorProv, colorCant, colorParr, colorComn;


        if (params.ordenar == '1') {


            orden = "asc";

        } else {

            orden = "desc";

        }


        switch (params.buscarPor) {

            case "1":


                colorProv = "#00008B";

                if (params.criterio != "") {
                    comunidades = Comunidad.withCriteria {
                        parroquia {
                            canton {
                                provincia {
                                    ilike("nombre", "%" + params.criterio + "%")
                                    order("nombre", orden)
                                }
                                order("nombre", orden)
                            }
                            order("nombre", orden)
                        }
                        order("nombre", orden)
                    }
                } else {
                    comunidades = Comunidad.list(order: "nombre")


                }


                break
            case "2":

                colorCant = "#00008B";

                if (params.criterio != "") {
                    comunidades = Comunidad.withCriteria {
                        parroquia {
                            canton {

                                ilike("nombre", "%" + params.criterio + "%")
                                order("nombre", orden)

                            }
                            order("nombre", orden)
                        }
                        order("nombre", orden)
                    }
                } else {
                    comunidades = Comunidad.list(order: "nombre")
                }

                break
            case "3":


                colorParr = "#00008B";

                if (params.criterio != "") {
                    println params
                    comunidades = Comunidad.withCriteria {
                        parroquia {
                            ilike("nombre", "%" + params.criterio + "%")
                            order("nombre", orden)
                        }
                        order("nombre", orden)
                    }
                } else {
                    comunidades = Comunidad.list()
                }

                break
            case "4":
//

                colorComn = "#00008B";

                if (params.criterio != "") {
                    comunidades = Comunidad.withCriteria {


                        ilike("nombre", "%" + params.criterio + "%")
                        order("nombre", orden)


                    }
                } else {
                    comunidades = Comunidad.list()
                }

                break

        }


        [comunidades: comunidades, colorComn: colorComn, colorProv: colorProv, colorParr: colorParr, colorCant: colorCant]

    }

    def form_ajax() {
        def obraInstance = new Obra(params)
        if (params.id) {
            obraInstance = Obra.get(params.id)
            if (!obraInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Obra con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [obraInstance: obraInstance]
    } //form_ajax

    def save() {

        println "save " + params

        def usuario = session.usuario.id

        def persona = Persona.get(usuario)


        println("usuario" + usuario)
        println("dep" + persona.departamento.id)


        if (params.fechaOficioSalida) {
            params.fechaOficioSalida = new Date().parse("dd-MM-yyyy", params.fechaOficioSalida)
        }

        if (params.fechaPreciosRubros) {
            params.fechaPreciosRubros = new Date().parse("dd-MM-yyyy", params.fechaPreciosRubros)
        }

        if (params.fechaCreacionObra) {
            params.fechaCreacionObra = new Date().parse("dd-MM-yyyy", params.fechaCreacionObra)
        }


        def obraInstance


        if (params.id) {
            obraInstance = Obra.get(params.id)

            if (!obraInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Obra con id " + params.id
                redirect(action: 'registroObra')
                return
            }//no existe el objeto

            def oriM = obraInstance.plazoEjecucionMeses
            def oriD = obraInstance.plazoEjecucionDias

            def valM = params.plazoEjecucionMeses
            def valD = params.plazoEjecucionDias

            if ((params.crono == "1" || params.crono == 1) && (oriM.toDouble() != valM.toDouble() || oriD.toDouble() != valD.toDouble())) {
                //Elimina el cronograma
                println "Elimina el cronograma"
                VolumenesObra.findAllByObra(obraInstance, [sort: "orden"]).each { vol ->
                    Cronograma.findAllByVolumenObra(vol).each { crono ->
                        crono.delete()
                    }
                }
            }

            obraInstance.properties = params
        }//es edit
        else {
            obraInstance = new Obra(params)

            obraInstance.departamento = persona.departamento


            println("AQUIII" + obraInstance.departamento)

            def par = Parametros.list()
            if (par.size() > 0)
                par = par.pop()

            obraInstance.indiceCostosIndirectosObra = par.indiceCostosIndirectosObra
            obraInstance.indiceCostosIndirectosPromocion = par.indiceCostosIndirectosPromocion
            obraInstance.indiceCostosIndirectosMantenimiento = par.indiceCostosIndirectosMantenimiento
            obraInstance.administracion = par.administracion
            obraInstance.indiceCostosIndirectosGarantias = par.indiceCostosIndirectosGarantias
            obraInstance.indiceCostosIndirectosCostosFinancieros = par.indiceCostosIndirectosCostosFinancieros
            obraInstance.indiceCostosIndirectosVehiculos = par.indiceCostosIndirectosVehiculos

            obraInstance.impreso = par.impreso
            obraInstance.indiceUtilidad = par.indiceUtilidad
            obraInstance.indiceCostosIndirectosTimbresProvinciales = par.indiceCostosIndirectosTimbresProvinciales



            obraInstance.indiceGastosGenerales = (obraInstance.indiceCostosIndirectosObra + obraInstance.indiceCostosIndirectosPromocion + obraInstance.indiceCostosIndirectosMantenimiento +
                    obraInstance.administracion + obraInstance.indiceCostosIndirectosGarantias + obraInstance.indiceCostosIndirectosCostosFinancieros + obraInstance.indiceCostosIndirectosVehiculos)

            obraInstance.totales = (obraInstance.impreso + obraInstance.indiceUtilidad + obraInstance.indiceCostosIndirectosTimbresProvinciales + obraInstance.indiceGastosGenerales)

        } //es create
        obraInstance.estado = "N"
        if (!obraInstance.save(flush: true)) {
            flash.clase = "alert-error"
            def str = "<h4>No se pudo guardar Obra " + (obraInstance.id ? obraInstance.id : "") + "</h4>"

            str += "<ul>"
            obraInstance.errors.allErrors.each { err ->
                def msg = err.defaultMessage
                err.arguments.eachWithIndex { arg, i ->
                    msg = msg.replaceAll("\\{" + i + "}", arg.toString())
                }
                str += "<li>" + msg + "</li>"
            }
            str += "</ul>"

            flash.message = str
            redirect(action: 'registroObra')
            return
        } else {

        }

        if (params.id) {
            flash.clase = "alert-success"
            flash.message = "Se ha actualizado correctamente Obra "
        } else {
            flash.clase = "alert-success"
            flash.message = "Se ha creado correctamente Obra "
        }
        redirect(action: 'registroObra', params: [obra: obraInstance.id])
    } //save

    //guardar copia
    def saveCopia() {
        if (params.fechaOficioSalida) {
            params.fechaOficioSalida = new Date().parse("dd-MM-yyyy", params.fechaOficioSalida)
        }

        if (params.fechaPreciosRubros) {
            params.fechaPreciosRubros = new Date().parse("dd-MM-yyyy", params.fechaPreciosRubros)
        }

        if (params.fechaCreacionObra) {
            params.fechaCreacionObra = new Date().parse("dd-MM-yyyy", params.fechaCreacionObra)
        }

        def obraInstance

        def volumenInstance

        def copiaObra

        def obra = Obra.get(params.id);

        def nuevoCodigo = params.nuevoCodigo

        def volumenes = VolumenesObra.findAllByObra(obra);

        obraInstance = Obra.get(params.id)


        def revisarCodigo = Obra.findByCodigo(nuevoCodigo)

        if (revisarCodigo != null) {

            println("entro1")

            render "NO_No se puede copiar la Obra " + " " + obra.nombre + " " + "porque posee un codigo ya existente."
            return


        } else {

            println("entro2")


            obraInstance = new Obra()
            obraInstance.properties = obra.properties
            obraInstance.codigo = nuevoCodigo
            obraInstance.estado = 'N'




            if (!obraInstance.save(flush: true)) {
                flash.clase = "alert-error"
                def str = "<h4>No se pudo copiar la Obra " + (obraInstance.id ? obraInstance.id : "") + "</h4>"

                str += "<ul>"
                obraInstance.errors.allErrors.each { err ->
                    def msg = err.defaultMessage
                    err.arguments.eachWithIndex { arg, i ->
                        msg = msg.replaceAll("\\{" + i + "}", arg.toString())
                    }
                    str += "<li>" + msg + "</li>"
                }
                str += "</ul>"

                render 'NO_' + str
//            return(action: 'registroObra')
                return
            }

            volumenes.each { volOr ->
                volumenInstance = new VolumenesObra()

                println("VO:" + volOr)

                volumenInstance.properties = volOr.properties

                println("VI:" + volumenInstance)
                //

                volumenInstance.obra = obraInstance
                volumenInstance.save(flush: true)
            }
            render 'OK_' + "Obra copiada"
        }

    } //save


    def show_ajax() {
        def obraInstance = Obra.get(params.id)
        if (!obraInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Obra con id " + params.id
            redirect(action: "list")
            return
        }
        [obraInstance: obraInstance]
    } //show


    def crearTipoObra() {

        println(params)

        def tipoObraInstance = new TipoObra(params)
        if (params.id) {
            tipoObraInstance = TipoObra.get(params.id)
            if (!tipoObraInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Tipo Obra con id " + params.id
                redirect(action: "list")
                return
            }
        }
        return [tipoObraInstance: tipoObraInstance]
    }






    def delete() {

        println("delete:" + params.id)

        def obraInstance = Obra.get(params.id)
        if (!obraInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Obra con id " + params.id
            render("no")
            return
        }

        try {
            obraInstance.delete(flush: true)
            flash.clase = "alert-success"
            flash.message = "Se ha eliminado correctamente Obra " + obraInstance.nombre
            render("ok")
        }
        catch (DataIntegrityViolationException e) {
            flash.clase = "alert-error"
            flash.message = "No se pudo eliminar Obra " + (obraInstance.id ? obraInstance.id : "")
            render("no")
        }
    } //delete



    /*lista obrtas */
    def listaObras(){
        println "listaItems" + params
        def datos;
//        [1: 'Código', 2: 'Nombre', 3: 'Mem. Ingreso', 4: 'Mem. Salida', 5: 'Estado']
        def listaObra = ['obracdgo', 'obranmbr', 'obrammig', 'obrammsl', 'obraetdo']

        def select = "select obra.obra__id, obracdgo, obranmbr, obraetdo, dptodscr, obrafcha " +
                "from obra, parr, dpto, obof "
        def txwh = "where parr.parr__id = obra.parr__id and dpto.dpto__id = obra.dpto__id and " +
                "obof.obra__id = obra.obra__id and obof.prsn__id = ${session.usuario.id}"
        def sqlTx = ""
        def bsca = listaObra[params.buscarPor.toInteger()-1]
        def ordn = listaObra[params.ordenar.toInteger()-1]

        txwh += " and $bsca ilike '%${params.criterio}%'"
        sqlTx = "${select} ${txwh} order by obranmbr, ${ordn} limit 100 ".toString()
        println "sql: $sqlTx"

        def cn = dbConnectionService.getConnection()
        datos = cn.rows(sqlTx.toString())
//        println "data: ${datos[0]}"
        [data: datos, tipo: params.tipo]

    }

    def importarObra_ajax(){


    }

    def verificaRbof_ajax() {
        println "verificaRbof_ajax"
        def cn = dbConnectionService.getConnection()
        def sql = "select rbofcdgo, item__id from rbof where rbofcdgo in " +
                "(select item__id from vlof where obra__id = ${params.obra}) and " +
                "rbof.obra__id = ${params.obra} group by rbofcdgo, item__id having count(*) > 1 "
        println "sql: $sql"
        def rubros = "("
        cn.eachRow(sql.toString()) { d->
            if(!rubros.contains(d.rbofcdgo.toString())) {
                rubros += d.rbofcdgo
            }
        }
        rubros += ")"
        println "rubros: $rubros"
        def datos = []
        if(rubros != "()"){
            sql = "select rbof__id, r.itemnmbr rubro, i.itemnmbr item, rbofcntd, rbofrndt " +
                    "from rbof, item r, item i where obra__id = ${params.obra} and rbofcdgo in ${rubros} and " +
                    "r.item__id = rbofcdgo and i.item__id = rbof.item__id order by rbofcdgo, i.item__id"
            println "sql: $sql"
        } else {

        }

        datos = cn.rows(sql.toString())
//        println "data: ${datos[0]}"
        [datos: datos]
    }

    def borrarRepetido_ajax(){
        def rubro = RubroOferente.get(params.id)
        println "borra: $params --> ${rubro.item.nombre}"
        if(rubro){
            try{
                rubro.delete(flush:true)
                render "ok_Borrado correctamente"
            }catch(e){
                println("Error al borrar el rubro " + rubro.errors)
                render "no_Error al borrar el rubro"
            }
        }else{
            render "no_No se ha ubicado el rubro"
        }
    }


} //fin controller
