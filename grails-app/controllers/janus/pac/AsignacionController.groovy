package janus.pac

import janus.Presupuesto
import janus.PresupuestoController
import org.springframework.dao.DataIntegrityViolationException

class AsignacionController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]
    def buscadorService
    def dbConnectionService

    def form_ajax() {
        def campos = ["numero": ["Código", "string"], "descripcion": ["Descripción", "string"]]
        def anio = new Date().format("yyyy")
        def actual = Anio.findByAnio(anio.toString())
        if(!actual){
            actual=Anio.list([sort: "id"])?.pop()
        }

        def asignacionInstance = new Asignacion(params)
        if (params.id) {
            asignacionInstance = Asignacion.get(params.id)
            if (!asignacionInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Asignacion con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [asignacionInstance: asignacionInstance,campos:campos,actual:actual]
    } //form_ajax

    def tabla(){
        println("tabla ba " + params)

        def anio = Anio.get(params.anio)
        def asignaciones

        def datos;
        def sqlTx = ""
        def listaItems = ['prsp.prspnmro', 'prsp.prspdscr']
        def bsca = listaItems[params.buscarPor.toInteger()-1]

        def select = "select prspdscr, prspnmro, prspproy, prspprgm, prspsbpr, asgnvlor, asgn__id from asgn, prsp"
        def txwh = " where asgn.prsp__id = prsp.prsp__id and $bsca ilike '%${params.criterio}%' and asgn.anio__id = ${anio?.id}"
        sqlTx = "${select} ${txwh} order by prsp.prspproy limit 30 ".toString()

        println "sql: $sqlTx"

        def cn = dbConnectionService.getConnection()
        datos = cn.rows(sqlTx)

        [asignaciones:datos, anio: anio]
    }

    def buscaPrsp(){
//        println("entro prsp!")
        println("params" + params)
        def listaTitulos = ["Código", "Descripción","Fuente","programa","Subprograma","Proyecto"]
        def listaCampos = ["numero", "descripcion","fuente","programa","subPrograma","proyecto"]
        def funciones = [null, null]
//        def url = g.createLink(action: "buscaCpac", controller: "pac")
        def url = g.createLink(action: "buscaPrsp")
        def funcionJs = "function(){"
        funcionJs += '$("#modal-ccp").modal("hide");'
        funcionJs += '$("#item_prsp").val($(this).attr("regId"));$("#item_presupuesto").val($(this).parent().parent().find(".props").attr("prop_numero"));' +
                '$("#item_presupuesto").attr("title",$(this).parent().parent().find(".props").attr("prop_numero"));' +
                '$("#item_desc").val($(this).parent().parent().find(".props").attr("prop_descripcion"));' +
                '$("#item_fuente").val($(this).parent().parent().find(".props").attr("prop_fuente"));' +
                '$("#item_prog").val($(this).parent().parent().find(".props").attr("prop_programa"));' +
                '$("#item_spro").val($(this).parent().parent().find(".props").attr("prop_subprograma"));' +
                '$("#item_proy").val($(this).parent().parent().find(".props").attr("prop_proyecto"));cargarTecho();'
        funcionJs += '}'

        def numRegistros = 20
        def extras = ""
//        if (!params.reporte) {
//            def lista = buscadorService.buscar(janus.Presupuesto, "Presupuesto", "excluyente", params, true, extras) /* Dominio, nombre del dominio , excluyente o incluyente ,params tal cual llegan de la interfaz del buscador, ignore case */
//            lista.pop()
//            render(view: '../tablaBuscadorColDer', model: [listaTitulos: listaTitulos, listaCampos: listaCampos, lista: lista, funciones: funciones, url: url, controller: "llamada", numRegistros: numRegistros, funcionJs: funcionJs])
//        } else {
//            /*De esto solo cambiar el dominio, el parametro tabla, el paramtero titulo y el tamaño de las columnas (anchos)*/
//            session.dominio = janus.Presupuesto
//            session.funciones = funciones
//            def anchos = [20, 80] /*el ancho de las columnas en porcentajes... solo enteros*/
//            redirect(controller: "reportes", action: "reporteBuscador", params: [listaCampos: listaCampos, listaTitulos: listaTitulos, tabla: "Presupuesto", orden: params.orden, ordenado: params.ordenado, criterios: params.criterios, operadores: params.operadores, campos: params.campos, titulo: "Partidas presupuestarias", anchos: anchos, extras: extras, landscape: false])
//        }


        if (!params.reporte) {
            if(params.excel){
                session.dominio = Presupuesto
                session.funciones = funciones
                def anchos = [15, 50, 70, 20, 20, 20]
                /*anchos para el set column view en excel (no son porcentajes)*/
                redirect(controller: "reportes", action: "reporteBuscadorExcel", params: [listaCampos: listaCampos,
                                                                                          listaTitulos: listaTitulos, tabla: "Presupuesto", orden: params.orden, ordenado: params.ordenado,
                                                                                          criterios: params.criterios, operadores: params.operadores, campos: params.campos,
                                                                                          titulo: "Presupuesto", anchos: anchos, extras: extras, landscape: true])
            }else{
                /* Dominio, nombre del dominio , excluyente o incluyente ,params tal cual llegan de la interfaz del buscador, ignore case */
                def lista = buscadorService.buscar(janus.Presupuesto, "Presupuesto", "excluyente", params, true, extras)
                println "lista: $lista"
                lista.pop()
/*
                render(view: '../tablaBuscador', model: [listaTitulos: listaTitulos, listaCampos: listaCampos,
                    lista: lista, funciones: funciones, url: url, controller: "llamada", numRegistros: numRegistros,
                    funcionJs: funcionJs])
*/
                render(view: '../tablaBuscador', model: [listaTitulos: listaTitulos, listaCampos: listaCampos,
                                                         lista: lista, funciones: funciones, url: url, controller: "llamada", numRegistros: numRegistros,
                                                         funcionJs: funcionJs, width: 1800, paginas: 12])

            }
        } else {
            /*De esto solo cambiar el dominio, el parametro tabla, el paramtero titulo y el tamaño de las columnas (anchos)*/
            session.dominio = Presupuesto
            session.funciones = funciones
            def anchos = [20, 20,20,10,10,10] /*el ancho de las columnas en porcentajes... solo enteros*/
            redirect(controller: "reportes", action: "reporteBuscador", params: [listaCampos: listaCampos,
                                                                                 listaTitulos: listaTitulos, tabla: "Presupuesto", orden: params.orden, ordenado: params.ordenado,
                                                                                 criterios: params.criterios, operadores: params.operadores, campos: params.campos,
                                                                                 titulo: "Partidas presupuestarias", anchos: anchos, extras: extras, landscape: false])
        }



    }
    def cargarTecho(){
        def prsp = janus.Presupuesto.get(params.id)
        def anio = Anio.get(params.anio)
        def techo = Asignacion.findByAnioAndPrespuesto(anio,prsp)
        if (!techo)
            techo="0.00"
        else
            techo=techo.valor
        render techo
    }


    def save() {
        def asgn
        def prsp = janus.Presupuesto.get(params.prespuesto.id)
        def anio = Anio.get(params.anio.id)
        asgn = Asignacion.findByAnioAndPrespuesto(anio,prsp)
        if (!asgn){
            asgn= new Asignacion()
            asgn.prespuesto=prsp
            asgn.anio=anio
        }
        asgn.valor=params.valor.toDouble()
        if (!asgn.save()) {
//            println "asgn  errors "+asgn.errors
        } else {
            flash.message="Datos guardados"
            redirect(action: "form_ajax")
        }
        return

    } //save

    def show_ajax() {
        def asignacionInstance = Asignacion.get(params.id)
        if (!asignacionInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Asignacion con id " + params.id
            redirect(action: "list")
            return
        }
        [asignacionInstance: asignacionInstance]
    } //show

    def delete() {
        def asignacionInstance = Asignacion.get(params.id)
        if (!asignacionInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Asignacion con id " + params.id
            redirect(action: "list")
            return
        }

        try {
            asignacionInstance.delete(flush: true)
            flash.clase = "alert-success"
            flash.message = "Se ha eliminado correctamente Asignacion " + asignacionInstance.id
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
            flash.clase = "alert-error"
            flash.message = "No se pudo eliminar Asignacion " + (asignacionInstance.id ? asignacionInstance.id : "")
            redirect(action: "list")
        }
    } //delete

    def buscarPresupuesto(){
        def anio = params.anio
        return[anio: anio]
    }

    def tablaPresupuesto_ajax(){
        println("tabla pre " + params)

        def anio = Anio.get(params.anio)
        def datos;
        def sqlTx = ""
        def listaItems = ['prspnmro', 'prspdscr']
        def bsca = listaItems[params.buscarPor.toInteger()-1]

        def select = "select * from prsp"
        def txwh = " where $bsca ilike '%${params.criterio}%' and anio__id = ${anio?.id}"
        sqlTx = "${select} ${txwh} order by prspdscr limit 30 ".toString()
        println "sql: $sqlTx"

        def cn = dbConnectionService.getConnection()
        datos = cn.rows(sqlTx)

//        println("data " + datos)
        return[presupuestos: datos, anioSeleccionado: anio.anio]
    }

    def formAsignacion_ajax(){

        def asignacion
        def anio = new Date().format("yyyy")
        def actual = Anio.findByAnio(anio.toString())
        if(!actual){
            actual=Anio.list([sort: "id"])?.pop()
        }

        if(params.id){
            asignacion = Asignacion.get(params.id)
        }else{
            asignacion = new Asignacion()
        }

        return [asignacion:asignacion, actual: actual]
    }

    def saveAsignacion_ajax(){
//        println("params sa " + params)

        def asignacion
        def anio = Anio.get(params.anio)
        def presupuesto = Presupuesto.get(params.prespuesto)
        def existe = Asignacion.findByAnioAndPrespuesto(anio, presupuesto)

        if(params.id){
            asignacion = Asignacion.get(params.id)

            if(existe){
                if(existe?.id != asignacion?.id){
                    render "err_Ya existe una asignación con esa partida"
                    return
                }
            }
        }else{

            if(existe){
                render "err_Ya existe una asignación con esa partida"
                return
            }

            asignacion = new Asignacion()
        }

        params.valor = params.valor.toDouble();
        asignacion.properties = params

        if(!asignacion.save(flush:true)){
            println("error al guardar la asignacion " + asignacion.errors)
            render "no_Error al guardar la asignación"
        }else{
            render "ok_Guardado correctamente"
        }
    }

    def borrarAsignacion_ajax(){
        def asignacion = Asignacion.get(params.id)

        if(asignacion){

            try{
                asignacion.delete(flush:true)
                render "ok_Borrado correctamente"
            }catch(e){
                println("_Error al borrar la asignacion " + asignacion.errors)
                render "no_Error al borrar la asignacion"
            }

        }else{
            render "no_Error al borrar la asignación"
        }
    }


    def asignaciones(){
        def partida =  null
        def pac = null

        if(params.pac){
            pac = Pac.get(params.pac)
            partida = pac.presupuesto
        }

        def campos = ["numero": ["Código", "string"], "descripcion": ["Descripción", "string"]]
        def anio = new Date().format("yyyy")
        def actual = Anio.findByAnio(anio.toString())
        if(!actual){
            actual=Anio.list([sort: "id"])?.pop()
        }

        return [campos:campos,actual:actual, partida: partida, pac: pac]
    }

    def tablaAsignaciones_ajax(){
//        println("tabla ba " + params)

        def anio = Anio.get(params.anio)
        def asignaciones

        def datos;
        def sqlTx = ""
        def listaItems = ['prsp.prspnmro', 'prsp.prspdscr']
        def bsca = listaItems[params.buscarPor.toInteger()-1]

        def select = "select prspdscr, prspnmro, prspproy, prspprgm, prspsbpr, asgn.prsp__id id, asgnvlor, asgn__id from asgn, prsp"
        def txwh = " where asgn.prsp__id = prsp.prsp__id and $bsca ilike '%${params.criterio}%' and asgn.anio__id = ${anio?.id}"
        sqlTx = "${select} ${txwh} order by prsp.prspproy limit 30 ".toString()

        println "sql: $sqlTx"

        def cn = dbConnectionService.getConnection()
        datos = cn.rows(sqlTx)

        [asignaciones:datos, anio: anio]
    }

    def asignacion_ajax(){

        def partida = Presupuesto.get(params.partida)
        def asignaciones = Asignacion.findAllByPrespuesto(partida)

        return  [asignaciones: asignaciones, partida: partida]
    }

    def valor_ajax(){
        def asignacion = Asignacion.get(params.id)
        return [asignacion: asignacion]
    }

    def formNuevaAsignacion_ajax(){

        def asignacion
        def partida = null
        def anio = new Date().format("yyyy")
        def actual = Anio.findByAnio(anio.toString())

        if(!actual){
            actual=Anio.list([sort: "id"])?.pop()
        }

        if(params.id){
            asignacion = Asignacion.get(params.id)
        }else{
            asignacion = new Asignacion()
        }

        if(params.partida){
            partida = Presupuesto.get(params.partida)
        }

        return [asignacion:asignacion, actual: actual, partida: partida]
    }

} //fin controller
