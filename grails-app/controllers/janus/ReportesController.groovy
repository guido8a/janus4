package janus

import com.lowagie.text.*
import com.lowagie.text.pdf.PdfPCell
import com.lowagie.text.pdf.PdfPTable
import com.lowagie.text.pdf.PdfWriter
import janus.ejecucion.Planilla
import janus.pac.Aseguradora
import janus.pac.Garantia
import jxl.Workbook
import jxl.WorkbookSettings
import jxl.write.*

import java.awt.*

import seguridad.Persona

class ReportesController {

    def index() {

    }

    def buscadorService
    def preciosService
    def dbConnectionService
    def diasLaborablesService
    def obraService

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

    def _garantiasContrato() {
//        println "reporte garantiasContrato $params"
        def auxiliar = Auxiliar.get(1)
        def contrato = Contrato.get(params.id)
        def garantias = Garantia.findAllByContrato(contrato)
        renderPdf(template:'/reportes/garantiasContrato', model: [contrato: contrato, garantias: garantias,auxiliar:auxiliar], filename: 'garantiasContrato.pdf')
    }

    def rubro = {
        return [algo: "algo"]
    }

    def imprimeMatriz() {

        def obra = Obra.get(params.id)
//
//        println "imprime matriz"
        def cn = buscadorService.dbConnectionService.getConnection()
        def cn2 = buscadorService.dbConnectionService.getConnection()
        def sql = "SELECT clmncdgo,clmndscr,clmntipo from mfcl where obra__id=${params.id} order by 1"
        def columnas = []
        def filas = []
        cn.eachRow(sql.toString()) { r ->
            def col = r[1]
            if (r[2] != "R") {
                def parts = col.split("_")
                //println "parts "+parts
                try {
                    col = parts[0].toLong()
                    col = Item.get(col).nombre

                } catch (e) {
                    col = parts[0]
                }

                col += parts[1]?.replaceAll("T", " Total")?.replaceAll("U", " Unitario")
            }

            columnas.add([r[0], col, r[2]])
        }
        sql = "SELECT * from mfrb where obra__id=${params.id} order by orden"
        def cont = 1
        cn.eachRow(sql.toString()) { r ->
            def tmp = [cont, r[0].trim(), r[2], r[3], r[4]]
            def sq = ""
            columnas.each { c ->
                if (c[2] != "R") {
                    sq = "select valor from mfvl where obra__id=${params.id} and clmncdgo=${c[0]} and codigo='${r[0].trim()}'"
                    cn2.eachRow(sq.toString()) { v ->
                        tmp.add(v[0])
                    }
                }
            }
            filas.add(tmp)
            cont++
        }

        def baos = new ByteArrayOutputStream()
        def name = "matriz_polinomica_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
//            println "name "+name
        Font titleFont = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font titleFont3 = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font titleFont2 = new Font(Font.TIMES_ROMAN, 16, Font.BOLD);
        Font times8bold = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        Font times8normal = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL);
        Font catFont = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font info = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL)

        def prmsHeaderHoja = [border: Color.WHITE]

        Document document
        document = new Document(PageSize.A3.rotate());
        def pdfw = PdfWriter.getInstance(document, baos);


        HeaderFooter footer1 = new HeaderFooter(new Phrase(" ", times8normal), true);
        // true aqui pone numero de pagina
        footer1.setBorder(Rectangle.NO_BORDER);
//        footer1.setBorder(Rectangle.TOP);
        footer1.setAlignment(Element.ALIGN_CENTER);

        document.setFooter(footer1);

        document.open();
        document.addTitle("Matriz Polinómica " + new Date().format("dd_MM_yyyy"));
        document.addSubject("Generado por el sistema Janus");
        document.addKeywords("reporte, janus,matriz");
        document.addAuthor("Janus");
        document.addCreator("Tedein SA");
        Font small = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL);

        def titulo = obra.desgloseTransporte == "S" ? '(Con desglose de Transporte)' : '(Sin desglose de Transporte)'
//        println titulo
        Paragraph headersTitulo = new Paragraph();
        addEmptyLine(headersTitulo, 1)
        headersTitulo.setAlignment(Element.ALIGN_CENTER);
//        headersTitulo.add(new Paragraph((Auxiliar.get(1)?.titulo ?: ''), titleFont2));
        headersTitulo.add(new Paragraph((Auxiliar.get(1)?.titulo ?: ''), titleFont2));
        addEmptyLine(headersTitulo, 1);
        headersTitulo.add(new Paragraph(obra?.departamento?.direccion?.nombre, titleFont));
        addEmptyLine(headersTitulo, 1);
        headersTitulo.add(new Paragraph("MATRIZ DE LA FORMULA POLINÓMICA " + titulo, titleFont));
        addEmptyLine(headersTitulo, 1);

        document.add(headersTitulo)

        PdfPTable tablaHeader = new PdfPTable(3);
        tablaHeader.setWidthPercentage(100);
        tablaHeader.setWidths(arregloEnteros([15, 2, 70]))

        addCellTabla(tablaHeader, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaHeader, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaHeader, new Paragraph(" ", times8bold), prmsHeaderHoja)


        addCellTabla(tablaHeader, new Paragraph("OBRA", times8bold), prmsHeaderHoja)
        addCellTabla(tablaHeader, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaHeader, new Paragraph(obra?.nombre, times8normal), prmsHeaderHoja)

        addCellTabla(tablaHeader, new Paragraph("CÓDIGO", times8bold), prmsHeaderHoja)
        addCellTabla(tablaHeader, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaHeader, new Paragraph(obra?.codigo, times8normal), prmsHeaderHoja)

        addCellTabla(tablaHeader, new Paragraph("MEMO CANT. OBRA", times8bold), prmsHeaderHoja)
        addCellTabla(tablaHeader, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaHeader, new Paragraph(obra?.memoCantidadObra, times8normal), prmsHeaderHoja)

        addCellTabla(tablaHeader, new Paragraph("DOC. REFERENCIA", times8bold), prmsHeaderHoja)
        addCellTabla(tablaHeader, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaHeader, new Paragraph(obra?.oficioIngreso, times8normal), prmsHeaderHoja)

        addCellTabla(tablaHeader, new Paragraph("FECHA", times8bold), prmsHeaderHoja)
        addCellTabla(tablaHeader, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaHeader, new Paragraph(printFecha(obra?.fechaCreacionObra).toUpperCase(), times8normal), prmsHeaderHoja)

        addCellTabla(tablaHeader, new Paragraph("FECHA ACT. PRECIOS", times8bold), prmsHeaderHoja)
        addCellTabla(tablaHeader, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaHeader, new Paragraph(printFecha(obra?.fechaPreciosRubros).toUpperCase(), times8normal), prmsHeaderHoja)

        addCellTabla(tablaHeader, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaHeader, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaHeader, new Paragraph(" ", times8bold), prmsHeaderHoja)

        document.add(tablaHeader);

        /*table*/

        def parcial = []
        def anchos = [4, 5, 15, 4, 6, 6, 6, 6, 6,6,6,6,6,6,6,6]     // , 9
        def anchos2 = [4, 5, 15, 4, 6, 6, 6, 6, 6,6,6,6,6,6,6,6]     // , 9

        def inicio = 0
        def fin = 16

        def inicioCab = 0
        def finCab = 16

//        println "size "+columnas.size()
        while (fin <= columnas.size() + 1) {  //gdo  <= antes

//            println "inicio "+inicio+"  fin  "+fin
//            println "iniciocab "+inicioCab+"  fincab  "+finCab
            if (inicio != 0) {
                anchos = [ 6, 6, 6, 6, 6,6,6,6,6,6,6,6,7,7,7,7]
                anchos2 = [6, 6, 6, 6, 6,6,6,6,6,6,6,6,7,7,7,7]
            }

            if (fin - inicio < 16) {
                anchos = []
                (fin - inicio).toInteger().times { i ->
                    anchos.add((100 / (fin - inicio)).toInteger())
                }

                anchos2 = []
                ((fin - inicio).toInteger() ).times { i ->
                    anchos2.add((100 / (((fin - inicio).toInteger()) - 1)).toInteger())
                }

            }
            def parrafo = new Paragraph("")

            PdfPTable table = new PdfPTable((fin - inicio).toInteger());       //gdo
//            println("-->>" + (fin-inicio))

            PdfPTable table2 = new PdfPTable(((finCab - inicioCab).toInteger()));
//            println "inicio "+inicioCab+"  fin "+finCab+"   "+anchos2.size()+"  "+arregloEnteros(anchos2) +" i1 "+inicio+" f1 "+fin
            def tam = 100
            if(anchos.size()<16)
                tam=(anchos.size()*100/16).toInteger()
            table.setWidthPercentage(tam);
            table.setWidths(arregloEnteros(anchos))
            table.setHorizontalAlignment(Element.ALIGN_LEFT);
            table2.setWidthPercentage(tam);
            table2.setWidths(arregloEnteros(anchos2))
            table2.setHorizontalAlignment(Element.ALIGN_LEFT);

            if (inicio == 0) {
                (finCab - inicioCab).toInteger().times { i ->

                    PdfPCell c0 = new PdfPCell(new Phrase(columnas[(inicioCab + i) - 1][1], small));
                    c0.setHorizontalAlignment(Element.ALIGN_CENTER);
                    table2.addCell(c0);
                }
                table2.setHeaderRows(1);
                filas.each { f ->
                    (finCab - inicioCab).toInteger().times { i ->

                        def fuente = small
                        def borde = 1.5
                        if (f[1]=~"sS") {
                            fuente = new Font(Font.TIMES_ROMAN, 8, Font.BOLD);
                        }

                        def dato = f[(inicio + i)]
                        if (!dato)
                            dato = "0.00"
                        else
                            dato = dato.toString()
                        def cell = new PdfPCell(new Phrase(dato, fuente));
                        cell.setFixedHeight(16f);
                        if (f[1] == "sS1")
                            cell.setBorderWidthTop(borde)
                        if (f[1] == "sS2")
                            cell.setBorderWidthBottom(borde)
                        table2.addCell(cell);
                    }
                }

            } else {
                (finCab - inicioCab).toInteger().times { i ->
//                println "columnas "+columnas[(inicioCab + i)-1][1]
                    PdfPCell c1 = new PdfPCell(new Phrase(columnas[(inicioCab + i) - 1][1], small));
                    c1.setHorizontalAlignment(Element.ALIGN_CENTER);
                    table.addCell(c1);
                }
                table.setHeaderRows(1);
                filas.each { f ->
//                    println "f "+f[1]
                    def fuente = small
                    def borde = 1.5
                    if (f[1]=~"sS") {
                        fuente = new Font(Font.TIMES_ROMAN, 8, Font.BOLD);
                    }
                    if (f[1] == "sS1" || f[1] == "sS2")
                        borde = 1.5
                    (fin - inicio).toInteger().times { i ->

                        def dato = f[(inicio + i) - 1]
                        if (!dato)
                            dato = "0.00"
                        else
                            dato = dato.toString()
                        def cell = new PdfPCell(new Phrase(dato, fuente));
                        cell.setFixedHeight(16f);
                        if (f[1] == "sS1")
                            cell.setBorderWidthTop(borde)
                        if (f[1] == "sS2")
                            cell.setBorderWidthBottom(borde)
                        table.addCell(cell);
                    }
                }
            }

            parrafo.add(table2)
            parrafo.add(table);
            document.add(parrafo);
            document.newPage();
//            inicio = fin + 1
            inicio = fin
            fin = inicio + 16

            inicioCab = finCab
            finCab = inicioCab + 16

            if (fin > columnas.size() + 1) {
                fin = columnas.size() + 1
            }
            if (finCab > columnas.size() + 1) {
                finCab = columnas.size() + 1
            }
            if (inicio > columnas.size())
                break;
        }

        /*table*/

        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }


    def reporteBuscadorExcel() {
//        println "reporte buscador excel "+params
        def listaTitulos = params.listaTitulos
        def listaCampos = params.listaCampos
        def lista = buscadorService.buscar(session.dominio, params.tabla, "excluyente", params, true, params.extras)
        def funciones = session.funciones
        session.dominio = null
        session.funciones = null
        lista.pop()
        def baos = new ByteArrayOutputStream()
        def name = "reporte_de_" + params.titulo.replaceAll(" ", "_") + "_" + new Date().format("ddMMyyyy_hhmm") + "";
        WorkbookSettings workbookSettings = new WorkbookSettings()
        workbookSettings.locale = Locale.default
        def file = File.createTempFile(name, '.xls')
        file.deleteOnExit()
        WritableWorkbook workbook = Workbook.createWorkbook(file, workbookSettings)
        WritableFont times16font = new WritableFont(WritableFont.TIMES, 11, WritableFont.BOLD, false);
        WritableCellFormat times16format = new WritableCellFormat(times16font);
        WritableFont times10Font = new WritableFont(WritableFont.TIMES, 10, WritableFont.NO_BOLD, false);
        WritableCellFormat times10 = new WritableCellFormat(times10Font);
        WritableFont times10FontB = new WritableFont(WritableFont.TIMES, 10, WritableFont.BOLD, false);
        WritableCellFormat times10b = new WritableCellFormat(times10FontB);
        def fila = 4

        WritableSheet sheet = workbook.createSheet("Reporte", 0)
        params.anchos.eachWithIndex { p, i ->
            sheet.setColumnView(i, p.toInteger())
        }

        def persona1 = Persona.get(session.usuario.id)

        def label = new Label(0, 1, "Reporte de " + params.titulo.toUpperCase(), times16format); sheet.addCell(label);
//        label = new Label(0, 2, "Generado por el usuario: " + session.usuario + "   el: " + new Date().format("dd/MM/yyyy hh:mm"), times16format);
        label = new Label(0, 2, "Generado por el usuario: " + (persona1?.titulo ?: '') + ' ' + (persona1?.nombre ?: '') + ' ' + (persona1?.apellido ?: '') + "   el: " + new Date().format("dd/MM/yyyy hh:mm"), times16format);
        sheet.addCell(label);
        listaTitulos.eachWithIndex { h, i ->
            //write cell
            label = new Label(i, 4, "" + h, times10b); sheet.addCell(label);
//            fila++
        }
        fila++

//        def tagLib = new BuscadorTagLib()
        lista.each { d ->
            listaCampos.eachWithIndex { c, j ->
                def campo
                if (funciones) {
//                    if (funciones[j])
//                        campo = tagLib.operacion([propiedad: c, funcion: funciones[j], registro: d]).toString()
//                    else
                    campo = d.properties[c].toString()
                } else {
                    campo = d.properties[c].toString()
                }
                if (campo == "null" || campo == null)
                    campo = ""
                label = new Label(j, fila, "" + campo, times10); sheet.addCell(label);
//write cell
            }
            fila++
        }

        workbook.write();
        workbook.close();
        def output = response.getOutputStream()
        def header = "attachment; filename=" + "" + name + ".xls";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        output.write(file.getBytes());

    }

    def reporteBuscador = {

//        println "reporte buscador params !! "+params
        if (!session.dominio)
            response.sendError(403)
        else {
            def listaTitulos = params.listaTitulos
            def listaCampos = params.listaCampos
            def lista = buscadorService.buscar(session.dominio, params.tabla, "excluyente", params, true, params.extras)
            def funciones = session.funciones
            session.dominio = null
            session.funciones = null
            lista.pop()

            def baos = new ByteArrayOutputStream()
            def name = "reporte_de_" + params.titulo.replaceAll(" ", "_") + "_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
//            println "name "+name
            Font catFont = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
            Font info = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL);
            Font times12bold = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
            Font times18bold = new Font(Font.TIMES_ROMAN, 18, Font.BOLD);
            Font times10bold = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
            Font times8bold = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
            Font times8normal = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL)
            Font times10boldWhite = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
            Font times8boldWhite = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
            Document document
            if (params.landscape)
                document = new Document(PageSize.A4.rotate());
            else
                document = new Document();

            def pdfw = PdfWriter.getInstance(document, baos);

            document.open();
            document.addTitle("Reporte de " + params.titulo + " " + new Date().format("dd_MM_yyyy"));
            document.addSubject("Generado por el sistema Janus");
            document.addKeywords("reporte, elyon," + params.titulo);
            document.addAuthor("Janus");
            document.addCreator("Tedein SA");
//            Paragraph preface = new Paragraph();
//            addEmptyLine(headers, 1);
//            preface.add(new Paragraph("SEP - G.A.D. PROVINCIA DE PICHINCHA", catFont));
            Paragraph headers = new Paragraph();
            addEmptyLine(headers, 1);
            headers.setAlignment(Element.ALIGN_CENTER);
            headers.add(new Paragraph((Auxiliar.get(1)?.titulo ?: ''), times18bold));
            addEmptyLine(headers, 1);
            headers.add(new Paragraph("" + params.titulo, times12bold));
            addEmptyLine(headers, 1);
            headers.add(new Paragraph("Quito, al " + printFecha(new Date()).toUpperCase(), times12bold));
            addEmptyLine(headers, 1);

            document.add(headers);
//        Start a new page
//        document.newPage();
            //System.getProperty("user.name")
            addContent(document, catFont, listaCampos.size(), listaTitulos, params.anchos, listaCampos, funciones, lista);
            // Los tamaños son porcentajes!!!!
            document.close();
            pdfw.close()
            byte[] b = baos.toByteArray();
            response.setContentType("application/pdf")
            response.setHeader("Content-disposition", "attachment; filename=" + name)
            response.setContentLength(b.length)
            response.getOutputStream().write(b)
        }
    }

    def reporteBuscador2 = {

        // println "reporte buscador params !! "+params
        if (!session.dominio)
            response.sendError(403)
        else {
            def listaTitulos = params.listaTitulos
            def listaCampos = params.listaCampos
            def lista = buscadorService.buscar(session.dominio, params.tabla, "excluyente", params, true, params.extras)
            def funciones = session.funciones
            session.dominio = null
            session.funciones = null
            lista.pop()

            def baos = new ByteArrayOutputStream()
            def name = "reporte_de_" + params.titulo.replaceAll(" ", "_") + "_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
//            println "name "+name
            Font catFont = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
            Font info = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL);
            Document document
            if (params.landscape)
                document = new Document(PageSize.A4.rotate());
            else
                document = new Document();

            def pdfw = PdfWriter.getInstance(document, baos);

            document.open();
            document.addTitle("Reporte de " + params.titulo + " " + new Date().format("dd_MM_yyyy"));
            document.addSubject("Generado por el sistema Janus");
            document.addKeywords("reporte, elyon," + params.titulo);
            document.addAuthor("Janus");
            document.addCreator("Tedein SA");
            Paragraph preface = new Paragraph();
            addEmptyLine(preface, 1);


            preface.add(new Paragraph((Auxiliar.get(1)?.titulo ?: ''), catFont));
            addEmptyLine(preface, 1);
            preface.add(new Paragraph("REPORTE DE OBRAS REGISTRADAS", catFont));
            addEmptyLine(preface, 1);
            preface.add(new Paragraph("Quito, " + printFecha(new Date()).toUpperCase(), catFont));
            addEmptyLine(preface, 1);

            addContent(document, catFont, listaCampos.size(), listaTitulos, params.anchos, listaCampos, funciones, lista);
            // Los tamaños son porcentajes!!!!
            document.close();
            pdfw.close()
            byte[] b = baos.toByteArray();
            response.setContentType("application/pdf")
            response.setHeader("Content-disposition", "attachment; filename=" + name)
            response.setContentLength(b.length)
            response.getOutputStream().write(b)
        }
    }

    def _pac() {
//        println "params REPORTE " + params
        def pac
        def dep
        def anio
        if (!params.todos) {
            anio = janus.pac.Anio.get(params.anio)
            if (params.dpto) {
                dep = Departamento.get(params.dpto)
                pac = janus.pac.Pac.findAllByDepartamentoAndAnio(dep, anio, [sort: "id"])
                dep = dep.descripcion
                anio = anio.anio
            } else {
                pac = janus.pac.Pac.findAllByAnio(janus.pac.Anio.get(params.anio), [sort: "id"])
                dep = "Todos"
                anio = anio.anio
            }
        } else {
            dep = "Todos"
            anio = "Todos"
            pac = janus.pac.Pac.list([sort: "id"])
        }
        renderPdf(template:'/reportes/pac', model: [pac: pac, todos: params.todos, dep: dep, anio: anio], filename: 'pac.pdf')
    }

    def analisisPrecios() {

    }

    private static void addEmptyLine(Paragraph paragraph, int number) {
        for (int i = 0; i < number; i++) {
            paragraph.add(new Paragraph(" "));
        }
    }

    private
    static void addContent(Document document, catFont, columnas, headers, anchos, campos, funciones, datos) throws DocumentException {
        Font small = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL);
        def parrafo = new Paragraph("")
        createTable(parrafo, columnas, headers, anchos, campos, funciones, datos);
        document.add(parrafo);
    }

    private
    static void createTable(Paragraph subCatPart, columnas, headers, anchos, campos, funciones, datos) throws BadElementException {
        PdfPTable table = new PdfPTable(columnas);
        table.setWidthPercentage(100);
        table.setWidths(arregloEnteros(anchos))
        Font small = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL);
        headers.eachWithIndex { h, i ->
            PdfPCell c1 = new PdfPCell(new Phrase(h, small));
            c1.setHorizontalAlignment(Element.ALIGN_CENTER);
            table.addCell(c1);
        }
        table.setHeaderRows(1);

        datos.each { d ->
            campos.eachWithIndex { c, j ->
                def campo
                if (funciones) {
                    campo = d.properties[c].toString()
                } else {
                    campo = d.properties[c].toString()
                }
                table.addCell(new Phrase(campo, small));
            }
        }
        subCatPart.add(table);
    }

    private static void createList(Section subCatPart) {
        List list = new List(true, false, 10);
        list.add(new ListItem("First point"));
        list.add(new ListItem("Second point"));
        list.add(new ListItem("Third point"));
        subCatPart.add(list);
    }

    static arregloEnteros(array) {
        int[] ia = new int[array.size()]
        array.eachWithIndex { it, i ->
            ia[i] = it.toInteger()
        }
        return ia
    }

    def reporteSubgrupos() {

        def obra = Obra.get(params.id)

        def sql = "SELECT\n" +
                "dprtdscr          descripcion,\n" +
                "itemnmbr          nombre,\n" +
                "vlobcntd          cantidad,\n" +
                "sbprdscr          subpresupuesto,\n" +
                "grpodscr          grupo,\n" +
                "sbgrdscr          subgrupo\n" +
                "FROM vlob,item,dprt,sbpr,grpo,sbgr\n" +
                "where item.item__id=vlob.item__id AND\n" +
                "dprt.dprt__id=item.dprt__id AND\n" +
                "sbpr.sbpr__id=vlob.sbpr__id AND\n" +
                "sbgr.sbgr__id=dprt.sbgr__id AND\n" +
                "grpo.grpo__id=sbgr.grpo__id AND\n" +
                "obra__id= ${params.id}\n" +
                "order by sbprdscr,grpodscr,sbgrdscr,dprtdscr,itemnmbr"

        def cn = dbConnectionService.getConnection()
        def res = cn.rows(sql.toString())

        def baos = new ByteArrayOutputStream()
        def name = "subgrupos_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        Font times12bold = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font times14bold = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font times10bold = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8bold = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        Font times8normal = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL)
        Font times10boldWhite = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8boldWhite = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        times8boldWhite.setColor(Color.BLACK)
        times10boldWhite.setColor(Color.BLACK)
        def fonts = [times12bold: times12bold, times10bold: times10bold, times8bold: times8bold,
                     times10boldWhite: times10boldWhite, times8boldWhite: times8boldWhite, times8normal: times8normal]

        Document document
        document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);
        document.open();
        document.addTitle("Subgrupos " + new Date().format("dd_MM_yyyy"));
        document.addSubject("Generado por el sistema Janus");
        document.addKeywords("reporte, janus, rubros");
        document.addAuthor("Janus");
        document.addCreator("Tedein SA");

        def prmsHeaderHoja = [border: Color.WHITE]
        def prmsHeader = [border: Color.WHITE, colspan: 7,
                          align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsHeader2 = [border: Color.WHITE, colspan: 3,
                           align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead = [border: Color.WHITE,
                            align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellIzquierda = [border: Color.WHITE,
                                 align : Element.ALIGN_LEFT, valign: Element.ALIGN_LEFT]
        def prmsCellCenter = [border: Color.WHITE, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellLeft = [border: Color.WHITE, valign: Element.ALIGN_MIDDLE]
        def prmsSubtotal = [border: Color.WHITE, colspan: 6,
                            align : Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsNum = [border: Color.WHITE, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        def prms = [prmsHeaderHoja: prmsHeaderHoja, prmsHeader: prmsHeader, prmsHeader2: prmsHeader2,
                    prmsCellHead: prmsCellHead, prmsCell: prmsCellCenter, prmsCellLeft: prmsCellLeft, prmsSubtotal: prmsSubtotal, prmsNum: prmsNum]

        Paragraph headers = new Paragraph();
        addEmptyLine(headers, 1);
        headers.setAlignment(Element.ALIGN_CENTER);
        headers.add(new Paragraph((Auxiliar.get(1)?.titulo ?: ''), times14bold));
        headers.add(new Paragraph(" ", times14bold));
        headers.add(new Paragraph("REPORTE GRUPOS Y SUBGRUPOS", times12bold));
        headers.add(new Paragraph("OBRA: " + obra?.nombre, times12bold));
        headers.add(new Paragraph("FECHA: " + printFecha(obra?.fechaCreacionObra), times12bold));

        addEmptyLine(headers, 1);
        document.add(headers);

        PdfPTable table = new PdfPTable(6);
        table.setWidthPercentage(100);
        table.setWidths(arregloEnteros([16, 15, 15, 20, 25, 9]))

        addCellTabla(table, new Paragraph("Subpresupuesto", times10boldWhite), prmsCellHead)
        addCellTabla(table, new Paragraph("Solicitante", times10boldWhite), prmsCellHead)
        addCellTabla(table, new Paragraph("Grupo", times10boldWhite), prmsCellHead)
        addCellTabla(table, new Paragraph("Subgrupo", times10boldWhite), prmsCellHead)
        addCellTabla(table, new Paragraph("Item", times10boldWhite), prmsCellHead)
        addCellTabla(table, new Paragraph("Cantidad", times10boldWhite), prmsCellHead)

        res.each { r ->
            addCellTabla(table, new Paragraph(r?.subpresupuesto, times8normal), prmsCellIzquierda)
            addCellTabla(table, new Paragraph(r?.grupo, times8normal), prmsCellIzquierda)
            addCellTabla(table, new Paragraph(r?.subgrupo, times8normal), prmsCellIzquierda)
            addCellTabla(table, new Paragraph(r?.descripcion, times8normal), prmsCellIzquierda)
            addCellTabla(table, new Paragraph(r?.nombre, times8normal), prmsCellIzquierda)
            addCellTabla(table, new Paragraph(g.formatNumber(number: r?.cantidad, minFractionDigits: 3, maxFractionDigits: 3, format: "##,###0", locale: "ec"), times8normal), prmsNum)
        }

        document.add(table);
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def imprimirRubros() {
        println "imprimirRubros... $params"
        def obra = Obra.get(params.obra)
        def fecha1
        def fecha2

        if (obra?.fechaPreciosRubros) {
            fecha1 = obra?.fechaPreciosRubros
        } else {

        }

        if (obra?.fechaOficioSalida) {
            fecha2 = obra?.fechaOficioSalida
        } else {
        }

        def rubros = []
        def lugar = obra?.lugar
        def indi = obra?.totales

        try {
            indi = indi.toDouble()
        } catch (e) {
            println "error parse " + e
            indi = 21.5
        }

        if(obra.estado != 'R') {
            println "antes de imprimir rubros.. actualiza desalojo y herramienta menor"
            preciosService.ac_transporteDesalojo(obra.id)
            preciosService.ac_rbroObra(obra.id)
        }

        def html = ""

        rubros = VolumenesObra.findAllByObra(obra, [sort: "orden"]).item.unique()


        rubros.eachWithIndex {rubro, indice ->
            def nombre = rubro.nombre.decodeHTML()
            nombre = nombre.replaceAll(/</, /&lt;/)
            nombre = nombre.replaceAll(/>/, /&gt;/)
            def header, tablas, footer, nota, salto
            def tablaHer, tablaMano, tablaMat, tablaTrans, tablaIndi

            header =
                    "  <div class=\"tituloPdf\" >\n" +
                            "                <p style=\"font-size: 18px\">\n" +
                            "                    <b>G.A.D. PROVINCIA DE PICHINCHA</b>\n" +
                            "                </p>\n" +
                            "\n" +
                            "                <p style=\"font-size: 14px\">\n" +
                            "                    <b>DCP - COORDINACIÓN DE RÉGIMEN DE FIJACIÓN DE COSTOS</b>\n" +
                            "                </p>\n" +
                            "\n" +
                            "                <p style=\"font-size: 14px\">\n" +
                            "                    <b>ANÁLISIS DE PRECIOS UNITARIOS</b>\n" +
                            "                </p>\n" +
                            "\n" +
                            "            </div>\n " +
                            " <div style=\"margin-top: 1px\">\n" +
                            "                <div class=\"row-fluid\">\n" +
                            " <div class=\"span3\" style=\"margin-right: 195px !important;\">\n"
            if (fecha2) {
                header += "                            <b>Fecha:</b> ${fecha2.format("dd-MM-yyyy")}\n"
            } else {
                header += "                             <b>Fecha:</b>\n"
            }

            header += "                    </div>\n" +

                    "  <div class=\"span4\">\n"
            if (fecha1) {

                header += "                         <b>Fecha Act. P.U:</b> ${fecha1.format("dd-MM-yyyy")}\n"
            } else {
                header += "                            <b>Fecha Act. P.U:</b>\n"
            }

            header += "                    </div>\n" +
                    "                </div>\n" +
                    "\n" +
                    "  <div class=\"row-fluid\">\n" +
                    "                    <div class=\"span12\">\n" +
                    "\n" +
                    "                        <b>Código Obra:</b> ${obra?.codigo}\n" +
                    "                    </div>\n" +
                    "                </div>\n" +
                    "\n" +
                    "               <div class=\"row-fluid\">\n" +
                    "                    <div class=\"span12\">\n" +
                    "\n" +
                    "                        <b>Presupuesto:</b> ${obra?.nombre.decodeHTML()}\n" +
                    "                    </div>\n" +
                    "                </div>\n" +
                    "                <div class=\"row-fluid\">\n" +
                    "                    <div class=\"span3\" style=\"margin-right: 195px !important;\">\n" +
                    "                        <b>Código de rubro:</b> ${rubro.codigo}\n" +
                    "                    </div>\n" +
                    "\n" +
                    "                    <div class=\"span4\">\n" +
                    "                        <b>Unidad:</b> ${rubro.unidad.codigo}\n" +
                    "                    </div>\n" +
                    "                </div>\n" +
                    "\n" +
                    "                <div class=\"row-fluid\">\n" +
                    "                    <div class=\"span12\">\n" +
                    "                        <b>Descripción:</b> ${nombre}\n" +
                    "                    </div>\n" +
                    "                </div>\n" +
                    "            </div>"

            preciosService.ac_rbroObra(obra.id)
            def res = preciosService.precioUnitarioVolumenObraAsc("*", obra.id, rubro.id)

            tablaHer = '<table class=""> '
            tablaMano = '<table class=""> '
            tablaMat = '<table class=""> '
            tablaTrans = '<table class=""> '
            tablaIndi = '<table class=""> '
            def tablaMat2 = '<table class="marginTop"> '
            def tablaTrans2 = '<table class="marginTop"> '
            def total = 0, totalHer = 0, totalMan = 0, totalMat = 0
            def band = 0
            def bandMat = 0
            def bandTrans = params.desglose



            tablaTrans += "<thead><tr><th colspan='8' class='tituloHeader'>TRANSPORTE</th></tr><tr><th colspan='8' class='theader'></th></tr><tr><th style='width: 80px;' class='padTopBot' >CÓDIGO</th><th style='width:610px'>DESCRIPCIÓN</th><th>UNIDAD</th><th>PES/VOL</th><th>CANTIDAD</th><th>DISTANCIA</th><th>TARIFA</th><th>C.TOTAL(\$)</th></tr>  <tr><th colspan='8' class='theaderup'></th></tr> </thead><tbody>"
            tablaHer += "<thead><tr><th colspan='7' class='tituloHeader'>EQUIPOS</th></tr><tr><th colspan='7' class='theader'></th></tr><tr><th style='width: 80px' class='padTopBot'>CÓDIGO</th><th style='width:610px'>DESCRIPCIÓN</th><th>CANTIDAD</th><th style='width:70px'>TARIFA(\$/H)</th><th>COSTO(\$)</th><th>RENDIMIENTO</th><th>C.TOTAL(\$)</th></tr>  <tr><th colspan='7' class='theaderup'></th></tr> </thead><tbody>"
            tablaMano += "<thead><tr><th colspan='7' class='tituloHeader'>MANO DE OBRA</th></tr><tr><th colspan='7' class='theader'></th></tr><tr><th style='width: 80px;' class='padTopBot'>CÓDIGO</th><th style='width:610px'>DESCRIPCIÓN</th><th>CANTIDAD</th><th style='width:70px'>JORNAL(\$/H)</th><th>COSTO(\$)</th><th>RENDIMIENTO</th><th>C.TOTAL(\$)</th></tr>  <tr><th colspan='7' class='theaderup'></th></tr> </thead><tbody>"

            if (params.desglose == '0') {

                tablaMat += "<thead><tr><th colspan='6' class='tituloHeader'>MATERIALES INCLUIDO TRANSPORTE</th></tr><tr><th colspan='6' class='theader'></th></tr><tr><th style='width: 80px;' class='padTopBot'>CÓDIGO</th><th style='width:610px'>DESCRIPCIÓN</th><th>UNIDAD</th><th>CANTIDAD</th><th>UNITARIO(\$)</th><th>C.TOTAL(\$)</th></tr> <tr><th colspan='6' class='theaderup'></th></tr> </thead><tbody>"

            } else {

                tablaMat += "<thead><tr><th colspan='6' class='tituloHeader'>MATERIALES</th></tr><tr><th colspan='6' class='theader'></th></tr><tr><th style='width: 80px;' class='padTopBot'>CÓDIGO</th><th style='width:610px'>DESCRIPCIÓN</th><th>UNIDAD</th><th>CANTIDAD</th><th>UNITARIO(\$)</th><th>C.TOTAL(\$)</th></tr> <tr><th colspan='6' class='theaderup'></th></tr> </thead><tbody>"

            }
            tablaMat2 += "<thead><tr><th colspan='6' class='tituloHeader'>MATERIALES</th></tr><tr><th colspan='6' class='theader'></th></tr><tr><th style='width: 80px;' class='padTopBot'>CÓDIGO</th><th style='width:610px'>DESCRIPCIÓN</th><th>UNIDAD</th><th>CANTIDAD</th><th>UNITARIO(\$)</th><th>C.TOTAL(\$)</th></tr> <tr><th colspan='6' class='theaderup'></th></tr> </thead><tbody>"
            tablaTrans2 += "<thead><tr><th colspan='8' class='tituloHeader'>TRANSPORTE</th></tr><tr><th colspan='8' class='theader'></th></tr><tr><th style='width: 80px;' class='padTopBot'>CÓDIGO</th><th style='width:610px'>DESCRIPCIÓN</th><th>UNIDAD</th><th>PES/VOL</th><th>CANTIDAD</th><th>DISTANCIA</th><th>TARIFA</th><th>C.TOTAL(\$)</th></tr>  <tr><th colspan='8' class='theaderup'></th></tr> </thead><tbody>"



            res.each { r ->
//            println "res "+res

                if (r["grpocdgo"] == 3) {
                    def nombreVaeH = r["itemnmbr"].decodeHTML()
                    nombreVaeH = nombreVaeH.replaceAll(/</, /&lt;/)
                    nombreVaeH = nombreVaeH.replaceAll(/&/, /&amp;/)
                    nombreVaeH = nombreVaeH.replaceAll(/'/, /&apos;/)
                    nombreVaeH = nombreVaeH.replaceAll(/"/, /&quot;/)
                    nombreVaeH = nombreVaeH.replaceAll(/>/, /&gt;/)

                    tablaHer += "<tr>"
                    tablaHer += "<td style='width: 80px;'>" + r["itemcdgo"] + "</td>"
//                    tablaHer += "<td>" + r["itemnmbr"] + "</td>"
                    tablaHer += "<td>" + nombreVaeH + "</td>"
                    tablaHer += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaHer += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaHer += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"] * r["rbrocntd"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaHer += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rndm"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaHer += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["parcial"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    totalHer += r["parcial"]
                    tablaHer += "</tr>"
                }
                if (r["grpocdgo"] == 2) {
                    def nombreVaeM = r["itemnmbr"].decodeHTML()
                    nombreVaeM = nombreVaeM.replaceAll(/</, /&lt;/)
                    nombreVaeM = nombreVaeM.replaceAll(/&/, /&amp;/)
                    nombreVaeM = nombreVaeM.replaceAll(/'/, /&apos;/)
                    nombreVaeM = nombreVaeM.replaceAll(/"/, /&quot;/)
                    nombreVaeM = nombreVaeM.replaceAll(/>/, /&gt;/)

                    tablaMano += "<tr>"
                    tablaMano += "<td style='width: 80px;'>" + r["itemcdgo"] + "</td>"
//                    tablaMano += "<td>" + r["itemnmbr"] + "</td>"
                    tablaMano += "<td>" + nombreVaeM + "</td>"
                    tablaMano += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaMano += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaMano += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"] * r["rbrocntd"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaMano += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rndm"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaMano += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["parcial"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    totalMan += r["parcial"]
                    tablaMano += "</tr>"
                }
                if (r["grpocdgo"] == 1) {


                    def nombreVaeMat = r["itemnmbr"].decodeHTML()
                    nombreVaeMat = nombreVaeMat.replaceAll(/</, /&lt;/)
                    nombreVaeMat = nombreVaeMat.replaceAll(/&/, /&amp;/)
                    nombreVaeMat = nombreVaeMat.replaceAll(/'/, /&apos;/)
                    nombreVaeMat = nombreVaeMat.replaceAll(/"/, /&quot;/)
                    nombreVaeMat = nombreVaeMat.replaceAll(/>/, /&gt;/)

                    bandMat = 1

                    tablaMat += "<tr>"
                    if (params.desglose != '0') {
                        tablaMat += "<td style='width: 80px;'>" + r["itemcdgo"] + "</td>"
//                        tablaMat += "<td>" + r["itemnmbr"] + "</td>"
                        tablaMat += "<td>" + nombreVaeMat + "</td>"
                        tablaMat += "<td style='width: 50px;text-align: center'>${r['unddcdgo']}</td>"
                        tablaMat += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                        tablaMat += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbpcpcun"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                        tablaMat += "<td style='width: 50px;text-align: right'>" + r["parcial"] + "</td>"
                        totalMat += r["parcial"]
                    }
                    if (params.desglose == '0') {

                        tablaMat += "<td style='width: 80px;'>" + r["itemcdgo"] + "</td>"
//                        tablaMat += "<td>" + r["itemnmbr"] + "</td>"
                        tablaMat += "<td>" + nombreVaeMat + "</td>"
                        tablaMat += "<td style='width: 50px;text-align: center'>${r['unddcdgo']}</td>"
                        tablaMat += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                        tablaMat += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: (r["rbpcpcun"] + r["parcial_t"] / r["rbrocntd"]), format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                        tablaMat += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: (r["parcial"] + r["parcial_t"]), format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"

                        totalMat += r["parcial"] + r["parcial_t"]
                    }
                    tablaMat += "</tr>"
                }
                if (r["grpocdgo"] == 1 && params.desglose != '0') {

                    def nombreVaeT = r["itemnmbr"].decodeHTML()
                    nombreVaeT = nombreVaeT.replaceAll(/</, /&lt;/)
                    nombreVaeT = nombreVaeT.replaceAll(/&/, /&amp;/)
                    nombreVaeT = nombreVaeT.replaceAll(/'/, /&apos;/)
                    nombreVaeT = nombreVaeT.replaceAll(/"/, /&quot;/)
                    nombreVaeT = nombreVaeT.replaceAll(/>/, /&gt;/)

                    tablaTrans += "<tr>"
                    tablaTrans += "<td style='width: 80px;'>" + r["itemcdgo"] + "</td>"
//                    tablaTrans += "<td>" + r["itemnmbr"] + "</td>"
                    tablaTrans += "<td>" + nombreVaeT + "</td>"
//                    println " -------------------" + r
                    if (r["tplscdgo"].trim() == 'P' || r["tplscdgo"].trim() == 'P1') {
                        tablaTrans += "<td style='width: 50px;text-align: right'>" + "ton-km" + "</td>"
                    } else {

                        if (r["tplscdgo"].trim() == 'V' || r["tplscdgo"].trim() == 'V1' || r["tplscdgo"].trim() == 'V2') {

                            tablaTrans += "<td style='width: 50px;text-align: right'>" + "m3-km" + "</td>"
                        } else {

                            tablaTrans += "<td style='width: 50px;text-align: right'>" + r["unddcdgo"] + "</td>"
                        }

                    }
//                tablaTrans += "<td style='width: 50px;text-align: right'>" + r["unddcdgo"] + "</td>"
                    tablaTrans += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["itempeso"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaTrans += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["rbrocntd"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaTrans += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["distancia"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaTrans += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["tarifa"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    tablaTrans += "<td style='width: 50px;text-align: right'>" + g.formatNumber(number: r["parcial_t"], format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec") + "</td>"
                    total += r["parcial_t"]
                    tablaTrans += "</tr>"
                } else {
                }
            }


            tablaTrans += "<tr><td></td><td></td><td></td><td></td><td></td><td></td><td style='text-align: right'><b>TOTAL</b></td><td style='width: 50px;text-align: right'><b>${g.formatNumber(number: total, format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec")}</b></td></tr>"
            tablaTrans += "</tbody></table>"
            tablaHer += "<tr><td></td><td></td><td></td><td></td><td></td><td style='text-align: right'><b>TOTAL</b></td><td style='width: 50px;text-align: right'><b>${g.formatNumber(number: totalHer, format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec")}</b></td></tr>"
            tablaHer += "</tbody></table>"
            tablaMano += "<tr><td></td><td></td><td></td><td></td><td></td><td style='text-align: right'><b>TOTAL</b></td><td style='width: 50px;text-align: right'><b>${g.formatNumber(number: totalMan, format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec")}</b></td></tr>"
            tablaMano += "</tbody></table>"
            tablaMat += "<tr><td></td><td></td><td></td><td></td><td style='text-align: right'><b>TOTAL</b></td><td style='width: 50px;text-align: right'><b>${g.formatNumber(number: totalMat, format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5", locale: "ec")}</b></td></tr>"
            tablaMat += "</tbody></table>"
            tablaTrans2 += "</tbody></table>"
            tablaMat2 += "</tbody></table>"

            def totalRubro = 0
            totalRubro = total + totalHer + totalMan + totalMat
            def totalIndi = totalRubro * indi / 100

            tablaIndi += "<thead><tr><th class='tituloHeader'>COSTOS INDIRECTOS</th></tr><tr><th colspan='3' class='theader'></th></tr><tr><th style='width:550px' class='padTopBot'>DESCRIPCIÓN</th><th style='width:130px'>PORCENTAJE</th><th>VALOR</th></tr>    <tr><th colspan='3' class='theaderup'></th></tr>  </thead>"
            tablaIndi += "<tbody><tr><td>COSTOS INDIRECTOS</td><td style='text-align:center'>${indi}%</td><td style='text-align:right'>${g.formatNumber(number: totalIndi, format: "##,##0", minFractionDigits: "5", maxFractionDigits: "5")}</td></tr></tbody>"
            tablaIndi += "</table>"

            tablas = "<div style=\"width: 100%;margin-top: 10px;\">"

            if (params.desglose == '0') {
                tablas += tablaHer + tablaMano + tablaMat + tablaIndi
            } else {
                tablas += tablaHer + tablaMano + tablaMat + tablaTrans + tablaIndi
            }

            tablas += "</div>"

            footer =
                    " <table class=\"table table-bordered table-striped table-condensed table-hover\" style=\"margin-top: 20px;margin-left: 300px;width: 50%;  border-top: 1px solid #000000;  border-bottom: 1px solid #000000;\">\n" +
                            "                    <tbody>\n" +
                            "                        <tr>\n" +
                            "                            <td style=\"width: 350px;\">\n" +
                            "                                <b>COSTO UNITARIO DIRECTO</b>\n" +
                            "                            </td>\n" +
                            "                            <td style=\"text-align: right\"><b>" + g.formatNumber(number: totalRubro, format: "##,##0", minFractionDigits: 2, maxFractionDigits: 2, locale: "ec") +
                            "                            </b></td>\n" +
                            "                        </tr>\n" +
                            "                        <tr>\n" +
                            "                            <td>\n" +
                            "                                <b>COSTOS INDIRECTOS</b>\n" +
                            "                            </td>\n" +
                            "                            <td style=\"text-align: right\"><b>" + g.formatNumber(number: totalIndi, format: "##,##0", minFractionDigits: 2, maxFractionDigits: 2, locale: "ec") +
                            "                            </b></td>\n" +
                            "                        </tr>\n" +
                            "                        <tr>\n" +
                            "                            <td>\n" +
                            "                                <b>COSTO TOTAL DEL RUBRO</b>\n" +
                            "                            </td>\n" +
                            "                            <td style=\"text-align: right\"><b>" + g.formatNumber(number: totalRubro + totalIndi, format: "##,##0", minFractionDigits: 2, maxFractionDigits: 2, locale: "ec") +
                            "                            </b></td>\n" +
                            "                        </tr>\n" +
                            "                        <tr>\n" +
                            "                            <td>\n" +
                            "                                <b>PRECIO UNITARIO (\$USD)</b>\n" +
                            "                            </td>\n" +
                            "                            <td style=\"text-align: right\"><b>" + g.formatNumber(number: totalRubro + totalIndi, format: "##,##0", minFractionDigits: 2, maxFractionDigits: 2, locale: "ec") +
                            "\n" +
                            "                            </b></td>\n" +
                            "                        </tr>\n" +
                            "                    </tbody>\n" +

                            "</table>\n"
            if(rubro?.codigo.split('-')[0] == 'TR') {
                footer += "<div><strong>Distancia General de Transporte:</strong> D= ${obra?.distanciaDesalojo} km</div>"
            }
            footer += "<div><b>Nota:</b> Los cálculos se hacen con todos los decimales y el resultado final se lo redondea a dos decimales</div>"
            html += "<div class='divRubro'>" + header + tablas + footer + "</div>"


        }
        [html: html]

    }


    def addTablaHoja(document, table, right) {
        Paragraph paragraph = new Paragraph()
        if (right) {
            paragraph.setAlignment(Element.ALIGN_RIGHT);
        }
        paragraph.setSpacingAfter(10);
//        addEmptyLine(paragraph, 1);
        paragraph.add(table);
        document.add(paragraph);
    }

    def addCellTabla(table, paragraph, params) {
        PdfPCell cell = new PdfPCell(paragraph);
//        println "params "+params
        cell.setBorderColor(Color.BLACK);

        if (params.border) {
            if (!params.bordeBot)
                if (!params.bordeTop)
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


    def reporteRegistro() {

        def obra = Obra.get(params.id)

        def auxiliar = Auxiliar.get(1)


        def prmsHeaderHoja = [border: Color.WHITE]
        def prmsHeaderHoja3 = [border: Color.WHITE, colspan: 2]


        def prmsHeaderHoja2 = [border: Color.WHITE, colspan: 9]


        def prmsHeader = [border: Color.WHITE, colspan: 7, bg: new Color(73, 175, 205),
                          align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]



        def prmsHeader2 = [border: Color.WHITE, colspan: 3, bg: new Color(73, 175, 205),
                           align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead = [border: Color.WHITE, bg: new Color(73, 175, 205),
                            align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellCenter = [border: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellRight = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsCellLeft = [border: Color.BLACK, valign: Element.ALIGN_MIDDLE]
        def prmsSubtotal = [border: Color.BLACK, colspan: 6,
                            align : Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsNum = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        def prms = [prmsHeaderHoja: prmsHeaderHoja, prmsHeader: prmsHeader, prmsHeader2: prmsHeader2,
                    prmsCellHead: prmsCellHead, prmsCell: prmsCellCenter, prmsCellLeft: prmsCellLeft, prmsSubtotal: prmsSubtotal, prmsNum: prmsNum, prmsHeaderHoja2: prmsHeaderHoja2, prmsCellRight: prmsCellRight]



        def baos = new ByteArrayOutputStream()
        def name = "presupuesto_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        Font times12bold = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font times14bold = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font times10bold = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times10normal = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL);
        Font times8bold = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        Font times8normal = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL)
        Font times10boldWhite = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8boldWhite = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        times8boldWhite.setColor(Color.WHITE)
        times10boldWhite.setColor(Color.WHITE)
        def fonts = [times12bold: times12bold, times10bold: times10bold, times8bold: times8bold,
                     times10boldWhite: times10boldWhite, times8boldWhite: times8boldWhite, times8normal: times8normal, times10normal: times10normal]

        Document document
        document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);
        document.open();
        document.addTitle("Registro " + new Date().format("dd_MM_yyyy"));
        document.addSubject("Generado por el sistema Janus");
        document.addKeywords("documentosObra, janus, presupuesto");
        document.addAuthor("Janus");
        document.addCreator("Tedein SA");



        Paragraph headers = new Paragraph();
        addEmptyLine(headers, 1);
        headers.setAlignment(Element.ALIGN_CENTER);
        headers.add(new Paragraph(auxiliar.titulo, times14bold));
        headers.add(new Paragraph(" ", times10bold));
//        headers.add(new Paragraph(" ", times10bold));
        headers.add(new Paragraph(obra?.departamento?.direccion?.nombre, times10bold));
        headers.add(new Paragraph(" ", times10bold));
        headers.add(new Paragraph("DATOS DE LA OBRA ", times10bold));
        headers.add(new Paragraph(" ", times10bold));
        document.add(headers)


        PdfPTable tablaCoeficiente = new PdfPTable(3);
        tablaCoeficiente.setWidthPercentage(100);
        tablaCoeficiente.setWidths(arregloEnteros([30, 20, 50]))

        addCellTabla(tablaCoeficiente, new Paragraph(" ", times10normal), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente, new Paragraph(" ", times10normal), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente, new Paragraph(" ", times10normal), prmsHeaderHoja)

        addCellTabla(tablaCoeficiente, new Paragraph(" ", times10normal), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente, new Paragraph(" ", times10normal), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente, new Paragraph(" ", times10normal), prmsHeaderHoja)

        addCellTabla(tablaCoeficiente, new Paragraph("Obra: ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente, new Paragraph(obra?.nombre, times10normal), prmsHeaderHoja3)

        addCellTabla(tablaCoeficiente, new Paragraph("Código: ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente, new Paragraph(obra?.codigo, times10normal), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente, new Paragraph(" ", times10bold), prmsHeaderHoja)

        addCellTabla(tablaCoeficiente, new Paragraph("Descripción: ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente, new Paragraph(obra?.descripcion, times10normal), prmsHeaderHoja3)

        addCellTabla(tablaCoeficiente, new Paragraph("Dirección: ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente, new Paragraph(obra?.departamento?.direccion?.nombre, times10normal), prmsHeaderHoja3)

        addCellTabla(tablaCoeficiente, new Paragraph("Programa: ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente, new Paragraph(obra?.programacion?.descripcion, times10normal), prmsHeaderHoja3)

        addCellTabla(tablaCoeficiente, new Paragraph("Clase de Obra: ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente, new Paragraph(obra?.claseObra?.descripcion, times10normal), prmsHeaderHoja3)

        addCellTabla(tablaCoeficiente, new Paragraph("Plazo: ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente, new Paragraph(obra?.plazoEjecucionMeses + " Mes(es)" + " " + obra?.plazoEjecucionDias + " Días", times10normal), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente, new Paragraph(" ", times10normal), prmsHeaderHoja)

        addCellTabla(tablaCoeficiente, new Paragraph("Documento de Referencia: ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente, new Paragraph(obra?.oficioIngreso, times10normal), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente, new Paragraph(" ", times10normal), prmsHeaderHoja)

        addCellTabla(tablaCoeficiente, new Paragraph("Oficio de Salida: ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente, new Paragraph(obra?.oficioSalida, times10normal), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente, new Paragraph(" ", times10normal), prmsHeaderHoja)

        addCellTabla(tablaCoeficiente, new Paragraph(" ", times10normal), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente, new Paragraph(" ", times10normal), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente, new Paragraph(" ", times10normal), prmsHeaderHoja)


        PdfPTable tablaDistancias = new PdfPTable(4);
        tablaDistancias.setWidthPercentage(100);
        tablaDistancias.setWidths(arregloEnteros([25, 25, 25, 25]))

        addCellTabla(tablaDistancias, new Paragraph("Listas de Precios al Peso", times12bold), prmsHeaderHoja)
        addCellTabla(tablaDistancias, new Paragraph(" ", times10normal), prmsHeaderHoja)
        addCellTabla(tablaDistancias, new Paragraph("Distancias", times12bold), prmsHeaderHoja)
        addCellTabla(tablaDistancias, new Paragraph(" ", times10bold), prmsHeaderHoja)

        addCellTabla(tablaDistancias, new Paragraph(" ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaDistancias, new Paragraph(" ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaDistancias, new Paragraph(" ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaDistancias, new Paragraph(" ", times10bold), prmsHeaderHoja)

        addCellTabla(tablaDistancias, new Paragraph("Lista Cantón", times10bold), prmsHeaderHoja)
//        addCellTabla(tablaCoeficiente2, new Paragraph(g.formatNumber(number: obra?.lugar, format: "###.##", locale: "ec"), times10normal), prmsHeaderHoja)
        addCellTabla(tablaDistancias, new Paragraph(obra?.lugar?.descripcion, times10normal), prmsHeaderHoja)
        addCellTabla(tablaDistancias, new Paragraph("Capital de Cantón ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaDistancias, new Paragraph(g.formatNumber(number: obra?.distanciaPeso, format: "###.##", locale: "ec"), times10normal), prmsHeaderHoja)
//        addCellTabla(tablaDistancias, new Paragraph(obra?.distanciaPeso, times10bold), prmsHeaderHoja)

        addCellTabla(tablaDistancias, new Paragraph("Lista Peso Especial", times10bold), prmsHeaderHoja)
//        addCellTabla(tablaCoeficiente2, new Paragraph(g.formatNumber(number: obra?.listaPeso1, format: "###.##", locale: "ec"), times10normal), prmsHeaderHoja)
        addCellTabla(tablaDistancias, new Paragraph(obra?.listaPeso1?.descripcion, times10normal), prmsHeaderHoja)
        addCellTabla(tablaDistancias, new Paragraph("Distancia Peso Espeacial ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaDistancias, new Paragraph(g.formatNumber(number: obra?.distanciaPesoEspecial, format: "###.##", locale: "ec"), times10normal), prmsHeaderHoja)

//        addCellTabla(tablaDistancias, new Paragraph(obra?.distanciaPesoEspecial, times10bold), prmsHeaderHoja)


        addCellTabla(tablaDistancias, new Paragraph(" ", times10normal), prmsHeaderHoja)
        addCellTabla(tablaDistancias, new Paragraph(" ", times10normal), prmsHeaderHoja)
        addCellTabla(tablaDistancias, new Paragraph(" ", times10normal), prmsHeaderHoja)
        addCellTabla(tablaDistancias, new Paragraph(" ", times10normal), prmsHeaderHoja)


        addCellTabla(tablaDistancias, new Paragraph("Listas Volumen", times12bold), prmsHeaderHoja)
        addCellTabla(tablaDistancias, new Paragraph(" ", times10normal), prmsHeaderHoja)
        addCellTabla(tablaDistancias, new Paragraph("Distancias", times12bold), prmsHeaderHoja)
        addCellTabla(tablaDistancias, new Paragraph(" ", times10bold), prmsHeaderHoja)

        addCellTabla(tablaDistancias, new Paragraph("Lista Materiales Petreos Hormigones", times10bold), prmsHeaderHoja)
//        addCellTabla(tablaCoeficiente2, new Paragraph(g.formatNumber(number: obra?.listaVolumen0, format: "###.##", locale: "ec"), times10normal), prmsHeaderHoja)
        addCellTabla(tablaDistancias, new Paragraph(obra?.listaVolumen0?.descripcion, times10normal), prmsHeaderHoja)
        addCellTabla(tablaDistancias, new Paragraph("Distancia Materiales Petreos Hormigones", times10bold), prmsHeaderHoja)
        addCellTabla(tablaDistancias, new Paragraph(g.formatNumber(number: obra?.distanciaVolumen, format: "###.##", locale: "ec"), times10normal), prmsHeaderHoja)
//        addCellTabla(tablaDistancias, new Paragraph(obra?.distanciaVolumen, times10bold), prmsHeaderHoja)

        addCellTabla(tablaDistancias, new Paragraph("Lista Materiales Mejoramiento", times10bold), prmsHeaderHoja)
//        addCellTabla(tablaCoeficiente2, new Paragraph(g.formatNumber(number: obra?.listaVolumen1, format: "###.##", locale: "ec"), times10normal), prmsHeaderHoja)
        addCellTabla(tablaDistancias, new Paragraph(obra?.listaVolumen1?.descripcion, times10normal), prmsHeaderHoja)
        addCellTabla(tablaDistancias, new Paragraph("Distancia Materiales Mejoramiento", times10bold), prmsHeaderHoja)
        addCellTabla(tablaDistancias, new Paragraph(g.formatNumber(number: obra?.distanciaVolumenMejoramiento, format: "###.##", locale: "ec"), times10normal), prmsHeaderHoja)
//        addCellTabla(tablaDistancias, new Paragraph(obra?.distanciaVolumenMejoramiento, times10bold), prmsHeaderHoja)

        addCellTabla(tablaDistancias, new Paragraph("Lista Materiales Carpeta Asfáltica", times10bold), prmsHeaderHoja)
//        addCellTabla(tablaCoeficiente2, new Paragraph(g.formatNumber(number: obra?.listaVolumen2, format: "###.##", locale: "ec"), times10normal), prmsHeaderHoja)
        addCellTabla(tablaDistancias, new Paragraph(obra?.listaVolumen2?.descripcion, times10normal), prmsHeaderHoja)
        addCellTabla(tablaDistancias, new Paragraph("Distancia Materiales Carpeta Asfáltica", times10bold), prmsHeaderHoja)
        addCellTabla(tablaDistancias, new Paragraph(g.formatNumber(number: obra?.distanciaVolumenCarpetaAsfaltica, format: "###.##", locale: "ec"), times10normal), prmsHeaderHoja)
//        addCellTabla(tablaDistancias, new Paragraph(obra?.distanciaVolumenCarpetaAsfaltica, times10bold), prmsHeaderHoja)


        PdfPTable tablaCoeficiente2 = new PdfPTable(3);
        tablaCoeficiente2.setWidthPercentage(100);
        tablaCoeficiente2.setWidths(arregloEnteros([30, 40, 30]))

        addCellTabla(tablaCoeficiente2, new Paragraph(" ", times10normal), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente2, new Paragraph(" ", times10normal), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente2, new Paragraph(" ", times10normal), prmsHeaderHoja)

        addCellTabla(tablaCoeficiente2, new Paragraph("Ubicación", times12bold), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente2, new Paragraph(" ", times10normal), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente2, new Paragraph(" ", times10normal), prmsHeaderHoja)

        addCellTabla(tablaCoeficiente2, new Paragraph("Cantón: ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente2, new Paragraph(obra?.parroquia?.canton?.nombre, times10normal), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente2, new Paragraph(" ", times10normal), prmsHeaderHoja)

        addCellTabla(tablaCoeficiente2, new Paragraph("Parroquia: ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente2, new Paragraph(obra?.parroquia?.nombre, times10normal), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente2, new Paragraph(" ", times10normal), prmsHeaderHoja)

        addCellTabla(tablaCoeficiente2, new Paragraph("Comunidad: ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente2, new Paragraph(obra?.comunidad?.nombre, times10normal), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente2, new Paragraph(" ", times10normal), prmsHeaderHoja)

        addCellTabla(tablaCoeficiente2, new Paragraph("Barrio: ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente2, new Paragraph(obra?.barrio, times10normal), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente2, new Paragraph(" ", times10normal), prmsHeaderHoja)

        addCellTabla(tablaCoeficiente2, new Paragraph("Sitio: ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente2, new Paragraph(obra?.sitio, times10normal), prmsHeaderHoja3)

        addCellTabla(tablaCoeficiente2, new Paragraph("Coordenadas: ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente2, new Paragraph(obra?.coordenadas, times10normal), prmsHeaderHoja3)

        addCellTabla(tablaCoeficiente2, new Paragraph("Lista de precios M.O. y Equipos: ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente2, new Paragraph(obra?.lugar?.descripcion, times10normal), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente2, new Paragraph(" ", times10normal), prmsHeaderHoja)

        addCellTabla(tablaCoeficiente2, new Paragraph(" ", times10normal), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente2, new Paragraph(" ", times10normal), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente2, new Paragraph(" ", times10normal), prmsHeaderHoja)

        addCellTabla(tablaCoeficiente2, new Paragraph("Datos Generales", times12bold), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente2, new Paragraph(" ", times10normal), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente2, new Paragraph(" ", times10normal), prmsHeaderHoja)

        addCellTabla(tablaCoeficiente2, new Paragraph("Inspector: ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente2, new Paragraph(obra?.inspector?.nombre + " " + obra?.inspector?.apellido, times10normal), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente2, new Paragraph(" ", times10normal), prmsHeaderHoja)

        addCellTabla(tablaCoeficiente2, new Paragraph("Revisor: ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente2, new Paragraph(obra?.revisor?.nombre + " " + obra?.revisor?.apellido, times10normal), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente2, new Paragraph(" ", times10normal), prmsHeaderHoja)

        addCellTabla(tablaCoeficiente2, new Paragraph("Responsable: ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente2, new Paragraph(obra?.responsableObra?.nombre + " " + obra?.responsableObra?.apellido, times10normal), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente2, new Paragraph(" ", times10normal), prmsHeaderHoja)


        addCellTabla(tablaCoeficiente2, new Paragraph("Fecha de Registro de la Obra: ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente2, new Paragraph(printFecha(obra?.fechaCreacionObra), times10normal), prmsHeaderHoja3)


        addCellTabla(tablaCoeficiente2, new Paragraph("Observaciones: ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente2, new Paragraph(obra?.observaciones, times10normal), prmsHeaderHoja)
        addCellTabla(tablaCoeficiente2, new Paragraph(" ", times10normal), prmsHeaderHoja)

        document.add(tablaCoeficiente)
        document.add(tablaDistancias)
        document.add(tablaCoeficiente2)


        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)


    }

    //reporte registroTramite

    def reporteRegistroTramite() {

//        println("--->" + params)

        def usuario = session.usuario

        def tramites = PersonasTramite.withCriteria {
            eq("persona", usuario)
            ne("rolTramite", RolTramite.findByCodigo("CC"))
            tramite {
                ne("estado", EstadoTramite.findByCodigo('F'))
            }
        }.tramite.unique()



        def prmsHeaderHoja = [border: Color.WHITE]


        def prmsHeaderHoja2 = [border: Color.WHITE, colspan: 9]


        def prmsHeader = [border: Color.WHITE, colspan: 7, bg: new Color(73, 175, 205),
                          align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]



        def prmsHeader2 = [border: Color.WHITE, colspan: 3, bg: new Color(73, 175, 205),
                           align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead = [border: Color.WHITE, bg: new Color(73, 175, 205),
                            align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHeadRight = [border: Color.WHITE, bg: new Color(73, 175, 205),
                                 align : Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsCellCenter = [border: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellRight = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsCellLeft = [border: Color.BLACK, valign: Element.ALIGN_MIDDLE]
        def prmsSubtotal = [border: Color.BLACK, colspan: 6,
                            align : Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsNum = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        def prms = [prmsHeaderHoja: prmsHeaderHoja, prmsHeader: prmsHeader, prmsHeader2: prmsHeader2,
                    prmsCellHead: prmsCellHead, prmsCell: prmsCellCenter, prmsCellLeft: prmsCellLeft, prmsSubtotal: prmsSubtotal, prmsNum: prmsNum, prmsHeaderHoja2: prmsHeaderHoja2, prmsCellRight: prmsCellRight, prmsCellHeadRight: prmsCellHeadRight]



        def baos = new ByteArrayOutputStream()
        def name = "registroTramite_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        Font times12bold = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font times10bold = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8bold = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        Font times8normal = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL)
        Font times10boldWhite = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8boldWhite = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        times8boldWhite.setColor(Color.WHITE)
        times10boldWhite.setColor(Color.WHITE)
        def fonts = [times12bold: times12bold, times10bold: times10bold, times8bold: times8bold,
                     times10boldWhite: times10boldWhite, times8boldWhite: times8boldWhite, times8normal: times8normal]

        Document document
        document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);
        document.open();
        document.addTitle("Presupuesto " + new Date().format("dd_MM_yyyy"));
        document.addSubject("Generado por el sistema Janus");
        document.addKeywords("tramite, janus, registroTramite");
        document.addAuthor("Janus");
        document.addCreator("Tedein SA");

        Paragraph headers = new Paragraph();
        addEmptyLine(headers, 1);
        headers.setAlignment(Element.ALIGN_CENTER);

        headers.add(new Paragraph((Auxiliar.get(1)?.titulo ?: '')))
        headers.add(new Paragraph(" "))
        headers.add(new Paragraph("TRÁMITES EN PROCESO"))
        headers.add(new Paragraph(" "))
        headers.add(new Paragraph("Quito, " + formatDate(date: new Date(), format: "dd-MM-yyyy"), times10bold));
        headers.add(new Paragraph(" ", times10bold));

        PdfPTable tablaVolObra = new PdfPTable(8);
        tablaVolObra.setWidthPercentage(100);


        tablaVolObra.setWidths(arregloEnteros([10, 20, 20, 14, 9, 12, 8, 7]))

        addCellTabla(tablaVolObra, new Paragraph("Tipo", times8bold), prmsCellHead)
        addCellTabla(tablaVolObra, new Paragraph("Envia", times8bold), prmsCellHead)
        addCellTabla(tablaVolObra, new Paragraph("Recibe", times8bold), prmsCellHead)
        addCellTabla(tablaVolObra, new Paragraph("Asunto", times8bold), prmsCellHead)
        addCellTabla(tablaVolObra, new Paragraph("Fecha", times8bold), prmsCellHead)
        addCellTabla(tablaVolObra, new Paragraph("Documentos", times8bold), prmsCellHead)
        addCellTabla(tablaVolObra, new Paragraph("N° Memo SAD", times8bold), prmsCellHead)
        addCellTabla(tablaVolObra, new Paragraph("Estado", times8bold), prmsCellHead)

        tramites.each {

            addCellTabla(tablaVolObra, new Paragraph(it?.tipoTramite?.descripcion, times8normal), prmsCellCenter)
            addCellTabla(tablaVolObra, new Paragraph(PersonasTramite.findByRolTramiteAndTramite(RolTramite.findByCodigo('DE'), it).persona.nombre + " " + PersonasTramite.findByRolTramiteAndTramite(RolTramite.findByCodigo('DE'), it).persona.apellido, times8normal), prmsCellLeft)
            addCellTabla(tablaVolObra, new Paragraph(PersonasTramite.findByRolTramiteAndTramite(RolTramite.findByCodigo('PARA'), it).persona.nombre + " " + PersonasTramite.findByRolTramiteAndTramite(RolTramite.findByCodigo('PARA'), it).persona.apellido, times8normal), prmsCellLeft)
            addCellTabla(tablaVolObra, new Paragraph(it?.descripcion, times8normal), prmsCellCenter)
            addCellTabla(tablaVolObra, new Paragraph(formatDate(date: it?.fecha, format: "dd-MM-yyyy"), times8normal), prmsCellCenter)
            addCellTabla(tablaVolObra, new Paragraph(it?.documentosAdjuntos, times8normal), prmsCellCenter)
            addCellTabla(tablaVolObra, new Paragraph(it?.memo, times8normal), prmsCellCenter)
            addCellTabla(tablaVolObra, new Paragraph(it?.estado?.codigo, times8normal), prmsCellCenter)

        }

        document.add(headers)
        document.add(tablaVolObra)

        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    //reporte registroTramite

    def reporteRegistroTramitexObra() {

        def obra = Obra.get(params.idObra)
        def usuario = session.usuario
        def tramites = Tramite.findAllByObra(obra)
        def prmsHeaderHoja = [border: Color.WHITE]
        def prmsHeaderHoja2 = [border: Color.WHITE, colspan: 9]
        def prmsHeader = [border: Color.WHITE, colspan: 7, bg: new Color(73, 175, 205),
                          align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]

        def prmsHeader2 = [border: Color.WHITE, colspan: 3, bg: new Color(73, 175, 205),
                           align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead = [border: Color.WHITE, bg: new Color(73, 175, 205),
                            align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHeadRight = [border: Color.WHITE, bg: new Color(73, 175, 205),
                                 align : Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsCellCenter = [border: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellRight = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsCellLeft = [border: Color.BLACK, valign: Element.ALIGN_MIDDLE]
        def prmsSubtotal = [border: Color.BLACK, colspan: 6,
                            align : Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsNum = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        def prms = [prmsHeaderHoja: prmsHeaderHoja, prmsHeader: prmsHeader, prmsHeader2: prmsHeader2,
                    prmsCellHead: prmsCellHead, prmsCell: prmsCellCenter, prmsCellLeft: prmsCellLeft, prmsSubtotal: prmsSubtotal, prmsNum: prmsNum, prmsHeaderHoja2: prmsHeaderHoja2, prmsCellRight: prmsCellRight, prmsCellHeadRight: prmsCellHeadRight]

        def baos = new ByteArrayOutputStream()
        def name = "registroTramite_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        Font times12bold = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font times10bold = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8bold = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        Font times8normal = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL)
        Font times10normal = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL)
        Font times10boldWhite = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8boldWhite = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        times8boldWhite.setColor(Color.WHITE)
        times10boldWhite.setColor(Color.WHITE)
        def fonts = [times12bold: times12bold, times10bold: times10bold, times8bold: times8bold,
                     times10boldWhite: times10boldWhite, times8boldWhite: times8boldWhite, times8normal: times8normal, times10normal: times10normal]

        Document document
        document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);
        document.open();
        document.addTitle("Presupuesto " + new Date().format("dd_MM_yyyy"));
        document.addSubject("Generado por el sistema Janus");
        document.addKeywords("tramite, janus, registroTramite");
        document.addAuthor("Janus");
        document.addCreator("Tedein SA");

        Paragraph headers = new Paragraph();
        addEmptyLine(headers, 1);
        headers.setAlignment(Element.ALIGN_CENTER);

        headers.add(new Paragraph((Auxiliar.get(1)?.titulo ?: '')))
        headers.add(new Paragraph(" "))
        headers.add(new Paragraph("TRÁMITES POR OBRA"))
        headers.add(new Paragraph(" "))
        headers.add(new Paragraph("Quito, " + formatDate(date: new Date(), format: "dd-MM-yyyy"), times10bold));
//        headers.add(new Paragraph(" ", times10bold));

        Paragraph txtObra = new Paragraph();
        addEmptyLine(txtObra, 1);
        txtObra.setAlignment(Element.ALIGN_LEFT);

        txtObra.add(new Paragraph("Obra: " + obra?.nombre, times10normal))
        txtObra.add(new Paragraph("Código: " + obra?.codigo, times10normal))
        txtObra.add(new Paragraph("Estado de la Obra: " + obra?.estadoObra, times10normal))
        txtObra.add(new Paragraph("Departamento: " + obra?.departamento, times10normal))
        txtObra.add(new Paragraph(" "))

        PdfPTable tablaVolObra = new PdfPTable(8);
        tablaVolObra.setWidthPercentage(100);


        tablaVolObra.setWidths(arregloEnteros([10, 20, 20, 14, 9, 12, 8, 7]))

        addCellTabla(tablaVolObra, new Paragraph("Tipo", times8bold), prmsCellHead)
        addCellTabla(tablaVolObra, new Paragraph("Envia", times8bold), prmsCellHead)
        addCellTabla(tablaVolObra, new Paragraph("Recibe", times8bold), prmsCellHead)
        addCellTabla(tablaVolObra, new Paragraph("Asunto", times8bold), prmsCellHead)
        addCellTabla(tablaVolObra, new Paragraph("Fecha", times8bold), prmsCellHead)
        addCellTabla(tablaVolObra, new Paragraph("Documentos", times8bold), prmsCellHead)
        addCellTabla(tablaVolObra, new Paragraph("N° Memo SAD", times8bold), prmsCellHead)
        addCellTabla(tablaVolObra, new Paragraph("Estado", times8bold), prmsCellHead)

        tramites.each {
            addCellTabla(tablaVolObra, new Paragraph(it?.tipoTramite?.descripcion, times8normal), prmsCellCenter)
            addCellTabla(tablaVolObra, new Paragraph(PersonasTramite.findByRolTramiteAndTramite(RolTramite.findByCodigo('DE'), it).persona.nombre + " " + PersonasTramite.findByRolTramiteAndTramite(RolTramite.findByCodigo('DE'), it).persona.apellido, times8normal), prmsCellLeft)
            addCellTabla(tablaVolObra, new Paragraph(PersonasTramite.findByRolTramiteAndTramite(RolTramite.findByCodigo('PARA'), it).persona.nombre + " " + PersonasTramite.findByRolTramiteAndTramite(RolTramite.findByCodigo('PARA'), it).persona.apellido, times8normal), prmsCellLeft)
            addCellTabla(tablaVolObra, new Paragraph(it?.descripcion, times8normal), prmsCellCenter)
            addCellTabla(tablaVolObra, new Paragraph(formatDate(date: it?.fecha, format: "dd-MM-yyyy"), times8normal), prmsCellCenter)
            addCellTabla(tablaVolObra, new Paragraph(it?.documentosAdjuntos, times8normal), prmsCellCenter)
            addCellTabla(tablaVolObra, new Paragraph(it?.memo, times8normal), prmsCellCenter)
            addCellTabla(tablaVolObra, new Paragraph(it?.estado?.codigo, times8normal), prmsCellCenter)
        }

        document.add(headers)
        document.add(txtObra)
        document.add(tablaVolObra)

        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def reporteDocumentosObra() {
        println "*****--->reporteDocumentosObra: $params"

        def cd
        def auxiliar = janus.Auxiliar.get(1);
        def nota

        if (params.notaValue && params.notaValue != '' && params.notaValue != 'null' && params.notaValue != 'undefined') {
            nota = Nota.get(params.notaValue)
        } else {
            nota = new Nota();
        }

        def obra = Obra.get(params.id)
        def paux = Parametros.get(1);
        def ivaTotal = 0
        def proyeccionTotal = 0
        def presupuestoTotal = 0;
        def inflacion = 0;
        def meses = 0;
        def firma = []
        def firmas
        def firmaFija
        def firmaCoordinador
        def personaElaboro
        def cuenta = 0;
        def cantidadMeses = params.meses

        def firma1 = obra?.responsableObra;
        def firma2 = obra?.revisor

        if (params.firmasFijas.trim().size() > 0) {
            firmaFija = params.firmasFijas.split(",")
        } else {
            firmaFija = []
        }
        cuenta = firma.size() + firmaFija.size() + 1

        def prmsHeaderHoja = [border: Color.WHITE]
        def prmsHeaderHoja2 = [border: Color.WHITE, colspan: 9]
        def prmsHeaderHoja3 = [border: Color.WHITE, colspan: 5]
        def prmsHeaderHoja4 = [border: Color.WHITE, bordeTop: "1"]
        def prmsHeaderHoja5 = [border: Color.WHITE, bordeBot: "1"]
        def prmsHeaderHoja6 = [border: Color.WHITE, bordeLeft: "1"]

        def prmsHeader = [border: Color.WHITE, colspan: 7, bg: new Color(73, 175, 205),
                          align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsHeader2 = [border: Color.WHITE, colspan: 3, bg: new Color(73, 175, 205),
                           align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead = [border: Color.WHITE, bg: Color.WHITE,
                            align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead2 = [border: Color.WHITE,
                             align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE, bordeTop: "1", bordeBot: "1"]
        def prmsCellHead3 = [border: Color.WHITE,
                             align : Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT, bordeTop: "1", bordeBot: "1"]
        def prmsCellHeadRight = [border: Color.WHITE, bg: new Color(73, 175, 205),
                                 align : Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsCellCenter = [border: Color.WHITE, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellCenterLeft = [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_LEFT]

        def prmsCellRight = [border: Color.WHITE, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsCellRight2 = [border: Color.WHITE, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT, bordeTop: "1", bordeBot: "1"]
        def prmsCellRightTop = [border: Color.WHITE, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT, bordeTop: "1"]
        def prmsCellRightBot = [border: Color.WHITE, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT, bordeBot: "1"]
        def prmsCellLeft = [border: Color.WHITE, valign: Element.ALIGN_MIDDLE]
        def prmsSubtotal = [border: Color.WHITE, colspan: 6,
                            align : Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsNum = [border: Color.WHITE, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        def prms = [prmsHeaderHoja : prmsHeaderHoja, prmsHeader: prmsHeader, prmsHeader2: prmsHeader2,
                    prmsCellHead   : prmsCellHead, prmsCell: prmsCellCenter, prmsCellLeft: prmsCellLeft, prmsSubtotal: prmsSubtotal, prmsNum: prmsNum,
                    prmsHeaderHoja2: prmsHeaderHoja2, prmsCellRight: prmsCellRight, prmsCellHeadRight: prmsCellHeadRight, prmsCellHead2: prmsCellHead2,
                    prmsCellRight2 : prmsCellRight2, prmsCellRightTop: prmsCellRightTop, prmsCellRightBot: prmsCellRightBot]

        def baos = new ByteArrayOutputStream()
        def name = "presupuesto_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        Font times12bold = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font times14bold = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font times13bold = new Font(Font.TIMES_ROMAN, 12);
        Font times18bold = new Font(Font.TIMES_ROMAN, 18, Font.BOLD);
        Font times10bold = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8bold = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        Font times8normal = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL)
        Font times10boldWhite = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8boldWhite = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        times8boldWhite.setColor(Color.WHITE)
        times10boldWhite.setColor(Color.WHITE)
        def fonts = [times12bold     : times12bold, times10bold: times10bold, times8bold: times8bold,
                     times10boldWhite: times10boldWhite, times8boldWhite: times8boldWhite, times8normal: times8normal, times18bold: times18bold]

        Document document
        document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);
        HeaderFooter footer1 = new HeaderFooter(new Phrase('', times8normal), true);
        footer1.setBorder(Rectangle.NO_BORDER);
        footer1.setAlignment(Element.ALIGN_CENTER);
        document.setFooter(footer1);
        document.open();
        document.addTitle("Presupuesto " + new Date().format("dd_MM_yyyy"));
        document.addSubject("Generado por el sistema Janus");
        document.addKeywords("documentosObra, janus, presupuesto");
        document.addAuthor("Janus");
        document.addCreator("Tedein SA");

        Paragraph headers = new Paragraph();
        addEmptyLine(headers, 1);
        headers.setAlignment(Element.ALIGN_CENTER);
        headers.add(new Paragraph(auxiliar.titulo, times14bold));
        if(session.perfil.id == 16){
            headers.add(new Paragraph(obra?.departamento?.codigo + " - Presupuesto borrador", times10bold));
        }else{
            headers.add(new Paragraph(auxiliar?.memo1, times12bold));
        }

        headers.add(new Paragraph(obra?.codigo + (obra?.estado == 'R' ? '' : ' - Presupuesto borrador') , times12bold));

        Paragraph headerFecha = new Paragraph();
        headerFecha.setAlignment(Element.ALIGN_RIGHT);
        addEmptyLine(headerFecha, 1);
        addEmptyLine(headerFecha, 1);
        headerFecha.add(new Paragraph("Quito, " + printFecha(obra?.fechaOficioSalida), times13bold));
        addEmptyLine(headerFecha, 1);

        Paragraph txtIzq = new Paragraph();
        addEmptyLine(txtIzq, 1);
        txtIzq.setAlignment(Element.ALIGN_LEFT);

        if (params.encabezado == "1" || params.encabezado == 1) {
            if (Persona.get(session.usuario.id).departamento?.codigo == 'CRFC') {
                if (obra?.departamentoDestino) {
                    def departamentoDestino = Departamento.get(obra?.departamentoDestino?.id)
                    def direccionDestino = departamentoDestino?.direccion
                    def funcionDirector = Funcion.findByCodigo('D')
                    def departamentosDestino = Departamento.findAllByDireccion(direccionDestino)
                    def personasDir = []
                    departamentosDestino.each {
                        personasDir += Persona.findAllByDepartamento(Departamento.get(it.id))
                    }

                    def rolDirector = PersonaRol.findByFuncionAndPersonaInList(funcionDirector, personasDir)
                    txtIzq.add(new Paragraph(rolDirector?.persona?.titulo?.toUpperCase() ?: '', times10bold));
                    txtIzq.add(new Paragraph(rolDirector?.persona?.nombre?.toUpperCase() + ' ' + rolDirector?.persona?.apellido?.toUpperCase(), times10bold));
                    txtIzq.add(new Paragraph('DIRECTOR - ' + rolDirector?.persona?.departamento?.direccion?.nombre?.toUpperCase(), times10bold));
                    txtIzq.add(new Paragraph('Presente.', times10bold));
                    txtIzq.add(new Paragraph(' ', times10bold));
                    txtIzq.add(new Paragraph('Sr. Director.', times10bold));
                } else {
                    txtIzq.add(new Paragraph('SR. DIRECTOR', times10bold));
                    txtIzq.add(new Paragraph('Presente.', times10bold));
                    txtIzq.add(new Paragraph(' ', times10bold));
                    txtIzq.add(new Paragraph('Sr. Director.', times10bold));
                }
            } else {
                if (obra?.departamentoDestino) {
                    def departamentoDestino = Departamento.get(obra?.departamentoDestino?.id)
                    def direccionDestino = departamentoDestino?.direccion
                    def funcionDirector = Funcion.findByCodigo('D')
                    def departamentosDestino = Departamento.findAllByDireccion(direccionDestino)
                    def personasDir = []

                    departamentosDestino.each {
                        personasDir += Persona.findAllByDepartamento(Departamento.get(it.id))
                    }

                    def rolDirector = PersonaRol.findByFuncionAndPersonaInList(funcionDirector, personasDir)

                    txtIzq.add(new Paragraph(rolDirector?.persona?.titulo?.toUpperCase() ?: '', times10bold));
                    txtIzq.add(new Paragraph(rolDirector?.persona?.nombre?.toUpperCase() + ' ' + rolDirector?.persona?.apellido?.toUpperCase(), times10bold));
                    txtIzq.add(new Paragraph('DIRECTOR - ' + rolDirector?.persona?.departamento?.direccion?.nombre?.toUpperCase(), times10bold));
                    txtIzq.add(new Paragraph('Presente.', times10bold));
                    txtIzq.add(new Paragraph(' ', times10bold));
                    txtIzq.add(new Paragraph('Sr. Director.', times10bold));
                } else {
                    txtIzq.add(new Paragraph('SR. DIRECTOR', times10bold));
                    txtIzq.add(new Paragraph('Presente.', times10bold));
                    txtIzq.add(new Paragraph(' ', times10bold));
                    txtIzq.add(new Paragraph('Sr. Director.', times10bold));
                }
            }
        } else {
            txtIzq.add(new Paragraph('PRESUPUESTO REFERENCIAL', times10bold));
        }

        if (params.tipoReporte == '1') {
            if(session.perfil.id == 16){
                txtIzq.add(new Paragraph("Tengo a bien presentar a usted el siguiente Presupuesto Borrador para la construcción de", times10bold));
                txtIzq.add(new Paragraph(" ", times10bold));
            }else{
                txtIzq.add(new Paragraph(auxiliar?.baseCont, times10bold));
                txtIzq.add(new Paragraph(" ", times10bold));
            }
        }
        if (params.tipoReporte == '2') {
            if(session.perfil.id == 16){
                txtIzq.add(new Paragraph("Tengo a bien presentar a usted el siguiente Presupuesto Borrador para la construcción de", times10bold));
                txtIzq.add(new Paragraph(" ", times10bold));
            }else{
                txtIzq.add(new Paragraph(auxiliar?.presupuestoRef, times10bold));
                txtIzq.add(new Paragraph(" ", times10bold));
            }
        }

        addEmptyLine(headers, 1);
        document.add(headers);
        document.add(headerFecha);
        document.add(txtIzq);

        PdfPTable tablaPresupuesto = new PdfPTable(7);
        tablaPresupuesto.setWidthPercentage(100);
        tablaPresupuesto.setWidths(arregloEnteros([12, 2, 13, 2, 8, 2, 26]))

        addCellTabla(tablaPresupuesto, new Paragraph("Requirente", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(obra?.departamento?.direccion?.nombre + ' - ' + obra?.departamento?.descripcion, times8normal), prmsHeaderHoja3)

        addCellTabla(tablaPresupuesto, new Paragraph("Código", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(obra?.codigo, times8normal), prmsHeaderHoja3)

        addCellTabla(tablaPresupuesto, new Paragraph("Memo Cant. Obra", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(obra?.memoCantidadObra, times8normal), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" ", times8normal), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph("Nombre", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(obra?.nombre, times8normal), prmsHeaderHoja)

        addCellTabla(tablaPresupuesto, new Paragraph("Fórmula N°", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(obra?.formulaPolinomica, times8normal), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" ", times8normal), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph("Tipo de Obra", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(obra?.tipoObjetivo?.descripcion, times8normal), prmsHeaderHoja)

        addCellTabla(tablaPresupuesto, new Paragraph("Cantón", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(obra?.parroquia?.canton?.nombre, times8normal), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" ", times8normal), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph("Parroquia", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(obra?.parroquia?.nombre, times8normal), prmsHeaderHoja)

        addCellTabla(tablaPresupuesto, new Paragraph("Comunidad", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(obra?.comunidad?.nombre, times8normal), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" ", times8normal), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph("Sitio", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(obra?.sitio, times8normal), prmsHeaderHoja)

        addCellTabla(tablaPresupuesto, new Paragraph("Fecha Act. Precios", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(printFecha(obra?.fechaPreciosRubros), times8normal), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" ", times8normal), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph("Responsable de las Cantidades", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph((obra?.inspector?.titulo ?: '')+ ' ' + obra?.inspector?.nombre + " " + obra?.inspector?.apellido, times8normal), prmsHeaderHoja)

        println "coordenadas: ${obra?.coordenadas}"
        PdfPTable tablaCoordenadas = new PdfPTable(3);
        tablaCoordenadas.setWidthPercentage(100);
        tablaCoordenadas.setWidths(arregloEnteros([17, 3, 72]))
        if(obra?.coordenadas != "S 0 0 W 0 0") {
            addCellTabla(tablaCoordenadas, new Paragraph("Coordenadas", times8bold), prmsHeaderHoja)
            addCellTabla(tablaCoordenadas, new Paragraph(" : ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaCoordenadas, new Paragraph(obra?.coordenadas, times8normal), prmsHeaderHoja)
        }

        PdfPTable tablaReferencia = new PdfPTable(3);
        tablaReferencia.setWidthPercentage(100);
        tablaReferencia.setWidths(arregloEnteros([17, 3, 72]))
        addCellTabla(tablaReferencia, new Paragraph("Referencia", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph(obra?.referencia, times8normal), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)

        PdfPTable tablaVolObra = new PdfPTable(6);
        tablaVolObra.setWidthPercentage(100);

        PdfPTable tablaCabeceraDoc = new PdfPTable(1);
        tablaVolObra.setWidthPercentage(100);

        PdfPTable tablaTotalSub = new PdfPTable(6);
        tablaVolObra.setWidthPercentage(100);

        PdfPTable tablaHeaderVol = new PdfPTable(6);
        tablaHeaderVol.setWidthPercentage(100);

        def detalle

        detalle = VolumenesObra.findAllByObra(obra, [sort: "orden"])
        preciosService.ac_rbroObra(obra.id)

        def precios = [:]
        def indirecto = obra.totales / 100
        def c;
        def total1 = 0;
        def total2 = 0;
        def totales
        def totalPresupuesto = 0;
        def totalPrueba = 0
        def totalPrueba1 = 0
        def valores = preciosService.rbro_pcun_v2(obra.id)
        def subPres = VolumenesObra.findAllByObra(obra, [sort: "orden"]).subPresupuesto.unique()

        tablaVolObra.setWidths(arregloEnteros([14, 43, 8, 10, 12, 15]))

        addCellTabla(tablaVolObra, new Paragraph("RUBRO N°", times8bold), prmsCellHead2)
        addCellTabla(tablaVolObra, new Paragraph("DESCRIPCIÓN", times8bold), prmsCellHead2)
        addCellTabla(tablaVolObra, new Paragraph("UNIDAD", times8bold), prmsCellHead2)
        addCellTabla(tablaVolObra, new Paragraph("CANTIDAD", times8bold), prmsCellHead3)
        addCellTabla(tablaVolObra, new Paragraph("P. UNITARIO", times8bold), prmsCellHead3)
        addCellTabla(tablaVolObra, new Paragraph("COSTO TOTAL", times8bold), prmsCellHead3)

        subPres.each { s ->
            total2 = 0

            addCellTabla(tablaVolObra, new Paragraph(s.descripcion, times10bold), [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_LEFT, colspan: 6])
            valores.each {

                if (it.sbprdscr == s.descripcion) {
                    def textoC = (it.rbronmbr ?: '')
                    textoC = textoC.decodeHTML()
                    it?.rbronmbr = textoC
                    addCellTabla(tablaVolObra, new Paragraph(it.rbrocdgo, times8normal), prmsCellLeft)
                    addCellTabla(tablaVolObra, new Paragraph(it.rbronmbr, times8normal), prmsCellLeft)
                    addCellTabla(tablaVolObra, new Paragraph(it.unddcdgo, times8normal), prmsCellRight)
                    addCellTabla(tablaVolObra, new Paragraph(g.formatNumber(number: it.vlobcntd, minFractionDigits:
                            2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight)
                    addCellTabla(tablaVolObra, new Paragraph(g.formatNumber(number: it.pcun, minFractionDigits:
                            2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight)
                    addCellTabla(tablaVolObra, new Paragraph(g.formatNumber(number: it.totl, minFractionDigits:
                            4, maxFractionDigits: 4, format: "##,##0", locale: "ec"), times8normal), prmsCellRight)
                    totales = it.totl
                    totalPrueba = total2 += totales
                    totalPresupuesto = (total1 += totales);
                } else {
                }
            }

            addCellTabla(tablaVolObra, new Paragraph("", times8bold), prmsCellCenter)
            addCellTabla(tablaVolObra, new Paragraph("", times8bold), prmsCellRight)
            addCellTabla(tablaVolObra, new Paragraph("", times8bold), prmsCellRight)
            addCellTabla(tablaVolObra, new Paragraph("", times8bold), prmsCellRight)
            addCellTabla(tablaVolObra, new Paragraph("SUBTOTAL:", times8bold), prmsCellLeft)
            addCellTabla(tablaVolObra, new Paragraph(g.formatNumber(number: totalPrueba, format: "##,##0", locale: "ec", maxFractionDigits: 4, minFractionDigits: 4), times8bold), prmsCellRight)

            addCellTabla(tablaVolObra, new Paragraph("", times8bold), prmsCellRight)
            addCellTabla(tablaVolObra, new Paragraph("", times8bold), prmsCellRight)
            addCellTabla(tablaVolObra, new Paragraph("", times8bold), prmsCellRight)
            addCellTabla(tablaVolObra, new Paragraph("", times8bold), prmsCellRight)
            addCellTabla(tablaVolObra, new Paragraph("", times8bold), prmsCellRight)
            addCellTabla(tablaVolObra, new Paragraph("", times8bold), prmsCellRight)
        }

        PdfPTable tablaTotal = new PdfPTable(6);
        tablaTotal.setWidthPercentage(100);

        tablaTotal.setWidths(arregloEnteros([85, 0, 0, 0, 0, 15]))

        addCellTabla(tablaTotal, new Paragraph("TOTAL DEL PRESUPUESTO: ", times8bold), prmsCellRight2)
        addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
        addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
        addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
        addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
        addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: totalPresupuesto, format: "##,##0", locale: "ec", maxFractionDigits: 4, minFractionDigits: 4), times8bold), prmsCellRight2)

        //solo IVA
        if (params.iva == 'true' && params.proyeccion == 'false') {
            ivaTotal = (totalPresupuesto * paux?.iva) / 100
            presupuestoTotal = totalPresupuesto + ivaTotal;

            addCellTabla(tablaTotal, new Paragraph("IVA " + paux?.iva + "% : ", times8bold), prmsCellRight)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: paux?.iva, format: "####.##", locale: "ec"), times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: ivaTotal, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellRight)

            addCellTabla(tablaTotal, new Paragraph("Presupuesto Total: ", times8bold), prmsCellRightBot)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: presupuestoTotal, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellRightBot)
        }
        //solo Proyeccion del reajuste

        if (params.proyeccion == 'true' && cantidadMeses.toInteger() >= 1 && params.iva == 'false') {

            inflacion = paux.inflacion
            meses = params.meses

            proyeccionTotal = (totalPresupuesto * ((inflacion / 1200) * meses.toInteger()))
            presupuestoTotal = totalPresupuesto + proyeccionTotal;

            addCellTabla(tablaTotal, new Paragraph("Proyeccion del Reajuste (período: " + meses + " meses, inflación: " + inflacion + " % ) :", times8bold), prmsCellRight)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: paux?.inflacion, format: "####.##", locale: "ec"), times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: proyeccionTotal, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellRight)

            addCellTabla(tablaTotal, new Paragraph("Presupuesto Total: ", times8bold), prmsCellRightBot)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: presupuestoTotal, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellRightBot)
        }

        if (params.proyeccion == 'true' && cantidadMeses.toInteger() >= 1 && params.iva == 'true') {
            inflacion = paux.inflacion
            meses = params.meses
            proyeccionTotal = (totalPresupuesto * ((inflacion / 1200) * meses.toInteger()))
            ivaTotal = ((totalPresupuesto + proyeccionTotal) * paux?.iva) / 100;
            presupuestoTotal = ((totalPresupuesto + proyeccionTotal) + ivaTotal)

            addCellTabla(tablaTotal, new Paragraph("Proyeccion del Reajuste (período: " + meses + " meses, inflación: " + inflacion + " % ) :", times8bold), prmsCellRight)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: paux?.inflacion, format: "####.##", locale: "ec"), times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: proyeccionTotal, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellRight)

            addCellTabla(tablaTotal, new Paragraph("IVA " + paux?.iva + "% : ", times8bold), prmsCellRight)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: paux?.iva, format: "##,##0", locale: "ec"), times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: ivaTotal, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellRight)

            addCellTabla(tablaTotal, new Paragraph("Presupuesto Total: ", times8bold), prmsCellRightBot)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: presupuestoTotal, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellRightBot)
        }

        Paragraph txtCondiciones = new Paragraph();
        addEmptyLine(txtCondiciones, 1);
        txtCondiciones.setAlignment(Element.ALIGN_LEFT);
        txtCondiciones.add(new Paragraph("CONDICIONES DEL CONTRATO", times10bold));
        txtCondiciones.add(new Paragraph(" ", times10bold));

        PdfPTable tablaCondiciones = new PdfPTable(3);
        tablaCondiciones.setWidthPercentage(100);
        tablaCondiciones.setWidths(arregloEnteros([7, 2, 60]))

        addCellTabla(tablaCondiciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCondiciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCondiciones, new Paragraph(" ", times8bold), prmsHeaderHoja)

        addCellTabla(tablaCondiciones, new Paragraph("Plazo de Ejecución", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCondiciones, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCondiciones, new Paragraph(g.formatNumber(number: obra?.plazoEjecucionMeses, format: "##", locale: "ec") + " mes(es)" + "  "  + obra?.plazoEjecucionDias + " día(s)", times8normal), prmsHeaderHoja)

        addCellTabla(tablaCondiciones, new Paragraph("Anticipo", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCondiciones, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCondiciones, new Paragraph(g.formatNumber(number: obra?.porcentajeAnticipo, format: "###", locale: "ec") + " %", times8normal), prmsHeaderHoja)

        addCellTabla(tablaCondiciones, new Paragraph("Responsable Técnico", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCondiciones, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCondiciones, new Paragraph((obra?.revisor?.titulo ?: '') + " " + (obra?.revisor?.nombre ?: '')+ " " + (obra?.revisor?.apellido ?: ''), times8normal), prmsHeaderHoja)

        document.add(tablaPresupuesto);
        document.add(tablaCoordenadas);
        document.add(tablaReferencia);
        document.add(tablaVolObra)
        document.add(tablaTotal);


        PdfPTable tablaRetenciones = new PdfPTable(3);
        Paragraph txtRetenciones = new Paragraph();
        Paragraph txtDatos = new Paragraph();
        Paragraph txtDatos1 = new Paragraph();


        PdfPTable tablaDatos = new PdfPTable(6);
        tablaDatos.setWidthPercentage(100);
        tablaDatos.setWidths(arregloEnteros([10, 2, 30, 6, 2, 10]))


        if (params.forzarValue == '1') {
            Paragraph headerForzar = new Paragraph();
            addEmptyLine(headerForzar, 1);
            headerForzar.setAlignment(Element.ALIGN_CENTER);
            headerForzar.add(new Paragraph(auxiliar.titulo, times12bold));
            if (obra?.oficioSalida == null) {
                headerForzar.add(new Paragraph("Informe N°:" + " ", times10bold));
            } else {
                headerForzar.add(new Paragraph("Informe N°:" + obra?.oficioSalida, times10bold));
            }

            headerForzar.add(new Paragraph(" ", times12bold));
            headerForzar.add(new Paragraph(" ", times12bold));

            tablaRetenciones.setWidthPercentage(100);
            tablaRetenciones.setWidths(arregloEnteros([7, 2, 60]))

            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)

            addCellTabla(tablaRetenciones, new Paragraph("Notas", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(nota?.texto, times8normal), prmsHeaderHoja)

            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(auxiliar?.notaAuxiliar, times8normal), prmsHeaderHoja)

            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(nota?.adicional, times8normal), prmsHeaderHoja)

            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)

            txtDatos.setAlignment(Element.ALIGN_CENTER);
            txtDatos.add(new Paragraph("DATOS PARA EL PRESUPUESTO", times8bold));
            txtDatos.add(new Paragraph(" ", times8bold));

            addEmptyLine(txtRetenciones, 1);
            txtRetenciones.setAlignment(Element.ALIGN_LEFT);
            txtRetenciones.add(new Paragraph("Atentamente, ", times8bold));
            txtRetenciones.add(new Paragraph(" ", times8bold));
        } else {
            tablaRetenciones.setWidthPercentage(100);
            tablaRetenciones.setWidths(arregloEnteros([7, 2, 60]))

            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)

            addCellTabla(tablaRetenciones, new Paragraph("Notas", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(nota?.texto, times8normal), prmsHeaderHoja)

            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(auxiliar?.notaAuxiliar, times8normal), prmsHeaderHoja)

            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(nota?.adicional, times8normal), prmsHeaderHoja)


            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)

            txtDatos.setAlignment(Element.ALIGN_CENTER);
            txtDatos.add(new Paragraph("DATOS PARA EL PRESUPUESTO", times8bold));
            txtDatos.add(new Paragraph(" ", times8bold));

            if(obra?.distanciaPeso != 0){
                addCellTabla(tablaDatos, new Paragraph("Cantón", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(" : ", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(obra?.lugar?.descripcion, times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph("Distancia", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(" : ", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(g.formatNumber(number: obra?.distanciaPeso, format: "##,##0", minFractionDigits: 2, maxFractionDigits: 2, locale: "ec") + ' Km', times8normal), prmsHeaderHoja)
            }

            if(obra?.distanciaPesoEspecial != 0){
                addCellTabla(tablaDatos, new Paragraph("Especial", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(" : ", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(obra?.listaPeso1?.descripcion, times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph("Distancia", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(" : ", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(g.formatNumber(number: obra?.distanciaPesoEspecial, format: "##,##0", minFractionDigits: 2, locale: "ec" ) + ' Km', times8normal), prmsHeaderHoja)
            }

            if(obra?.distanciaVolumenMejoramiento != 0){
                addCellTabla(tablaDatos, new Paragraph("Mejoramiento", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(" : ", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(obra?.listaVolumen1?.descripcion, times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph("Distancia", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(" : ", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(g.formatNumber(number: obra?.distanciaVolumenMejoramiento, format: "##,##0", minFractionDigits: 2, maxFractionDigits: 2, locale: "ec") + ' Km', times8normal), prmsHeaderHoja)
            }

            if(obra?.distanciaVolumen != 0){
                addCellTabla(tablaDatos, new Paragraph("Petreos Hormigones", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(" : ", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(obra?.listaVolumen0?.descripcion, times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph("Distancia", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(" : ", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(g.formatNumber(number: obra?.distanciaVolumen, format: "##,##0", minFractionDigits: 2, maxFractionDigits: 2, locale: "ec") + ' Km', times8normal), prmsHeaderHoja)
            }

            if(obra?.distanciaVolumenCarpetaAsfaltica != 0){
                addCellTabla(tablaDatos, new Paragraph("Carpeta Asfáltica", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(" : ", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(obra?.listaVolumen2?.descripcion, times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph("Distancia", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(" : ", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(g.formatNumber(number: obra?.distanciaVolumenCarpetaAsfaltica, format: "##,##0", minFractionDigits: 2, maxFractionDigits: 2, locale: "ec") + ' Km', times8normal), prmsHeaderHoja)
            }

            if(obra?.distanciaDesalojo != 0){
                addCellTabla(tablaDatos, new Paragraph("Distancia General de Transporte", times8bold), prmsHeaderHoja + [colspan: 3] )
                addCellTabla(tablaDatos, new Paragraph("Distancia", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(" : ", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(g.formatNumber(number: obra?.distanciaDesalojo, format: "##,##0", minFractionDigits: 2, maxFractionDigits: 2, locale: "ec") + ' Km', times8normal), prmsHeaderHoja)
            }

            txtDatos1.setAlignment(Element.ALIGN_CENTER);
            txtDatos1.add(new Paragraph("COSTO INDIRECTO TOTAL : ${obra?.totales} %", times8bold));
            txtDatos1.add(new Paragraph(" ", times8bold));
            addEmptyLine(txtRetenciones, 1);
            txtRetenciones.setAlignment(Element.ALIGN_LEFT);
            txtRetenciones.add(new Paragraph("Atentamente, ", times8bold));
            txtRetenciones.add(new Paragraph(" ", times8bold));
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
        addCellTabla(tablaFirmas, new Paragraph(" ", times8bold), prmsHeaderHoja)

        def arregloFirmas = []

        def el1
        def el2

        if(firmaFija.size() == 3){
            el1 = firmaFija[1]
            el2 = firmaFija[2]

            firmaFija[0] = el1
            firmaFija[1] = el2
        }

        firmaFija.each {f->
            firmas = Persona.get(f)
            arregloFirmas += firmas
        }


        if(params.firmaElaboro){
            personaElaboro = Persona.get(params.firmaElaboro)
            addCellTabla(tablaFirmas, new Paragraph((personaElaboro?.titulo?.toUpperCase() ?: '') + " " + (personaElaboro?.nombre.toUpperCase() ?: '' ) + " " + (personaElaboro?.apellido?.toUpperCase() ?: ''), times8bold), prmsHeaderHoja)
        }else{
            addCellTabla(tablaFirmas, new Paragraph(" ", times8bold), prmsHeaderHoja)
        }

        addCellTabla(tablaFirmas, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph("ELABORÓ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(personaElaboro?.departamento?.descripcion?.toUpperCase() ?: '', times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(" ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(" ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(" ", times10bold), prmsHeaderHoja)

        //sumilla

        PdfPTable table3 = new PdfPTable(2);
        table3.setHorizontalAlignment(Element.ALIGN_LEFT)
        table3.setWidthPercentage(30);
        table3.setWidths(arregloEnteros([15, 15]))
        PdfPTable nested2 = new PdfPTable(1);
        PdfPTable nested3 = new PdfPTable(1);
        PdfPCell cell1 = new PdfPCell(new Paragraph("SUMILLA", times8bold));

        cell1.setColspan(2);
        table3.addCell(cell1)
        PdfPCell cell4 = new PdfPCell(new Paragraph((obra?.responsableObra?.titulo?.toUpperCase() ?: '') + " " + (obra?.responsableObra?.nombre?.toUpperCase() ?: '')+ " " + (obra?.responsableObra?.apellido?.toUpperCase() ?: ''), times8bold));
        cell4.setFixedHeight(25);
        PdfPCell cell6 = new PdfPCell(new Paragraph("ELABORÓ", times8bold));
        nested2.addCell(cell4)
        nested2.addCell(cell6)
        table3.addCell(new PdfPCell(nested2));
        table3.addCell(new PdfPCell(nested3));

        //prueba de separacion de parrafos

        PdfPTable apendice = new PdfPTable(1);
        apendice.setWidthPercentage(100)
        apendice.setWidths(arregloEnteros([100]))
        apendice.setSpacingBefore(30);


        PdfPTable nested8 = new PdfPTable(1);
        PdfPCell celda1 = new PdfPCell()
        celda1.setBorder(0)
        celda1.addElement(tablaCondiciones)
        celda1.addElement(tablaRetenciones)
        celda1.addElement(txtDatos)
        celda1.addElement(tablaDatos)
        celda1.addElement(txtDatos1)
        celda1.addElement(txtRetenciones)
        celda1.addElement(tablaFirmas)
        celda1.setColspan(1)

        apendice.addCell(celda1)
        apendice.setKeepTogether(true);
        document.add(apendice)

        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }


    def reporteDocumentosObraDscr() {

        def cd
        def auxiliar = janus.Auxiliar.get(1);
        def nota

        if (params.notaValue && params.notaValue != '' && params.notaValue != 'null' && params.notaValue != 'undefined') {
            nota = Nota.get(params.notaValue)
        } else {
            nota = new Nota();
        }

        def obra = Obra.get(params.id)
        def paux = Parametros.get(1);
        def ivaTotal = 0
        def proyeccionTotal = 0
        def presupuestoTotal = 0;
        def inflacion = 0;
        def meses = 0;
        def firma = []
        def firmas
        def firmaFija
        def firmaCoordinador
        def personaElaboro
        def cuenta = 0;
        def cantidadMeses = params.meses
        def firma1 = obra?.responsableObra;
        def firma2 = obra?.revisor

        if (params.firmasFijas.trim().size() > 0) {
            firmaFija = params.firmasFijas.split(",")
        } else {
            firmaFija = []
        }

        cuenta = firma.size() + firmaFija.size() + 1

        def prmsHeaderHoja = [border: Color.WHITE]
        def prmsHeaderHoja2 = [border: Color.WHITE, colspan: 9]
        def prmsHeaderHoja3 = [border: Color.WHITE, colspan: 5]
        def prmsHeaderHoja4 = [border: Color.WHITE, bordeTop: "1"]
        def prmsHeaderHoja5 = [border: Color.WHITE, bordeBot: "1"]
        def prmsHeaderHoja6 = [border: Color.WHITE, bordeLeft: "1"]

        def prmsHeader = [border: Color.WHITE, colspan: 7, bg: new Color(73, 175, 205),
                          align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsHeader2 = [border: Color.WHITE, colspan: 3, bg: new Color(73, 175, 205),
                           align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead = [border: Color.WHITE, bg: Color.WHITE,
                            align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead2 = [border: Color.WHITE,
                             align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE, bordeTop: "1", bordeBot: "1"]
        def prmsCellHead3 = [border: Color.WHITE,
                             align : Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT, bordeTop: "1", bordeBot: "1"]
        def prmsCellHeadRight = [border: Color.WHITE, bg: new Color(73, 175, 205),
                                 align : Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsCellCenter = [border: Color.WHITE, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellCenterLeft = [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_LEFT]

        def prmsCellRight = [border: Color.WHITE, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsCellRight2 = [border: Color.WHITE, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT, bordeTop: "1", bordeBot: "1"]
        def prmsCellRightTop = [border: Color.WHITE, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT, bordeTop: "1"]
        def prmsCellRightBot = [border: Color.WHITE, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT, bordeBot: "1"]
        def prmsCellLeft = [border: Color.WHITE, valign: Element.ALIGN_MIDDLE]
        def prmsSubtotal = [border: Color.WHITE, colspan: 6,
                            align : Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsNum = [border: Color.WHITE, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        def prms = [prmsHeaderHoja : prmsHeaderHoja, prmsHeader: prmsHeader, prmsHeader2: prmsHeader2,
                    prmsCellHead   : prmsCellHead, prmsCell: prmsCellCenter, prmsCellLeft: prmsCellLeft, prmsSubtotal: prmsSubtotal, prmsNum: prmsNum,
                    prmsHeaderHoja2: prmsHeaderHoja2, prmsCellRight: prmsCellRight, prmsCellHeadRight: prmsCellHeadRight, prmsCellHead2: prmsCellHead2,
                    prmsCellRight2 : prmsCellRight2, prmsCellRightTop: prmsCellRightTop, prmsCellRightBot: prmsCellRightBot]

        def baos = new ByteArrayOutputStream()
        def name = "presupuestoConDescripcion_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        Font times14bold = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font times12bold = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font times13bold = new Font(Font.TIMES_ROMAN, 12);
        Font times18bold = new Font(Font.TIMES_ROMAN, 18, Font.BOLD);
        Font times10bold = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8bold = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        Font times8normal = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL)
        Font times10boldWhite = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8boldWhite = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        times8boldWhite.setColor(Color.WHITE)
        times10boldWhite.setColor(Color.WHITE)
        def fonts = [times12bold     : times12bold, times10bold: times10bold, times8bold: times8bold,
                     times10boldWhite: times10boldWhite, times8boldWhite: times8boldWhite, times8normal: times8normal, times18bold: times18bold]

        Document document
        document = new Document(PageSize.A4.rotate());

        def pdfw = PdfWriter.getInstance(document, baos);
        HeaderFooter footer1 = new HeaderFooter(new Phrase('', times8normal), true);
        footer1.setBorder(Rectangle.NO_BORDER);
        footer1.setAlignment(Element.ALIGN_CENTER);
        document.setFooter(footer1);
        document.open();

//        document.setMargins(2,2,2,2)
        document.addTitle("Presupuesto " + new Date().format("dd_MM_yyyy"));
        document.addSubject("Generado por el sistema Janus");
        document.addKeywords("documentosObra, janus, presupuesto");
        document.addAuthor("Janus");
        document.addCreator("Tedein SA");

        Paragraph headers = new Paragraph();
        addEmptyLine(headers, 1);
        headers.setAlignment(Element.ALIGN_CENTER);
        headers.add(new Paragraph(auxiliar?.titulo, times14bold));

        if(session.perfil.id == 16){
            headers.add(new Paragraph(obra?.departamento?.codigo + " - Presupuesto borrador", times12bold));
        }else{
            headers.add(new Paragraph(auxiliar?.memo1, times12bold));
        }

        headers.add(new Paragraph(obra?.codigo, times12bold));

        Paragraph headerFecha = new Paragraph();
        headerFecha.setAlignment(Element.ALIGN_RIGHT);
        addEmptyLine(headerFecha, 1);
        addEmptyLine(headerFecha, 1);
        headerFecha.add(new Paragraph("Quito, " + printFecha(obra?.fechaOficioSalida), times13bold));
        addEmptyLine(headerFecha, 1);

        Paragraph txtIzq = new Paragraph();
        addEmptyLine(txtIzq, 1);
        txtIzq.setAlignment(Element.ALIGN_LEFT);

        if (params.encabezado == "1" || params.encabezado == 1) {
            if (Persona.get(session.usuario.id).departamento?.codigo == 'CRFC') {
                if (obra?.departamentoDestino) {
                    def departamentoDestino = Departamento.get(obra?.departamentoDestino?.id)
                    def direccionDestino = departamentoDestino?.direccion
                    def funcionDirector = Funcion.findByCodigo('D')
                    def departamentosDestino = Departamento.findAllByDireccion(direccionDestino)
                    def personasDir = []
                    departamentosDestino.each {
                        personasDir += Persona.findAllByDepartamento(Departamento.get(it.id))
                    }

                    def rolDirector = PersonaRol.findByFuncionAndPersonaInList(funcionDirector, personasDir)
                    txtIzq.add(new Paragraph(rolDirector?.persona?.titulo?.toUpperCase() ?: '', times10bold));
                    txtIzq.add(new Paragraph(rolDirector?.persona?.nombre?.toUpperCase() + ' ' + rolDirector?.persona?.apellido?.toUpperCase(), times10bold));
                    txtIzq.add(new Paragraph('DIRECTOR - ' + rolDirector?.persona?.departamento?.direccion?.nombre?.toUpperCase(), times10bold));
                    txtIzq.add(new Paragraph('Presente.', times10bold));
                    txtIzq.add(new Paragraph(' ', times10bold));
                    txtIzq.add(new Paragraph('Sr. Director.', times10bold));
                } else {
                    txtIzq.add(new Paragraph('SR. DIRECTOR', times10bold));
                    txtIzq.add(new Paragraph('Presente.', times10bold));
                    txtIzq.add(new Paragraph(' ', times10bold));
                    txtIzq.add(new Paragraph('Sr. Director.', times10bold));
                }

            } else {
                if (obra?.departamentoDestino) {
                    def departamentoDestino = Departamento.get(obra?.departamentoDestino?.id)
                    def direccionDestino = departamentoDestino?.direccion
                    def funcionDirector = Funcion.findByCodigo('D')
                    def departamentosDestino = Departamento.findAllByDireccion(direccionDestino)
                    def personasDir = []
                    departamentosDestino.each {
                        personasDir += Persona.findAllByDepartamento(Departamento.get(it.id))
                    }
                    def rolDirector = PersonaRol.findByFuncionAndPersonaInList(funcionDirector, personasDir)
                    txtIzq.add(new Paragraph(rolDirector?.persona?.titulo?.toUpperCase() ?: '', times10bold));
                    txtIzq.add(new Paragraph(rolDirector?.persona?.nombre?.toUpperCase() + ' ' + rolDirector?.persona?.apellido?.toUpperCase(), times10bold));
                    txtIzq.add(new Paragraph('DIRECTOR - ' + rolDirector?.persona?.departamento?.direccion?.nombre?.toUpperCase(), times10bold));
                    txtIzq.add(new Paragraph('Presente.', times10bold));
                    txtIzq.add(new Paragraph(' ', times10bold));
                    txtIzq.add(new Paragraph('Sr. Director.', times10bold));
                } else {
                    txtIzq.add(new Paragraph('SR. DIRECTOR', times10bold));
                    txtIzq.add(new Paragraph('Presente.', times10bold));
                    txtIzq.add(new Paragraph(' ', times10bold));
                    txtIzq.add(new Paragraph('Sr. Director.', times10bold));
                }
            }
        } else {
            txtIzq.add(new Paragraph('PRESUPUESTO REFERENCIAL', times10bold));
        }

        if (params.tipoReporte == '1') {
            if(session.perfil.id == 16){
                txtIzq.add(new Paragraph("Tengo a bien presentar a usted el siguiente Presupuesto Borrador para la construcción de", times10bold));
                txtIzq.add(new Paragraph(" ", times10bold));
            }else{
                txtIzq.add(new Paragraph(auxiliar?.baseCont, times10bold));
                txtIzq.add(new Paragraph(" ", times10bold));
            }
        }
        if (params.tipoReporte == '2') {
            if(session.perfil.id == 16){
                txtIzq.add(new Paragraph("Tengo a bien presentar a usted el siguiente Presupuesto Borrador para la construcción de", times10bold));
                txtIzq.add(new Paragraph(" ", times10bold));
            }else{
                txtIzq.add(new Paragraph(auxiliar?.presupuestoRef, times10bold));
                txtIzq.add(new Paragraph(" ", times10bold));
            }
        }

        addEmptyLine(headers, 1);
        document.add(headers);
        document.add(headerFecha);
        document.add(txtIzq);

        PdfPTable tablaPresupuesto = new PdfPTable(7);
        tablaPresupuesto.setWidthPercentage(100);
        tablaPresupuesto.setWidths(arregloEnteros([12, 2, 13, 2, 8, 2, 26]))

        addCellTabla(tablaPresupuesto, new Paragraph("Requirente", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(obra?.departamento?.direccion?.nombre + ' - ' + obra?.departamento?.descripcion, times8normal), prmsHeaderHoja3)

        addCellTabla(tablaPresupuesto, new Paragraph("Código", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(obra?.codigo, times8normal), prmsHeaderHoja3)

        addCellTabla(tablaPresupuesto, new Paragraph("Memo Cant. Obra", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(obra?.memoCantidadObra, times8normal), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" ", times8normal), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph("Nombre", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(obra?.nombre, times8normal), prmsHeaderHoja)

        addCellTabla(tablaPresupuesto, new Paragraph("Fórmula N°", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(obra?.formulaPolinomica, times8normal), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" ", times8normal), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph("Tipo de Obra", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(obra?.tipoObjetivo?.descripcion, times8normal), prmsHeaderHoja)

        addCellTabla(tablaPresupuesto, new Paragraph("Cantón", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(obra?.parroquia?.canton?.nombre, times8normal), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" ", times8normal), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph("Parroquia", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(obra?.parroquia?.nombre, times8normal), prmsHeaderHoja)

        addCellTabla(tablaPresupuesto, new Paragraph("Comunidad", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(obra?.comunidad?.nombre, times8normal), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" ", times8normal), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph("Sitio", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(obra?.sitio, times8normal), prmsHeaderHoja)

        addCellTabla(tablaPresupuesto, new Paragraph("Fecha Act. Precios", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(printFecha(obra?.fechaPreciosRubros), times8normal), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" ", times8normal), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph("Responsable de las Cantidades", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph((obra?.inspector?.titulo ?: '')+ ' ' + obra?.inspector?.nombre + " " + obra?.inspector?.apellido, times8normal), prmsHeaderHoja)

        PdfPTable tablaCoordenadas = new PdfPTable(3);
        tablaCoordenadas.setWidthPercentage(100);
        tablaCoordenadas.setWidths(arregloEnteros([17, 3, 72]))
        addCellTabla(tablaCoordenadas, new Paragraph("Coordenadas", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCoordenadas, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCoordenadas, new Paragraph(obra?.coordenadas, times8normal), prmsHeaderHoja)

        PdfPTable tablaReferencia = new PdfPTable(3);
        tablaReferencia.setWidthPercentage(100);
        tablaReferencia.setWidths(arregloEnteros([17, 3, 72]))
        addCellTabla(tablaReferencia, new Paragraph("Referencia", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph(obra?.referencia, times8normal), prmsHeaderHoja)

        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)

        PdfPTable tablaVolObra = new PdfPTable(8);
        tablaVolObra.setWidthPercentage(100);

        PdfPTable tablaCabeceraDoc = new PdfPTable(1);
        tablaVolObra.setWidthPercentage(100);

        PdfPTable tablaTotalSub = new PdfPTable(6);
        tablaVolObra.setWidthPercentage(100);

        PdfPTable tablaHeaderVol = new PdfPTable(6);
        tablaHeaderVol.setWidthPercentage(100);

        def detalle

        detalle = VolumenesObra.findAllByObra(obra, [sort: "orden"])
        preciosService.ac_rbroObra(obra.id)

        def precios = [:]
        def indirecto = obra.totales / 100
        def c;
        def total1 = 0;
        def total2 = 0;
        def totales
        def totalPresupuesto = 0;
        def totalPrueba = 0
        def totalPrueba1 = 0
        def totalRelativo1 = 0
        def totalRelativo2 = 0
        def finalRelativo = 0
        def totalVae1 = 0
        def totalVae2 = 0
        def finalVae = 0
        def valores = preciosService.rbro_pcun_vae(obra.id)
        def subPres = VolumenesObra.findAllByObra(obra, [sort: "orden"]).subPresupuesto.unique()

        tablaVolObra.setWidths(arregloEnteros([14,13, 42, 20, 10, 12, 12,12]))

        addCellTabla(tablaVolObra, new Paragraph("CÓDIGO", times8bold), prmsCellHead2)
        addCellTabla(tablaVolObra, new Paragraph("ESPEC.", times8bold), prmsCellHead2)
        addCellTabla(tablaVolObra, new Paragraph("RUBRO", times8bold), prmsCellHead2)
        addCellTabla(tablaVolObra, new Paragraph("DESCRIPCIÓN", times8bold), prmsCellHead2)
        addCellTabla(tablaVolObra, new Paragraph("UNIDAD", times8bold), prmsCellHead2)
        addCellTabla(tablaVolObra, new Paragraph("CANTIDAD", times8bold), prmsCellHead3)
        addCellTabla(tablaVolObra, new Paragraph("P. U.", times8bold), prmsCellHead3)
        addCellTabla(tablaVolObra, new Paragraph("C. TOTAL", times8bold), prmsCellHead3)

        subPres.each { s ->
            total2 = 0
            addCellTabla(tablaVolObra, new Paragraph(s.descripcion, times10bold), [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_LEFT, colspan: 8])
            valores.each {
                if (it.sbprdscr == s.descripcion) {
                    def textoC = (it.rbronmbr ?: '')
                    textoC = textoC.decodeHTML()
                    it?.rbronmbr = textoC
                    addCellTabla(tablaVolObra, new Paragraph(it.rbrocdgo, times8normal), prmsCellLeft)
                    addCellTabla(tablaVolObra, new Paragraph(it.itemcdes, times8normal), prmsCellLeft)
                    addCellTabla(tablaVolObra, new Paragraph(it.rbronmbr, times8normal), prmsCellLeft)
                    addCellTabla(tablaVolObra, new Paragraph(it.vlobdscr, times8normal), prmsCellLeft)
                    addCellTabla(tablaVolObra, new Paragraph(it.unddcdgo, times8normal), prmsCellCenter)
                    addCellTabla(tablaVolObra, new Paragraph(g.formatNumber(number: it.vlobcntd, minFractionDigits:
                            2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight)
                    addCellTabla(tablaVolObra, new Paragraph(g.formatNumber(number: it.pcun, minFractionDigits:
                            2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight)
                    addCellTabla(tablaVolObra, new Paragraph(g.formatNumber(number: it.totl, minFractionDigits:
                            4, maxFractionDigits: 4, format: "##,##0", locale: "ec"), times8normal), prmsCellRight)

                    totales = it.totl
                    totalPrueba = total2 += totales
                    totalPresupuesto = (total1 += totales);

                    totalRelativo1 = it.relativo
                    finalRelativo = (totalRelativo2 += totalRelativo1)

                    totalVae1= it.vae_totl?:0
                    finalVae = (totalVae2 += totalVae1)
                } else {  }
            }
            addCellTabla(tablaVolObra, new Paragraph("", times8bold), prmsCellCenter)
            addCellTabla(tablaVolObra, new Paragraph("", times8bold), prmsCellRight)
            addCellTabla(tablaVolObra, new Paragraph("", times8bold), prmsCellRight)
            addCellTabla(tablaVolObra, new Paragraph("", times8bold), prmsCellRight)
            addCellTabla(tablaVolObra, new Paragraph("", times8bold), prmsCellRight)
            addCellTabla(tablaVolObra, new Paragraph("", times8bold), prmsCellRight)
            addCellTabla(tablaVolObra, new Paragraph("SUBTOTAL:", times8bold), prmsCellRight)
            addCellTabla(tablaVolObra, new Paragraph(g.formatNumber(number: totalPrueba, format: "##,##0", locale: "ec", maxFractionDigits: 4, minFractionDigits: 4), times8bold), prmsCellRight)

            addCellTabla(tablaVolObra, new Paragraph("", times8bold), prmsCellRight)
            addCellTabla(tablaVolObra, new Paragraph("", times8bold), prmsCellRight)
            addCellTabla(tablaVolObra, new Paragraph("", times8bold), prmsCellRight)
            addCellTabla(tablaVolObra, new Paragraph("", times8bold), prmsCellRight)
            addCellTabla(tablaVolObra, new Paragraph("", times8bold), prmsCellRight)
            addCellTabla(tablaVolObra, new Paragraph("", times8bold), prmsCellRight)
            addCellTabla(tablaVolObra, new Paragraph("", times8bold), prmsCellRight)
            addCellTabla(tablaVolObra, new Paragraph("", times8bold), prmsCellRight)
        }

        PdfPTable tablaTotal = new PdfPTable(8);
        tablaTotal.setWidthPercentage(100);
        tablaTotal.setWidths(arregloEnteros([0,0,0,0,0,90,20,8]))

        addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead2)
        addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead2)
        addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead2)
        addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead2)
        addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead2)
        addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead2)
        addCellTabla(tablaTotal, new Paragraph("TOTAL DEL PRESUPUESTO: ", times8bold), prmsCellHead2)
        addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: totalPresupuesto, format: "##,##0", locale: "ec", maxFractionDigits: 4, minFractionDigits: 4), times8bold), prmsCellRight2)

        //solo IVA
        if (params.iva == 'true' && params.proyeccion == 'false') {
            ivaTotal = (totalPresupuesto * paux?.iva) / 100
            presupuestoTotal = totalPresupuesto + ivaTotal;

            addCellTabla(tablaTotal, new Paragraph("IVA " + paux?.iva + "% : ", times8bold), prmsCellRight)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: paux?.iva, format: "####.##", locale: "ec"), times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: ivaTotal, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellRight)

            addCellTabla(tablaTotal, new Paragraph("Presupuesto Total: ", times8bold), prmsCellRightBot)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: presupuestoTotal, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellRightBot)
        }
        //solo Proyeccion del reajuste

        if (params.proyeccion == 'true' && cantidadMeses.toInteger() >= 1 && params.iva == 'false') {
            inflacion = paux.inflacion
            meses = params.meses

            proyeccionTotal = (totalPresupuesto * ((inflacion / 1200) * meses.toInteger()))
            presupuestoTotal = totalPresupuesto + proyeccionTotal;

            addCellTabla(tablaTotal, new Paragraph("Proyeccion del Reajuste (período: " + meses + " meses, inflación: " + inflacion + " % ) :", times8bold), prmsCellRight)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: paux?.inflacion, format: "####.##", locale: "ec"), times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: proyeccionTotal, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellRight)

            addCellTabla(tablaTotal, new Paragraph("Presupuesto Total: ", times8bold), prmsCellRightBot)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: presupuestoTotal, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellRightBot)
        }

        if (params.proyeccion == 'true' && cantidadMeses.toInteger() >= 1 && params.iva == 'true') {
            inflacion = paux.inflacion
            meses = params.meses
            proyeccionTotal = (totalPresupuesto * ((inflacion / 1200) * meses.toInteger()))
            ivaTotal = ((totalPresupuesto + proyeccionTotal) * paux?.iva) / 100;
            presupuestoTotal = ((totalPresupuesto + proyeccionTotal) + ivaTotal)

            addCellTabla(tablaTotal, new Paragraph("Proyeccion del Reajuste (período: " + meses + " meses, inflación: " + inflacion + " % ) :", times8bold), prmsCellRight)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: paux?.inflacion, format: "####.##", locale: "ec"), times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: proyeccionTotal, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellRight)

            addCellTabla(tablaTotal, new Paragraph("IVA " + paux?.iva + "% : ", times8bold), prmsCellRight)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: paux?.iva, format: "##,##0", locale: "ec"), times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: ivaTotal, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellRight)

            addCellTabla(tablaTotal, new Paragraph("Presupuesto Total: ", times8bold), prmsCellRightBot)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: presupuestoTotal, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellRightBot)
        }

        Paragraph txtCondiciones = new Paragraph();
        addEmptyLine(txtCondiciones, 1);
        txtCondiciones.setAlignment(Element.ALIGN_LEFT);
        txtCondiciones.add(new Paragraph("CONDICIONES DEL CONTRATO", times10bold));
        txtCondiciones.add(new Paragraph(" ", times10bold));

        PdfPTable tablaCondiciones = new PdfPTable(3);
        tablaCondiciones.setWidthPercentage(100);
        tablaCondiciones.setWidths(arregloEnteros([7, 2, 60]))

        addCellTabla(tablaCondiciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCondiciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCondiciones, new Paragraph(" ", times8bold), prmsHeaderHoja)

        addCellTabla(tablaCondiciones, new Paragraph("Plazo de Ejecución", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCondiciones, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCondiciones, new Paragraph(g.formatNumber(number: obra?.plazoEjecucionMeses, format: "##", locale: "ec") + " mes(es)" + "  "  + obra?.plazoEjecucionDias + " día(s)", times8normal), prmsHeaderHoja)

        addCellTabla(tablaCondiciones, new Paragraph("Anticipo", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCondiciones, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCondiciones, new Paragraph(g.formatNumber(number: obra?.porcentajeAnticipo, format: "###", locale: "ec") + " %", times8normal), prmsHeaderHoja)

        addCellTabla(tablaCondiciones, new Paragraph("Responsable Técnico", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCondiciones, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCondiciones, new Paragraph((obra?.revisor?.titulo ?: '') + " " + (obra?.revisor?.nombre ?: '')+ " " + (obra?.revisor?.apellido ?: ''), times8normal), prmsHeaderHoja)

        document.add(tablaPresupuesto);
        document.add(tablaCoordenadas);
        document.add(tablaReferencia);
        document.add(tablaVolObra)
        document.add(tablaTotal);

        PdfPTable tablaRetenciones = new PdfPTable(3);
        Paragraph txtRetenciones = new Paragraph();
        Paragraph txtDatos = new Paragraph();
        Paragraph txtDatos1 = new Paragraph();

        PdfPTable tablaDatos = new PdfPTable(6);
        tablaDatos.setWidthPercentage(100);
        tablaDatos.setWidths(arregloEnteros([10, 2, 30, 6, 2, 10]))

        if (params.forzarValue == '1') {
            Paragraph headerForzar = new Paragraph();
            addEmptyLine(headerForzar, 1);
            headerForzar.setAlignment(Element.ALIGN_CENTER);
            headerForzar.add(new Paragraph(auxiliar.titulo, times12bold));
            if (obra?.oficioSalida == null) {
                headerForzar.add(new Paragraph("Informe N°:" + " ", times10bold));
            } else {
                headerForzar.add(new Paragraph("Informe N°:" + obra?.oficioSalida, times10bold));
            }

            headerForzar.add(new Paragraph(" ", times12bold));
            headerForzar.add(new Paragraph(" ", times12bold));

            tablaRetenciones.setWidthPercentage(100);
            tablaRetenciones.setWidths(arregloEnteros([7, 2, 60]))

            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)

            addCellTabla(tablaRetenciones, new Paragraph("Notas", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(nota?.texto, times8normal), prmsHeaderHoja)

            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(auxiliar?.notaAuxiliar, times8normal), prmsHeaderHoja)

            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(nota?.adicional, times8normal), prmsHeaderHoja)

            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)

            txtDatos.setAlignment(Element.ALIGN_CENTER);
            txtDatos.add(new Paragraph("DATOS PARA EL PRESUPUESTO", times8bold));
            txtDatos.add(new Paragraph(" ", times8bold));

            addEmptyLine(txtRetenciones, 1);
            txtRetenciones.setAlignment(Element.ALIGN_LEFT);
            txtRetenciones.add(new Paragraph("Atentamente, ", times8bold));
            txtRetenciones.add(new Paragraph(" ", times8bold));


        } else {

//            PdfPTable tablaRetenciones = new PdfPTable(3);
            tablaRetenciones.setWidthPercentage(100);
            tablaRetenciones.setWidths(arregloEnteros([7, 2, 60]))

            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)

            addCellTabla(tablaRetenciones, new Paragraph("Notas", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(nota?.texto, times8normal), prmsHeaderHoja)

            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(auxiliar?.notaAuxiliar, times8normal), prmsHeaderHoja)

            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(nota?.adicional, times8normal), prmsHeaderHoja)


            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)

            txtDatos.setAlignment(Element.ALIGN_CENTER);
            txtDatos.add(new Paragraph("DATOS PARA EL PRESUPUESTO", times8bold));
            txtDatos.add(new Paragraph(" ", times8bold));

            if(obra?.distanciaPeso != 0){
                addCellTabla(tablaDatos, new Paragraph("Cantón", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(" : ", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(obra?.lugar?.descripcion, times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph("Distancia", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(" : ", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(g.formatNumber(number: obra?.distanciaPeso, format: "##,##0", minFractionDigits: 2, maxFractionDigits: 2, locale: "ec") + ' Km', times8normal), prmsHeaderHoja)

            }

            if(obra?.distanciaPesoEspecial != 0){

                addCellTabla(tablaDatos, new Paragraph("Especial", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(" : ", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(obra?.listaPeso1?.descripcion, times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph("Distancia", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(" : ", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(g.formatNumber(number: obra?.distanciaPesoEspecial, format: "##,##0", minFractionDigits: 2, locale: "ec" ) + ' Km', times8normal), prmsHeaderHoja)
            }


            if(obra?.distanciaVolumenMejoramiento != 0){

                addCellTabla(tablaDatos, new Paragraph("Mejoramiento", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(" : ", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(obra?.listaVolumen1?.descripcion, times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph("Distancia", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(" : ", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(g.formatNumber(number: obra?.distanciaVolumenMejoramiento, format: "##,##0", minFractionDigits: 2, maxFractionDigits: 2, locale: "ec") + ' Km', times8normal), prmsHeaderHoja)
            }

            if(obra?.distanciaVolumen != 0){
                addCellTabla(tablaDatos, new Paragraph("Petreos Hormigones", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(" : ", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(obra?.listaVolumen0?.descripcion, times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph("Distancia", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(" : ", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(g.formatNumber(number: obra?.distanciaVolumen, format: "##,##0", minFractionDigits: 2, maxFractionDigits: 2, locale: "ec") + ' Km', times8normal), prmsHeaderHoja)
            }

            if(obra?.distanciaVolumenCarpetaAsfaltica != 0){
                addCellTabla(tablaDatos, new Paragraph("Carpeta Asfáltica", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(" : ", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(obra?.listaVolumen2?.descripcion, times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph("Distancia", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(" : ", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(g.formatNumber(number: obra?.distanciaVolumenCarpetaAsfaltica, format: "##,##0", minFractionDigits: 2, maxFractionDigits: 2, locale: "ec") + ' Km', times8normal), prmsHeaderHoja)
            }

            if(obra?.distanciaDesalojo != 0){
                addCellTabla(tablaDatos, new Paragraph("Distancia General de Transporte", times8bold), prmsHeaderHoja + [colspan: 3] )
                addCellTabla(tablaDatos, new Paragraph("Distancia", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(" : ", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(g.formatNumber(number: obra?.distanciaDesalojo, format: "##,##0", minFractionDigits: 2, maxFractionDigits: 2, locale: "ec") + ' Km', times8normal), prmsHeaderHoja)
            }


            txtDatos1.setAlignment(Element.ALIGN_CENTER);
            txtDatos1.add(new Paragraph("COSTO INDIRECTO TOTAL : ${obra?.totales} %", times8bold));
            txtDatos1.add(new Paragraph(" ", times8bold));
            addEmptyLine(txtRetenciones, 1);
            txtRetenciones.setAlignment(Element.ALIGN_LEFT);
            txtRetenciones.add(new Paragraph("Atentamente, ", times8bold));
            txtRetenciones.add(new Paragraph(" ", times8bold));

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
//        if(session.perfil.id != 16){
//            addCellTabla(tablaFirmas, new Paragraph("______________________________________", times8bold), prmsHeaderHoja)
//        }else{
        addCellTabla(tablaFirmas, new Paragraph(" ", times8bold), prmsHeaderHoja)
//        }

        def arregloFirmas = []
        def el1
        def el2

        if(firmaFija.size() == 3){
            el1 = firmaFija[1]
            el2 = firmaFija[2]

            firmaFija[0] = el1
            firmaFija[1] = el2
        }

        firmaFija.each {f->
            firmas = Persona.get(f)
            arregloFirmas += firmas
        }

        if(params.firmaElaboro){
            personaElaboro = Persona.get(params.firmaElaboro)
            addCellTabla(tablaFirmas, new Paragraph((personaElaboro?.titulo?.toUpperCase() ?: '') + " " + (personaElaboro?.nombre.toUpperCase() ?: '' ) + " " + (personaElaboro?.apellido?.toUpperCase() ?: ''), times8bold), prmsHeaderHoja)
        }else{
            addCellTabla(tablaFirmas, new Paragraph(" ", times8bold), prmsHeaderHoja)
        }

        addCellTabla(tablaFirmas, new Paragraph("", times8bold), prmsHeaderHoja)

//        if(session.perfil.id != 16){
//            if(params.firmaCoordinador != ''){
//                def personaRol = PersonaRol.get(params.firmaCoordinador)
//                firmaCoordinador = personaRol.persona
//                addCellTabla(tablaFirmas, new Paragraph((firmaCoordinador?.titulo.toUpperCase() ?: '') + " " + (firmaCoordinador?.nombre?.toUpperCase() ?: '') + " " + (firmaCoordinador?.apellido?.toUpperCase() ?: ''), times8bold), prmsHeaderHoja)
//            }else{
//                addCellTabla(tablaFirmas, new Paragraph("Coordinador no asignado", times8bold), prmsHeaderHoja)
//            }
//        }else{
        addCellTabla(tablaFirmas, new Paragraph("", times8bold), prmsHeaderHoja)
//        }

        addCellTabla(tablaFirmas, new Paragraph("ELABORÓ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(" ", times8bold), prmsHeaderHoja)
//        if(session.perfil.id == 16){
        addCellTabla(tablaFirmas, new Paragraph("", times8bold), prmsHeaderHoja)
//        }else{
//            addCellTabla(tablaFirmas, new Paragraph("COORDINADOR", times8bold), prmsHeaderHoja)
//        }

        addCellTabla(tablaFirmas, new Paragraph(personaElaboro?.departamento?.descripcion?.toUpperCase() ?: '', times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph("", times8bold), prmsHeaderHoja)
//        addCellTabla(tablaFirmas, new Paragraph((firmaCoordinador?.departamento?.descripcion?.toUpperCase() ?: ''), times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(" ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(" ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(" ", times10bold), prmsHeaderHoja)

        //sumilla

        PdfPTable table3 = new PdfPTable(2);
        table3.setHorizontalAlignment(Element.ALIGN_LEFT)
        table3.setWidthPercentage(30);
        table3.setWidths(arregloEnteros([15, 15]))
        PdfPTable nested2 = new PdfPTable(1);
        PdfPTable nested3 = new PdfPTable(1);
        PdfPCell cell1 = new PdfPCell(new Paragraph("SUMILLA", times8bold));

        cell1.setColspan(2);
        table3.addCell(cell1)
        PdfPCell cell4 = new PdfPCell(new Paragraph((obra?.responsableObra?.titulo?.toUpperCase() ?: '') + " " + (obra?.responsableObra?.nombre?.toUpperCase() ?: '')+ " " + (obra?.responsableObra?.apellido?.toUpperCase() ?: ''), times8bold));
        cell4.setFixedHeight(25);
        PdfPCell cell6 = new PdfPCell(new Paragraph("ELABORÓ", times8bold));
        nested2.addCell(cell4)
        nested2.addCell(cell6)
        table3.addCell(new PdfPCell(nested2));
        table3.addCell(new PdfPCell(nested3));

        //prueba de separacion de parrafos

        PdfPTable apendice = new PdfPTable(1);
        apendice.setWidthPercentage(100)
        apendice.setWidths(arregloEnteros([100]))
        apendice.setSpacingBefore(30);


        PdfPTable nested8 = new PdfPTable(1);
        PdfPCell celda1 = new PdfPCell()
        celda1.setBorder(0)
        celda1.addElement(tablaCondiciones)
        celda1.addElement(tablaRetenciones)
        celda1.addElement(txtDatos)
        celda1.addElement(tablaDatos)
        celda1.addElement(txtDatos1)
        celda1.addElement(txtRetenciones)
        celda1.addElement(tablaFirmas)
        celda1.setColspan(1)
        apendice.addCell(celda1)
        apendice.setKeepTogether(true);
        document.add(apendice)

        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def reporteDocumentosObraVae() {

//        println("*****--->" + params)

        def cd
        def auxiliar = janus.Auxiliar.get(1);
        def nota

        if (params.notaValue && params.notaValue != '' && params.notaValue != 'null' && params.notaValue != 'undefined') {
            nota = Nota.get(params.notaValue)
        } else {
            nota = new Nota();
        }

        def obra = Obra.get(params.id)
        def paux = Parametros.get(1);
        def ivaTotal = 0
        def proyeccionTotal = 0
        def presupuestoTotal = 0;
        def inflacion = 0;
        def meses = 0;
        def firma = []
        def firmas
        def firmaFija
        def firmaCoordinador
        def personaElaboro
        def cuenta = 0;
        def cantidadMeses = params.meses
        def firma1 = obra?.responsableObra;
        def firma2 = obra?.revisor

        if (params.firmasFijas.trim().size() > 0) {
            firmaFija = params.firmasFijas.split(",")
        } else {
            firmaFija = []
        }

        cuenta = firma.size() + firmaFija.size() + 1

        def prmsHeaderHoja = [border: Color.WHITE]
        def prmsHeaderHoja2 = [border: Color.WHITE, colspan: 9]
        def prmsHeaderHoja3 = [border: Color.WHITE, colspan: 5]
        def prmsHeaderHoja4 = [border: Color.WHITE, bordeTop: "1"]
        def prmsHeaderHoja5 = [border: Color.WHITE, bordeBot: "1"]
        def prmsHeaderHoja6 = [border: Color.WHITE, bordeLeft: "1"]

        def prmsHeader = [border: Color.WHITE, colspan: 7, bg: new Color(73, 175, 205),
                          align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsHeader2 = [border: Color.WHITE, colspan: 3, bg: new Color(73, 175, 205),
                           align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead = [border: Color.WHITE, bg: Color.WHITE,
                            align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead2 = [border: Color.WHITE,
                             align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE, bordeTop: "1", bordeBot: "1"]
        def prmsCellHead3 = [border: Color.WHITE,
                             align : Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE, bordeTop: "1", bordeBot: "1"]
        def prmsCellHead4 = [border: Color.WHITE,
                             align : Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, bordeTop: "1", bordeBot: "1"]
        def prmsCellHeadRight = [border: Color.WHITE, bg: new Color(73, 175, 205),
                                 align : Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsCellCenter = [border: Color.WHITE, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellCenterLeft = [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_LEFT]

        def prmsCellRight = [border: Color.WHITE, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsCellRight2 = [border: Color.WHITE, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT, bordeTop: "1", bordeBot: "1"]
        def prmsCellRightTop = [border: Color.WHITE, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT, bordeTop: "1"]
        def prmsCellRightBot = [border: Color.WHITE, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT, bordeBot: "1"]
        def prmsCellLeft = [border: Color.WHITE, valign: Element.ALIGN_MIDDLE]
        def prmsSubtotal = [border: Color.WHITE, colspan: 6,
                            align : Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsNum = [border: Color.WHITE, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        def prms = [prmsHeaderHoja : prmsHeaderHoja, prmsHeader: prmsHeader, prmsHeader2: prmsHeader2,
                    prmsCellHead   : prmsCellHead, prmsCell: prmsCellCenter, prmsCellLeft: prmsCellLeft, prmsSubtotal: prmsSubtotal, prmsNum: prmsNum,
                    prmsHeaderHoja2: prmsHeaderHoja2, prmsCellRight: prmsCellRight, prmsCellHeadRight: prmsCellHeadRight, prmsCellHead2: prmsCellHead2,
                    prmsCellRight2 : prmsCellRight2, prmsCellRightTop: prmsCellRightTop, prmsCellRightBot: prmsCellRightBot]

        def baos = new ByteArrayOutputStream()
        def name = "presupuestoVAE_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        Font times14bold = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font times12bold = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font times13bold = new Font(Font.TIMES_ROMAN, 12);
        Font times18bold = new Font(Font.TIMES_ROMAN, 18, Font.BOLD);
        Font times10bold = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8bold = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        Font times8normal = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL)
        Font times10boldWhite = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8boldWhite = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        times8boldWhite.setColor(Color.WHITE)
        times10boldWhite.setColor(Color.WHITE)
        def fonts = [times12bold     : times12bold, times10bold: times10bold, times8bold: times8bold,
                     times10boldWhite: times10boldWhite, times8boldWhite: times8boldWhite, times8normal: times8normal, times18bold: times18bold]

        Document document
        document = new Document(PageSize.A4.rotate());

        def pdfw = PdfWriter.getInstance(document, baos);
        HeaderFooter footer1 = new HeaderFooter(new Phrase('', times8normal), true);
        footer1.setBorder(Rectangle.NO_BORDER);
        footer1.setAlignment(Element.ALIGN_CENTER);
        document.setFooter(footer1);
        document.open();
        document.addTitle("Presupuesto " + new Date().format("dd_MM_yyyy"));
        document.addSubject("Generado por el sistema Obras");
        document.addKeywords("documentosObra, janus, presupuesto");
        document.addAuthor("Janus");
        document.addCreator("Tedein SA");

        Paragraph headers = new Paragraph();
        addEmptyLine(headers, 1);
        headers.setAlignment(Element.ALIGN_CENTER);
        headers.add(new Paragraph(auxiliar?.titulo, times14bold));
        headers.add(new Paragraph(auxiliar?.memo1, times12bold));
        headers.add(new Paragraph(obra?.codigo, times12bold));

        Paragraph headerFecha = new Paragraph();
        headerFecha.setAlignment(Element.ALIGN_RIGHT);
        addEmptyLine(headerFecha, 1);
        addEmptyLine(headerFecha, 1);
        headerFecha.add(new Paragraph("Quito, " + printFecha(obra?.fechaOficioSalida), times13bold));
        addEmptyLine(headerFecha, 1);

        Paragraph txtIzq = new Paragraph();
        addEmptyLine(txtIzq, 1);
        txtIzq.setAlignment(Element.ALIGN_LEFT);

        if (params.encabezado == "1" || params.encabezado == 1) {
            if (Persona.get(session.usuario.id).departamento?.codigo == 'CRFC') {
                if (obra?.departamentoDestino) {
                    def departamentoDestino = Departamento.get(obra?.departamentoDestino?.id)
                    def direccionDestino = departamentoDestino?.direccion
                    def funcionDirector = Funcion.findByCodigo('D')
                    def departamentosDestino = Departamento.findAllByDireccion(direccionDestino)
                    def personasDir = []
                    departamentosDestino.each {
                        personasDir += Persona.findAllByDepartamento(Departamento.get(it.id))
                    }

                    def rolDirector = PersonaRol.findByFuncionAndPersonaInList(funcionDirector, personasDir)
                    txtIzq.add(new Paragraph(rolDirector?.persona?.titulo?.toUpperCase() ?: '', times10bold));
                    txtIzq.add(new Paragraph(rolDirector?.persona?.nombre?.toUpperCase() + ' ' + rolDirector?.persona?.apellido?.toUpperCase(), times10bold));
                    txtIzq.add(new Paragraph('DIRECTOR - ' + rolDirector?.persona?.departamento?.direccion?.nombre?.toUpperCase(), times10bold));
                    txtIzq.add(new Paragraph('Presente.', times10bold));
                    txtIzq.add(new Paragraph(' ', times10bold));
                    txtIzq.add(new Paragraph('Sr. Director.', times10bold));
                } else {
                    txtIzq.add(new Paragraph('SR. DIRECTOR', times10bold));
                    txtIzq.add(new Paragraph('Presente.', times10bold));
                    txtIzq.add(new Paragraph(' ', times10bold));
                    txtIzq.add(new Paragraph('Sr. Director.', times10bold));
                }
            } else {
                if (obra?.departamentoDestino) {
                    def departamentoDestino = Departamento.get(obra?.departamentoDestino?.id)
                    def direccionDestino = departamentoDestino?.direccion
                    def funcionDirector = Funcion.findByCodigo('D')
                    def departamentosDestino = Departamento.findAllByDireccion(direccionDestino)
                    def personasDir = []
                    departamentosDestino.each {
                        personasDir += Persona.findAllByDepartamento(Departamento.get(it.id))
                    }
                    def rolDirector = PersonaRol.findByFuncionAndPersonaInList(funcionDirector, personasDir)
                    txtIzq.add(new Paragraph(rolDirector?.persona?.titulo?.toUpperCase() ?: '', times10bold));
                    txtIzq.add(new Paragraph(rolDirector?.persona?.nombre?.toUpperCase() + ' ' + rolDirector?.persona?.apellido?.toUpperCase(), times10bold));
                    txtIzq.add(new Paragraph('DIRECTOR - ' + rolDirector?.persona?.departamento?.direccion?.nombre?.toUpperCase(), times10bold));
                    txtIzq.add(new Paragraph('Presente.', times10bold));
                    txtIzq.add(new Paragraph(' ', times10bold));
                    txtIzq.add(new Paragraph('Sr. Director.', times10bold));
                } else {
                    txtIzq.add(new Paragraph('SR. DIRECTOR', times10bold));
                    txtIzq.add(new Paragraph('Presente.', times10bold));
                    txtIzq.add(new Paragraph(' ', times10bold));
                    txtIzq.add(new Paragraph('Sr. Director.', times10bold));
                }
            }
        } else {
            txtIzq.add(new Paragraph('PRESUPUESTO REFERENCIAL', times10bold));
        }

        if (params.tipoReporte == '1') {
            if(session.perfil.id == 16){
                txtIzq.add(new Paragraph("Tengo a bien presentar a usted el siguiente Presupuesto Borrador para la construcción de", times10bold));
                txtIzq.add(new Paragraph(" ", times10bold));
            }else{
                txtIzq.add(new Paragraph(auxiliar?.baseCont, times10bold));
                txtIzq.add(new Paragraph(" ", times10bold));
            }
        }
        if (params.tipoReporte == '2') {
            if(session.perfil.id == 16){
                txtIzq.add(new Paragraph("Tengo a bien presentar a usted el siguiente Presupuesto Borrador para la construcción de", times10bold));
                txtIzq.add(new Paragraph(" ", times10bold));
            }else{
                txtIzq.add(new Paragraph(auxiliar?.presupuestoRef, times10bold));
                txtIzq.add(new Paragraph(" ", times10bold));
            }
        }

        addEmptyLine(headers, 1);
        document.add(headers);
        document.add(headerFecha);
        document.add(txtIzq);

        PdfPTable tablaPresupuesto = new PdfPTable(7);
        tablaPresupuesto.setWidthPercentage(100);
        tablaPresupuesto.setWidths(arregloEnteros([12, 2, 13, 2, 8, 2, 26]))

        addCellTabla(tablaPresupuesto, new Paragraph("Requirente", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(obra?.departamento?.direccion?.nombre + ' - ' + obra?.departamento?.descripcion, times8normal), prmsHeaderHoja3)

        addCellTabla(tablaPresupuesto, new Paragraph("Código", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(obra?.codigo, times8normal), prmsHeaderHoja3)

        addCellTabla(tablaPresupuesto, new Paragraph("Memo Cant. Obra", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(obra?.memoCantidadObra, times8normal), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" ", times8normal), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph("Nombre", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(obra?.nombre, times8normal), prmsHeaderHoja)

        addCellTabla(tablaPresupuesto, new Paragraph("Fórmula N°", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(obra?.formulaPolinomica, times8normal), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" ", times8normal), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph("Tipo de Obra", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(obra?.tipoObjetivo?.descripcion, times8normal), prmsHeaderHoja)

        addCellTabla(tablaPresupuesto, new Paragraph("Cantón", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(obra?.parroquia?.canton?.nombre, times8normal), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" ", times8normal), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph("Parroquia", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(obra?.parroquia?.nombre, times8normal), prmsHeaderHoja)

        addCellTabla(tablaPresupuesto, new Paragraph("Comunidad", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(obra?.comunidad?.nombre, times8normal), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" ", times8normal), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph("Sitio", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(obra?.sitio, times8normal), prmsHeaderHoja)

        addCellTabla(tablaPresupuesto, new Paragraph("Fecha Act. Precios", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(printFecha(obra?.fechaPreciosRubros), times8normal), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" ", times8normal), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph("Responsable de las Cantidades", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaPresupuesto, new Paragraph((obra?.inspector?.titulo ?: '')+ ' ' + obra?.inspector?.nombre + " " + obra?.inspector?.apellido, times8normal), prmsHeaderHoja)

        PdfPTable tablaCoordenadas = new PdfPTable(3);
        tablaCoordenadas.setWidthPercentage(100);
        tablaCoordenadas.setWidths(arregloEnteros([17, 3, 72]))
        addCellTabla(tablaCoordenadas, new Paragraph("Coordenadas", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCoordenadas, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCoordenadas, new Paragraph(obra?.coordenadas, times8normal), prmsHeaderHoja)

        PdfPTable tablaReferencia = new PdfPTable(3);
        tablaReferencia.setWidthPercentage(100);
        tablaReferencia.setWidths(arregloEnteros([17, 3, 72]))
        addCellTabla(tablaReferencia, new Paragraph("Referencia", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph(obra?.referencia, times8normal), prmsHeaderHoja)

        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaReferencia, new Paragraph("", times8bold), prmsHeaderHoja)

        PdfPTable tablaVolObra = new PdfPTable(11);
        tablaVolObra.setWidthPercentage(100);

        PdfPTable tablaCabeceraDoc = new PdfPTable(1);
        tablaVolObra.setWidthPercentage(100);

        PdfPTable tablaTotalSub = new PdfPTable(6);
        tablaVolObra.setWidthPercentage(100);

        PdfPTable tablaHeaderVol = new PdfPTable(6);
        tablaHeaderVol.setWidthPercentage(100);

        def detalle

        detalle = VolumenesObra.findAllByObra(obra, [sort: "orden"])
        preciosService.ac_rbroObra(obra.id)

        def precios = [:]
        def indirecto = obra.totales / 100
        def c;
        def total1 = 0;
        def total2 = 0;
        def totales
        def totalPresupuesto = 0;
        def totalPrueba = 0
        def totalPrueba1 = 0
        def totalRelativo1 = 0
        def totalRelativo2 = 0
        def finalRelativo = 0
        def totalVae1 = 0
        def totalVae2 = 0
        def finalVae = 0
        def valores = preciosService.rbro_pcun_vae(obra.id)
        def subPres = VolumenesObra.findAllByObra(obra, [sort: "orden"]).subPresupuesto.unique()

        tablaVolObra.setWidths(arregloEnteros([14,13, 42, 20, 10, 12, 12,12,12,10,10]))

        addCellTabla(tablaVolObra, new Paragraph("CÓDIGO", times8bold), prmsCellHead2)
        addCellTabla(tablaVolObra, new Paragraph("ESPEC.", times8bold), prmsCellHead4)
        addCellTabla(tablaVolObra, new Paragraph("RUBRO", times8bold), prmsCellHead2)
        addCellTabla(tablaVolObra, new Paragraph("DESCRIPCIÓN", times8bold), prmsCellHead2)
        addCellTabla(tablaVolObra, new Paragraph("UNIDAD", times8bold), prmsCellHead2)
        addCellTabla(tablaVolObra, new Paragraph("CANTIDAD", times8bold), prmsCellHead3)
        addCellTabla(tablaVolObra, new Paragraph("P. U.", times8bold), prmsCellHead3)
        addCellTabla(tablaVolObra, new Paragraph("C. TOTAL", times8bold), prmsCellHead3)
        addCellTabla(tablaVolObra, new Paragraph("PESO RELATIVO", times8bold), prmsCellHead3)
        addCellTabla(tablaVolObra, new Paragraph("VAE RUBRO", times8bold), prmsCellHead3)
        addCellTabla(tablaVolObra, new Paragraph("VAE TOTAL", times8bold), prmsCellHead3)

        subPres.each { s ->
            total2 = 0
            addCellTabla(tablaVolObra, new Paragraph(s.descripcion, times10bold), [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_LEFT, colspan: 11])
            valores.each {
                if (it.sbprdscr == s.descripcion) {
                    def textoC = (it.rbronmbr ?: '')
                    textoC = textoC.decodeHTML()
                    it?.rbronmbr = textoC
                    addCellTabla(tablaVolObra, new Paragraph(it.rbrocdgo, times8normal), prmsCellLeft)
                    addCellTabla(tablaVolObra, new Paragraph(it.itemcdes, times8normal), prmsCellLeft)
                    addCellTabla(tablaVolObra, new Paragraph(it.rbronmbr, times8normal), prmsCellLeft)
                    addCellTabla(tablaVolObra, new Paragraph(it.vlobdscr, times8normal), prmsCellLeft)
                    addCellTabla(tablaVolObra, new Paragraph(it.unddcdgo, times8normal), prmsCellCenter)
                    addCellTabla(tablaVolObra, new Paragraph(g.formatNumber(number: it.vlobcntd, minFractionDigits:
                            2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight)
                    addCellTabla(tablaVolObra, new Paragraph(g.formatNumber(number: it.pcun, minFractionDigits:
                            2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight)
                    addCellTabla(tablaVolObra, new Paragraph(g.formatNumber(number: it.totl, minFractionDigits:
                            4, maxFractionDigits: 4, format: "##,##0", locale: "ec"), times8normal), prmsCellRight)
                    addCellTabla(tablaVolObra, new Paragraph(g.formatNumber(number: it.relativo, minFractionDigits:
                            2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight)
                    addCellTabla(tablaVolObra, new Paragraph(g.formatNumber(number: it?.vae_rbro ?: 0, minFractionDigits:
                            2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight)
                    addCellTabla(tablaVolObra, new Paragraph(g.formatNumber(number: it?.vae_totl ?: 0, minFractionDigits:
                            2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight)
                    totales = it.totl
                    totalPrueba = total2 += totales
                    totalPresupuesto = (total1 += totales);

                    totalRelativo1 = it.relativo
                    finalRelativo = (totalRelativo2 += totalRelativo1)

                    if(it.vae_totl){
                        totalVae1= it.vae_totl
                    }else{
                        totalVae1= 0
                    }
                    finalVae = (totalVae2 += totalVae1)
                } else {  }
            }
            addCellTabla(tablaVolObra, new Paragraph("", times8bold), prmsCellCenter)
            addCellTabla(tablaVolObra, new Paragraph("", times8bold), prmsCellRight)
            addCellTabla(tablaVolObra, new Paragraph("", times8bold), prmsCellRight)
            addCellTabla(tablaVolObra, new Paragraph("", times8bold), prmsCellRight)
            addCellTabla(tablaVolObra, new Paragraph("", times8bold), prmsCellRight)
            addCellTabla(tablaVolObra, new Paragraph("", times8bold), prmsCellRight)
            addCellTabla(tablaVolObra, new Paragraph("SUBTOTAL:", times8bold), prmsCellRight)
            addCellTabla(tablaVolObra, new Paragraph(g.formatNumber(number: totalPrueba, format: "##,##0", locale: "ec", maxFractionDigits: 4, minFractionDigits: 4), times8bold), prmsCellRight)
            addCellTabla(tablaVolObra, new Paragraph("", times8bold), prmsCellRight)
            addCellTabla(tablaVolObra, new Paragraph("", times8bold), prmsCellRight)
            addCellTabla(tablaVolObra, new Paragraph("", times8bold), prmsCellRight)
        }

        PdfPTable tablaTotal = new PdfPTable(11);
        tablaTotal.setWidthPercentage(100);

        tablaTotal.setWidths(arregloEnteros([14,13, 42, 20, 10, 0, 30,15,12,5,10]))
        addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead2)
        addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead2)
        addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead2)
        addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead2)
        addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead2)
        addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead2)
        addCellTabla(tablaTotal, new Paragraph("TOTAL DEL PRESUPUESTO: ", times8bold), prmsCellHead2)
        addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: totalPresupuesto, format: "##,##0", locale: "ec", maxFractionDigits: 4, minFractionDigits: 4), times8bold), prmsCellHead2)
        addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: finalRelativo, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellHead2)
        addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead2)
        addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: finalVae, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellHead3)

        //solo IVA
        if (params.iva == 'true' && params.proyeccion == 'false') {
            ivaTotal = (totalPresupuesto * paux?.iva) / 100
            presupuestoTotal = totalPresupuesto + ivaTotal;

            addCellTabla(tablaTotal, new Paragraph("IVA " + paux?.iva + "% : ", times8bold), prmsCellRight)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: paux?.iva, format: "####.##", locale: "ec"), times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: ivaTotal, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellRight)

            addCellTabla(tablaTotal, new Paragraph("Presupuesto Total: ", times8bold), prmsCellRightBot)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: presupuestoTotal, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellRightBot)
        }
        //solo Proyeccion del reajuste

        if (params.proyeccion == 'true' && cantidadMeses.toInteger() >= 1 && params.iva == 'false') {
            inflacion = paux.inflacion
            meses = params.meses

            proyeccionTotal = (totalPresupuesto * ((inflacion / 1200) * meses.toInteger()))
            presupuestoTotal = totalPresupuesto + proyeccionTotal;

            addCellTabla(tablaTotal, new Paragraph("Proyeccion del Reajuste (período: " + meses + " meses, inflación: " + inflacion + " % ) :", times8bold), prmsCellRight)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: paux?.inflacion, format: "####.##", locale: "ec"), times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: proyeccionTotal, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellRight)

            addCellTabla(tablaTotal, new Paragraph("Presupuesto Total: ", times8bold), prmsCellRightBot)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: presupuestoTotal, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellRightBot)
        }

        if (params.proyeccion == 'true' && cantidadMeses.toInteger() >= 1 && params.iva == 'true') {
            inflacion = paux.inflacion
            meses = params.meses
            proyeccionTotal = (totalPresupuesto * ((inflacion / 1200) * meses.toInteger()))
            ivaTotal = ((totalPresupuesto + proyeccionTotal) * paux?.iva) / 100;
            presupuestoTotal = ((totalPresupuesto + proyeccionTotal) + ivaTotal)

            addCellTabla(tablaTotal, new Paragraph("Proyeccion del Reajuste (período: " + meses + " meses, inflación: " + inflacion + " % ) :", times8bold), prmsCellRight)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: paux?.inflacion, format: "####.##", locale: "ec"), times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: proyeccionTotal, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellRight)

            addCellTabla(tablaTotal, new Paragraph("IVA " + paux?.iva + "% : ", times8bold), prmsCellRight)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: paux?.iva, format: "##,##0", locale: "ec"), times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: ivaTotal, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellRight)

            addCellTabla(tablaTotal, new Paragraph("Presupuesto Total: ", times8bold), prmsCellRightBot)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(" ", times8bold), prmsCellHead)
            addCellTabla(tablaTotal, new Paragraph(g.formatNumber(number: presupuestoTotal, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellRightBot)
        }

        Paragraph txtCondiciones = new Paragraph();
        addEmptyLine(txtCondiciones, 1);
        txtCondiciones.setAlignment(Element.ALIGN_LEFT);
        txtCondiciones.add(new Paragraph("CONDICIONES DEL CONTRATO", times10bold));
        txtCondiciones.add(new Paragraph(" ", times10bold));

        PdfPTable tablaCondiciones = new PdfPTable(3);
        tablaCondiciones.setWidthPercentage(100);
        tablaCondiciones.setWidths(arregloEnteros([7, 2, 60]))

        addCellTabla(tablaCondiciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCondiciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCondiciones, new Paragraph(" ", times8bold), prmsHeaderHoja)

        addCellTabla(tablaCondiciones, new Paragraph("Plazo de Ejecución", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCondiciones, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCondiciones, new Paragraph(g.formatNumber(number: obra?.plazoEjecucionMeses, format: "##", locale: "ec") + " mes(es)" + "  "  + obra?.plazoEjecucionDias + " día(s)", times8normal), prmsHeaderHoja)

        addCellTabla(tablaCondiciones, new Paragraph("Anticipo", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCondiciones, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCondiciones, new Paragraph(g.formatNumber(number: obra?.porcentajeAnticipo, format: "###", locale: "ec") + " %", times8normal), prmsHeaderHoja)

        addCellTabla(tablaCondiciones, new Paragraph("Responsable Técnico", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCondiciones, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCondiciones, new Paragraph((obra?.revisor?.titulo ?: '') + " " + (obra?.revisor?.nombre ?: '')+ " " + (obra?.revisor?.apellido ?: ''), times8normal), prmsHeaderHoja)

        document.add(tablaPresupuesto);
        document.add(tablaCoordenadas);
        document.add(tablaReferencia);
        document.add(tablaVolObra)
        document.add(tablaTotal);

        PdfPTable tablaRetenciones = new PdfPTable(3);
        Paragraph txtRetenciones = new Paragraph();
        Paragraph txtDatos = new Paragraph();
        Paragraph txtDatos1 = new Paragraph();

        PdfPTable tablaDatos = new PdfPTable(6);
        tablaDatos.setWidthPercentage(100);
        tablaDatos.setWidths(arregloEnteros([10, 2, 30, 6, 2, 10]))

        if (params.forzarValue == '1') {
            Paragraph headerForzar = new Paragraph();
            addEmptyLine(headerForzar, 1);
            headerForzar.setAlignment(Element.ALIGN_CENTER);
            headerForzar.add(new Paragraph(auxiliar.titulo, times12bold));
            if (obra?.oficioSalida == null) {
                headerForzar.add(new Paragraph("Informe N°:" + " ", times10bold));
            } else {
                headerForzar.add(new Paragraph("Informe N°:" + obra?.oficioSalida, times10bold));
            }

            headerForzar.add(new Paragraph(" ", times12bold));
            headerForzar.add(new Paragraph(" ", times12bold));

            tablaRetenciones.setWidthPercentage(100);
            tablaRetenciones.setWidths(arregloEnteros([7, 2, 60]))

            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)

            addCellTabla(tablaRetenciones, new Paragraph("Notas", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(nota?.texto, times8normal), prmsHeaderHoja)

            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(auxiliar?.notaAuxiliar, times8normal), prmsHeaderHoja)

            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(nota?.adicional, times8normal), prmsHeaderHoja)

            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)

            txtDatos.setAlignment(Element.ALIGN_CENTER);
            txtDatos.add(new Paragraph("DATOS PARA EL PRESUPUESTO", times8bold));
            txtDatos.add(new Paragraph(" ", times8bold));

            addEmptyLine(txtRetenciones, 1);
            txtRetenciones.setAlignment(Element.ALIGN_LEFT);
            txtRetenciones.add(new Paragraph("Atentamente, ", times8bold));
            txtRetenciones.add(new Paragraph(" ", times8bold));
        } else {
            tablaRetenciones.setWidthPercentage(100);
            tablaRetenciones.setWidths(arregloEnteros([7, 2, 60]))

            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)

            addCellTabla(tablaRetenciones, new Paragraph("Notas", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(nota?.texto, times8normal), prmsHeaderHoja)

            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(auxiliar?.notaAuxiliar, times8normal), prmsHeaderHoja)

            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(nota?.adicional, times8normal), prmsHeaderHoja)


            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaRetenciones, new Paragraph(" ", times8bold), prmsHeaderHoja)

            txtDatos.setAlignment(Element.ALIGN_CENTER);
            txtDatos.add(new Paragraph("DATOS PARA EL PRESUPUESTO", times8bold));
            txtDatos.add(new Paragraph(" ", times8bold));

            if(obra?.distanciaPeso != 0){
                addCellTabla(tablaDatos, new Paragraph("Cantón", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(" : ", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(obra?.lugar?.descripcion, times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph("Distancia", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(" : ", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(g.formatNumber(number: obra?.distanciaPeso, format: "##,##0", minFractionDigits: 2, maxFractionDigits: 2, locale: "ec") + ' Km', times8normal), prmsHeaderHoja)

            }
            if(obra?.distanciaPesoEspecial != 0){
                addCellTabla(tablaDatos, new Paragraph("Especial", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(" : ", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(obra?.listaPeso1?.descripcion, times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph("Distancia", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(" : ", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(g.formatNumber(number: obra?.distanciaPesoEspecial, format: "##,##0", minFractionDigits: 2, locale: "ec" ) + ' Km', times8normal), prmsHeaderHoja)
            }

            if(obra?.distanciaVolumenMejoramiento != 0){
                addCellTabla(tablaDatos, new Paragraph("Mejoramiento", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(" : ", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(obra?.listaVolumen1?.descripcion, times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph("Distancia", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(" : ", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(g.formatNumber(number: obra?.distanciaVolumenMejoramiento, format: "##,##0", minFractionDigits: 2, maxFractionDigits: 2, locale: "ec") + ' Km', times8normal), prmsHeaderHoja)
            }
            if(obra?.distanciaVolumen != 0){
                addCellTabla(tablaDatos, new Paragraph("Petreos Hormigones", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(" : ", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(obra?.listaVolumen0?.descripcion, times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph("Distancia", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(" : ", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(g.formatNumber(number: obra?.distanciaVolumen, format: "##,##0", minFractionDigits: 2, maxFractionDigits: 2, locale: "ec") + ' Km', times8normal), prmsHeaderHoja)
            }
            if(obra?.distanciaVolumenCarpetaAsfaltica != 0){
                addCellTabla(tablaDatos, new Paragraph("Carpeta Asfáltica", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(" : ", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(obra?.listaVolumen2?.descripcion, times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph("Distancia", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(" : ", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(g.formatNumber(number: obra?.distanciaVolumenCarpetaAsfaltica, format: "##,##0", minFractionDigits: 2, maxFractionDigits: 2, locale: "ec") + ' Km', times8normal), prmsHeaderHoja)
            }
            if(obra?.distanciaDesalojo != 0){
                addCellTabla(tablaDatos, new Paragraph("Distancia General de Transporte", times8bold), prmsHeaderHoja + [colspan: 3] )
                addCellTabla(tablaDatos, new Paragraph("Distancia", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(" : ", times8bold), prmsHeaderHoja)
                addCellTabla(tablaDatos, new Paragraph(g.formatNumber(number: obra?.distanciaDesalojo, format: "##,##0", minFractionDigits: 2, maxFractionDigits: 2, locale: "ec") + ' Km', times8normal), prmsHeaderHoja)
            }

            txtDatos1.setAlignment(Element.ALIGN_CENTER);
            txtDatos1.add(new Paragraph("COSTO INDIRECTO TOTAL : ${obra?.totales} %", times8bold));
            txtDatos1.add(new Paragraph(" ", times8bold));
            addEmptyLine(txtRetenciones, 1);
            txtRetenciones.setAlignment(Element.ALIGN_LEFT);
            txtRetenciones.add(new Paragraph("Atentamente, ", times8bold));
            txtRetenciones.add(new Paragraph(" ", times8bold));
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
        addCellTabla(tablaFirmas, new Paragraph(" ", times8bold), prmsHeaderHoja)

        def arregloFirmas = []
        def el1
        def el2

        if(firmaFija.size() == 3){
            el1 = firmaFija[1]
            el2 = firmaFija[2]

            firmaFija[0] = el1
            firmaFija[1] = el2
        }

        firmaFija.each {f->
            firmas = Persona.get(f)
            arregloFirmas += firmas
        }

        if(params.firmaElaboro){
            personaElaboro = Persona.get(params.firmaElaboro)
            addCellTabla(tablaFirmas, new Paragraph((personaElaboro?.titulo?.toUpperCase() ?: '') + " " + (personaElaboro?.nombre.toUpperCase() ?: '' ) + " " + (personaElaboro?.apellido?.toUpperCase() ?: ''), times8bold), prmsHeaderHoja)
        }else{
            addCellTabla(tablaFirmas, new Paragraph(" ", times8bold), prmsHeaderHoja)
        }

        addCellTabla(tablaFirmas, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph("ELABORÓ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(personaElaboro?.departamento?.descripcion?.toUpperCase() ?: '', times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(" ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(" ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(" ", times10bold), prmsHeaderHoja)

        //sumilla
        PdfPTable table3 = new PdfPTable(2);
        table3.setHorizontalAlignment(Element.ALIGN_LEFT)
        table3.setWidthPercentage(30);
        table3.setWidths(arregloEnteros([15, 15]))
        PdfPTable nested2 = new PdfPTable(1);
        PdfPTable nested3 = new PdfPTable(1);
        PdfPCell cell1 = new PdfPCell(new Paragraph("SUMILLA", times8bold));

        cell1.setColspan(2);
        table3.addCell(cell1)
        PdfPCell cell4 = new PdfPCell(new Paragraph((obra?.responsableObra?.titulo?.toUpperCase() ?: '') + " " + (obra?.responsableObra?.nombre?.toUpperCase() ?: '')+ " " + (obra?.responsableObra?.apellido?.toUpperCase() ?: ''), times8bold));
        cell4.setFixedHeight(25);
        PdfPCell cell6 = new PdfPCell(new Paragraph("ELABORÓ", times8bold));
        nested2.addCell(cell4)
        nested2.addCell(cell6)
        table3.addCell(new PdfPCell(nested2));
        table3.addCell(new PdfPCell(nested3));

        //prueba de separacion de parrafos
        PdfPTable apendice = new PdfPTable(1);
        apendice.setWidthPercentage(100)
        apendice.setWidths(arregloEnteros([100]))
        apendice.setSpacingBefore(30);

        PdfPTable nested8 = new PdfPTable(1);
        PdfPCell celda1 = new PdfPCell()
        celda1.setBorder(0)
        celda1.addElement(tablaCondiciones)
        celda1.addElement(tablaRetenciones)
        celda1.addElement(txtDatos)
        celda1.addElement(tablaDatos)
        celda1.addElement(txtDatos1)
        celda1.addElement(txtRetenciones)
        celda1.addElement(tablaFirmas)
        celda1.setColspan(1)
        apendice.addCell(celda1)
        apendice.setKeepTogether(true);
        document.add(apendice)

        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def reporteDocumentosObraMemo() {
//        println("-memo-->>" + params)
        def cd
        def auxiliar = Auxiliar.get(1)
        def auxiliarFijo = Auxiliar.get(1)
        def obra = Obra.get(params.id)
        def paux = Parametros.get(1);
        def firma
        def firmas
        def firmaFijaMemo
        def firmaCoordinador
        def cuenta = 0;
        def firma1 = obra?.responsableObra;
        def firma2 = obra?.revisor;
        def totalBase = params.totalPresupuesto
        def tipo = params.tipoReporte
        def usuario = session.usuario.id
        def persona = Persona.get(usuario)
        def ivaTotal
        def valorTotal
        def subTotalMemo
        def mesesMemo
        def inflacion
        def proyeccionTotalMemo
        def cantidadMesesMemo = params.reajusteMesesMemo
        def valores = preciosService.rbro_pcun_v2(obra.id)
        def direccion = Direccion.get(obra?.departamento?.direccion?.id)
        def nota

        def firmaNueva

        if (!(params.firmaNueva == 'undefined')) {
            firmaNueva = PersonaRol.get(params.firmaNueva)
        } else {
            firmaNueva = null
        }

        if (params.notaValue && params.notaValue != '' && params.notaValue != 'null' && params.notaValue != 'undefined') {
            nota = Nota.get(params.notaValue)
        } else {
            nota = new Nota();
        }

        if (obra?.oficioSalida == null) {
            obra?.oficioSalida = "";
        }

        if (totalBase == "") {
            totalBase = 0;
        } else {
            totalBase = params.totalPresupuesto
        }

        if (params.firmasIdMemo.trim().size() > 0) {
            firma = params.firmasIdMemo.split(",")
            firma = firma.toList().unique()
        } else {
            firma = []
        }

        if (params.firmasFijasMemo.trim().size() > 0) {
            firmaFijaMemo = params.firmasFijasMemo.split(",")
        } else {
            firmaFijaMemo = []
        }

        cuenta = 3
        def prmsHeaderHoja = [border: Color.WHITE]
        def prmsHeaderHojaRight = [border: Color.WHITE, align: Element.ALIGN_RIGHT]
        def prmsHeaderHojaLeft = [border: Color.WHITE, align: Element.ALIGN_LEFT]
        def prmsHeaderHojaRight2 = [border: Color.WHITE, align: Element.ALIGN_RIGHT, bordeBot: 1]
        def prmsHeaderHojaRight3 = [border: Color.WHITE, align: Element.ALIGN_RIGHT, bordeTop: 1]
        def prmsHeaderHojaRight4 = [border: Color.WHITE, align: Element.ALIGN_LEFT, bordeTop: 1]
        def prmsHeaderHoja2 = [border: Color.WHITE, colspan: 9]
        def prmsHeader = [border: Color.WHITE, colspan: 7, bg: new Color(73, 175, 205),
                          align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsHeader2 = [border: Color.WHITE, colspan: 3, bg: new Color(73, 175, 205),
                           align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead = [border: Color.WHITE, bg: new Color(73, 175, 205),
                            align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellCenter = [border: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellRight = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsCellLeft = [border: Color.BLACK, valign: Element.ALIGN_MIDDLE]
        def prmsSubtotal = [border: Color.BLACK, colspan: 6,
                            align : Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsNum = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prms = [prmsHeaderHoja: prmsHeaderHoja, prmsHeader: prmsHeader, prmsHeader2: prmsHeader2,
                    prmsCellHead: prmsCellHead, prmsCell: prmsCellCenter, prmsCellLeft: prmsCellLeft, prmsSubtotal: prmsSubtotal, prmsNum: prmsNum, prmsHeaderHoja2: prmsHeaderHoja2, prmsCellRight: prmsCellRight]

        def baos = new ByteArrayOutputStream()
        def name = "memorando_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        Font times12bold = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font times14bold = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font times18bold = new Font(Font.TIMES_ROMAN, 18, Font.BOLD);
        Font times10bold = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8bold = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        Font times8normal = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL)
        Font times10normal = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL)
        Font times10boldWhite = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8boldWhite = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        times8boldWhite.setColor(Color.WHITE)
        times10boldWhite.setColor(Color.WHITE)
        def fonts = [times12bold: times12bold, times10bold: times10bold, times8bold: times8bold,
                     times10boldWhite: times10boldWhite, times8boldWhite: times8boldWhite, times8normal: times8normal, times10normal: times10normal]

        Document document
        document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);
        document.open();
        document.addTitle("Informe " + new Date().format("dd_MM_yyyy"));
        document.addSubject("Generado por el sistema Janus");
        document.addKeywords("documentosObra, janus, presupuesto");
        document.addAuthor("Janus");
        document.addCreator("Tedein SA");

        Paragraph headers = new Paragraph();
        addEmptyLine(headers, 1);
        headers.setAlignment(Element.ALIGN_CENTER);
        headers.add(new Paragraph(auxiliar.titulo, times14bold));
//        headers.add(new Paragraph("DCP. - COORDINACIÓN DE RÉGIMEN DE FIJACIÓN DE COSTOS", times12bold));
        headers.add(new Paragraph(obra?.departamento?.direccion?.nombre + ' - ' + obra?.departamento?.descripcion, times12bold));
        headers.add(new Paragraph("INFORME", times12bold))

        Paragraph txtIzq = new Paragraph();
        addEmptyLine(txtIzq, 1);
        txtIzq.setAlignment(Element.ALIGN_LEFT);

        PdfPTable tablaCabecera = new PdfPTable(2);
        tablaCabecera.setWidthPercentage(100);
        tablaCabecera.setWidths(arregloEnteros([4, 60]))

        if (obra?.memoSalida == null) {
            addCellTabla(tablaCabecera, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaCabecera, new Paragraph("Informe N°:", times10bold), prmsHeaderHoja)
        } else {
            addCellTabla(tablaCabecera, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaCabecera, new Paragraph("Informe N°: " + obra?.oficioSalida, times10bold), prmsHeaderHoja)
        }

        PdfPTable tablaQuito = new PdfPTable(2);
        tablaQuito.setWidthPercentage(100);
        tablaQuito.setWidths(arregloEnteros([4, 60]))

        addCellTabla(tablaQuito, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaQuito, new Paragraph("Quito, " + printFecha(obra?.fechaOficioSalida), times10bold), prmsHeaderHoja)

        addCellTabla(tablaQuito, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaQuito, new Paragraph(" ", times8bold), prmsHeaderHoja)

        PdfPTable tablaDatosMemo = new PdfPTable(4);
        tablaDatosMemo.setWidthPercentage(100);
        tablaDatosMemo.setWidths(arregloEnteros([5, 7, 2, 60]))

        addCellTabla(tablaDatosMemo, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaDatosMemo, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaDatosMemo, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaDatosMemo, new Paragraph(" ", times8bold), prmsHeaderHoja)

        addCellTabla(tablaDatosMemo, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaDatosMemo, new Paragraph("DE", times10bold), prmsHeaderHoja)
        addCellTabla(tablaDatosMemo, new Paragraph(" : ", times8bold), prmsHeaderHoja)
//        addCellTabla(tablaDatosMemo, new Paragraph(persona?.departamento?.descripcion, times10bold), prmsHeaderHoja)
        addCellTabla(tablaDatosMemo, new Paragraph(obra?.departamento?.direccion?.nombre + ' - ' + obra?.departamento?.descripcion, times10bold), prmsHeaderHoja)

        if (obra?.direccionDestino) {
            addCellTabla(tablaDatosMemo, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaDatosMemo, new Paragraph("PARA", times10bold), prmsHeaderHoja)
            addCellTabla(tablaDatosMemo, new Paragraph(" : ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaDatosMemo, new Paragraph(obra?.direccionDestino?.nombre, times10bold), prmsHeaderHoja)
        } else if (obra?.departamentoDestino) {
            addCellTabla(tablaDatosMemo, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaDatosMemo, new Paragraph("PARA", times10bold), prmsHeaderHoja)
            addCellTabla(tablaDatosMemo, new Paragraph(" : ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaDatosMemo, new Paragraph(obra?.departamentoDestino?.descripcion, times10bold), prmsHeaderHoja)
        } else {
            addCellTabla(tablaDatosMemo, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaDatosMemo, new Paragraph("PARA", times10bold), prmsHeaderHoja)
            addCellTabla(tablaDatosMemo, new Paragraph(" : ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaDatosMemo, new Paragraph("No se ha seleccionado una dirección de destino, en la pantalla de Registro de Obra", times10bold), prmsHeaderHoja)
        }

        PdfPTable tablaLinea = new PdfPTable(2);
        tablaLinea.setWidthPercentage(100);
        tablaLinea.setWidths(arregloEnteros([5, 80]))

        addCellTabla(tablaLinea, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaLinea, new Paragraph("_________________________________________________________________________________________________________________________", times8bold), prmsHeaderHoja)

        PdfPTable tablaDatosAux = new PdfPTable(2);
        tablaDatosAux.setWidthPercentage(100);
        tablaDatosAux.setWidths(arregloEnteros([7, 80]))

        addCellTabla(tablaDatosAux, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaDatosAux, new Paragraph(auxiliarFijo?.memo1, times10normal), prmsHeaderHoja)

        addEmptyLine(headers, 1);
        document.add(headers);
        document.add(tablaCabecera);
        document.add(tablaQuito);
        document.add(tablaDatosMemo);
        document.add(tablaLinea);
        document.add(tablaDatosAux);

        PdfPTable tablaMemo = new PdfPTable(4);
        tablaMemo.setWidthPercentage(100);
        tablaMemo.setWidths(arregloEnteros([8, 25, 2, 50]))

        addCellTabla(tablaMemo, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph(" ", times8bold), prmsHeaderHoja)

        if (tipo == '1') {
            addCellTabla(tablaMemo, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaMemo, new Paragraph("Presupuesto Referencial", times10bold), prmsHeaderHoja)
            addCellTabla(tablaMemo, new Paragraph(" : ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaMemo, new Paragraph(obra?.oficioSalida, times10normal), prmsHeaderHoja)
            addCellTabla(tablaMemo, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaMemo, new Paragraph("Fórmula Polinómica", times10bold), prmsHeaderHoja)
            addCellTabla(tablaMemo, new Paragraph(" : ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaMemo, new Paragraph(obra?.formulaPolinomica, times10normal), prmsHeaderHoja)
        }
        if (tipo == '2') {
            addCellTabla(tablaMemo, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaMemo, new Paragraph("Presupuesto Referencial", times10bold), prmsHeaderHoja)
            addCellTabla(tablaMemo, new Paragraph(" : ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaMemo, new Paragraph(" : " + obra?.oficioSalida, times10normal), prmsHeaderHoja)
        }

        addCellTabla(tablaMemo, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph(" ", times8bold), prmsHeaderHoja)

        addCellTabla(tablaMemo, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph("Código", times10bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph(obra?.codigo, times10normal), prmsHeaderHoja)

        addCellTabla(tablaMemo, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph("Nombre de la obra", times10bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph(obra?.nombre, times10normal), prmsHeaderHoja)

        addCellTabla(tablaMemo, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph("Descripción", times10bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph(obra?.descripcion, times10normal), prmsHeaderHoja)

        addCellTabla(tablaMemo, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph("Tipo de Obra", times10bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph(obra?.tipoObjetivo?.descripcion, times10normal), prmsHeaderHoja)

        addCellTabla(tablaMemo, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph("Cantón", times10bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph(obra?.parroquia?.canton?.nombre, times10normal), prmsHeaderHoja)

        addCellTabla(tablaMemo, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph("Parroquia", times10bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph(obra?.parroquia?.nombre, times10normal), prmsHeaderHoja)

        addCellTabla(tablaMemo, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph("Documento de Referencia", times10bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph(obra?.oficioIngreso, times10normal), prmsHeaderHoja)

        addCellTabla(tablaMemo, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph("Otras Referencias", times10bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph(obra?.referencia, times10normal), prmsHeaderHoja)

        addCellTabla(tablaMemo, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph("", times8bold), prmsHeaderHoja)

        addCellTabla(tablaMemo, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaMemo, new Paragraph("", times8bold), prmsHeaderHoja)

        PdfPTable tablaBaseMemo = new PdfPTable(4);
        tablaMemo.setWidthPercentage(100);
        tablaBaseMemo.setWidthPercentage(100);
        tablaBaseMemo.setWidths(arregloEnteros([12, 70, 20, 25]))
        tablaBaseMemo.setSpacingBefore(20)

        if (tipo == '1') {
            addCellTabla(tablaBaseMemo, new Paragraph(" ", times10bold), prmsHeaderHojaLeft)
            addCellTabla(tablaBaseMemo, new Paragraph("Valor del Presupuesto :", times10bold), prmsHeaderHojaLeft)
            addCellTabla(tablaBaseMemo, new Paragraph(g.formatNumber(number: (totalBase), format: "##,##0", locale: "ec", maxFractionDigits: 4, minFractionDigits: 4), times10bold), prmsHeaderHojaRight)
            addCellTabla(tablaBaseMemo, new Paragraph(" ", times8normal), prmsHeaderHoja)

//            solo Iva
            if (params.reajusteIvaMemo == 'true' && params.proyeccionMemo == 'false') {
                ivaTotal = (totalBase.toDouble() * paux?.iva) / 100
                valorTotal = totalBase.toDouble() + ivaTotal;

                addCellTabla(tablaBaseMemo, new Paragraph(" ", times10bold), prmsHeaderHojaLeft)
                addCellTabla(tablaBaseMemo, new Paragraph("Iva " + paux?.iva + " % :", times10bold), prmsHeaderHojaLeft)
                addCellTabla(tablaBaseMemo, new Paragraph(g.formatNumber(number: ivaTotal, format: "##,##0", locale: "ec", maxFractionDigits: 4, minFractionDigits: 4), times10bold), prmsHeaderHojaRight)
                addCellTabla(tablaBaseMemo, new Paragraph(" ", times8normal), prmsHeaderHoja)

                addCellTabla(tablaBaseMemo, new Paragraph(" ", times10bold), prmsHeaderHojaLeft)
                addCellTabla(tablaBaseMemo, new Paragraph("Valor total incluido IVA:", times10bold), prmsHeaderHojaRight4)
                addCellTabla(tablaBaseMemo, new Paragraph(g.formatNumber(number: valorTotal, format: "##,##0", locale: "ec", maxFractionDigits: 4, minFractionDigits: 4), times10bold), prmsHeaderHojaRight3)
                addCellTabla(tablaBaseMemo, new Paragraph(" ", times8normal), prmsHeaderHoja)
            }

            //solo proyeccion del reajuste

            if (params.proyeccionMemo == 'true' && cantidadMesesMemo >= '1' && params.reajusteIvaMemo == 'false') {
                def anio = obra.fechaCreacionObra.getYear().toInteger()
                inflacion = ValoresAnuales.findByAnio((anio + 1900)).inflacion
                mesesMemo = params.reajusteMesesMemo
                proyeccionTotalMemo = (totalBase.toDouble() * ((inflacion / 1200) * mesesMemo.toInteger()))
                valorTotal = totalBase.toDouble() + proyeccionTotalMemo;

                addCellTabla(tablaBaseMemo, new Paragraph(" ", times10bold), prmsHeaderHojaLeft)
                addCellTabla(tablaBaseMemo, new Paragraph("Proyección del Reajuste (" + "Período: " + g.formatNumber(number: mesesMemo, format: "##.##", locale: "ec") + " meses, " + "Inflación: " + g.formatNumber(number: inflacion, format: "####.##", locale: "ec") + "%):", times10bold), prmsHeaderHojaLeft)
                addCellTabla(tablaBaseMemo, new Paragraph(g.formatNumber(number: proyeccionTotalMemo, format: "##,##0", locale: "ec", maxFractionDigits: 4, minFractionDigits: 4), times10bold), prmsHeaderHojaRight)
                addCellTabla(tablaBaseMemo, new Paragraph(" ", times8normal), prmsHeaderHoja)

                addCellTabla(tablaBaseMemo, new Paragraph(" ", times10bold), prmsHeaderHojaLeft)
                addCellTabla(tablaBaseMemo, new Paragraph("Valor Total :", times10bold), prmsHeaderHojaRight4)
                addCellTabla(tablaBaseMemo, new Paragraph(g.formatNumber(number: valorTotal, format: "##,##0", locale: "ec", maxFractionDigits: 4, minFractionDigits: 4), times10bold), prmsHeaderHojaRight3)
                addCellTabla(tablaBaseMemo, new Paragraph(" ", times8normal), prmsHeaderHoja)
            }

            if (params.proyeccionMemo == 'true' && cantidadMesesMemo >= '1' && params.reajusteIvaMemo == 'true') {
                def anio = obra.fechaCreacionObra.getYear().toInteger()
                inflacion = ValoresAnuales.findByAnio((anio + 1900)).inflacion
                mesesMemo = params.reajusteMesesMemo
                proyeccionTotalMemo = (totalBase.toDouble() * ((inflacion / 1200) * mesesMemo.toInteger()))
                ivaTotal = ((totalBase.toDouble() + proyeccionTotalMemo) * paux?.iva) / 100;
                valorTotal = ((totalBase.toDouble() + proyeccionTotalMemo) + ivaTotal)
                subTotalMemo = (totalBase.toDouble() + proyeccionTotalMemo)

                addCellTabla(tablaBaseMemo, new Paragraph(" ", times10bold), prmsHeaderHojaLeft)
                addCellTabla(tablaBaseMemo, new Paragraph("Proyección del Reajuste (" + "Período: " + g.formatNumber(number: mesesMemo, format: "##.##", locale: "ec") + " meses, " + "Inflación: " + g.formatNumber(number: inflacion, format: "####.##", locale: "ec") + "%):", times10bold), prmsHeaderHojaLeft)
                addCellTabla(tablaBaseMemo, new Paragraph(g.formatNumber(number: proyeccionTotalMemo, format: "##,##0", locale: "ec", maxFractionDigits: 4, minFractionDigits: 4), times10bold), prmsHeaderHojaRight)
                addCellTabla(tablaBaseMemo, new Paragraph(" ", times8normal), prmsHeaderHoja)

                addCellTabla(tablaBaseMemo, new Paragraph(" ", times10bold), prmsHeaderHojaLeft)
                addCellTabla(tablaBaseMemo, new Paragraph("Subtotal :", times10bold), prmsHeaderHojaRight4)
                addCellTabla(tablaBaseMemo, new Paragraph(g.formatNumber(number: subTotalMemo, format: "##,##0", locale: "ec", maxFractionDigits: 4, minFractionDigits: 4), times10bold), prmsHeaderHojaRight3)
                addCellTabla(tablaBaseMemo, new Paragraph(" ", times8normal), prmsHeaderHoja)

                addCellTabla(tablaBaseMemo, new Paragraph(" ", times10bold), prmsHeaderHojaLeft)
                addCellTabla(tablaBaseMemo, new Paragraph("Iva " + paux?.iva + " % :", times10bold), prmsHeaderHojaLeft)
                addCellTabla(tablaBaseMemo, new Paragraph(g.formatNumber(number: ivaTotal, format: "##,##0", locale: "ec", maxFractionDigits: 4, minFractionDigits: 4), times10bold), prmsHeaderHojaRight)
                addCellTabla(tablaBaseMemo, new Paragraph(" ", times8normal), prmsHeaderHoja)

                addCellTabla(tablaBaseMemo, new Paragraph(" ", times10bold), prmsHeaderHojaLeft)
                addCellTabla(tablaBaseMemo, new Paragraph("Valor total incluido IVA:", times10bold), prmsHeaderHojaRight4)
                addCellTabla(tablaBaseMemo, new Paragraph(g.formatNumber(number: valorTotal, format: "##,##0", locale: "ec", maxFractionDigits: 4, minFractionDigits: 4), times10bold), prmsHeaderHojaRight3)
                addCellTabla(tablaBaseMemo, new Paragraph(" ", times8normal), prmsHeaderHoja)
            }
            if (params.proyeccionMemo == 'false' && params.reajusteIvaMemo == 'false') {
                valorTotal = totalBase.toDouble();
                addCellTabla(tablaBaseMemo, new Paragraph(" ", times10bold), prmsHeaderHojaLeft)
                addCellTabla(tablaBaseMemo, new Paragraph("Valor Total :", times10bold), prmsHeaderHojaRight4)
                addCellTabla(tablaBaseMemo, new Paragraph(g.formatNumber(number: valorTotal, format: "##,##0", locale: "ec", maxFractionDigits: 4, minFractionDigits: 4), times10bold), prmsHeaderHojaRight3)
                addCellTabla(tablaBaseMemo, new Paragraph(" ", times8normal), prmsHeaderHoja)
            }
        }

        if (tipo == '2') {
            addCellTabla(tablaBaseMemo, new Paragraph(" ", times10bold), prmsHeaderHojaLeft)
            addCellTabla(tablaBaseMemo, new Paragraph("Valor del P. Referencial :", times10bold), prmsHeaderHojaRight)
            addCellTabla(tablaBaseMemo, new Paragraph(g.formatNumber(number: totalBase, format: "##,##0", locale: "ec", maxFractionDigits: 4, minFractionDigits: 4), times10normal), prmsHeaderHojaRight)
            addCellTabla(tablaBaseMemo, new Paragraph(" ", times8normal), prmsHeaderHoja)

            addCellTabla(tablaBaseMemo, new Paragraph(" ", times10bold), prmsHeaderHojaLeft)
            addCellTabla(tablaBaseMemo, new Paragraph("Valor Total :", times10bold), prmsHeaderHojaRight3)
            addCellTabla(tablaBaseMemo, new Paragraph(g.formatNumber(number: totalBase, format: "##,##0", locale: "ec", maxFractionDigits: 4, minFractionDigits: 4), times10normal), prmsHeaderHojaRight3)
            addCellTabla(tablaBaseMemo, new Paragraph(" ", times8normal), prmsHeaderHoja)
        }

        document.add(tablaMemo)
        document.add(tablaBaseMemo)

        PdfPTable tablaFirmas = new PdfPTable(2)
        tablaFirmas.setWidthPercentage(90);
        addCellTabla(tablaFirmas, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph("______________________________________", times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(" ", times8bold), prmsHeaderHoja)
        //nuevas
        def personaRol = null
        if (params.firmaCoordinador != '') {
            personaRol = PersonaRol.get(params.firmaCoordinador)
            firmaCoordinador = personaRol?.persona
            if (firmaNueva) {
                firmaCoordinador = firmaNueva.persona
            }

            addCellTabla(tablaFirmas, new Paragraph((firmaCoordinador?.titulo?.toUpperCase() ?: '') + " " + (firmaCoordinador?.nombre?.toUpperCase() ?: '') + " " + (firmaCoordinador?.apellido?.toUpperCase() ?: ''), times8bold), prmsHeaderHoja)
            addCellTabla(tablaFirmas, new Paragraph(" ", times8bold), prmsHeaderHoja)
        } else {
            addCellTabla(tablaFirmas, new Paragraph("Coordinador no asignado", times8bold), prmsHeaderHoja)
            addCellTabla(tablaFirmas, new Paragraph(" ", times8bold), prmsHeaderHoja)
        }
        def rolPrint = "COORDINADOR"
//        println "firma nueva " + firmaNueva
        def personaNueva
        if (firmaNueva) {
            personaNueva = firmaNueva.persona
            def rol = PersonaRol.findAllByPersona(firmaNueva.persona)
            rol.each {
                if (it.funcion.codigo == "D") {
                    if (firmaNueva.persona.sexo == "M") {
                        rolPrint = "DIRECTOR"
                    } else {
                        rolPrint = "DIRECTORA"
                    }
                }
            }
        }
        addCellTabla(tablaFirmas, new Paragraph(rolPrint, times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(personaNueva?.departamento?.descripcion?.toUpperCase() ?: '', times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(" ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(" ", times10bold), prmsHeaderHoja)
        document.add(tablaFirmas);

        /** todo: poner responsable y revisado por ... usar obrasService.esDuenoObra**/
        if(obraService.esDuenoObra(obra, persona.id) && (tipo == '1') && (persona.departamento.codigo == 'CRFC')){
            def funcionCoord = Funcion.findByCodigo('O')
            def coordinador = PersonaRol.findByFuncionAndPersonaInList(funcionCoord, Persona.findAllByDepartamento(Departamento.findByCodigo('CRFC')))?.persona
            PdfPTable tablaPie = new PdfPTable(2);
            tablaPie.setWidthPercentage(100);
            tablaPie.setWidths(arregloEnteros([3, 60]))

            addCellTabla(tablaPie, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaPie, new Paragraph("Elaborado por: " + obra?.responsableObra?.titulo?.toUpperCase() + " " +
                    obra?.responsableObra?.nombre?.toUpperCase() + " " + obra?.responsableObra?.apellido?.toUpperCase(), times8normal), prmsHeaderHoja)
            addCellTabla(tablaPie, new Paragraph(" ", times8bold), prmsHeaderHoja)
            addCellTabla(tablaPie, new Paragraph("Revisado por: " + coordinador?.titulo?.toUpperCase() + " " +
                    coordinador?.nombre?.toUpperCase() + " " + coordinador?.apellido?.toUpperCase() , times8normal), prmsHeaderHoja)
            document.add(tablaPie)
        }

        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def reporteDocumentosObraFormu() {   /* fórmula polinómica */
//        println("paramsf" + params)
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

        def personaElaboro
        def firmaCoordinador

        if (params.notaValue && params.notaValue != '' && params.notaValue != 'null' && params.notaValue != 'undefined') {
            nota = Nota.get(params.notaValue)
        } else {
            nota = new Nota();
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

        def prmsHeaderHoja = [border: Color.WHITE]
        def prmsHeaderHojaCenter = [border: Color.WHITE, valign: Element.ALIGN_MIDDLE]
        def prmsHeaderHojaRight = [border: Color.WHITE, align : Element.ALIGN_RIGHT]
        def prmsHeaderHoja4 = [border: Color.WHITE, bordeTop: "1"]
        def prmsHeaderHoja5 = [border: Color.WHITE, bordeBot: "1"]

        def prmsHeaderHoja2 = [border: Color.WHITE, colspan: 9]
        def prmsHeaderHoja3 = [border: Color.WHITE, colspan: 2]

        def prmsHeader = [border: Color.WHITE, colspan: 7, bg: new Color(73, 175, 205),
                          align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead2 = [border: Color.WHITE,
                             align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE, bordeBot: "1"]
        def prmsHeader2 = [border: Color.WHITE, colspan: 3, bg: new Color(73, 175, 205),
                           align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead = [border: Color.WHITE, bg: new Color(73, 175, 205),
                            align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellCenter = [border: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellRight = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsCellLeft = [border: Color.BLACK, valign: Element.ALIGN_MIDDLE]
        def prmsSubtotal = [border: Color.BLACK, colspan: 6,
                            align : Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsNum = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        def prms = [prmsHeaderHoja: prmsHeaderHoja, prmsHeader: prmsHeader, prmsHeader2: prmsHeader2,
                    prmsCellHead: prmsCellHead, prmsCell: prmsCellCenter, prmsCellLeft: prmsCellLeft, prmsSubtotal: prmsSubtotal, prmsNum: prmsNum, prmsHeaderHoja2: prmsHeaderHoja2, prmsCellRight: prmsCellRight]

        def baos = new ByteArrayOutputStream()
        def name = "formulaPolinomica_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        Font times14bold = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font times12bold = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font times18bold = new Font(Font.TIMES_ROMAN, 18, Font.BOLD);
        Font times10bold = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times10normal = new Font(Font.TIMES_ROMAN, 9, Font.NORMAL);
        Font times8bold = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        Font times8normal = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL)
        Font times10boldWhite = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8boldWhite = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        times8boldWhite.setColor(Color.WHITE)
        times10boldWhite.setColor(Color.WHITE)
        def fonts = [times12bold: times12bold, times10bold: times10bold, times8bold: times8bold,
                     times10boldWhite: times10boldWhite, times8boldWhite: times8boldWhite, times8normal: times8normal, times10normal: times10normal, times18bold: times18bold]

        Document document
        document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);
        document.open();
        document.addTitle("Formula " + new Date().format("dd_MM_yyyy"));
        document.addSubject("Generado por el sistema Obras");
        document.addKeywords("documentosObra, janus, presupuesto");
        document.addAuthor("Janus");
        document.addCreator("Tedein SA")
        document.setMargins(30, 20, 20, 20)

        Paragraph headers = new Paragraph();

        headers.setAlignment(Element.ALIGN_CENTER);
        headers.add(new Paragraph(auxiliar?.titulo, times14bold));
        headers.add(new Paragraph("FÓRMULA POLINÓMICA " + obra?.formulaPolinomica, times12bold))
        document.add(headers);

        Paragraph txtIzq = new Paragraph();
        txtIzq.setAlignment(Element.ALIGN_CENTER);
        txtIzq.setIndentationLeft(15)
        txtIzq.add(new Paragraph("De existir variaciones en los costos de los componentes de precios unitarios " +
                "estipulados en el contrato para la construcción de: ", times10normal));
        txtIzq.setSpacingAfter(10)
        document.add(txtIzq);

        PdfPTable tablaObra = new PdfPTable(2);
        tablaObra.setWidthPercentage(90);
        tablaObra.setWidths(arregloEnteros([15, 85]))

        PdfPTable tablaHeader = new PdfPTable(4);
        tablaHeader.setWidthPercentage(90);
        tablaHeader.setWidths(arregloEnteros([15, 42, 15, 28]))

        addCellTabla(tablaHeader, new Paragraph("Requirente: ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaHeader, new Paragraph(obra?.departamento?.direccion?.nombre + ' - ' + obra?.departamento?.descripcion, times10normal), prmsHeaderHoja2)

        addCellTabla(tablaHeader, new Paragraph("Nombre: ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaHeader, new Paragraph(obra?.nombre, times10normal), prmsHeaderHoja2)

        addCellTabla(tablaHeader, new Paragraph("Tipo de Obra: ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaHeader, new Paragraph(obra?.tipoObjetivo?.descripcion, times10normal), prmsHeaderHoja)
        addCellTabla(tablaHeader, new Paragraph("Código Obra: ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaHeader, new Paragraph(obra?.codigo, times10normal), prmsHeaderHoja)

        addCellTabla(tablaHeader, new Paragraph("Ubicación : ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaHeader, new Paragraph(obra?.sitio, times10normal), prmsHeaderHoja2)

        addCellTabla(tablaHeader, new Paragraph("Cantón : ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaHeader, new Paragraph(obra?.parroquia?.canton?.nombre, times10normal), prmsHeaderHoja)
        addCellTabla(tablaHeader, new Paragraph("Parroquia : ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaHeader, new Paragraph(obra?.parroquia?.nombre, times10normal), prmsHeaderHoja)

        if(obra?.coordenadas != "S 0 0 W 0 0") {
            addCellTabla(tablaHeader, new Paragraph("Coordenadas : ", times10bold), prmsHeaderHoja)
            addCellTabla(tablaHeader, new Paragraph(obra?.coordenadas, times10normal), prmsHeaderHoja)
        } else {
            addCellTabla(tablaHeader, new Paragraph("", times10bold), prmsHeaderHoja)
            addCellTabla(tablaHeader, new Paragraph("", times10normal), prmsHeaderHoja)
        }
        addCellTabla(tablaHeader, new Paragraph("Fecha: ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaHeader, new Paragraph(printFecha(obra?.fechaOficioSalida).toUpperCase(), times10normal), prmsHeaderHoja)

        document.add(tablaObra)
        document.add(tablaHeader)

        Paragraph txtIzqHeader = new Paragraph();
        txtIzqHeader.setAlignment(Element.ALIGN_LEFT);
        txtIzqHeader.setIndentationLeft(20)
        txtIzqHeader.add(new Paragraph("Los costos se reajustarán para efecto de pago, mediante la fórmula general: ", times10normal));

        txtIzqHeader.add(new Paragraph("Pr = Po (p01B1/Bo + p02C1/Co + p03D1/Do + p04E1/Eo + p05F1/Fo + p06G1/Go + p07H1/Ho + p08I1/Io + p09J1/Jo + p10K1/Ko + pxX1/Xo) ", times8normal));

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

                    def p07valores =
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
        txtIzqHeader.add(new Paragraph(formulaStr, times10bold));
        txtIzqHeader.add(new Paragraph(" ", times10bold));

        document.add(txtIzqHeader)

        PdfPTable tablaCoeficiente = new PdfPTable(3);
        tablaCoeficiente.setWidthPercentage(90);
//        tablaCoeficiente.setWidths(arregloEnteros([5, 8, 1, 53]))
        tablaCoeficiente.setWidths(arregloEnteros([6, 8, 86]))

        addCellTabla(tablaCoeficiente, new Paragraph("", times10normal), prmsHeaderHoja4)
        addCellTabla(tablaCoeficiente, new Paragraph("", times10normal), prmsHeaderHoja4)
        addCellTabla(tablaCoeficiente, new Paragraph("", times10normal), prmsHeaderHoja4)
//        addCellTabla(tablaCoeficiente, new Paragraph("", times10normal), prmsHeaderHoja4)

        def valorTotal = 0

        valores.each { i ->
            if (i) {
                if (i.valor != 0.0 || i.valor != 0) {
                    addCellTabla(tablaCoeficiente, new Paragraph(i.numero + " = ", times10normal), prmsHeaderHoja)
                    addCellTabla(tablaCoeficiente, new Paragraph(g.formatNumber(number: i.valor, format: "#.###", minFractionDigits: 3, locale: "ec"), times10normal), prmsHeaderHoja)
//                    addCellTabla(tablaCoeficiente, new Paragraph("Coeficiente del Componente ", times10normal), prmsHeaderHoja)
//                    addCellTabla(tablaCoeficiente, new Paragraph("", times10normal), prmsHeaderHoja)
                    addCellTabla(tablaCoeficiente, new Paragraph(i?.indice?.descripcion.toUpperCase(), times10normal), prmsHeaderHoja)

                    valorTotal = i.valor + valorTotal
                }
            }
        }

        addCellTabla(tablaCoeficiente, new Paragraph(" ", times10bold), prmsHeaderHoja4)
        addCellTabla(tablaCoeficiente, new Paragraph(g.formatNumber(number: valorTotal, format: "##,##0", minFractionDigits: 3, maxFractionDigits: 3, locale: "ec"), times10bold), prmsHeaderHoja4)
//        addCellTabla(tablaCoeficiente, new Paragraph("", times10bold), prmsHeaderHojaCenter)
        addCellTabla(tablaCoeficiente, new Paragraph(" (Suma total)", times10bold), prmsHeaderHojaCenter)

        addCellTabla(tablaCoeficiente, new Paragraph(" ", times10normal), prmsHeaderHoja4)
        addCellTabla(tablaCoeficiente, new Paragraph(" ", times10normal), prmsHeaderHoja4)
        addCellTabla(tablaCoeficiente, new Paragraph(" ", times10normal), prmsHeaderHoja4)
//        addCellTabla(tablaCoeficiente, new Paragraph(" ", times10normal), prmsHeaderHoja4)

        PdfPTable tablaCuadrillaHeader = new PdfPTable(2);
        tablaCuadrillaHeader.setWidthPercentage(90);
        tablaCuadrillaHeader.setWidths(arregloEnteros([30, 70]))
        addCellTabla(tablaCuadrillaHeader, new Paragraph("CUADRILLA TIPO ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaCuadrillaHeader, new Paragraph("CLASE OBRERO ", times10bold), prmsHeaderHoja)

        PdfPTable tablaCuadrilla = new PdfPTable(3);
        tablaCuadrilla.setWidthPercentage(90);
        tablaCuadrilla.setWidths(arregloEnteros([6, 8, 86]))

        def valorTotalCuadrilla = 0;

        cuadrilla.each { i ->

            if (i.valor != 0.0 || i.valor != 0) {
                addCellTabla(tablaCuadrilla, new Paragraph(i?.numero + " = ", times10normal), prmsHeaderHoja)
                addCellTabla(tablaCuadrilla, new Paragraph(g.formatNumber(number: i?.valor.toFloat(), format: "##,##0", minFractionDigits: 3, maxFractionDigits: 3, locale: "ec"), times10normal), prmsHeaderHoja)
                addCellTabla(tablaCuadrilla, new Paragraph(i?.indice?.descripcion, times10normal), prmsHeaderHoja)
                valorTotalCuadrilla = i.valor + valorTotalCuadrilla
            } else {  }
        }

        addCellTabla(tablaCuadrilla, new Paragraph(" ", times10bold), prmsHeaderHoja4)
        addCellTabla(tablaCuadrilla, new Paragraph(g.formatNumber(number: valorTotalCuadrilla, format: "##,##0", minFractionDigits: 3, maxFractionDigits: 3, locale: "ec"), times10bold), prmsHeaderHoja4)
        addCellTabla(tablaCuadrilla, new Paragraph("(Suma total) ", times10bold), prmsHeaderHojaCenter)

        addCellTabla(tablaCuadrilla, new Paragraph(" ", times10normal), prmsHeaderHoja4)
        addCellTabla(tablaCuadrilla, new Paragraph(" ", times10normal), prmsHeaderHoja4)
        addCellTabla(tablaCuadrilla, new Paragraph(" ", times10normal), prmsHeaderHoja4)

        document.add(tablaCoeficiente)
        document.add(tablaCuadrillaHeader)
        document.add(tablaCuadrilla)

        PdfPTable tablaPie = new PdfPTable(4);
        tablaPie.setWidthPercentage(90);

        addCellTabla(tablaPie, new Paragraph("Monto del Contrato : ", times10bold), prmsHeaderHojaCenter)
        addCellTabla(tablaPie, new Paragraph("\$ " + g.formatNumber(number: totalBase, minFractionDigits: 2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), fonts.times10normal), prmsHeaderHojaCenter)
        addCellTabla(tablaPie, new Paragraph("", times10normal), prmsHeaderHoja)
        addCellTabla(tablaPie, new Paragraph("", times10normal), prmsHeaderHoja)

        document.add(tablaPie)

        PdfPTable tablaNota = new PdfPTable(4);
        tablaNota.setWidthPercentage(90);
        tablaNota.setWidths(arregloEnteros([8, 66, 3, 23]))

        addCellTabla(tablaNota, new Paragraph("NOTA: ", times8bold), prmsHeaderHoja4)
        addCellTabla(tablaNota, new Paragraph("La presente Fórmula Polinómica se sujetará a lo establecido en la Ley de Contratación Pública ", times8normal), prmsHeaderHoja4)
        addCellTabla(tablaNota, new Paragraph(" ", times10bold), prmsHeaderHoja4)
//        addCellTabla(tablaNota, new Paragraph("Índice So: ${printFechaMes(obra?.fechaOficioSalida).toUpperCase()}", times8bold), prmsHeaderHoja4)
        addCellTabla(tablaNota, new Paragraph("", times8bold), prmsHeaderHoja4)

        addCellTabla(tablaNota, new Paragraph(" ", times10normal), prmsHeaderHoja)
        addCellTabla(tablaNota, new Paragraph(" ", times10normal), prmsHeaderHoja)
        addCellTabla(tablaNota, new Paragraph(" ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaNota, new Paragraph(" ", times10bold), prmsHeaderHoja)

        addCellTabla(tablaNota, new Paragraph("", times10normal), prmsHeaderHoja)
        addCellTabla(tablaNota, new Paragraph("Atentamente,   ", times10normal), prmsHeaderHoja)
        addCellTabla(tablaNota, new Paragraph(" ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaNota, new Paragraph(" ", times10bold), prmsHeaderHoja)

        document.add(tablaNota);

        PdfPTable tablaFirmas = new PdfPTable(2);
        tablaFirmas.setWidthPercentage(90);
        addCellTabla(tablaFirmas, new Paragraph(" ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(" ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(" ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(" ", times10bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph("______________________________________", times8bold), prmsHeaderHoja)

        if(obra?.codigo?.contains("-OF")){
            addCellTabla(tablaFirmas, new Paragraph("______________________________________", times8bold), prmsHeaderHoja)
            addCellTabla(tablaFirmas, new Paragraph("", times8bold), prmsHeaderHoja)
        }
        addCellTabla(tablaFirmas, new Paragraph("", times8bold), prmsHeaderHoja)

        def arregloFirmas = []
        def el1
        def el2

        if(firmaFijaFormu.size() == 3){
            el1 = firmaFijaFormu[1]
            el2 = firmaFijaFormu[2]
            firmaFijaFormu[0] = el1
            firmaFijaFormu[1] = el2
        }
        firmaFijaFormu.each {f->
            firmas = Persona.get(f)
            arregloFirmas += firmas
        }


        if(obra?.codigo?.contains("-OF")){
            def obraOferente = ObraOferente.findByObra(obra)
            println("-- " + obraOferente?.id)
            def oferente = obraOferente?.oferente
            println("-- " + oferente?.firma)
//            addCellTabla(tablaFirmas, new Paragraph((firmaCoordinador?.titulo?.toUpperCase() ?: '') + " " + (firmaCoordinador?.nombre?.toUpperCase() ?: '') + " " + (firmaCoordinador?.apellido?.toUpperCase() ?: ''), times8bold), prmsHeaderHoja)
            addCellTabla(tablaFirmas, new Paragraph((oferente?.firma?.toUpperCase() ?: ''), times8bold), prmsHeaderHoja)

        }

        if(params.firmaElaboro){
            personaElaboro = Persona.get(params.firmaElaboro)
            addCellTabla(tablaFirmas, new Paragraph((personaElaboro?.titulo?.toUpperCase() ?: '') + " " + (personaElaboro?.nombre?.toUpperCase() ?: '' ) + " " + (personaElaboro?.apellido?.toUpperCase() ?: ''), times8bold), prmsHeaderHoja)


        }else{
            addCellTabla(tablaFirmas, new Paragraph(" ", times8bold), prmsHeaderHoja)
        }

        if(!obra?.codigo?.contains("-OF")){
            addCellTabla(tablaFirmas, new Paragraph("", times8bold), prmsHeaderHoja)
        }

//        if(params.firmaCoordinador != ''){
//            def personaRol = PersonaRol.get(params.firmaCoordinador)
//            firmaCoordinador = personaRol.persona
//            addCellTabla(tablaFirmas, new Paragraph((firmaCoordinador?.titulo?.toUpperCase() ?: '') + " " + (firmaCoordinador?.nombre?.toUpperCase() ?: '') + " " + (firmaCoordinador?.apellido?.toUpperCase() ?: ''), times8bold), prmsHeaderHoja)
//        }else{
//            addCellTabla(tablaFirmas, new Paragraph("Coordinador no asignado", times8bold), prmsHeaderHoja)
//        }

        //cargos

        if(obra?.codigo?.contains("-OF")){
            addCellTabla(tablaFirmas, new Paragraph("OFERENTE", times8bold), prmsHeaderHoja)
        }
        addCellTabla(tablaFirmas, new Paragraph("ELABORÓ", times8bold), prmsHeaderHoja)
        //        addCellTabla(tablaFirmas, new Paragraph("COORDINADOR", times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph("", times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph(personaElaboro?.departamento?.descripcion?.toUpperCase() ?: '', times8bold), prmsHeaderHoja)
//        addCellTabla(tablaFirmas, new Paragraph((firmaCoordinador?.departamento?.descripcion?.toUpperCase() ?: ''), times8bold), prmsHeaderHoja)
        addCellTabla(tablaFirmas, new Paragraph('', times8bold), prmsHeaderHoja)
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

    def documentosObraExcel() {

        def obra = Obra.get(params.id)
        def tasa = params.tasa
        def detalle = VolumenesObra.findAllByObra(obra, [sort: "orden"])
        def subPres = VolumenesObra.findAllByObra(obra, [sort: "orden"]).subPresupuesto.unique()
        def precios = [:]
        def fecha = obra.fechaPreciosRubros
        def dsps = obra.distanciaPeso
        def dsvl = obra.distanciaVolumen
        def lugar = obra.lugar
        def prch = 0
        def prvl = 0
        def indirecto = obra.totales / 100
        def c;
        def total1 = 0;
        def totales
        def totalPresupuesto;

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
        // fija el ancho de la columna
        // sheet.setColumnView(1,40)

        params.id = params.id.split(",")
        if (params.id.class == java.lang.String) {
            params.id = [params.id]
        }
        WritableFont times16font = new WritableFont(WritableFont.TIMES, 11, WritableFont.BOLD, false);
        WritableCellFormat times16format = new WritableCellFormat(times16font);
        sheet.setColumnView(0, 60)
        sheet.setColumnView(1, 12)
        sheet.setColumnView(2, 25)
        sheet.setColumnView(3, 25)
        sheet.setColumnView(4, 30)
        sheet.setColumnView(8, 20)
        // inicia textos y numeros para asocias a columnas
        def label
        def nmro
        def number

        def fila = 6;

        NumberFormat nf = new NumberFormat("#.##");
        WritableCellFormat cf2obj = new WritableCellFormat(nf);

        label = new Label(0, 2, "Presupuesto de la Obra: " + obra?.nombre.toString(), times16format);
        sheet.addCell(label);
        label = new Label(0, 4, "RUBRO", times16format); sheet.addCell(label);
        label = new Label(1, 4, "NOMBRE", times16format); sheet.addCell(label);
        label = new Label(2, 4, "UNDD", times16format); sheet.addCell(label);
        label = new Label(3, 4, "CANTIDAD", times16format); sheet.addCell(label);
        label = new Label(4, 4, "P_UNIT", times16format); sheet.addCell(label);
        label = new Label(5, 4, "SUBTOTAL", times16format); sheet.addCell(label);

        detalle.each {
            def res = preciosService.precioUnitarioVolumenObraSinOrderBy("sum(parcial)+sum(parcial_t) precio ", obra.id, it.item.id)
            precios.put(it.id.toString(), (res["precio"][0] + res["precio"][0] * indirecto).toDouble().round(2))
            def precioUnitario = precios[it.id.toString()]
            def subtotal = (precios[it.id.toString()] * it.cantidad)
            label = new Label(0, fila, it?.item?.codigo.toString()); sheet.addCell(label);
            label = new Label(1, fila, it?.item?.nombre.toString()); sheet.addCell(label);
            label = new Label(2, fila, it?.item?.unidad?.codigo.toString()); sheet.addCell(label);
            number = new jxl.write.Number(3, fila, it?.cantidad); sheet.addCell(number);
            number = new jxl.write.Number(4, fila, precioUnitario, cf2obj); sheet.addCell(number);
            number = new jxl.write.Number(5, fila, subtotal, cf2obj); sheet.addCell(number);
            fila++
//            return totalPresupuesto
        }

        workbook.write();
        workbook.close();
        def output = response.getOutputStream()
        def header = "attachment; filename=" + "DocumentosObraExcel.xls";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        output.write(file.getBytes());
    }

    def documentosObraTasaExcel() {

        def obra = Obra.get(params.id)
        def tasa = params.tasa
        def detalle = VolumenesObra.findAllByObra(obra, [sort: "orden"])
        def subPres = VolumenesObra.findAllByObra(obra, [sort: "orden"]).subPresupuesto.unique()
        def precios = [:]
        def fecha = obra.fechaPreciosRubros
        def dsps = obra.distanciaPeso
        def dsvl = obra.distanciaVolumen
        def lugar = obra.lugar
        def prch = 0
        def prvl = 0
        def indirecto = obra.totales / 100
        def c;
        def total1 = 0;
        def totales
        def totalPresupuesto;

        NumberFormat nf = new NumberFormat("#.##");
        WritableCellFormat cf2obj = new WritableCellFormat(nf);

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
        // fija el ancho de la columna
        // sheet.setColumnView(1,40)
        params.id = params.id.split(",")
        if (params.id.class == java.lang.String) {
            params.id = [params.id]
        }
        WritableFont times16font = new WritableFont(WritableFont.TIMES, 11, WritableFont.BOLD, true);
        WritableCellFormat times16format = new WritableCellFormat(times16font);
        sheet.setColumnView(0, 60)
        sheet.setColumnView(1, 12)
        sheet.setColumnView(2, 25)
        sheet.setColumnView(3, 25)
        sheet.setColumnView(4, 30)
        sheet.setColumnView(8, 20)
        // inicia textos y numeros para asocias a columnas

        def label
        def nmro
        def number

        def fila = 6;

        label = new Label(0, 2, "Presupuesto de la Obra: " + obra?.nombre.toString(), times16format);
        sheet.addCell(label);

        label = new Label(0, 4, "RUBRO", times16format); sheet.addCell(label);
        label = new Label(1, 4, "NOMBRE", times16format); sheet.addCell(label);
        label = new Label(2, 4, "UNDD", times16format); sheet.addCell(label);
        label = new Label(3, 4, "CANTIDAD", times16format); sheet.addCell(label);
        label = new Label(4, 4, "P_UNIT", times16format); sheet.addCell(label);
        label = new Label(5, 4, "SUBTOTAL", times16format); sheet.addCell(label);

        detalle.each {
            def res = preciosService.precioUnitarioVolumenObraSinOrderBy("sum(parcial)+sum(parcial_t) precio ", obra.id, it.item.id)
            precios.put(it.id.toString(), (res["precio"][0] + res["precio"][0] * indirecto).toDouble().round(2))
            def precioUnitario = (precios[it.id.toString()]) * tasa.toDouble()
            def subtotal = (((precios[it.id.toString()]) * tasa.toDouble()) * it.cantidad)
            label = new Label(0, fila, it?.item?.codigo.toString()); sheet.addCell(label);
            label = new Label(1, fila, it?.item?.nombre.toString()); sheet.addCell(label);
            label = new Label(2, fila, it?.item?.unidad?.codigo.toString()); sheet.addCell(label);
            number = new jxl.write.Number(3, fila, it?.cantidad); sheet.addCell(number);
            number = new jxl.write.Number(4, fila, precioUnitario, cf2obj); sheet.addCell(number);
            number = new jxl.write.Number(5, fila, subtotal, cf2obj); sheet.addCell(number);
            fila++
        }

        workbook.write();
        workbook.close();
        def output = response.getOutputStream()
        def header = "attachment; filename=" + "DocumentosObraExcelTasa.xls";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        output.write(file.getBytes());
    }

    def dummyReportes() {
        return false
    }

    def pagarAnticipoPdf() {
        def baos = new ByteArrayOutputStream()
        def name = "pagarAnticipo_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        Font times12bold = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font times10bold = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8bold = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        Font times8normal = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL)
        Font times10boldWhite = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8boldWhite = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        times8boldWhite.setColor(Color.WHITE)
        times10boldWhite.setColor(Color.WHITE)
        def fonts = [times12bold: times12bold, times10bold: times10bold, times8bold: times8bold,
                     times10boldWhite: times10boldWhite, times8boldWhite: times8boldWhite, times8normal: times8normal]
        Document document
        document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);
        document.open();
        document.addTitle("Pagar Anticipo " + new Date().format("dd_MM_yyyy"));
        document.addSubject("Generado por el sistema Janus");
        document.addKeywords("reporte, janus, rubros");
        document.addAuthor("Janus");
        document.addCreator("Tedein SA");

        def prmsHeaderHoja = [border: Color.WHITE]
        def prmsHeader = [border: Color.WHITE, colspan: 7, bg: new Color(73, 175, 205),
                          align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsHeader2 = [border: Color.WHITE, colspan: 3, bg: new Color(73, 175, 205),
                           align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead = [border: Color.WHITE, bg: new Color(73, 175, 205),
                            align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellCenter = [border: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellLeft = [border: Color.BLACK, valign: Element.ALIGN_MIDDLE]
        def prmsSubtotal = [border: Color.BLACK, colspan: 6,
                            align : Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsNum = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prms = [prmsHeaderHoja: prmsHeaderHoja, prmsHeader: prmsHeader, prmsHeader2: prmsHeader2,
                    prmsCellHead: prmsCellHead, prmsCell: prmsCellCenter, prmsCellLeft: prmsCellLeft, prmsSubtotal: prmsSubtotal, prmsNum: prmsNum]

        def planilla = janus.ejecucion.Planilla.get(params.id)
        def contrato = Contrato.get(planilla?.contrato?.id)
        def obra = Obra.get(contrato?.oferta?.concurso?.obra?.id)
        def suma = (planilla?.reajuste + planilla?.valor)

        PdfPTable headerRubroTabla = new PdfPTable(4); // 4 columns.
        headerRubroTabla.setWidthPercentage(100);
        headerRubroTabla.setWidths(arregloEnteros([10, 40, 10, 40]))


        addCellTabla(headerRubroTabla, new Paragraph("Obra1:", times8bold), prmsHeaderHoja)
        addCellTabla(headerRubroTabla, new Paragraph(obra?.nombre + " " + obra?.descripcion, times8normal), prmsHeaderHoja)
        addCellTabla(headerRubroTabla, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(headerRubroTabla, new Paragraph(" ", times8normal), prmsHeaderHoja)
        addCellTabla(headerRubroTabla, new Paragraph("Lugar:", times8bold), prmsHeaderHoja)
        addCellTabla(headerRubroTabla, new Paragraph(obra?.lugar?.descripcion, times8normal), prmsHeaderHoja)
        addCellTabla(headerRubroTabla, new Paragraph("Planilla:", times8bold), prmsHeaderHoja)
        addCellTabla(headerRubroTabla, new Paragraph(g.formatNumber(number: planilla?.numero, minFractionDigits: 2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), fonts.times8normal), prmsHeaderHoja)
        addCellTabla(headerRubroTabla, new Paragraph("Ubicación:", times8bold), prmsHeaderHoja)
        addCellTabla(headerRubroTabla, new Paragraph(obra?.parroquia?.nombre + " " + obra?.parroquia?.canton?.nombre, times8normal), prmsHeaderHoja)
        addCellTabla(headerRubroTabla, new Paragraph("Monto Contrato:", times8bold), prmsHeaderHoja)
        addCellTabla(headerRubroTabla, new Paragraph(g.formatNumber(number: contrato?.monto, minFractionDigits: 2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), fonts.times8normal), prmsHeaderHoja)
        addCellTabla(headerRubroTabla, new Paragraph("Contratista:", times8bold), prmsHeaderHoja)
        addCellTabla(headerRubroTabla, new Paragraph(contrato?.oferta?.proveedor?.nombre, times8normal), prmsHeaderHoja)
        addCellTabla(headerRubroTabla, new Paragraph("Período:", times8bold), prmsHeaderHoja)
        addCellTabla(headerRubroTabla, new Paragraph((planilla.tipoPlanilla.codigo == 'A' ? 'Anticipo' : 'del ' + planilla.fechaInicio.format('dd-MM-yyyy') + ' al ' + planilla.fechaFin.format('dd-MM-yyyy')), times8normal), prmsHeaderHoja)
        addCellTabla(headerRubroTabla, new Paragraph("Plazo:", times8bold), prmsHeaderHoja)
        addCellTabla(headerRubroTabla, new Paragraph(g.formatNumber(number: contrato?.plazo, minFractionDigits: 2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), fonts.times8normal), prmsHeaderHoja)
        addCellTabla(headerRubroTabla, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(headerRubroTabla, new Paragraph(" ", times8normal), prmsHeaderHoja)
        addCellTabla(headerRubroTabla, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(headerRubroTabla, new Paragraph(" ", times8normal), prmsHeaderHoja)
        addCellTabla(headerRubroTabla, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(headerRubroTabla, new Paragraph(" ", times8normal), prmsHeaderHoja)

        PdfPTable anticipoTabla = new PdfPTable(2);
        anticipoTabla.setWidthPercentage(100);
        anticipoTabla.setWidths(arregloEnteros([50, 50]))

        if (planilla?.tipoPlanilla?.codigo == 'A') {
            addCellTabla(anticipoTabla, new Paragraph(contrato?.porcentajeAnticipo + " % de anticipo:", times8bold), prmsHeaderHoja)
            addCellTabla(anticipoTabla, new Paragraph(g.formatNumber(number: planilla?.valor, minFractionDigits: 2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), fonts.times8normal), prmsHeaderHoja)
            addCellTabla(anticipoTabla, new Paragraph("(+) Reajuste provisional del anticipo", times8bold), prmsHeaderHoja)
            addCellTabla(anticipoTabla, new Paragraph(g.formatNumber(number: planilla?.reajuste, minFractionDigits: 2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), fonts.times8normal), prmsHeaderHoja)
            addCellTabla(anticipoTabla, new Paragraph("SUMA:", times8bold), prmsHeaderHoja)
            addCellTabla(anticipoTabla, new Paragraph(g.formatNumber(number: suma, minFractionDigits: 2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), fonts.times8normal), prmsHeaderHoja)
            addCellTabla(anticipoTabla, new Paragraph("A FAVOR DEL CONTRATISTA:", times8bold), prmsHeaderHoja)
            addCellTabla(anticipoTabla, new Paragraph(g.formatNumber(number: suma, minFractionDigits: 2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), fonts.times8normal), prmsHeaderHoja)

        } else {
            addCellTabla(anticipoTabla, new Paragraph("Valor Planilla", times8bold), prmsHeaderHoja)
            addCellTabla(anticipoTabla, new Paragraph(g.formatNumber(number: planilla?.valor, minFractionDigits: 2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), fonts.times8normal), prmsHeaderHoja)
            addCellTabla(anticipoTabla, new Paragraph("(+) Reajuste provisional del anticipo", times8bold), prmsHeaderHoja)
            addCellTabla(anticipoTabla, new Paragraph(g.formatNumber(number: planilla?.reajuste, minFractionDigits: 2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), fonts.times8normal), prmsHeaderHoja)
            addCellTabla(anticipoTabla, new Paragraph("SUMA:", times8bold), prmsHeaderHoja)
            addCellTabla(anticipoTabla, new Paragraph(g.formatNumber(number: suma, minFractionDigits: 2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), fonts.times8normal), prmsHeaderHoja)
            addCellTabla(anticipoTabla, new Paragraph("A FAVOR DEL CONTRATISTA:", times8bold), prmsHeaderHoja)
            addCellTabla(anticipoTabla, new Paragraph(g.formatNumber(number: suma, minFractionDigits: 2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), fonts.times8normal), prmsHeaderHoja)
        }

        document.add(headerRubroTabla);
        document.add(anticipoTabla);
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }


    def anticipoReporte() {

        def planilla = Planilla.get(params.id)
        def obra = planilla.contrato.oferta.concurso.obra
        def contrato = planilla.contrato
        def oferta = contrato.oferta
        def tramite = Tramite.findByPlanilla(planilla)
        def prsn = PersonasTramite.findAllByTramite(tramite, [sort: "rolTramite"])
        def planillas = Planilla.withCriteria {
            and {
                eq("contrato", contrato)
                or {
                    lt("fechaInicio", planilla.fechaFin)
                    isNull("fechaInicio")
                }
                order("id", "asc")
            }
        }

        def diasPlanilla = 0

        if (planilla.tipoPlanilla.codigo != "A") {
            diasPlanilla = planilla.fechaFin - planilla.fechaInicio
        }
        def valorPlanilla = planilla.valor
        def acumuladoCrono = 0, acumuladoPlan = 0
        def diasAll = 0
        def detalle = VolumenesObra.findAllByObra(obra, [sort: "orden"])
        def precios = [:]
        def indirecto = obra.totales / 100

        preciosService.ac_rbroObra(obra.id)

        detalle.each {
            def res = preciosService.precioUnitarioVolumenObraSinOrderBy("sum(parcial)+sum(parcial_t) precio ", obra.id, it.item.id)
            precios.put(it.id.toString(), (res["precio"][0] + res["precio"][0] * indirecto).toDouble().round(2))
        }

        def planillasAnteriores = Planilla.withCriteria {
            eq("contrato", contrato)
            lt("fechaFin", planilla.fechaInicio)
        }

        def numerosALetras = NumberToLetterConverter.convertNumberToLetter(planilla?.valor + planilla?.reajuste)
        return [planilla: planilla, obra: obra, oferta: oferta, contrato: contrato, numerosALetras: numerosALetras, tramite: tramite, prsn: prsn]
    }


    def _aseguradoras() {
        def asg = Aseguradora.list()
        renderPdf(template:'/reportes/aseguradoras', model: [asg: asg], filename: 'aseguradoras.pdf')
    }


    def reporteComposicion() {

        def obra = Obra.get(params.id)
        def totales
        def valorTotal
        def total1 = 0
        def totalesMano
        def valorTotalMano
        def total2 = 0
        def totalesEquipos
        def valorTotalEquipos
        def total3 = 0


        if (!params.tipo) {
            params.tipo = "-1"
        }
        if (!params.rend) {
            params.rend = "screen"
        }
        if (!params.sp) {
            params.sp = '-1'
        }
        if (params.tipo == "-1") {
            params.tipo = "1,2,3"
        }
        def wsp = ""
        if (params.sp.toString() != "-1") {
            wsp = "      AND v.sbpr__id = ${params.sp} \n"
        }



//        def sql = "SELECT i.itemcdgo codigo, i.itemnmbr item, u.unddcdgo unidad, sum(v.voitcntd) cantidad, \n" +
//                "v.voitpcun punitario, v.voittrnp transporte, v.voitpcun + v.voittrnp  costo, \n" +
//                "sum((v.voitpcun + v.voittrnp) * v.voitcntd)  total, g.grpodscr grupo, g.grpo__id grid \n" +
//                "FROM vlobitem v INNER JOIN item i ON v.item__id = i.item__id\n" +
//                "INNER JOIN undd u ON i.undd__id = u.undd__id\n" +
//                "INNER JOIN dprt d ON i.dprt__id = d.dprt__id\n" +
//                "INNER JOIN sbgr s ON d.sbgr__id = s.sbgr__id\n" +
//                "INNER JOIN grpo g ON s.grpo__id = g.grpo__id AND g.grpo__id IN (${params.tipo}) \n" +
//                "WHERE v.obra__id = ${params.id} and v.voitcntd >0 \n" + wsp +
//                "group by i.itemcdgo, i.itemnmbr, u.unddcdgo, v.voitpcun, v.voittrnp, v.voitpcun, \n" +
//                "g.grpo__id, g.grpodscr " +
//                "ORDER BY g.grpo__id ASC, i.itemcdgo"

        def sql = "SELECT item.itemcdgo codigo, itemnmbr item, unddcdgo unidad, sum(voitcntd) cantidad, " +
                "voitpcun punitario, voittrnp transporte, voitpcun + voittrnp  costo, " +
                "sum((voitpcun + voittrnp) * voitcntd)  total, grpodscr grupo, grpo.grpo__id grid " +
                "from vlobitem, item, undd, dprt, sbgr, grpo " +
                "where vlobitem.obra__id = ${params.id} and item.item__id = vlobitem.item__id and " +
                "undd.undd__id = item.undd__id and dprt.dprt__id = item.dprt__id and " +
                "sbgr.sbgr__id = dprt.sbgr__id and grpo.grpo__id = sbgr.grpo__id and " +
                "voitcntd > 0 and grpo.grpo__id in (${params.tipo}) " + wsp +
                "group by item.itemcdgo, itemnmbr, unddcdgo, voitpcun, voittrnp, voitpcun, grpo.grpo__id, grpodscr " +
                "ORDER BY grpo.grpo__id ASC, item.itemcdgo"

        println "--sql: $sql"
        def cn = dbConnectionService.getConnection()
        def res = cn.rows(sql.toString())


        def baos = new ByteArrayOutputStream()
        def name = "composicion_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        Font times12bold = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font times10bold = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times18bold = new Font(Font.TIMES_ROMAN, 18, Font.BOLD);
        Font times14bold = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font times8bold = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        Font times8normal = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL)
        Font times10boldWhite = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8boldWhite = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        times8boldWhite.setColor(Color.BLACK)
        times10boldWhite.setColor(Color.BLACK)
        def fonts = [times12bold: times12bold, times10bold: times10bold, times8bold: times8bold,
                     times10boldWhite: times10boldWhite, times8boldWhite: times8boldWhite, times8normal: times8normal]

        Document document
        document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);
        document.open();
        document.addTitle("Composicion " + new Date().format("dd_MM_yyyy"));
        document.addSubject("Generado por el sistema Janus");
        document.addKeywords("reporte, janus, composicion");
        document.addAuthor("Janus");
        document.addCreator("Tedein SA");

        def prmsHeaderHoja = [border: Color.WHITE]
        def prmsHeader = [border: Color.WHITE, colspan: 7,
                          align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsRight = [border: Color.WHITE, colspan: 7,
                         align : Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsHeader2 = [border: Color.WHITE, colspan: 3,
                           align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead = [border: Color.WHITE,
                            align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead3 = [border: Color.WHITE,
                             align : Element.ALIGN_LEFT, valign: Element.ALIGN_LEFT]
        def prmsCellHead2 = [border: Color.WHITE,
                             align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE, bordeTop: "1", bordeBot: "1"]
        def prmsCellIzquierda = [border: Color.WHITE,
                                 align : Element.ALIGN_LEFT, valign: Element.ALIGN_LEFT]
        def prmsCellDerecha = [border: Color.WHITE,
                               align : Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsCellDerecha2 = [border: Color.WHITE,
                                align : Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT, bordeTop: "1", bordeBot: "1"]
        def prmsCellCenter = [border: Color.WHITE, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellLeft = [border: Color.WHITE, valign: Element.ALIGN_MIDDLE]
        def prmsSubtotal = [border: Color.WHITE, colspan: 6,
                            align : Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsNum = [border: Color.WHITE, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        def prms = [prmsHeaderHoja: prmsHeaderHoja, prmsHeader: prmsHeader, prmsHeader2: prmsHeader2,
                    prmsCellHead: prmsCellHead, prmsCell: prmsCellCenter, prmsCellLeft: prmsCellLeft, prmsSubtotal: prmsSubtotal, prmsNum: prmsNum, prmsRight: prmsRight,
                    prmsCellDerecha: prmsCellDerecha, prmsCellIzquierda: prmsCellIzquierda]

        Paragraph headersTitulo = new Paragraph();
        addEmptyLine(headersTitulo, 1);
        headersTitulo.setAlignment(Element.ALIGN_CENTER);
        headersTitulo.add(new Paragraph((Auxiliar.get(1)?.titulo ?: ''), times18bold));
        headersTitulo.add(new Paragraph("COMPOSICIÓN", times14bold));
        headersTitulo.add(new Paragraph(obra?.departamento?.direccion?.nombre, times12bold));
        headersTitulo.add(new Paragraph("", times12bold));
        document.add(headersTitulo)

        PdfPTable header = new PdfPTable(3)
        header.setWidthPercentage(100)
        header.setWidths(arregloEnteros([25, 8, 65]))

        addCellTabla(header, new Paragraph("", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph("", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph("", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph("OBRA", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(" : ", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(obra?.nombre, times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph("CÓDIGO", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(" : ", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(obra?.codigo, times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph("DOCUMENTO DE REFERENCIA", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(" : ", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(obra?.oficioIngreso, times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph("FECHA", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(" : ", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(printFecha(obra?.fechaCreacionObra), times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph("FECHA ACT. PRECIOS", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(" : ", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(printFecha(obra?.fechaPreciosRubros), times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph("", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph("", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph("", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph("", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph("", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph("", times8bold), prmsCellHead3)

        document.add(header);


        PdfPTable tablaHeader = new PdfPTable(8)
        tablaHeader.setWidthPercentage(100)
        tablaHeader.setWidths(arregloEnteros([12, 36, 5, 9, 9, 9, 10, 10]))

        PdfPTable tablaTitulo = new PdfPTable(2)
        tablaTitulo.setWidthPercentage(100)
        tablaTitulo.setWidths(arregloEnteros([90, 10]))

        PdfPTable tablaComposicion = new PdfPTable(8)
        tablaComposicion.setWidthPercentage(100)
        tablaComposicion.setWidths(arregloEnteros([12, 36, 5, 9, 9, 9, 10, 10]))

        PdfPTable tablaTotales = new PdfPTable(2)
        tablaTotales.setWidthPercentage(100)
        tablaTotales.setWidths(arregloEnteros([70, 30]))


        addCellTabla(tablaHeader, new Paragraph("Código", times8bold), prmsCellHead2)
        addCellTabla(tablaHeader, new Paragraph("Item", times8bold), prmsCellHead2)
        addCellTabla(tablaHeader, new Paragraph("U", times8bold), prmsCellHead2)
        addCellTabla(tablaHeader, new Paragraph("Cantidad", times8bold), prmsCellHead2)
        addCellTabla(tablaHeader, new Paragraph("Precio Unitario", times8bold), prmsCellDerecha2)
        addCellTabla(tablaHeader, new Paragraph("Transporte", times8bold), prmsCellDerecha2)
        addCellTabla(tablaHeader, new Paragraph("Costo", times8bold), prmsCellDerecha2)
        addCellTabla(tablaHeader, new Paragraph("Total", times8bold), prmsCellDerecha2)


        addCellTabla(tablaTitulo, new Paragraph("Materiales ", times14bold), prmsCellIzquierda)
        addCellTabla(tablaTitulo, new Paragraph(" ", times10bold), prmsCellIzquierda)



        res.each { r ->

            if (r?.grid == 1) {

                addCellTabla(tablaComposicion, new Paragraph(r?.codigo, times8normal), prmsCellIzquierda)
                addCellTabla(tablaComposicion, new Paragraph(r?.item, times8normal), prmsCellIzquierda)
                addCellTabla(tablaComposicion, new Paragraph(r?.unidad, times8normal), prmsCellHead)
                addCellTabla(tablaComposicion, new Paragraph(g.formatNumber(number: r?.cantidad, minFractionDigits:
                        3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times8normal), prmsNum)
                addCellTabla(tablaComposicion, new Paragraph(g.formatNumber(number: r?.punitario, minFractionDigits:
                        3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times8normal), prmsNum)
                addCellTabla(tablaComposicion, new Paragraph(g.formatNumber(number: r?.transporte, minFractionDigits:
                        3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times8normal), prmsNum)
                addCellTabla(tablaComposicion, new Paragraph(g.formatNumber(number: r?.costo, minFractionDigits:
                        3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times8normal), prmsNum)
                addCellTabla(tablaComposicion, new Paragraph(g.formatNumber(number: r?.total, minFractionDigits:
                        3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times8normal), prmsNum)

                totales = r?.total

                valorTotal = (total1 += totales)
            }

        }

        addCellTabla(tablaTotales, new Paragraph("Total Materiales", times10bold), prmsCellDerecha)
        addCellTabla(tablaTotales, new Paragraph(g.formatNumber(number: valorTotal ?: 0, minFractionDigits:
                3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times10bold), prmsNum)

        addCellTabla(tablaTotales, new Paragraph(" ", times10bold), prmsNum)
        addCellTabla(tablaTotales, new Paragraph(" ", times10bold), prmsNum)

        PdfPTable tablaTitulo2 = new PdfPTable(2)
        tablaTitulo2.setWidthPercentage(100)
        tablaTitulo2.setWidths(arregloEnteros([90, 10]))

        PdfPTable tablaComposicion2 = new PdfPTable(8)
        tablaComposicion2.setWidthPercentage(100)
        tablaComposicion2.setWidths(arregloEnteros([12, 36, 5, 9, 9, 9, 10, 10]))

        PdfPTable tablaTotalesMano = new PdfPTable(2)
        tablaTotalesMano.setWidthPercentage(100)
        tablaTotalesMano.setWidths(arregloEnteros([70, 30]))

        addCellTabla(tablaTitulo2, new Paragraph("Mano de obra ", times14bold), prmsCellIzquierda)
        addCellTabla(tablaTitulo2, new Paragraph(" ", times10bold), prmsCellIzquierda)



        res.each { j ->
            if (j?.grid == 2) {
                addCellTabla(tablaComposicion2, new Paragraph(j?.codigo, times8normal), prmsCellIzquierda)
                addCellTabla(tablaComposicion2, new Paragraph(j?.item, times8normal), prmsCellIzquierda)
                addCellTabla(tablaComposicion2, new Paragraph(j?.unidad, times8normal), prmsCellHead)
                addCellTabla(tablaComposicion2, new Paragraph(g.formatNumber(number: j?.cantidad, minFractionDigits:
                        3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times8normal), prmsNum)
                addCellTabla(tablaComposicion2, new Paragraph(g.formatNumber(number: j?.punitario, minFractionDigits:
                        3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times8normal), prmsNum)
                addCellTabla(tablaComposicion2, new Paragraph(g.formatNumber(number: j?.transporte, minFractionDigits:
                        3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times8normal), prmsNum)
                addCellTabla(tablaComposicion2, new Paragraph(g.formatNumber(number: j?.costo, minFractionDigits:
                        3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times8normal), prmsNum)
                addCellTabla(tablaComposicion2, new Paragraph(g.formatNumber(number: j?.total, minFractionDigits:
                        3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times8normal), prmsNum)

                totalesMano = j?.total
                valorTotalMano = (total2 += totalesMano)
            }

        }

        addCellTabla(tablaTotalesMano, new Paragraph("Total Mano de Obra:", times10bold), prmsCellDerecha)
        addCellTabla(tablaTotalesMano, new Paragraph(g.formatNumber(number: valorTotalMano ?: 0, minFractionDigits:
                3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times10bold), prmsNum)

        addCellTabla(tablaTotalesMano, new Paragraph(" ", times10bold), prmsNum)
        addCellTabla(tablaTotalesMano, new Paragraph(" ", times10bold), prmsNum)


        PdfPTable tablaTitulo3 = new PdfPTable(2)
        tablaTitulo3.setWidthPercentage(100)
        tablaTitulo3.setWidths(arregloEnteros([90, 10]))

        PdfPTable tablaComposicion3 = new PdfPTable(8)
        tablaComposicion3.setWidthPercentage(100)
        tablaComposicion3.setWidths(arregloEnteros([12, 36, 5, 9, 9, 9, 10, 10]))

        PdfPTable tablaTotalesEquipos = new PdfPTable(2)
        tablaTotalesEquipos.setWidthPercentage(100)
        tablaTotalesEquipos.setWidths(arregloEnteros([70, 30]))


        addCellTabla(tablaTitulo3, new Paragraph("Equipos ", times14bold), prmsCellIzquierda)
        addCellTabla(tablaTitulo3, new Paragraph(" ", times10bold), prmsCellIzquierda)


        res.each { k ->

            if (k?.grid == 3) {
                addCellTabla(tablaComposicion3, new Paragraph(k?.codigo, times8normal), prmsCellIzquierda)
                addCellTabla(tablaComposicion3, new Paragraph(k?.item, times8normal), prmsCellIzquierda)
                addCellTabla(tablaComposicion3, new Paragraph(k?.unidad, times8normal), prmsCellHead)
                addCellTabla(tablaComposicion3, new Paragraph(g.formatNumber(number: k?.cantidad, minFractionDigits:
                        3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times8normal), prmsNum)
                addCellTabla(tablaComposicion3, new Paragraph(g.formatNumber(number: k?.punitario, minFractionDigits:
                        3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times8normal), prmsNum)
                addCellTabla(tablaComposicion3, new Paragraph(g.formatNumber(number: k?.transporte, minFractionDigits:
                        3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times8normal), prmsNum)
                addCellTabla(tablaComposicion3, new Paragraph(g.formatNumber(number: k?.costo, minFractionDigits:
                        3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times8normal), prmsNum)
                addCellTabla(tablaComposicion3, new Paragraph(g.formatNumber(number: k?.total, minFractionDigits:
                        3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times8normal), prmsNum)

                totalesEquipos = k?.total
                valorTotalEquipos = (total3 += totalesEquipos)


            }

        }

        addCellTabla(tablaTotalesEquipos, new Paragraph("Total Equipos:", times10bold), prmsCellDerecha)
        addCellTabla(tablaTotalesEquipos, new Paragraph(g.formatNumber(number: valorTotalEquipos ?: 0, minFractionDigits:
                3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times10bold), prmsNum)

//
        PdfPTable tablaTotalGeneral = new PdfPTable(2)
        tablaTotalGeneral.setWidthPercentage(100)
        tablaTotalGeneral.setWidths(arregloEnteros([70, 30]))

//        addCellTabla(tablaTotalGeneral, new Paragraph("Total General:", times10bold), prmsCellDerecha)
        addCellTabla(tablaTotalGeneral, new Paragraph("Total Directo:", times10bold), prmsCellDerecha)
        addCellTabla(tablaTotalGeneral, new Paragraph(g.formatNumber(number: ((valorTotal ?: 0) + (valorTotalMano ?: 0) + (valorTotalEquipos ?: 0)), minFractionDigits:
                3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times10bold), prmsNum)

        addCellTabla(tablaTotalGeneral, new Paragraph("Total Indirecto:", times10bold), prmsCellDerecha)
        addCellTabla(tablaTotalGeneral, new Paragraph(g.formatNumber(number: (obra?.valor ? obra?.valor - ((valorTotal ?: 0) + (valorTotalMano ?: 0) + (valorTotalEquipos ?: 0)) : 0), minFractionDigits:
                3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times10bold), prmsNum)

        addCellTabla(tablaTotalGeneral, new Paragraph("Total:", times10bold), prmsCellDerecha)
        addCellTabla(tablaTotalGeneral, new Paragraph(g.formatNumber(number: (obra?.valor ?: 0), minFractionDigits:
                3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times10bold), prmsNum)

        document.add(tablaHeader);
        document.add(tablaTitulo);
        document.add(tablaComposicion);
        document.add(tablaTotales)
        document.add(tablaTitulo2)
        document.add(tablaComposicion2);
        document.add(tablaTotalesMano)
        document.add(tablaTitulo3)
        document.add(tablaComposicion3);
        document.add(tablaTotalesEquipos)
        document.add(tablaTotalGeneral)
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def reporteComposicionMat() {

//        println("-->>" + params)

        def obra = Obra.get(params.id)
        def totales
        def valorTotal = 0
        def total1 = 0
        def totalesMano
        def valorTotalMano
        def total2 = 0
        def totalesEquipos
        def valorTotalEquipos
        def total3 = 0

        if (!params.rend) {
            params.rend = "screen"
        }
        if (!params.sp) {
            params.sp = '-1'
        }
        params.tipo = "1"

        def wsp = ""
        if (params.sp.toString() != "-1") {
            println("entro")
            wsp = "      AND v.sbpr__id = ${params.sp} \n"
        }

        def sql = "SELECT i.itemcdgo codigo, i.itemnmbr item, u.unddcdgo unidad, sum(v.voitcntd) cantidad, \n" +
                "v.voitpcun punitario, v.voittrnp transporte, v.voitpcun + v.voittrnp  costo, \n" +
                "sum((v.voitpcun + v.voittrnp) * v.voitcntd)  total, g.grpodscr grupo, g.grpo__id grid \n" +
                "FROM vlobitem v INNER JOIN item i ON v.item__id = i.item__id\n" +
                "INNER JOIN undd u ON i.undd__id = u.undd__id\n" +
                "INNER JOIN dprt d ON i.dprt__id = d.dprt__id\n" +
                "INNER JOIN sbgr s ON d.sbgr__id = s.sbgr__id\n" +
                "INNER JOIN grpo g ON s.grpo__id = g.grpo__id AND g.grpo__id IN (${params.tipo}) \n" +
                "WHERE v.obra__id = ${params.id} and v.voitcntd >0 \n" + wsp +
                "group by i.itemcdgo, i.itemnmbr, u.unddcdgo, v.voitpcun, v.voittrnp, v.voitpcun, \n" +
                "g.grpo__id, g.grpodscr " +
                "ORDER BY g.grpo__id ASC, i.itemcdgo"

//        println(sql)

        def cn = dbConnectionService.getConnection()
        def res = cn.rows(sql.toString())

        def baos = new ByteArrayOutputStream()
        def name = "composicion_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        Font times12bold = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font times14bold = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font times18bold = new Font(Font.TIMES_ROMAN, 18, Font.BOLD);
        Font times10bold = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8bold = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        Font times8normal = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL)
        Font times10boldWhite = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8boldWhite = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        times8boldWhite.setColor(Color.BLACK)
        times10boldWhite.setColor(Color.BLACK)
        def fonts = [times12bold: times12bold, times10bold: times10bold, times8bold: times8bold,
                     times10boldWhite: times10boldWhite, times8boldWhite: times8boldWhite, times8normal: times8normal]

        Document document
        document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);
        document.open();
        document.addTitle("Composicion " + new Date().format("dd_MM_yyyy"));
        document.addSubject("Generado por el sistema Janus");
        document.addKeywords("reporte, janus, composicion");
        document.addAuthor("Janus");
        document.addCreator("Tedein SA");

        def prmsHeaderHoja = [border: Color.WHITE]
        def prmsHeader = [border: Color.WHITE, colspan: 7,
                          align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsRight = [border: Color.WHITE, colspan: 7,
                         align : Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsHeader2 = [border: Color.WHITE, colspan: 3,
                           align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead = [border: Color.WHITE,
                            align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead3 = [border: Color.WHITE,
                             align : Element.ALIGN_LEFT, valign: Element.ALIGN_LEFT]
        def prmsCellHead2 = [border: Color.WHITE,
                             align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE, bordeTop: "1", bordeBot: "1"]
        def prmsCellIzquierda = [border: Color.WHITE,
                                 align : Element.ALIGN_LEFT, valign: Element.ALIGN_LEFT]
        def prmsCellDerecha = [border: Color.WHITE,
                               align : Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsCellDerecha2 = [border: Color.WHITE,
                                align : Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT, bordeTop: "1", bordeBot: "1"]
        def prmsCellCenter = [border: Color.WHITE, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellLeft = [border: Color.WHITE, valign: Element.ALIGN_MIDDLE]
        def prmsSubtotal = [border: Color.WHITE, colspan: 6,
                            align : Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsNum = [border: Color.WHITE, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        def prms = [prmsHeaderHoja: prmsHeaderHoja, prmsHeader: prmsHeader, prmsHeader2: prmsHeader2,
                    prmsCellHead: prmsCellHead, prmsCell: prmsCellCenter, prmsCellLeft: prmsCellLeft, prmsSubtotal: prmsSubtotal, prmsNum: prmsNum, prmsRight: prmsRight,
                    prmsCellDerecha: prmsCellDerecha, prmsCellIzquierda: prmsCellIzquierda]

        Paragraph headersTitulo = new Paragraph();
        addEmptyLine(headersTitulo, 1);
        headersTitulo.setAlignment(Element.ALIGN_CENTER);
        headersTitulo.add(new Paragraph((Auxiliar.get(1)?.titulo ?: ''), times18bold));
        headersTitulo.add(new Paragraph("COMPOSICIÓN", times14bold));
        headersTitulo.add(new Paragraph(obra?.departamento?.direccion?.nombre, times12bold));
        headersTitulo.add(new Paragraph("", times12bold));
        document.add(headersTitulo)

        PdfPTable header = new PdfPTable(3)
        header.setWidthPercentage(100)
        header.setWidths(arregloEnteros([25, 8, 65]))

        addCellTabla(header, new Paragraph("", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph("", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph("", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph("OBRA", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(" : ", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(obra?.nombre, times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph("CÓDIGO", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(" : ", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(obra?.codigo, times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph("DOCUMENTO DE REFERENCIA", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(" : ", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(obra?.oficioIngreso, times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph("FECHA", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(" : ", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(printFecha(obra?.fechaCreacionObra), times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph("FECHA ACT. PRECIOS", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(" : ", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(printFecha(obra?.fechaPreciosRubros), times8bold), prmsCellHead3)

        document.add(header);

        PdfPTable tablaHeader = new PdfPTable(8)
        tablaHeader.setWidthPercentage(100)
        tablaHeader.setWidths(arregloEnteros([12, 36, 5, 9, 9, 9, 10, 10]))

        PdfPTable tablaTitulo = new PdfPTable(2)
        tablaTitulo.setWidthPercentage(100)
        tablaTitulo.setWidths(arregloEnteros([90, 10]))

        PdfPTable tablaComposicion = new PdfPTable(8)
        tablaComposicion.setWidthPercentage(100)
        tablaComposicion.setWidths(arregloEnteros([12, 36, 5, 9, 9, 9, 10, 10]))

        PdfPTable tablaTotales = new PdfPTable(2)
        tablaTotales.setWidthPercentage(100)
        tablaTotales.setWidths(arregloEnteros([70, 30]))

        addCellTabla(tablaHeader, new Paragraph("Código", times8bold), prmsCellHead2)
        addCellTabla(tablaHeader, new Paragraph("Item", times8bold), prmsCellHead2)
        addCellTabla(tablaHeader, new Paragraph("U", times8bold), prmsCellHead2)
        addCellTabla(tablaHeader, new Paragraph("Cantidad", times8bold), prmsCellHead2)
        addCellTabla(tablaHeader, new Paragraph("Precio Unitario", times8bold), prmsCellDerecha2)
        addCellTabla(tablaHeader, new Paragraph("Transporte", times8bold), prmsCellDerecha2)
        addCellTabla(tablaHeader, new Paragraph("Costo", times8bold), prmsCellDerecha2)
        addCellTabla(tablaHeader, new Paragraph("Total", times8bold), prmsCellDerecha2)
        addCellTabla(tablaTitulo, new Paragraph("Materiales ", times14bold), prmsCellIzquierda)
        addCellTabla(tablaTitulo, new Paragraph(" ", times10bold), prmsCellIzquierda)

        res.each { r ->

            if (r?.grid == 1) {
                addCellTabla(tablaComposicion, new Paragraph(r?.codigo, times8normal), prmsCellIzquierda)
                addCellTabla(tablaComposicion, new Paragraph(r?.item, times8normal), prmsCellIzquierda)
                addCellTabla(tablaComposicion, new Paragraph(r?.unidad, times8normal), prmsCellHead)
                addCellTabla(tablaComposicion, new Paragraph(g.formatNumber(number: r?.cantidad, minFractionDigits:
                        3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times8normal), prmsNum)
                addCellTabla(tablaComposicion, new Paragraph(g.formatNumber(number: r?.punitario, minFractionDigits:
                        3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times8normal), prmsNum)
                addCellTabla(tablaComposicion, new Paragraph(g.formatNumber(number: r?.transporte, minFractionDigits:
                        3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times8normal), prmsNum)
                addCellTabla(tablaComposicion, new Paragraph(g.formatNumber(number: r?.costo, minFractionDigits:
                        3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times8normal), prmsNum)
                addCellTabla(tablaComposicion, new Paragraph(g.formatNumber(number: r?.total, minFractionDigits:
                        3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times8normal), prmsNum)

                totales = r?.total

                valorTotal = (total1 += totales)
            }

        }

        addCellTabla(tablaTotales, new Paragraph("Total Materiales", times10bold), prmsCellDerecha)
        addCellTabla(tablaTotales, new Paragraph(g.formatNumber(number: valorTotal, minFractionDigits: 3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times10bold), prmsNum)
        addCellTabla(tablaTotales, new Paragraph(" ", times10bold), prmsNum)
        addCellTabla(tablaTotales, new Paragraph(" ", times10bold), prmsNum)

        document.add(tablaTitulo);
        document.add(tablaHeader);
        document.add(tablaComposicion);
        document.add(tablaTotales)

        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def reporteComposicionMano() {

//        println("MO!!!!" + params)

        def obra = Obra.get(params.id)
        def totales
        def valorTotal
        def total1 = 0
        def totalesMano
        def valorTotalMano
        def total2 = 0
        def totalesEquipos
        def valorTotalEquipos
        def total3 = 0


        if (!params.tipo) {
            params.tipo = "-1"
        }
        if (!params.rend) {
            params.rend = "screen"
        }
        if (!params.sp) {
            params.sp = '-1'
        }
        if (params.tipo == "-1") {
            params.tipo = "1,2,3"
        }
        def wsp = ""
        if (params.sp.toString() != "-1") {
            println("entro")
            wsp = "      AND v.sbpr__id = ${params.sp} \n"
        }

        def sql = "SELECT i.itemcdgo codigo, i.itemnmbr item, u.unddcdgo unidad, sum(v.voitcntd) cantidad, \n" +
                "v.voitpcun punitario, v.voittrnp transporte, v.voitpcun + v.voittrnp  costo, \n" +
                "sum((v.voitpcun + v.voittrnp) * v.voitcntd)  total, g.grpodscr grupo, g.grpo__id grid \n" +
                "FROM vlobitem v INNER JOIN item i ON v.item__id = i.item__id\n" +
                "INNER JOIN undd u ON i.undd__id = u.undd__id\n" +
                "INNER JOIN dprt d ON i.dprt__id = d.dprt__id\n" +
                "INNER JOIN sbgr s ON d.sbgr__id = s.sbgr__id\n" +
                "INNER JOIN grpo g ON s.grpo__id = g.grpo__id AND g.grpo__id IN (${params.tipo}) \n" +
                "WHERE v.obra__id = ${params.id} and v.voitcntd >0 \n" + wsp +
                "group by i.itemcdgo, i.itemnmbr, u.unddcdgo, v.voitpcun, v.voittrnp, v.voitpcun, \n" +
                "g.grpo__id, g.grpodscr " +
                "ORDER BY g.grpo__id ASC, i.itemcdgo"

//        println(sql)

        def cn = dbConnectionService.getConnection()
        def res = cn.rows(sql.toString())


        def baos = new ByteArrayOutputStream()
        def name = "composicion_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        Font times12bold = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font times10bold = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times14bold = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font times18bold = new Font(Font.TIMES_ROMAN, 18, Font.BOLD);
        Font times8bold = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        Font times8normal = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL)
        Font times10boldWhite = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8boldWhite = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        times8boldWhite.setColor(Color.BLACK)
        times10boldWhite.setColor(Color.BLACK)
        def fonts = [times12bold: times12bold, times10bold: times10bold, times8bold: times8bold,
                     times10boldWhite: times10boldWhite, times8boldWhite: times8boldWhite, times8normal: times8normal]

        Document document
        document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);
        document.open();
        document.addTitle("Composicion " + new Date().format("dd_MM_yyyy"));
        document.addSubject("Generado por el sistema Janus");
        document.addKeywords("reporte, janus, composicion");
        document.addAuthor("Janus");
        document.addCreator("Tedein SA");

        def prmsHeaderHoja = [border: Color.WHITE]
        def prmsHeader = [border: Color.WHITE, colspan: 7,
                          align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsRight = [border: Color.WHITE, colspan: 7,
                         align : Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsHeader2 = [border: Color.WHITE, colspan: 3,
                           align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead = [border: Color.WHITE,
                            align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead3 = [border: Color.WHITE,
                             align : Element.ALIGN_LEFT, valign: Element.ALIGN_LEFT]
        def prmsCellHead2 = [border: Color.WHITE,
                             align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE, bordeTop: "1", bordeBot: "1"]

        def prmsCellIzquierda = [border: Color.WHITE,
                                 align : Element.ALIGN_LEFT, valign: Element.ALIGN_LEFT]
        def prmsCellDerecha = [border: Color.WHITE,
                               align : Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsCellDerecha2 = [border: Color.WHITE,
                                align : Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT, bordeTop: "1", bordeBot: "1"]
        def prmsCellCenter = [border: Color.WHITE, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellLeft = [border: Color.WHITE, valign: Element.ALIGN_MIDDLE]
        def prmsSubtotal = [border: Color.WHITE, colspan: 6,
                            align : Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsNum = [border: Color.WHITE, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        def prms = [prmsHeaderHoja: prmsHeaderHoja, prmsHeader: prmsHeader, prmsHeader2: prmsHeader2,
                    prmsCellHead: prmsCellHead, prmsCell: prmsCellCenter, prmsCellLeft: prmsCellLeft, prmsSubtotal: prmsSubtotal, prmsNum: prmsNum, prmsRight: prmsRight,
                    prmsCellDerecha: prmsCellDerecha, prmsCellIzquierda: prmsCellIzquierda]

        Paragraph headersTitulo = new Paragraph();
        addEmptyLine(headersTitulo, 1);
        headersTitulo.setAlignment(Element.ALIGN_CENTER);
        headersTitulo.add(new Paragraph((Auxiliar.get(1)?.titulo ?: ''), times18bold));
        headersTitulo.add(new Paragraph("COMPOSICIÓN", times14bold));
        headersTitulo.add(new Paragraph(obra?.departamento?.direccion?.nombre, times12bold));
        headersTitulo.add(new Paragraph("", times12bold));
        document.add(headersTitulo)

        PdfPTable header = new PdfPTable(3)
        header.setWidthPercentage(100)
        header.setWidths(arregloEnteros([25, 8, 65]))

        addCellTabla(header, new Paragraph("", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph("", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph("", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph("OBRA", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(" : ", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(obra?.nombre, times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph("CÓDIGO", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(" : ", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(obra?.codigo, times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph("DOCUMENTO DE REFERENCIA", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(" : ", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(obra?.oficioIngreso, times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph("FECHA", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(" : ", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(printFecha(obra?.fechaCreacionObra), times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph("FECHA ACT. PRECIOS", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(" : ", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(printFecha(obra?.fechaPreciosRubros), times8bold), prmsCellHead3)

        document.add(header);

        PdfPTable tablaHeader = new PdfPTable(8)
        tablaHeader.setWidthPercentage(100)
        tablaHeader.setWidths(arregloEnteros([12, 36, 5, 9, 9, 9, 10, 10]))

        PdfPTable tablaTitulo = new PdfPTable(2)
        tablaTitulo.setWidthPercentage(100)
        tablaTitulo.setWidths(arregloEnteros([90, 10]))

        PdfPTable tablaComposicion = new PdfPTable(8)
        tablaComposicion.setWidthPercentage(100)
        tablaComposicion.setWidths(arregloEnteros([12, 36, 5, 9, 9, 9, 10, 10]))

        PdfPTable tablaTotales = new PdfPTable(2)
        tablaTotales.setWidthPercentage(100)
        tablaTotales.setWidths(arregloEnteros([70, 30]))

        addCellTabla(tablaHeader, new Paragraph("Código", times8bold), prmsCellHead2)
        addCellTabla(tablaHeader, new Paragraph("Item", times8bold), prmsCellHead2)
        addCellTabla(tablaHeader, new Paragraph("U", times8bold), prmsCellHead2)
        addCellTabla(tablaHeader, new Paragraph("Cantidad", times8bold), prmsCellHead2)
        addCellTabla(tablaHeader, new Paragraph("Precio Unitario", times8bold), prmsCellDerecha2)
        addCellTabla(tablaHeader, new Paragraph("Transporte", times8bold), prmsCellDerecha2)
        addCellTabla(tablaHeader, new Paragraph("Costo", times8bold), prmsCellDerecha2)
        addCellTabla(tablaHeader, new Paragraph("Total", times8bold), prmsCellDerecha2)

        PdfPTable tablaTitulo2 = new PdfPTable(2)
        tablaTitulo2.setWidthPercentage(100)
        tablaTitulo2.setWidths(arregloEnteros([90, 10]))

        PdfPTable tablaComposicion2 = new PdfPTable(8)
        tablaComposicion2.setWidthPercentage(100)
        tablaComposicion2.setWidths(arregloEnteros([12, 36, 5, 9, 9, 9, 10, 10]))

        PdfPTable tablaTotalesMano = new PdfPTable(2)
        tablaTotalesMano.setWidthPercentage(100)
        tablaTotalesMano.setWidths(arregloEnteros([70, 30]))
        addCellTabla(tablaTitulo2, new Paragraph("Mano de obra ", times14bold), prmsCellIzquierda)
        addCellTabla(tablaTitulo2, new Paragraph(" ", times10bold), prmsCellIzquierda)

        res.each { j ->


            if (j?.grid == 2) {
                addCellTabla(tablaComposicion2, new Paragraph(j?.codigo, times8normal), prmsCellIzquierda)
                addCellTabla(tablaComposicion2, new Paragraph(j?.item, times8normal), prmsCellIzquierda)
                addCellTabla(tablaComposicion2, new Paragraph(j?.unidad, times8normal), prmsCellHead)
                addCellTabla(tablaComposicion2, new Paragraph(g.formatNumber(number: j?.cantidad, minFractionDigits:
                        3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times8normal), prmsNum)
                addCellTabla(tablaComposicion2, new Paragraph(g.formatNumber(number: j?.punitario, minFractionDigits:
                        3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times8normal), prmsNum)
                addCellTabla(tablaComposicion2, new Paragraph(g.formatNumber(number: j?.transporte, minFractionDigits:
                        3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times8normal), prmsNum)
                addCellTabla(tablaComposicion2, new Paragraph(g.formatNumber(number: j?.costo, minFractionDigits:
                        3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times8normal), prmsNum)
                addCellTabla(tablaComposicion2, new Paragraph(g.formatNumber(number: j?.total, minFractionDigits:
                        3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times8normal), prmsNum)

                totalesMano = j?.total
                valorTotalMano = (total2 += totalesMano)
            }

        }

        addCellTabla(tablaTotalesMano, new Paragraph("Total Mano de Obra:", times10bold), prmsCellDerecha)
        addCellTabla(tablaTotalesMano, new Paragraph(g.formatNumber(number: valorTotalMano, minFractionDigits:
                3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times10bold), prmsNum)
        addCellTabla(tablaTotalesMano, new Paragraph(" ", times10bold), prmsNum)
        addCellTabla(tablaTotalesMano, new Paragraph(" ", times10bold), prmsNum)
        document.add(tablaTitulo2)
        document.add(tablaHeader);
        document.add(tablaComposicion2);
        document.add(tablaTotalesMano)

        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }


    def reporteComposicionEq() {

        def obra = Obra.get(params.id)
        def totales
        def valorTotal
        def total1 = 0
        def totalesMano
        def valorTotalMano
        def total2 = 0
        def totalesEquipos
        def valorTotalEquipos
        def total3 = 0


        if (!params.tipo) {
            params.tipo = "-1"
        }
        if (!params.rend) {
            params.rend = "screen"
        }
        if (!params.sp) {
            params.sp = '-1'
        }
        if (params.tipo == "-1") {
            params.tipo = "1,2,3"
        }
        def wsp = ""
        if (params.sp.toString() != "-1") {
            wsp = "      AND v.sbpr__id = ${params.sp} \n"
        }

        def sql = "SELECT i.itemcdgo codigo, i.itemnmbr item, u.unddcdgo unidad, sum(v.voitcntd) cantidad, \n" +
                "v.voitpcun punitario, v.voittrnp transporte, v.voitpcun + v.voittrnp  costo, \n" +
                "sum((v.voitpcun + v.voittrnp) * v.voitcntd)  total, g.grpodscr grupo, g.grpo__id grid \n" +
                "FROM vlobitem v INNER JOIN item i ON v.item__id = i.item__id\n" +
                "INNER JOIN undd u ON i.undd__id = u.undd__id\n" +
                "INNER JOIN dprt d ON i.dprt__id = d.dprt__id\n" +
                "INNER JOIN sbgr s ON d.sbgr__id = s.sbgr__id\n" +
                "INNER JOIN grpo g ON s.grpo__id = g.grpo__id AND g.grpo__id IN (${params.tipo}) \n" +
                "WHERE v.obra__id = ${params.id} and v.voitcntd >0 \n" + wsp +
                "group by i.itemcdgo, i.itemnmbr, u.unddcdgo, v.voitpcun, v.voittrnp, v.voitpcun, \n" +
                "g.grpo__id, g.grpodscr " +
                "ORDER BY g.grpo__id ASC, i.itemcdgo"


        def cn = dbConnectionService.getConnection()
        def res = cn.rows(sql.toString())


        def baos = new ByteArrayOutputStream()
        def name = "composicion_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        Font times12bold = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font times10bold = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times14bold = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font times18bold = new Font(Font.TIMES_ROMAN, 18, Font.BOLD);
        Font times8bold = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        Font times8normal = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL)
        Font times10boldWhite = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8boldWhite = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        times8boldWhite.setColor(Color.BLACK)
        times10boldWhite.setColor(Color.BLACK)
        def fonts = [times12bold: times12bold, times10bold: times10bold, times8bold: times8bold,
                     times10boldWhite: times10boldWhite, times8boldWhite: times8boldWhite, times8normal: times8normal]

        Document document
        document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);
        document.open();
        document.addTitle("Composicion " + new Date().format("dd_MM_yyyy"));
        document.addSubject("Generado por el sistema Janus");
        document.addKeywords("reporte, janus, composicion");
        document.addAuthor("Janus");
        document.addCreator("Tedein SA");

        def prmsHeaderHoja = [border: Color.WHITE]
        def prmsHeader = [border: Color.WHITE, colspan: 7,
                          align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsRight = [border: Color.WHITE, colspan: 7,
                         align : Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsHeader2 = [border: Color.WHITE, colspan: 3,
                           align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead = [border: Color.WHITE,
                            align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead3 = [border: Color.WHITE,
                             align : Element.ALIGN_LEFT, valign: Element.ALIGN_LEFT]
        def prmsCellHead2 = [border: Color.WHITE,
                             align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE, bordeTop: "1", bordeBot: "1"]
        def prmsCellIzquierda = [border: Color.WHITE,
                                 align : Element.ALIGN_LEFT, valign: Element.ALIGN_LEFT]
        def prmsCellDerecha = [border: Color.WHITE,
                               align : Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsCellDerecha2 = [border: Color.WHITE,
                                align : Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT, bordeTop: "1", bordeBot: "1"]
        def prmsCellCenter = [border: Color.WHITE, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellLeft = [border: Color.WHITE, valign: Element.ALIGN_MIDDLE]
        def prmsSubtotal = [border: Color.WHITE, colspan: 6,
                            align : Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsNum = [border: Color.WHITE, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        def prms = [prmsHeaderHoja: prmsHeaderHoja, prmsHeader: prmsHeader, prmsHeader2: prmsHeader2,
                    prmsCellHead: prmsCellHead, prmsCell: prmsCellCenter, prmsCellLeft: prmsCellLeft, prmsSubtotal: prmsSubtotal, prmsNum: prmsNum, prmsRight: prmsRight,
                    prmsCellDerecha: prmsCellDerecha, prmsCellIzquierda: prmsCellIzquierda]

        Paragraph headersTitulo = new Paragraph();
        addEmptyLine(headersTitulo, 1);
        headersTitulo.setAlignment(Element.ALIGN_CENTER);
        headersTitulo.add(new Paragraph((Auxiliar.get(1)?.titulo ?: ''), times18bold));
        headersTitulo.add(new Paragraph("COMPOSICIÓN", times14bold));
        headersTitulo.add(new Paragraph(obra?.departamento?.direccion?.nombre, times12bold));
        headersTitulo.add(new Paragraph("", times12bold));
        document.add(headersTitulo)

        PdfPTable header = new PdfPTable(3)
        header.setWidthPercentage(100)
        header.setWidths(arregloEnteros([25, 8, 65]))

        addCellTabla(header, new Paragraph("", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph("", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph("", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph("OBRA", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(" : ", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(obra?.nombre, times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph("CÓDIGO", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(" : ", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(obra?.codigo, times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph("DOCUMENTO DE REFERENCIA", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(" : ", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(obra?.oficioIngreso, times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph("FECHA", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(" : ", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(printFecha(obra?.fechaCreacionObra), times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph("FECHA ACT. PRECIOS", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(" : ", times8bold), prmsCellHead3)
        addCellTabla(header, new Paragraph(printFecha(obra?.fechaPreciosRubros), times8bold), prmsCellHead3)

        document.add(header);

        PdfPTable tablaHeader = new PdfPTable(8)
        tablaHeader.setWidthPercentage(100)
        tablaHeader.setWidths(arregloEnteros([12, 36, 5, 9, 9, 9, 10, 10]))

        PdfPTable tablaTitulo = new PdfPTable(2)
        tablaTitulo.setWidthPercentage(100)
        tablaTitulo.setWidths(arregloEnteros([90, 10]))

        PdfPTable tablaComposicion = new PdfPTable(8)
        tablaComposicion.setWidthPercentage(100)
        tablaComposicion.setWidths(arregloEnteros([12, 36, 5, 9, 9, 9, 10, 10]))

        PdfPTable tablaTotales = new PdfPTable(2)
        tablaTotales.setWidthPercentage(100)
        tablaTotales.setWidths(arregloEnteros([70, 30]))

        addCellTabla(tablaHeader, new Paragraph("Código", times8bold), prmsCellHead2)
        addCellTabla(tablaHeader, new Paragraph("Item", times8bold), prmsCellHead2)
        addCellTabla(tablaHeader, new Paragraph("U", times8bold), prmsCellHead2)
        addCellTabla(tablaHeader, new Paragraph("Cantidad", times8bold), prmsCellHead2)
        addCellTabla(tablaHeader, new Paragraph("Precio Unitario", times8bold), prmsCellDerecha2)
        addCellTabla(tablaHeader, new Paragraph("Transporte", times8bold), prmsCellDerecha2)
        addCellTabla(tablaHeader, new Paragraph("Costo", times8bold), prmsCellDerecha2)
        addCellTabla(tablaHeader, new Paragraph("Total", times8bold), prmsCellDerecha2)

        PdfPTable tablaTitulo2 = new PdfPTable(2)
        tablaTitulo2.setWidthPercentage(100)
        tablaTitulo2.setWidths(arregloEnteros([90, 10]))

        PdfPTable tablaComposicion2 = new PdfPTable(8)
        tablaComposicion2.setWidthPercentage(100)
        tablaComposicion2.setWidths(arregloEnteros([12, 36, 5, 9, 9, 9, 10, 10]))

        PdfPTable tablaTotalesMano = new PdfPTable(2)
        tablaTotalesMano.setWidthPercentage(100)
        tablaTotalesMano.setWidths(arregloEnteros([70, 30]))

        PdfPTable tablaTitulo3 = new PdfPTable(2)
        tablaTitulo3.setWidthPercentage(100)
        tablaTitulo3.setWidths(arregloEnteros([90, 10]))

        PdfPTable tablaComposicion3 = new PdfPTable(8)
        tablaComposicion3.setWidthPercentage(100)
        tablaComposicion3.setWidths(arregloEnteros([12, 36, 5, 9, 9, 9, 10, 10]))

        PdfPTable tablaTotalesEquipos = new PdfPTable(2)
        tablaTotalesEquipos.setWidthPercentage(100)
        tablaTotalesEquipos.setWidths(arregloEnteros([70, 30]))

        addCellTabla(tablaTitulo3, new Paragraph("Equipos ", times14bold), prmsCellIzquierda)
        addCellTabla(tablaTitulo3, new Paragraph(" ", times10bold), prmsCellIzquierda)

        res.each { k ->

            if (k?.grid == 3) {
                addCellTabla(tablaComposicion3, new Paragraph(k?.codigo, times8normal), prmsCellIzquierda)
                addCellTabla(tablaComposicion3, new Paragraph(k?.item, times8normal), prmsCellIzquierda)
                addCellTabla(tablaComposicion3, new Paragraph(k?.unidad, times8normal), prmsCellHead)
                addCellTabla(tablaComposicion3, new Paragraph(g.formatNumber(number: k?.cantidad, minFractionDigits:
                        3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times8normal), prmsNum)
                addCellTabla(tablaComposicion3, new Paragraph(g.formatNumber(number: k?.punitario, minFractionDigits:
                        3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times8normal), prmsNum)
                addCellTabla(tablaComposicion3, new Paragraph(g.formatNumber(number: k?.transporte, minFractionDigits:
                        3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times8normal), prmsNum)
                addCellTabla(tablaComposicion3, new Paragraph(g.formatNumber(number: k?.costo, minFractionDigits:
                        3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times8normal), prmsNum)
                addCellTabla(tablaComposicion3, new Paragraph(g.formatNumber(number: k?.total, minFractionDigits:
                        3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times8normal), prmsNum)

                totalesEquipos = k?.total
                valorTotalEquipos = (total3 += totalesEquipos)
            }
        }

        addCellTabla(tablaTotalesEquipos, new Paragraph("Total Equipos:", times10bold), prmsCellDerecha)
        addCellTabla(tablaTotalesEquipos, new Paragraph(g.formatNumber(number: valorTotalEquipos, minFractionDigits:
                3, maxFractionDigits: 3, format: "##,##0", locale: "ec"), times10bold), prmsNum)

        document.add(tablaTitulo3)
        document.add(tablaHeader);
        document.add(tablaComposicion3);
        document.add(tablaTotalesEquipos)

        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def matrizExcel() {
        def cn = dbConnectionService.getConnection()
        def cn1 = dbConnectionService.getConnection()
        def cn2 = dbConnectionService.getConnection()
        def obra = Obra.get(params.id)
        def lugar = obra.lugar
        def fecha = obra.fechaPreciosRubros
        def itemsChofer = [obra.chofer]
        def itemsVolquete = [obra.volquete]
        def indi = obra.totales
        WorkbookSettings workbookSettings = new WorkbookSettings()
        workbookSettings.locale = Locale.default
        def file = File.createTempFile('matrizFP' + obra.codigo, '.xlsx')
        file.deleteOnExit()
        WritableWorkbook workbook = Workbook.createWorkbook(file, workbookSettings)

        WritableFont times10Font = new WritableFont(WritableFont.TIMES, 10, WritableFont.BOLD, false);
        WritableCellFormat times10format = new WritableCellFormat(times10Font);
        WritableFont times10Normal = new WritableFont(WritableFont.TIMES, 10, WritableFont.BOLD, false);
        WritableCellFormat times10formatNormal = new WritableCellFormat(times10Normal);

        WritableFont times08font = new WritableFont(WritableFont.TIMES, 8, WritableFont.NO_BOLD, false);
        WritableCellFormat times08format = new WritableCellFormat(times08font);

        def fila = 12

        WritableSheet sheet = workbook.createSheet("PAC", 0)

        sheet.setColumnView(0, 8)
        sheet.setColumnView(1, 12)
        sheet.setColumnView(2, 50)
        sheet.setColumnView(3, 8)
        sheet.setColumnView(4, 12)
        sheet.setColumnView(5, 15)
        sheet.setColumnView(6, 15)
        sheet.setColumnView(7, 15)
        sheet.setColumnView(8, 15)
        sheet.setColumnView(9, 15)
        sheet.setColumnView(10, 15)
        sheet.setColumnView(11, 15)
        sheet.setColumnView(12, 15)  // el resto por defecto..

        def label = new Label(2, 1, (Auxiliar.get(1)?.titulo ?: '').toUpperCase(), times10format); sheet.addCell(label);

        label = new Label(2, 2, "${obra?.departamento?.direccion?.nombre}", times10format); sheet.addCell(label);
        label = new Label(2, 3, "Matriz de la Fórmula Polinómica", times10format); sheet.addCell(label);
        label = new Label(2, 4, "", times10format); sheet.addCell(label);
        label = new Label(2, 5, "Obra: ${obra.nombre}", times10format); sheet.addCell(label);
        label = new Label(2, 6, "Código: ${obra.codigo}", times10format); sheet.addCell(label);
        label = new Label(2, 7, "Memo Cant. Obra: ${obra.memoCantidadObra}", times10format); sheet.addCell(label);
        label = new Label(2, 8, "Doc. Referencia: ${obra.oficioIngreso}", times10format); sheet.addCell(label);
        label = new Label(2, 9, "Fecha: ${printFecha(obra?.fechaCreacionObra)}", times10format); sheet.addCell(label);
        label = new Label(2, 10, "Fecha Act. Precios: ${printFecha(obra?.fechaPreciosRubros)}", times10format);
        sheet.addCell(label);

        // crea columnas

        def sql = "SELECT clmncdgo,clmndscr,clmntipo from mfcl where obra__id = ${obra.id} order by  1"
        def subSql = ""
        def sqlVl = ""
        def clmn = 0
        def col = ""
        cn.eachRow(sql.toString()) { r ->
            col = r[1]
            if (r[2] != "R") {
                def parts = r[1].split("_")
                try {
                    col = Item.get(parts[0].toLong()).nombre
                } catch (e) {
                    println "error: " + e
                    col = parts[0]
                }
                col += " " + parts[1]?.replaceAll("T", " Total")?.replaceAll("U", " Unitario")
            }
            label = new Label(clmn++, fila, "${col}", times10formatNormal); sheet.addCell(label);
        }
        fila++
        def sqlRb = "SELECT orden, codigo, rubro, unidad, cantidad from mfrb where obra__id = ${obra.id} order by orden"
        def number
        cn.eachRow(sqlRb.toString()) { r ->
            4.times {
                label = new Label(it, fila, r[it]?.toString() ?: "", times08format); sheet.addCell(label);
            }
            number = new Number(4, fila, r.cantidad?.toDouble()?.round(3) ?: 0, times08format); sheet.addCell(number);
            fila++
        }

        fila = 13
        clmn = 5

        sql = "SELECT clmncdgo, clmntipo from mfcl where obra__id = ${obra.id} order by  1"
        cn.eachRow(sqlRb.toString()) { rb ->
            cn1.eachRow(sql.toString()) { r ->
                if (r.clmntipo != "R") {
                    subSql = "select valor from mfvl where clmncdgo = ${r.clmncdgo} and codigo='${rb.codigo.trim()}' and " +
                            "obra__id = ${obra.id}"
                    cn2.eachRow(subSql.toString()) { v ->
                        number = new Number(clmn++, fila, v.valor?.toDouble()?.round(5) ?: 0.00000, times08format); sheet.addCell(number);
                    }
                }
            }
            clmn = 5
            fila++
        }

        workbook.write();
        workbook.close();
        def output = response.getOutputStream()
        def header = "attachment; filename=" + "matriz.xlsx";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        output.write(file.getBytes());
    }


    def reporteAvance() {

        params.id = 15;

        def concurso = janus.pac.Concurso.get(params.id)
        def diasPreparatorioPac = concurso.pac.tipoProcedimiento.preparatorio
        def inicioPreparatorio = concurso.fechaInicioPreparatorio
        def finPreparatorio = concurso.fechaFinPreparatorio
        def diasPrecontractualPac = concurso.pac.tipoProcedimiento.precontractual
        def inicioPrecontractual = concurso.fechaInicioPrecontractual
        def finPrecontractual = concurso.fechaFinPrecontractual
        def diasContractualPac = concurso.pac.tipoProcedimiento.contractual
        def inicioContractual = concurso.fechaInicioContractual
        def finContractual = concurso.fechaInicioContractual
        def fechaTemp = inicioPreparatorio
        def fechaTempPrecon = inicioPrecontractual
        def fechaTempContra = inicioContractual
        def diasPreparatorio = 0
        def diasPrecontractual = 0
        def diasContractual = 0

        /* Aqui esta con la nueva tabla de dias feriados */
        def res1 = diasLaborablesService.diasLaborablesEntre(fechaTemp, finPreparatorio)
        def res2 = diasLaborablesService.diasLaborablesEntre(fechaTempPrecon, finPrecontractual)
        def res3 = diasLaborablesService.diasLaborablesEntre(fechaTempContra, finContractual)
        def err
        if (res1[0]) {
            diasPreparatorio = res1[1]
        } else {
            diasPreparatorio = null
            err = "<li>" + res[1] + "</li>"
        }
        if (res2[0]) {
            diasPrecontractual = res2[1]
        } else {
            diasPrecontractual = null
            err = "<li>" + res[1] + "</li>"
        }
        if (res3[0]) {
            diasContractual = res3[1]
        } else {
            diasContractual = null
            err = "<li>" + res[1] + "</li>"
        }

        if (!diasPreparatorio || !diasPrecontractual || !diasContractual) {
            def url2 = g.createLink(controller: "diaLaborable", action: "calendario", params: [anio: res[2] ?: ""])
            def link = "<a href='${url2}' class='btn btn-primary'>Configurar días laborables</a>"
            flash.message = "<ul>" + err + "</ul>"
            redirect(action: "errores", params: [link: link])
            return;
//            redirect(action: "errores")
        }

        def baos = new ByteArrayOutputStream()
        def name = "avance_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        Font times12bold = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font times10bold = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8bold = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        Font times8normal = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL)
        Font times18bold = new Font(Font.TIMES_ROMAN, 18, Font.BOLD)
        Font times10boldWhite = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8boldWhite = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        times8boldWhite.setColor(Color.BLACK)
        times10boldWhite.setColor(Color.BLACK)
        def fonts = [times12bold: times12bold, times10bold: times10bold, times8bold: times8bold,
                     times10boldWhite: times10boldWhite, times8boldWhite: times8boldWhite, times8normal: times8normal, times18bold: times18bold]

        Document document
        document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);
        document.open();
        document.addTitle("Avance " + new Date().format("dd_MM_yyyy"));
        document.addSubject("Generado por el sistema Janus");
        document.addKeywords("reporte, janus, composicion");
        document.addAuthor("Janus");
        document.addCreator("Tedein SA");

        def prmsHeaderHoja = [border: Color.WHITE]
        def prmsHeader = [border: Color.WHITE, colspan: 7,
                          align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsRight = [border: Color.WHITE, colspan: 7,
                         align : Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsHeader2 = [border: Color.WHITE, colspan: 3,
                           align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead = [border: Color.WHITE,
                            align : Element.ALIGN_CENTER, valign: Element.ALIGN_CENTER, bordeTop: "1", bordeBot: "1"]
        def prmsCellHeadIzquierda = [border: Color.WHITE,
                                     align : Element.ALIGN_LEFT, valign: Element.ALIGN_LEFT, bordeTop: "1", bordeBot: "1"]
        def prmsCellIzquierda = [border: Color.WHITE,
                                 align : Element.ALIGN_LEFT, valign: Element.ALIGN_LEFT]
        def prmsCellDerecha = [border: Color.WHITE,
                               align : Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsCellCenter = [border: Color.WHITE, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellLeft = [border: Color.WHITE, valign: Element.ALIGN_MIDDLE]
        def prmsSubtotal = [border: Color.WHITE, colspan: 6,
                            align : Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsNum = [border: Color.WHITE, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]

        def prms = [prmsHeaderHoja: prmsHeaderHoja, prmsHeader: prmsHeader, prmsHeader2: prmsHeader2,
                    prmsCellHead: prmsCellHead, prmsCell: prmsCellCenter, prmsCellLeft: prmsCellLeft, prmsSubtotal: prmsSubtotal, prmsNum: prmsNum, prmsRight: prmsRight,
                    prmsCellDerecha: prmsCellDerecha, prmsCellIzquierda: prmsCellIzquierda]

        Paragraph headers = new Paragraph();
        addEmptyLine(headers, 1);
        headers.setAlignment(Element.ALIGN_CENTER);
        headers.add(new Paragraph((Auxiliar.get(1)?.titulo ?: ''), times18bold));
        headers.add(new Paragraph("CONTROL DE AVANCE DE CONCURSO", times12bold));
        headers.add(new Paragraph("OBRA: " + concurso?.obra?.nombre, times10bold));
        headers.add(new Paragraph("FECHA: " + printFecha(new Date()), times10bold));

        addEmptyLine(headers, 1);
        document.add(headers);

        PdfPTable tablaAvance = new PdfPTable(4)
        tablaAvance.setWidthPercentage(90)
        tablaAvance.setWidths(arregloEnteros([20, 35, 20, 25]))

        addCellTabla(tablaAvance, new Paragraph("Etapa", times10bold), prmsCellHeadIzquierda)
        addCellTabla(tablaAvance, new Paragraph("Tiempo utilizado en el proceso", times10bold), prmsCellHead)
        addCellTabla(tablaAvance, new Paragraph("Tiempo estandar", times10bold), prmsCellHead)
        addCellTabla(tablaAvance, new Paragraph("Indicador", times10bold), prmsCellHead)

        if (inicioPreparatorio && finPreparatorio) {

            addCellTabla(tablaAvance, new Paragraph("Preparatorio", times8normal), prmsCellIzquierda)
            addCellTabla(tablaAvance, new Paragraph(g.formatNumber(number: diasPreparatorio, minFractionDigits:
                    0, maxFractionDigits: 0, format: "##,##0", locale: "ec"), times8normal), prmsNum)
            addCellTabla(tablaAvance, new Paragraph(g.formatNumber(number: diasPreparatorioPac, minFractionDigits:
                    0, maxFractionDigits: 0, format: "##,##0", locale: "ec"), times8normal), prmsNum)
            addCellTabla(tablaAvance, new Paragraph(g.formatNumber(number: (diasPreparatorio / diasPreparatorioPac) * 100, minFractionDigits:
                    0, maxFractionDigits: 0, format: "##,##0", locale: "ec") + " %", times8normal), prmsNum)


        }
        if (inicioPrecontractual && finPrecontractual) {

            addCellTabla(tablaAvance, new Paragraph("Precontractual", times8normal), prmsCellIzquierda)
            addCellTabla(tablaAvance, new Paragraph(g.formatNumber(number: diasPrecontractual, minFractionDigits:
                    0, maxFractionDigits: 0, format: "##,##0", locale: "ec"), times8normal), prmsNum)
            addCellTabla(tablaAvance, new Paragraph(g.formatNumber(number: diasPrecontractualPac, minFractionDigits:
                    0, maxFractionDigits: 0, format: "##,##0", locale: "ec"), times8normal), prmsNum)
            addCellTabla(tablaAvance, new Paragraph(g.formatNumber(number: (diasPrecontractual / diasPrecontractualPac) * 100, minFractionDigits:
                    0, maxFractionDigits: 0, format: "##,##0", locale: "ec") + " %", times8normal), prmsNum)


        }
        if (inicioContractual && finContractual) {

            addCellTabla(tablaAvance, new Paragraph("Contractual", times8normal), prmsCellIzquierda)
            addCellTabla(tablaAvance, new Paragraph(g.formatNumber(number: diasContractual, minFractionDigits:
                    0, maxFractionDigits: 0, format: "##,##0", locale: "ec"), times8normal), prmsNum)
            addCellTabla(tablaAvance, new Paragraph(g.formatNumber(number: diasContractualPac, minFractionDigits:
                    0, maxFractionDigits: 0, format: "##,##0", locale: "ec"), times8normal), prmsNum)
            addCellTabla(tablaAvance, new Paragraph(g.formatNumber(number: (diasContractual / diasContractualPac) * 100, minFractionDigits:
                    0, maxFractionDigits: 2, format: "##,##0", locale: "ec") + " %", times8normal), prmsNum)
        }

        document.add(tablaAvance);
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def horasLaborables(fechaTemp, fechaFin, dias, fmt, noLaborables) {
        while (fechaTemp <= fechaFin) {
            if (!noLaborables.contains(fmt.format(fechaTemp))) {
                dias++
            }
            fechaTemp += 1
        }
        return dias
    }


    def reportedocumentosObraMemoAdmi() {

        def auxiliar = Auxiliar.get(1)
        def obra = Obra.get(params.id)
        def direccion = Direccion.get(params.para)
        def fecha = printFecha(new Date().parse("dd-MM-yyyy", params.fecha))
        def cuenta = 0
        def firmaFijaMP
        def firma
        def firmas
        def fina = params.financiero.toDouble()/100 + 1

//        println "----- $fina"

        if (params.firmasIdMP.trim().size() > 0) {
            firma = params.firmasIdMP.split(",")
            firma = firma.toList().unique()
        } else {
            firma = []
        }

        if (params.firmasFijasMP.trim().size() > 0) {

            firmaFijaMP = params.firmasFijasMP.split(",")
//            firmaFijaMP = firmaFijaMP.toList().unique()
        } else {

            firmaFijaMP = []
        }

        cuenta = firma.size() + firmaFijaMP.size()

        def prmsHeaderHoja = [border: Color.WHITE]
        def prmsHeaderHoja3 = [border: Color.WHITE, colspan: 3]
        def prmsHeaderHoja4 = [border: Color.WHITE, colspan: 4]
        def prmsHeaderHojaRight = [border: Color.WHITE, align: Element.ALIGN_RIGHT]
        def prmsHeaderHojaLeft = [border: Color.WHITE, align: Element.ALIGN_LEFT]
        def prmsHeaderHojaLeft2 = [border: Color.WHITE, align: Element.ALIGN_LEFT, colspan: 2]

        def prmsHeaderHoja2 = [border: Color.WHITE, colspan: 9]


        def prmsHeader = [border: Color.WHITE, colspan: 7, bg: new Color(73, 175, 205),
                          align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]

        def prmsCellHead2 = [border: Color.WHITE,
                             align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE, bordeTop: "1", bordeBot: "1"]
        def prmsCellHead3 = [border: Color.WHITE,
                             align : Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT, bordeTop: "1", bordeBot: "1"]
        def prmsCellHead4 = [border: Color.WHITE,
                             align : Element.ALIGN_LEFT, valign: Element.ALIGN_LEFT, colspan: 6]
        def prmsCellHead5 = [border: Color.WHITE,
                             align : Element.ALIGN_LEFT, valign: Element.ALIGN_LEFT, colspan: 7]
        def prmsCellHead6 = [border: Color.WHITE,
                             align : Element.ALIGN_LEFT, valign: Element.ALIGN_LEFT, colspan: 4]

        def prmsHeader2 = [border: Color.WHITE, colspan: 3, bg: new Color(73, 175, 205),
                           align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellHead = [border: Color.WHITE, bg: new Color(73, 175, 205),
                            align : Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellCenter = [border: Color.WHITE, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCellRight = [border: Color.WHITE, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT]
        def prmsCellRight2 = [border: Color.WHITE, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT, bordeTop: "1", bordeBot: "1"]
        def prmsCellRight3 = [border: Color.WHITE, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT, bordeBot: "1"]
        def prmsCellRight4 = [border: Color.WHITE, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_RIGHT, bordeTop: "1"]
        def prmsCellLeft3 = [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_LEFT, bordeBot: "1"]
        def prmsCellLeft = [border: Color.WHITE, valign: Element.ALIGN_MIDDLE]
        def prmsSubtotal = [border: Color.WHITE, colspan: 6,
                            align : Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsNum = [border: Color.WHITE, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        def prms = [prmsHeaderHoja: prmsHeaderHoja, prmsHeader: prmsHeader, prmsHeader2: prmsHeader2,
                    prmsCellHead: prmsCellHead, prmsCell: prmsCellCenter, prmsCellLeft: prmsCellLeft, prmsSubtotal: prmsSubtotal, prmsNum: prmsNum, prmsHeaderHoja2: prmsHeaderHoja2, prmsCellRight: prmsCellRight]

        def baos = new ByteArrayOutputStream()
        def name = "adminDirecta_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
        Font times12bold = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
        Font times14bold = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font times18bold = new Font(Font.TIMES_ROMAN, 18, Font.BOLD);
        Font times10bold = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8bold = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        Font times8normal = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL)
        Font times10normal = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL)
        Font times10boldWhite = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
        Font times8boldWhite = new Font(Font.TIMES_ROMAN, 8, Font.BOLD)
        times8boldWhite.setColor(Color.WHITE)
        times10boldWhite.setColor(Color.WHITE)
        def fonts = [times12bold: times12bold, times10bold: times10bold, times8bold: times8bold,
                     times10boldWhite: times10boldWhite, times8boldWhite: times8boldWhite, times8normal: times8normal, times10normal: times10normal]

        Document document
        document = new Document(PageSize.A4);
        document.setMargins(56.2, 56.2, 50, 28.1);
        // margins: left, right, top, bottom
        // 1 in = 72, 1cm=28.1, 3cm = 86.4
        def pdfw = PdfWriter.getInstance(document, baos);

        HeaderFooter footer1 = new HeaderFooter(new Phrase(" ", times8normal), true);
        // true aqui pone numero de pagina
        footer1.setBorder(Rectangle.NO_BORDER);
//        footer1.setBorder(Rectangle.TOP);
        footer1.setAlignment(Element.ALIGN_CENTER);
        document.setFooter(footer1);
        document.open();
        document.addTitle("AdminDirecta " + new Date().format("dd_MM_yyyy"));
        document.addSubject("Generado por el sistema Obras");
        document.addKeywords("documentosObra, janus, presupuesto");
        document.addAuthor("Janus");
        document.addCreator("Tedein SA");

        Paragraph headers = new Paragraph();
        addEmptyLine(headers, 1);
        headers.setAlignment(Element.ALIGN_CENTER);
        headers.add(new Paragraph(auxiliar.titulo, times12bold));
        headers.add(new Paragraph(obra?.departamento?.direccion?.nombre, times12bold));
        headers.add(new Paragraph("MEMORANDO", times12bold))
        headers.add(new Paragraph(" ", times12bold));

        PdfPTable tablaCabeceraMemo = new PdfPTable(3);
        tablaCabeceraMemo.setWidthPercentage(100);
        tablaCabeceraMemo.setWidths(arregloEnteros([7, 2, 60]))

        addCellTabla(tablaCabeceraMemo, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCabeceraMemo, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCabeceraMemo, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCabeceraMemo, new Paragraph("PARA", times10bold), prmsHeaderHoja)
        addCellTabla(tablaCabeceraMemo, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCabeceraMemo, new Paragraph(direccion.nombre, times10bold), prmsHeaderHoja)
        addCellTabla(tablaCabeceraMemo, new Paragraph("DE", times10bold), prmsHeaderHoja)
        addCellTabla(tablaCabeceraMemo, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCabeceraMemo, new Paragraph(params.de, times10bold), prmsHeaderHoja)
//        addCellTabla(tablaCabeceraMemo, new Paragraph(obra?.departamento?.direccion?.nombre + ' - ' + obra?.departamento?.descripcion, times10bold), prmsHeaderHoja)
        addCellTabla(tablaCabeceraMemo, new Paragraph("FECHA", times10bold), prmsHeaderHoja)
        addCellTabla(tablaCabeceraMemo, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCabeceraMemo, new Paragraph(printFecha(obra?.fechaOficioSalida), times10bold), prmsHeaderHoja)
        addCellTabla(tablaCabeceraMemo, new Paragraph("ASUNTO", times10bold), prmsHeaderHoja)
        addCellTabla(tablaCabeceraMemo, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaCabeceraMemo, new Paragraph(params.asunto, times10bold), prmsHeaderHoja)

        PdfPTable tablaParametros = new PdfPTable(3);
        tablaParametros.setWidthPercentage(100);
        tablaParametros.setWidths(arregloEnteros([10, 2, 60]))

        addCellTabla(tablaParametros, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaParametros, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaParametros, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaParametros, new Paragraph("Nombre", times8bold), prmsHeaderHoja)
        addCellTabla(tablaParametros, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaParametros, new Paragraph(obra?.nombre, times8bold), prmsHeaderHoja)
        addCellTabla(tablaParametros, new Paragraph("Descripción", times8bold), prmsHeaderHoja)
        addCellTabla(tablaParametros, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaParametros, new Paragraph(obra?.descripcion, times8bold), prmsHeaderHoja)
        addCellTabla(tablaParametros, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaParametros, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaParametros, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaParametros, new Paragraph("UBICACIÓN", times10bold), prmsHeaderHoja2)
        addCellTabla(tablaParametros, new Paragraph("Cantón", times8bold), prmsHeaderHoja)
        addCellTabla(tablaParametros, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaParametros, new Paragraph(obra?.parroquia?.canton?.nombre, times8bold), prmsHeaderHoja)
        addCellTabla(tablaParametros, new Paragraph("Parroquia", times8bold), prmsHeaderHoja)
        addCellTabla(tablaParametros, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaParametros, new Paragraph(obra?.parroquia?.nombre, times8bold), prmsHeaderHoja)
        addCellTabla(tablaParametros, new Paragraph("Comunidad", times8bold), prmsHeaderHoja)
        addCellTabla(tablaParametros, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaParametros, new Paragraph(obra?.comunidad?.nombre, times8bold), prmsHeaderHoja)
        addCellTabla(tablaParametros, new Paragraph("Coordenadas WGS84", times8bold), prmsHeaderHoja)
        addCellTabla(tablaParametros, new Paragraph(" : ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaParametros, new Paragraph(obra?.coordenadas, times8bold), prmsHeaderHoja)

        Paragraph tablaTextoMemoPresu = new Paragraph();
        addEmptyLine(tablaTextoMemoPresu, 1);
        addEmptyLine(tablaTextoMemoPresu, 1);
        tablaTextoMemoPresu.setAlignment(Element.ALIGN_LEFT);
        tablaTextoMemoPresu.add(new Paragraph(auxiliar?.notaMemoAd, times10normal))
        addEmptyLine(tablaTextoMemoPresu, 1);

        PdfPTable tablaValoresMemoPresu = new PdfPTable(4);
        tablaValoresMemoPresu.setWidthPercentage(100);
        tablaValoresMemoPresu.setWidths(arregloEnteros([35, 25, 20, 20]))

        addCellTabla(tablaValoresMemoPresu, new Paragraph(" ", times8bold), prmsHeaderHoja4)

        addCellTabla(tablaValoresMemoPresu, new Paragraph("CANTIDADES DE OBRA", times10bold), [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_LEFT, colspan: 4])
        addCellTabla(tablaValoresMemoPresu, new Paragraph(" ", times8bold), prmsHeaderHojaRight)
        addCellTabla(tablaValoresMemoPresu, new Paragraph("", times10normal), prmsHeaderHojaRight)
        addCellTabla(tablaValoresMemoPresu, new Paragraph(" ", times8bold), prmsHeaderHoja)

        addCellTabla(tablaValoresMemoPresu, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu, new Paragraph(" ", times8bold), prmsHeaderHoja)

        //tabla presupuesto

        def total1 = 0;
        def total2 = 0;

        def totales

        def totalPresupuesto = 0;
        def totalPrueba = 0

        PdfPTable tablaVolObraMemoPresu = new PdfPTable(6);
        tablaVolObraMemoPresu.setWidthPercentage(100);
        tablaVolObraMemoPresu.setWidths(arregloEnteros([14, 43, 8, 10, 12, 15]))
//        tablaVolObraMemoPresu.setWidths(arregloEnteros([14, 43, 8, 10]))

        def valores = preciosService.rbro_pcun_v2(obra.id)
        def subPres = VolumenesObra.findAllByObra(obra, [sort: "orden"]).subPresupuesto.unique()

        subPres.each { s ->

            addCellTabla(tablaVolObraMemoPresu, new Paragraph(s.descripcion, times10bold), [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_LEFT, colspan: 6])
            addCellTabla(tablaVolObraMemoPresu, new Paragraph("Rubro N°", times8bold), prmsCellHead2)
            addCellTabla(tablaVolObraMemoPresu, new Paragraph("Descripción", times8bold), prmsCellHead2)
            addCellTabla(tablaVolObraMemoPresu, new Paragraph("Unidad", times8bold), prmsCellHead2)
            addCellTabla(tablaVolObraMemoPresu, new Paragraph("Cantidad", times8bold), prmsCellHead3)
            addCellTabla(tablaVolObraMemoPresu, new Paragraph("P. Unitario", times8bold), prmsCellHead3)
            addCellTabla(tablaVolObraMemoPresu, new Paragraph("Total", times8bold), prmsCellHead3)

            valores.each {

                if (it.sbprdscr == s.descripcion) {
                    addCellTabla(tablaVolObraMemoPresu, new Paragraph(it.rbrocdgo, times8normal), prmsCellLeft)
                    addCellTabla(tablaVolObraMemoPresu, new Paragraph(it.rbronmbr, times8normal), prmsCellLeft)
                    addCellTabla(tablaVolObraMemoPresu, new Paragraph(it.unddcdgo, times8normal), prmsCellCenter)

                    addCellTabla(tablaVolObraMemoPresu, new Paragraph(g.formatNumber(number: it.vlobcntd, minFractionDigits:
                            2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight)

                    addCellTabla(tablaVolObraMemoPresu, new Paragraph(g.formatNumber(number: (it.pcun), minFractionDigits:
                            2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight)

                    addCellTabla(tablaVolObraMemoPresu, new Paragraph(g.formatNumber(number:(it.totl), minFractionDigits:
                            2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight)


                    totales = it.totl
                    totalPrueba = total2 += totales
                    totalPresupuesto = (total1 += totales);

                } else {

                }
            }
        }


        addCellTabla(tablaVolObraMemoPresu, new Paragraph(" ", times8bold), prmsCellHead6)
        addCellTabla(tablaVolObraMemoPresu, new Paragraph(" ", times8bold), prmsCellHead6)
        addCellTabla(tablaVolObraMemoPresu, new Paragraph(" ", times8bold), prmsCellHead6)

        //Presupuesto por Adm Directa

        def totales2 = 0
        def totalPrueba2 =0
        def totalP2 = 0
        def totalTrans = 0
        def trans= 0
        def tra = 0

//        def resMat = Composicion.findAll("from Composicion where obra=${params.id} and grupo in (${1})")
        def resMat = Composicion.findAllByObraAndGrupo(obra, Grupo.get(1))
        resMat.sort { it.item.codigo }

        def resMano = Composicion.findAllByObraAndGrupo(obra, Grupo.get(2))
        resMano.sort { it.item.codigo }

        def resEq = Composicion.findAllByObraAndGrupo(obra, Grupo.get(3))
        resEq.sort { it.item.codigo }


        PdfPTable tablaAdmDirecta = new PdfPTable(4);
        tablaAdmDirecta.setWidthPercentage(100);
        tablaAdmDirecta.setWidths(arregloEnteros([35, 25, 20, 20]))

        addCellTabla(tablaAdmDirecta, new Paragraph(" ", times8bold), prmsHeaderHoja4)
        addCellTabla(tablaAdmDirecta, new Paragraph(" ", times8bold), prmsHeaderHoja4)
        addCellTabla(tablaAdmDirecta, new Paragraph(" ", times8bold), prmsHeaderHoja4)


        if(obra.tipo == 'D' & session.perfil.codigo == 'COGS') {
            addCellTabla(tablaAdmDirecta, new Paragraph("PRESUPUESTO REFERENCIAL POR COGESTIÓN", times10bold), [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_LEFT, colspan: 4])
        } else {
            addCellTabla(tablaAdmDirecta, new Paragraph("PRESUPUESTO REFERENCIAL POR ADMINISTRACIÓN DIRECTA", times10bold), [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_LEFT, colspan: 4])
        }

        addCellTabla(tablaAdmDirecta, new Paragraph(" ", times8bold), prmsHeaderHojaRight)
        addCellTabla(tablaAdmDirecta, new Paragraph("", times10normal), prmsHeaderHojaRight)
        addCellTabla(tablaAdmDirecta, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaAdmDirecta, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaAdmDirecta, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaAdmDirecta, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaAdmDirecta, new Paragraph(" ", times8bold), prmsHeaderHoja)

        PdfPTable tablaComMateriales = new PdfPTable(6);
        tablaComMateriales.setWidthPercentage(100);
        tablaComMateriales.setWidths(arregloEnteros([14, 43, 8, 10, 12, 15]))

        addCellTabla(tablaComMateriales, new Paragraph("MATERIALES INCLUYE TRANSPORTE", times10bold), prmsCellHead4)

        addCellTabla(tablaComMateriales, new Paragraph("Código", times8bold), prmsCellHead2)
        addCellTabla(tablaComMateriales, new Paragraph("Item", times8bold), prmsCellHead2)
        addCellTabla(tablaComMateriales, new Paragraph("Unidad", times8bold), prmsCellHead2)
        addCellTabla(tablaComMateriales, new Paragraph("Cantidad", times8bold), prmsCellHead3)
        addCellTabla(tablaComMateriales, new Paragraph("P. Unitario", times8bold), prmsCellHead3)
        addCellTabla(tablaComMateriales, new Paragraph("Total", times8bold), prmsCellHead3)

        resMat.each {
            addCellTabla(tablaComMateriales, new Paragraph(it?.item?.codigo, times8normal), prmsCellLeft)
            addCellTabla(tablaComMateriales, new Paragraph(it?.item?.nombre, times8normal), prmsCellLeft)
            addCellTabla(tablaComMateriales, new Paragraph(it?.item?.unidad?.codigo, times8normal), prmsCellCenter)
            addCellTabla(tablaComMateriales, new Paragraph(g.formatNumber(number: it?.cantidad, minFractionDigits:
                    2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight)
            addCellTabla(tablaComMateriales, new Paragraph(g.formatNumber(number: (it?.precio + it?.transporte)*fina, minFractionDigits:
                    6, maxFractionDigits: 6, format: "##,##0", locale: "ec"), times8normal), prmsCellRight)
            addCellTabla(tablaComMateriales, new Paragraph(g.formatNumber(number:((it?.precio + it?.transporte) * it?.cantidad)*fina, minFractionDigits:
                    2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight)
            totales2 = (it?.precio * it?.cantidad) * fina
            totalPrueba2 = totalP2 += totales2
            trans = (it?.cantidad * it?.transporte)  * fina
            totalTrans = tra += trans
        }


        addCellTabla(tablaComMateriales, new Paragraph("", times8bold), prmsCellRight2)
        addCellTabla(tablaComMateriales, new Paragraph("", times8bold), prmsCellRight2)
        addCellTabla(tablaComMateriales, new Paragraph("", times8bold), prmsCellRight2)
        addCellTabla(tablaComMateriales, new Paragraph("", times8bold), prmsCellRight2)
        addCellTabla(tablaComMateriales, new Paragraph("Total:", times8bold), prmsCellRight2)
        addCellTabla(tablaComMateriales, new Paragraph(g.formatNumber(number: (totalPrueba2+totalTrans), format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellRight2)

        addCellTabla(tablaComMateriales, new Paragraph("", times8bold), prmsCellHead4)
        addCellTabla(tablaComMateriales, new Paragraph("", times8bold), prmsCellHead4)
        addCellTabla(tablaComMateriales, new Paragraph("", times8bold), prmsCellHead4)
        addCellTabla(tablaComMateriales, new Paragraph("", times8bold), prmsCellHead4)
        addCellTabla(tablaComMateriales, new Paragraph("", times8bold), prmsCellHead4)
        addCellTabla(tablaComMateriales, new Paragraph("", times8bold), prmsCellHead4)

        def totales3 = 0
        def totalPrueba3 =0
        def totalP3 = 0

        PdfPTable tablaComMano = new PdfPTable(6);
        tablaComMano.setWidthPercentage(100);
        tablaComMano.setWidths(arregloEnteros([14, 43, 8, 10, 12, 15]))

        addCellTabla(tablaComMano, new Paragraph("MANO DE OBRA", times10bold), prmsCellHead4)

        addCellTabla(tablaComMano, new Paragraph("Código", times8bold), prmsCellHead2)
        addCellTabla(tablaComMano, new Paragraph("Mano de Obra", times8bold), prmsCellHead2)
        addCellTabla(tablaComMano, new Paragraph("Unidad", times8bold), prmsCellHead2)
        addCellTabla(tablaComMano, new Paragraph("Horas Hombre", times8bold), prmsCellHead3)
        addCellTabla(tablaComMano, new Paragraph("Sal. / Hora", times8bold), prmsCellHead3)
        addCellTabla(tablaComMano, new Paragraph("Total", times8bold), prmsCellHead3)

        resMano.each {

            addCellTabla(tablaComMano, new Paragraph(it?.item?.codigo, times8normal), prmsCellLeft)
            addCellTabla(tablaComMano, new Paragraph(it?.item?.nombre, times8normal), prmsCellLeft)
            addCellTabla(tablaComMano, new Paragraph(it?.item?.unidad?.codigo, times8normal), prmsCellCenter)
            addCellTabla(tablaComMano, new Paragraph(g.formatNumber(number: it?.cantidad, minFractionDigits:
                    2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight)

            addCellTabla(tablaComMano, new Paragraph(g.formatNumber(number: it?.precio, minFractionDigits:
                    2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight)

            addCellTabla(tablaComMano, new Paragraph(g.formatNumber(number: (it?.precio * it?.cantidad), minFractionDigits:
                    2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight)

            totales3 = (it?.precio * it?.cantidad)
            totalPrueba3 = totalP3 += totales3
        }

        addCellTabla(tablaComMano, new Paragraph("", times8bold), prmsCellRight2)
        addCellTabla(tablaComMano, new Paragraph("", times8bold), prmsCellRight2)
        addCellTabla(tablaComMano, new Paragraph("", times8bold), prmsCellRight2)
        addCellTabla(tablaComMano, new Paragraph("", times8bold), prmsCellRight2)
        addCellTabla(tablaComMano, new Paragraph("Total:", times8bold), prmsCellRight2)
        addCellTabla(tablaComMano, new Paragraph(g.formatNumber(number: totalPrueba3, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellRight2)

        addCellTabla(tablaComMano, new Paragraph("", times8bold), prmsCellHead4)
        addCellTabla(tablaComMano, new Paragraph("", times8bold), prmsCellHead4)
        addCellTabla(tablaComMano, new Paragraph("", times8bold), prmsCellHead4)
        addCellTabla(tablaComMano, new Paragraph("", times8bold), prmsCellHead4)
        addCellTabla(tablaComMano, new Paragraph("", times8bold), prmsCellHead4)
        addCellTabla(tablaComMano, new Paragraph("", times8bold), prmsCellHead4)

        def totales4 = 0
        def totalPrueba4 =0
        def totalP4 = 0

        PdfPTable tablaComEq = new PdfPTable(6);
        tablaComEq.setWidthPercentage(100);
        tablaComEq.setWidths(arregloEnteros([14, 43, 8, 10, 12, 15]))

        addCellTabla(tablaComEq, new Paragraph("EQUIPOS", times10bold), prmsCellHead4)

        addCellTabla(tablaComEq, new Paragraph("Código", times8bold), prmsCellHead2)
        addCellTabla(tablaComEq, new Paragraph("Equipo", times8bold), prmsCellHead2)
        addCellTabla(tablaComEq, new Paragraph("Unidad", times8bold), prmsCellHead2)
        addCellTabla(tablaComEq, new Paragraph("Cantidad", times8bold), prmsCellHead3)
        addCellTabla(tablaComEq, new Paragraph("Tarifa", times8bold), prmsCellHead3)
        addCellTabla(tablaComEq, new Paragraph("Total", times8bold), prmsCellHead3)

        resEq.each {
            addCellTabla(tablaComEq, new Paragraph(it?.item?.codigo, times8normal), prmsCellLeft)
            addCellTabla(tablaComEq, new Paragraph(it?.item?.nombre, times8normal), prmsCellLeft)
            addCellTabla(tablaComEq, new Paragraph(it?.item?.unidad?.codigo, times8normal), prmsCellCenter)
            addCellTabla(tablaComEq, new Paragraph(g.formatNumber(number: it?.cantidad, minFractionDigits:
                    2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight)

            addCellTabla(tablaComEq, new Paragraph(g.formatNumber(number: it?.precio, minFractionDigits:
                    2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight)

            addCellTabla(tablaComEq, new Paragraph(g.formatNumber(number: (it?.precio * it?.cantidad), minFractionDigits:
                    2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight)

            totales4 = (it?.precio * it?.cantidad)
            totalPrueba4 = totalP4 += totales4
        }


        addCellTabla(tablaComEq, new Paragraph("", times8bold), prmsCellRight4)
        addCellTabla(tablaComEq, new Paragraph("", times8bold), prmsCellRight4)
        addCellTabla(tablaComEq, new Paragraph("", times8bold), prmsCellRight4)
        addCellTabla(tablaComEq, new Paragraph("", times8bold), prmsCellRight4)
        addCellTabla(tablaComEq, new Paragraph("Total:", times8bold), prmsCellRight4)
        addCellTabla(tablaComEq, new Paragraph(g.formatNumber(number: totalPrueba4, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellRight4)


        def totalParte2 = totalPrueba2+totalTrans+totalPrueba3+totalPrueba4

        PdfPTable tablaTotalCom = new PdfPTable(6);
        tablaTotalCom.setWidthPercentage(100);
        tablaTotalCom.setWidths(arregloEnteros([85, 0, 0, 0, 0, 15]))

        addCellTabla(tablaTotalCom, new Paragraph(" ", times8bold), prmsCellHead4)
        addCellTabla(tablaTotalCom, new Paragraph("Subtotal: ", times8bold), prmsCellRight4)
        addCellTabla(tablaTotalCom, new Paragraph(" ", times8bold), prmsCellHead)
        addCellTabla(tablaTotalCom, new Paragraph(" ", times8bold), prmsCellHead)
        addCellTabla(tablaTotalCom, new Paragraph(" ", times8bold), prmsCellHead)
        addCellTabla(tablaTotalCom, new Paragraph(" ", times8bold), prmsCellHead)
        addCellTabla(tablaTotalCom, new Paragraph(g.formatNumber(number: (totalPrueba2+totalTrans+totalPrueba3+totalPrueba4), format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellRight4)
        addCellTabla(tablaTotalCom, new Paragraph(" ", times8bold), prmsCellHead4)
        addCellTabla(tablaTotalCom, new Paragraph(params?.costoPorcentaje + " % Costos Indirectos", times8bold), prmsCellRight4)
        addCellTabla(tablaTotalCom, new Paragraph(" ", times8bold), prmsCellHead)
        addCellTabla(tablaTotalCom, new Paragraph(" ", times8bold), prmsCellHead)
        addCellTabla(tablaTotalCom, new Paragraph(" ", times8bold), prmsCellHead)
        addCellTabla(tablaTotalCom, new Paragraph(" ", times8bold), prmsCellHead)
        addCellTabla(tablaTotalCom, new Paragraph(g.formatNumber(number:  params?.costo ?: 0, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellRight4)
        addCellTabla(tablaTotalCom, new Paragraph(" ", times8bold), prmsCellHead4)
        addCellTabla(tablaTotalCom, new Paragraph("TOTAL DEL PRESUPUESTO: ", times8bold), prmsCellRight4)
        addCellTabla(tablaTotalCom, new Paragraph(" ", times8bold), prmsCellHead)
        addCellTabla(tablaTotalCom, new Paragraph(" ", times8bold), prmsCellHead)
        addCellTabla(tablaTotalCom, new Paragraph(" ", times8bold), prmsCellHead)
        addCellTabla(tablaTotalCom, new Paragraph(" ", times8bold), prmsCellHead)

        if(params?.costo){
            addCellTabla(tablaTotalCom, new Paragraph(g.formatNumber(number: ((params?.costo.toDouble() ?: 0) + (totalParte2 ?: 0)), format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellRight4)
        }else {

            addCellTabla(tablaTotalCom, new Paragraph(g.formatNumber(number: ((totalParte2 ?: 0)), format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellRight4)
        }

        addCellTabla(tablaTotalCom, new Paragraph(" ", times8bold), prmsCellHead4)
        addCellTabla(tablaTotalCom, new Paragraph(" ", times8bold), prmsCellHead4)

        //Presupuesto por Contrato


        if (!params.sp) {
            params.sp = '-1'
        }

        def wsp = ""
        if (params.sp.toString() != "-1") {
            wsp = "      AND v.sbpr__id = ${params.sp} \n"
        }

        def sql1 = "SELECT i.itemcdgo codigo, i.itemnmbr item, u.unddcdgo unidad, sum(v.voitcntd) cantidad, \n" +
                "v.voitpcun punitario, v.voittrnp transporte, v.voitpcun + v.voittrnp  costo, \n" +
                "sum((v.voitpcun + v.voittrnp) * v.voitcntd)  total, g.grpodscr grupo, g.grpo__id grid \n" +
                "FROM vlobitem v INNER JOIN item i ON v.item__id = i.item__id\n" +
                "INNER JOIN undd u ON i.undd__id = u.undd__id\n" +
                "INNER JOIN dprt d ON i.dprt__id = d.dprt__id\n" +
                "INNER JOIN sbgr s ON d.sbgr__id = s.sbgr__id\n" +
                "INNER JOIN grpo g ON s.grpo__id = g.grpo__id AND g.grpo__id IN (${1}) \n" +
                "WHERE v.obra__id = ${params.id} and v.voitcntd >0 \n" + wsp +
                "group by i.itemcdgo, i.itemnmbr, u.unddcdgo, v.voitpcun, v.voittrnp, v.voitpcun, \n" +
                "g.grpo__id, g.grpodscr " +
                "ORDER BY g.grpo__id ASC, i.itemcdgo"

        def cn1 = dbConnectionService.getConnection()

        def res1 = cn1.rows(sql1.toString())

        def sql2 = "SELECT i.itemcdgo codigo, i.itemnmbr item, u.unddcdgo unidad, sum(v.voitcntd) cantidad, \n" +
                "v.voitpcun punitario, v.voittrnp transporte, v.voitpcun + v.voittrnp  costo, \n" +
                "sum((v.voitpcun + v.voittrnp) * v.voitcntd)  total, g.grpodscr grupo, g.grpo__id grid \n" +
                "FROM vlobitem v INNER JOIN item i ON v.item__id = i.item__id\n" +
                "INNER JOIN undd u ON i.undd__id = u.undd__id\n" +
                "INNER JOIN dprt d ON i.dprt__id = d.dprt__id\n" +
                "INNER JOIN sbgr s ON d.sbgr__id = s.sbgr__id\n" +
                "INNER JOIN grpo g ON s.grpo__id = g.grpo__id AND g.grpo__id IN (${2}) \n" +
                "WHERE v.obra__id = ${params.id} and v.voitcntd >0 \n" + wsp +
                "group by i.itemcdgo, i.itemnmbr, u.unddcdgo, v.voitpcun, v.voittrnp, v.voitpcun, \n" +
                "g.grpo__id, g.grpodscr " +
                "ORDER BY g.grpo__id ASC, i.itemcdgo"

        def cn2 = dbConnectionService.getConnection()

        def res2 = cn2.rows(sql2.toString())

        def sql3 = "SELECT i.itemcdgo codigo, i.itemnmbr item, u.unddcdgo unidad, sum(v.voitcntd) cantidad, \n" +
                "v.voitpcun punitario, v.voittrnp transporte, v.voitpcun + v.voittrnp  costo, \n" +
                "sum((v.voitpcun + v.voittrnp) * v.voitcntd)  total, g.grpodscr grupo, g.grpo__id grid \n" +
                "FROM vlobitem v INNER JOIN item i ON v.item__id = i.item__id\n" +
                "INNER JOIN undd u ON i.undd__id = u.undd__id\n" +
                "INNER JOIN dprt d ON i.dprt__id = d.dprt__id\n" +
                "INNER JOIN sbgr s ON d.sbgr__id = s.sbgr__id\n" +
                "INNER JOIN grpo g ON s.grpo__id = g.grpo__id AND g.grpo__id IN (${3}) \n" +
                "WHERE v.obra__id = ${params.id} and v.voitcntd >0 \n" + wsp +
                "group by i.itemcdgo, i.itemnmbr, u.unddcdgo, v.voitpcun, v.voittrnp, v.voitpcun, \n" +
                "g.grpo__id, g.grpodscr " +
                "ORDER BY g.grpo__id ASC, i.itemcdgo"

        def cn3 = dbConnectionService.getConnection()


        def res3 = cn3.rows(sql3.toString())

        PdfPTable tablaContrato = new PdfPTable(4);
        tablaContrato.setWidthPercentage(100);
        tablaContrato.setWidths(arregloEnteros([35, 25, 20, 20]))

        addCellTabla(tablaContrato, new Paragraph(" ", times8bold), prmsHeaderHoja4)
        addCellTabla(tablaContrato, new Paragraph(" ", times8bold), prmsHeaderHoja4)
        addCellTabla(tablaContrato, new Paragraph("PRESUPUESTO REFERENCIAL POR CONTRATO", times10bold), [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_LEFT, colspan: 4])
        addCellTabla(tablaContrato, new Paragraph(" ", times8bold), prmsHeaderHojaRight)
        addCellTabla(tablaContrato, new Paragraph("", times10normal), prmsHeaderHojaRight)
        addCellTabla(tablaContrato, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaContrato, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaContrato, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaContrato, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaContrato, new Paragraph(" ", times8bold), prmsHeaderHoja)

        def totales5 = 0
        def totalPrueba5 =0
        def totalP5 = 0
        def totalTrans5 = 0
        def trans5= 0
        def tra5 = 0

        PdfPTable tablaContMateriales = new PdfPTable(6);
        tablaContMateriales.setWidthPercentage(100);
        tablaContMateriales.setWidths(arregloEnteros([14, 43, 8, 10, 12, 15]))

        addCellTabla(tablaContMateriales, new Paragraph("MATERIALES INCLUYE TRANSPORTE", times10bold), prmsCellHead4)

        addCellTabla(tablaContMateriales, new Paragraph("Código", times8bold), prmsCellHead2)
        addCellTabla(tablaContMateriales, new Paragraph("Item", times8bold), prmsCellHead2)
        addCellTabla(tablaContMateriales, new Paragraph("Unidad", times8bold), prmsCellHead2)
        addCellTabla(tablaContMateriales, new Paragraph("Cantidad", times8bold), prmsCellHead3)
        addCellTabla(tablaContMateriales, new Paragraph("P. Unitario", times8bold), prmsCellHead3)

        addCellTabla(tablaContMateriales, new Paragraph("Total", times8bold), prmsCellHead3)

        res1.each {
            addCellTabla(tablaContMateriales, new Paragraph(it?.codigo, times8normal), prmsCellLeft)
            addCellTabla(tablaContMateriales, new Paragraph(it?.item, times8normal), prmsCellLeft)
            addCellTabla(tablaContMateriales, new Paragraph(it?.unidad, times8normal), prmsCellCenter)
            addCellTabla(tablaContMateriales, new Paragraph(g.formatNumber(number: it?.cantidad, minFractionDigits:
                    2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight)

            addCellTabla(tablaContMateriales, new Paragraph(g.formatNumber(number: it?.punitario + it?.transporte, minFractionDigits:
                    2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight)

            addCellTabla(tablaContMateriales, new Paragraph(g.formatNumber(number: (it?.cantidad* (it?.punitario + it?.transporte)), minFractionDigits:
                    2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight)

            totales5 = (it?.punitario * it?.cantidad)
            totalPrueba5 = totalP5 += totales5
            trans5 = (it?.cantidad * it?.transporte)
            totalTrans5 = tra5 += trans5
        }


        addCellTabla(tablaContMateriales, new Paragraph("", times8bold), prmsCellRight2)
        addCellTabla(tablaContMateriales, new Paragraph("", times8bold), prmsCellRight2)
        addCellTabla(tablaContMateriales, new Paragraph("", times8bold), prmsCellRight2)
        addCellTabla(tablaContMateriales, new Paragraph("", times8bold), prmsCellRight2)
        addCellTabla(tablaContMateriales, new Paragraph("Total:", times8bold), prmsCellRight2)
        addCellTabla(tablaContMateriales, new Paragraph(g.formatNumber(number: totalPrueba5+totalTrans5, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellRight2)
        addCellTabla(tablaContMateriales, new Paragraph("", times8bold), prmsCellHead4)
        addCellTabla(tablaContMateriales, new Paragraph("", times8bold), prmsCellHead4)
        addCellTabla(tablaContMateriales, new Paragraph("", times8bold), prmsCellHead4)
        addCellTabla(tablaContMateriales, new Paragraph("", times8bold), prmsCellHead4)
        addCellTabla(tablaContMateriales, new Paragraph("", times8bold), prmsCellHead4)
        addCellTabla(tablaContMateriales, new Paragraph("", times8bold), prmsCellHead4)

        def totales6 = 0
        def totalPrueba6 =0
        def totalP6 = 0

        PdfPTable tablaContMano = new PdfPTable(6);
        tablaContMano.setWidthPercentage(100);
        tablaContMano.setWidths(arregloEnteros([14, 43, 8, 10, 12, 15]))

        addCellTabla(tablaContMano, new Paragraph("MANO DE OBRA", times10bold), prmsCellHead4)
        addCellTabla(tablaContMano, new Paragraph("Código", times8bold), prmsCellHead2)
        addCellTabla(tablaContMano, new Paragraph("Mano de Obra", times8bold), prmsCellHead2)
        addCellTabla(tablaContMano, new Paragraph("Unidad", times8bold), prmsCellHead2)
        addCellTabla(tablaContMano, new Paragraph("Horas Hombre", times8bold), prmsCellHead3)
        addCellTabla(tablaContMano, new Paragraph("Sal. / Hora", times8bold), prmsCellHead3)
        addCellTabla(tablaContMano, new Paragraph("Total", times8bold), prmsCellHead3)

        res2.each {
            addCellTabla(tablaContMano, new Paragraph(it?.codigo, times8normal), prmsCellLeft)
            addCellTabla(tablaContMano, new Paragraph(it?.item, times8normal), prmsCellLeft)
            addCellTabla(tablaContMano, new Paragraph(it?.unidad, times8normal), prmsCellCenter)
            addCellTabla(tablaContMano, new Paragraph(g.formatNumber(number: it?.cantidad, minFractionDigits:
                    2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight)

            addCellTabla(tablaContMano, new Paragraph(g.formatNumber(number: it?.punitario, minFractionDigits:
                    2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight)

            addCellTabla(tablaContMano, new Paragraph(g.formatNumber(number: (it?.total), minFractionDigits:
                    2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight)

            totales6 = (it?.punitario * it?.cantidad)
            totalPrueba6 = totalP6 += totales6
        }


        addCellTabla(tablaContMano, new Paragraph("", times8bold), prmsCellRight2)
        addCellTabla(tablaContMano, new Paragraph("", times8bold), prmsCellRight2)
        addCellTabla(tablaContMano, new Paragraph("", times8bold), prmsCellRight2)
        addCellTabla(tablaContMano, new Paragraph("", times8bold), prmsCellRight2)
        addCellTabla(tablaContMano, new Paragraph("Total:", times8bold), prmsCellRight2)
        addCellTabla(tablaContMano, new Paragraph(g.formatNumber(number: totalPrueba6, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellRight2)
        addCellTabla(tablaContMano, new Paragraph("", times8bold), prmsCellHead4)
        addCellTabla(tablaContMano, new Paragraph("", times8bold), prmsCellHead4)
        addCellTabla(tablaContMano, new Paragraph("", times8bold), prmsCellHead4)
        addCellTabla(tablaContMano, new Paragraph("", times8bold), prmsCellHead4)
        addCellTabla(tablaContMano, new Paragraph("", times8bold), prmsCellHead4)
        addCellTabla(tablaContMano, new Paragraph("", times8bold), prmsCellHead4)

//        document.add(tablaContMano);

        def totales7 = 0
        def totalPrueba7 =0
        def totalP7 = 0

        PdfPTable tablaContEq = new PdfPTable(6);
        tablaContEq.setWidthPercentage(100);
        tablaContEq.setWidths(arregloEnteros([14, 43, 8, 10, 12, 15]))

        addCellTabla(tablaContEq, new Paragraph("EQUIPOS", times10bold), prmsCellHead4)
        addCellTabla(tablaContEq, new Paragraph("Código", times8bold), prmsCellHead2)
        addCellTabla(tablaContEq, new Paragraph("Equipo", times8bold), prmsCellHead2)
        addCellTabla(tablaContEq, new Paragraph("Unidad", times8bold), prmsCellHead2)
        addCellTabla(tablaContEq, new Paragraph("Cantidad", times8bold), prmsCellHead3)
        addCellTabla(tablaContEq, new Paragraph("Tarifa", times8bold), prmsCellHead3)
        addCellTabla(tablaContEq, new Paragraph("Total", times8bold), prmsCellHead3)

        res3.each {
            addCellTabla(tablaContEq, new Paragraph(it?.codigo, times8normal), prmsCellLeft)
            addCellTabla(tablaContEq, new Paragraph(it?.item, times8normal), prmsCellLeft)
            addCellTabla(tablaContEq, new Paragraph(it?.unidad, times8normal), prmsCellCenter)
            addCellTabla(tablaContEq, new Paragraph(g.formatNumber(number: it?.cantidad, minFractionDigits:
                    2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight)

            addCellTabla(tablaContEq, new Paragraph(g.formatNumber(number: it?.punitario, minFractionDigits:
                    2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight)

            addCellTabla(tablaContEq, new Paragraph(g.formatNumber(number: (it?.total), minFractionDigits:
                    2, maxFractionDigits: 2, format: "##,##0", locale: "ec"), times8normal), prmsCellRight)

            totales7 = (it?.punitario * it?.cantidad)
            totalPrueba7 = totalP7 += totales7

        }

        addCellTabla(tablaContEq, new Paragraph("", times8bold), prmsCellRight4)
        addCellTabla(tablaContEq, new Paragraph("", times8bold), prmsCellRight4)
        addCellTabla(tablaContEq, new Paragraph("", times8bold), prmsCellRight4)
        addCellTabla(tablaContEq, new Paragraph("", times8bold), prmsCellRight4)
        addCellTabla(tablaContEq, new Paragraph("Total:", times8bold), prmsCellRight4)
        addCellTabla(tablaContEq, new Paragraph(g.formatNumber(number: totalPrueba7, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellRight4)

        addCellTabla(tablaContEq, new Paragraph("", times8bold), prmsCellHead4)
        addCellTabla(tablaContEq, new Paragraph("", times8bold), prmsCellHead4)


//        document.add(tablaContEq);

        def resultadoParcial1 = (totalPrueba5+totalTrans5+totalPrueba6+totalPrueba7);
        def resultadoFinal1 = (params?.totalPresupuesto ? params?.totalPresupuesto.toDouble() : 0) - resultadoParcial1;


        PdfPTable tablaTotalCont = new PdfPTable(6);
        tablaTotalCont.setWidthPercentage(100);
        tablaTotalCont.setWidths(arregloEnteros([85, 0, 0, 0, 0, 15]))

        addCellTabla(tablaTotalCont, new Paragraph("Subtotal: ", times8bold), prmsCellRight4)
        addCellTabla(tablaTotalCont, new Paragraph(" ", times8bold), prmsCellHead)
        addCellTabla(tablaTotalCont, new Paragraph(" ", times8bold), prmsCellHead)
        addCellTabla(tablaTotalCont, new Paragraph(" ", times8bold), prmsCellHead)
        addCellTabla(tablaTotalCont, new Paragraph(" ", times8bold), prmsCellHead)
        addCellTabla(tablaTotalCont, new Paragraph(g.formatNumber(number: (totalPrueba5+totalTrans5+totalPrueba6+totalPrueba7), format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellRight4)
        addCellTabla(tablaTotalCont, new Paragraph(" ", times8bold), prmsCellHead4)
        addCellTabla(tablaTotalCont, new Paragraph(obra?.totales + "% Costos Indirectos: ", times8bold), prmsCellRight4)
        addCellTabla(tablaTotalCont, new Paragraph(" ", times8bold), prmsCellHead)
        addCellTabla(tablaTotalCont, new Paragraph(" ", times8bold), prmsCellHead)
        addCellTabla(tablaTotalCont, new Paragraph(" ", times8bold), prmsCellHead)
        addCellTabla(tablaTotalCont, new Paragraph(" ", times8bold), prmsCellHead)
        addCellTabla(tablaTotalCont, new Paragraph(g.formatNumber(number: (resultadoFinal1), format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellRight4)
        addCellTabla(tablaTotalCont, new Paragraph(" ", times8bold), prmsCellHead4)
        addCellTabla(tablaTotalCont, new Paragraph("TOTAL DEL PRESUPUESTO: ", times8bold), prmsCellRight4)
        addCellTabla(tablaTotalCont, new Paragraph(" ", times8bold), prmsCellHead)
        addCellTabla(tablaTotalCont, new Paragraph(" ", times8bold), prmsCellHead)
        addCellTabla(tablaTotalCont, new Paragraph(" ", times8bold), prmsCellHead)
        addCellTabla(tablaTotalCont, new Paragraph(" ", times8bold), prmsCellHead)
        addCellTabla(tablaTotalCont, new Paragraph(g.formatNumber(number: (params?.totalPresupuesto), format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times8bold), prmsCellRight4)
        addCellTabla(tablaTotalCont, new Paragraph(" ", times8bold), prmsCellHead4)
        addCellTabla(tablaTotalCont, new Paragraph(" ", times8bold), prmsCellHead4)

        //resumen

        def resultadoParcial = (totalPrueba5+totalTrans5+totalPrueba6+totalPrueba7);
        def resultadoFinal = (params?.totalPresupuesto ? params?.totalPresupuesto.toDouble() : 0) - resultadoParcial;

        PdfPTable tablaValoresMemoPresu1 = new PdfPTable(4);
        tablaValoresMemoPresu1.setWidthPercentage(100);
        tablaValoresMemoPresu1.setWidths(arregloEnteros([34, 25, 20, 10]))

        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8bold), prmsCellHead4)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8bold), prmsCellHead4)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph("RESUMEN", times10bold), [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_LEFT, colspan: 4])
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph("Presupuesto referencial por contrato:", times10bold), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph("USD " + g.formatNumber(number: (params?.totalPresupuesto), format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times10normal), prmsHeaderHojaRight)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8normal), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph("Materiales", times8bold), prmsHeaderHojaRight)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(g.formatNumber(number: (totalPrueba5+totalTrans5), format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times10bold), prmsHeaderHojaRight)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8normal), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph("Mano de Obra", times8bold), prmsHeaderHojaRight)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(g.formatNumber(number: (totalPrueba6), format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times10normal), prmsHeaderHojaRight)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8normal), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph("Equipo", times8bold), prmsHeaderHojaRight)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(g.formatNumber(number: (totalPrueba7), format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times10normal), prmsHeaderHojaRight)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8normal), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(obra?.totales + " % Costos Indirectos", times8bold), prmsHeaderHojaRight)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(g.formatNumber(number: (resultadoFinal1), format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times10normal), prmsHeaderHojaRight)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8normal), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph("TOTAL", times8bold), prmsHeaderHojaRight)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(g.formatNumber(number: (params?.totalPresupuesto), format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times10normal), prmsHeaderHojaRight)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8bold), prmsHeaderHoja4)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8bold), prmsHeaderHoja4)
//        println "generando reporte: .."+ session.perfil.codigo
        if(obra.tipo == 'D' && session.perfil.codigo == 'COGS') {
            addCellTabla(tablaValoresMemoPresu1, new Paragraph("Presupuesto por Cogestión:", times10bold), prmsHeaderHoja)
        } else if(obra.tipo == 'D' && session.perfil.codigo == 'ADDI'){
            addCellTabla(tablaValoresMemoPresu1, new Paragraph("Presupuesto por Administración Directa:", times10bold), prmsHeaderHoja)
        } else  addCellTabla(tablaValoresMemoPresu1, new Paragraph("Presupuesto por administración directa:", times10bold), prmsHeaderHoja)

        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph("USD " + g.formatNumber(number: (params?.total ?: (totalPrueba2+totalTrans+totalPrueba3+totalPrueba4+params?.costo)), format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times10normal), prmsHeaderHojaRight)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8normal), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph("Materiales", times8bold), prmsHeaderHojaRight)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(g.formatNumber(number: (totalPrueba2+totalTrans), format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times10bold), prmsHeaderHojaRight)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8normal), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph("Mano de Obra", times8bold), prmsHeaderHojaRight)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(g.formatNumber(number: params?.manoObra ?: 0, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times10normal), prmsHeaderHojaRight)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8normal), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph("Equipo", times8bold), prmsHeaderHojaRight)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(g.formatNumber(number: params?.equipos ?: 0, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times10normal), prmsHeaderHojaRight)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8normal), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(params?.costoPorcentaje + " %" + " Costos Indirectos", times8bold), prmsHeaderHojaRight)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(g.formatNumber(number: params?.costo ?: 0, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times10normal), prmsHeaderHojaRight)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8bold), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8normal), prmsHeaderHoja)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph("TOTAL", times8bold), prmsHeaderHojaRight)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(g.formatNumber(number: (params?.total ?: ((totalPrueba2+totalTrans) + totalPrueba3+totalPrueba4+params?.costo)), format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2), times10normal), prmsHeaderHojaRight)
        addCellTabla(tablaValoresMemoPresu1, new Paragraph(" ", times8bold), prmsHeaderHoja)

//       nota

        Paragraph pie = new Paragraph();
        pie.setAlignment(Element.ALIGN_LEFT);
        pie.add(new Chunk("Nota", times10bold))
        pie.add(new Paragraph(": Para Administración Directa, a los costos de los materiales se incrementa el porcentaje de Timbres Provinciales y el de gastos financieros", times8normal ))
        pie.add(new Chunk("PLAZO", times10bold))
        pie.add(new Paragraph(": " + obra?.plazoEjecucionMeses + " mes(es) " + obra?.plazoEjecucionDias + " días calendario", times8normal ))
        if(obra.tipo == 'D' & session.perfil.codigo == 'COGS') {
            addCellTabla(tablaValoresMemoPresu1, new Paragraph("Presupuesto por Cogestión:", times10bold), prmsHeaderHoja)
        } else if(obra.tipo == 'D' & session.perfil.codigo == 'ADDI') {
            addCellTabla(tablaValoresMemoPresu1, new Paragraph("Presupuesto por Administración Directa:", times10bold), prmsHeaderHoja)
        } else  addCellTabla(tablaValoresMemoPresu1, new Paragraph("Presupuesto por administración directa:", times10bold), prmsHeaderHoja)
        if(obra.tipo == 'D' & session.perfil.codigo == 'COGS') {
            pie.add(new Paragraph("Cabe indicar que para ejecutar esta obra por cogestión el valor que se requerirá consiste en el costo de los materiales \$ " + g.formatNumber(number: params?.materiales, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2)
                    + " puesto que la mano de obra y los costos están considerados dentro de los gastos corrientes de la Institución.", times8normal));
        } else {
            pie.add(new Paragraph("Cabe indicar que para ejecutar esta obra por administración directa el valor que se " +
                    "requerirá consiste en el costo de los materiales \$ " +
                    g.formatNumber(number: params?.materiales, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2)
                    + " puesto que la mano de obra y los costos están considerados dentro de los gastos corrientes de la Institución.", times8normal));
        }

        pie.add(new Paragraph("", times8normal));
        pie.add(new Paragraph("La institución realiza un estudio de mercado independiente de cualquier proceso de compra de materiales " +
                "o contratación de obra específico, para lo cual cada cuatro meses la PRSP, realiza la actualización de los precios de los " +
                "materiales de construcción, con la colaboración de varias empresas fabricantes, distribuidores y ferreterías que " +
                "proporcionan un listado de venta al público de sus diferentes productos.", times8normal));

        pie.setAlignment(Element.ALIGN_JUSTIFIED);
        addEmptyLine(pie, 1);

        PdfPTable tablaAdjunto = new PdfPTable(2);
        tablaAdjunto.setWidthPercentage(100);
        tablaAdjunto.setWidths(arregloEnteros([10,70]))


        addCellTabla(tablaAdjunto, new Paragraph(" ", times8normal), prmsHeaderHoja)
        addCellTabla(tablaAdjunto, new Paragraph(" ", times8normal), prmsHeaderHoja)

        addCellTabla(tablaAdjunto, new Paragraph("Adjunto: ", times8normal), prmsHeaderHoja)
        addCellTabla(tablaAdjunto, new Paragraph(auxiliar?.notaPieAd, times8normal), prmsHeaderHojaLeft)

        document.add(headers);
        document.add(tablaCabeceraMemo);
        document.add(tablaParametros);
        document.add(tablaValoresMemoPresu1);

        document.add(tablaTextoMemoPresu);
        document.add(tablaValoresMemoPresu);
        document.add(tablaVolObraMemoPresu)

        document.add(tablaContrato);
        document.add(tablaContMateriales);
        document.add(tablaContMano);
        document.add(tablaContEq);
        document.add(tablaTotalCont);

        document.add(tablaAdmDirecta);
        document.add(tablaComMateriales);
        document.add(tablaComMano);
        document.add(tablaComEq);
        document.add(tablaTotalCom);

        document.add(pie);

        if (cuenta == 3) {
            PdfPTable tablaFirmas = new PdfPTable(3);
            tablaFirmas.setWidthPercentage(100);
            addCellTabla(tablaFirmas, new Paragraph(" ", times10bold), prmsHeaderHoja)
            addCellTabla(tablaFirmas, new Paragraph(" ", times10bold), prmsHeaderHoja)
            addCellTabla(tablaFirmas, new Paragraph(" ", times10bold), prmsHeaderHoja)
            addCellTabla(tablaFirmas, new Paragraph(" ", times10bold), prmsHeaderHoja)
            addCellTabla(tablaFirmas, new Paragraph(" ", times10bold), prmsHeaderHoja)
            addCellTabla(tablaFirmas, new Paragraph(" ", times10bold), prmsHeaderHoja)
            addCellTabla(tablaFirmas, new Paragraph("______________________________________", times8bold), prmsHeaderHoja)
            addCellTabla(tablaFirmas, new Paragraph("______________________________________", times8bold), prmsHeaderHoja)
            addCellTabla(tablaFirmas, new Paragraph("______________________________________", times8bold), prmsHeaderHoja)

            firmaFijaMP.each { f ->
                if(f != ''){
                    firmas = Persona.get(f)
                    addCellTabla(tablaFirmas, new Paragraph((firmas?.titulo?.toUpperCase() ?: '') + " " + (firmas?.nombre?.toUpperCase() ?: '') + " " + (firmas?.apellido?.toUpperCase() ?: ''), times8bold), prmsHeaderHoja)
                }else {
                    addCellTabla(tablaFirmas, new Paragraph("Sin Asignar", times8bold), prmsHeaderHoja)
                }
            }

            firmas = Persona.get(firmaFijaMP[0])
            addCellTabla(tablaFirmas, new Paragraph(firmas?.cargo?.toUpperCase() ?: '', times8bold), prmsHeaderHoja)
            addCellTabla(tablaFirmas, new Paragraph("REVISOR", times8bold), prmsHeaderHoja)
            addCellTabla(tablaFirmas, new Paragraph("ELABORÓ", times8bold), prmsHeaderHoja)
//            }
            document.add(tablaFirmas);
        }
        document.add(tablaAdjunto);
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + name)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)

    }

    def errores() {
        return [params: params]
    }

}