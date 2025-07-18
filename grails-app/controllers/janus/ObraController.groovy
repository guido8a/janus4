package janus

import janus.pac.DocumentoObra
import janus.pac.TipoProcedimiento
import org.springframework.dao.DataIntegrityViolationException
import seguridad.Persona
import seguridad.Prfl
import seguridad.Sesn

class ObraController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]
    def buscadorService
    def obraService
    def dbConnectionService

    def index() {
        redirect(action: "registroObra", params: params)
    } //index

    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [obraInstanceList: Obra.list(params), obraInstanceTotal: Obra.count(), params: params]
    } //list

    def biblioteca() {

    }

    def iniciarObraAdm() {
        println "incio obra dm " + params
        def obra = Obra.get(params.obra)
        def fecha
        try {
            fecha = new Date().parse("dd-MM-yyyy", params.fecha)
            if (fecha > obra.fechaCreacionObra) {
                if (!obra.fechaInicio) {
                    obra.tipo = "D"
                    obra.fechaInicio = fecha
                    obra.observacionesInicioObra = params.obs
                    obra.save(flush: true)
                    render "ok"
                    return

                } else {
                    render "error"
                    return
                }

            } else {
                render "La fecha de inicio de la obra debe ser mayor a ${obra.fechaCreacionObra.format('dd-MMM-yyyy')}"
                return
            }
        } catch (e) {
            println "error fecha " + e
            render "error"
            return
        }
    }

    def obrasFinalizadas() {
        def perfil = session.perfil.id
        def cn = dbConnectionService.getConnection()
        def departamento = [:]
        def sql = "select distinct obra.dpto__id id, diredscr||' - '||dptodscr nombre " +
                "from obra, dpto, dire " +
                "where dpto.dpto__id = obra.dpto__id and dire.dire__id = dpto.dire__id and " +
                "obrafcin is not null " +
                "order by 2"
        println "sqlReg: $sql"
        cn.eachRow(sql.toString()) { r ->
            departamento[r.id] = r.nombre
        }

        def campos = ["codigo": ["Código", "string"], "nombre": ["Nombre", "string"],
                      "descripcion": ["Descripción", "string"], "oficioIngreso": ["Memo ingreso", "string"],
                      "oficioSalida": ["Memo salida", "string"], "sitio": ["Sitio", "string"],
                      "plazoEjecucionMeses": ["Plazo", "number"], "parroquia": ["Parroquia", "string"],
                      "comunidad": ["Comunidad", "string"], "departamento": ["Dirección", "string"],
                      "fechaCreacionObra": ["Fecha", "date"]]
        [campos: campos, perfil: perfil, departamento: departamento]
    }

    /*lista obrtas */
    def listaObras(){
        println "listaItems" + params
        def datos;
//        [1: 'Código', 2: 'Nombre', 3: 'Mem. Ingreso', 4: 'Mem. Salida', 5: 'Estado']
        def listaObra = ['obracdgo', 'obranmbr', 'obrammig', 'obrammsl', 'obraetdo']

        def select = "select obra.obra__id, obracdgo, obranmbr, obraetdo, dptodscr, obrafcha " +
                "from obra, parr, dpto "
        def txwh = "where parr.parr__id = obra.parr__id and dpto.dpto__id = obra.dpto__id "
        def sqlTx = ""
        def bsca = listaObra[params.buscarPor.toInteger()-1]
        def ordn = listaObra[params.ordenar.toInteger()-1]

        txwh += " and $bsca ilike '%${params.criterio}%'"
        sqlTx = "${select} ${txwh} order by obranmbr, ${ordn} limit 100 ".toString()
        println "sql: $sqlTx"

        def cn = dbConnectionService.getConnection()
        datos = cn.rows(sqlTx)
//        println "data: ${datos[0]}"
        [data: datos, tipo: params.tipo]

    }



    def buscarObraFin() {
//        println "buscar obra fin"

        def extraParr = ""
        def extraCom = ""
        def extraDep = ""

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
            if (params.campos == "departamento") {
                def dirs = Direccion.findAll("from Direccion where nombre like '%${params.criterios.toUpperCase()}%'")
                def deps = Departamento.findAllByDireccionInList(dirs)
                params.criterios = ""
                deps.eachWithIndex { p, i ->
                    extraDep += "" + p.id
                    if (i < deps.size() - 1)
                        extraDep += ","
                }
                if (extraDep.size() < 1)
                    extraDep = "-1"
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
                if (p == "departamento") {
                    def dirs = Direccion.findAll("from Direccion where nombre like '%${params.criterios.toUpperCase()}%'")
                    def deps = Departamento.findAllByDireccionInList(dirs)

                    deps.eachWithIndex { c, j ->
                        extraDep += "" + c.id
                        if (j < deps.size() - 1)
                            extraDep += ","
                    }
                    if (extraDep.size() < 1)
                        extraDep = "-1"
                    remove.add(i)
                }
            }
            remove.each {
                params.criterios[it] = null
                params.campos[it] = null
                params.operadores[it] = null
            }
        }


        def extras = " and liquidacion=0 and fechaFin is not null"
        if (extraParr.size() > 1)
            extras += " and parroquia in (${extraParr})"
        if (extraCom.size() > 1)
            extras += " and comunidad in (${extraCom})"
        if (extraDep.size() > 1)
            extras += " and departamento in (${extraDep})"

//        println "extas "+extras
        def parr = { p ->
            return p.parroquia?.nombre
        }
        def comu = { c ->
            return c.comunidad?.nombre
        }
        def listaTitulos = ["CODIGO", "NOMBRE", "DIRECCION", "FECHA REG.", "SITIO", "PARROQUIA", "COMUNIDAD", "FECHA INICIO", "FECHA FIN"]
        def listaCampos = ["codigo", "nombre", "departamento", "fechaCreacionObra", "sitio", "parroquia", "comunidad", "fechaInicio", "fechaFin"]
        def funciones = [null, null, null, ["format": ["dd/MM/yyyy"]], null, ["closure": [parr, "&"]], ["closure": [comu, "&"]], ["format": ["dd/MM/yyyy"]], ["format": ["dd/MM/yyyy"]]]
        def url = g.createLink(action: "buscarObraFin", controller: "obra")
        def funcionJs = "function(){"
        funcionJs += '$("#modal-busqueda").modal("hide");'
        funcionJs += 'location.href="' + g.createLink(action: 'registroObra', controller: 'obra') + '?obra="+$(this).attr("regId");'
        funcionJs += '}'
        def numRegistros = 20
//        println "params " + params.reporte + "  " + params.excel

        if (!params.reporte) {
            if (params.excel) {
                session.dominio = Obra
                session.funciones = funciones
                def anchos = [15, 50, 70, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20]
                /*anchos para el set column view en excel (no son porcentajes)*/
                redirect(controller: "reportes", action: "reporteBuscadorExcel", params: [listaCampos: listaCampos, listaTitulos: listaTitulos, tabla: "Obra", orden: params.orden, ordenado: params.ordenado, criterios: params.criterios, operadores: params.operadores, campos: params.campos, titulo: "Obras", anchos: anchos, extras: extras, landscape: true])
            } else {
                def lista = buscadorService.buscar(Obra, "Obra", "excluyente", params, true, extras)
                /* Dominio, nombre del dominio , excluyente o incluyente ,params tal cual llegan de la interfaz del buscador, ignore case */
                lista.pop()
                render(view: '../tablaBuscador', model: [listaTitulos: listaTitulos, listaCampos: listaCampos, lista: lista, funciones: funciones, url: url, controller: "obra", numRegistros: numRegistros, funcionJs: funcionJs, width: 1800, paginas: 12])
            }

        } else {
//            println "entro reporte"
            /*De esto solo cambiar el dominio, el parametro tabla, el paramtero titulo y el tamaño de las columnas (anchos)*/
            session.dominio = Obra
            session.funciones = funciones
            def anchos = [7, 16, 23, 8, 10, 10, 10, 8, 8]
            /*el ancho de las columnas en porcentajes... solo enteros*/
            redirect(controller: "reportes", action: "reporteBuscador", params: [listaCampos: listaCampos, listaTitulos: listaTitulos, tabla: "Obra", orden: params.orden, ordenado: params.ordenado, criterios: params.criterios, operadores: params.operadores, campos: params.campos, titulo: "REPORTE DE OBRAS FINALIZADAS", anchos: anchos, extras: extras, landscape: true])
        }
    }


    def regitrarObra() {
        def cn = dbConnectionService.getConnection()
        def obra = Obra.get(params.id)

        def msg = ""
        def vols = VolumenesObra.findAllByObra(obra)
        if (vols.size() < 1) {
            msg = "Error: la obra no tiene volumenes de obra registrados"
            render msg
            return
        }
        def crono = 0
        vols.each {
            def tmp = Cronograma.findAllByVolumenObra(it)
            println "crono: ${tmp.size()}"
            if(tmp.size() > 0){
                tmp.each { tm ->
                    crono += tm.porcentaje
                }
//            println "volObra: " + it.item.codigo + " tmp " + tmp.volumenObra.id + "  " + tmp.porcentaje + "  " + tmp.precio + "  " + tmp.cantidad
//            println "crono " + crono
                if (crono.toDouble().round(2) != 100.00) {
                    msg += "<br><span class='label-azul'>Error:</span> La suma de porcentajes del volumen de obra: ${it.item.codigo} (${crono.toDouble().round(2)}) en el cronograma es diferente de 100%"
                }
                crono = 0
            }else{
                msg += ''
            }
        }

        println "msg: ${(msg != "")}"
        if (msg != "") {
            render msg
            return
        }

//        def res = obrafp.verificaMatriz(obra.id)
        def res = verificaMatriz(obra.id)
        if (res != "") {
            msg = res
            println "1 res "+msg
            render msg
            return
        }

        println "....ok"

//        res = obrafp.verifica_precios(obra.id)
        res = verifica_precios(obra.id)
        if (res.size() > 0) {
            msg = "<span style='color:red'>Errores detectados</span><br> <span class='label-azul'>No se encontraron precios para los siguientes items:</span><br>"
            msg += res.collect { "<b>ITEM</b>: $it.key ${it.value.join(", <b>Lista</b>: ")}" }.join('<br>')
            render msg
            return
        }
        println "2 res "+msg

        def fps = FormulaPolinomica.findAllByObra(obra)
//        println "fps "+fps
        def totalP = 0
        fps.each { fp ->
            if (fp.numero =~ "p") {
//                println "sumo "+fp.numero+"  "+fp.valor
                totalP += fp.valor
            }
        }

        def totalC = 0
        fps.each { fp ->
            if (fp.numero =~ "c") {
//                println "sumo "+fp.numero+"  "+fp.valor
                totalC += fp.valor
            }
        }
//        println "totp "+totalP
        def valorMenorCuantia = TipoProcedimiento.findBySigla("MCD")?.techo
        def consultoria = janus.Parametros.findByEmpresaLike(message(code: 'ambiente2'))
        if(consultoria) valorMenorCuantia = 0
        println "es consultoría: ${consultoria}"
        def valorObra = obra.valor
        if (valorObra <= valorMenorCuantia) {
            if (obra.tipo != 'D') {
                if (totalP.toDouble().round(6) != 1.000) {
                    render "La suma de los coeficientes de la formula polinómica (${totalP}) es diferente a 1.000"
                    return
                }
                if (totalC.toDouble().round(6) != 1.000) {
                    render "La suma de los coeficientes de la Cuadrilla tipo (${totalC}) es diferente a 1.000"
                    return
                }
            }
        }

        def documentos = DocumentoObra.findAllByObra(obra)
        if (documentos.size() < 2) {
            render "Debe ingresar al menos 2 documentos en la biblioteca de la obra: 'Plano' y 'Justificativo de cantidad de obra'"
            return
        } else {
            def plano = documentos.findAll { it.nombre.toLowerCase().contains("plano") }
            if (plano.size() == 0) {
                render "Debe ingresar un documento en la biblioteca de la obra con nombre 'Plano'"
                return
            }
            def justificacion = documentos.findAll { it.nombre.toLowerCase().contains("justificativo") }
            if (justificacion.size() == 0) {
                render "Debe ingresar un documento en la biblioteca de la obra con nombre 'Justificativo de cantidad de obra'"
                return
            }
        }


        obraService.registrarObra(obra)
        obra.estado = "R"
        obra.desgloseTransporte = null  //obliga a genrar matriz con valores históricos almacenados por grst_obra

        if (obra.save(flush: true)) {

            def sql1 = "delete from mfcl where obra__id = ${obra?.id}"
            def sql2 = "delete from mfvl where obra__id = ${obra?.id}"
            def sql3 = "delete from mfrb where obra__id = ${obra?.id}"
            cn.execute(sql1)
            cn.execute(sql2)
            cn.execute(sql3)

            render "ok"
            return
        }
    }

    def desregitrarObra() {
        def obra = Obra.get(params.id)
        obra.estado = "N"
        if (obra.save(flush: true))
            render "ok"
        else
            println "error: " + obra.errors
        return
    }

    def calculaPlazo() {
        //println "calculaPlazo: " + params
        def obra = Obra.get(params.id)

        if (!params.personas) params.personas = obra.plazoPersonas
        if (!params.maquinas) params.maquinas = obra.plazoMaquinas
        if (!params.save) params.save = "0"

        def sqlM = "select itemcdgo, itemnmbr, sum(itemcntd) itemcntd, sum(itemcntd/8) dias " +
                "from obra_comp_v2(${params.id}) where grpo__id = 2 and itemcntd > 0 group by itemcdgo, itemnmbr order by dias desc"
        def sqlR = "select itemcdgo, itemnmbr, unddcdgo, sum(rbrocntd) rbrocntd, sum(dias) dias " +
                "from plazo(${params.id},${params.personas},${params.maquinas},${params.save}) group by itemcdgo, itemnmbr, unddcdgo"
        //println sqlM
        //println sqlR
        def cn = dbConnectionService.getConnection()
        def resultM = cn.rows(sqlM.toString())
        def resultR = cn.rows(sqlR.toString())

        //println "\n\n"
        //println resultM
        //println resultR
        //println "\n\n"

        if (params.save.toString() == "0") {
            return [obra: obra, resultM: resultM, resultR: resultR, params: params]
        } else {
            obra.plazoPersonas = params.personas.toInteger()
            obra.plazoMaquinas = params.maquinas.toInteger()
            obra.plazoEjecucionMeses = params.plazoMeses.toInteger()
            obra.plazoEjecucionDias = params.plazoDias.toInteger()

            if (!obra.save(flush: true)) {
                println "error: " + obra.errors
                flash.clase = "alert-error"
                flash.message = "Ha ocurrido un error al guardar el plazo de la obra"
                return [obra: obra, resultM: resultM, resultR: resultR, params: params]
            } else {
                flash.clase = "alert-success"
                flash.message = "Plazo actualizado correctamente"
                redirect(action: "registroObra", params: [obra: obra.id])
            }
        }
    }

    def savePlazo() {
        def obra = Obra.get(params.id)
        obra.plazoEjecucionMeses = params.plazoMeses.toInteger()
        obra.plazoEjecucionDias = params.plazoDias.toInteger()
        if (!obra.save(flush: true)) {
            println "error: " + obra.errors
            flash.clase = "alert-error"
            flash.message = "Ha ocurrido un error al modificar el plazo de la obra"
        } else {
            flash.clase = "alert-success"
            flash.message = "Plazo actualizado correctamente"
        }
        redirect(action: "registroObra", params: [obra: obra.id])
    }

    def updateCoords() {

    }

    def existeFP() {
        def obra = Obra.get(params.obra.toLong())
        def fps = FormulaPolinomica.countByObra(obra)
        render fps != 0
    }

    def cambiarAdminDir() {
        def obra = Obra.get(params.id)
        obra.tipo = 'D'
        if (!obra.save(flush: true)) {
            flash.message = g.renderErrors(bean: obra)
        }
        redirect(action: "registroObra", params: [obra: obra.id])
    }

    def saveMemoSIF() {
        def obra = Obra.get(params.obra)
        def memo = params.memo.trim().toUpperCase()
        obra.memoSif = memo
        if (obra.save(flush: true)) {
            render "OK_${memo}"
        } else {
            render "NO_" + obra.errors
        }
    }

    def aprobarSif() {
        def obra = Obra.get(params.obra)
        obra.estadoSif = "R"
        obra.save(flush: true)
        flash.message = "Memo S.I.F. aprobado"
        render "ok"
    }

    def registroObra() {

        def cn = dbConnectionService.getConnection()
//        println "---" + params
        def obra
        def perfil = session.perfil
        def persona = Persona.get(session.usuario.id)
        def direccion = Direccion.get(persona?.departamento?.direccion?.id)
        def grupo = Grupo.findByDireccion(direccion)
        def departamentos = Departamento.findAllByDireccion(direccion)
        def programa
        def tipoObra
        def claseObra
        def duenoObra = 0
        def funcionElab = Funcion.findByCodigo('E')
        def personasUtfpu1 = Persona.findAllByDepartamento(Departamento.findByCodigo('CRFC'))
        def personasUtfpu = PersonaRol.findAllByFuncionAndPersonaInList(funcionElab, personasUtfpu1)
        def responsableObra

        def fechaPrecio = new Date()
        cn.eachRow("select max(rbpcfcha) fcha from rbpc, item where rbpc.item__id = item.item__id and " +
                "itemnmbr ilike '%cemento%port%'") { d ->
            fechaPrecio = d.fcha
        }

        def listaObra = [1: 'Código', 2: 'Nombre', 3: 'Mem. Ingreso', 4: 'Mem. Salida', 5: 'Estado']
        def sbprMF = [:]

        programa = Programacion.list([sort: 'descripcion']);
        tipoObra = TipoObra.list([sort: 'descripcion']);
        claseObra = ClaseObra.list([sort: 'descripcion']);

        def matrizOk = false
//        println "...1"
        def prov = Provincia.list();
        def campos = ["codigo": ["Código", "string"], "nombre": ["Nombre", "string"], "descripcion": ["Descripción", "string"], "oficioIngreso": ["Memo ingreso", "string"], "oficioSalida": ["Memo salida", "string"], "sitio": ["Sitio", "string"], "plazoEjecucionMeses": ["Plazo", "number"], "canton": ["Canton", "string"], "parroquia": ["Parroquia", "string"], "comunidad": ["Comunidad", "string"], "departamento": ["Dirección", "string"], "fechaCreacionObra": ["Fecha", "date"], "estado": ["Estado", "string"], "valor": ["Monto", "number"]]
        def camposCPC = ["numero": ["Código", "string"], "descripcion": ["Descripción", "string"]]
        if (params.obra) {
            obra = Obra.get(params.obra)
            cn.eachRow("select distinct sbpr__id from mfrb where obra__id = ${obra.id} order by sbpr__id".toString()) { d ->
                if(d.sbpr__id == 0)
                    sbprMF << ["0" : 'Todos los subpresupuestos']
                else
                    sbprMF << ["${d.sbpr__id}" : SubPresupuesto.get(d.sbpr__id).descripcion]
            }

            def subs = VolumenesObra.findAllByObra(obra).subPresupuesto.unique().sort{it.id}
            def volumen = VolumenesObra.findByObra(obra)
            def formula = FormulaPolinomica.findByObra(obra)

            def sqlVer = "SELECT voit__id id FROM  vlobitem WHERE obra__id= ${params.obra}"
            def verif = cn.rows(sqlVer.toString())
            def verifOK = false

            if (verif != []) {

                verifOK = true
            }

            def sqlMatriz = "select count(*) cuantos from mfcl where obra__id = ${params.obra}"
            println "matriz: $sqlMatriz"
            def matriz = cn.rows(sqlMatriz.toString())[0].cuantos
            if (matriz > 0) {
                matrizOk = true
            }
            def concurso = janus.pac.Concurso.findByObra(obra)
//            println "concursos: ${concurso?.fechaLimiteEntregaOfertas}"
            if (concurso) {
                if (!concurso.fechaLimiteEntregaOfertas)
                    concurso = null

            }
            cn.close()

            duenoObra = esDuenoObra(obra) ? 1 : 0
            println "dueño: $duenoObra, concurso: $concurso, obra: ${obra.estadoSif}"

            def existeObraOferente = ObraOferente.findByIdJanus(obra)

            [campos: campos, camposCPC: camposCPC, prov: prov, obra: obra, subs: subs, persona: persona, formula: formula, volumen: volumen,
             matrizOk: matrizOk, verif: verif, verifOK: verifOK, perfil: perfil, programa: programa, tipoObra: tipoObra,
             claseObra: claseObra, grupoDir: grupo, dire  : direccion, depar: departamentos, concurso: concurso,
             personasUtfpu: personasUtfpu, duenoObra: duenoObra, sbprMF: sbprMF, listaObra: listaObra, existeObraOferente: existeObraOferente]
        } else {

            duenoObra = 0
//            println "...ok"
            [campos: campos, camposCPC: camposCPC, prov: prov, persona: persona, matrizOk: matrizOk, perfil: perfil, programa: programa,
             tipoObra: tipoObra, claseObra: claseObra, grupoDir: grupo, dire: direccion, depar: departamentos,
             fcha: fechaPrecio, personasUtfpu: personasUtfpu, duenoObra: duenoObra, sbprMF:sbprMF, listaObra: listaObra]
        }
    }

    def esDuenoObra(obra) {
        return obraService.esDuenoObra(obra, session.usuario.id)

/*
        def dueno = false
        def funcionElab = Funcion.findByCodigo('E')
        def personasUtfpu = PersonaRol.findAllByFuncionAndPersonaInList(funcionElab, Persona.findAllByDepartamento(Departamento.findByCodigo('CRFC')))
        def responsableRol = PersonaRol.findByPersonaAndFuncion(obra?.responsableObra, funcionElab)

        if (responsableRol) {
            if (obra?.responsableObra?.departamento?.direccion?.id == Persona.get(session.usuario.id).departamento?.direccion?.id) {
                dueno = true
            } else {
                dueno = personasUtfpu.contains(responsableRol) && session.usuario.departamento.codigo == 'CRFC'
            }
        }
        dueno
*/
    }


    def generaNumeroFP() {

        println("FP:" + params)
        /*
        El sistema debe generar un número de fórmula polinómica de liquidación en el formato: FP-nnn-CEV-13-LIQ,
        para oferentes:  FP-nnn-CEV-13-OFE. Para las otras obras el formato se mantiene (FP-nnn-CEV-13).

                1. Obra normal          int obra.liquidacion = 0        FP-nnn-CEV-13
                2. Obra liquidación     int obra.liquidacion = 1        FP-nnn-CEV-13-LIQ
                3. Obra de oferentes    int obra.liquidacion = 2        FP-nnn-CEV-13-OFE
         */

        def obra = Obra.get(params.obra)
        if (!obra) {
            render "NO_No se encontró la obra"
            return
        }
        if (obra.formulaPolinomica && obra.formulaPolinomica != "") {
            render "OK_" + obra.formulaPolinomica
            return
        }
        def dpto = obra.departamento
//        println "........." + obra.id
//        println "........." + dpto
//        println "........." + dpto.documento
//        println "........." + dpto.fechaUltimoDoc
//        println "........." + dpto.codigo

        def numActual = dpto.documento
        def num = numActual ?: 0 + 1
        if (dpto.fechaUltimoDoc && dpto.fechaUltimoDoc.format("yy") != new Date().format("yy")) {
            num = 1
        }
        def numero = "FP-" + num
        if (dpto.codigo) {
            numero += "-" + dpto.codigo
        } else {
            dpto.codigo = dpto.id
            numero += "-" + dpto.codigo
        }
        numero += "-" + (new Date().format("yy"))

        if (obra.liquidacion == 1) {
            numero += "-LIQ"
        } else if (obra.liquidacion == 2) {
            numero += "-OFE"
        }
        println("numero:" + numero)
        obra.formulaPolinomica = numero
        if (obra.save(flush: true)) {
            dpto.documento = num
            if (!dpto.save(flush: true)) {
                println "Error al guardar el num de doc en del dpto: " + dpto.errors
                render "NO_" + renderErrors(bean: dpto)
                obra.formulaPolinomica = null
                obra.save(flush: true)
            } else {
                render "OK_" + numero
            }
        } else {
            println "Error al generar el numero FP: " + obra.errors
            render "NO_" + renderErrors(bean: obra)
        }
    }

    def buscarObra() {
//        println "buscar obra "+params
        def extraParr = ""
        def extraCom = ""
        def extraDep = ""
        def extraCan = ""

        if (params.campos instanceof java.lang.String) {
            if (params.criterios != "") {
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
                if (params.campos == "canton") {
                    println "busca canton"
                    def cans = Canton.findAll("from Canton where nombre like '%${params.criterios.toUpperCase()}%'")
                    params.criterios = ""
                    cans.eachWithIndex { p, i ->
                        def parrs = Parroquia.findAllByCanton(p)
                        parrs.eachWithIndex { pa, k ->
                            extraCan += "" + pa.id
                            if (k < parrs.size() - 1)
                                extraCan += ","
                        }
                    }
                    if (extraCan.size() < 1)
                        extraCan = "-1"
//                    println "extra can "+extraCan
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
                if (params.campos == "departamento") {
                    def dirs = Direccion.findAll("from Direccion where nombre like '%${params.criterios.toUpperCase()}%'")
                    def deps = Departamento.findAllByDireccionInList(dirs)
                    params.criterios = ""
                    deps.eachWithIndex { p, i ->
                        extraDep += "" + p.id
                        if (i < deps.size() - 1)
                            extraDep += ","
                    }
                    if (extraDep.size() < 1)
                        extraDep = "-1"
                    params.campos = ""
                    params.operadores = ""
                }
            }

        } else {
            def remove = []
            params.campos.eachWithIndex { p, i ->
                if (params.criterios[i] != "") {
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
                    if (p == "canton") {
                        def cans = Canton.findAll("from Canton where nombre like '%${params.criterios[i].toUpperCase()}%'")

                        cans.eachWithIndex { c, j ->
                            def parrs = Parroquia.findAllByCanton(c)
                            parrs.eachWithIndex { pa, k ->
                                extraCan += "" + pa.id
                                if (k < parrs.size() - 1)
                                    extraCan += ","
                            }
                        }
                        if (extraCan.size() < 1)
                            extraCan = "-1"
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
                    if (p == "departamento") {
                        def dirs = Direccion.findAll("from Direccion where nombre like '%${params.criterios.toUpperCase()}%'")
                        def deps = Departamento.findAllByDireccionInList(dirs)

                        deps.eachWithIndex { c, j ->
                            extraDep += "" + c.id
                            if (j < deps.size() - 1)
                                extraDep += ","
                        }
                        if (extraDep.size() < 1)
                            extraDep = "-1"
                        remove.add(i)
                    }
                }

            }
            remove.each {
                params.criterios[it] = null
                params.campos[it] = null
                params.operadores[it] = null
            }
        }


        def extras = " and liquidacion=0"
        if (extraParr.size() > 0)
            extras += " and parroquia in (${extraParr})"
        if (extraCan.size() > 0)
            extras += " and parroquia in (${extraCan})"
        if (extraCom.size() > 0)
            extras += " and comunidad in (${extraCom})"
        if (extraDep.size() > 0)
            extras += " and departamento in (${extraDep})"

//        println "extas "+extras
        def parr = { p ->
            return p.parroquia?.nombre
        }
        def comu = { c ->
            return c.comunidad?.nombre
        }
        def listaTitulos = ["CODIGO", "NOMBRE", "DESCRIPCION", "DIRECCION", "FECHA REG.", "M. INGRESO", "M. SALIDA", "SITIO", "PLAZO", "PARROQUIA", "COMUNIDAD", "INSPECTOR", "REVISOR", "RESPONSABLE", "ESTADO", "MONTO"]
        def listaCampos = ["codigo", "nombre", "descripcion", "departamento", "fechaCreacionObra", "oficioIngreso", "oficioSalida", "sitio", "plazoEjecucionMeses", "parroquia", "comunidad", "inspector", "revisor", "responsableObra", "estado", "valor"]
        def funciones = [null, null, null, null, ["format": ["dd/MM/yyyy hh:mm"]], null, null, null, null, ["closure": [parr, "&"]], ["closure": [comu, "&"]], null, null, null, null]
        def url = g.createLink(action: "buscarObra", controller: "obra")
        def funcionJs = "function(){"
        funcionJs += '$("#modal-busqueda").modal("hide");'
        funcionJs += 'location.href="' + g.createLink(action: 'registroObra', controller: 'obra') + '?obra="+$(this).attr("regId");'
        funcionJs += '}'
        def numRegistros = 20
        println "params " + params.reporte + "  " + params.excel

        if (!params.reporte) {
            if (params.excel) {
                session.dominio = Obra
                session.funciones = funciones
                def anchos = [15, 50, 70, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 10]
                /*anchos para el set column view en excel (no son porcentajes)*/
                redirect(controller: "reportes", action: "reporteBuscadorExcel", params: [listaCampos: listaCampos, listaTitulos: listaTitulos, tabla: "Obra", orden: params.orden, ordenado: params.ordenado, criterios: params.criterios, operadores: params.operadores, campos: params.campos, titulo: "Obras", anchos: anchos, extras: extras, landscape: true])
            } else {
                def lista = buscadorService.buscar(Obra, "Obra", "excluyente", params, true, extras)
                /* Dominio, nombre del dominio , excluyente o incluyente ,params tal cual llegan de la interfaz del buscador, ignore case */
                lista.pop()
                render(view: '../tablaBuscador', model: [listaTitulos: listaTitulos, listaCampos: listaCampos, lista: lista, funciones: funciones, url: url, controller: "obra", numRegistros: numRegistros, funcionJs: funcionJs, width: 1800, paginas: 12])
            }

        } else {
//            println "entro reporte"
            /*De esto solo cambiar el dominio, el parametro tabla, el paramtero titulo y el tamaño de las columnas (anchos)*/
            session.dominio = Obra
            session.funciones = funciones
            def anchos = [7, 10, 7, 7, 7, 7, 7, 7, 4, 7, 7, 7, 7, 7, 7, 7]
            /*el ancho de las columnas en porcentajes... solo enteros*/
            redirect(controller: "reportes", action: "reporteBuscador", params: [listaCampos: listaCampos, listaTitulos: listaTitulos, tabla: "Obra", orden: params.orden, ordenado: params.ordenado, criterios: params.criterios, operadores: params.operadores, campos: params.campos, titulo: "Lista de obras", anchos: anchos, extras: extras, landscape: true])
        }
    }

    def buscarObraLq() {
        println "buscar obra LQ"
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


        def extras = " and liquidacion=1"
        if (extraParr.size() > 1)
            extras += " and parroquia in (${extraParr})"
        if (extraCom.size() > 1)
            extras += " and comunidad in (${extraCom})"

        def parr = { p ->
            return p.parroquia?.nombre
        }
        def comu = { c ->
            return c.comunidad?.nombre
        }
        def listaTitulos = ["CODIGO", "NOMBRE", "DESCRIPCION", "FECHA REG.", "M. INGRESO", "M. SALIDA", "SITIO", "PLAZO", "PARROQUIA", "COMUNIDAD", "INSPECTOR", "REVISOR", "RESPONSABLE", "ESTADO"]
        def listaCampos = ["codigo", "nombre", "descripcion", "fechaCreacionObra", "oficioIngreso", "oficioSalida", "sitio", "plazo", "parroquia", "comunidad", "inspector", "revisor", "responsableObra", "estado"]
        def funciones = [null, null, null, ["format": ["dd/MM/yyyy hh:mm"]], null, null, null, null, ["closure": [parr, "&"]], ["closure": [comu, "&"]], null, null, null, null]
        def url = g.createLink(action: "buscarObraLq", controller: "obra")
        def funcionJs = "function(){"
        funcionJs += '$("#modal-busqueda").modal("hide");'
        funcionJs += 'location.href="' + g.createLink(action: 'registroObra', controller: 'obra') + '?obra="+$(this).attr("regId");'
        funcionJs += '}'
        def numRegistros = 20
        println "params " + params.reporte + "  " + params.excel

        if (!params.reporte) {
            if (params.excel) {
                session.dominio = Obra
                session.funciones = funciones
                def anchos = [15, 50, 70, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20]
                /*anchos para el set column view en excel (no son porcentajes)*/
                redirect(controller: "reportes", action: "reporteBuscadorExcel", params: [listaCampos: listaCampos, listaTitulos: listaTitulos, tabla: "Obra", orden: params.orden, ordenado: params.ordenado, criterios: params.criterios, operadores: params.operadores, campos: params.campos, titulo: "Obras", anchos: anchos, extras: extras, landscape: true])
            } else {
                def lista = buscadorService.buscar(Obra, "Obra", "excluyente", params, true, extras)
                /* Dominio, nombre del dominio , excluyente o incluyente ,params tal cual llegan de la interfaz del buscador, ignore case */
                lista.pop()
                render(view: '../tablaBuscador', model: [listaTitulos: listaTitulos, listaCampos: listaCampos, lista: lista, funciones: funciones, url: url, controller: "obra", numRegistros: numRegistros, funcionJs: funcionJs, width: 1800, paginas: 12])
            }

        } else {
//            println "entro reporte"
            /*De esto solo cambiar el dominio, el parametro tabla, el paramtero titulo y el tamaño de las columnas (anchos)*/
            session.dominio = Obra
            session.funciones = funciones
            def anchos = [7, 10, 7, 7, 7, 7, 7, 4, 7, 7, 7, 7, 7, 7]
            /*el ancho de las columnas en porcentajes... solo enteros*/
            redirect(controller: "reportes", action: "reporteBuscador", params: [listaCampos: listaCampos, listaTitulos: listaTitulos, tabla: "Obra", orden: params.orden, ordenado: params.ordenado, criterios: params.criterios, operadores: params.operadores, campos: params.campos, titulo: "Obras", anchos: anchos, extras: extras, landscape: true])
        }
    }


    def mapaObra() {
        def obra = Obra.get(params.id)
        def persona = Persona.get(session.usuario.id)

        def coordsParts = obra.coordenadas.split(" ")
        def lat, lng

        lat = (coordsParts[0] == 'N' ? 1 : -1) * (coordsParts[1].toInteger() + (coordsParts[2].toDouble() / 60))
        lng = (coordsParts[3] == 'N' ? 1 : -1) * (coordsParts[4].toInteger() + (coordsParts[5].toDouble() / 60))

        def duenoObra = 0

        duenoObra = esDuenoObra(obra) ? 1 : 0

        return [obra: obra, lat: lat, lng: lng, duenoObra: duenoObra, persona: persona]
    }

    def saveCoords() {
        def obra = Obra.get(params.id)
        obra.coordenadas = params.coords
        if (obra.save(flush: true)) {
            render "OK"
        } else {
            println "ERROR al guardar las coordenadas de la obra desde mapa"
            println obra.errors
            render "NO"
        }
    }


    def getPersonas() {

//        println(params)

        def obra = Obra.get(params.obra)
        def usuario = session.usuario.id
        def persona = Persona.get(usuario)
        def rolUsuario = PersonaRol.findByPersona(persona)
        //old
        def departamento = Departamento.get(params.id)
        def personas = Persona.findAllByDepartamento(departamento)

        //nuevo

//        def direccion = Direccion.get(params.id)
//
//        def departamentos = Departamento.findAllByDireccion(direccion)
//
//        def personas = Persona.findAllByDepartamentoInList(departamentos, [sort: 'nombre'])

//        println("pers" + personas)

//        def funcionInsp = Funcion.get(3)
//        def funcionRevi = Funcion.get(5)
//        def funcionResp = Funcion.get(1)

        def funcionInsp = Funcion.findByCodigo('I')
        def funcionRevi = Funcion.findByCodigo('R')
        def funcionResp = Funcion.findByCodigo('S')



        def personasRolInsp = PersonaRol.findAllByFuncionAndPersonaInList(funcionInsp, personas)
        def personasRolRevi = PersonaRol.findAllByFuncionAndPersonaInList(funcionRevi, personas)
        def personasRolResp = PersonaRol.findAllByFuncionAndPersonaInList(funcionResp, personas)

//        println("---->>" + personasRolResp)
//        println("---->>" + personas)

        println(personasRolInsp)
        println(personasRolRevi)
        println(personasRolResp)
//
//        println(personasRolInsp.persona)
//        println(personasRolRevi.persona)
//        println(personasRolResp.persona)

//        println(personas)

        return [personas: personas, personasRolInsp: personasRolInsp.persona, personasRolRevi: personasRolRevi.persona, personasRolResp: personasRolResp.persona, obra: obra, persona: persona]
    }


    def getPersonas2() {

        def obra = Obra.get(params.obra)
        def usuario = session.usuario.id
        def persona = Persona.get(usuario)
        def rolUsuario = PersonaRol.findByPersona(persona)
        def direccion
        def departamentos

        if(params.id){
            direccion = Direccion.get(params.id)
            departamentos = Departamento.findAllByDireccion(direccion)
        } else {
            departamentos = [Departamento.get(params.idDep)]
        }

        def personas = Persona.findAllByDepartamentoInList(departamentos, [sort: 'nombre'])

        if(!personas) {
            departamentos = Departamento.findAllByDireccion(departamentos.first().direccion)
            personas =  Persona.findAllByDepartamentoInList(departamentos, [sort: 'nombre'])
        }
        /* si no hay personas del dpto, se carga de la dirección*/

        def funcionInsp = Funcion.findByCodigo('I')
        def funcionRevi = Funcion.findByCodigo('R')
        def funcionResp = Funcion.findByCodigo('S')
        def funcionElab = Funcion.findByCodigo('E')

        def personasRolInsp = PersonaRol.findAllByFuncionAndPersonaInList(funcionInsp, personas)
        def personasRolRevi = PersonaRol.findAllByFuncionAndPersonaInList(funcionRevi, personas)
        def personasRolResp = PersonaRol.findAllByFuncionAndPersonaInList(funcionResp, personas)
        def personasRolElab = PersonaRol.findAllByFuncionAndPersonaInList(funcionElab, personas)
        def personasUtfpu1 = Persona.findAllByDepartamento(Departamento.findByCodigo('CRFC'))
        def personasUtfpu = PersonaRol.findAllByFuncionAndPersonaInList(funcionElab, personasUtfpu1)

        def responsableObra
        def duenoObra = 0

        if (obra) {
            responsableObra = obra?.responsableObra

            def responsableRol = PersonaRol.findByPersonaAndFuncion(responsableObra, funcionElab)

            if (responsableRol) {
                personasUtfpu.each {
                    if (it.id == responsableRol.id) {
                        duenoObra = 1
                    } else {

                    }
                }
            } else {

            }
        } else {
            duenoObra = 0
        }

//        println "presonas utfpu: ${personasUtfpu.persona}"

        return [personas       : personas, personasRolInsp: personasRolInsp.persona, personasRolRevi: personasRolRevi.persona,
                personasRolResp: personasRolResp.persona, personasRolElab: personasRolElab.persona, obra: obra,
                persona: persona, personasUtfpu: personasUtfpu.persona, duenoObra: duenoObra, direccion: direccion, idep: params.idDep]
    }

    def getSalida() {

        println("getSalida:" + params)

        params.direccion = params.direccion ?: Obra.get(params?.obra)?.departamento?.id

        println "dirección: ${params.direccion}"

        def direccion = Departamento.get(params.direccion?:21)?.direccion
//        def direccion = Direccion.get(params.direccion)
//        def direccion = Departamento.findByDireccion(params.direccion?:21)?.direccion
        def obra = Obra.get(params.obra)
        def departamentos = Departamento.findAllByDireccion(direccion)

//        println "direccion: $direccion, dept: $departamentos"
        return [dire: direccion, depar: departamentos, obra: obra, fcha: new Date()]
    }

    def situacionGeografica() {
//        println "situacionGeografica" + params
        def comunidades
        def orden;
        def colorProv, colorCant, colorParr, colorComn;
        def select = "select provnmbr, cntnnmbr, parrnmbr, cmndnmbr, prov.prov__id, cntn.cntn__id, " +
                "parr.parr__id, cmnd.cmnd__id from prov, cntn, parr, cmnd"
        def txwh = "where cntn.prov__id = prov.prov__id and parr.cntn__id = cntn.cntn__id and cmnd.parr__id = parr.parr__id"
        def campos = ['provnmbr', 'cntnnmbr', 'parrnmbr', 'cmndnmbr']
        def cmpo = params.buscarPor.toInteger()
        def sqlTx = ""

        if (params.ordenar == '1') {
            orden = "asc";
        } else {
            orden = "desc";
        }

        txwh += " and ${campos[cmpo - 1]} ilike '%${params.criterio}%'"

        sqlTx = "${select} ${txwh} order by ${campos[cmpo - 1]} limit 1500".toString()
        println "sql: cmpo: $cmpo $sqlTx"

        def cn = dbConnectionService.getConnection()
        comunidades = cn.rows(sqlTx)
        [comunidades: comunidades, colorComn: colorComn, colorProv: colorProv, colorParr: colorParr, colorCant: colorCant]

    }

    def codigoCPC_ajax() {
//        println "params codigo cpc" + params

        def codigos
        def orden;
        def select = "select * from cpac"
//        def txwh = "where cntn.prov__id = prov.prov__id and parr.cntn__id = cntn.cntn__id and cmnd.parr__id = parr.parr__id"
        def campos = ['cpacnmro', 'cpacdscr']
        def cmpo = params.buscarPor.toInteger()
        def sqlTx = ""

        if (params.ordenar == '1') {
            orden = "asc";
        } else {
            orden = "desc";
        }

        def txwh = " where ${campos[cmpo - 1]} ilike '%${params.criterio}%'"

        sqlTx = "${select} ${txwh} order by ${campos[cmpo - 1]} ${orden} limit 40".toString()

        def cn = dbConnectionService.getConnection()
        codigos = cn.rows(sqlTx)

//        println("sql " + sqlTx)

        return [codigos: codigos]
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
        def ultimo
        def anioActual = new Date().format("yy")

        params.oficioIngreso = params.oficioIngreso.toUpperCase()
        params.memoCantidadObra = params.memoCantidadObra.toUpperCase()

        if(params.memoSalida){
            params.memoSalida = params.memoSalida.toUpperCase()
        }else{
            params.memoSalida = null
        }

        if(params.oficioSalida){
            params.oficioSalida = params.oficioSalida.toUpperCase()
        }else{
            params.oficioSalida = null
        }

        params.codigo = params.codigo.toUpperCase()

        if (params.anchoVia) {
            params.anchoVia = params.anchoVia.toDouble()

        } else {

            params.anchoVia = 0
        }

        if (params.longitudVia) {

            params.longitudVia = params.longitudVia.replaceAll(",", "").toDouble()
        } else {

            params.longitudVia = 0

        }

        if (params.formulaPolinomica) {
            params.formulaPolinomica = params.formulaPolinomica.toUpperCase()
        }

        println "params.fechaOficioSalida: ${params.fechaOficioSalida.class}"
        if (params.fechaCreacionObra) {
            params.fechaCreacionObra = new Date().parse("dd-MM-yyyy", params.fechaCreacionObra)
        }

        if (params.fechaOficioSalida) {
            params.fechaOficioSalida = new Date().parse("dd-MM-yyyy", params.fechaOficioSalida)
        }

        if (params.fechaPreciosRubros) {
            params.fechaPreciosRubros = new Date().parse("dd-MM-yyyy", params.fechaPreciosRubros)
        }



        if (params.id) {
            if (session.perfil.codigo == 'ADDI' || session.perfil.codigo == 'COGS') {
                params.departamento = Departamento.get(params.per.id)
            } else {
                params.departamento = Departamento.get(params.departamento.id)
            }

        }
        params."departamento.id" = params.departamento.id

        println "obra: ${params.id} depto: ${params.departamento.id}"

        def obraInstance
        def bandera

        if (params.id) {

            bandera = false

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
//                println "Elimina el cronograma"
                VolumenesObra.findAllByObra(obraInstance, [sort: "orden"]).each { vol ->
                    Cronograma.findAllByVolumenObra(vol).each { crono ->
                        crono.delete()
                    }
                }
            }

//            println("-->" +params.departamento.id)

            obraInstance.properties = params

            obraInstance.departamento = params.departamento

//            println("-->" +params.departamento.id)

        }//es edit
        else {
            def numero = ""
//            switch (session.perfil.codigo) {
//                case "CSTO":
//                    ultimo = Numero.findByDescripcion('CO')
//                    numero = completa(ultimo?.valor + 1)
//                    params.codigo = "CO-${numero}-CRFC-${anioActual}"
//
//                    ultimo.valor = (ultimo.valor+1)
//
//                    break;
//                case "ADDI":
//                    ultimo = Numero.findByDescripcion('PAD')
//                    numero = completa(ultimo?.valor + 1)
//                    params.codigo = "PAD-${numero}-GADPP-${anioActual}"
//
//                    ultimo.valor = (ultimo.valor+1)
//                    break;
//                case "OBRA":
//                    ultimo = Numero.findByDescripcion('PB')
//                    numero = completa(ultimo?.valor + 1)
//                    params.codigo = "PB-${numero}-GADPP-${anioActual}"
//
//                    ultimo.valor = (ultimo.valor+1)
//                    break;
//            }


            if(!Obra.findByCodigo(params.codigo)){

                obraInstance = new Obra(params)

                bandera = true
                def departamento

                if (session.perfil.codigo == 'ADDI' || session.perfil.codigo == 'COGS') {
                    departamento = Departamento.get(persona?.departamento?.id)
                } else {
                    departamento = Departamento.get(params.departamento.id)
                }

                obraInstance.departamento = departamento

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

                obraInstance.indiceAlquiler = par.indiceAlquiler
                obraInstance.indiceProfesionales = par.indiceProfesionales
                obraInstance.indiceSeguros = par.indiceSeguros
                obraInstance.indiceSeguridad = par.indiceSeguridad
                obraInstance.indiceCampo = par.indiceCampo
                obraInstance.indiceCampamento = par.indiceCampamento

                /** variables por defecto para las nuevas obras **/
                obraInstance.lugar = Lugar.findAll('from Lugar  where tipoLista=1')[0]
                obraInstance.listaVolumen0 = Lugar.findAll('from Lugar  where tipoLista=3')[0]
                obraInstance.distanciaPeso = 10
                obraInstance.distanciaVolumen = 30


//                obraInstance.indiceGastosGenerales = (obraInstance.indiceCostosIndirectosObra + obraInstance.indiceCostosIndirectosPromocion + obraInstance.indiceCostosIndirectosMantenimiento +
//                        obraInstance.administracion + obraInstance.indiceCostosIndirectosGarantias + obraInstance.indiceCostosIndirectosCostosFinancieros + obraInstance.indiceCostosIndirectosVehiculos)


                obraInstance.indiceGastosGenerales = (obraInstance?.indiceAlquiler + obraInstance?.administracion + obraInstance?.indiceProfesionales + obraInstance?.indiceCostosIndirectosMantenimiento + obraInstance?.indiceSeguros + obraInstance?.indiceSeguridad)

                obraInstance.indiceGastoObra = (obraInstance?.indiceCampo + obraInstance?.indiceCostosIndirectosCostosFinancieros + obraInstance?.indiceCostosIndirectosGarantias + obraInstance?.indiceCampamento)

//                obraInstance.totales = (obraInstance.impreso + obraInstance.indiceUtilidad + obraInstance.indiceCostosIndirectosTimbresProvinciales + obraInstance.indiceGastosGenerales)
                obraInstance.totales = (obraInstance.impreso + obraInstance.indiceUtilidad + obraInstance.indiceGastoObra + obraInstance.indiceGastosGenerales)

                /* si pefiles administración directa o cogestion pone obratipo = 'D' */
                if (session.perfil.codigo == 'ADDI' || session.perfil.codigo == 'COGS') {
                    obraInstance.tipo = 'D'
                }
            }else {
                flash.clase = "alert-error"
                flash.message = " No se pudo guardar la obra,  código duplicado: " + params.codigo
                redirect(action: 'registroObra')
                return
            }
        } //es create

        obraInstance.estado = "N"
//        obraInstance.departamento.id = params.departamento.id

        if (!obraInstance.save(flush: true)) {

            flash.clase = "alert-error"
            def str = "<h4>No se pudo guardar Obra " + (obraInstance.id ? obraInstance.id : "") + "</h4>"

            str += "<ul>"

            println "errores: ${params.fechaCreacionObra} ${obraInstance.errors} "

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
//            if(bandera){
//                ultimo.save(flush: true)
//            }
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
        def obra = Obra.get(params.id);
        def nuevoCodigo = params.nuevoCodigo.toUpperCase()
        def volumenes = VolumenesObra.findAllByObra(obra)
        def departamento = Persona.get(session.usuario.id).departamento

        obraInstance = Obra.get(params.id)

        def revisarCodigo = Obra.findByCodigo(nuevoCodigo)

        if (revisarCodigo != null) {
            render "NO_No se puede copiar la Obra " + " " + obra.nombre + " " + "porque posee un codigo ya existente."
        } else {
//            println("entro2")
            obraInstance = new Obra()
            obraInstance.properties = obra.properties
            obraInstance.codigo = nuevoCodigo
            obraInstance.estado = 'N'
            obraInstance.departamento = departamento
            obraInstance.memoSif = null
            obraInstance.fechaInicio = null
            obraInstance.fechaFin = null
            obraInstance.formulaPolinomica = null

            def persona = Persona.get(session.usuario.id)

//            if(departamento?.codigo != 'CRFC'){
                def direccion = Direccion.get(persona.departamento.direccion.id)
                def departamentos = Departamento.findAllByDireccion(direccion)
                def personas = Persona.findAllByDepartamentoInList(departamentos, [sort: 'nombre'])
                def funcionInsp = Funcion.findByCodigo('I')
                def funcionRevi = Funcion.findByCodigo('R')
                def funcionElab = Funcion.findByCodigo('E')
                def personasRolInsp = PersonaRol.findAllByFuncionAndPersonaInList(funcionInsp, personas)
                def personasRolRevi = PersonaRol.findAllByFuncionAndPersonaInList(funcionRevi, personas)
                def personasRolElab = PersonaRol.findAllByFuncionAndPersonaInList(funcionElab, personas)

                obraInstance.inspector = personasRolInsp.first().persona
                obraInstance.revisor = personasRolRevi.first().persona
                obraInstance.responsableObra = personasRolElab.first().persona
//            } else {
//                obraInstance.responsableObra = persona   // cambia de dueño al usuario que copia de la CRFC
//            }

            obraInstance.responsableObra = persona

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
                return
            }
            volumenes.each { volOr ->
                volumenInstance = new VolumenesObra()
                volumenInstance.properties = volOr.properties
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

        def grupo = params.grupo

        def tipoObraInstance = new TipoObra(params)
        if (params.id) {
            tipoObraInstance = TipoObra.get(params.id)
            if (!tipoObraInstance) {
                render "no_Tipo de obra no encontrada"
            }
        }
        return [tipoObraInstance: tipoObraInstance, grupo: grupo]
    }


    def delete() {

//        println("delete:" + params.id)

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


    def formIva_ajax () {

    }


    def guardarIva_ajax () {

        def paux = Parametros.first()
        def nuevoIva = params.iva_name

        paux.iva = nuevoIva.toInteger()

        try{
            paux.save(flush: true)
            render "ok"
        }catch (e){
            render "no"
        }
    }

    def revisarSizeRubros_ajax () {
//        println "revisarSizeRubros_ajax $params"
        def obra = Obra.get(params.id)
        def tamano = VolumenesObra.findAllByObra(obra, [sort: 'orden']).item.unique().size()
        def tamano1 = VolumenesObra.findAllByObra(obra, [sort: 'orden']).item.unique()

        if(tamano > 0){
            render "ok"
        }else{
            render "no"
        }
    }

    def verificaMatriz(id) {
        println "verificaMatriz"
        def obra = Obra.get(id)
        def errr = ""
        if (!VolumenesObra.findAllByObra(obra)) errr += "<br><span class='label-azul'>No se ha ingresado los volúmenes de Obra</span>"
        if (!obra.lugar) errr += "<br><span class='label-azul'>No se ha definido la Lista precios:</span> \"Peso Capital de cantón\" para esta Obra"
        if (!obra.listaPeso1) errr += "<br><span class='label-azul'>No se ha definido la Lista precios:</span> \"Peso Especial\" para esta Obra"
        if (!obra.listaVolumen0) errr += "<br><span class='label-azul'>No se ha definido la Lista precios: </span>\"Materiales Pétreos Hormigones\" para esta Obra"
        if (!obra.listaVolumen1) errr += "<br><span class='label-azul'>No se ha definido la Lista precios: </span>\"Materiales Mejoramiento\" para esta Obra"
        if (!obra.listaVolumen2) errr += "<br><span class='label-azul'>No se ha definido la Lista precios:</span> \"Materiales Carpeta Asfáltica\" para esta Obra"
        if (!obra.listaManoObra) errr += "<br><span class='label-azul'>No se ha definido la Lista precios:</span> \"Mano de obra y equipos\" para esta Obra"

//        if (!obra.distanciaPeso) errr += "<br> <span class='label-azul'> No se han ingresado las distancias al Peso</span>"
        if (obra.distanciaPeso == null) errr += "<br> <span class='label-azul'> No se han ingresado las distancias al Peso</span>"
//        if (!obra.distanciaVolumen) errr += "<br>  <span class='label-azul'>No se han ingresado las distancias al Volumen</span>"
        if (obra.distanciaVolumen == null) errr += "<br>  <span class='label-azul'>No se han ingresado las distancias al Volumen</span>"
        if (rubrosSinCantidad(id) > 0) errr += "<br> <span class='label-azul'>Existen Rubros con cantidades Negativas o CERO</span>"

        //if (nombresCortos()) errr += "<br><span class='label-azul'>Existen Items con nombres cortos repetidos: </span>" + nombresCortos()

        if (errr) errr = "<b><span style='color:red'>Errores detectados</span></b> " + errr
        else errr = ""
        return errr
    }

    def rubrosSinCantidad(id) {
        println "rubrosSinCantidad ---1"
        def cn = dbConnectionService.getConnection()
        def er = 0;
        def tx_sql = "select count(*) nada from vlob where obra__id = ${id} and vlobcntd <= 0"
        println "rubrosSinCantidad: $tx_sql"
        cn.eachRow(tx_sql.toString()) { row ->
            er = row.nada
        }
        cn.close()
        return er
    }

    def verifica_precios(id) {
        // usa funcion
        def cn = dbConnectionService.getConnection()
        def errr = [:];
        def tx_sql = "select itemcdgo, itemnmbr, tplsdscr from verifica_precios_v2(${id}) order by itemcdgo "
        cn.eachRow(tx_sql.toString()) { row ->
            errr.put(row["itemcdgo"]?.trim(), [row["itemnmbr"]?.trim(), row["tplsdscr"]?.trim()])
//            errr += "Item: ${row.itemcdgo.trim()} ${row.itemnmbr.trim()} Lista: ${row.tplsdscr.trim()}\n"
//            println "r "+row
        }
        cn.close()
        return errr
    }

    def tablaObrasFinalizadas(){
        println "tablaObrasFinalizadas params $params"
        def fcin = params.fechaInicio ? new Date().parse("dd-MM-yyyy", params.fechaInicio).format('yyyy-MM-dd') : ''
        def fcfn = params.fechaFin ? new Date().parse("dd-MM-yyyy", params.fechaFin).format('yyyy-MM-dd') : ''
        def campos = ['obracdgo', 'obranmbr', 'obradscr',
                      'obrasito', 'parrnmbr', 'cmndnmbr', 'diredscr']
        def cn = dbConnectionService.getConnection()
        def sql = "select obracdgo, obranmbr, diredscr||' - '||dptodscr direccion, obrafcha, obrasito, parrnmbr, " +
                "cmndnmbr, obrafcin, obrafcfn from obra, dpto, dire, parr, cmnd "
        def sqlWhere = "where dpto.dpto__id = obra.dpto__id and dire.dire__id = dpto.dire__id and " +
                "parr.parr__id = obra.parr__Id and cmnd.cmnd__id = obra.cmnd__id and " +
                "obrafcin is not null and " +
                "${campos[params.buscador.toInteger()]} ilike '%${params.criterio}%' "
        def sqlOrder = "order by obrafcin desc"
        if(params.departamento) sqlWhere += " and obra.dpto__id = ${params.departamento} "
        if(params.fechaInicio) sqlWhere += " and obrafcha >= '${fcin}' "
        if(params.fechaFIn) sqlWhere += " and obrafcha <= '${fcfn}' "
        sql += sqlWhere + sqlOrder
        println "sql: $sql"
        def obras = cn.rows(sql)
        params.criterio = params.old
        return [data: obras, params: params]
    }

    def impresionesRubros_ajax(){
        def obra = Obra.get(params.id)
        return[obra: obra]
    }

    def generarCodigoFP_ajax(){
        def obra = Obra.get(params.id)
        def codigo
        def anioActual = new Date().format("yy")


//        def numero = ""
//        def ultimo = Numero.findByDescripcion('FP')
//        numero = completa(ultimo?.valor + 1)
//        codigo = "FP-${numero}-CRFC-${anioActual}"
//        obra.formulaPolinomica = codigo
//        ultimo.valor = (ultimo.valor+1)

        obra.formulaPolinomica = "FP-${obra?.codigo}"

        if(!obra.save(flush:true)){
            println("error al generar el código de la FP " + obra?.errors)
            render "no_Error al generar el código de la FP"
        }else{
//            ultimo.save(flush:true)
            render "ok_Código creado correctamente"
        }
    }

    def seleccionarRevisor_ajax(){

        def obra = Obra.get(params.obra)
        def usuario = session.usuario.id
        def persona = Persona.get(usuario)
        def direccion
        def departamentos

        if(params.id){
            direccion = Direccion.get(params.id)
            departamentos = Departamento.findAllByDireccion(direccion)
        } else {
            departamentos = [Departamento.get(params.idDep)]
        }

        def personas = Persona.findAllByDepartamentoInList(departamentos, [sort: 'nombre'])

        if(!personas) {
            departamentos = Departamento.findAllByDireccion(departamentos.first().direccion)
            personas =  Persona.findAllByDepartamentoInList(departamentos, [sort: 'nombre'])
        }

        def funcionRevi = Funcion.findByCodigo('R')
        def personasRolRevi = PersonaRol.findAllByFuncionAndPersonaInList(funcionRevi, personas)

        return [personas : personas, personasRolRevi: personasRolRevi.persona, obra: obra, persona: persona]

    }

    def seleccionarInspector_ajax(){

        def obra = Obra.get(params.obra)
        def usuario = session.usuario.id
        def persona = Persona.get(usuario)
        def direccion
        def departamentos

        if(params.id){
            direccion = Direccion.get(params.id)
            departamentos = Departamento.findAllByDireccion(direccion)
        } else {
            departamentos = [Departamento.get(params.idDep)]
        }

        def personas = Persona.findAllByDepartamentoInList(departamentos, [sort: 'nombre'])

        if(!personas) {
            departamentos = Departamento.findAllByDireccion(departamentos.first().direccion)
            personas =  Persona.findAllByDepartamentoInList(departamentos, [sort: 'nombre'])
        }

        def funcionInsp = Funcion.findByCodigo('I')
        def funcionResp = Funcion.findByCodigo('S')
        def funcionElab = Funcion.findByCodigo('E')

        def personasRolInsp = PersonaRol.findAllByFuncionAndPersonaInList(funcionInsp, personas)
        def personasRolResp = PersonaRol.findAllByFuncionAndPersonaInList(funcionResp, personas)
        def personasRolElab = PersonaRol.findAllByFuncionAndPersonaInList(funcionElab, personas)
        def personasUtfpu1 = Persona.findAllByDepartamento(Departamento.findByCodigo('CRFC'))
        def personasUtfpu = PersonaRol.findAllByFuncionAndPersonaInList(funcionElab, personasUtfpu1)

        def responsableObra
        def duenoObra = 0

        if (obra) {
            responsableObra = obra?.responsableObra

            def responsableRol = PersonaRol.findByPersonaAndFuncion(responsableObra, funcionElab)

            if (responsableRol) {
                personasUtfpu.each {
                    if (it.id == responsableRol.id) {
                        duenoObra = 1
                    } else {

                    }
                }
            } else {

            }
        } else {
            duenoObra = 0
        }

        return [personas       : personas, personasRolInsp: personasRolInsp.persona,
                personasRolResp: personasRolResp.persona, personasRolElab: personasRolElab.persona, obra: obra,
                persona: persona, personasUtfpu: personasUtfpu.persona, duenoObra: duenoObra, direccion: direccion, idep: params.idDep]

    }

    def seleccionarResponsable_ajax(){

        def obra = Obra.get(params.obra)
        def usuario = session.usuario.id
        def persona = Persona.get(usuario)
        def direccion
        def departamentos

        if(params.id){
            direccion = Direccion.get(params.id)
            departamentos = Departamento.findAllByDireccion(direccion)
        } else {
            departamentos = [Departamento.get(params.idDep)]
        }

        def personas = Persona.findAllByDepartamentoInList(departamentos, [sort: 'nombre'])

        if(!personas) {
            departamentos = Departamento.findAllByDireccion(departamentos.first().direccion)
            personas =  Persona.findAllByDepartamentoInList(departamentos, [sort: 'nombre'])
        }

        def funcionInsp = Funcion.findByCodigo('I')
        def funcionResp = Funcion.findByCodigo('S')
        def funcionElab = Funcion.findByCodigo('E')

        def personasRolInsp = PersonaRol.findAllByFuncionAndPersonaInList(funcionInsp, personas)
        def personasRolResp = PersonaRol.findAllByFuncionAndPersonaInList(funcionResp, personas)
        def personasRolElab = PersonaRol.findAllByFuncionAndPersonaInList(funcionElab, personas)
//        def personasUtfpu1 = Persona.findAllByDepartamento(Departamento.findByCodigo('CRFC'))
        def personasUtfpu1 = Persona.findAllByDepartamento(obra?.departamento)
        def perfilCosto = Prfl.findByCodigo('CSTO')
        def sesion = Sesn.findAllByPerfilAndFechaFinIsNullAndUsuarioInList(perfilCosto, personasUtfpu1)
//        def personasUtfpu = PersonaRol.findAllByFuncionAndPersonaInList(funcionElab, personasUtfpu1)
        def personasUtfpu = PersonaRol.findAllByFuncionAndPersonaInList(funcionElab, sesion.usuario)


        def responsableObra
        def duenoObra = 0

        if (obra) {
            responsableObra = obra?.responsableObra

            def responsableRol = PersonaRol.findByPersonaAndFuncion(responsableObra, funcionElab)

            if (responsableRol) {
                personasUtfpu.each {
                    if (it.id == responsableRol.id) {
                        duenoObra = 1
                    } else {

                    }
                }
            } else {

            }
        } else {
            duenoObra = 0
        }

        return [personas       : personas, personasRolInsp: personasRolInsp.persona,
                personasRolResp: personasRolResp.persona, personasRolElab: personasRolElab.persona, obra: obra,
                persona: persona, personasUtfpu: personasUtfpu.persona, duenoObra: duenoObra, direccion: direccion, idep: params.idDep]

    }

    def guardarInspector_ajax(){

        def obra = Obra.get(params.obra)
        def inspector = Persona.get(params.inspector)
        obra.inspector = inspector

        if(!obra.save(flush:true)){
            println("error al guardar el inspector " + obra.errors)
            render "no_Error al guardar el inspector"
        }else{
            render "ok_Guardado correctamente"
        }
    }

    def guardarResponsable_ajax(){

        def obra = Obra.get(params.obra)
        def responsable = Persona.get(params.responsable)
        obra.responsableObra = responsable

        if(!obra.save(flush:true)){
            println("error al guardar el responsable " + obra.errors)
            render "no_Error al guardar el responsable"
        }else{
            render "ok_Guardado correctamente"
        }
    }

    def guardarRevisor_ajax(){

        def obra = Obra.get(params.obra)
        def revisor = Persona.get(params.revisor)
        obra.revisor = revisor

        if(!obra.save(flush:true)){
            println("error al guardar el revisor " + obra.errors)
            render "no_Error al guardar el revisor"
        }else{
            render "ok_Guardado correctamente"
        }
    }

    def completa(valor) {
        def txto = '0'*(3-valor.toString().size())
        println "txto: $txto"
        return "${txto}${valor}"
    }

    def comprobarAres_ajax(){
        println "comprobarAres_ajax: $params"
        def cn = dbConnectionService.getConnection()
        def departamento = [:]
        def sql = "select itemcdgo, itemnmbr from item where itemcdes is null and item__id in (" +
                "select item__id from vlob where obra__id = ${params.id}) " +
                "order by 1"
        println "sql: $sql"
        def sinCodigo = cn.rows(sql.toString())

        if(sinCodigo.size() > 0){
            render "no"
        }else{
            render "ok"
        }
    }

    def listaRubrosSinCodigo_ajax(){
        def rubrosSin
        def cn = dbConnectionService.getConnection()
        def departamento = [:]
        def sql = "select itemcdgo, itemnmbr from item where itemcdes is null and item__id in (" +
                "select item__id from vlob where obra__id = ${params.id}) " +
                "order by 1"
        println "sql: $sql"
        rubrosSin = cn.rows(sql.toString())

        return [rubros: rubrosSin]
    }

    def fecha_ajax(){
        def obra = Obra.get(params.id)
        return [obra: obra]
    }

    def guardarFecha_ajax(){
        println("params " + params)

        def obra = Obra.get(params.id)
        def fecha

        if(params.fecha){
            fecha = new Date().parse("dd-MM-yyyy", params.fecha)
        }

        obra.fechaCreacionObra = fecha

        if(!obra.save(flush:true)){
            println("error al guardar la fecha " + obra.errors)
            render "no_Error al guardar la fecha"
        }else{
            render "ok_Guardado correctamente"
        }


    }

} //fin controller
