package janus.pac

import janus.Contrato
import jxl.Cell
import jxl.Sheet
import jxl.Workbook
import org.apache.poi.xssf.usermodel.XSSFCell
import org.apache.poi.xssf.usermodel.XSSFRow
import org.apache.poi.xssf.usermodel.XSSFSheet
import org.apache.poi.xssf.usermodel.XSSFWorkbook
import org.springframework.dao.DataIntegrityViolationException

class CodigoComprasPublicasController {

    def dbConnectionService

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
//        [codigoComprasPublicasInstanceList: CodigoComprasPublicas.list(params), params: params]
    } //list

    def tablaCPC_ajax(){
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
        sqlTx = "${select} ${txwh} order by cpacdscr limit 100 ".toString()

        def cn = dbConnectionService.getConnection()
        datos = cn.rows(sqlTx)
        [data: datos, tipo: params.tipo]
    }

    def form_ajax() {
        def codigoComprasPublicasInstance = new CodigoComprasPublicas(params)
        if (params.id) {
            codigoComprasPublicasInstance = CodigoComprasPublicas.get(params.id)
            if (!codigoComprasPublicasInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Codigo Compras Publicas con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [codigoComprasPublicasInstance: codigoComprasPublicasInstance]
    } //form_ajax

    def save() {
        def codigoComprasPublicasInstance

        if(params.fecha){
            params.fecha = new Date().parse("dd-MM-yyyy", params.fecha)
        }

        if(params.id){
            codigoComprasPublicasInstance = CodigoComprasPublicas.get(params.id)
        }else{
            codigoComprasPublicasInstance = new CodigoComprasPublicas()
            codigoComprasPublicasInstance.nivel = 9
            codigoComprasPublicasInstance.movimiento = 1
        }

        codigoComprasPublicasInstance.properties = params

        if(!codigoComprasPublicasInstance.save(flush:true)){
            println("Error al guardar el CPC " + codigoComprasPublicasInstance.errors)
            render "no_Error al guardar el CPC"
        }else{
            render "ok_Guardado correctamente"
        }

    } //save

    def show_ajax() {
        def codigoComprasPublicasInstance = CodigoComprasPublicas.get(params.id)
        if (!codigoComprasPublicasInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Codigo Compras Publicas con id " + params.id
            redirect(action: "list")
            return
        }
        [codigoComprasPublicasInstance: codigoComprasPublicasInstance]
    } //show

    def delete() {
        def codigoComprasPublicasInstance = CodigoComprasPublicas.get(params.id)
        if (!codigoComprasPublicasInstance) {
            render "no_No se encontró el registro"
        }

        try {
            codigoComprasPublicasInstance.delete(flush: true)
            render "ok_Borrado correctamente"
        }
        catch (DataIntegrityViolationException e) {
            println("error al borrar el CPC " + codigoComprasPublicasInstance.errors)
            render "no_Error al borrar el registro"
        }
    } //delete



    def cargarCPC () {

    }


//    def uploadFile() {
//        println("params uf " + params)
//
//        def fecha
//        def error = ''
//
//        if (!params.fecha) {
//            flash.message = "Ingrese la fecha"
//            redirect(action: 'cargarCPC')
//        }else{
//            fecha = new Date().parse("dd-MM-yyyy", params.fecha)
//        }
//
//
//        def path = "/var/janus/" + "xls/"   //web-app/archivos
//        new File(path).mkdirs()
//
//        def f = request.getFile('file')  //archivo = name del input type file
//
//
//        if (f && !f.empty) {
//            def fileName = f.getOriginalFilename() //nombre original del archivo
//            def ext
//
//            def parts = fileName.split("\\.")
//            fileName = ""
//            parts.eachWithIndex { obj, i ->
//                if (i < parts.size() - 1) {
//                    fileName += obj
//                } else {
//                    ext = obj
//                }
//            }
//
//
//
//            if (ext == "xls") {
//
//                fileName = "xlsCPC_" + new Date().format("yyyyMMdd_HHmmss")
//
//                def fn = fileName
//                fileName = fileName + "." + ext
//
//                def pathFile = path + fileName
//                def src = new File(pathFile)
//
//                def i = 1
//                while (src.exists()) {
//                    pathFile = path + fn + "_" + i + "." + ext
//                    src = new File(pathFile)
//                    i++
//                }
//
//                f.transferTo(new File(pathFile)) // guarda el archivo subido al nuevo path
//
//                def htmlInfo = "", errores = "", doneHtml = "", done = 0
//                def file = new File(pathFile)
//                Workbook workbook = Workbook.getWorkbook(file)
//
//                workbook.getNumberOfSheets().times { sheet ->
////                    if (sheet == 0) {
//                    Sheet s = workbook.getSheet(sheet)
//                    if (!s.getSettings().isHidden()) {
//                        println s.getName() + "  " + sheet
//                        htmlInfo += "<h2>Hoja " + (sheet + 1) + ": " + s.getName() + "</h2>"
//                        errores += "<h2>Hoja " + (sheet + 1) + ": " + s.getName() + "</h2>"
//                        Cell[] row = null
//                        s.getRows().times { j ->
//                            if (j == 0) {
//                                errores += "<ol>"
//                            }
//                            println ">>>>>>>>>>>>>>>" + (j + 1)
//                            row = s.getRow(j)
////                            println "row.length: ${row.length}"
//
//                            if(j >= 7){
//
//                                if(row.length == 0){
//                                    println("fila no existente")
//                                }else{
//                                    def codigo = row[0]?.getContents()
//                                    def descripcion = row[1]?.getContents()
//
//                                    if(!codigo || !descripcion){
//                                        println("en blanco")
//                                    }else{
//                                        println("cod " + codigo)
//                                        println("des " + descripcion)
//
//                                        def bCodigo = CodigoComprasPublicas.findAllByNumero(codigo)
//                                        if(bCodigo){
//                                            println("codigo existente " + codigo)
//                                        }else{
//                                            println("codigo NO existente " + codigo)
//                                            def nuevo = new CodigoComprasPublicas()
//                                            nuevo.numero = codigo
//                                            nuevo.descripcion = descripcion
//                                            nuevo.fecha = fecha
//
//                                            try{
//                                                nuevo.save(flush: true)
//                                            }catch(e){
//                                                error += e + " - "
//                                                println("error al guardar nuevo cpc " + nuevo.errors + " " + e)
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//
//                if(error == ''){
//                    flash.message = "Registros cargados correctamente"
//                    redirect(action: 'cargarCPC')
//                }else{
//                    flash.message = "Error al cargar los registros"
//                    redirect(action: 'cargarCPC')
//                }
//
//
//            }else{
//                flash.message = "Seleccione un archivo Excel xls para procesar (archivos xlsx deben ser convertidos a xls primero)"
//                redirect(action: 'cargarCPC')
//            }
//
//        }
//    }
//

    def uploadFile() {
        println "uploadFile $params"
        def cn = dbConnectionService.getConnection()
        def filasNO = [0, 1]
        def path = "/var/janus/" + "xls/"   //web-app/archivos
        new File(path).mkdirs()
        def fecha = new Date().parse("dd-MM-yyyy", params.fecha).format('yyyy-MM-dd')
        def sql = ""
        def cuenta = 0

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

                fileName = "CPC_" + new Date().format("yyyyMMdd_HHmmss")

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

                XSSFSheet sheet1 = workbook.getSheetAt(0);
                XSSFRow row;
                XSSFCell cell;

                XSSFRow row1;
                XSSFCell cell1;

                Iterator rows = sheet1.rowIterator();
                while (rows.hasNext()) {
                    i

                    row = (XSSFRow) rows.next()

                    if (!(row.rowNum in filasNO)) {
                        def ok = true
                        Iterator cells = row.cellIterator()
                        def rgst = []

                        while (cells.hasNext()) {
                            cell = (XSSFCell) cells.next()
//                            println "cell: $cell"
                            if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
                                if (cell.getCellStyle().getDataFormatString().contains("%")) {
                                    rgst.add(cell.getNumericCellValue())
                                } else {
                                    rgst.add(cell.getNumericCellValue())
                                }

                            } else if (cell.getCellType() == XSSFCell.CELL_TYPE_STRING) {
                                rgst.add(cell.getStringCellValue())
                            } else {
                                rgst.add('')
                            }
                        }
//                        println "rgst: $rgst"
                        def numero = rgst[0]
                        def dscr = rgst[1]
                        def vae = rgst[2]
                        def umve = -1.00

                        try {
                            umve = vae.toDouble() * 100
                        } catch (e) {umve = -1}
                        println "valores: $numero $dscr $vae $umve"

                        if ( umve != -1 ) {
                            println "puede procesar: $rgst"
                            sql = "select cpac__id from cpac where cpacnmro = '${numero}'"
                            println "sql: $sql"
                            def cp_id = cn.rows(sql.toString())[0]?.cpac__id
                            if (!cp_id) {
                                errores += "<li>Se ingresa ${numero} ${dscr})</li>"
                                println "No se encontró el CPC ${numero}"
                                sql = "insert into cpac(cpacnmro, cpacdscr, cpacnvel, cpacfcha, cpacmvnt, cpacumve) " +
                                        "values('${numero}', '${dscr}', 9, '${fecha}', 1, ${umve})"
                                println "inserta $sql"
                                try {
                                    cn.execute(sql.toString())
                                    htmlInfo += "<p>ITEM añadido: " + numero + ' ' + dscr + "</p>"

                                } catch (e) {
                                    println " no se pudo insertar $rgst: ${e.erros()}"
                                }
                            } else {
                                sql = "update cpac set cpacdscr = '${dscr}', cpacfcha = '${fecha}' " +
                                        "where cpac__id = ${cp_id}"
                                println "actualiza $cp_id $sql"
                                try {
                                    cn.execute(sql.toString())
                                    cuenta++
                                } catch (e) {
                                    println " no se pudo actualizar $rgst: ${e.erros()}"
                                }

                            }
                        }
                    }
                } //sheets.each
                htmlInfo += "<h3>Se ha actualziado: " + cuenta + " registros del CPC</h3>"

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
                redirect(action: "mensajeUploadContrato", id: params.id)
            } else {
                flash.message = "Seleccione un archivo Excel xlsx para procesar (archivos xls deben ser convertidos a xlsx primero)"
                redirect(action: 'formArchivo')
            }
        } else {
            flash.message = "Seleccione un archivo para procesar"
            redirect(action: 'subirExcel')
        }
    }


    def actualizar(){

    }

    def uploadCpc(){

    }

    def subirExcel_ajax(){

    }

    def actualizaVae(){
        def cn = dbConnectionService.getConnection()
        def sql = "select max(cpacfcha) fcha from cpac"
        def fcha = cn.rows(sql.toString())[0]?.fcha

        sql = "select itvafcha from itva where itvafcha = '${fcha}' "
        def existe = cn.rows(sql.toString())[0]?.itvafcha

        if(!existe) {
            sql = "insert into itva(itvafcha, itvafcin, item__id, itvapcnt, itvargst) " +
                    "select '${fcha}', now()::date, item__id, cpacumve, 'N' from item, cpac " +
                    "where item.cpac__id = cpac.cpac__id and cpacfcha = '${fcha}' "
            println "sql. $sql"
            cn.execute(sql.toString())
        }
        cn.close()
        render "ok"
    }

    def mensajeUploadContrato() {
    }


} //fin controller
