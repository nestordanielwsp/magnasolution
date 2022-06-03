using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Transactions;
using System.Web;
using System.Xml.Linq;
using Infraestructura.Archivos;
using Newtonsoft.Json;
using OfficeOpenXml;
using Renci.SshNet;

namespace CYP.Codes
{
    public class RobotConfiguracion
    {
        private static string NamePcMod = "Robot";
        private static string AuditUserId = "0";
        private static string Sincronizador = "";
        private static string ArtículosActivityId = "19";

        public static Dictionary<int, string> IdCampos = new Dictionary<int, string>
            {
                {1, Cliente},
                {2, Vendedor},
                {3, CentroCostos},
                {4, CuentaContable},
                {5, Subcuenta},
                {6, Devolucion},
                {7, FacturaProducto},
                {8, LineaProducto},
                {9, Articulo},
                {10, Cartera},
                {11, Cartera},
                {12, Pago},
                {13, RegistroQad},
                {14, CancelacionPago},
                {15, Trazabilidad},
                {16, AsignacionAnalistaCliente},
                {17, ListaPrecio},
                {18, Proyecto},
                {19, ArtículosActivity},
                {20, Proveedor},
                {21, Presupuesto},
                {22, MatrizPOP},
                {23, MatrizDiasFestivos},
                {999, ProductoActivity},
            };

        public static Dictionary<string, object> Sincronizar(Dictionary<string, object> datos, bool esDesdePagina = false)
        {
            var storage = new AlmacenamientoAzureServicio();
            var response = new Dictionary<string, object>();
            var servidor = ConfigurationManager.AppSettings["ServidorFtp"];
            var user = ConfigurationManager.AppSettings["UsuarioFtp"];
            var pass = ConfigurationManager.AppSettings["PasswordFtp"];
            var directoryFtp = ConfigurationManager.AppSettings["DirectorioArchivosFtp"];
            var directoryLocal = HttpContext.Current.Server.MapPath(ConfigurationManager.AppSettings["CarpetaArchivos"]) + "SFTP\\";

            //directoryFtp = directoryLocal;

            var a = new LogicAccess();
            string[] clavesAlmacen = { "MXQUAGRS", "MEXPOP", "MEXPOP03" };
            int totalArchivosArticulos = 0;
            //Se obtiene la información de los sincronizadores que toca cargar para procesar los archivos.
            var dt = a.ExecuteQuery("Sincronizador_Sel", datos).Tables[0];
            var sincronizadores = a.DataTableToMap(dt);

            if (esDesdePagina)
            {
                NamePcMod = datos["NamePcMod"].ToString();
                AuditUserId = datos["UsuarioID"].ToString();
                if (sincronizadores.Count > 0)
                {
                    Sincronizador = sincronizadores[0]["SincronizadorId"].ToString();
                }
            }

            using (var sftp = new SftpClient(servidor, user, pass))
            {
                //sftp.ConnectionInfo.Timeout = new TimeSpan(0,0,0,5);
                sftp.Connect();

                foreach (var sincronizador in sincronizadores)
                {
                    var nombreArchivo = a.GetString(sincronizador, "NombreArchivo");
                    var rutaArchivoSftp = directoryFtp + nombreArchivo;
                    sincronizador.Add("TipoCambio", datos.ContainsKey("TipoCambio") ? datos["TipoCambio"] : 0);

                    if (sincronizador["SincronizadorId"].ToString() == ArtículosActivityId)
                    {
                        for (int index = 0; index < clavesAlmacen.Length; index++)
                        {
                            rutaArchivoSftp = string.Format("{0}{1}_{2}.csv", directoryFtp, Path.GetFileNameWithoutExtension(nombreArchivo), clavesAlmacen[index]);

                            if (sftp.Exists(rutaArchivoSftp))
                            {
                                totalArchivosArticulos += 1;
                                response = ProcesarArchivoSFTP(sftp, sincronizador, rutaArchivoSftp);
                            }
                        }

                        if (totalArchivosArticulos == 0)
                        {
                            var descripcion = "Error: El archivo no existe";
                            GuardarLogError(descripcion, sincronizador);
                            response["Error"] = descripcion;
                        }
                    }
                    else
                    {
                        if (sftp.Exists(rutaArchivoSftp))
                        {
                            ProcesarArchivoSFTP(sftp, sincronizador, rutaArchivoSftp);
                        }
                        else
                        {
                            var descripcion = "Error: El archivo no existe";
                            GuardarLogError(descripcion, sincronizador);
                            response["Error"] = descripcion;
                        }
                    }
                }

                sftp.Disconnect();
            }
            return response;
        }

        public static Dictionary<string, object> ProcesarArchivoSFTP(SftpClient sftp, Dictionary<string, object> sincronizador, string rutaArchivoSftp)
        {
            var response = new Dictionary<string, object>();
            var a = new LogicAccess();

            var sincronizadorId = a.GetInt(sincronizador, "SincronizadorId");
            var encoding = sincronizadorId == 8 ? Encoding.UTF8 : Encoding.Default;
            var fileBytes = sftp.ReadAllBytes(rutaArchivoSftp);
            //var fileBytes = File.ReadAllBytes(rutaArchivoSftp);
            var tipo = a.GetString(sincronizador, "Tipo").Trim();
            var json = IdCampos[sincronizadorId];
            var campos = JsonConvert.DeserializeObject<List<Dictionary<string, object>>>(json);

            sincronizador["SincronizacionId"] = 0;
            sincronizador["NamePcMod"] = NamePcMod;
            sincronizador["AuditUserId"] = AuditUserId;

            if (tipo == "xlsx")
            {
                if (sincronizadorId == (int)Codes.Sincronizador.DiasFestivos)
                {
                    json = IdCampos[23];
                    campos = JsonConvert.DeserializeObject<List<Dictionary<string, object>>>(json);
                    sincronizador["StoreProcedure"] = "MatrizDiasFestivos_IU";
                    ProcesarExcelDiasFestivos(fileBytes, campos, sincronizador, 1);
                }
                else if (sincronizadorId == (int)Codes.Sincronizador.ListaPrecioProducto)
                {
                    ProcesarExcel(fileBytes, campos, sincronizador, 1);

                    json = IdCampos[999];
                    campos = JsonConvert.DeserializeObject<List<Dictionary<string, object>>>(json);
                    sincronizador["StoreProcedure"] = "ProductoActivity_IU";

                    ProcesarExcel(fileBytes, campos, sincronizador, 2);
                }
                else if (sincronizadorId == (int)Codes.Sincronizador.Presupuesto)
                {
                    ProcesarExcelPresupuesto(fileBytes, campos, sincronizador, 1);
                }
                else if (sincronizadorId == (int)Codes.Sincronizador.MatrizPOP)
                {
                    json = IdCampos[22];
                    campos = JsonConvert.DeserializeObject<List<Dictionary<string, object>>>(json);
                    sincronizador["StoreProcedure"] = "MatrizPOP_IU";
                    ProcesarExcelPOP(fileBytes, campos, sincronizador, 1);
                }
            }
            else
            {
                using (var fileStream = new StreamReader(new MemoryStream(fileBytes), encoding))
                {
                    var allLines = fileStream.ReadToEnd().Split('\n').ToArray();

                    try
                    {
                        if (tipo == "|" || tipo == ",")
                        {
                            var tipoChar = Convert.ToChar(tipo);
                            var startLine = tipo == "|" ? 1 : 2;
                            ProcesarCsvOrTxt(allLines, tipoChar, sincronizador, campos, startLine);
                        }
                        else if (tipo == "prn")
                            ProcesarPrn(allLines, sincronizador, campos);
                    }
                    catch (Exception ex)
                    {
                        GuardarLogError(ex.Message, null, ex.StackTrace);
                        response["Error"] = "Error en el sistema favor de contactar a su proveedor";
                    }

                    fileStream.Close();
                }
            }

            return response;
        }
        public static void ProcesarExcel(byte[] fileBytes, List<Dictionary<string, object>> campos,
            Dictionary<string, object> sincronizador, int hoja)
        {
            var fila = 2;
            var listaDatos = new List<Dictionary<string, object>>();
            var lineasConError = 0;

            try
            {
                var a = new LogicAccess();
                using (MemoryStream memStream = new MemoryStream(fileBytes))
                {
                    var pck = new ExcelPackage(memStream);
                    var ws = pck.Workbook.Worksheets[hoja];
                    var primerValor = ws.Cells[fila, 1].Text;

                    while (primerValor != "")
                    {
                        var error = "";
                        var datos = new Dictionary<string, object>();

                        foreach (var campo in campos)
                        {
                            var posicion = a.GetInt(campo, "Posicion");
                            object valor = ws.Cells[fila, posicion].Text;
                            ObtenerValorCampo(valor, campo, datos, ref error);
                        }

                        if (error != "")
                        {
                            lineasConError++;
                            var descripcion = string.Format("Línea {0}. Error: ", fila) + error;
                            GuardarLogError(descripcion, sincronizador);
                        }
                        else
                            listaDatos.Add(datos);

                        fila++;
                        primerValor = ws.Cells[fila, 1].Text;
                    }
                }
            }
            catch (Exception ex)
            {
                var descripcion = string.Format("Fila {0}; error: ", fila) + ex.Message;
                GuardarLogError(descripcion, null, ex.StackTrace);
            }

            GuardarDatos(listaDatos, sincronizador, lineasConError);
        }

        public static void ProcesarExcelPOP(byte[] fileBytes, List<Dictionary<string, object>> campos,
         Dictionary<string, object> sincronizador, int hoja)
        {
            var fila = 7;
            var listaDatos = new List<Dictionary<string, object>>();
            var lineasConError = 0;

            try
            {
                var a = new LogicAccess();
                using (MemoryStream memStream = new MemoryStream(fileBytes))
                {
                    var pck = new ExcelPackage(memStream);
                    var ws = pck.Workbook.Worksheets[hoja];
                    var primerValor = ws.Cells[fila, 24].Text;

                    while (primerValor != "")
                    {
                        var error = "";
                        var datos = new Dictionary<string, object>();

                        foreach (var campo in campos)
                        {
                            var posicion = a.GetInt(campo, "Posicion");
                            object valor = ws.Cells[fila, posicion].Text;
                            ObtenerValorCampo(valor, campo, datos, ref error);
                        }

                        if (error != "")
                        {
                            lineasConError++;
                            var descripcion = string.Format("Línea {0}. Error: ", fila) + error;
                            GuardarLogError(descripcion, sincronizador);
                        }
                        else
                            listaDatos.Add(datos);

                        fila++;
                        primerValor = ws.Cells[fila, 24].Text;
                    }
                }
            }
            catch (Exception ex)
            {
                var descripcion = string.Format("Fila {0}; error: ", fila) + ex.Message;
                GuardarLogError(descripcion, null, ex.StackTrace);
            }

            GuardarDatos(listaDatos, sincronizador, lineasConError);
        }

        public static void ProcesarExcelDiasFestivos(byte[] fileBytes, List<Dictionary<string, object>> campos,
        Dictionary<string, object> sincronizador, int hoja)
        {
            var fila = 2;
            var listaDatos = new List<Dictionary<string, object>>();
            var totalRegistrosError = 0;
            var totalRegistrosOK = 0;
            var commit = 0;
            try
            {
                var a = new LogicAccess();
                var descripcionError = "";
                using (MemoryStream memStream = new MemoryStream(fileBytes))
                {
                    var pck = new ExcelPackage(memStream);
                    var ws = pck.Workbook.Worksheets[hoja];
                    var primerValor = ws.Cells[fila, 1].Text;
                     
                    while (primerValor != "")
                    {
                        var datosDetalle = new Dictionary<string, object>();

                        // registramos individualmente y realizamos las validaciones correspondientes
                        // permitir la edición del mes corriente, y meses futuros y que no sea retroactivo, 
                        // es decir que ya no cambien meses anteriores al actual para mantener un histórico.
                        datosDetalle = new Dictionary<string, object>
                                        { 
                                            { "Dia", ws.Cells[fila, 1].Text },
                                            { "Mes", ws.Cells[fila, 2].Text },
                                            { "Anio", ws.Cells[fila, 3].Text },
                                            { "NombreDia", ws.Cells[fila, 4].Text },
                                            { "Mensaje",  string.Empty},
                                            { "AuditUserId",sincronizador["AuditUserId"] }
                                        };
                        a.ExecuteNonQuery("MatrizDiasFestivos_IU", datosDetalle);

                        if (!string.IsNullOrEmpty(datosDetalle["Mensaje"].ToString()))
                        {
                            totalRegistrosError += 1;
                            descripcionError = descripcionError + string.Format("Respuesta: " + datosDetalle["Mensaje"].ToString()) + " // ";
                        }
                        else
                            totalRegistrosOK += 1;

                        fila++;
                        primerValor = ws.Cells[fila, 1].Text;
                    }
                }

                // guardamos log de los registros enviados
                if (descripcionError != "")
                {
                    GuardarLogError(descripcionError, sincronizador, null);
                }
                else
                { 
                    var error = totalRegistrosError == 0 ? "" : string.Format("; Error: {0} registros", totalRegistrosError);
                    sincronizador["Descripcion"] = string.Format("Ok, {0} registros", totalRegistrosOK) + error;
                    a.ExecuteNonQuery("Log_Sincronizador_I", sincronizador);

                    sincronizador["Resultado"] = sincronizador["Descripcion"];
                    a.ExecuteNonQuery("Sincronizador_U", sincronizador);
                }

            }
            catch (Exception ex)
            {
                var descripcion = string.Format("Fila {0}; error: ", fila) + ex.Message;
                GuardarLogError(descripcion, null, ex.StackTrace);
            }
             
        }


        public static void ProcesarExcelPresupuesto(byte[] fileBytes, List<Dictionary<string, object>> campos,
      Dictionary<string, object> sincronizador, int hoja)
        {
            var fila = 2;
            int columna = 4, totalRegistrosOK=0,totalRegistrosError=0;
            var datosHeader = new Dictionary<string, object>();
            var datosDetalle = new Dictionary<string, object>();
            var listaMarcas = new List<Dictionary<string, object>>();
            bool esFinHoja;
            string descripcionError, concepto;
            var a = new LogicAccess();

            try
            {         
                using (MemoryStream memStream = new MemoryStream(fileBytes))
                {

                    var pck = new ExcelPackage(memStream);
                    var ws = pck.Workbook.Worksheets[hoja];

                    //Obtener marcas
                    string subcuentaContable = ws.Cells[fila, columna].Text;
                    while (subcuentaContable != string.Empty)
                    {
                        var dtMarca = a.ExecuteQuery("Marca_BySubcuenta", new Dictionary<string, object> { { "SubcuentaContable", subcuentaContable } }).Tables[0];
                        listaMarcas.Add(new Dictionary<string, object> {
                            { "SubcuentaContable", subcuentaContable },
                            { "LineaCodigo", dtMarca.Rows.Count > 0 ? dtMarca.Rows[0]["LineaCodigo"].ToString() : string.Empty },
                            { "Posicion", columna }
                        });

                        columna += 1;
                        subcuentaContable = ws.Cells[fila, columna].Text;
                    }

                    fila += 1;
                    string valorColumna1 = ws.Cells[fila, 1].Text;
                    string valorColumna4 = ws.Cells[fila, 3].Text;
                 
                    bool esHeader = valorColumna1 == string.Empty && valorColumna4 != string.Empty ? true : false;

                    while (esHeader && valorColumna4 != string.Empty)
                    {
                        concepto = ws.Cells[fila, 3].Text;
                        fila += 1;
                        valorColumna1 = ws.Cells[fila, 1].Text;
                        valorColumna4 = ws.Cells[fila, 3].Text;
                        esHeader = valorColumna1 == string.Empty && valorColumna4 != string.Empty ? true : false;
                        esFinHoja = ws.Cells[fila, 1].Text == string.Empty && ws.Cells[fila, 2].Text == string.Empty && ws.Cells[fila, 3].Text == string.Empty ? true : false;

                        datosHeader = new Dictionary<string, object>
                        {
                             { "PresupuestoConcepto", concepto },
                             { "Anio", DateTime.Now.Year }
                        };
                        a.ExecuteNonQuery("Presupuesto_Del", datosHeader);
                        //Insertar los detalles
                        if (!esHeader)
                        {
                            while (!esHeader && !esFinHoja)
                            {
                                foreach (var marca in listaMarcas)
                                {
                                    if (!string.IsNullOrEmpty(marca["LineaCodigo"].ToString()))
                                    {
                                        decimal.TryParse(ws.Cells[fila, int.Parse(marca["Posicion"].ToString())].Text, out decimal monto);
                                        datosDetalle = new Dictionary<string, object>
                                        {
                                            { "PresupuestoConcepto", concepto },
                                            { "Rubro", ws.Cells[fila, 1].Text },
                                            { "Cuenta", ws.Cells[fila, 2].Text },
                                            { "Medios", ws.Cells[fila, 3].Text },
                                            { "SubcuentaContable", marca["SubcuentaContable"] },
                                            { "Monto",  monto},
                                            { "Mensaje",  string.Empty},
                                            { "Anio", DateTime.Now.Year },
                                            { "AuditUserId",sincronizador["AuditUserId"] }
                                        };
                                        a.ExecuteNonQuery("Presupuesto_IU", datosDetalle);

                                        if (!string.IsNullOrEmpty(datosDetalle["Mensaje"].ToString()))
                                        {
                                            totalRegistrosError += 1;
                                            descripcionError = string.Format("No se encontró el Rubro {0}. Columna {1}", ws.Cells[fila, 1].Text, ws.Cells[fila, int.Parse(marca["Posicion"].ToString())].Address);
                                            GuardarLogError(descripcionError, sincronizador, null);
                                        }                                           
                                        else
                                            totalRegistrosOK += 1;
                                    }
                                    else
                                    {                                  
                                        totalRegistrosError += 1;
                                        descripcionError = string.Format("No se encontró la cuenta {0}. Columna {1}", marca["SubcuentaContable"], ws.Cells[fila, int.Parse(marca["Posicion"].ToString())].Address);
                                        GuardarLogError(descripcionError, sincronizador, null);
                                    }                                     
                                }

                                fila += 1;
                                valorColumna1 = ws.Cells[fila, 1].Text;
                                valorColumna4 = ws.Cells[fila, 3].Text;
                                esHeader = valorColumna1 == string.Empty && valorColumna4 != string.Empty ? true : false;
                                esFinHoja = ws.Cells[fila, 1].Text == string.Empty && ws.Cells[fila, 2].Text == string.Empty && ws.Cells[fila, 3].Text == string.Empty ? true : false;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                var descripcion = string.Format("Fila {0}; error: ", fila) + ex.Message;
                GuardarLogError(descripcion, null, ex.StackTrace);
            }

            var error = totalRegistrosError == 0 ? "" : string.Format("; Error: {0} registros", totalRegistrosError);
            sincronizador["Descripcion"] = string.Format("Ok, {0} registros", totalRegistrosOK) + error;
            a.ExecuteNonQuery("Log_Sincronizador_I", sincronizador);

            sincronizador["Resultado"] = sincronizador["Descripcion"];
            a.ExecuteNonQuery("Sincronizador_U", sincronizador);
        }

        public static void ProcesarCsvOrTxt(string[] lines, char tipo, Dictionary<string, object> sincronizador,
                   List<Dictionary<string, object>> campos, int startLine)
        {
            var a = new LogicAccess();
            var listaDatos = new List<Dictionary<string, object>>();
            int linea = 0, lineasProcesadas = 0, lineasConError = 0;
            var error = "";
            var campoError = "";
            var sincronizadorId = a.GetInt(sincronizador, "SincronizadorId");

            foreach (var line in lines.Where(e => e != ""))
            {
                linea++;
                if (linea >= startLine)
                {
                    try
                    {
                        string[] valores;
                        if (tipo == ',')
                        {
                            var pattern = ",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)";
                            valores = Regex.Split(line, pattern);
                        }
                        else
                        {
                            valores = line.Split(tipo);
                        }

                        var datos = new Dictionary<string, object>();
                        error = "";
                        campoError = "";

                        foreach (var campo in campos)
                        {
                            var posicion = a.GetInt(campo, "Posicion");
                            var nombreCampo = campo["Campo"].ToString();
                            campoError = nombreCampo;
                            var tipoDato = campo["TipoDato"].ToString();
                            object valor = valores[posicion].Trim().Replace("\"", "");
                            var valorString = a.GetString(valor);

                            if (sincronizadorId == 13 && posicion == 9)
                            {
                                var startIndex = valorString.IndexOf("*") + 1;
                                var endIndex = valorString.LastIndexOf("*");

                                //Este error es especifico para el archivo detNotas, la mayoria de los registros no traen el folio, 
                                //por lo que si el folio no viene no se grabará en el log de errores
                                if (endIndex != -1)
                                    valor = valorString.Substring(startIndex, endIndex - startIndex);
                                else
                                    error = "-1";
                            }

                            if (tipoDato != "" && valorString != "")
                            {
                                switch (tipoDato)
                                {
                                    case "int":
                                        valor = a.GetInt(valor, ref error);
                                        break;
                                    case "decimal":
                                        valor = a.GetDecimal(valor, ref error);
                                        break;
                                    case "date":
                                        if (valorString != "?")
                                        {
                                            valor = campo.ContainsKey("Formato")
                                                ? a.GetDate(valor, ref error, campo["Formato"].ToString())
                                                : a.GetDate(valor, ref error);
                                        }
                                        else
                                        {
                                            valorString = "";
                                        }
                                        break;
                                    case "stringToBool":
                                        valor = a.GetBoolFromString(valor, "yes", ref error);
                                        break;
                                    case "time":
                                        //Se agregan por separado la hora el minuto y el segundoa los datos.
                                        var valorSplit = valorString.Split(':');
                                        if (valorSplit.Count() == 3)
                                        {
                                            datos["Hora"] = valorSplit[0].Trim();
                                            datos["Minuto"] = valorSplit[1].Trim();
                                            datos["Segundo"] = valorSplit[2].Trim();
                                        }

                                        valorString = "";
                                        break;
                                }
                            }

                            if (valorString != "")
                            {
                                datos[nombreCampo] = valor;
                            }
                        }

                        if (error != "" && error != "-1")
                        {
                            lineasConError++;
                            var descripcion = string.Format("Línea {0}, campo {1}. Error: ", linea, campoError) + error;
                            GuardarLogError(descripcion, sincronizador);
                        }
                        else if (error == "")
                        {
                            listaDatos.Add(datos);
                            lineasProcesadas++;
                        }
                    }
                    catch (Exception ex)
                    {
                        lineasConError++;
                        var descripcion = string.Format("Línea {0}, campo {1}; error: ", linea, campoError) + ex.Message;
                        GuardarLogError(descripcion, null, ex.StackTrace);
                    }
                }
            }

            //Se utilizará para saber los folios que se repiten mas de 5 veces para el archivo detNotas
            if (sincronizadorId == 13)
            {
                var folios = listaDatos.Select(e => e["FolioTpm"].ToString()).Distinct().ToList();

                foreach (var folio in folios)
                {
                    var repetidos = listaDatos.Where(e => e["FolioTpm"].ToString() == folio).ToList();
                    if (repetidos.Count > 5)
                    {
                        listaDatos.RemoveAll(e => e["FolioTpm"].ToString() == folio);
                    }
                }
            }

            GuardarDatos(listaDatos, sincronizador, lineasConError);
        }

        public static void ProcesarPrn(string[] lines, Dictionary<string, object> sincronizador,
            List<Dictionary<string, object>> campos)
        {
            var a = new LogicAccess();
            var listaDatos = new List<Dictionary<string, object>>();
            var informacionLlave = new List<string>();
            int linea = 0, lineasProcesadas = 0, lineasConError = 0;
            var error = "";
            var campoError = "";
            var esLineaCampo = false;
            var sincronizadorId = a.GetInt(sincronizador, "SincronizadorId");
            var lineaProducto = "";
            var finReporte = false;
            var esLineaCodigoProducto = false;
            var esInicioLineaProducto = false;
            var numLineaProducto = 1;
            var datos = new Dictionary<string, object>();

            try
            {
                foreach (var line in lines.Where(line => !finReporte))
                {
                    var lineaNoEspacios = line.Trim();

                    finReporte = lineaNoEspacios.Contains("Fin de Reporte");
                    linea++;

                    //Si no se procesa el archivo producto(Línea Productos), cada nueva línea genera un nuevo registro(datos)
                    if (sincronizadorId != 8)
                    {
                        datos = new Dictionary<string, object>();
                    }

                    var inicioLinea = string.IsNullOrEmpty(line) ? "" : line.Substring(0, 1);
                    var finLinea = string.IsNullOrEmpty(line) || lineaNoEspacios.Length < 4 ? "" : lineaNoEspacios.Substring(0, 4);
                    var longitudLinea = line.Length;
                    var guardarLinea = true;

                    //Archivo de FacturaProducto(01vtaart)
                    if (sincronizadorId == 7)
                    {
                        //Verifica si la línea trae información (Campo Cobr-A).
                        esLineaCampo = false;
                        esLineaCodigoProducto = line.Split(' ')[0].Length == 8 && line.IndexOf("---") < 0;
                    }

                    //Archivo de Productos(Línea Producto)
                    if (sincronizadorId == 8)
                    {
                        if (!esInicioLineaProducto)
                        {
                            esInicioLineaProducto = line.Length > 12 && line.Substring(0, 12).Contains("Lín Producto");

                            //Si se procesa el archivo producto(Línea Productos), se genera un nuevo registro
                            //cada que se vuelve a encontrar la palabra Lin Producto
                            if (esInicioLineaProducto)
                            {
                                datos = new Dictionary<string, object>();
                                listaDatos.Add(datos);
                                lineasProcesadas++;
                            }
                        }
                    }

                    //Archivo de Articulos(Producots)
                    if (sincronizadorId == 9)
                    {
                        if (inicioLinea == "\t")
                        {
                            esLineaCampo = false;
                        }

                        if (lineaNoEspacios.Contains("Línea:"))
                        {
                            lineaProducto = lineaNoEspacios.Substring(6, 5).Trim();
                            //lineaProducto["NombreLinea"] = lineaNoEspacios.Substring(12, lineaNoEspacios.Length - 12).Trim();
                            esLineaCampo = false;
                        }
                    }
                    if (line.Contains("2018/MXF-FRCL/000001887") || line.Contains("2018/MXO-FRCL000271164 "))
                    {

                    }
                    if (sincronizadorId == 10 || sincronizadorId == 11 || sincronizadorId == 12 || sincronizadorId == 15)
                    {
                        esLineaCampo = line.ToLower().Contains("/mxf-") || line.ToLower().Contains("/mxo-");
                    }

                    //Encuentra si la línea es el salto de pagina o fin de línea para no procesar las siguientes líneas
                    if (esLineaCampo && (inicioLinea == "\f" || finLinea == "----"))
                    {
                        esLineaCampo = false;
                    }

                    if ((esLineaCampo && !finReporte && longitudLinea > 0) || esInicioLineaProducto || esLineaCodigoProducto)
                    {
                        error = "";

                        //Si no se esta leyendo el archivo Producto(!esInicioLineaProducto) se leen todos los campos
                        //en caso contrario se lee el número de línea del campo y se valida con el numLineaProducto
                        foreach (var campo in campos.Where(e => !esInicioLineaProducto || numLineaProducto == Convert.ToInt16(e["Linea"])))
                        {
                            var posicion = a.GetInt(campo, "Posicion");
                            var esLlave = campo.ContainsKey("EsLlave") && Utilities.GetBool(campo, "EsLlave");
                            //Si campo trae la llave EsUltimoCampo quiere decir que la longitud del campo puede ser variable,
                            //por lo que esta longitud se saca de la longitud total de la lína menos la posición
                            var longitud = !esInicioLineaProducto || !campo.ContainsKey("EsUltimoCampo")
                                ? a.GetInt(campo, "Longitud")
                                : line.Length - posicion;

                            //Cuando la posición del campo no es fija, restando la posición a la longitudLinea
                            //se asegura que se va a poder sacar un valor del campo cuando se haga el substring
                            longitud = posicion + longitud > longitudLinea ? longitudLinea - posicion : longitud;

                            object valor = posicion + longitud > longitudLinea || longitud < 1
                                ? ""
                                : line.Substring(posicion, longitud).Trim();
                            var valorString = valor.ToString();

                            //Caso especial para los archivos de cartera, los días de vencimiento pueden 
                            //traer un número o una palabra,si es palabra el valor se convierte a "0"
                            if ((sincronizadorId == 10 || sincronizadorId == 11) && campo["Campo"].ToString() == "DiasVencimiento")
                            {
                                int valorEntero;
                                int.TryParse(valorString, out valorEntero);
                                valor = valorEntero;
                                valorString = valorEntero.ToString();
                            }

                            if (!esLlave || (esLlave && informacionLlave.All(e => e != valorString)))
                            {
                                if (esLlave && valorString != "")
                                {
                                    informacionLlave.Add(valorString);
                                }

                                if (error == "")
                                {
                                    ObtenerValorCampo(valor, campo, datos, ref error);
                                }
                            }
                            else
                            {
                                error = String.Format("El {0}: {1} ya existe", campo["Nombre"], valorString);
                            }

                        }

                        //Archivo Articulos(Productos), contiene la cabecera línea y en la descripción hay saltos de línea.
                        if (sincronizadorId == 9)
                        {
                            var codigoProducto = a.GetString(datos, "CodigoProducto");

                            //Si el código del producto viene vacío segnifica que hubo un salto de líena en la descripción de la línea anterior
                            if (codigoProducto == "")
                            {
                                var descripcionAnterior = listaDatos[lineasProcesadas - 1]["Descripcion"] + " ";
                                listaDatos[lineasProcesadas - 1]["Descripcion"] = descripcionAnterior + lineaNoEspacios;
                                guardarLinea = false;
                            }
                            else
                            {
                                datos["CodigoLinea"] = lineaProducto;
                            }
                        }


                        if (error != "")
                        {
                            lineasConError++;
                            var descripcion = string.Format("Línea {0}. Error: ", linea) + error;
                            GuardarLogError(descripcion, sincronizador);
                        }
                        else if (guardarLinea && !esInicioLineaProducto)
                        {
                            listaDatos.Add(datos);
                            lineasProcesadas++;
                        }

                        if (sincronizadorId == 8)
                        {
                            numLineaProducto++;
                            if (numLineaProducto == 20)
                            {
                                numLineaProducto = 1;
                                esInicioLineaProducto = false;
                            }
                        }
                    }//Encuentra el inicio de la línea (si el incicio de línea trae "-", la siguiente línea trae información) 
                    //o si la línea trae el código del producto.
                    else if (inicioLinea == "-" || esLineaCodigoProducto)
                    {
                        esLineaCampo = true;
                    }
                }
            }
            catch (Exception ex)
            {
                var descripcion = string.Format("Línea {0}; error: ", linea) + ex.Message;
                GuardarLogError(descripcion, null, ex.StackTrace);
            }

            GuardarDatos(listaDatos, sincronizador, lineasConError);
        }

        public static void GuardarDatos(List<Dictionary<string, object>> listaDatos, Dictionary<string, object> sincronizador,
            int lineasConError)
        {
            var a = new LogicAccess();
            var sincronizadorId = a.GetInt(sincronizador, "SincronizadorId");

            var xmlElements = new XElement("root",
                listaDatos.Select(e =>
                    new XElement("row",
                        e.Select(kv => new XElement(kv.Key, kv.Value)))
                )
            );

            var data = new Dictionary<string, object>();
            data["XmlData"] = xmlElements.ToString();
            data["AuditUserId"] = sincronizador["AuditUserId"];
            data["NamePcMod"] = sincronizador["NamePcMod"];
            data["EsCierreMes"] = sincronizadorId == 11;
            data["EsAsignacionAnalista"] = sincronizadorId == 16;
            data["TipoCambio"] = sincronizador["TipoCambio"];
            //using (TransactionScope scope = new TransactionScope())
            //{
            //    a.ExecuteNonQuery(sincronizador["StoreProcedure"].ToString(), data);
            //    scope.Complete();
            //}

            a.ExecuteNonQuery(sincronizador["StoreProcedure"].ToString(), data);

            var error = lineasConError == 0 ? "" : string.Format("; Error: {0} registros", lineasConError);
            sincronizador["Descripcion"] = string.Format("Ok, {0} registros", listaDatos.Count) + error;
            a.ExecuteNonQuery("Log_Sincronizador_I", sincronizador);

            sincronizador["Resultado"] = sincronizador["Descripcion"];
            a.ExecuteNonQuery("Sincronizador_U", sincronizador);
        }

        private static void ObtenerValorCampo(object valor, Dictionary<string, object> campo,
            Dictionary<string, object> datos, ref string error)
        {
            var a = new LogicAccess();
            var nombreCampo = campo["Campo"].ToString();
            var tipoDato = campo["TipoDato"].ToString();

            var valorString = a.GetString(valor);
            if (tipoDato != "" && (valorString != "" || tipoDato == "decimal"))
            {
                switch (tipoDato)
                {
                    case "int":
                        valor = a.GetInt(valor, ref error);
                        break;
                    case "decimal":
                        valor = valorString == "" ? 0 : a.GetDecimal(valor, ref error);
                        break;
                    case "date":
                        if (valorString != "?")
                        {
                            valor = campo.ContainsKey("Formato")
                                ? a.GetDate(valor, ref error, campo["Formato"].ToString())
                                : a.GetDate(valor, ref error);
                        }
                        else
                        {
                            valorString = null;
                        }
                        break;
                    case "stringToBool":
                        valor = a.GetBoolFromString(valor, "yes", ref error);
                        break;
                    case "time":
                        //Se agregan por separado la hora el minuto y el segundoa los datos.
                        var valorSplit = valorString.Split(':');
                        if (valorSplit.Count() == 3)
                        {
                            datos["Hora"] = valorSplit[0].Trim();
                            datos["Minuto"] = valorSplit[1].Trim();
                            datos["Segundo"] = valorSplit[2].Trim();
                        }

                        valorString = null;
                        break;
                }
            }

            if (valorString != null)
            {
                datos[nombreCampo] = valor;
            }
        }

        public static void GuardarLogError(string descripcion, Dictionary<string, object> data = null,
            string stacktrace = "")
        {
            try
            {
                var a = new LogicAccess();
                data = data ?? new Dictionary<string, object>();

                if (Sincronizador != "")
                {
                    data["SincronizadorId"] = Sincronizador;
                }

                data["NamePcMod"] = NamePcMod;
                data["AuditUserId"] = AuditUserId;
                data["Descripcion"] = descripcion;
                data["Stacktrace"] = stacktrace;
                a.ExecuteNonQuery("Log_SincronizadorError_I", data);

                data["Resultado"] = descripcion;
                a.ExecuteNonQuery("Sincronizador_U", data);
            }
            catch
            {
                // ignored
            }
        }

        private const string Cliente = @"[{'Campo': 'CodigoCliente', 'Posicion': '0', 'TipoDato': ''},
	                            {'Campo': 'NombreCliente', 'Posicion': '1', 'TipoDato': ''},
	                            {'Campo': 'CobrA', 'Posicion': '2', 'TipoDato': ''},
	                            {'Campo': 'Rfc', 'Posicion': '3', 'TipoDato': ''},
	                            {'Campo': 'LimiteCredito', 'Posicion': '4', 'TipoDato': 'decimal'},
	                            {'Campo': 'TerminosCredito', 'Posicion': '5', 'TipoDato': ''},
	                            {'Campo': 'VendedorId', 'Posicion': '6', 'TipoDato': ''},
	                            {'Campo': 'CanalId', 'Posicion': '7', 'TipoDato': 'int'},
	                            {'Campo': 'ListaPrecios', 'Posicion': '8', 'TipoDato': ''},
	                            {'Campo': 'ZonaImpuestos', 'Posicion': '9', 'TipoDato': ''},
	                            {'Campo': 'ClaseImpuestos', 'Posicion': '10', 'TipoDato': ''},
	                            {'Campo': 'UsoImpuestos', 'Posicion': '11', 'TipoDato': ''},
	                            {'Campo': 'RelacionComercial', 'Posicion': '12', 'TipoDato': ''},
	                            {'Campo': 'Direccion1', 'Posicion': '13', 'TipoDato': ''},
	                            {'Campo': 'Direccion2', 'Posicion': '14', 'TipoDato': ''},
	                            {'Campo': 'Direccion3', 'Posicion': '15', 'TipoDato': ''},
	                            {'Campo': 'Municipio', 'Posicion': '16', 'TipoDato': ''},
	                            {'Campo': 'Ciudad', 'Posicion': '17', 'TipoDato': ''},
	                            {'Campo': 'CodigoPostal', 'Posicion': '18', 'TipoDato': ''},
	                            {'Campo': 'Estado', 'Posicion': '19', 'TipoDato': ''},
	                            {'Campo': 'Pais', 'Posicion': '20', 'TipoDato': ''},
	                            {'Campo': 'Moneda', 'Posicion': '21', 'TipoDato': ''},
	                            {'Campo': 'NoIdentificador', 'Posicion': '22', 'TipoDato': ''},
	                            {'Campo': 'Active', 'Posicion': '23', 'TipoDato': 'stringToBool'},
	                            {'Campo': 'RetencionCredito', 'Posicion': '24', 'TipoDato': 'stringToBool'},
	                            {'Campo': 'CuentaLmClientes', 'Posicion': '25', 'TipoDato': ''},
                                {'Campo': 'CuentaLmVentas', 'Posicion': '26', 'TipoDato': ''},
	                            {'Campo': 'Gravables', 'Posicion': '27', 'TipoDato': 'stringToBool'},
	                            {'Campo': 'UltimaVenta', 'Posicion': '28', 'TipoDato': 'date', 'Formato':'MM/dd/yy'},
	                            {'Campo': 'Observaciones', 'Posicion': '29', 'TipoDato': ''},
	                            {'Campo': 'Almacen', 'Posicion': '30', 'TipoDato': ''}]";

        private const string Vendedor = @"[{'Campo': 'CodigoJefe', 'Posicion': '0', 'TipoDato': ''},
	                            {'Campo': 'CodigoVendedor', 'Posicion': '2', 'TipoDato': ''},
	                            {'Campo': 'NombreVendedor', 'Posicion': '3', 'TipoDato': ''}]";

        private const string CentroCostos = @"[{'Campo': 'GrupoPresupuesto', 'Posicion': '0', 'TipoDato': ''},
	                            {'Campo': 'MascaraCentroCosto', 'Posicion': '1', 'TipoDato': ''},
	                            {'Campo': 'NombreCentroCosto', 'Posicion': '2', 'TipoDato': ''},
	                            {'Campo': 'DescripcionCentroCosto', 'Posicion': '3', 'TipoDato': ''},
	                            {'Campo': 'Activo', 'Posicion': '4', 'TipoDato': 'stringToBool'},
	                            {'Campo': 'RecuperarEstructuraLm', 'Posicion': '5', 'TipoDato': 'stringToBool'},
	                            {'Campo': 'Saf', 'Posicion': '6', 'TipoDato': 'stringToBool'},
	                            {'Campo': 'SafFijadoFecha', 'Posicion': '7', 'TipoDato': 'stringToBool'},
	                            {'Campo': 'FechaModificacion', 'Posicion': '8', 'TipoDato': 'date', 'Formato': 'MM/dd/yyyy'},
	                            {'Campo': 'HoraModificacon', 'Posicion': '9', 'TipoDato': 'time'},
	                            {'Campo': 'UsuarioModificacion', 'Posicion': '10', 'TipoDato': ''},
	                            {'Campo': 'CodigoPerfil', 'Posicion': '11', 'TipoDato': ''},
	                            {'Campo': 'SafFijadoPor', 'Posicion': '12', 'TipoDato': 'stringToBool'},
	                            {'Campo': 'UsuarioResponsable', 'Posicion': '13', 'TipoDato': ''}]";

        private const string CuentaContable = @"[{'Campo': 'CuentaLm', 'Posicion': '0', 'TipoDato': ''},
	                            {'Campo': 'DescripcionCuentaContable', 'Posicion': '1', 'TipoDato': ''},
                                {'Campo': 'NombreCuentaContable', 'Posicion': '1', 'TipoDato': ''},
	                            {'Campo': 'TipoLm', 'Posicion': '2', 'TipoDato': ''},
	                            {'Campo': 'Subcuenta', 'Posicion': '3', 'TipoDato': 'stringToBool'},
	                            {'Campo': 'CuentaCentroCostos', 'Posicion': '4', 'TipoDato': 'stringToBool'},
	                            {'Campo': 'UsarApv', 'Posicion': '5', 'TipoDato': 'stringToBool'},
	                            {'Campo': 'Activo', 'Posicion': '6', 'TipoDato': 'stringToBool'}]";

        private const string Subcuenta = @"[{'Campo': 'GrupoPresupuesto', 'Posicion': '0', 'TipoDato': ''},
	                            {'Campo': 'MascaraSubcuenta', 'Posicion': '1', 'TipoDato': ''},
	                            {'Campo': 'Subcuenta', 'Posicion': '2', 'TipoDato': ''},
	                            {'Campo': 'Descripcion', 'Posicion': '3', 'TipoDato': ''},
	                            {'Campo': 'Active', 'Posicion': '4', 'TipoDato': 'stringToBool'},
	                            {'Campo': 'FechaModificacion', 'Posicion': '5', 'TipoDato': 'date', 'Formato': 'MM/dd/yyyy'},
	                            {'Campo': 'HoraModificacon', 'Posicion': '6', 'TipoDato': 'time'},
	                            {'Campo': 'UsuarioModificacion', 'Posicion': '7', 'TipoDato': ''}]";

        private const string Devolucion = @"[{'Campo': 'Referencia', 'Posicion': '0', 'Longitud':'25', 'TipoDato': ''},
	                            {'Campo': 'Dir', 'Posicion': '26', 'Longitud':'8', 'TipoDato': ''},
	                            {'Campo': 'Nombre', 'Posicion': '35', 'Longitud':'36', 'TipoDato': ''},
	                            {'Campo': 'Vendedor1', 'Posicion': '72', 'Longitud':'8', 'TipoDato': ''},
	                            {'Campo': 'Fecha', 'Posicion': '81', 'Longitud':'8', 'TipoDato': 'date', 'Formato':'MM/dd/yy'},
	                            {'Campo': 'Monto', 'Posicion': '90', 'Longitud':'16', 'TipoDato': 'decimal'},
	                            {'Campo': 'Causal', 'Posicion': '107', 'Longitud':'8', 'TipoDato': ''},
	                            {'Campo': 'Descripcion', 'Posicion': '116', 'Longitud':'30', 'TipoDato': ''},
	                            {'Campo': 'CodigoFactura', 'Posicion': '147', 'Longitud':'25', 'TipoDato': ''},
	                            {'Campo': 'Cliente', 'Posicion': '173', 'Longitud':'11', 'TipoDato': ''},
	                            {'Campo': 'Bodega', 'Posicion': '185', 'Longitud':'10', 'TipoDato': ''},
                                {'Campo': 'Pedido', 'Posicion': '196', 'Longitud':'8', 'TipoDato': ''},
	                            {'Campo': 'MontoAbierto', 'Posicion': '205', 'Longitud':'14', 'TipoDato': 'decimal'}]";

        private const string FacturaProducto = @"[{'Campo': 'Cliente', 'Posicion': '40', 'Longitud':'8', 'TipoDato': ''},
                                {'Campo': 'CobrarA', 'Posicion': '0', 'Longitud':'8', 'TipoDato': ''},
	                            {'Campo': 'CodigoFactura', 'Posicion': '80', 'Longitud':'22', 'TipoDato': ''},
	                            {'Campo': 'FechaFactura', 'Posicion': '106', 'Longitud':'10', 'TipoDato': 'date', 'Formato':'MM/dd/yyyy'},
	                            {'Campo': 'CodigoProducto', 'Posicion': '126', 'Longitud':'8', 'TipoDato': ''},
	                            {'Campo': 'Cantidad', 'Posicion': '170', 'Longitud':'14', 'TipoDato': 'decimal'},
                                {'Campo': 'Unidad', 'Posicion': '185', 'Longitud':'2', 'TipoDato': ''},
                                {'Campo': 'Subtotal', 'Posicion': '188', 'Longitud':'23', 'TipoDato': 'decimal'},
	                            {'Campo': 'Iva', 'Posicion': '212', 'Longitud':'15', 'TipoDato': 'decimal'},
                                {'Campo': 'Ieps', 'Posicion': '228', 'Longitud':'15', 'TipoDato': 'decimal'},
	                            {'Campo': 'Importe', 'Posicion': '244', 'Longitud':'23', 'TipoDato': 'decimal'}]";

        private const string LineaProducto = @"[{'Campo': 'CodigoLinea','Linea': '1', 'Posicion': '13', 'Longitud':'5', 'TipoDato': ''},
	                            {'Campo': 'Descripcion','Linea': '1', 'Posicion': '32', 'Longitud':'8', 'TipoDato': '', 'EsUltimoCampo': 'true'},
	                            {'Campo': 'CuentaInventario','Linea': '2', 'Posicion': '20', 'Longitud':'6', 'TipoDato': ''},
	                            {'Campo': 'Subcuenta','Linea': '2', 'Posicion': '29', 'Longitud':'3', 'TipoDato': ''},
	                            {'Campo': 'CtaDiscrInventario','Linea': '2', 'Posicion': '65', 'Longitud':'6', 'TipoDato': ''},
	                            {'Campo': 'CuentaDesperdicio','Linea': '2', 'Posicion': '108', 'Longitud':'6', 'TipoDato': ''},
	                            {'Campo': 'Revaluado','Linea': '3', 'Posicion': '20', 'Longitud':'6', 'TipoDato': ''},
	                            {'Campo': 'CuentaVentas','Linea': '5', 'Posicion': '20', 'Longitud':'6', 'TipoDato': ''},
	                            {'Campo': 'CuentaDescVentas','Linea': '5', 'Posicion': '65', 'Longitud':'6', 'TipoDato': ''},
	                            {'Campo': 'MaterialCdv','Linea': '6', 'Posicion': '20', 'Longitud':'6', 'TipoDato': ''},
	                            {'Campo': 'CuentaMoCdv','Linea': '6', 'Posicion': '65', 'Longitud':'6', 'TipoDato': ''},
                                {'Campo': 'CuentaIndVarCdv','Linea': '6', 'Posicion': '108', 'Longitud':'6', 'TipoDato': ''},
                                {'Campo': 'IndFijoCdv','Linea': '7', 'Posicion': '20', 'Longitud':'6', 'TipoDato': ''},
	                            {'Campo': 'SubcontratoCdv','Linea': '7', 'Posicion': '65', 'Longitud':'6', 'TipoDato': ''},
	                            {'Campo': 'CuentaCompras','Linea': '9', 'Posicion': '20', 'Longitud':'6', 'TipoDato': ''},
	                            {'Campo': 'CuentaRecepcion','Linea': '9', 'Posicion': '65', 'Longitud':'6', 'TipoDato': ''},
	                            {'Campo': 'CuentaAplIndFijo','Linea': '9', 'Posicion': '108', 'Longitud':'6', 'TipoDato': ''},
                                {'Campo': 'CodigoCentroCosto','Linea': '9', 'Posicion': '126', 'Longitud':'4', 'TipoDato': ''},
	                            {'Campo': 'CuentaVarPrecioOc','Linea': '10', 'Posicion': '20', 'Longitud':'6', 'TipoDato': ''},
	                            {'Campo': 'CuentaVarUsoCp','Linea': '10', 'Posicion': '65', 'Longitud':'6', 'TipoDato': ''},
                                {'Campo': 'CtaTasaVarCp','Linea': '10', 'Posicion': '108', 'Longitud':'6', 'TipoDato': ''},
	                            {'Campo': 'CuentaPiso','Linea': '12', 'Posicion': '20', 'Longitud':'6', 'TipoDato': ''},
	                            {'Campo': 'VarUsoMatl','Linea': '12', 'Posicion': '65', 'Longitud':'6', 'TipoDato': ''},
	                            {'Campo': 'VarTarifaMtl','Linea': '12', 'Posicion': '108', 'Longitud':'6', 'TipoDato': ''},
                                {'Campo': 'CostoProduccion','Linea': '13', 'Posicion': '20', 'Longitud':'6', 'TipoDato': ''},
                                {'Campo': 'VarUsoSbcon','Linea': '13', 'Posicion': '65', 'Longitud':'6', 'TipoDato': ''},
	                            {'Campo': 'TarifaSub','Linea': '13', 'Posicion': '108', 'Longitud':'6', 'TipoDato': ''},
	                            {'Campo': 'VariacionMez','Linea': '14', 'Posicion': '20', 'Longitud':'6', 'TipoDato': ''},
                                {'Campo': 'CuentaWip','Linea': '14', 'Posicion': '65', 'Longitud':'6', 'TipoDato': ''},
                                {'Campo': 'CtaVarMetodo','Linea': '14', 'Posicion': '108', 'Longitud':'6', 'TipoDato': ''},
	                            {'Campo': 'MoServicio','Linea': '16', 'Posicion': '20', 'Longitud':'6', 'TipoDato': ''},
	                            {'Campo': 'DevolucionServicio','Linea': '16', 'Posicion': '65', 'Longitud':'6', 'TipoDato': ''},
	                            {'Campo': 'IndFijoServicio','Linea': '17', 'Posicion': '20', 'Longitud':'6', 'TipoDato': ''},
	                            {'Campo': 'GastoDebeEmpleado','Linea': '17', 'Posicion': '65', 'Longitud':'6', 'TipoDato': ''},
	                            {'Campo': 'GastoServicio','Linea': '18', 'Posicion': '20', 'Longitud':'6', 'TipoDato': ''},
	                            {'Campo': 'IngresoDiferido','Linea': '18', 'Posicion': '65', 'Longitud':'6', 'TipoDato': ''},
	                            {'Campo': 'Devengado','Linea': '19', 'Posicion': '20', 'Longitud':'6', 'TipoDato': ''}]";

        private const string Articulo = @"[{'Campo': 'CodigoProducto', 'Posicion': '0', 'Longitud':'18', 'TipoDato': '', 'EsLlave': 'true', 'Nombre': 'Número Articulo'},
	                            {'Campo': 'Descripcion', 'Posicion': '19', 'Longitud':'24', 'TipoDato': ''},
	                            {'Campo': 'Um', 'Posicion': '44', 'Longitud':'2', 'TipoDato': ''},
	                            {'Campo': 'Revi', 'Posicion': '47', 'Longitud':'4', 'TipoDato': ''},
	                            {'Campo': 'Categoria', 'Posicion': '52', 'Longitud':'18', 'TipoDato': ''},
	                            {'Campo': 'Grupo', 'Posicion': '71', 'Longitud':'8', 'TipoDato': ''},
	                            {'Campo': 'Tipo', 'Posicion': '80', 'Longitud':'8', 'TipoDato': ''},
	                            {'Campo': 'Estado', 'Posicion': '89', 'Longitud':'8', 'TipoDato': ''},
	                            {'Campo': 'Fecha', 'Posicion': '98', 'Longitud':'8', 'TipoDato': 'date', 'Formato':'MM/dd/yy'},
	                            {'Campo': 'GrupoDiseño', 'Posicion': '107', 'Longitud':'8', 'TipoDato': ''},
	                            {'Campo': 'Ubicacion', 'Posicion': '116', 'Longitud':'8', 'TipoDato': ''},
	                            {'Campo': 'Tamanio', 'Posicion': '125', 'Longitud':'4', 'TipoDato': ''}]";

        private const string Cartera = @"[{'Campo': 'Referencia', 'Posicion': '0', 'Longitud':'25', 'TipoDato': ''},
                                {'Campo': 'CobrarA', 'Posicion': '26', 'Longitud':'8', 'TipoDato': ''},
	                            {'Campo': 'Tipo', 'Posicion': '35', 'Longitud':'2', 'TipoDato': ''},
	                            {'Campo': 'Fecha', 'Posicion': '37', 'Longitud':'8', 'TipoDato': 'date', 'Formato':'MM/dd/yy'},
	                            {'Campo': 'FechaVencimiento', 'Posicion': '46', 'Longitud':'10', 'TipoDato': 'date', 'Formato':'MM/dd/yyyy'},
	                            {'Campo': 'DiasVencimiento', 'Posicion': '57', 'Longitud':'9', 'TipoDato': ''},
	                            {'Campo': 'Monto', 'Posicion': '66', 'Longitud':'18', 'TipoDato': 'decimal'},
                                {'Campo': 'RangoUno', 'Posicion': '86', 'Longitud':'18', 'TipoDato': 'decimal'},
                                {'Campo': 'RangoDos', 'Posicion': '105', 'Longitud':'18', 'TipoDato': 'decimal'},
                                {'Campo': 'RangoTres', 'Posicion': '124', 'Longitud':'18', 'TipoDato': 'decimal'},
                                {'Campo': 'RangoCuatro', 'Posicion': '143', 'Longitud':'18', 'TipoDato': 'decimal'},
                                {'Campo': 'RangoCinco', 'Posicion': '162', 'Longitud':'18', 'TipoDato': 'decimal'},
                                {'Campo': 'TotalMonto', 'Posicion': '181', 'Longitud':'19', 'TipoDato': 'decimal'},
	                            {'Campo': 'Descripcion', 'Posicion': '201', 'Longitud':'40', 'TipoDato': ''}]";

        private const string Pago = @"[{'Campo': 'DocumentoId', 'Posicion': '0', 'Longitud':'26', 'TipoDato': ''},
                                {'Campo': 'ClienteId', 'Posicion': '27', 'Longitud':'9', 'TipoDato': ''},
	                            {'Campo': 'Entidad', 'Posicion': '73', 'Longitud':'6', 'TipoDato': ''},
	                            {'Campo': 'Fecha', 'Posicion': '82', 'Longitud':'10', 'TipoDato': 'date', 'Formato':'MM/dd/yyyy'},
	                            {'Campo': 'FechaEfectiva', 'Posicion': '93', 'Longitud':'10', 'TipoDato': 'date', 'Formato':'MM/dd/yyyy'},
	                            {'Campo': 'Monto', 'Posicion': '114', 'Longitud':'18', 'TipoDato': 'decimal'},
                                {'Campo': 'Cuenta', 'Posicion': '133', 'Longitud':'8', 'TipoDato': ''},
                                {'Campo': 'Banco', 'Posicion': '142', 'Longitud':'12', 'TipoDato': ''}]";

        private const string RegistroQad = @"[{'Campo': 'FolioTpm', 'Posicion': '9', 'TipoDato': ''},
	                            {'Campo': 'CodigoQad', 'Posicion': '29', 'TipoDato': ''}]";

        private const string CancelacionPago = @"[{'Campo': 'CuentaLm', 'Posicion': '0', 'TipoDato': ''},
	                            {'Campo': 'Comprobante', 'Posicion': '2', 'TipoDato': 'int'},
	                            {'Campo': 'ReferenciaFacturaExterna', 'Posicion': '21', 'TipoDato': ''},
                                {'Campo': 'RelacionComercial', 'Posicion': '34', 'TipoDato': ''},
                                {'Campo': 'Monto', 'Posicion': '37', 'TipoDato': 'decimal'},
	                            {'Campo': 'FechaRegistro', 'Posicion': '40', 'TipoDato': 'date', 'Formato':'MM/dd/yyyy'}]";

        private const string Trazabilidad = @"[{'Campo': 'Pedido', 'Posicion': '0', 'Longitud':'8', 'TipoDato': ''},
                                {'Campo': 'FacturaId', 'Posicion': '124', 'Longitud':'25', 'TipoDato': ''},
	                            {'Campo': 'FechaRecibo', 'Posicion': '247', 'Longitud':'11', 'TipoDato': 'date', 'Formato':'MM/dd/yyyy'}]";

        private const string AsignacionAnalistaCliente = @"[{'Campo': 'CodigoCliente', 'Posicion': '0', 'TipoDato': ''},
	                            {'Campo': 'AnalistaId', 'Posicion': '1', 'TipoDato': 'int'}]";

        private const string ListaPrecio = @"[{'Campo': 'Negocio', 'Posicion': '5', 'TipoDato': ''},
	                            {'Campo': 'Marca', 'Posicion': '6', 'TipoDato': ''},
                                {'Campo': 'Referencia', 'Posicion': '7', 'TipoDato': ''},
	                            {'Campo': 'Canal', 'Posicion': '10', 'TipoDato': ''},
	                            {'Campo': 'Subcanal', 'Posicion': '11', 'TipoDato': ''},
	                            {'Campo': 'PorcentajeMargen', 'Posicion': '12', 'TipoDato': 'decimal'},
	                            {'Campo': 'C', 'Posicion': '13', 'TipoDato': ''},
	                            {'Campo': 'PvpName', 'Posicion': '14', 'TipoDato': ''},
	                            {'Campo': 'PvpEntrada', 'Posicion': '15', 'TipoDato': 'decimal'},
	                            {'Campo': 'PrecioUnidadIva', 'Posicion': '16', 'TipoDato': 'decimal'},
	                            {'Campo': 'PrecioUnidadIeps', 'Posicion': '17', 'TipoDato': 'decimal'},
	                            {'Campo': 'PrecioUnidad', 'Posicion': '18', 'TipoDato': 'decimal'},
	                            {'Campo': 'PrecioDisplayIva', 'Posicion': '20', 'TipoDato': 'decimal'},
	                            {'Campo': 'PrecioDisplayIeps', 'Posicion': '21', 'TipoDato': 'decimal'},
	                            {'Campo': 'PrecioDisplay', 'Posicion': '22', 'TipoDato': 'decimal'},
	                            {'Campo': 'PrecioCajaIva', 'Posicion': '23', 'TipoDato': 'decimal'},
	                            {'Campo': 'PrecioCajaIeps', 'Posicion': '24', 'TipoDato': 'decimal'},
	                            {'Campo': 'PrecioCaja', 'Posicion': '25', 'TipoDato': 'decimal'},
	                            {'Campo': 'Flag', 'Posicion': '27', 'TipoDato': ''},
                                {'Campo': 'FechaCreacion', 'Posicion': '28', 'TipoDato': 'date'},
                                {'Campo': 'FechaModificacion', 'Posicion': '29', 'TipoDato': 'date'},
                                {'Campo': 'FechaInicio', 'Posicion': '30', 'TipoDato': 'date'},
	                            {'Campo': 'Iva', 'Posicion': '38', 'TipoDato': 'decimal'},
	                            {'Campo': 'TasaIepsPorLitro', 'Posicion': '39', 'TipoDato': 'decimal'},
	                            {'Campo': 'IepsCafeina', 'Posicion': '40', 'TipoDato': 'decimal'},
	                            {'Campo': 'Active', 'Posicion': '19', 'TipoDato': 'bool'}]";

        private const string ProductoActivity = @"[{'Campo': 'Nombre', 'Posicion': '4', 'TipoDato': ''},
	                            {'Campo': 'Codigo', 'Posicion': '5', 'TipoDato': ''},
                                {'Campo': 'Marca', 'Posicion': '2', 'TipoDato': ''},
	                            {'Campo': 'Referencia', 'Posicion': '3', 'TipoDato': ''},
	                            {'Campo': 'UpcPieza', 'Posicion': '6', 'TipoDato': ''},
	                            {'Campo': 'UpcCaja', 'Posicion': '7', 'TipoDato': ''},
	                            {'Campo': 'UpcDisplay', 'Posicion': '8', 'TipoDato': ''},
	                            {'Campo': 'UpcPallet', 'Posicion': '9', 'TipoDato': ''},
	                            {'Campo': 'Grupo', 'Posicion': '10', 'TipoDato': ''},
	                            {'Campo': 'Linea', 'Posicion': '12', 'TipoDato': ''},
	                            {'Campo': 'FactorConversion', 'Posicion': '14', 'TipoDato': 'decimal'},
	                            {'Campo': 'DisplayPorCaja', 'Posicion': '15', 'TipoDato': 'int'},
	                            {'Campo': 'UnidadPorCaja', 'Posicion': '16', 'TipoDato': 'int'},
	                            {'Campo': 'UnidadPorDisplay', 'Posicion': '17', 'TipoDato': 'int'},
	                            {'Campo': 'Contenido', 'Posicion': '18', 'TipoDato': 'decimal'},
	                            {'Campo': 'Densidad', 'Posicion': '19', 'TipoDato': 'decimal'},
	                            {'Campo': 'UsoImpuestoMagna', 'Posicion': '20', 'TipoDato': ''},
	                            {'Campo': 'UsoImpuestoComex', 'Posicion': '21', 'TipoDato': ''},
	                            {'Campo': 'ActiveString', 'Posicion': '22', 'TipoDato': ''},
	                            {'Campo': 'Subcuenta', 'Posicion': '24', 'TipoDato': ''},
	                            {'Campo': 'Planeador', 'Posicion': '25', 'TipoDato': ''}]";

        private const string Proyecto = @"[
                                         {'Campo': 'Proyecto', 'Posicion': '6', 'TipoDato': ''},
                                         {'Campo': 'Descripcion', 'Posicion': '8', 'TipoDato': ''},
                                         {'Campo': 'MascaraProyecto', 'Posicion': '4', 'TipoDato': ''},
                                         {'Campo': 'CodigoGrupoProyecto', 'Posicion': '10', 'TipoDato': ''},
                                         {'Campo': 'RecuperarEstructuraLM', 'Posicion': '11', 'TipoDato': ''},
                                         {'Campo': 'SAF', 'Posicion': '12', 'TipoDato': ''},
                                         {'Campo': 'FechaFinalizaOrigProyecto', 'Posicion': '13', 'TipoDato': 'date', 'Formato':'dd/MM/yyyy'},
                                         {'Campo': 'FechaInicio', 'Posicion': '16', 'TipoDato': 'date', 'Formato':'dd/MM/yyyy'},
                                         {'Campo': 'CodigoEstado', 'Posicion': '17', 'TipoDato': ''},
                                         {'Campo': 'EstadoSistema', 'Posicion': '18', 'TipoDato': ''},
                                         {'Campo': 'Comentarios', 'Posicion': '0', 'TipoDato': ''}
                                         ]";

        private const string ArtículosActivity = @"[
                                                   {'Campo': 'NumArticulo', 'Posicion': '0', 'TipoDato': ''},
                                                   {'Campo': 'Nombre', 'Posicion': '1', 'TipoDato': ''},
                                                   {'Campo': 'Descripcion', 'Posicion': '2', 'TipoDato': ''},
                                                   {'Campo': 'Almacen', 'Posicion': '3', 'TipoDato': ''},
                                                   {'Campo': 'UnidadMedida', 'Posicion': '4', 'TipoDato': ''},
                                                   {'Campo': 'LineaProductos', 'Posicion': '5', 'TipoDato': 'int'},
                                                   {'Campo': 'TipoArticulo', 'Posicion': '6', 'TipoDato': ''},
                                                   {'Campo': 'Estado', 'Posicion': '8', 'TipoDato': ''},
                                                   {'Campo': 'Comprador', 'Posicion': '9', 'TipoDato': ''},
                                                   {'Campo': 'TiposATPForzado', 'Posicion': '15', 'TipoDato': ''},
                                                   {'Campo': 'RestriccionADDSO', 'Posicion': '16', 'TipoDato': ''}
                                                   ]";

        private const string Proveedor = @"[
                                             {'Campo': 'Nombre', 'Posicion': '2', 'TipoDato': ''},
                                             {'Campo': 'CodigoQad', 'Posicion': '0', 'TipoDato': ''},
                                             {'Campo': 'CodRelacionComercial', 'Posicion': '1', 'TipoDato': ''},
                                             {'Campo': 'Direccion', 'Posicion': '3', 'TipoDato': ''},
                                             {'Campo': 'CodigoPostal', 'Posicion': '4', 'TipoDato': ''},
                                             {'Campo': 'Ciudad', 'Posicion': '5', 'TipoDato': ''},
                                             {'Campo': 'Condado', 'Posicion': '6', 'TipoDato': ''},
                                             {'Campo': 'Estado', 'Posicion': '7', 'TipoDato': ''},
                                             {'Campo': 'Pais', 'Posicion': '8', 'TipoDato': ''},
                                             {'Campo': 'ImpuestoFederal', 'Posicion': '9', 'TipoDato': ''},
                                             {'Campo': 'ImpuestoEstatal', 'Posicion': '10', 'TipoDato': ''},
                                             {'Campo': 'TipoProveedor', 'Posicion': '11', 'TipoDato': ''},
                                             {'Campo': 'PagaCargosBancarios', 'Posicion': '14', 'TipoDato': ''},
                                             {'Campo': 'Activo', 'Posicion': '12', 'TipoDato': ''}
                                         ]";

        private const string Presupuesto = @"[
                                                 {'Campo': 'Rubro', 'Posicion': '0', 'TipoDato': ''},
                                                 {'Campo': 'CuentaLm', 'Posicion': '1', 'TipoDato': ''},
                                                 {'Campo': 'NombreCuentaContable', 'Posicion': '2', 'TipoDato': ''}
                                             ]";

        private const string MatrizPOP = @"[
                                                 {'Campo': 'Descripcion', 'Posicion': '2', 'TipoDato': ''},
                                                 {'Campo': 'RangoInicial', 'Posicion': '24', 'TipoDato': ''},
                                                 {'Campo': 'RangoFinal', 'Posicion': '25', 'TipoDato': ''},
                                                 {'Campo': 'Proveedor', 'Posicion': '26', 'TipoDato': ''},
                                                 {'Campo': 'Precio', 'Posicion': '27', 'TipoDato': ''},
                                                 {'Campo': 'Articulo', 'Posicion': '28', 'TipoDato': ''},
                                                 {'Campo': 'CodigoProveedor', 'Posicion': '29', 'TipoDato': ''}
                                             ]";

        private const string MatrizDiasFestivos = @"[
                                                 {'Campo': 'Dia', 'Posicion': '1', 'TipoDato': ''},
                                                 {'Campo': 'Mes', 'Posicion': '2', 'TipoDato': ''},
                                                 {'Campo': 'Anio', 'Posicion': '3', 'TipoDato': ''},
                                                 {'Campo': 'NombreDia', 'Posicion': '4', 'TipoDato': ''}
                                             ]";

    }
}