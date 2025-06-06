package janus

import com.lowagie.text.*
import com.lowagie.text.pdf.PdfContentByte
import com.lowagie.text.pdf.PdfPCell
import com.lowagie.text.pdf.PdfPTable
import com.lowagie.text.pdf.PdfWriter
//import construye.DetalleConsumo
//import janus.construye.Consumo
import janus.pac.CronogramaContratado

import jxl.Workbook
import jxl.WorkbookSettings
import jxl.write.*
import org.apache.poi.ss.usermodel.Sheet
import org.apache.poi.xssf.usermodel.XSSFCellStyle
import org.apache.poi.xssf.usermodel.XSSFFont
import org.apache.poi.xssf.usermodel.XSSFWorkbook
import seguridad.Persona

import java.awt.*

class Reportes5Controller{

    def dbConnectionService
    def preciosService
    def reportesService
    def reportesPdfService

    def meses = ['', "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]

    private String printFecha(Date fecha) {
        if (fecha) {
            return (fecha.format("dd") + ' de ' + meses[fecha.format("MM").toInteger()] + ' de ' + fecha.format("yyyy"))
        } else {
            return "Error: no hay fecha que mostrar"
        }
    }

    private String printFechaMes(Date fecha) {
        if (fecha) {
            return (meses[fecha.format("MM").toInteger()] + ' de ' + fecha.format("yyyy"))
        } else {
            return "Error: no hay fecha que mostrar"
        }
    }

    private filasAvance(params) {
        def sqlBase = "SELECT\n" +
                "  c.cntr__id               id,\n" +
                "  b.obracdgo               obra_cod,\n" +
                "  b.obranmbr               obra_nmbr,\n" +
                "  b.obratipo               tipo,\n" +
                "  b.prsn__id               responsable,\n" +
                "  z.dptocdgo               codigodepar,\n" +
                "  m.cmndnmbr               comunidad,\n" +
                "  a.parrnmbr               parroquia,\n" +
                "  k.cntnnmbr               canton,\n" +
                "  c.cntrcdgo               num_contrato,\n" +
                "  p.prvenmbr               proveedor,\n" +
                "  c.cntrmnto               monto,\n" +
                "  c.cntrfcsb               fecha,\n" +
                "  c.cntrplzo               plazo,\n" +
                "  (SELECT\n" +
                "  coalesce(sum(plnlmnto), 0)\n" +
                "   FROM plnl\n" +
                "   WHERE cntr__id = c.cntr__id\n" +
                "         AND tppl__id = 3) sum,\n" +
                "  (SELECT\n" +
                "  plnlavfs\n" +
                "   FROM plnl\n" +
                "   WHERE cntr__id = c.cntr__id\n" +
                "         AND plnlfcin IS NOT null\n" +
                "   ORDER BY plnlfcin DESC\n" +
                "   LIMIT 1)                fisico,\n" +
                "  b.obrafcin               inicio,\n" +
                "  c.cntrfccn               recepcion_contratista,\n" +
                "  c.cntrfcfs               recepcion_fisc\n" +
                "FROM cntr c\n" +
                "  INNER JOIN ofrt o ON c.ofrt__id = o.ofrt__id\n" +
                "  INNER JOIN cncr n ON o.cncr__id = n.cncr__id\n" +
                "  INNER JOIN obra b ON n.obra__id = b.obra__id\n" +
                "  INNER JOIN dpto z ON b.dpto__id = z.dpto__id\n" +
                "  INNER JOIN tpob t ON b.tpob__id = t.tpob__id\n" +
                "  INNER JOIN prve p ON o.prve__id = p.prve__id\n" +
                "  INNER JOIN cmnd m ON b.cmnd__id = m.cmnd__id\n" +
                "  INNER JOIN parr a ON m.parr__id = a.parr__id\n" +
                "  INNER JOIN cntn k ON a.cntn__id = k.cntn__id"

        def filtroBuscador = "", buscador

        switch (params.buscador) {
            case "cdgo":
            case "nmbr":
            case "ofig":
            case "ofsl":
            case "mmsl":
            case "frpl":
            case "tipo":
                buscador = "b.obra" + params.buscador
                filtroBuscador = " ${buscador} ILIKE ('%${params.criterio}%') "
                break;
            case "cmnd":
                filtroBuscador = " m.cmndnmbr ILIKE ('%${params.criterio}%') "
                break;
            case "parr":
                filtroBuscador = " a.parrnmbr ILIKE ('%${params.criterio}%') "
                break;
            case "cntn":
                filtroBuscador = " k.cntnnmbr ILIKE ('%${params.criterio}%') "
                break;
            case "cntr":
                filtroBuscador = " c.cntrcdgo ILIKE ('%${params.criterio}%') "
                break;
            case "cnts":
                filtroBuscador = " p.prvenmbr ILIKE ('%${params.criterio}%') OR p.prvenbct ILIKE ('%${params.criterio}%') OR p.prveapct ILIKE ('%${params.criterio}%')"
                break;
        }

        if (filtroBuscador != "") {
            filtroBuscador = " WHERE " + filtroBuscador
        }

        def sql = sqlBase + filtroBuscador
        def cn = dbConnectionService.getConnection()

        return cn.rows(sql.toString())
    }

    def avance() {
        def cn = dbConnectionService.getConnection()
        def departamento = [:]
        def sql = "select distinct obra.dpto__id id, diredscr||' - '||dptodscr nombre " +
                "from obra, dpto, dire, cntr " +
                "where dpto.dpto__id = obra.dpto__id and dire.dire__id = dpto.dire__id and " +
                "cntr.obra__id = obra.obra__id and cntretdo = 'R' " +
                "order by 2"
        println "sqlReg: $sql"
        cn.eachRow(sql.toString()) { r ->
            departamento[r.id] = r.nombre
        }
        [departamento: departamento]
    }

    def tablaAvance_old() {
        params.old = params.criterio
        params.criterio = reportesService(params.criterio)

        def res = filasAvance(params)

        def personasPRSP = Persona.findAllByDepartamento(Departamento.findByCodigo('CRFC'))
        def responsableObra

        def obrasFiltradas = []


        if(Persona.get(session.usuario.id).departamento?.codigo == 'CRFC'){
            res.each{
                responsableObra = it.responsable
                if((personasPRSP.contains(Persona.get(responsableObra))) || it.tipo == 'D'){
                    obrasFiltradas += it
                }
            }
        }else{
            obrasFiltradas = res
        }

        params.criterio = params.old

        return [res: obrasFiltradas, params: params]
    }

    def tablaAvance() {
        def cn = dbConnectionService.getConnection()
        def campos = reportesService.obrasAvance()

        params.old = params.criterio
        params.criterio = reportesService.limpiaCriterio(params.criterio)

        def sql = armaSqlAvance(params)
        println "sql: $sql"
        def obras = cn.rows(sql)

        params.criterio = params.old
        return [obras: obras, params: params]
    }

    def armaSqlAvance(params){
        def campos = reportesService.obrasAvance()
        def operador = reportesService.operadores()
        println "armaSqlAvance: $params"
        def fcin = params.fechaInicio ? new Date().parse("dd-MM-yyyy", params.fechaInicio).format('yyyy-MM-dd') : ''
        def fcfn = params.fechaFin ? new Date().parse("dd-MM-yyyy", params.fechaFin).format('yyyy-MM-dd') : ''

        def sqlSelect = "select obra.obra__id, obracdgo, obranmbr, cntnnmbr, parrnmbr, cmndnmbr, c.cntrcdgo, " +
                "c.cntrmnto, c.cntrfcsb, prvenmbr, c.cntrplzo, obrafcin, cntrfcfs," +
                "(select(coalesce(sum(plnlmnto), 0)) / cntrmnto av_economico " +
                "from plnl where cntr__id = c.cntr__id and tppl__id > 1), " +
                "(select(coalesce(max(plnlavfs), 0)) av_fisico " +
                "from plnl where cntr__id = c.cntr__id and tppl__id > 1) " +  // no cuenta el anticipo
                "from obra, cntn, parr, cmnd, cncr, ofrt, cntr c, dpto, prve "
        def sqlWhere = "where cmnd.cmnd__id = obra.cmnd__id and " +
                "parr.parr__id = obra.parr__id and cntn.cntn__id = parr.cntn__id and " +
                "cncr.obra__id = obra.obra__id and ofrt.cncr__id = cncr.cncr__id and " +
                "c.ofrt__id = ofrt.ofrt__id and dpto.dpto__id = obra.dpto__id and " +
                "prve.prve__id = c.prve__id"
        def sqlOrder = "order by obracdgo"

//        println "llega params: $params"
        params.nombre = "Código"
        if(campos.find {it.campo == params.buscador}?.size() > 0) {
            def op = operador.find {it.valor == params.operador}
            println "op: $op"
            sqlWhere += " and ${params.buscador} ${op.operador} ${op.strInicio}${params.criterio}${op.strFin}";
        }

        if(params.departamento) sqlWhere += " and obra.dpto__id = ${params.departamento} "
        if(params.fechaInicio) sqlWhere += " and obrafcha >= '${fcin}' "
        if(params.fechaFIn) sqlWhere += " and obrafcha <= '${fcfn}' "
        println "sql: ${sqlSelect} ${sqlWhere} ${sqlOrder}"
        "$sqlSelect $sqlWhere $sqlOrder".toString()
    }

    def reporteAvance() {

        def baos = new ByteArrayOutputStream()
        def name = "avance_obras_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        Font titleFont = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font titleFont3 = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font titleFont2 = new Font(Font.TIMES_ROMAN, 16, Font.BOLD);
        Font times8normal = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL);
        Font times7normal = new Font(Font.TIMES_ROMAN, 7, Font.NORMAL);
        Font fontTh = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font fontTh8 = new Font(Font.TIMES_ROMAN, 8, Font.BOLD);
        Font fontTd = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL);

        Document document
        document = new Document(PageSize.A4.rotate());
        def pdfw = PdfWriter.getInstance(document, baos);

        document.open();
        document.addTitle("avanceObra " + new Date().format("dd_MM_yyyy"));
        document.addSubject("Generado por el sistema Janus");
        document.addKeywords("reporte, janus,matriz");
        document.addAuthor("Janus");
        document.addCreator("Tedein SA");

        Paragraph headersTitulo = new Paragraph();
        addEmptyLine(headersTitulo, 1)
        headersTitulo.setAlignment(Element.ALIGN_CENTER);
        headersTitulo.add(new Paragraph((Auxiliar.get(1)?.titulo ?: ''), titleFont2));
        addEmptyLine(headersTitulo, 1);
        headersTitulo.add(new Paragraph("REPORTE DE AVANCE DE OBRAS", titleFont));
        headersTitulo.add(new Paragraph("Quito, " + fechaConFormato(new Date(), "dd MMMM yyyy").toUpperCase(), titleFont3));
        addEmptyLine(headersTitulo, 1);
        addEmptyLine(headersTitulo, 1);

        document.add(headersTitulo)

        params.old = params.criterio
        params.criterio = reportesService.limpiaCriterio(params.criterio)

        def cn = dbConnectionService.getConnection()
        def campos = reportesService.obrasAvance()
        def sql = armaSqlAvance(params)
        def obras = cn.rows(sql)
        params.criterio = params.old

        def tablaDatos = new PdfPTable(10);
        tablaDatos.setWidthPercentage(100);
        tablaDatos.setWidths(arregloEnteros([9, 21, 14, 9, 11, 7, 9, 6, 5, 5]))

        def paramsHead = [border: Color.BLACK, align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE, bordeTop: "1", bordeBot: "1"]
        def prmsCellLeft = [border: Color.BLACK, valign: Element.ALIGN_MIDDLE, bordeBot: "1"]
        def prmsCellRight = [border: Color.BLACK, align : Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE, bordeBot: "1"]
        def prmsCellCenter = [border: Color.BLACK, align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE, bordeBot: "1"]

        addCellTabla(tablaDatos, new Paragraph("Código", fontTh8), paramsHead)
        addCellTabla(tablaDatos, new Paragraph("Nombre", fontTh8), paramsHead)
        addCellTabla(tablaDatos, new Paragraph("Cantón-Parroquia-Comunidad", fontTh8), paramsHead)
        addCellTabla(tablaDatos, new Paragraph("Núm. Contrato", fontTh8), paramsHead)
        addCellTabla(tablaDatos, new Paragraph("Contratista", fontTh8), paramsHead)
        addCellTabla(tablaDatos, new Paragraph("Monto", fontTh8), paramsHead)
        addCellTabla(tablaDatos, new Paragraph("Fecha suscripción", fontTh8), paramsHead)
        addCellTabla(tablaDatos, new Paragraph("Plazo", fontTh8), paramsHead)
        addCellTabla(tablaDatos, new Paragraph("% Avance", fontTh8), paramsHead)
        addCellTabla(tablaDatos, new Paragraph("Avance Físico", fontTh8), paramsHead)

        obras.each { fila ->
            addCellTabla(tablaDatos, new Paragraph(fila.obracdgo, fontTd), prmsCellLeft)
            addCellTabla(tablaDatos, new Paragraph(fila.obranmbr, fontTd), prmsCellLeft)
            addCellTabla(tablaDatos, new Paragraph(fila.cntnnmbr + " - " + fila.parrnmbr + " - " + fila.cmndnmbr, times7normal), prmsCellLeft)
            addCellTabla(tablaDatos, new Paragraph(fila.cntrcdgo, fontTd), prmsCellLeft)
            addCellTabla(tablaDatos, new Paragraph(fila.prvenmbr, times7normal), prmsCellLeft)
            addCellTabla(tablaDatos, new Paragraph(numero(fila.cntrmnto, 2), fontTd), prmsCellRight)
            addCellTabla(tablaDatos, new Paragraph(fila.cntrfcsb.format("dd-MM-yyyy"), fontTd), prmsCellCenter)
            addCellTabla(tablaDatos, new Paragraph(numero(fila.cntrplzo, 0) + " días", fontTd), prmsCellCenter)
            addCellTabla(tablaDatos, new Paragraph(numero( (fila.av_economico) * 100, 2) + "%", fontTd), prmsCellCenter)
            addCellTabla(tablaDatos, new Paragraph(numero(fila.av_fisico, 2), fontTd), prmsCellCenter)
        }

        document.add(tablaDatos)

        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

//    def reporteExcelAvance () {
//
//        def cn = dbConnectionService.getConnection()
//        def campos = reportesService.obrasAvance()
//        params.old = params.criterio
//        params.criterio = reportesService.limpiaCriterio(params.criterio)
//        def sql = armaSqlAvance(params)
//        def obras = cn.rows(sql)
//        params.criterio = params.old
//
//        //excel
//        WorkbookSettings workbookSettings = new WorkbookSettings()
//        workbookSettings.locale = Locale.default
//
//        def file = File.createTempFile('myExcelDocument', '.xls')
//        file.deleteOnExit()
//
//        WritableWorkbook workbook = Workbook.createWorkbook(file, workbookSettings)
//
//        WritableFont font = new WritableFont(WritableFont.ARIAL, 12)
//        WritableCellFormat formatXls = new WritableCellFormat(font)
//
//        def row = 0
//        WritableSheet sheet = workbook.createSheet('MySheet', 0)
//
//        WritableFont times16font = new WritableFont(WritableFont.TIMES, 11, WritableFont.BOLD, false);
//        WritableCellFormat times16format = new WritableCellFormat(times16font);
//        sheet.setColumnView(0, 12)
//        sheet.setColumnView(1, 60)
//        sheet.setColumnView(2, 30)
//        sheet.setColumnView(3, 20)
//        sheet.setColumnView(4, 40)
//        sheet.setColumnView(5, 15)
//        sheet.setColumnView(6, 17)
//        sheet.setColumnView(7, 10)
//        sheet.setColumnView(8, 15)
//        sheet.setColumnView(9, 15)
//
//        def label
//        def nmro
//        def number
//
//        def fila = 6;
//
//        NumberFormat nf = new NumberFormat("#.##");
//        WritableCellFormat cf2obj = new WritableCellFormat(nf);
//
//        label = new Label(1, 1, (Auxiliar.get(1)?.titulo ?: ''), times16format); sheet.addCell(label);
//        label = new Label(1, 2, "REPORTE EXCEL AVANCE DE OBRAS", times16format); sheet.addCell(label);
//        label = new Label(0, 4, "Código: ", times16format); sheet.addCell(label);
//        label = new Label(1, 4, "Nombre", times16format); sheet.addCell(label);
//        label = new Label(2, 4, "Cantón-Parroquia-Comunidad", times16format); sheet.addCell(label);
//        label = new Label(3, 4, "Num. Contrato", times16format); sheet.addCell(label);
//        label = new Label(4, 4, "Contratista", times16format); sheet.addCell(label);
//        label = new Label(5, 4, "Monto", times16format); sheet.addCell(label);
//        label = new Label(6, 4, "Fecha suscripción", times16format); sheet.addCell(label);
//        label = new Label(7, 4, "Plazo", times16format); sheet.addCell(label);
//        label = new Label(8, 4, "% Avance", times16format); sheet.addCell(label);
//        label = new Label(9, 4, "Avance Físico", times16format); sheet.addCell(label);
//
//        obras.eachWithIndex {i, j->
//            label = new Label(0, fila, i.obracdgo.toString()); sheet.addCell(label);
//            label = new Label(1, fila, i?.obranmbr?.toString()); sheet.addCell(label);
//            label = new Label(2, fila, i?.cntnnmbr?.toString() + " " + i?.parrnmbr?.toString() + " " + i?.cmndnmbr?.toString()); sheet.addCell(label);
//            label = new Label(3, fila, i?.cntrcdgo?.toString()); sheet.addCell(label);
//            label = new Label(4, fila, i?.prvenmbr?.toString()); sheet.addCell(label);
//            number = new jxl.write.Number(5, fila, i.cntrmnto); sheet.addCell(number);
//            label = new Label(6, fila, i?.cntrfcsb?.toString()); sheet.addCell(label);
//            number = new jxl.write.Number(7, fila, i.cntrplzo); sheet.addCell(number);
//            number = new jxl.write.Number(8, fila, (i.av_economico * 100)); sheet.addCell(number);
//            number = new jxl.write.Number(9, fila, (i.av_fisico * 100)); sheet.addCell(number);
//            fila++
//        }
//
//        workbook.write();
//        workbook.close();
//        def output = response.getOutputStream()
//        def header = "attachment; filename=" + "DocumentosObraExcel.xls";
//        response.setContentType("application/octet-stream")
//        response.setHeader("Content-Disposition", header);
//        output.write(file.getBytes());
//    }

    private String fechaConFormato(fecha, formato) {
        def meses = ["", "Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"]
        def mesesLargo = ["", "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
        def strFecha = ""
        if (fecha) {
            switch (formato) {
                case "MMM-yy":
                    strFecha = meses[fecha.format("MM").toInteger()] + "-" + fecha.format("yy")
                    break;
                case "dd-MM-yyyy":
                    strFecha = "" + fecha.format("dd-MM-yyyy")
                    break;
                case "dd-MMM-yyyy":
                    strFecha = "" + fecha.format("dd") + "-" + meses[fecha.format("MM").toInteger()] + "-" + fecha.format("yyyy")
                    break;
                case "dd MMMM yyyy":
                    strFecha = "" + fecha.format("dd") + " de " + mesesLargo[fecha.format("MM").toInteger()] + " de " + fecha.format("yyyy")
                    break;
                default:
                    strFecha = "Formato " + formato + " no reconocido"
                    break;
            }
        }
        return strFecha
    }

    private String fechaConFormato(fecha) {
        return fechaConFormato(fecha, "MMM-yy")
    }

    private String numero(num, decimales, cero) {
        if (num == 0 && cero.toString().toLowerCase() == "hide") {
            return " ";
        }
        if (decimales == 0) {
            return formatNumber(number: num, minFractionDigits: decimales, maxFractionDigits: decimales, locale: "ec")
        } else {
            def format
            if (decimales == 2) {
                format = "##,##0"
            } else if (decimales == 3) {
                format = "##,###0"
            }
            return formatNumber(number: num, minFractionDigits: decimales, maxFractionDigits: decimales, locale: "ec", format: format)
        }
    }

    private String numero(num, decimales) {
        return numero(num, decimales, "show")
    }

    private String numero(num) {
        return numero(num, 3)
    }

    private static void addEmptyLine(Paragraph paragraph, int number) {
        for (int i = 0; i < number; i++) {
            paragraph.add(new Paragraph(" "));
        }
    }

    private static int[] arregloEnteros(array) {
        int[] ia = new int[array.size()]
        array.eachWithIndex { it, i ->
            ia[i] = it.toInteger()
        }
        return ia
    }

    private static void addCellTabla(PdfPTable table, paragraph, params) {
        PdfPCell cell = new PdfPCell(paragraph);
        if (params.height) {
            cell.setFixedHeight(params.height.toFloat());
        }
        if (params.border) {
            cell.setBorderColor(params.border);
        }
        if (params.bg) {
            cell.setBackgroundColor(params.bg);
        }
        if (params.colspan) {
            cell.setColspan(params.colspan);
        }
        if (params.align) {
            cell.setHorizontalAlignment(params.align);
        }
        if (params.valign) {
            cell.setVerticalAlignment(params.valign);
        }
        if (params.w) {
            cell.setBorderWidth(params.w);
            cell.setUseBorderPadding(true);
        }
        if (params.bwl) {
            cell.setBorderWidthLeft(params.bwl.toFloat());
            cell.setUseBorderPadding(true);
        }
        if (params.bwb) {
            cell.setBorderWidthBottom(params.bwb.toFloat());
            cell.setUseBorderPadding(true);
        }
        if (params.bwr) {
            cell.setBorderWidthRight(params.bwr.toFloat());
            cell.setUseBorderPadding(true);
        }
        if (params.bwt) {
            cell.setBorderWidthTop(params.bwt.toFloat());
            cell.setUseBorderPadding(true);
        }
        if (params.bcl) {
            cell.setBorderColorLeft(params.bcl);
            cell.setUseVariableBorders(true);
        }
        if (params.bcb) {
            cell.setBorderColorBottom(params.bcb);
            cell.setUseVariableBorders(true);
        }
        if (params.bcr) {
            cell.setBorderColorRight(params.bcr);
            cell.setUseVariableBorders(true);
        }
        if (params.bct) {
            cell.setBorderColorTop(params.bct);
            cell.setUseVariableBorders(true);
        }
        if (params.padding) {
            cell.setPadding(params.padding.toFloat());
        }
        if (params.pl) {
            cell.setPaddingLeft(params.pl.toFloat());
        }
        if (params.pr) {
            cell.setPaddingRight(params.pr.toFloat());
        }
        if (params.pt) {
            cell.setPaddingTop(params.pt.toFloat());
        }
        if (params.pb) {
            cell.setPaddingBottom(params.pb.toFloat());
        }
        if (params.bordeTop) {
            cell.setBorderWidthTop(1)
            cell.setBorderWidthLeft(0)
            cell.setBorderWidthRight(0)
            cell.setBorderWidthBottom(0)
            cell.setPaddingTop(7);
        }
        if (params.bordeBot) {
            cell.setBorderWidthBottom(1)
            cell.setBorderWidthLeft(0)
            cell.setBorderWidthRight(0)
            cell.setPaddingBottom(7)

            if (!params.bordeTop) {
                cell.setBorderWidthTop(0)
            }
        }
        table.addCell(cell);
    }

    private static void addCellTabla3(PdfPTable table, paragraph, params) {
        PdfPCell cell = new PdfPCell(paragraph);
        if (params.height) {
            cell.setFixedHeight(params.height.toFloat());
        }
        if (params.border) {
            cell.setBorderColor(params.border);
        }
        if (params.bg) {
            cell.setBackgroundColor(params.bg);
        }
        if (params.colspan) {
            cell.setColspan(params.colspan);
        }
        if (params.align) {
            cell.setHorizontalAlignment(params.align);
        }
        if (params.valign) {
            cell.setVerticalAlignment(params.valign);
        }
        if (params.w) {
            cell.setBorderWidth(params.w);
            cell.setUseBorderPadding(true);
        }
        if (params.bwl) {
            cell.setBorderWidthLeft(params.bwl.toFloat());
            cell.setUseBorderPadding(true);
        }
        if (params.bwb) {
            cell.setBorderWidthBottom(params.bwb.toFloat());
            cell.setUseBorderPadding(true);
        }
        if (params.bwr) {
            cell.setBorderWidthRight(params.bwr.toFloat());
            cell.setUseBorderPadding(true);
        }
        if (params.bwt) {
            cell.setBorderWidthTop(params.bwt.toFloat());
            cell.setUseBorderPadding(true);
        }
        if (params.bcl) {
            cell.setBorderColorLeft(params.bcl);
        }
        if (params.bcb) {
            cell.setBorderColorBottom(params.bcb);
        }
        if (params.bcr) {
            cell.setBorderColorRight(params.bcr);
        }
        if (params.bct) {
            cell.setBorderColorTop(params.bct);
        }
        if (params.padding) {
            cell.setPadding(params.padding.toFloat());
        }
        if (params.pl) {
            cell.setPaddingLeft(params.pl.toFloat());
        }
        if (params.pr) {
            cell.setPaddingRight(params.pr.toFloat());
        }
        if (params.pt) {
            cell.setPaddingTop(params.pt.toFloat());
        }
        if (params.pb) {
            cell.setPaddingBottom(params.pb.toFloat());
        }

        table.addCell(cell);
    }

    private static void addCellTabla2(PdfPTable table, paragraph, params) {
        PdfPCell cell = new PdfPCell(paragraph);
        if (params.height) {
            cell.setFixedHeight(params.height.toFloat());
        }
        if (params.border) {
            cell.setBorderColor(params.border);
        }
        if (params.bg) {
            cell.setBackgroundColor(params.bg);
        }
        if (params.colspan) {
            cell.setColspan(params.colspan);
        }
        if (params.align) {
            cell.setHorizontalAlignment(params.align);
        }
        if (params.valign) {
            cell.setVerticalAlignment(params.valign);
        }
        if (params.w) {
            cell.setBorderWidth(params.w);
            cell.setUseBorderPadding(true);
        }
        if (params.bwl) {
            cell.setBorderWidthLeft(params.bwl.toFloat());
            cell.setUseBorderPadding(true);
        }
        if (params.bwb) {
            cell.setBorderWidthBottom(params.bwb.toFloat());
            cell.setUseBorderPadding(true);
        }
        if (params.bwr) {
            cell.setBorderWidthRight(params.bwr.toFloat());
            cell.setUseBorderPadding(true);
        }
        if (params.bwt) {
            cell.setBorderWidthTop(params.bwt.toFloat());
            cell.setUseBorderPadding(true);
        }
        if (params.bcl) {
            cell.setBorderColorLeft(params.bcl);
        }
        if (params.bcb) {
            cell.setBorderColorBottom(params.bcb);
        }
        if (params.bcr) {
            cell.setBorderColorRight(params.bcr);
        }
        if (params.bct) {
            cell.setBorderColorTop(params.bct);
        }
        if (params.padding) {
            cell.setPadding(params.padding.toFloat());
        }
        if (params.pl) {
            cell.setPaddingLeft(params.pl.toFloat());
        }
        if (params.pr) {
            cell.setPaddingRight(params.pr.toFloat());
        }
        if (params.pt) {
            cell.setPaddingTop(params.pt.toFloat());
        }
        if (params.pb) {
            cell.setPaddingBottom(params.pb.toFloat());
        }

        table.addCell(cell);
    }

    def reporteFormulaExcel() {
        def auxiliar = Auxiliar.get(1)
        def auxiliarFijo = Auxiliar.get(1)
        def obra = Obra.get(params.id)
        def firma
        def firmas
        def firmaFijaFormu
        def cuenta = 0;
        def formula = FormulaPolinomica.findAllByObra(obra)
        def ps = FormulaPolinomica.findAllByObraAndNumeroIlike(obra, 'p%', [sort: 'numero'])
        def cuadrilla = FormulaPolinomica.findAllByObraAndNumeroIlike(obra, 'c%', [sort: 'numero'])
        def c
        def z = []
        def banderafp = 0
        def firma1 = obra?.responsableObra;
        def firma2 = obra?.revisor;
        def nota

        if(params.notaPoli != '-1' || params.notaPoli != -1){
            nota = Nota.get(params.notaPoli)?.texto
        }else {
            nota = ''
        }

        if (params.firmasIdFormu.trim().size() > 0) {
            firma = params.firmasIdFormu.split(",")
            firma = firma.toList().unique()
        } else {
            firma = []
        }
        if (params.firmasFijasFormu.trim().size() > 0) {
            firmaFijaFormu = params.firmasFijasFormu.split(",")
        } else {
            firmaFijaFormu = []
        }

        cuenta = firma.size() + firmaFijaFormu.size()

        def totalBase = params.totalPresupuesto

        if (obra?.formulaPolinomica == null) {
            obra?.formulaPolinomica = ""
        }
        //excel
        WorkbookSettings workbookSettings = new WorkbookSettings()
        workbookSettings.locale = Locale.default

        def file = File.createTempFile('myExcelDocument', '.xls')
        file.deleteOnExit()
        WritableWorkbook workbook = Workbook.createWorkbook(file, workbookSettings)
        WritableFont font = new WritableFont(WritableFont.ARIAL, 12)
        WritableCellFormat formatXls = new WritableCellFormat(font)

        def row = 0

        WritableSheet sheet = workbook.createSheet('MySheet', 0)
        WritableFont times16font = new WritableFont(WritableFont.TIMES, 11, WritableFont.BOLD, false);
        WritableCellFormat times16format = new WritableCellFormat(times16font);
        sheet.setColumnView(0, 12)
        sheet.setColumnView(1, 25)
        sheet.setColumnView(2, 25)
        sheet.setColumnView(3, 60)
        sheet.setColumnView(4, 25)
        sheet.setColumnView(5, 25)
        sheet.setColumnView(6, 25)
        sheet.setColumnView(7, 25)

        def label
        def number
        def nmro
        def numero = 1;
        def fila = 16;
        def ultimaFila

        label = new Label(1, 2, auxiliar?.titulo, times16format); sheet.addCell(label);
        label = new Label(1, 3, auxiliar?.memo1, times16format); sheet.addCell(label);
        label = new Label(1, 4, "FÓRMULA POLINÓMICA", times16format); sheet.addCell(label);
        label = new Label(1, 6, obra?.formulaPolinomica, times16format); sheet.addCell(label);
        label = new Label(1, 8, "De existir variaciones en los costos de los componentes de precios unitarios estipulados en el contrato para la construcción de:", times16format);
        sheet.addCell(label);

        label = new Label(1, 10, "Nombre: ", times16format); sheet.addCell(label);
        label = new Label(2, 10, obra?.nombre, times16format); sheet.addCell(label);
        label = new Label(1, 11, "Tipo de Obra: ", times16format); sheet.addCell(label);
        label = new Label(2, 11, obra?.tipoObjetivo?.descripcion, times16format); sheet.addCell(label);
        label = new Label(1, 12, "Código Obra: ", times16format); sheet.addCell(label);
        label = new Label(2, 12, obra?.codigo, times16format); sheet.addCell(label);
        label = new Label(1, 13, "Ubicación: ", times16format); sheet.addCell(label);
        label = new Label(2, 13, obra?.sitio, times16format); sheet.addCell(label);
        label = new Label(1, 14, "Fecha: ", times16format); sheet.addCell(label);
        label = new Label(2, 14, printFecha(obra?.fechaOficioSalida), times16format); sheet.addCell(label);
        label = new Label(1, 15, "Cantón: ", times16format); sheet.addCell(label);
        label = new Label(2, 15, obra?.parroquia?.canton?.nombre, times16format); sheet.addCell(label);
        label = new Label(1, 16, "Parroquia: ", times16format); sheet.addCell(label);
        label = new Label(2, 16, obra?.parroquia?.nombre, times16format); sheet.addCell(label);
        label = new Label(1, 17, "Coordenadas: ", times16format); sheet.addCell(label);
        label = new Label(2, 17, obra?.coordenadas, times16format); sheet.addCell(label);

        label = new Label(1, 19, "Los costos se reajustarán para efecto de pago, mediante la fórmula general: ", times16format);
        sheet.addCell(label);

        label = new Label(1, 21, "Pr = Po (p01B1/Bo + p02C1/Co + p03D1/Do + p04E1/Eo + p05F1/Fo + p06G1/Go + p07H1/Ho + p08I1/Io + p09J1/Jo + p10K1/Ko + pxX1/Xo) ", times16format);
        sheet.addCell(label);

        def textoFormula = "Pr=Po(";
        def txInicio = "Pr = Po (";
        def txFin = ")";
        def txSuma = " + "
        def txExtra = ""
        def tx = []
        def valores = []
        def formulaCompleta
        def valorP

        ps.each { j ->

            if (j.valor != 0.0 || j.valor != 0) {
                if (j.numero == 'p01') {
                    tx[0] = g.formatNumber(number: j.valor, maxFractionDigits: 3, minFractionDigits: 3) + "B1/Bo"
                    valores[0] = j
                }
                if (j.numero == 'p02') {
                    tx[1] = g.formatNumber(number: j.valor, maxFractionDigits: 3, minFractionDigits: 3) + "C1/Co"
                    valores[1] = j
                }
                if (j.numero == 'p03') {
                    tx[2] = g.formatNumber(number: j.valor, maxFractionDigits: 3, minFractionDigits: 3) + "D1/Do"
                    valores[2] = j
                }
                if (j.numero == 'p04') {
                    tx[3] = g.formatNumber(number: j.valor, maxFractionDigits: 3, minFractionDigits: 3) + "E1/Eo"
                    valores[3] = j
                }
                if (j.numero == 'p05') {
                    tx[4] = g.formatNumber(number: j.valor, maxFractionDigits: 3, minFractionDigits: 3) + "F1/Fo"
                    valores[4] = j
                }
                if (j.numero == 'p06') {
                    tx[5] = g.formatNumber(number: j.valor, maxFractionDigits: 3, minFractionDigits: 3) + "G1/Go"
                    valores[5] = j
                }
                if (j.numero == 'p07') {
//                    def p07valores =
                    tx[6] = g.formatNumber(number: j.valor, maxFractionDigits: 3, minFractionDigits: 3) + "H1/Ho"
                    valores[6] = j
                }
                if (j.numero == 'p08') {
                    tx[7] = g.formatNumber(number: j.valor, maxFractionDigits: 3, minFractionDigits: 3) + "I1/Io"
                    valores[7] = j
                }
                if (j.numero == 'p09') {
                    tx[8] = g.formatNumber(number: j.valor, maxFractionDigits: 3, minFractionDigits: 3) + "J1/Jo"
                    valores[8] = j
                }
                if (j.numero == 'p10') {

                    tx[9] = g.formatNumber(number: j.valor, maxFractionDigits: 3, minFractionDigits: 3) + "K1/Ko"
                    valores[9] = j
                }
                if (j.numero.trim() == 'px') {
                    tx[10] = g.formatNumber(number: j.valor, maxFractionDigits: 3, minFractionDigits: 3) + "X1/Xo"
                    valores[10] = j
                }
            }
        }

        def formulaStr = txInicio
        tx.eachWithIndex { linea, k ->
            if (linea) {
                formulaStr += linea
                if (k < tx.size() - 1)
                    formulaStr += " + "
            }
        }
        formulaStr += txFin
        label = new Label(1, 23, formulaStr, times16format); sheet.addCell(label);
        label = new Label(1, 24, " ", times16format); sheet.addCell(label);

        def valorTotal = 0
        def salto = 1

        valores.eachWithIndex { i, j ->

            if (i) {
                if (i.valor != 0.0 || i.valor != 0) {

                    label = new Label(1, 24 + salto, i.numero + "= " + g.formatNumber(number: i.valor, format: "##,##0", minFractionDigits: 3, maxFractionDigits: 3, locale: "ec") +
                            "    Coeficiente del Componente    " + i?.indice?.descripcion.toUpperCase(), times16format);
                    sheet.addCell(label);
                    valorTotal = i.valor + valorTotal
                    salto++
                }
            }
        }

        def salto2 = 24 + salto

        label = new Label(1, salto2, "___________________", times16format); sheet.addCell(label);
        label = new Label(1, salto2 + 1, "SUMAN : " + g.formatNumber(number: valorTotal, format: "##,##0", minFractionDigits: 3, maxFractionDigits: 3, locale: "ec"), times16format);
        sheet.addCell(label);

        label = new Label(1, salto2 + 3, "CUADRILLA TIPO", times16format); sheet.addCell(label);
        label = new Label(2, salto2 + 3, "CLASE OBRERO", times16format); sheet.addCell(label);

        def valorTotalCuadrilla = 0;
        def salto3 = salto2 + 5

        cuadrilla.eachWithIndex { i, s ->


            if (i.valor != 0.0 || i.valor != 0) {
                label = new Label(1, salto3, i?.numero + "  " + g.formatNumber(number: i?.valor, format: "##.####", locale: "ec"), times16format);
                sheet.addCell(label);
                label = new Label(2, salto3, i?.indice?.descripcion, times16format); sheet.addCell(label);
                valorTotalCuadrilla = i.valor + valorTotalCuadrilla
                salto3++
            } else {
            }
        }

        label = new Label(1, salto3 + 1, "___________________", times16format); sheet.addCell(label);
        label = new Label(1, salto3 + 2, "SUMAN : " + g.formatNumber(number: valorTotalCuadrilla, format: "##,##0", minFractionDigits: 3, maxFractionDigits: 3, locale: "ec"), times16format);
        sheet.addCell(label);

        label = new Label(1, salto3 + 4, nota, times16format); sheet.addCell(label);

        label = new Label(1, salto3 + 5, "NOTA : La presente Fórmula Polinómica se sujetará a lo establecido en la Ley de Contratación Pública", times16format); sheet.addCell(label);
        label = new Label(2, salto3 + 5,  "Índice So: " + printFechaMes(obra?.fechaOficioSalida), times16format); sheet.addCell(label);

        label = new Label(1, salto3 + 6, "Fecha de actualización", times16format); sheet.addCell(label);
        label = new Label(2, salto3 + 6, printFecha(obra?.fechaPreciosRubros), times16format); sheet.addCell(label);
//        sheet.addCell(label);

        label = new Label(1, salto3 + 7, "Monto del Contrato", times16format); sheet.addCell(label);
        label = new Label(2, salto3 + 7, "\$" + g.formatNumber(number: totalBase, minFractionDigits: 2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), times16format);
        sheet.addCell(label);

        label = new Label(1, salto3 + 8, "Atentamente,  ", times16format); sheet.addCell(label);

        label = new Label(1, salto3 + 13, "______________________________________", times16format);
        sheet.addCell(label);

        def firmaC

        if(params.firmaCoordinador != ''){
            def personaRol = PersonaRol.get(params.firmaCoordinador)
            firmaC = personaRol.persona

            label = new Label(1, salto3 + 14, firmaC?.titulo?.toUpperCase() ?: '' + " " + (firmaC?.nombre?.toUpperCase() ?: '' + " " + firmaC?.apellido?.toUpperCase() ?: ''), times16format);
            sheet.addCell(label);

        }else{
            label = new Label(1, salto3 + 14, "Coordinador no asignado", times16format);
            sheet.addCell(label);
        }

        workbook.write();
        workbook.close();
        def output = response.getOutputStream()
        def header = "attachment; filename=" + "FormulaPolinomicaExcel.xls";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        output.write(file.getBytes());
    }

    def imprimirCoeficientes() {

        def obra = Obra.get(params.id)

        def baos = new ByteArrayOutputStream()
        def name = "coeficientes_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";

        Font titleFont = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font titleFont3 = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font titleFont2 = new Font(Font.TIMES_ROMAN, 16, Font.BOLD);
        Font times8normal = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL);
        Font fontTh = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font fontTd = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL);

        Document document
        document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);

        HeaderFooter footer1 = new HeaderFooter(new Phrase(" ", times8normal), true);
        footer1.setBorder(Rectangle.NO_BORDER);
        footer1.setAlignment(Element.ALIGN_CENTER);

        document.setFooter(footer1);

        document.open();
        document.addTitle("Coeficientes " + new Date().format("dd_MM_yyyy"));
        document.addSubject("Generado por el sistema Janus");
        document.addKeywords("reporte, janus,coeficientes");
        document.addAuthor("Janus");
        document.addCreator("Tedein SA");

        Paragraph headersTitulo = new Paragraph();
        addEmptyLine(headersTitulo, 1)
        headersTitulo.setAlignment(Element.ALIGN_CENTER);
        headersTitulo.add(new Paragraph((Auxiliar.get(1)?.titulo ?: ''), titleFont2));
        addEmptyLine(headersTitulo, 1);
        headersTitulo.add(new Paragraph("COEFICIENTES DE LA FÓRMULA POLINÓMICA DE LA OBRA ${obra.nombre}", titleFont));
        addEmptyLine(headersTitulo, 1);
        addEmptyLine(headersTitulo, 1);

        document.add(headersTitulo)

        def sql = "SELECT distinct i.itemcdgo codigo, i.itemnmbr item, v.voitcoef aporte, v.voitpcun precio, " +
                "grpo__id::char(1) grupo FROM vlobitem v, item i, dprt, sbgr where v.item__id = i.item__id and " +
                "dprt.dprt__id = i.dprt__id and sbgr.sbgr__id = dprt.sbgr__id and grpo__id in (1,2) and " +
                "obra__id = ${params.id} ORDER BY grupo, i.itemnmbr;"

        println "sql: $sql"

        def tablaDatos = new PdfPTable(3);
        tablaDatos.setWidthPercentage(100);
        tablaDatos.setWidths(arregloEnteros([15, 77, 8]))

        addCellTabla(tablaDatos, new Paragraph("Item", fontTh), [border: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
        addCellTabla(tablaDatos, new Paragraph("Descripción", fontTh), [border: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
        addCellTabla(tablaDatos, new Paragraph("Aporte", fontTh), [border: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])

        def grupo = "null"

        def cn = dbConnectionService.getConnection()
        cn.eachRow(sql.toString()) { row ->
            if (row.grupo != grupo) {
                grupo = row.grupo
                addCellTabla(tablaDatos, new Paragraph((row.grupo == '1'? 'Materiales' : 'Mano de Obra'), fontTh), [border: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE, colspan: 3])
            }
            addCellTabla(tablaDatos, new Paragraph(row.codigo, fontTd), [border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
            addCellTabla(tablaDatos, new Paragraph(row.item, fontTd), [border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
            addCellTabla(tablaDatos, new Paragraph(numero(row.aporte, 5), fontTd), [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
        }

        document.add(tablaDatos)

        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def reporteCronogramaNuevoPdf() {
        def tipo = params.tipo
        def obra = null, contrato = null, lbl = ""
        switch (tipo) {
            case "obra":
                obra = Obra.get(params.id.toLong())
                lbl = " la obra"
                break;
            case "contrato":
                contrato = Contrato.get(params.id)
                obra = contrato.obra
                lbl = "l contrato de la obra"
                break;
        }

        def meses = obra.plazoEjecucionMeses + (obra.plazoEjecucionDias > 0 ? 1 : 0)
        def detalle = VolumenContrato.findAllByObra(obra, [sort: "volumenOrden"])

        def precios = [:]
        def indirecto = obra.totales / 100

        preciosService.ac_rbroObra(obra.id)

        detalle.each {
            it.refresh()
            def res = preciosService.precioUnitarioVolumenObraSinOrderBy("sum(parcial)+sum(parcial_t) precio ", obra.id, it.item.id)

            if(res["precio"][0] != null){
                precios.put(it.id.toString(), (res["precio"][0] + res["precio"][0] * indirecto).toDouble().round(2))
            }else{
                precios.put(it.id.toString(), (0 * indirecto).toDouble().round(2))
            }
        }

        def baos = new ByteArrayOutputStream()

        def name = "cronograma${tipo.capitalize()}_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";

        Font catFont2 = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font catFont3 = new Font(Font.TIMES_ROMAN, 16, Font.BOLD);
        Font info = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL)
        Font fontTh = new Font(Font.TIMES_ROMAN, 8, Font.BOLD);
        Font fontTd = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL);
        Font times8bold = new Font(Font.TIMES_ROMAN, 8, Font.BOLD);
        Font times10bold = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        def prmsHeaderHoja = [border: Color.WHITE]

        Document document
        document = new Document(PageSize.A4.rotate());
        def pdfw = PdfWriter.getInstance(document, baos);
        document.open();
        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Cronograma de${lbl} " + obra.nombre + " " + new Date().format("dd_MM_yyyy"));
        document.addSubject("Generado por el sistema Janus");
        document.addKeywords("reporte, janus, planillas");
        document.addAuthor("Janus");
        document.addCreator("Tedein SA");

        /* ***************************************************** Titulo del reporte *******************************************************/
        Paragraph preface = new Paragraph();
        addEmptyLine(preface, 1);
        preface.setAlignment(Element.ALIGN_CENTER);
        preface.add(new Paragraph((Auxiliar.get(1)?.titulo ?: ''), catFont3));
        preface.add(new Paragraph("CRONOGRAMA", catFont2));
        preface.add(new Paragraph("DCP - COORDINACIÓN DE RÉGIMEN DE FIJACIÓN DE COSTOS", catFont2));
        addEmptyLine(preface, 1);
        Paragraph preface2 = new Paragraph();
        document.add(preface);
        document.add(preface2);
        Paragraph pMeses = new Paragraph();
        pMeses.add(new Paragraph("Obra: ${obra.descripcion} (${meses} mes${meses == 1 ? '' : 'es'})", info))
        addEmptyLine(pMeses, 1);
        document.add(pMeses);

        Paragraph pRequirente = new Paragraph();
        pRequirente.add(new Paragraph("Requirente: ${obra?.departamento?.direccion?.nombre + ' - ' + obra.departamento?.descripcion}", info))
        document.add(pRequirente);

        Paragraph codigoObra = new Paragraph();
        codigoObra.add(new Paragraph("Código de la Obra: ${obra?.codigo}", info))
        document.add(codigoObra);

        Paragraph docReferencia = new Paragraph();
        docReferencia.add(new Paragraph("Doc. Referencia: ${obra?.oficioIngreso}", info))
        document.add(docReferencia);

        Paragraph fecha = new Paragraph();
        fecha.add(new Paragraph("Fecha: ${printFecha(obra?.fechaCreacionObra)}", info))
        document.add(fecha);

        Paragraph plazo = new Paragraph();
        plazo.add(new Paragraph("Plazo: ${obra?.plazoEjecucionMeses} Meses" + " ${obra?.plazoEjecucionDias} Días", info))
        document.add(plazo);

        Paragraph rutaCritica = new Paragraph();
        rutaCritica.add(new Paragraph("Los rubros pertenecientes a la ruta crítica están marcados con un * antes de su código.", info))
        addEmptyLine(rutaCritica, 1);
        document.add(rutaCritica);

        /* ***************************************************** Fin Titulo del reporte ***************************************************/
        /* ***************************************************** Tabla cronograma *********************************************************/
        def tams = [10, 40, 5, 6, 6, 6, 2]
        meses.times {
            tams.add(7)
        }
        tams.add(10)

        PdfPTable tabla = new PdfPTable(8 + meses);
        tabla.setWidthPercentage(100);
        tabla.setWidths(arregloEnteros(tams))
        tabla.setWidthPercentage(100);

        addCellTabla(tabla, new Paragraph("Código", fontTh), [border: Color.BLACK, bg: Color.LIGHT_GRAY, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
        addCellTabla(tabla, new Paragraph("Rubro", fontTh), [border: Color.BLACK, bg: Color.LIGHT_GRAY, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
        addCellTabla(tabla, new Paragraph("Unidad", fontTh), [border: Color.BLACK, bg: Color.LIGHT_GRAY, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
        addCellTabla(tabla, new Paragraph("Cantidad", fontTh), [border: Color.BLACK, bg: Color.LIGHT_GRAY, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
        addCellTabla(tabla, new Paragraph("P. Unitario", fontTh), [border: Color.BLACK, bg: Color.LIGHT_GRAY, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
        addCellTabla(tabla, new Paragraph("C. Total", fontTh), [border: Color.BLACK, bg: Color.LIGHT_GRAY, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
        addCellTabla(tabla, new Paragraph("T.", fontTh), [border: Color.BLACK, bg: Color.LIGHT_GRAY, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
        meses.times { i ->
            addCellTabla(tabla, new Paragraph("Mes " + (i + 1), fontTh), [border: Color.BLACK, bg: Color.LIGHT_GRAY, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
        }
        addCellTabla(tabla, new Paragraph("Total Rubro", fontTh), [border: Color.BLACK, bg: Color.LIGHT_GRAY, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])

        tabla.setHeaderRows(1)

        def totalMes = []
        def sum = 0
        def borderWidth = 2

        detalle.eachWithIndex { vol, s ->
            def cronos
            switch (tipo) {
                case "obra":
                    cronos = Cronograma.findAllByVolumenObra(VolumenesObra.findByItemAndOrdenAndObra(vol.item, vol.volumenOrden, vol.obra))
                    break;
                case "contrato":
                    cronos = CronogramaContratado.findAllByVolumenContrato(vol)
                    break;
            }

            def totalDolRow = 0, totalPrcRow = 0, totalCanRow = 0
            def parcial = Math.round(precios[vol.id.toString()] * vol.volumenCantidad*100)/100
            sum += parcial

            addCellTabla(tabla, new Paragraph((vol.rutaCritica == 'S' ? "* " : "") + vol.item.codigo, fontTd), [border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
            addCellTabla(tabla, new Paragraph(vol.item.nombre, fontTd), [border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
            addCellTabla(tabla, new Paragraph(vol.item.unidad.codigo, fontTd), [border: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
            addCellTabla(tabla, new Paragraph(numero(vol.volumenCantidad, 2), fontTd), [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
            addCellTabla(tabla, new Paragraph(numero(precios[vol.id.toString()], 2), fontTd), [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
            addCellTabla(tabla, new Paragraph(numero(parcial, 2), fontTd), [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
            addCellTabla(tabla, new Paragraph('$', fontTd), [border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
            meses.times { i ->
                def prec = cronos.find { it.periodo == i + 1 }
                totalDolRow += (prec ? prec.precio : 0)
                if (!totalMes[i]) {
                    totalMes[i] = 0
                }
                totalMes[i] += (prec ? prec.precio : 0)
                addCellTabla(tabla, new Paragraph(numero(prec?.precio, 2), fontTd), [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
            }
            addCellTabla(tabla, new Paragraph(numero(totalDolRow, 2) + ' $', fontTh), [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])

            addCellTabla(tabla, new Paragraph(' ', fontTd), [border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 6])
            addCellTabla(tabla, new Paragraph('%', fontTd), [border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
            meses.times { i ->
                def porc = cronos.find { it.periodo == i + 1 }
                totalPrcRow += (porc ? porc.porcentaje : 0)
                addCellTabla(tabla, new Paragraph(numero(porc?.porcentaje, 2), fontTd), [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
            }
            addCellTabla(tabla, new Paragraph(numero(totalPrcRow, 2) + ' %', fontTh), [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])

            addCellTabla(tabla, new Paragraph(' ', fontTd), [border: Color.BLACK, bwb: borderWidth, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 6])
            addCellTabla(tabla, new Paragraph('F', fontTd), [border: Color.BLACK, bwb: borderWidth, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE])
            meses.times { i ->
                def cant = cronos.find { it.periodo == i + 1 }
                totalCanRow += (cant ? cant.cantidad : 0)
                addCellTabla(tabla, new Paragraph(numero(cant?.cantidad, 2), fontTd), [border: Color.BLACK, bwb: borderWidth, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
            }
            addCellTabla(tabla, new Paragraph(numero(totalCanRow, 2) + ' F', fontTh), [border: Color.BLACK, bwb: borderWidth, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
        }

        addCellTabla(tabla, new Paragraph(" ", fontTh), [border: Color.BLACK, bg: Color.LIGHT_GRAY, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
        addCellTabla(tabla, new Paragraph("TOTAL PARCIAL", fontTh), [border: Color.BLACK, bg: Color.LIGHT_GRAY, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 4])
        addCellTabla(tabla, new Paragraph(numero(sum, 2), fontTh), [border: Color.BLACK, bg: Color.LIGHT_GRAY, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
        addCellTabla(tabla, new Paragraph("T", fontTh), [border: Color.BLACK, bg: Color.LIGHT_GRAY, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
        meses.times { i ->
            addCellTabla(tabla, new Paragraph(numero(totalMes[i], 2), fontTh), [border: Color.BLACK, bg: Color.LIGHT_GRAY, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
        }
        addCellTabla(tabla, new Paragraph(" ", fontTh), [border: Color.BLACK, bg: Color.LIGHT_GRAY, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])

        addCellTabla(tabla, new Paragraph(" ", fontTh), [border: Color.BLACK, bg: Color.LIGHT_GRAY, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
        addCellTabla(tabla, new Paragraph("TOTAL ACUMULADO", fontTh), [border: Color.BLACK, bg: Color.LIGHT_GRAY, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 4])
        addCellTabla(tabla, new Paragraph(" ", fontTh), [border: Color.BLACK, bg: Color.LIGHT_GRAY, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
        addCellTabla(tabla, new Paragraph("T", fontTh), [border: Color.BLACK, bg: Color.LIGHT_GRAY, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
        def acu = 0
        meses.times { i ->
            acu += totalMes[i]
            addCellTabla(tabla, new Paragraph(numero(acu, 2), fontTh), [border: Color.BLACK, bg: Color.LIGHT_GRAY, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
        }
        addCellTabla(tabla, new Paragraph(" ", fontTh), [border: Color.BLACK, bg: Color.LIGHT_GRAY, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])

        addCellTabla(tabla, new Paragraph(" ", fontTh), [border: Color.BLACK, bg: Color.LIGHT_GRAY, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
        addCellTabla(tabla, new Paragraph("% PARCIAL", fontTh), [border: Color.BLACK, bg: Color.LIGHT_GRAY, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 4])
        addCellTabla(tabla, new Paragraph(" ", fontTh), [border: Color.BLACK, bg: Color.LIGHT_GRAY, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
        addCellTabla(tabla, new Paragraph("T", fontTh), [border: Color.BLACK, bg: Color.LIGHT_GRAY, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
        meses.times { i ->
            def prc = 100 * totalMes[i] / sum
            addCellTabla(tabla, new Paragraph(numero(prc, 2), fontTh), [border: Color.BLACK, bg: Color.LIGHT_GRAY, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
        }
        addCellTabla(tabla, new Paragraph(" ", fontTh), [border: Color.BLACK, bg: Color.LIGHT_GRAY, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])

        addCellTabla(tabla, new Paragraph(" ", fontTh), [border: Color.BLACK, bg: Color.LIGHT_GRAY, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
        addCellTabla(tabla, new Paragraph("% ACUMULADO", fontTh), [border: Color.BLACK, bg: Color.LIGHT_GRAY, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 4])
        addCellTabla(tabla, new Paragraph(" ", fontTh), [border: Color.BLACK, bg: Color.LIGHT_GRAY, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
        addCellTabla(tabla, new Paragraph("T", fontTh), [border: Color.BLACK, bg: Color.LIGHT_GRAY, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
        acu = 0
        meses.times { i ->
            def prc = 100 * totalMes[i] / sum
            acu += prc
            addCellTabla(tabla, new Paragraph(numero(acu, 2), fontTh), [border: Color.BLACK, bg: Color.LIGHT_GRAY, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
        }
        addCellTabla(tabla, new Paragraph(" ", fontTh), [border: Color.BLACK, bg: Color.LIGHT_GRAY, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])

        document.add(tabla)
        /* ***************************************************** Fin Tabla cronograma *****************************************************/

        def personaElaboro
        def firmaCoordinador
        def ban = 0

        def deptoUsu = Persona.get(session.usuario.id).departamento

        def funcionCoor = Funcion.findByCodigo('O')
        def funcionElab = Funcion.findByCodigo('E')

        def personasDep = Persona.findAllByDepartamento(deptoUsu)
        def personasPRSP = Persona.findAllByDepartamento(Departamento.findByCodigo('CRFC'))

        def coordinador = PersonaRol.findByPersonaInListAndFuncion(personasDep,funcionCoor)
        def coordinadorPRSP = PersonaRol.findByPersonaInListAndFuncion(personasPRSP,funcionCoor)

        def elabPRSP = PersonaRol.findAllByPersonaInListAndFuncion(personasPRSP,funcionElab)

        def responsableRol = PersonaRol.findByPersona(Persona.get(obra?.responsableObra?.id))

        elabPRSP.each {
            if(it?.id == responsableRol?.id){
                ban = 1
            }
        }

        PdfPTable tablaFirmas = new PdfPTable(3);
        tablaFirmas.setWidthPercentage(100);

        addCellTabla(tablaFirmas, new Paragraph(" ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(" ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(" ", times10bold), prmsHeaderHoja)

        addCellTabla(tablaFirmas, new Paragraph(" ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(" ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(" ", times10bold), prmsHeaderHoja)

        addCellTabla(tablaFirmas, new Paragraph(" ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(" ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(" ", times10bold), prmsHeaderHoja)

        addCellTabla(tablaFirmas, new Paragraph("______________________________________", times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph("______________________________________", times8bold), prmsHeaderHoja)

        if(obra?.responsableObra){
            personaElaboro = Persona.get(obra?.responsableObra?.id)
            addCellTabla(tablaFirmas, new Paragraph((personaElaboro?.titulo?.toUpperCase() ?: '') + " " + (personaElaboro?.nombre.toUpperCase() ?: '' ) + " " + (personaElaboro?.apellido?.toUpperCase() ?: ''), times8bold), prmsHeaderHoja)
        }else{
            addCellTabla(tablaFirmas, new Paragraph(" ", times8bold), prmsHeaderHoja)
        }

        addCellTabla(tablaFirmas, new Paragraph("", times8bold), prmsHeaderHoja)

        if(coordinador){
            if(ban == 1){
                firmaCoordinador = coordinadorPRSP.persona
                addCellTabla(tablaFirmas, new Paragraph((firmaCoordinador?.titulo?.toUpperCase() ?: '') + " " + (firmaCoordinador?.nombre?.toUpperCase() ?: '') + " " + (firmaCoordinador?.apellido?.toUpperCase() ?: ''), times8bold), prmsHeaderHoja)
            }else{
                firmaCoordinador = coordinador.persona
                addCellTabla(tablaFirmas, new Paragraph((firmaCoordinador?.titulo?.toUpperCase() ?: '') + " " + (firmaCoordinador?.nombre?.toUpperCase() ?: '') + " " + (firmaCoordinador?.apellido?.toUpperCase() ?: ''), times8bold), prmsHeaderHoja)
            }

        }else{
            addCellTabla(tablaFirmas, new Paragraph("Coordinador no asignado", times8bold), prmsHeaderHoja)
        }
        //cargos

        addCellTabla(tablaFirmas, new Paragraph("ELABORÓ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph("COORDINADOR", times8bold), prmsHeaderHoja)

        addCellTabla(tablaFirmas, new Paragraph(personaElaboro?.departamento?.descripcion?.toUpperCase() ?: '', times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph((firmaCoordinador?.departamento?.descripcion?.toUpperCase() ?: ''), times8bold), prmsHeaderHoja)

        addCellTabla(tablaFirmas, new Paragraph(" ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(" ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(" ", times10bold), prmsHeaderHoja)

        document.add(tablaFirmas);

        document.close();

        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def reporteExistencias() {
        println("params " + params)

        def usuario = Persona.get(session.usuario.id)
        def empresa = usuario.empresa

        def sql = "select * from rp_existencias(${params.grupo.toInteger()}, ${params.bodega.toInteger()})"
        def cn = dbConnectionService.getConnection()
        def datos = cn.rows(sql)

        println("sql " + sql)

        def totales = 0

        def prmsHeaderHoja = [border: Color.WHITE]
        def prmsFila = [border: Color.WHITE, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsFilaIzquierda = [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsFilaDerecha = [border: Color.WHITE, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsHeaderHoja2 = [border: Color.WHITE, colspan: 9]
        def prmsHeader = [border: Color.WHITE, colspan: 7, bg: new Color(73, 175, 205),
                          align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsHeader2 = [border: Color.WHITE, colspan: 3, bg: new Color(73, 175, 205),
                           align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead = [border: Color.WHITE, bg: new Color(73, 175, 205),
                            align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellCenter = [border: Color.WHITE, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellRight = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsCellLeft = [border: Color.WHITE, valign: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsSubtotal = [border: Color.BLACK, colspan: 6,
                            align : Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsNum = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        def celdaCabecera = [border: Color.BLACK, bg: new Color(220, 220, 220), align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE, bordeBot: "1"]

        Font times12bold = new Font(Font.TIMES_ROMAN, 12, Font.BOLD)
        Font times14bold = new Font(Font.TIMES_ROMAN, 14, Font.BOLD)
        Font times10bold = new Font(Font.TIMES_ROMAN, 10, Font.BOLD)
        Font times10normal = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL)
        Font times8bold = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        Font times8normal = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL)
        Font times7bold = new Font(Font.TIMES_ROMAN, 7, Font.BOLD)
        Font times7normal = new Font(Font.TIMES_ROMAN, 7, Font.NORMAL)
        Font times10boldWhite = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8boldWhite = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)

        times8boldWhite.setColor(Color.WHITE)
        times10boldWhite.setColor(Color.WHITE)

        def fonts = [times12bold: times12bold, times10bold: times10bold, times8bold: times8bold,
                     times10boldWhite: times10boldWhite, times8boldWhite: times8boldWhite, times8normal: times8normal, times10normal: times10normal]

        def baos = new ByteArrayOutputStream()
        def name = "reporteExistencias_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        def logoPath = servletContext.getRealPath("/") + "images/logos/${empresa?.id}/logo_reportes.png"
        Image logo = Image.getInstance(logoPath);
        logo.scalePercent(70)
        logo.setAlignment(Image.MIDDLE | Image.TEXTWRAP)

        Document document
//        document = new Document(PageSize.A4.rotate());
        document = new Document(PageSize.A4);

        document.setMargins(40, 40, 20, 25);
        def pdfw = PdfWriter.getInstance(document, baos);
        document.open();
        document.addTitle("Existencias " + new Date().format("dd_MM_yyyy"));
        document.addSubject("Generado por el sistema Obras");
        document.addKeywords("documentosObra, obras, existencias");
        document.addAuthor("OBRAS");
        document.addCreator("Tedein SA");

        Paragraph headers = new Paragraph();
        headers.setAlignment(Element.ALIGN_CENTER);
        headers.add(new Paragraph(empresa?.nombre?.toUpperCase(), times12bold));
        headers.add(new Paragraph(" ", times10bold));
        headers.add(new Paragraph(empresa?.direccion, times10bold));
        headers.add(new Paragraph("Teléfono: " + (empresa?.telefono ? empresa?.telefono  : ''), times10bold));
        headers.add(new Paragraph("Email: " + (empresa?.email ? empresa?.email : ''), times10bold));
        headers.add(new Paragraph(" ", times10bold));
        headers.add(new Paragraph(empresa?.lugar + " -  Ecuador", times10bold));
        headers.add(new Paragraph(" ", times10bold));

        Paragraph headersRemi = new Paragraph();
        headersRemi.setAlignment(Element.ALIGN_CENTER);
        headersRemi.add(new Paragraph("EXISTENCIAS: " + (params.grupo == '1' ? 'MATERIALES' : (params.grupo == '2' ? 'MANO DE OBRA' : 'EQUIPOS')), times10bold));
        headersRemi.add(new Paragraph(" ", times10bold));

        //EXISTENCIAS
        PdfPTable tablaEquipos = new PdfPTable(7);
        tablaEquipos.setWidthPercentage(100);
        tablaEquipos.setWidths(arregloEnteros([15,37,8,10,10,10,10]))

        reportesPdfService.addCellTb(tablaEquipos, new Paragraph("CÓDIGO", times7bold), celdaCabecera)
        reportesPdfService.addCellTb(tablaEquipos, new Paragraph("ITEM", times7bold), celdaCabecera)
        reportesPdfService.addCellTb(tablaEquipos, new Paragraph("UNIDAD", times7bold), celdaCabecera)
        reportesPdfService.addCellTb(tablaEquipos, new Paragraph("FECHA", times7bold), celdaCabecera)
        reportesPdfService.addCellTb(tablaEquipos, new Paragraph("EXISTENCIAS", times7bold), celdaCabecera)
        reportesPdfService.addCellTb(tablaEquipos, new Paragraph("P. UNITARIO", times7bold), celdaCabecera)
        reportesPdfService.addCellTb(tablaEquipos, new Paragraph("VALOR", times7bold), celdaCabecera)

        datos.eachWithIndex { r, i ->
            reportesPdfService.addCellTb(tablaEquipos, new Paragraph(r?.itemcdgo, times8normal), prmsFilaIzquierda)
            reportesPdfService.addCellTb(tablaEquipos, new Paragraph(r?.itemnmbr, times8normal), prmsFilaIzquierda)
            reportesPdfService.addCellTb(tablaEquipos, new Paragraph(r?.unddcdgo, times8normal), prmsFila)
            reportesPdfService.addCellTb(tablaEquipos, new Paragraph(r?.krdxfcha?.format("dd-MM-yyyy"), times8normal), prmsFila)
            reportesPdfService.addCellTb(tablaEquipos, new Paragraph(numero(r?.exstcntd, 3)?.toString(), times8normal), prmsFilaDerecha)
            reportesPdfService.addCellTb(tablaEquipos, new Paragraph(numero(r?.exstpcun, 4)?.toString(), times8normal), prmsFilaDerecha)
            reportesPdfService.addCellTb(tablaEquipos, new Paragraph(numero(r?.exstvlor, 4)?.toString(), times8normal), prmsFilaDerecha)

            totales += (r?.exstvlor ?: 0)
        }

        PdfPTable tablaTotal = new PdfPTable(2);
        tablaTotal.setWidthPercentage(100);
        tablaTotal.setWidths(arregloEnteros([90, 10]))

        reportesPdfService.addCellTb(tablaTotal, new Paragraph("TOTAL", times10bold), prmsFilaDerecha)
        reportesPdfService.addCellTb(tablaTotal, new Paragraph(numero(totales, 4)?.toString(), times10bold), prmsFilaDerecha)

        PdfPTable tablaHeader = new PdfPTable(2);
        tablaHeader.setWidthPercentage(100);
        tablaHeader.setWidths(arregloEnteros([50, 50]))

        addCellTabla(tablaHeader, logo, prmsCellLeft)
        addCellTabla(tablaHeader, headers, prmsCellCenter)

        document.add(tablaHeader)
        document.add(headersRemi)
        document.add(tablaEquipos)
        document.add(tablaTotal)

        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def reporteExistenciasExcel() {

        def usuario = Persona.get(session.usuario.id)
        def empresa = usuario.empresa

        def sql = "select * from rp_existencias(${params.grupo.toInteger()}, ${params.bodega.toInteger()})"
        def cn = dbConnectionService.getConnection()
        def res = cn.rows(sql)

        def totales = 0

        //excel

        WorkbookSettings workbookSettings = new WorkbookSettings()
        workbookSettings.locale = Locale.default

        def file = File.createTempFile('myExcelDocument', '.xls')
        file.deleteOnExit()
        WritableWorkbook workbook = Workbook.createWorkbook(file, workbookSettings)

        WritableFont font = new WritableFont(WritableFont.ARIAL, 12)
        WritableCellFormat formatXls = new WritableCellFormat(font)

        def row = 0
        WritableSheet sheet = workbook.createSheet('MySheet', 0)

        WritableFont times16font = new WritableFont(WritableFont.TIMES, 11, WritableFont.BOLD, false);
        WritableCellFormat times16format = new WritableCellFormat(times16font);
        sheet.setColumnView(0, 20)
        sheet.setColumnView(1, 20)
        sheet.setColumnView(2, 20)
        sheet.setColumnView(3, 20)
        sheet.setColumnView(4, 15)
        sheet.setColumnView(5, 20)
        sheet.setColumnView(6, 45)
        sheet.setColumnView(7, 20)
        sheet.setColumnView(8, 20)
        sheet.setColumnView(9, 15)
        sheet.setColumnView(10, 15)
        sheet.setColumnView(11, 15)
        sheet.setColumnView(12, 15)
        sheet.setColumnView(13, 15)
        sheet.setColumnView(14, 15)
        sheet.setColumnView(15, 15)

        def label
        def number
        def fila = 12;

        //cabecera
        label = new Label(2, 2, (empresa?.nombre?.toUpperCase() ?: ''), times16format); sheet.addCell(label);
        label = new Label(2, 3, (empresa?.direccion ?: ''), times16format); sheet.addCell(label);
        label = new Label(2, 4, ("Teléfono: " + ( empresa?.telefono ?: '')), times16format); sheet.addCell(label);
        label = new Label(2, 5, ("Email: " + ( empresa?.email ?: '')), times16format); sheet.addCell(label);
        label = new Label(2, 6, (( empresa?.lugar ?: '') + " - Ecuador"), times16format); sheet.addCell(label);
        label = new Label(2, 7, (''), times16format); sheet.addCell(label);
        label = new Label(2, 8, "EXISTENCIAS: " + (params.grupo == '1' ? 'MATERIALES' : (params.grupo == '2' ? 'MANO DE OBRA' : 'EQUIPOS')), times16format); sheet.addCell(label);
        label = new Label(2, 9, "", times16format); sheet.addCell(label);

        //columnas
        label = new Label(0, 10, "CÓDIGO ", times16format); sheet.addCell(label);
        label = new Label(1, 10, "ITEM", times16format); sheet.addCell(label);
        label = new Label(2, 10, "UNIDAD", times16format); sheet.addCell(label);
        label = new Label(3, 10, "FECHA", times16format); sheet.addCell(label);
        label = new Label(4, 10, "EXISTENCIAS", times16format); sheet.addCell(label);
        label = new Label(5, 10, "P. UNITARIO", times16format); sheet.addCell(label);
        label = new Label(6, 10, "VALOR", times16format); sheet.addCell(label);

        res.each{ r->
            label = new Label(0, fila, r?.itemcdgo?.toString() ?: ''); sheet.addCell(label);
            label = new Label(1, fila, r?.itemnmbr?.toString() ?: ''); sheet.addCell(label);
            label = new Label(2, fila, r?.unddcdgo?.toString() ?: ''); sheet.addCell(label);
            label = new Label(3, fila, r?.krdxfcha?.format("dd-MM-yyyy")?.toString() ?: ''); sheet.addCell(label);
            number = new Number(4, fila, r?.exstcntd ?: 0); sheet.addCell(number);
            number = new Number(5, fila, r?.exstpcun ?: 0); sheet.addCell(number);
            number = new Number(6, fila,  r?.exstvlor?: 0); sheet.addCell(number);

            totales += (r?.exstvlor ?: 0)
            fila++
        }

        label = new Label(5, fila, "TOTALES", times16format); sheet.addCell(label);
        number = new Number(6, fila, totales ?: 0); sheet.addCell(number);

        workbook.write();
        workbook.close();
        def output = response.getOutputStream()
        def header = "attachment; filename=" + "existencias.xls";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        output.write(file.getBytes());
    }

    def reporteObrasFinalizadas(){

        def cn = dbConnectionService.getConnection()
        def campos = ['obracdgo', 'obranmbr', 'obradscr',
                      'obrasito', 'parrnmbr', 'cmndnmbr', 'diredscr']
        def sql = "select obracdgo, obranmbr, diredscr||' - '||dptodscr direccion, obrafcha, obrasito, parrnmbr, " +
                "cmndnmbr, obrafcin, obrafcfn from obra, dpto, dire, parr, cmnd " +
                "where dpto.dpto__id = obra.dpto__id and dire.dire__id = dpto.dire__id and " +
                "parr.parr__id = obra.parr__Id and cmnd.cmnd__id = obra.cmnd__id and " +
                "obrafcin is not null and " +
                "${campos[params.buscador.toInteger()]} ilike '%${params.criterio}%' " +
                "order by obrafcin desc"
        def obras = cn.rows(sql)

        def prmsCellHead2 = [border: Color.BLACK,
                             align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE, bordeTop: "1", bordeBot: "1"]
        def prmsCellRight = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE, bordeBot: "1"]
        def prmsCellLeft = [border: Color.BLACK, valign: Element.ALIGN_MIDDLE, bordeBot: "1"]
        def prmsCellCenter= [border: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE, bordeBot: "1"]

        def baos = new ByteArrayOutputStream()
        def name = "obrasFinalizadas_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        Font times12bold = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font times18bold = new Font(Font.TIMES_ROMAN, 18, Font.BOLD);
        Font times8bold = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        Font times8normal = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL)
        Font times7normal = new Font(Font.TIMES_ROMAN, 7, Font.NORMAL)
        Font times10boldWhite = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8boldWhite = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        times8boldWhite.setColor(Color.WHITE)
        times10boldWhite.setColor(Color.WHITE)

        Document document
        document = new Document(PageSize.A4.rotate());
        def pdfw = PdfWriter.getInstance(document, baos);
        document.open();

        document.addTitle("obrasFinalizadas_" + new Date().format("dd_MM_yyyy"));
        document.addSubject("Generado por el sistema Janus");
        document.addKeywords("documentosObra, janus, presupuesto");
        document.addAuthor("Janus");
        document.addCreator("Tedein SA");

        Paragraph headers = new Paragraph();
        addEmptyLine(headers, 1);
        headers.setAlignment(Element.ALIGN_CENTER);
        headers.add(new Paragraph((Auxiliar.get(1)?.titulo ?: ''), times18bold));
        addEmptyLine(headers, 1);
        headers.add(new Paragraph("REPORTE DE OBRAS FINALIZADAS", times12bold));
        addEmptyLine(headers, 1);
        headers.add(new Paragraph("AL " + printFecha(new Date()).toUpperCase(), times12bold));
        addEmptyLine(headers, 1);
        document.add(headers);

        PdfPTable tablaRegistradas = new PdfPTable(8);
        tablaRegistradas.setWidthPercentage(100);
        tablaRegistradas.setWidths(arregloEnteros([11, 25, 18, 7, 15, 12, 7, 7]))

        addCellTabla(tablaRegistradas, new Paragraph("Código", times8bold), prmsCellHead2)
        addCellTabla(tablaRegistradas, new Paragraph("Nombre", times8bold), prmsCellHead2)
        addCellTabla(tablaRegistradas, new Paragraph("Dirección", times8bold), prmsCellHead2)
        addCellTabla(tablaRegistradas, new Paragraph("Fecha Reg.", times8bold), prmsCellHead2)
        addCellTabla(tablaRegistradas, new Paragraph("Sitio", times8bold), prmsCellHead2)
        addCellTabla(tablaRegistradas, new Paragraph("Parroquia - Comunidad", times8bold), prmsCellHead2)
        addCellTabla(tablaRegistradas, new Paragraph("Fecha Inicio", times8bold), prmsCellHead2)
        addCellTabla(tablaRegistradas, new Paragraph("Fecha Fin", times8bold), prmsCellHead2)

        obras.eachWithIndex {i,j->
            addCellTabla(tablaRegistradas, new Paragraph(i.obracdgo, times8normal), prmsCellLeft)
            addCellTabla(tablaRegistradas, new Paragraph(i.obranmbr, times8normal), prmsCellLeft)
            addCellTabla(tablaRegistradas, new Paragraph(i.direccion, times7normal), prmsCellLeft)
            addCellTabla(tablaRegistradas, new Paragraph(i?.obrafcha?.format("dd-MM-yyyy"), times8normal), prmsCellCenter)
            addCellTabla(tablaRegistradas, new Paragraph(i.obrasito, times7normal), prmsCellLeft)
            addCellTabla(tablaRegistradas, new Paragraph(i.parrnmbr, times7normal), prmsCellLeft)
            addCellTabla(tablaRegistradas, new Paragraph(i?.obrafcin?.format("dd-MM-yyyy"), times8normal), prmsCellCenter)
            addCellTabla(tablaRegistradas, new Paragraph(i?.obrafcfn?.format("dd-MM-yyyy"), times8normal), prmsCellCenter)
        }

        document.add(tablaRegistradas);
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }


    def componentesObraPdf(){

        def cn = dbConnectionService.getConnection()

        def sql = "select grpodscr, item.itemcdgo, itemnmbr, unddcdgo, avg(voitpcun) pcun, sum(voitcntd) cntd, " +
                "count(distinct (obra.obra__id) ) cnta " +
                "from obra, vlobitem, item, undd, dprt, sbgr, grpo " +
                "where vlobitem.obra__id = obra.obra__id and item.item__id = vlobitem.item__id and " +
                "undd.undd__id = item.undd__id and dprt.dprt__id = item.dprt__id and sbgr.sbgr__id = dprt.sbgr__id and " +
                "grpo.grpo__id = sbgr.grpo__id " +
                "group by grpodscr, item.itemcdgo, itemnmbr, unddcdgo order by grpodscr, cnta desc"

        def componentes = cn.rows(sql)

        def prmsCellHead2 = [border: Color.BLACK,align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE, bordeTop: "1", bordeBot: "1"]
        def prmsCellHeadRight = [border: Color.BLACK,align : Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE, bordeTop: "1", bordeBot: "1"]
        def prmsCellHeadLeft = [border: Color.BLACK,align : Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, bordeTop: "1", bordeBot: "1"]
        def prmsCellRight = [border: Color.BLACK,align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT, bordeBot: "1"]
        def prmsCellLeft = [border: Color.BLACK, valign: Element.ALIGN_MIDDLE, bordeBot: "1"]
        def prmsCellCentro = [border: Color.BLACK,align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE, bordeBot: "1"]

        def baos = new ByteArrayOutputStream()
        def name = "componentesObra" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        Font times12bold = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font times18bold = new Font(Font.TIMES_ROMAN, 18, Font.BOLD);
        Font times8bold = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        Font times8normal = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL)
        Font times10boldWhite = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8boldWhite = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        times8boldWhite.setColor(Color.WHITE)
//        times10boldWhite.setColor(Color.WHITE)

        Document document
        document = new Document(PageSize.A4.rotate());
        def pdfw = PdfWriter.getInstance(document, baos);
        document.open();

        document.addTitle("Componentes obra " + new Date().format("dd_MM_yyyy"));
        document.addSubject("Generado por el sistema Janus");
        document.addKeywords("documentosObra, janus, presupuesto");
        document.addAuthor("Janus");
        document.addCreator("Tedein SA");

        Paragraph headers = new Paragraph();
        addEmptyLine(headers, 1);
        headers.setAlignment(Element.ALIGN_CENTER);
        headers.add(new Paragraph((Auxiliar.get(1)?.titulo ?: ''), times18bold));
        addEmptyLine(headers, 1);
        headers.add(new Paragraph("REPORTE DE COMPONENTES DE OBRA", times12bold));
        addEmptyLine(headers, 1);
        headers.add(new Paragraph("AL " + printFecha(new Date()).toUpperCase(), times12bold));
        addEmptyLine(headers, 1);
        document.add(headers);

        PdfPTable tablaRegistradas = new PdfPTable(7);
        tablaRegistradas.setWidthPercentage(100);
        tablaRegistradas.setWidths(arregloEnteros([10, 10, 45, 5, 5, 15, 10]))

        addCellTabla(tablaRegistradas, new Paragraph("Grupo", times10boldWhite), prmsCellHeadLeft)
        addCellTabla(tablaRegistradas, new Paragraph("Código", times10boldWhite), prmsCellHead2)
        addCellTabla(tablaRegistradas, new Paragraph("Item", times10boldWhite), prmsCellHead2)
        addCellTabla(tablaRegistradas, new Paragraph("Unidad", times10boldWhite), prmsCellHead2)
        addCellTabla(tablaRegistradas, new Paragraph("Precio", times10boldWhite), prmsCellHead2)
        addCellTabla(tablaRegistradas, new Paragraph("Cantidad", times10boldWhite), prmsCellHeadRight)
        addCellTabla(tablaRegistradas, new Paragraph("Presupuestos", times10boldWhite), prmsCellHeadRight)

        componentes.eachWithIndex {i,j->
            if(i?.pcun){
                addCellTabla(tablaRegistradas, new Paragraph(i.grpodscr, times8normal), prmsCellLeft)
                addCellTabla(tablaRegistradas, new Paragraph(i.itemcdgo, times8normal), prmsCellCentro)
                addCellTabla(tablaRegistradas, new Paragraph(i.itemnmbr, times8normal), prmsCellLeft)
                addCellTabla(tablaRegistradas, new Paragraph(i.unddcdgo, times8normal), prmsCellCentro)
                addCellTabla(tablaRegistradas, new Paragraph(numero(i.pcun, 2)?.toString(), times8normal), prmsCellRight)
                addCellTabla(tablaRegistradas, new Paragraph(numero(i.cntd, 2)?.toString(), times8normal), prmsCellRight)
                addCellTabla(tablaRegistradas, new Paragraph(numero(i.cnta, 0)?.toString(), times8normal), prmsCellRight)
            }
        }

        document.add(tablaRegistradas);
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def itemsNoUsadosPdf(){

        def cn = dbConnectionService.getConnection()

        def sql = "select grpodscr, item.itemcdgo, itemnmbr, unddcdgo from item, undd, dprt, sbgr, grpo where item.item__id not in (select item__id from vlobitem) and undd.undd__id = item.undd__id and tpit__id = 1 and " +
                "item.item__id not in (select item__id from rbro) and item.itemcdgo not in ('EQPO', 'REP', 'COMB', '009.001', '103.001.009') and dprt.dprt__id = item.dprt__id and sbgr.sbgr__id = dprt.sbgr__id and " +
                "grpo.grpo__id = sbgr.grpo__id group by grpodscr, item.itemcdgo, itemnmbr, unddcdgo order by 1;"

        def items = cn.rows(sql)

        def prmsCellHead2 = [border: Color.BLACK,align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE, bordeTop: "1", bordeBot: "1"]
        def prmsCellRight = [border: Color.BLACK,align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT, bordeBot: "1"]
        def prmsCellLeft = [border: Color.BLACK,valign: Element.ALIGN_MIDDLE, bordeBot: "1"]
        def prmsCellLeft2 = [border: Color.BLACK,align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE,  bordeTop: "1", bordeBot: "1"]
        def prmsCellCentro = [border: Color.BLACK,align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE, bordeBot: "1"]

        def baos = new ByteArrayOutputStream()
        def name = "itemsNoUsados" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        Font times12bold = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font times18bold = new Font(Font.TIMES_ROMAN, 18, Font.BOLD);
        Font times8bold = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        Font times8normal = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL)
        Font times10boldWhite = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8boldWhite = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        times8boldWhite.setColor(Color.WHITE)
        times10boldWhite.setColor(Color.WHITE)

        Document document
        document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);
        document.open();

        document.addTitle("Items no usados " + new Date().format("dd_MM_yyyy"));
        document.addSubject("Generado por el sistema Janus");
        document.addKeywords("documentosObra, janus, presupuesto");
        document.addAuthor("Janus");
        document.addCreator("Tedein SA");

        Paragraph headers = new Paragraph();
        addEmptyLine(headers, 1);
        headers.setAlignment(Element.ALIGN_CENTER);
        headers.add(new Paragraph((Auxiliar.get(1)?.titulo ?: ''), times18bold));
        addEmptyLine(headers, 1);
        headers.add(new Paragraph("REPORTE DE ITEMS NO USADOS", times12bold));
        addEmptyLine(headers, 1);
        headers.add(new Paragraph("AL " + printFecha(new Date()).toUpperCase(), times12bold));
        addEmptyLine(headers, 1);
        document.add(headers);

        PdfPTable tablaRegistradas = new PdfPTable(4);
        tablaRegistradas.setWidthPercentage(100);
        tablaRegistradas.setWidths(arregloEnteros([13, 10, 60, 7]))

        addCellTabla(tablaRegistradas, new Paragraph("Grupo", times8bold), prmsCellHead2)
        addCellTabla(tablaRegistradas, new Paragraph("Código", times8bold), prmsCellHead2)
        addCellTabla(tablaRegistradas, new Paragraph("Item", times8bold), prmsCellHead2)
        addCellTabla(tablaRegistradas, new Paragraph("Unidad", times8bold), prmsCellLeft2)

        items.eachWithIndex {i,j->
            addCellTabla(tablaRegistradas, new Paragraph(i.grpodscr, times8normal), prmsCellLeft)
            addCellTabla(tablaRegistradas, new Paragraph(i.itemcdgo, times8normal), prmsCellCentro)
            addCellTabla(tablaRegistradas, new Paragraph(i.itemnmbr, times8normal), prmsCellLeft)
            addCellTabla(tablaRegistradas, new Paragraph(i.unddcdgo, times8normal), prmsCellCentro)
        }

        document.add(tablaRegistradas);
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }


}