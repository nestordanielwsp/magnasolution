using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Script.Serialization;
using System.Xml.Linq;
using Infraestructura.Archivos;
using logic;
using OfficeOpenXml;

namespace magnajs.Codes
{
    /// <summary>
    /// Summary description for UploadExcelFile
    /// </summary>
    public class UploadExcelFile : IHttpHandler, System.Web.SessionState.IRequiresSessionState
    {
        List<string> listCanalIDs = new List<string>();
        bool esPromocionArmada = false;
        bool esExtemporanea = false;
        string almacenesCanal = string.Empty;
        string alamacenesalmacenesCanalBD = string.Empty;
        string marcaExcel = string.Empty;

        string errorRefresh = string.Empty;

        public void ProcessRequest(HttpContext context)
        {
            var datos = new Dictionary<string, object>();
            var error = "";
            var activityId = 0;
            var promocionId = 0;
            var storage = new AlmacenamientoAzureServicio();
            var sessionName = string.Empty;

            try
            {
                context.Response.ContentType = "text/html";
                HttpPostedFile archivo = context.Request.Files[0];
            
                var datosExcel = new ExcelPackage(archivo.InputStream);
                ExcelWorksheet ws = datosExcel.Workbook.Worksheets[1];
                sessionName = context.Request["SessionName"];
                var marca = (context.Request["Marca"] != null ? context.Request["Marca"].Trim() : "");
                var existeCodigoPromocion = context.Request["ExisteCodigoPromocion"];

                if (sessionName == "EstructuraComercial")
                {
                    if (context.Request["CodigoPromocion"] == null || context.Request["CodigoPromocion"] == "undefined" || context.Request["CodigoPromocion"].ToString() == "")
                        error = "\nFavor de capturar el Código de Promoción";
                    else if (existeCodigoPromocion == "0")
                        error = "\nPrimero debe buscar el Código de Promoción capturado";
                    else
                        error = CargarEstructuraComercial(ws, datos, marca, true);
                }
                else
                {
                    if ((context.Request["TipoSolicitudId"] != null && context.Request["TipoSolicitudId"] != "undefined") && (context.Request["TipoMovimientoId"] != null && context.Request["TipoMovimientoId"] != "undefined"))
                    {
                        var tipoSolicitud = context.Request["TipoSolicitud"];
                        var tipoSolicitudId = Convert.ToInt16(context.Request["TipoSolicitudId"] != null && context.Request["TipoSolicitudId"] != "undefined" ? context.Request["TipoSolicitudId"] : "0");
                        var tipoMovimiento = context.Request["TipoMovimiento"];
                        var tipoMovimientoId = Convert.ToInt16(context.Request["TipoMovimientoId"] != null && context.Request["TipoMovimientoId"] != "undefined" ? context.Request["TipoMovimientoId"] : "0");
                        //var existeCodigoPromocion = context.Request["ExisteCodigoPromocion"];
                        var loadComercialStructureComplete = context.Request["LoadComercialStructureComplete"] != null && context.Request["LoadComercialStructureComplete"] != "undefined" ? Convert.ToBoolean(context.Request["LoadComercialStructureComplete"]) : false;

                        activityId = Convert.ToInt32(context.Request["ActivityId"]);
                        promocionId = Convert.ToInt32(context.Request["PromocionId"]);

                        datos["IsRefresh"] = context.Request["IsRefresh"] != null ? Convert.ToBoolean(context.Request["IsRefresh"]) : false;

                        if (tipoMovimientoId == 6 && existeCodigoPromocion == "1" && !loadComercialStructureComplete)
                        {
                            error = "Favor de cargar la Estructura Comercial";
                        }
                        else
                        {
                            switch (sessionName)
                            {
                                case "Presupuesto":
                                    var data = new Dictionary<string, object>();
                                    error = CargarPresupuesto(ws, data);
                                    if (error == "")
                                    {
                                        HttpContext.Current.Session[sessionName] = data;
                                    }
                                    break;
                                case "Promocion":

                                    var codigoPromocion = string.Empty;
                                    var esSinCreacion = false;
                                    //Validar el tipo de movimiento cuando no se está intentando cargar una reactivación de un código que no existe
                                    //ExisteCodigoPromocion = 0    
                                    //ExisteCodigoPromocion = 1    No existe codigo de Promocion
                                    //ExisteCodigoPromocion = 2    Existe codigo de Promocion
                                    if (existeCodigoPromocion != "1")
                                        error = ValidarTipoMovimiento(ws, datos, tipoSolicitud, tipoSolicitudId, tipoMovimiento, tipoMovimientoId, existeCodigoPromocion, activityId, promocionId);
                                    else if (tipoMovimientoId == 6 && existeCodigoPromocion == "1" && loadComercialStructureComplete)
                                    {
                                        esSinCreacion = true;
                                        codigoPromocion = context.Request["CodigoPromocion"];
                                        datos["UnidadMedidaProductos"] = context.Request["UnidadMedidaProductos"];
                                        datos["EsSinCreacion"] = esSinCreacion;
                                    }                                    

                                    if (error == "")
                                    {
                                        if (tipoMovimientoId == 1)
                                        {
                                            //Creación
                                            error = CargarPromocion(ws, datos, marca, tipoSolicitud, tipoSolicitudId, tipoMovimiento, tipoMovimientoId, existeCodigoPromocion, activityId);
                                        }

                                        else
                                        {
                                            //Todos excepto Creación
                                            //Información leída del excel
                                            //la info queda en la variable datos
                                            error = CargarPromocionSinValidar(ws, datos, marca, tipoSolicitud, tipoSolicitudId, tipoMovimiento, tipoMovimientoId, existeCodigoPromocion, activityId, esSinCreacion, codigoPromocion);

                                            if (error == "")
                                            {
                                                if (esSinCreacion)
                                                    error = ValidarPromocionReactivacionSinCreacion(ws, datos, activityId, promocionId, tipoMovimientoId, tipoSolicitud, marca, esSinCreacion); //Solo Reactivación cuando el código de promoción no existe
                                                else
                                                    error = ValidarPromocion(ws, datos, activityId, promocionId, tipoMovimientoId, tipoSolicitud, marca, esSinCreacion);    //Solo Ampliación, Actualización de Parámetros, Actualización de Precios, Cierre o Reactivación cuando el código de promoción existe
                                            }

                                        }
                                    }

                                    //if (error == "")
                                    //{
                                    //    //Si no hay problema con la carga del tipo de movimiento, entonces enviar los campos recibidos en la macro y compararlos contra el último ActivityPromocion cargado
                                    //    //Validar si hay cambios en los campos que si deben actualizarse
                                    //    //Validar que no haya cambios en los campos que no deben actualizarse
                                    //    //error = ValidarInformacionPromocion()

                                    //    error = ObtenerDatosPromocion(ws, datos, tipoSolicitud, tipoMovimiento, tipoMovimientoId, existeCodigoPromocion);
                                    //    if (error != "") break;

                                    //    var elementos = new List<Dictionary<string, object>>();
                                    //    error = ObtenerElementosPromocion(ws, elementos, datos, marca);
                                    //    if (error != "") break;

                                    //    var listas = new List<Dictionary<string, object>>();
                                    //    error = ObtenerListasPromocion(ws, listas, datos);
                                    //    if (error != "") break;
                                    //}
                                    break;
                                default:
                                    break;
                            }
                        }
                    }
                    else
                    {
                        error = "Favor de seleccionar el Tipo de Solicitud y el Tipo de Movimiento";
                    }
                }

                //Cada Carga sin errores, almacena el archivo
                if (error == "" && sessionName != "EstructuraComercial")
                {
                    var folder = context.Request["Folder"];
                    var dateDirectory = DateTime.Today.ToString("yyyyMM");
                    var contenedor = ConfigurationManager.AppSettings["CarpetaArchivos"] + folder + "/";

                    var GUID = Guid.NewGuid().ToString().Substring(1, 7) + "_";
                    var nombreArchivo = archivo.FileName;

                    nombreArchivo = GUID + nombreArchivo;

                    var rutaArchivo = dateDirectory + "/" + nombreArchivo;
                    //var rutaArchivo = nombreArchivo;
                    datos["RutaArchivo"] = rutaArchivo;

                    Stream stream = archivo.InputStream;
                    stream.Position = 0;

                    storage.Guardar(stream, contenedor + rutaArchivo);

                }
            }
            catch (Exception ex)
            {
                error = ex.Message;
            }

            datos["Error"] = error.IndexOf("\n") == 0 ? error.Substring(1): error;
            datos["CanalIDs"] = String.Join(",", this.listCanalIDs.ToArray());
            datos["EsExtemporanea"] = this.esExtemporanea;
            datos["TipoAlmacen"] = this.almacenesCanal;

            datos["ErrorRefresh"] = this.errorRefresh;
            
            var json = new JavaScriptSerializer().Serialize(datos);
            context.Response.Write(json);
        }

        private bool ExistenDiferecniasHeader(Dictionary<string, object> datos, int activityId, int promocionId, int tipoMovimientoId, Dictionary<string, object> parmsActivityPromocion) {
            //Get Info from BD
            var parmsActivity = new Dictionary<string, object> { ["ActivityId"] = activityId };
            var activityData = Utilities.GetItem("Activity_SelById", parmsActivity);
            int estatusId = Utilities.GetInt(activityData, "EstatusId");

            List<Dictionary<string, object>> dataPromocion = Utilities.GetData("ActivityPromocion_SelByPromocionId", parmsActivityPromocion);

            string Folio = string.Empty;
            string FechaSolicitud = string.Empty;
            string CodigoPromocion = string.Empty;
            string Nombre = string.Empty;
            string Empresa = string.Empty;
            int TipoMovimientoId = 0;
            int TipoSolicitudId = 0;
            string Marca = string.Empty;
            //string TipoAlmacen = string.Empty;
            string Linea = string.Empty;
            string Grupo = string.Empty;
            string Impuesto = string.Empty;
            string ClaseImpuesto = string.Empty;
            string AlmacenPrincipal = string.Empty;
            string EstatusAdicional = string.Empty;
            string Tipo = string.Empty;
            string Planeador = string.Empty;
            string UnidadMedida = string.Empty;
            string CodigoBarras = string.Empty;
            string UmaCajaDisplay = string.Empty;
            string UmaCajaUnidad = string.Empty;
            int CantidadPromocion = 0;
            bool EsSinCreacion = false;

            foreach (var promocion in dataPromocion)
            {

                Folio = promocion["Folio"].ToString();
                FechaSolicitud = promocion["FechaSolicitud"].ToString();
                CodigoPromocion = promocion["CodigoPromocion"].ToString();
                Nombre = promocion["Nombre"].ToString();
                Empresa = promocion["Empresa"].ToString();
                TipoSolicitudId = Convert.ToInt32(promocion["TipoSolicitudId"]);
                Marca = promocion["Marca"].ToString();
                //TipoAlmacen = promocion["TipoAlmacen"].ToString();
                this.alamacenesalmacenesCanalBD = promocion["TipoAlmacen"].ToString();
                Linea = promocion["Linea"].ToString();
                Grupo = promocion["Grupo"].ToString();
                Impuesto = promocion["Impuesto"].ToString();
                ClaseImpuesto = promocion["ClaseImpuesto"].ToString();
                AlmacenPrincipal = promocion["AlmacenPrincipal"].ToString();
                EstatusAdicional = promocion["EstatusAdicional"].ToString();
                Tipo = promocion["Tipo"].ToString();
                Planeador = promocion["Planeador"].ToString();
                UnidadMedida = promocion["UnidadMedida"].ToString();

                CodigoBarras = promocion["CodigoBarras"].ToString();
                UmaCajaDisplay = promocion["UmaCajaDisplay"].ToString();
                UmaCajaUnidad = promocion["UmaCajaUnidad"].ToString();
                if(tipoMovimientoId == 6 && promocionId == 0)
                    datos["CantidadPromocion"] = Convert.ToInt32(promocion["CantidadPromocion"]);

                EsSinCreacion = Convert.ToBoolean(promocion["EsSinCreacion"].ToString());
            }

            bool existenDiferenciasHeader = false;
            
            //Comparar información principal

            if (
                (
                    (tipoMovimientoId == 2 || tipoMovimientoId == 3 || tipoMovimientoId == 6) &&
                    (
                        Folio != datos["Folio"].ToString() ||
                        //FechaSolicitud != datos["FechaSolicitud"].ToString() ||
                        CodigoPromocion != datos["CodigoPromocion"].ToString() ||
                        Nombre != datos["Nombre"].ToString() ||
                        Empresa != datos["Empresa"].ToString() ||
                        TipoSolicitudId != Convert.ToInt32(datos["TipoSolicitudId"].ToString()) ||
                        Marca != datos["Marca"].ToString()
                    )
                )
                ||
                (
                    tipoMovimientoId == 4 && 
                    (
                        (
                            Folio != datos["Folio"].ToString() ||
                            //FechaSolicitud != datos["FechaSolicitud"].ToString() ||
                            CodigoPromocion != datos["CodigoPromocion"].ToString() ||
                            Nombre != datos["Nombre"].ToString() ||
                            Empresa != datos["Empresa"].ToString() ||
                            TipoSolicitudId != Convert.ToInt32(datos["TipoSolicitudId"].ToString()) ||
                            Marca != datos["Marca"].ToString()
                        )
                        || 

                        (
                            EsSinCreacion || 
                            (
                                !EsSinCreacion && (
                                Linea != datos["Linea"].ToString() ||
                                Grupo != datos["Grupo"].ToString() ||
                                Impuesto != datos["Impuesto"].ToString() ||
                                ClaseImpuesto != datos["ClaseImpuesto"].ToString() ||
                                AlmacenPrincipal != datos["AlmacenPrincipal"].ToString() ||
                                EstatusAdicional != datos["EstatusAdicional"].ToString() ||
                                Tipo != datos["Tipo"].ToString() ||
                                Planeador != datos["Planeador"].ToString() ||
                                CodigoBarras != datos["CodigoBarras"].ToString() ||
                                UnidadMedida != datos["UnidadMedida"].ToString() ||                
                                UmaCajaDisplay != datos["UmaCajaDisplay"].ToString() ||
                                UmaCajaUnidad != datos["UmaCajaUnidad"].ToString()
                                )
                            )
                        )
                    )
                )
                ||
                (
                    (
                        tipoMovimientoId == 5 && 
                        (
                            Folio != datos["Folio"].ToString() ||
                            //FechaSolicitud != datos["FechaSolicitud"].ToString() ||
                            CodigoPromocion != datos["CodigoPromocion"].ToString() ||
                            Nombre != datos["Nombre"].ToString() ||
                            Empresa != datos["Empresa"].ToString() ||
                            TipoSolicitudId != Convert.ToInt32(datos["TipoSolicitudId"].ToString()) ||
                            Marca != datos["Marca"].ToString()
                        )
                        &&
                        (
                            EsSinCreacion || 
                            (
                                !EsSinCreacion && 
                                (
                                    Linea != datos["Linea"].ToString() ||
                                    Grupo != datos["Grupo"].ToString() ||
                                    Impuesto != datos["Impuesto"].ToString() ||
                                    ClaseImpuesto != datos["ClaseImpuesto"].ToString() ||
                                    AlmacenPrincipal != datos["AlmacenPrincipal"].ToString() ||
                                    EstatusAdicional != datos["EstatusAdicional"].ToString() ||
                                    Tipo != datos["Tipo"].ToString() ||
                                    Planeador != datos["Planeador"].ToString() 
                                    //|| UnidadMedida != datos["UnidadMedida"].ToString()
                                )
                            )
                        )
                    )
                )
            )
            {
                existenDiferenciasHeader = true;
            }

            return existenDiferenciasHeader;
        }

        private decimal ObtienePrecioTMP(List<Dictionary<string, object>> listaPrecios, int indexListaPrecio, string marca, string numeroLista)
        {
            var esPrecioUnidad = !string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioUnidad"].ToString());
            var esPrecioDisplay = !string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioDisplay"].ToString());
            var esPrecioCaja = !string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioCaja"].ToString());

            string[] valuesMarca = marca.Split('-');
            var unidadMedidaId = esPrecioCaja ? 1 : esPrecioUnidad ? 2 : 3;
            var dataListaPrecioProducto = new Dictionary<string, object>
            { ["NumeroLista"] = numeroLista, ["UnidadMedidaId"] = unidadMedidaId, ["Marca"] = valuesMarca[0].Trim(), ["Referencia"] = valuesMarca[1].Trim() };
            var listaDatos = Utilities.GetItem("ListaPrecioProducto_Sel", dataListaPrecioProducto);

            var propiedadPrecio = esPrecioUnidad ? "PrecioUnidad" :
            esPrecioDisplay ? "PrecioDisplay" : "PrecioCaja";

            return Utilities.GetDecimal(listaDatos, propiedadPrecio);
        }
        private decimal ObtieneDescuento(List<Dictionary<string, object>> listaPrecios, int indexListaPrecio, string marca, string numeroLista)
        {
            var esPrecioUnidad = !string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioUnidad"].ToString());
            var esPrecioDisplay = !string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioDisplay"].ToString());
            var esPrecioCaja = !string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioCaja"].ToString());
            
            var propiedadPrecio = esPrecioUnidad ? "PrecioUnidad" : esPrecioDisplay ? "PrecioDisplay" : "PrecioCaja";
            decimal precioPromocion = Convert.ToDecimal(listaPrecios[indexListaPrecio][propiedadPrecio].ToString().Replace("$", ""));

            return ObtienePrecioTMP(listaPrecios, indexListaPrecio, marca, numeroLista) - precioPromocion;
            

        }
        private decimal ObtienePrecioPromocion(List<Dictionary<string, object>> listaPrecios, int indexListaPrecio, string marca, string numeroLista)
        {
            var esPrecioUnidad = !string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioUnidad"].ToString());
            var esPrecioDisplay = !string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioDisplay"].ToString());
            var esPrecioCaja = !string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioCaja"].ToString());

            var propiedadPrecio = esPrecioUnidad ? "PrecioUnidad" :
            esPrecioDisplay ? "PrecioDisplay" : "PrecioCaja";

            return Convert.ToDecimal(listaPrecios[indexListaPrecio][propiedadPrecio].ToString().Replace("$", ""));

        }

        private string ValidaPrecio(bool esPrecioUnidad, bool esPrecioDisplay, bool esPrecioCaja, string propiedadPrecio, Dictionary<string, object> listaDatos, string precioUnidad, string precioDisplay, string precioCaja, string numeroLista)
        {
            var error = string.Empty;

            if (esPrecioUnidad && !Decimal.TryParse(precioUnidad.Replace("$", ""), out decimal precioU))
                error = error + $"\nPara el número de lista {numeroLista}, el Precio Unidad es incorrecto, se espera un valor númerico";
            else if (esPrecioUnidad && Utilities.GetDecimal(listaDatos, propiedadPrecio) == 0 && precioUnidad != "")
                error = error + $"\nPara el número de lista {numeroLista}, el Precio Unidad en TPM es 0, por lo tanto no se debe informar en la macro";
            else if (esPrecioUnidad && Utilities.GetDecimal(listaDatos, propiedadPrecio) < Convert.ToDecimal(precioUnidad.Replace("$", "")))
                error = error + $"\nPara el número de lista {numeroLista}, el Precio Unidad de la macro debe ser menor al configurado en TPM";
            //else if (esPrecioUnidad)
            //{
            //    if (txtPrecioUnidad == "")
            //        txtPrecioUnidad = listaPrecios[indexListaPrecio]["PrecioUnidad"].ToString().Replace("$", "");
            //    else if (txtPrecioUnidad != listaPrecios[indexListaPrecio]["PrecioUnidad"].ToString().Replace("$", ""))
            //        error = error + $"\nSolo se permite un único precio unidad en todos los números de lista, favor de revisar";
            //}

            if (esPrecioDisplay && !Decimal.TryParse(precioDisplay.Replace("$", ""), out decimal precioD))
                error = error + $"\nPara el número de lista {numeroLista}, el Precio Display es incorrecto, se espera un valor númerico";
            else if (esPrecioDisplay && Utilities.GetDecimal(listaDatos, propiedadPrecio) == 0 && precioDisplay != "")
                error = error + $"\nPara el número de lista {numeroLista}, el Precio Display en TPM es 0, por lo tanto no se debe informar en la macro";
            else if (esPrecioDisplay && Utilities.GetDecimal(listaDatos, propiedadPrecio) < Convert.ToDecimal(precioDisplay.Replace("$", "")))
                error = error + $"\nPara el número de lista {numeroLista}, el Precio Display de la macro debe ser menor al configurado en TPM";
            //else if (esPrecioDisplay)
            //{
            //    if (txtPrecioDisplay == "")
            //        txtPrecioDisplay = listaPrecios[indexListaPrecio]["PrecioDisplay"].ToString().Replace("$", "");
            //    else if (txtPrecioDisplay != listaPrecios[indexListaPrecio]["PrecioDisplay"].ToString().Replace("$", ""))
            //        error = error + $"\nSolo se permite un único precio display en todos los números de lista, favor de revisar";
            //}

            if (esPrecioCaja && !Decimal.TryParse(precioCaja.Replace("$", ""), out decimal precioC))
                error = error + $"\nPara el número de lista {numeroLista}, el Precio Display es incorrecto, se espera un valor númerico";
            else if (esPrecioCaja && Utilities.GetDecimal(listaDatos, propiedadPrecio) == 0 && precioCaja != "")
                error = error + $"\nPara el número de lista {numeroLista}, el Precio Caja en TPM es 0, por lo tanto no se debe informar en la macro";
            else if (esPrecioCaja && Utilities.GetDecimal(listaDatos, propiedadPrecio) < Convert.ToDecimal(precioCaja.Replace("$", "")))
                error = error + $"\nPara el número de lista {numeroLista}, el Precio Caja de la macro debe ser menor al configurado en TPM";
            //else if (esPrecioCaja)
            //{
            //    if (txtPrecioCaja == "")
            //        txtPrecioCaja = listaPrecios[indexListaPrecio]["PrecioCaja"].ToString().Replace("$", "");
            //    else if (txtPrecioCaja != listaPrecios[indexListaPrecio]["PrecioCaja"].ToString().Replace("$", ""))
            //        error = error + $"\nSolo se permite un único precio caja en todos los números de lista, favor de revisar";
            //}

            return error;
        }
        private string ValidaFechaCierre(string fechaCierre, string numeroLista)
        {
            var error = string.Empty;

            if (String.IsNullOrEmpty(fechaCierre))
            {
                error = error + $"\nLa Fecha de Cierre es requerida en la macro en el No. de Lista {numeroLista}";
            }
            else if (!IsValidDate(fechaCierre, "MM/dd/yyyy"))
            {
                error = error + $"\nFecha de Cierre incorrecta, debe ser MM/dd/yyyy en el número de lista {numeroLista}";
            }

            return error;
        }
        private string ValidaFechaInicio(string fechaInicio, string numeroLista)
        {
            var error = string.Empty;
                
            if (String.IsNullOrEmpty(fechaInicio))
            {
                error = $"\nLa Fecha de Inicio es requerida en la macro en el No. de Lista {numeroLista}";
            }
            else if (!IsValidDate(fechaInicio, "MM/dd/yyyy"))
            {
                error = $"\nFecha de Inicio incorrecta, debe ser MM/dd/yyyy en el número de lista {numeroLista}";
            }

            return error;
        }

        private bool IsValidDate(string date, string shortDatePattern)
        {
            Regex regex;

            if (shortDatePattern == "dd/MM/yyyy")
            {
                //regex = new Regex(@"^(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[012])[- /.](20|[2-9][0-9])\d\d$");
                regex = new Regex(@"^(0[1-9]|[12][0-9]|3[01])[/](0[1-9]|1[012])[/](20|[2-9][0-9])\d\d$");
            }
            else if (shortDatePattern == "MM/dd/yyyy")
            {
                //regex = new Regex(@"^(0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])[- /.](20|[2-9][0-9])\d\d$");
                regex = new Regex(@"^(0[1-9]|1[012])[/](0[1-9]|[12][0-9]|3[01])[/](20|[2-9][0-9])\d\d$");
            }
            else if (shortDatePattern == "M/d/yyyy")
            {
                regex = new Regex(@"^(((0?[1-9]|1[012])/(0?[1-9]|1\d|2[0-8])|(0?[13456789]|1[012])/(29|30)|(0?[13578]|1[02])/31)/(19|[2-9]\d)\d{2}|0?2/29/((19|[2-9]\d)(0[48]|[2468][048]|[13579][26])|(([2468][048]|[3579][26])00)))$");
            }
            else
            {
                return false;
            }

            Match m = regex.Match(date);

            return !string.IsNullOrEmpty(m.Value);

        }
        private string CheckValuePartDate(string value)
        {
            if (value.Length == 1)
                return "0" + value;
            else
                return value;
        }

        private void BuscaCanalPorNumeroLista(string numeroLista) {
            //Obtener el canalID de cada lista
            var dataListaPrecio = new Dictionary<string, object>
            { ["NumeroLista"] = numeroLista };
            var canales = Utilities.GetData("ActivityPromocionListaPrecio_Sel", dataListaPrecio);

            if (canales.Count() > 0)
            {
                foreach (var canal in canales)
                {
                    if (!this.listCanalIDs.Contains(canal["Canal"].ToString()))
                        this.listCanalIDs.Add(canal["Canal"].ToString());
                }
            }
        }

        private string ValidarTipoMovimiento(ExcelWorksheet ws, Dictionary<string, object> datos, string tipoSolicitud, int tipoSolicitudId, string tipoMovimiento, int tipoMovimientoId, string existeCodigoPromocion, int activityId, int promocionId)
        {
            var error = string.Empty;

            bool tipoSolicitudError = false;

            if (String.IsNullOrEmpty(ws.Cells["D11"].Text))
            {
                error = error + "\nEl campo Tipo de Solicitud es requerido en la macro";
                tipoSolicitudError = true;
            }

            if (tipoSolicitud.ToLower() != ws.Cells["D11"].Text.ToLower())
            {
                error = error + "\nEl Tipo de Solicitud no coincide con el seleccionado";
                tipoSolicitudError = true;
            }

            bool codigoPromocionError = false;

            if (!tipoSolicitudError)
            {
                if (String.IsNullOrEmpty(ws.Cells["F6"].Text))
                {
                    error = error + "\nEl Código de Promoción es requerido en la macro";
                    codigoPromocionError = true;
                }
                else
                {
                    if (ws.Cells["F6"].Text.Trim().Length != 8)
                    {
                        error = error + "\nEl Código de Promoción debe ser de 8 caracteres";
                        codigoPromocionError = true;
                    }
                    if (tipoSolicitud.ToLower() == "promocion configurada" && !ws.Cells["F6"].Text.Trim().ToLower().StartsWith("p"))
                    {
                        error = error + "\nEl Código de Promoción debe iniciar con p cuando el tipo de solicitud es Promoción Configurada";
                        codigoPromocionError = true;
                    }
                    if (tipoSolicitud.ToLower() == "promocion armada" && !ws.Cells["F6"].Text.Trim().ToLower().StartsWith("ap"))
                    {
                        error = error + "\nEl Código de Promoción debe iniciar con ap cuando el tipo de solicitud es Promoción Armada";
                        codigoPromocionError = true;
                    }
                }
            }

            bool tipoMovimientoError = false;

            if (String.IsNullOrEmpty(ws.Cells["E11"].Text))
            {
                error = error + "\nEl Tipo de Movimiento es requerido en la macro";
                tipoMovimientoError = true;
            }

            if (tipoMovimiento.ToLower() != ws.Cells["E11"].Text.ToLower())
            {
                error = error + "\nEl Tipo de Movimiento no coincide con el seleccionado";
                tipoMovimientoError = true;
            }

            if (!tipoSolicitudError && !tipoMovimientoError && !codigoPromocionError)
            {
                //Validar Creacion si existeCodigoPromocion == 1 (no se encontró CodigoPromocion)
                //Validar Reactivacion, Cierre, Ampliacion, Actualizacion de Parametros, Actualizacion de Precio si existeCodigoPromocion == 2 (se encontró CodigoPromocion)
                //var dataTipoMovimiento = new Dictionary<string, object> { ["TipoMovimientoId"] = existeCodigoPromocion == "1" ? 1 : tipoMovimientoId, ["CodigoPromocion"] = ws.Cells["F6"].Text, ["ActivityId"] = activityId };
                var dataTipoMovimiento = new Dictionary<string, object> { ["TipoSolicitudId"] = tipoSolicitudId, ["TipoMovimientoId"] = tipoMovimientoId, ["CodigoPromocion"] = ws.Cells["F6"].Text, ["ActivityId"] = activityId, ["PromocionId"] = promocionId };
                var resultValidate = Utilities.GetData("TipoMovimiento_Validate", dataTipoMovimiento);

                string messageError = string.Empty;
                foreach (var item in resultValidate)
                {
                    messageError = item["MessageError"].ToString();
                }

                if (messageError != "")
                {
                    error = error + messageError;
                    return error;
                }

            }

            return error;
        }

        private string ValidarPromocion(ExcelWorksheet ws, Dictionary<string, object> datos, int activityId, int promocionId, int tipoMovimientoId, string tipoSolicitud, string marca, bool esSinCreacion)
        {
            string error = string.Empty;

            bool existenDiferenciasProductos = false;
            bool existenDiferenciasListaPrecios = false;

            string errorHeader = string.Empty;
            string errorProducto = string.Empty;
            string errorListaPrecio = string.Empty;
            var parmsActivityPromocion = new Dictionary<string, object> { ["PromocionId"] = promocionId, ["CodigoPromocion"] = datos["CodigoPromocion"].ToString() };

            if (ExistenDiferecniasHeader(datos, activityId, promocionId, tipoMovimientoId, parmsActivityPromocion))
            {
                errorHeader = "\nExisten diferencias en el Encabezado de la macro";
            }
            else
            {
                //Info from Excel
                List<Dictionary<string, object>> productos = (List<Dictionary<string, object>>)datos["Productos"];
                List<Dictionary<string, object>> listaPrecios = (List<Dictionary<string, object>>)datos["ListaPrecios"];

                //Info from BD
                List<Dictionary<string, object>> dataProducto = Utilities.GetData("ActivityPromocionProducto_SelByPromocionId", parmsActivityPromocion);
                List<Dictionary<string, object>> dataListaPrecio = Utilities.GetData("ActivityPromocionListaPrecio_SelByPromocionId", parmsActivityPromocion);

                //Enviar productos solo en tipoMovimiento reactivacion
                if (tipoMovimientoId == 6 && promocionId == 0 && !esSinCreacion)
                {
                    datos["Productos"] = dataProducto;

                    error = ValidarCargaPromocion(ws, marca);
                    if (error != "") return error;

                    var codigoBarrasReferencia = Utilities.GetData("CodigoBarrasReferencia_Get", datos);

                    var codigoBarras = codigoBarrasReferencia.Count > 0 ? codigoBarrasReferencia[0]["CodigoBarras"].ToString() : "";

                    error = error + (tipoSolicitud.ToUpper() == "PROMOCION ARMADA" && String.IsNullOrEmpty(codigoBarras) ? "\nEl Código de Barras es requerido en la macro" : "");
                    if (error != "") return error;

                    datos["CodigoBarras"] = codigoBarras; 
                }

                if (tipoMovimientoId == 5)
                    error = error + (tipoSolicitud.ToUpper() == "PROMOCION ARMADA" && String.IsNullOrEmpty(datos["CodigoBarras"].ToString()) ? "\nEl Código de Barras es requerido en la macro" : "");

                int indexProducto = 0;
                //bool diferenciasProducto = false;                                    

                var marcaReferencias = new List<Dictionary<string, object>>();
                string umaCajaDisplay = string.Empty;
                string umaCajaUnidad = string.Empty;

                bool umaCajaDisplayRegalado = false;
                bool umaCajaUnidadRegalado = false;

                List<decimal> listParticipacionVendido = new List<decimal>();
                List<decimal> listParticipacionRegalado = new List<decimal>();

                if (error == "" && (tipoMovimientoId == 4 || tipoMovimientoId == 5))
                {
                    if (productos.Count == 0 && (tipoMovimientoId == 4 || tipoMovimientoId == 5))
                        errorProducto = "\nPara tipos de movimiento Actualización de Precios o Actualización de Parámetros se espera al menos un elemento en Estructura Comercial";

                    if (errorProducto == "" && (tipoMovimientoId == 4 || tipoMovimientoId == 5) && dataProducto.Count != productos.Count)
                        errorProducto = "\nEl total de productos es diferente al último cargado";

                    var dataMarca = new Dictionary<string, object> { ["marca"] = marca };
                    marcaReferencias = Utilities.GetData("MarcaReferencia_Get", dataMarca);

                    umaCajaDisplay = datos["UmaCajaDisplay"].ToString();
                    umaCajaUnidad = datos["UmaCajaUnidad"].ToString();
                }

                while ((tipoMovimientoId == 4 || tipoMovimientoId == 5) && errorProducto == "" && error == "" && indexProducto < productos.Count)
                {
                    if (
                        (tipoMovimientoId != 5 && (dataProducto[indexProducto]["NumeroProducto"].ToString() != productos[indexProducto]["NumeroProducto"].ToString() ||
                        dataProducto[indexProducto]["Cantidad"].ToString() != productos[indexProducto]["Cantidad"].ToString() ||
                        dataProducto[indexProducto]["UnidadMedida"].ToString() != productos[indexProducto]["UnidadMedida"].ToString() ||
                        dataProducto[indexProducto]["TipoElemento"].ToString() != productos[indexProducto]["TipoElemento"].ToString() ||
                        dataProducto[indexProducto]["Participacion"].ToString() != productos[indexProducto]["Participacion"].ToString() ||
                        dataProducto[indexProducto]["Codigo"].ToString() != productos[indexProducto]["Codigo"].ToString() ||
                        dataProducto[indexProducto]["Producto"].ToString() != productos[indexProducto]["Producto"].ToString())))

                    {
                        existenDiferenciasProductos = true;
                        errorProducto = errorProducto + "\nExisten diferencias en la Estructura Comercial de la macro";
                    }

                    if (!existenDiferenciasProductos)
                    {
                        if (tipoMovimientoId == 5)
                        {


                            if (String.IsNullOrEmpty(productos[indexProducto]["NumeroProducto"].ToString()))
                                error = error + "\nEl No. Elementos PT es requerido en la macro";

                            if (String.IsNullOrEmpty(productos[indexProducto]["Cantidad"].ToString()))
                                error = error + "\nLa Cantidad es requerida en la macro";

                            if (String.IsNullOrEmpty(productos[indexProducto]["UnidadMedida"].ToString()))
                                error = error + "\nLa Unidad de Medida es requerida en la macro";

                            if (String.IsNullOrEmpty(productos[indexProducto]["TipoElemento"].ToString()))
                                error = error + "\nEl Tipo Elemento es requerido en la macro";

                            if (String.IsNullOrEmpty(productos[indexProducto]["Participacion"].ToString()))
                                error = error + "\nEl % Participación es requerido en la macro";
                            else if (!Decimal.TryParse(productos[indexProducto]["Participacion"].ToString().Replace("%", ""), out decimal participacion))
                                error = error + $"\nPara la fila {(indexProducto + 1) + 33}, se espera un valor númerico en % Participación";

                            if (String.IsNullOrEmpty(productos[indexProducto]["Codigo"].ToString()))
                                error = error + "\nEl Código del Artículo es requerido en la macro";

                            if (String.IsNullOrEmpty(productos[indexProducto]["Producto"].ToString()))
                                error = error + "\nLa Descripción del Artículo es requerida en la macro";

                            if (error == "")
                            {
                                var articulo = productos[indexProducto]["Codigo"].ToString();
                                var dataProductoActivity = new Dictionary<string, object> { ["TextoBusqueda"] = articulo };
                                var articulos = Utilities.GetData("ProductoActivity_Cmb", dataProductoActivity);
                                var tipoElemento = productos[indexProducto]["TipoElemento"].ToString();

                                error = articulos.Count == 0
                                    ? $"\nEl artículo {articulo} no esta dado de alta en TPM favor de validar"
                                    : "";

                                var marcaCorrecta = false;

                                foreach (var _articulo in articulos)
                                {
                                    foreach (var referencia in marcaReferencias)
                                    {
                                        if (string.Equals(referencia["Marca"].ToString(), _articulo["Marca"].ToString(), StringComparison.CurrentCultureIgnoreCase))
                                            marcaCorrecta = true;
                                    }
                                }

                                error = error + (marcaCorrecta ? "" : $"\nLa marca del artículo {articulo} debe ser igual a la marca de la macro");

                                //Veriricar UNIDAD DE MEDIDA por cada artículo
                                //UmaCajaDisplay y UmaCajaUnidad vacíos, UNIDAD DE MEDIDA igual a CJ
                                //UmaCajaDisplay igual 1 y UmaCajaUnidad vacío, UNIDAD DE MEDIDA igual a DP
                                //UmaCajaDisplay vacío y UmaCajaUnidad 1, UNIDAD DE MEDIDA igual a UN

                                if (!esPromocionArmada && umaCajaDisplay != "" && umaCajaDisplay != "1")
                                    error = error + "\nEn promoción configurada, el valor UMA DE CJ A DP debe ser 1";

                                if (!esPromocionArmada && umaCajaUnidad != "" && umaCajaUnidad != "1")
                                    error = error + "\nEn promoción configurada, el valor UMA DE CJ A U debe ser 1";

                                //Si el elemnto es de tipo vendido, esta será la unidad de medida que se pondrá en la cabecera
                                decimal participacion = Convert.ToDecimal(productos[indexProducto]["Participacion"].ToString().Replace("%", ""));
                                bool esVendido = false;
                                string unidadMedidad = string.Empty;

                                if (tipoElemento.ToLower() == "vendido")
                                {
                                    error = error + (participacion % 1 != 0 ? $"\nPorcetanje de Participación incorrecto, solo se permiten números enteros en el artículo {articulo}" : "");

                                    if (unidadMedidad == "")
                                        unidadMedidad = productos[indexProducto]["UnidadMedida"].ToString();
                                    else if (unidadMedidad != productos[indexProducto]["UnidadMedida"].ToString())
                                        error = error + $"\nSolo se permite una misma unidad de medida en todos los productos VENDIDOS.";

                                    esVendido = true;
                                    datos["UnidadMedidaProductos"] = productos[indexProducto]["UnidadMedida"].ToString();

                                    listParticipacionVendido.Add(participacion);
                                }
                                else if (tipoElemento.ToLower() == "regalado")
                                {
                                    if (productos[indexProducto]["UnidadMedida"].ToString().ToLower().Equals("un"))
                                        umaCajaUnidadRegalado = true;
                                    else if (productos[indexProducto]["UnidadMedida"].ToString().ToLower().Equals("dp"))
                                        umaCajaDisplayRegalado = true;

                                    listParticipacionRegalado.Add(participacion);
                                }
                                else
                                {
                                    error = error + $"\nSolo se permiten los tipos de elemento VENDIDO ó REGALADO en el artículo {articulo}";
                                }
                            }
                        }
                    }

                    indexProducto++;
                }

                if (error == "" && tipoMovimientoId == 5)
                {
                    if (datos["UnidadMedidaProductos"].ToString().ToLower().Equals(datos["UnidadMedida"].ToString().ToLower()))
                    {
                        if (umaCajaDisplay == "" && (datos["UnidadMedidaProductos"].ToString().ToLower().Equals("dp") || umaCajaDisplayRegalado))
                            error = error + "\nSe espera " + (esPromocionArmada ? "valor" : "el valor 1") + " en el campo UMA DE CJ A DP";
                        else if (umaCajaUnidad == "" && (datos["UnidadMedidaProductos"].ToString().ToLower().Equals("un") || umaCajaUnidadRegalado))
                            error = error + "\nSe espera " + (esPromocionArmada ? "valor" : "el valor 1") + " en el campo UMA DE CJ A U";

                        if (listParticipacionVendido.Count > 1 && listParticipacionVendido.Sum() != 100)
                            error = error + "\nEl total del porcentaje de participación para los tipos de elementos VENDIDO debe ser 100%";

                        if (listParticipacionRegalado.Count > 1 && listParticipacionRegalado.Sum() != 0)
                            error = error + "\nEl total del porcentaje de participación para los tipos de elementos REGALADO debe ser 0%";
                    }
                    else
                    {
                        error = error + "\nLa UM debe ser igual a la Unidad de Medida de los tipos de elementos VENDIDO";
                    }
                    
                }

                int indexListaPrecio = 0;

                if (this.alamacenesalmacenesCanalBD != this.almacenesCanal)
                    errorListaPrecio = "\nAlmacenes/Canal es diferente al último cargado";

                if (listaPrecios.Count == 0)
                    errorListaPrecio = "\nPara todos los tipos de movimiento se espera al menos un elemento en lista de precios";

                if (errorListaPrecio == "" && dataListaPrecio.Count != listaPrecios.Count)
                    errorListaPrecio = "\nEl total de listas de precio es diferente a la última cargado";

                DateTime dateFechaSolicitud = DateTime.ParseExact(datos["FechaSolicitudExcel"].ToString(), CultureInfo.CurrentCulture.DateTimeFormat.ShortDatePattern, CultureInfo.InvariantCulture);

                bool atLeastOnePrecioUnidad = false;
                bool atLeastOnePrecioDisplay = false;
                bool atLeastOnePrecioCaja = false;

                string txtPrecioUnidad = string.Empty;
                string txtPrecioDisplay = string.Empty;
                string txtPrecioCaja = string.Empty;

                this.listCanalIDs.Clear();

                while (errorListaPrecio == "" && error == "" & indexListaPrecio < dataListaPrecio.Count)
                {
                    if (

                        (tipoMovimientoId == 2 && (
                        dataListaPrecio[indexListaPrecio]["NumeroLista"].ToString() != listaPrecios[indexListaPrecio]["NumeroLista"].ToString() ||
                        dataListaPrecio[indexListaPrecio]["PrecioUnidad"].ToString() != listaPrecios[indexListaPrecio]["PrecioUnidad"].ToString() ||
                        dataListaPrecio[indexListaPrecio]["PrecioDisplay"].ToString() != listaPrecios[indexListaPrecio]["PrecioDisplay"].ToString() ||
                        dataListaPrecio[indexListaPrecio]["PrecioCaja"].ToString() != listaPrecios[indexListaPrecio]["PrecioCaja"].ToString() ||
                        dataListaPrecio[indexListaPrecio]["FechaInicio"].ToString() != listaPrecios[indexListaPrecio]["FechaInicio"].ToString()
                        ))

                        ||

                        ((tipoMovimientoId == 3) && (
                        dataListaPrecio[indexListaPrecio]["NumeroLista"].ToString() != listaPrecios[indexListaPrecio]["NumeroLista"].ToString() ||
                        dataListaPrecio[indexListaPrecio]["PrecioUnidad"].ToString() != listaPrecios[indexListaPrecio]["PrecioUnidad"].ToString() ||
                        dataListaPrecio[indexListaPrecio]["PrecioDisplay"].ToString() != listaPrecios[indexListaPrecio]["PrecioDisplay"].ToString() ||
                        dataListaPrecio[indexListaPrecio]["PrecioCaja"].ToString() != listaPrecios[indexListaPrecio]["PrecioCaja"].ToString()
                        ))

                        ||

                        (tipoMovimientoId == 4 && (
                        dataListaPrecio[indexListaPrecio]["NumeroLista"].ToString() != listaPrecios[indexListaPrecio]["NumeroLista"].ToString() ||
                        dataListaPrecio[indexListaPrecio]["FechaInicio"].ToString() != listaPrecios[indexListaPrecio]["FechaInicio"].ToString() ||
                        dataListaPrecio[indexListaPrecio]["FechaFin"].ToString() != listaPrecios[indexListaPrecio]["FechaFin"].ToString()
                        ))

                        ||

                        (tipoMovimientoId == 5 || tipoMovimientoId == 6 && (
                        dataListaPrecio[indexListaPrecio]["NumeroLista"].ToString() != listaPrecios[indexListaPrecio]["NumeroLista"].ToString()
                        ))

                        )

                    {
                        errorListaPrecio = errorListaPrecio + "\nExisten diferencias en la Lista de Precios";
                        existenDiferenciasListaPrecios = true;
                    }

                    if (!existenDiferenciasListaPrecios)
                    {
                        var numeroLista = listaPrecios[indexListaPrecio]["NumeroLista"].ToString();

                        if (tipoMovimientoId == 4)
                        {
                            //Actualización de Precios
                            var esPrecioUnidad = !string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioUnidad"].ToString());
                            var esPrecioDisplay = !string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioDisplay"].ToString());
                            var esPrecioCaja = !string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioCaja"].ToString());

                            if (datos["UnidadMedidaProductos"].ToString().ToLower().Equals("cj"))
                                error = esPrecioUnidad || esPrecioDisplay ? $"\nSolo se espera el PRECIO CAJA" : "";

                            if (datos["UnidadMedidaProductos"].ToString().ToLower().Equals("dp"))
                                error = esPrecioUnidad || esPrecioCaja ? $"\nSolo se espera el PRECIO DISPLAY" : "";

                            if (datos["UnidadMedidaProductos"].ToString().ToLower().Equals("un"))
                                error = esPrecioDisplay || esPrecioCaja ? $"\nSolo se espera el PRECIO UNIDAD" : "";

                            if (error == "" && (esPrecioUnidad || esPrecioDisplay || esPrecioCaja))
                            {
                                string[] valuesMarca = datos["Marca"].ToString().Split('-');
                                var unidadMedidaId = esPrecioCaja ? 1 : esPrecioUnidad ? 2 : 3;
                                var dataListaPrecioProducto = new Dictionary<string, object>
                                { ["NumeroLista"] = numeroLista, ["UnidadMedidaId"] = unidadMedidaId, ["Marca"] = valuesMarca[0].Trim(), ["Referencia"] = valuesMarca[1].Trim() };
                                var listaDatos = Utilities.GetItem("ListaPrecioProducto_Sel", dataListaPrecioProducto);

                                error = listaDatos.Count == 0
                                    ? $"\nEl No. de Lista {numeroLista} no esta dado de alta o está inactivo en TPM, favor de validar"
                                    : "";

                                if (error == "")
                                {


                                    var columanPrecio = esPrecioUnidad ? 4 : esPrecioDisplay ? 5 : 6;

                                    if (!string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioUnidad"].ToString()) && !string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioDisplay"].ToString()) && !string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioCaja"].ToString()))
                                    {
                                        error = error + $"\nSolo se permite informar un Precio para el número de lista {numeroLista}";
                                    }
                                    else if (!string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioUnidad"].ToString()))
                                    {
                                        atLeastOnePrecioUnidad = true;
                                    }
                                    else if (!string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioDisplay"].ToString()))
                                    {
                                        atLeastOnePrecioDisplay = true;
                                    }
                                    else if (!string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioCaja"].ToString()))
                                    {
                                        atLeastOnePrecioCaja = true;
                                    }

                                    var propiedadPrecio = esPrecioUnidad ? "PrecioUnidad" : esPrecioDisplay ? "PrecioDisplay" : "PrecioCaja";

                                    //Validar que los montos sean menores al que se encuentra en base de datos TPM

                                    error = error + ValidaPrecio(esPrecioUnidad, esPrecioDisplay, esPrecioCaja, propiedadPrecio, listaDatos, listaPrecios[indexListaPrecio]["PrecioUnidad"].ToString(), listaPrecios[indexListaPrecio]["PrecioDisplay"].ToString(), listaPrecios[indexListaPrecio]["PrecioCaja"].ToString(), listaPrecios[indexListaPrecio]["NumeroLista"].ToString());

                                    if (esPrecioUnidad)                                    
                                        if (txtPrecioUnidad == "")
                                            txtPrecioUnidad = listaPrecios[indexListaPrecio]["PrecioUnidad"].ToString().Replace("$", "");
                                        else if (txtPrecioUnidad != listaPrecios[indexListaPrecio]["PrecioUnidad"].ToString().Replace("$", ""))
                                            error = error + $"\nSolo se permite un único precio unidad en todos los números de lista, favor de revisar";
                                    

                                    if (esPrecioDisplay)                                    
                                        if (txtPrecioDisplay == "")
                                            txtPrecioDisplay = listaPrecios[indexListaPrecio]["PrecioDisplay"].ToString().Replace("$", "");
                                        else if (txtPrecioDisplay != listaPrecios[indexListaPrecio]["PrecioDisplay"].ToString().Replace("$", ""))
                                            error = error + $"\nSolo se permite un único precio display en todos los números de lista, favor de revisar";
                                    

                                    if (esPrecioCaja)                                    
                                        if (txtPrecioCaja == "")
                                            txtPrecioCaja = listaPrecios[indexListaPrecio]["PrecioCaja"].ToString().Replace("$", "");
                                        else if (txtPrecioCaja != listaPrecios[indexListaPrecio]["PrecioCaja"].ToString().Replace("$", ""))
                                            error = error + $"\nSolo se permite un único precio caja en todos los números de lista, favor de revisar";
                                    
                                    decimal precioPromocion = error == "" ? Convert.ToDecimal(listaPrecios[indexListaPrecio][propiedadPrecio].ToString().Replace("$", "")) : 0;

                                    var descuento = Utilities.GetDecimal(listaDatos, propiedadPrecio) - precioPromocion;

                                    datos["Descuento"] = descuento;
                                    listaPrecios[indexListaPrecio]["Descuento"] = descuento;
                                    listaPrecios[indexListaPrecio]["PrecioPromocion"] = precioPromocion;

                                    //Fechas en listas de precios, solo son visibles y no requiere validar
                                    DateTime dateFechaInicio = DateTime.Now;
                                    DateTime dateFechaCierre = DateTime.Now;

                                    dateFechaCierre = DateTime.ParseExact(listaPrecios[indexListaPrecio]["FechaFin"].ToString(), "MM/dd/yyyy", CultureInfo.InvariantCulture);
                                    listaPrecios[indexListaPrecio]["FechaFinVisible"] = CheckValuePartDate(dateFechaCierre.Day.ToString()) + "/" + CheckValuePartDate(dateFechaCierre.Month.ToString()) + "/" + dateFechaCierre.Year.ToString();

                                    dateFechaInicio = DateTime.ParseExact(listaPrecios[indexListaPrecio]["FechaInicio"].ToString(), "MM/dd/yyyy", CultureInfo.InvariantCulture);
                                    listaPrecios[indexListaPrecio]["FechaInicioVisible"] = CheckValuePartDate(dateFechaInicio.Day.ToString()) + "/" + CheckValuePartDate(dateFechaInicio.Month.ToString()) + "/" + dateFechaInicio.Year.ToString();
                                                                        
                                }
                            }

                            if (!esPrecioUnidad && !esPrecioDisplay && !esPrecioCaja)
                            {
                                error = error + $"\nSolo se permite informar un Precio para el número de lista {listaPrecios[indexListaPrecio]["NumeroLista"].ToString()}";
                            }
                            else if (esPrecioUnidad)
                            {
                                atLeastOnePrecioUnidad = true;
                            }
                            else if (esPrecioDisplay)
                            {
                                atLeastOnePrecioDisplay = true;
                            }
                            else if (esPrecioCaja)
                            {
                                atLeastOnePrecioCaja = true;
                            }
                        }

                        if (tipoMovimientoId == 3 || tipoMovimientoId == 6)
                        {
                            //Ampliación ó Reactivación

                            var esPrecioUnidad = !string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioUnidad"].ToString());
                            var esPrecioDisplay = !string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioDisplay"].ToString());
                            var esPrecioCaja = !string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioCaja"].ToString());

                            var descuento = 0.0M;

                            if (esPrecioUnidad || esPrecioDisplay || esPrecioCaja)
                                descuento = ObtieneDescuento(listaPrecios, indexListaPrecio, datos["Marca"].ToString(), numeroLista);


                            else
                            {
                                error = error + "Ingrese al menos un tipo de precio en la lista.";
                                break;
                            }
                            
                                

                            datos["Descuento"] = descuento;
                            listaPrecios[indexListaPrecio]["Descuento"] = descuento;
                            listaPrecios[indexListaPrecio]["PrecioPromocion"] = ObtienePrecioPromocion(listaPrecios, indexListaPrecio, datos["Marca"].ToString(), numeroLista);

                            DateTime dateFechaInicio = DateTime.Now;
                            DateTime dateFechaCierre = DateTime.Now;

                            //Validar FECHA de CIERRE para tipos de movimientos Cierre

                            error = ValidaFechaCierre(listaPrecios[indexListaPrecio]["FechaFin"].ToString(), numeroLista);

                            if(error == "")
                            {
                                dateFechaCierre = DateTime.ParseExact(listaPrecios[indexListaPrecio]["FechaFin"].ToString(), "MM/dd/yyyy", CultureInfo.InvariantCulture);
                                listaPrecios[indexListaPrecio]["FechaFin"] = dateFechaCierre.Year.ToString() + CheckValuePartDate(dateFechaCierre.Month.ToString()) + CheckValuePartDate(dateFechaCierre.Day.ToString());
                                listaPrecios[indexListaPrecio]["FechaFinVisible"] = CheckValuePartDate(dateFechaCierre.Day.ToString()) + "/" + CheckValuePartDate(dateFechaCierre.Month.ToString()) + "/" + dateFechaCierre.Year.ToString();

                            }

                            //Validar FECHA DE INICIO para tipos de movimientos Creaciones, Reactivaciones, Actualizaciones, Ampliaciones
                            if (error == "")
                            {
                                error = ValidaFechaInicio(listaPrecios[indexListaPrecio]["FechaInicio"].ToString(), numeroLista);

                                if(error == "")
                                {
                                    dateFechaInicio = DateTime.ParseExact(listaPrecios[indexListaPrecio]["FechaInicio"].ToString(), "MM/dd/yyyy", CultureInfo.InvariantCulture);
                                    listaPrecios[indexListaPrecio]["FechaInicio"] = dateFechaInicio.Year.ToString() + CheckValuePartDate(dateFechaInicio.Month.ToString()) + CheckValuePartDate(dateFechaInicio.Day.ToString());
                                    listaPrecios[indexListaPrecio]["FechaInicioVisible"] = CheckValuePartDate(dateFechaInicio.Day.ToString()) + "/" + CheckValuePartDate(dateFechaInicio.Month.ToString()) + "/" + dateFechaInicio.Year.ToString();

                                    if (dateFechaInicio > dateFechaCierre)
                                    {
                                        error = $"\nLa Fecha de Inicio debe ser menor a la Fecha de Cierre en el número de lista {numeroLista}";
                                    }
                                    else if (dateFechaSolicitud > dateFechaInicio)
                                    {
                                        error = $"\nEn todos los Tipo de Movimientos (excepto Cierre), la Fecha de Inicio debe ser mayor a la Fecha de Solicitud en el número de lista {numeroLista}";
                                    }
                                    else
                                    {
                                        if ((ws.Cells["E11"].Text == "REACTIVACION" && dateFechaInicio.Subtract(dateFechaSolicitud).Days < 7)
                                            ||(ws.Cells["E11"].Text == "AMPLIACION" && dateFechaInicio.Subtract(dateFechaSolicitud).Days < 3))
                                            esExtemporanea = true;
                                    }

                                }
                            }
                        }

                        if (tipoMovimientoId == 2)
                        {
                            //Cierre
                            var descuento = ObtieneDescuento(listaPrecios, indexListaPrecio, datos["Marca"].ToString(), numeroLista);

                            datos["Descuento"] = descuento;
                            listaPrecios[indexListaPrecio]["Descuento"] = descuento;
                            listaPrecios[indexListaPrecio]["PrecioPromocion"] = ObtienePrecioPromocion(listaPrecios, indexListaPrecio, datos["Marca"].ToString(), numeroLista);

                            DateTime dateFechaCierre = DateTime.Now;
                            DateTime dateFechaInicio = DateTime.ParseExact(listaPrecios[indexListaPrecio]["FechaInicio"].ToString(), "MM/dd/yyyy", CultureInfo.InvariantCulture);
                            bool esErrorFechaCierre = true;

                            error = ValidaFechaCierre(listaPrecios[indexListaPrecio]["FechaFin"].ToString(), numeroLista);

                            if(error == "")
                            {
                                dateFechaCierre = DateTime.ParseExact(listaPrecios[indexListaPrecio]["FechaFin"].ToString(), "MM/dd/yyyy", CultureInfo.InvariantCulture);
                                listaPrecios[indexListaPrecio]["FechaFin"] = dateFechaCierre.Year.ToString() + CheckValuePartDate(dateFechaCierre.Month.ToString()) + CheckValuePartDate(dateFechaCierre.Day.ToString());
                                listaPrecios[indexListaPrecio]["FechaFinVisible"] = CheckValuePartDate(dateFechaCierre.Day.ToString()) + "/" + CheckValuePartDate(dateFechaCierre.Month.ToString()) + "/" + dateFechaCierre.Year.ToString();

                                if (dateFechaCierre < dateFechaSolicitud)// || dateFechaCierre.Subtract(dateFechaSolicitud).Days < 7)
                                {
                                    error = error + $"\nEn Tipo de Movimiento Cierre, la Fecha de Cierre debe ser mayor a la Fecha de Solicitud en el número de lista {numeroLista}";
                                }
                                else
                                {                                    
                                    if (dateFechaCierre.Subtract(dateFechaSolicitud).Days < 3)
                                        esExtemporanea = true;
                                }
                            }
                        }

                        if (tipoMovimientoId == 5)
                        {
                            //Actualización de Parámetros
                            var esPrecioUnidad = !string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioUnidad"].ToString());
                            var esPrecioDisplay = !string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioDisplay"].ToString());
                            var esPrecioCaja = !string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioCaja"].ToString());

                            if (datos["UnidadMedidaProductos"].ToString().ToLower().Equals("cj"))
                                error = esPrecioUnidad || esPrecioDisplay ? $"\nSolo se espera el PRECIO CAJA" : "";

                            if (datos["UnidadMedidaProductos"].ToString().ToLower().Equals("dp"))
                                error = esPrecioUnidad || esPrecioCaja ? $"\nSolo se espera el PRECIO DISPLAY" : "";

                            if (datos["UnidadMedidaProductos"].ToString().ToLower().Equals("un"))
                                error = esPrecioDisplay || esPrecioCaja ? $"\nSolo se espera el PRECIO UNIDAD" : "";

                            if (error == "" && (esPrecioUnidad || esPrecioDisplay || esPrecioCaja))
                            {
                                string[] valuesMarca = datos["Marca"].ToString().Split('-');
                                var unidadMedidaId = esPrecioCaja ? 1 : esPrecioUnidad ? 2 : 3;
                                var dataListaPrecioProducto = new Dictionary<string, object>
                                { ["NumeroLista"] = numeroLista, ["UnidadMedidaId"] = unidadMedidaId, ["Marca"] = valuesMarca[0].Trim(), ["Referencia"] = valuesMarca[1].Trim() };
                                var listaDatos = Utilities.GetItem("ListaPrecioProducto_Sel", dataListaPrecioProducto);

                                error = listaDatos.Count == 0
                                    ? $"\nEl No. de Lista {numeroLista} no esta dado de alta o está inactivo en TPM, favor de validar"
                                    : "";

                                if (error == "")
                                {
                                    DateTime dateFechaInicio = DateTime.Now;
                                    DateTime dateFechaCierre = DateTime.Now;

                                    //Validar FECHA de CIERRE para tipos de movimientos Cierre

                                    error = ValidaFechaCierre(listaPrecios[indexListaPrecio]["FechaFin"].ToString(), numeroLista);
                                    
                                    if(error == "")
                                    {
                                        dateFechaCierre = DateTime.ParseExact(listaPrecios[indexListaPrecio]["FechaFin"].ToString(), "MM/dd/yyyy", CultureInfo.InvariantCulture);
                                        listaPrecios[indexListaPrecio]["FechaFin"] = dateFechaCierre.Year.ToString() + CheckValuePartDate(dateFechaCierre.Month.ToString()) + CheckValuePartDate(dateFechaCierre.Day.ToString());
                                        listaPrecios[indexListaPrecio]["FechaFinVisible"] = CheckValuePartDate(dateFechaCierre.Day.ToString()) + "/" + CheckValuePartDate(dateFechaCierre.Month.ToString()) + "/" + dateFechaCierre.Year.ToString();

                                    }

                                    //Validar FECHA DE INICIO para tipos de movimientos Creaciones, Reactivaciones, Actualizaciones, Ampliaciones
                                    if (error == "")
                                    {                                       
                                        error = ValidaFechaInicio(listaPrecios[indexListaPrecio]["FechaInicio"].ToString(), numeroLista);

                                        if(error == "")
                                        {
                                            dateFechaInicio = DateTime.ParseExact(listaPrecios[indexListaPrecio]["FechaInicio"].ToString(), "MM/dd/yyyy", CultureInfo.InvariantCulture);
                                            listaPrecios[indexListaPrecio]["FechaInicio"] = dateFechaInicio.Year.ToString() + CheckValuePartDate(dateFechaInicio.Month.ToString()) + CheckValuePartDate(dateFechaInicio.Day.ToString());
                                            listaPrecios[indexListaPrecio]["FechaInicioVisible"] = CheckValuePartDate(dateFechaInicio.Day.ToString()) + "/" + CheckValuePartDate(dateFechaInicio.Month.ToString()) + "/" + dateFechaInicio.Year.ToString();

                                            if (dateFechaInicio > dateFechaCierre)
                                            {
                                                error = $"\nLa Fecha de Inicio debe ser menor a la Fecha de Cierre en el número de lista {numeroLista}";
                                            }
                                            else if(dateFechaSolicitud > dateFechaInicio)
                                            {
                                                error = $"\nEn todos los Tipo de Movimientos (excepto Cierre), la Fecha de Inicio debe ser mayor a la Fecha de Solicitud en el número de lista {numeroLista}";
                                            }
                                            else
                                            {
                                                if (ws.Cells["E11"].Text == "ACTUALIZACION DE PARAMETROS" && dateFechaInicio.Subtract(dateFechaSolicitud).Days < 5)
                                                    esExtemporanea = true;
                                            }

                                        }
                                    }

                                    //Obtener el texto que representa el canal
                                    //this.almacenesCanal = ws.Cells[i, 1].Text;

                                    BuscaCanalPorNumeroLista(numeroLista);
                                                                        
                                    var columanPrecio = esPrecioUnidad ? 4 : esPrecioDisplay ? 5 : 6;

                                    if (!string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioUnidad"].ToString()) && !string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioDisplay"].ToString()) && !string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioCaja"].ToString()))
                                    {
                                        error = error + $"\nSolo se permite informar un Precio para el número de lista {numeroLista}";
                                    }
                                    else if (!string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioUnidad"].ToString()))
                                    {
                                        atLeastOnePrecioUnidad = true;
                                    }
                                    else if (!string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioDisplay"].ToString()))
                                    {
                                        atLeastOnePrecioDisplay = true;
                                    }
                                    else if (!string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioCaja"].ToString()))
                                    {
                                        atLeastOnePrecioCaja = true;
                                    }

                                    var propiedadPrecio = esPrecioUnidad ? "PrecioUnidad" : esPrecioDisplay ? "PrecioDisplay" : "PrecioCaja";

                                    //Validar que los montos sean menores al que se encuentra en base de datos TPM
                                    error = error + ValidaPrecio(esPrecioUnidad, esPrecioDisplay, esPrecioCaja, propiedadPrecio, listaDatos, listaPrecios[indexListaPrecio]["PrecioUnidad"].ToString(), listaPrecios[indexListaPrecio]["PrecioDisplay"].ToString(), listaPrecios[indexListaPrecio]["PrecioCaja"].ToString(), listaPrecios[indexListaPrecio]["NumeroLista"].ToString());

                                    if (esPrecioUnidad)                                    
                                        if (txtPrecioUnidad == "")
                                            txtPrecioUnidad = listaPrecios[indexListaPrecio]["PrecioUnidad"].ToString().Replace("$", "");
                                        else if (txtPrecioUnidad != listaPrecios[indexListaPrecio]["PrecioUnidad"].ToString().Replace("$", ""))
                                            error = error + $"\nSolo se permite un único precio unidad en todos los números de lista, favor de revisar";
                                    
                                    if (esPrecioDisplay)                                    
                                        if (txtPrecioDisplay == "")
                                            txtPrecioDisplay = listaPrecios[indexListaPrecio]["PrecioDisplay"].ToString().Replace("$", "");
                                        else if (txtPrecioDisplay != listaPrecios[indexListaPrecio]["PrecioDisplay"].ToString().Replace("$", ""))
                                            error = error + $"\nSolo se permite un único precio display en todos los números de lista, favor de revisar";
                                    
                                    if (esPrecioCaja)                                    
                                        if (txtPrecioCaja == "")
                                            txtPrecioCaja = listaPrecios[indexListaPrecio]["PrecioCaja"].ToString().Replace("$", "");
                                        else if (txtPrecioCaja != listaPrecios[indexListaPrecio]["PrecioCaja"].ToString().Replace("$", ""))
                                            error = error + $"\nSolo se permite un único precio caja en todos los números de lista, favor de revisar";
                                    
                                    decimal precioPromocion = error == "" ? Convert.ToDecimal(listaPrecios[indexListaPrecio][propiedadPrecio].ToString().Replace("$", "")) : 0;

                                    var descuento = Utilities.GetDecimal(listaDatos, propiedadPrecio) - precioPromocion;
                                    
                                    datos["Descuento"] = descuento;
                                    listaPrecios[indexListaPrecio]["Descuento"] = descuento;
                                    listaPrecios[indexListaPrecio]["PrecioPromocion"] = precioPromocion;
                                }
                            }

                            if (!esPrecioUnidad && !esPrecioDisplay && !esPrecioCaja)
                            {
                                error = error + $"\nSolo se permite informar un Precio para el número de lista {listaPrecios[indexListaPrecio]["NumeroLista"].ToString()}";
                            }
                            else if (esPrecioUnidad)
                            {
                                atLeastOnePrecioUnidad = true;
                            }
                            else if (esPrecioDisplay)
                            {
                                atLeastOnePrecioDisplay = true;
                            }
                            else if (esPrecioCaja)
                            {
                                atLeastOnePrecioCaja = true;
                            }


                        }
                    }

                    indexListaPrecio++;
                }

                if (esExtemporanea)
                {
                    datos["EsExtemporanea"] = "1";

                    if (String.IsNullOrEmpty(datos["Justificacion"].ToString()))
                        error = error + "\nDebido a que es extemporánea, la justificación es requerida";
                    else if (datos["Justificacion"].ToString().Length > 1000)
                        error = error + "\nDebido a que es extemporánea, la justificación debe tener un máx. de 1000 caracteres";
                }
                else
                {
                    datos["EsExtemporanea"] = "0";
                    datos["Justificacion"] = "";
                }

                if (errorListaPrecio == "" && error == "" && (tipoMovimientoId == 4 || tipoMovimientoId == 5))
                {
                    //if (this.listCanalIDs.Count > 1)
                    //{
                    //    error = "\nSe encontró más de un canal, solo se permiten números de lista de un solo canal";
                    //}
                    //else
                    //{
                    if (atLeastOnePrecioUnidad && umaCajaUnidad == "")
                    {
                        error = "\nSe encontró al menos un precio unidad en los numeros de lista, UMA DE CJ A U debe ser 1";
                    }

                    if (atLeastOnePrecioDisplay && umaCajaDisplay == "")
                    {
                        error = "\nSe encontró al menos un precio display en los numeros de lista, UMA DE CJ A DP debe ser 1";
                    }

                    if (atLeastOnePrecioCaja && (umaCajaUnidad != "" || umaCajaDisplay != ""))
                    {
                        error = "\nSe encontró al menos un precio caja en los numeros de lista, UMA DE CJ A DP y UMA DE CJ A U deben ser vacíos";
                    }
                    //}
                }
            }


            error = errorHeader + errorProducto + errorListaPrecio + error;

            return error;
        }

        private string ValidarPromocionReactivacionSinCreacion(ExcelWorksheet ws, Dictionary<string, object> datos, int activityId, int promocionId, int tipoMovimientoId, string tipoSolicitud, string marca, bool esSinCreacion)
        {
            string error = string.Empty;

            bool existenDiferenciasProductos = false;
            bool existenDiferenciasListaPrecios = false;

            string errorHeader = string.Empty;
            string errorProducto = string.Empty;
            string errorListaPrecio = string.Empty;
            //Info from Excel
            //List<Dictionary<string, object>> productos = (List<Dictionary<string, object>>)datos["Productos"];
            List<Dictionary<string, object>> listaPrecios = (List<Dictionary<string, object>>)datos["ListaPrecios"];
            
            int indexProducto = 0;
            //bool diferenciasProducto = false;                                    

            var marcaReferencias = new List<Dictionary<string, object>>();
            
            int indexListaPrecio = 0;

            if (listaPrecios.Count == 0)
                errorListaPrecio = "\nPara todos los tipos de movimiento se espera al menos un elemento en lista de precios";

            DateTime dateFechaSolicitud = DateTime.ParseExact(datos["FechaSolicitudExcel"].ToString(), CultureInfo.CurrentCulture.DateTimeFormat.ShortDatePattern, CultureInfo.InvariantCulture);

            bool atLeastOnePrecioUnidad = false;
            bool atLeastOnePrecioDisplay = false;
            bool atLeastOnePrecioCaja = false;

            string txtPrecioUnidad = string.Empty;
            string txtPrecioDisplay = string.Empty;
            string txtPrecioCaja = string.Empty;

            this.listCanalIDs.Clear();

            while (errorListaPrecio == "" && error == "" && indexListaPrecio < listaPrecios.Count)
            {
                var numeroLista = listaPrecios[indexListaPrecio]["NumeroLista"].ToString();

                var esPrecioUnidad = !string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioUnidad"].ToString());
                var esPrecioDisplay = !string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioDisplay"].ToString());
                var esPrecioCaja = !string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioCaja"].ToString());

                if (datos["UnidadMedidaProductos"].ToString().ToLower().Equals("cj"))
                    error = esPrecioUnidad || esPrecioDisplay ? $"\nSolo se espera el PRECIO CAJA" : "";

                if (datos["UnidadMedidaProductos"].ToString().ToLower().Equals("dp"))
                    error = esPrecioUnidad || esPrecioCaja ? $"\nSolo se espera el PRECIO DISPLAY" : "";

                if (datos["UnidadMedidaProductos"].ToString().ToLower().Equals("un"))
                    error = esPrecioDisplay || esPrecioCaja ? $"\nSolo se espera el PRECIO UNIDAD" : "";

                if (error == "" && (esPrecioUnidad || esPrecioDisplay || esPrecioCaja))
                {
                    string[] valuesMarca = datos["Marca"].ToString().Split('-');
                    var unidadMedidaId = esPrecioCaja ? 1 : esPrecioUnidad ? 2 : 3;
                    var dataListaPrecioProducto = new Dictionary<string, object>
                    { ["NumeroLista"] = numeroLista, ["UnidadMedidaId"] = unidadMedidaId, ["Marca"] = valuesMarca[0].Trim(), ["Referencia"] = valuesMarca[1].Trim() };
                    var listaDatos = Utilities.GetItem("ListaPrecioProducto_Sel", dataListaPrecioProducto);

                    error = listaDatos.Count == 0
                        ? $"\nEl No. de Lista {numeroLista} no esta dado de alta o está inactivo en TPM, favor de validar"
                        : "";

                    if (error == "")
                    {
                        var columanPrecio = esPrecioUnidad ? 4 : esPrecioDisplay ? 5 : 6;

                        if (!string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioUnidad"].ToString()) && !string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioDisplay"].ToString()) && !string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioCaja"].ToString()))
                        {
                            error = error + $"\nSolo se permite informar un Precio para el número de lista {numeroLista}";
                        }
                        else if (!string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioUnidad"].ToString()))
                        {
                            atLeastOnePrecioUnidad = true;
                        }
                        else if (!string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioDisplay"].ToString()))
                        {
                            atLeastOnePrecioDisplay = true;
                        }
                        else if (!string.IsNullOrEmpty(listaPrecios[indexListaPrecio]["PrecioCaja"].ToString()))
                        {
                            atLeastOnePrecioCaja = true;
                        }

                        var propiedadPrecio = esPrecioUnidad ? "PrecioUnidad" : esPrecioDisplay ? "PrecioDisplay" : "PrecioCaja";

                        //Validar que los montos sean menores al que se encuentra en base de datos TPM

                        error = error + ValidaPrecio(esPrecioUnidad, esPrecioDisplay, esPrecioCaja, propiedadPrecio, listaDatos, listaPrecios[indexListaPrecio]["PrecioUnidad"].ToString(), listaPrecios[indexListaPrecio]["PrecioDisplay"].ToString(), listaPrecios[indexListaPrecio]["PrecioCaja"].ToString(), listaPrecios[indexListaPrecio]["NumeroLista"].ToString());

                        if (esPrecioUnidad)                        
                            if (txtPrecioUnidad == "")
                                txtPrecioUnidad = listaPrecios[indexListaPrecio]["PrecioUnidad"].ToString().Replace("$", "");
                            else if (txtPrecioUnidad != listaPrecios[indexListaPrecio]["PrecioUnidad"].ToString().Replace("$", ""))
                                error = error + $"\nSolo se permite un único precio unidad en todos los números de lista, favor de revisar";

                        if (esPrecioDisplay)                        
                            if (txtPrecioDisplay == "")
                                txtPrecioDisplay = listaPrecios[indexListaPrecio]["PrecioDisplay"].ToString().Replace("$", "");
                            else if (txtPrecioDisplay != listaPrecios[indexListaPrecio]["PrecioDisplay"].ToString().Replace("$", ""))
                                error = error + $"\nSolo se permite un único precio display en todos los números de lista, favor de revisar";

                        if (esPrecioCaja)                        
                            if (txtPrecioCaja == "")
                                txtPrecioCaja = listaPrecios[indexListaPrecio]["PrecioCaja"].ToString().Replace("$", "");
                            else if (txtPrecioCaja != listaPrecios[indexListaPrecio]["PrecioCaja"].ToString().Replace("$", ""))
                                error = error + $"\nSolo se permite un único precio caja en todos los números de lista, favor de revisar";
                        
                        decimal precioPromocion = error == "" ? Convert.ToDecimal(listaPrecios[indexListaPrecio][propiedadPrecio].ToString().Replace("$", "")) : 0;

                        var descuento = Utilities.GetDecimal(listaDatos, propiedadPrecio) - precioPromocion;

                        datos["Descuento"] = descuento;
                        listaPrecios[indexListaPrecio]["Descuento"] = descuento;
                        listaPrecios[indexListaPrecio]["PrecioPromocion"] = precioPromocion;
                    }
                }

                if (!esPrecioUnidad && !esPrecioDisplay && !esPrecioCaja)
                {
                    error = error + $"\nSolo se permite informar un Precio para el número de lista {listaPrecios[indexListaPrecio]["NumeroLista"].ToString()}";
                }
                else if (esPrecioUnidad)
                {
                    atLeastOnePrecioUnidad = true;
                }
                else if (esPrecioDisplay)
                {
                    atLeastOnePrecioDisplay = true;
                }
                else if (esPrecioCaja)
                {
                    atLeastOnePrecioCaja = true;
                }

                if (error == "")
                {
                    DateTime dateFechaInicio = DateTime.Now;
                    DateTime dateFechaCierre = DateTime.Now;

                    //Validar FECHA de CIERRE para tipos de movimientos Cierre

                    error = ValidaFechaCierre(listaPrecios[indexListaPrecio]["FechaFin"].ToString(), numeroLista);

                    if(error == "")
                    {
                        dateFechaCierre = DateTime.ParseExact(listaPrecios[indexListaPrecio]["FechaFin"].ToString(), "MM/dd/yyyy", CultureInfo.InvariantCulture);
                        listaPrecios[indexListaPrecio]["FechaFin"] = dateFechaCierre.Year.ToString() + CheckValuePartDate(dateFechaCierre.Month.ToString()) + CheckValuePartDate(dateFechaCierre.Day.ToString());
                        listaPrecios[indexListaPrecio]["FechaFinVisible"] = CheckValuePartDate(dateFechaCierre.Day.ToString()) + "/" + CheckValuePartDate(dateFechaCierre.Month.ToString()) + "/" + dateFechaCierre.Year.ToString();

                    }

                    //Validar FECHA DE INICIO para tipos de movimientos Creaciones, Reactivaciones, Actualizaciones, Ampliaciones
                    if (error == "")
                    {
                        error = ValidaFechaInicio(listaPrecios[indexListaPrecio]["FechaInicio"].ToString(), numeroLista);
                        
                        if(error == "")
                        {
                            dateFechaInicio = DateTime.ParseExact(listaPrecios[indexListaPrecio]["FechaInicio"].ToString(), "MM/dd/yyyy", CultureInfo.InvariantCulture);
                            listaPrecios[indexListaPrecio]["FechaInicio"] = dateFechaInicio.Year.ToString() + CheckValuePartDate(dateFechaInicio.Month.ToString()) + CheckValuePartDate(dateFechaInicio.Day.ToString());
                            listaPrecios[indexListaPrecio]["FechaInicioVisible"] = CheckValuePartDate(dateFechaInicio.Day.ToString()) + "/" + CheckValuePartDate(dateFechaInicio.Month.ToString()) + "/" + dateFechaInicio.Year.ToString();

                            if (dateFechaInicio > dateFechaCierre)
                            {
                                error = $"\nLa Fecha de Inicio debe ser menor a la Fecha de Cierre en el número de lista {numeroLista}";
                            }
                            else if(dateFechaSolicitud > dateFechaInicio)
                            {
                                error = $"\nEn todos los Tipo de Movimientos (excepto Cierre), la Fecha de Inicio debe ser mayor a la Fecha de Solicitud en el número de lista {numeroLista}";
                            }
                            else
                            {
                                if (ws.Cells["E11"].Text == "REACTIVACION" && dateFechaSolicitud.Subtract(dateFechaInicio).Days > 7)
                                    esExtemporanea = true;
                            }

                        }
                    }
                }

                BuscaCanalPorNumeroLista(numeroLista);
                
                indexListaPrecio++;
            }

            if (esExtemporanea)
            {
                datos["EsExtemporanea"] = "1";

                if (String.IsNullOrEmpty(datos["Justificacion"].ToString()))
                    error = error + "\nDebido a que es extemporánea, la justificación es requerida";
                else if (datos["Justificacion"].ToString().Length > 1000)
                    error = error + "\nDebido a que es extemporánea, la justificación debe tener un máx. de 1000 caracteres";
            }
            else
            {
                datos["EsExtemporanea"] = "0";
                datos["Justificacion"] = "";
            }

            if (error == "")            
                if (this.listCanalIDs.Count > 1)                
                    error = "\nSe encontró más de un canal, solo se permiten números de lista de un solo canal";
            
            error = errorHeader + errorProducto + errorListaPrecio + error;

            return error;
        }
        private string CargarEstructuraComercial(ExcelWorksheet ws, Dictionary<string, object> datos, string marca, bool esEstructuraComercial)
        {
            var error = ValidarCargaPromocion(ws, marca);
            if (error != "") return error;

            var elementos = new List<Dictionary<string, object>>();
            error = ObtenerElementosPromocion(ws, elementos, datos, marca, esEstructuraComercial);
            if (error != "") return error;

            //error = ObtenerDatosPromocion(ws, datos, tipoSolicitud, tipoMovimiento, existeCodigoPromocion);
            datos["Productos"] = elementos;

            return error;
        }

        private string CargarPromocion(ExcelWorksheet ws, Dictionary<string, object> datos, string marca, string tipoSolicitud, int tipoSolicitudId, string tipoMovimiento, int tipoMovimientoId, string existeCodigoPromocion, int activityId)
        {
            var error = ValidarCargaPromocion(ws, marca);
            if (error != "") return error;

            error = ObtenerDatosPromocion(ws, datos, tipoSolicitud, tipoSolicitudId, tipoMovimiento, tipoMovimientoId, existeCodigoPromocion, activityId);
            if (error != "") return error;

            var elementos = new List<Dictionary<string, object>>();
            error = ObtenerElementosPromocion(ws, elementos, datos, marca);
            if (error != "") return error;

            var listas = new List<Dictionary<string, object>>();
            error = ObtenerListasPromocion(ws, listas, datos);

            //error = ObtenerDatosPromocion(ws, datos, tipoSolicitud, tipoMovimiento, existeCodigoPromocion);
            datos["Productos"] = elementos;
            datos["ListaPrecios"] = listas;

            return error;
        }
        private string ValidarCargaPromocion(ExcelWorksheet ws, string marca)
        {
            var error = String.IsNullOrEmpty(marca) ? "Favor de seleccionar la marca" : "";

            if (error != "") return error;

            var data = new Dictionary<string, object> { ["marca"] = marca };
            var marcaReferencias = Utilities.GetData("MarcaReferencia_Get", data);
            var tipoSolicitud = ws.Cells["D11"].Text;
            var marcaExcel = ws.Cells["F11"].Text;

            //error = tipoSolicitud.ToLower() == "promocion configurada"
            //    ? ""
            //    : "La carga debe ser una Promoción Configurada";

            //if (error != "") return error;

            var marcaCorrecta = false;

            foreach (var referencia in marcaReferencias)
            {
                if (string.Equals(referencia["Marca"].ToString(), marcaExcel, StringComparison.CurrentCultureIgnoreCase))
                    marcaCorrecta = true;
            }

            error = marcaCorrecta ? "" : "La marca de la carga es incorrecta, no coincide con la de la macro";

            return error;
        }

     
        private string ObtenerDatosPromocion(ExcelWorksheet ws, Dictionary<string, object> datos, string tipoSolicitud, int tipoSolicitudId, string tipoMovimiento, int tipoMovimientoId, string existeCodigoPromocion, int activityId)
        {
            var error = string.Empty;

            error = error + (String.IsNullOrEmpty(ws.Cells["F4"].Text) ? "\nEl Folio es requerido en la macro" : "");

            datos["Folio"] = ws.Cells["F4"].Text;

            error = error + (String.IsNullOrEmpty(ws.Cells["G4"].Text) ? "\nLa Fecha de Solicitud es requerida en la macro" : "");

            if (!IsValidDate(ws.Cells["G4"].Text, CultureInfo.CurrentCulture.DateTimeFormat.ShortDatePattern))
            {
                error = error + "\nFecha de Solicitud incorrecta, debe ser " + CultureInfo.CurrentCulture.DateTimeFormat.ShortDatePattern;
            }
            else
            {
                DateTime dateFechaSolicitud = DateTime.ParseExact(ws.Cells["G4"].Text, CultureInfo.CurrentCulture.DateTimeFormat.ShortDatePattern, CultureInfo.InvariantCulture);
                datos["FechaSolicitud"] = dateFechaSolicitud.Year.ToString() + CheckValuePartDate(dateFechaSolicitud.Month.ToString()) + CheckValuePartDate(dateFechaSolicitud.Day.ToString());
                datos["FechaSolicitudVisible"] = CheckValuePartDate(dateFechaSolicitud.Day.ToString()) + "/" + CheckValuePartDate(dateFechaSolicitud.Month.ToString()) + "/" + dateFechaSolicitud.Year.ToString();
            }

            error = error + (String.IsNullOrEmpty(ws.Cells["F8"].Text) ? "\nEl Nombre es requerido en la macro" : "");

            datos["Nombre"] = ws.Cells["F8"].Text;

            error = error + (String.IsNullOrEmpty(ws.Cells["C11"].Text) ? "\nLa Empresa es requerida en la macro" : "");

            esPromocionArmada = tipoSolicitud.ToLower() == "promocion armada";

            //if (tipoSolicitud.ToLower() == "promocion configurada")            
            error = error + (!ws.Cells["C11"].Text.ToLower().Contains("empresa (1501)") ? "\nEn promoción configurada/armada la empresa debe ser Magna (1501)" : "");

            datos["Empresa"] = ws.Cells["C11"].Text;

            datos["TipoSolicitud"] = tipoSolicitud;
            datos["TipoSolicitudId"] = tipoSolicitudId;

            datos["TipoMovimiento"] = ws.Cells["E11"].Text;
            datos["TipoMovimientoId"] = tipoMovimientoId;

            datos["CodigoPromocion"] = ws.Cells["F6"].Text;

            error = error + (String.IsNullOrEmpty(ws.Cells["F11"].Text) ? "\nLa Marca es requerida en la macro" : "");

            datos["Marca"] = ws.Cells["F11"].Text;

            datos["Linea"] = ws.Cells["B21"].Text;
            datos["Grupo"] = ws.Cells["C21"].Text;
            datos["Impuesto"] = ws.Cells["D21"].Text;
            datos["AlmacenPrincipal"] = ws.Cells["F21"].Text;
            datos["Tipo"] = ws.Cells["B23"].Text;
            datos["Planeador"] = ws.Cells["C23"].Text;

            error = error + (tipoSolicitud.ToUpper() == "PROMOCION ARMADA" && String.IsNullOrEmpty(ws.Cells["D23"].Text) ? "\nEn promoción armada el Código de Barras es requerido en la macro" : "");

            datos["CodigoBarras"] = ws.Cells["D23"].Text;

            datos["EstatusAdicional"] = ws.Cells["G21"].Text;
            datos["UnidadMedida"] = ws.Cells["E23"].Text;

            datos["UmaCajaDisplay"] = ws.Cells["F23"].Text;
            datos["UmaCajaUnidad"] = ws.Cells["G23"].Text;

            error = error + (String.IsNullOrEmpty(ws.Cells["E21"].Text) ? "\nLa Clase Impuesto es requerida en la macro" : "");

            datos["ClaseImpuesto"] = ws.Cells["E21"].Text;

            if (error != "") return error;

            return "";
        }
        private string ObtenerElementosPromocion(ExcelWorksheet ws, List<Dictionary<string, object>> elementos, Dictionary<string, object> datos, string marca, bool esEstructuraComercial = false)
        {
            var dataMarca = new Dictionary<string, object> { ["marca"] = marca };
            var marcaReferencias = Utilities.GetData("MarcaReferencia_Get", dataMarca);

            var error = "";
            var i = 33;

            if (!esEstructuraComercial)
            {
                if (ws.Cells[i, 2].Text == "" && (ws.Cells["E11"].Text == "CREACION" || ws.Cells["E11"].Text == "ACTUALIZACION DE PRECIOS" || ws.Cells["E11"].Text == "ACTUALIZACION DE PARAMETROS"))
                    error = error + $"\nPara el tipo de movimiento {ws.Cells["E11"].Text} se espera al menos un artículo en estructura comercial";

                if (ws.Cells[i, 2].Text != "" && (ws.Cells["E11"].Text == "REACTIVACION" || ws.Cells["E11"].Text == "CIERRE" || ws.Cells["E11"].Text == "AMPLIACION"))
                    error = error + $"\nPara el tipo de movimiento {ws.Cells["E11"].Text} no se permite estructura comercial";
            }
            else
            {
                if (ws.Cells[i, 2].Text == "")
                    error = error + $"\nSe espera al menos un artículo en Estructura Comercial";
            }

            List<decimal> listParticipacionVendido = new List<decimal>();
            List<decimal> listParticipacionRegalado = new List<decimal>();

            string umaCajaDisplay = ws.Cells["F23"].Text;
            string umaCajaUnidad = ws.Cells["G23"].Text;

            bool umaCajaDisplayRegalado = false;
            bool umaCajaUnidadRegalado = false;

            if (error == "")
            {
                while (ws.Cells[i, 2].Text != "" && error == "")
                {
                    if (String.IsNullOrEmpty(ws.Cells[i, 2].Text))
                        error = error + "\nEl No. Elementos PT es requerido en la macro";

                    if (String.IsNullOrEmpty(ws.Cells[i, 3].Text))
                        error = error + "\nLa Cantidad es requerida en la macro";

                    if (String.IsNullOrEmpty(ws.Cells[i, 4].Text))
                        error = error + "\nLa Unidad de Medida es requerida en la macro";

                    if (String.IsNullOrEmpty(ws.Cells[i, 5].Text))
                        error = error + "\nEl Tipo Elemento es requerido en la macro";

                    if (String.IsNullOrEmpty(ws.Cells[i, 6].Text))
                        error = error + "\nEl % Participación es requerido en la macro";
                    else if (!Decimal.TryParse(ws.Cells[i, 6].Text.Replace("%", ""), out decimal participacion))
                        error = error + $"\nPara la fila {i}, se espera un valor númerico en % Participación";

                    if (String.IsNullOrEmpty(ws.Cells[i, 7].Text))
                        error = error + "\nEl Código del Artículo es requerido en la macro";

                    if (String.IsNullOrEmpty(ws.Cells[i, 8].Text))
                        error = error + "\nLa Descripción del Artículo es requerida en la macro";

                    if (error == "")
                    {
                        var articulo = ws.Cells[i, 7].Text;
                        var data = new Dictionary<string, object> { ["TextoBusqueda"] = articulo };
                        var articulos = Utilities.GetData("ProductoActivity_Cmb", data);
                        var tipoElemento = ws.Cells[i, 5].Text;

                        error = articulos.Count == 0
                            ? $"\nEl artículo {articulo} no esta dado de alta en TPM favor de validar"
                            : "";

                        var marcaCorrecta = false;

                        foreach (var _articulo in articulos)
                        {
                            foreach (var referencia in marcaReferencias)
                            {
                                if (string.Equals(referencia["Marca"].ToString(), _articulo["Marca"].ToString(), StringComparison.CurrentCultureIgnoreCase))
                                    marcaCorrecta = true;
                            }
                        }

                        error = error + (marcaCorrecta ? "" : $"\nLa marca del artículo {articulo} debe ser igual a la marca de la macro");

                        //Veriricar UNIDAD DE MEDIDA por cada artículo
                        //UmaCajaDisplay y UmaCajaUnidad vacíos, UNIDAD DE MEDIDA igual a CJ
                        //UmaCajaDisplay igual 1 y UmaCajaUnidad vacío, UNIDAD DE MEDIDA igual a DP
                        //UmaCajaDisplay vacío y UmaCajaUnidad 1, UNIDAD DE MEDIDA igual a UN

                        if (!esPromocionArmada && umaCajaDisplay != "" && umaCajaDisplay != "1")
                            error = error + "\nEn promoción configurada, el valor UMA DE CJ A DP debe ser 1";

                        if (!esPromocionArmada && umaCajaUnidad != "" && umaCajaUnidad != "1")
                            error = error + "\nEn programación configurada, el valor UMA DE CJ A U debe ser 1";

                        //Si el elemnto es de tipo vendido, esta será la unidad de medida que se pondrá en la cabecera
                        decimal participacion = Convert.ToDecimal(ws.Cells[i, 6].Text.Replace("%", ""));
                        bool esVendido = false;
                        string unidadMedidad = string.Empty;

                        if (tipoElemento.ToLower() == "vendido")
                        {
                            error = error + (participacion % 1 != 0 ? $"\nPorcetanje de Participación incorrecto, solo se permiten números enteros en el artículo {articulo}" : "");

                            if (unidadMedidad == "")
                                unidadMedidad = ws.Cells[i, 4].Text;
                            else if (unidadMedidad != ws.Cells[i, 4].Text)
                                error = error + $"\nSolo se permite una misma unidad de medida en todos los productos VENDIDOS";

                            esVendido = true;
                            datos["UnidadMedidaProductos"] = ws.Cells[i, 4].Text;

                            listParticipacionVendido.Add(participacion);
                        }
                        else if (tipoElemento.ToLower() == "regalado")
                        {
                            if (ws.Cells[i, 4].Text.ToLower().Equals("un"))
                                umaCajaUnidadRegalado = true;
                            else if (ws.Cells[i, 4].Text.ToLower().Equals("dp"))
                                umaCajaDisplayRegalado = true;

                            listParticipacionRegalado.Add(participacion);
                        }
                        else
                        {
                            error = error + $"\nSolo se permiten los tipos de elemento VENDIDO ó REGALADO en el artículo {articulo}";
                        }

                        if (error == "")
                        {
                            var elemento = new Dictionary<string, object>
                            {
                                ["NumeroProducto"] = ws.Cells[i, 2].Text,
                                ["Cantidad"] = ws.Cells[i, 3].Text,
                                ["UnidadMedida"] = ws.Cells[i, 4].Text,
                                ["TipoElemento"] = tipoElemento,
                                ["Participacion"] = participacion,
                                ["Codigo"] = ws.Cells[i, 7].Text,
                                ["Producto"] = ws.Cells[i, 8].Text,
                                ["EsVendido"] = esVendido
                            };

                            elementos.Add(elemento);
                        }

                        i++;
                    }


                }

                //if (datos["UnidadMedidaProductos"].ToString().ToLower().Equals(datos["UnidadMedida"].ToString().ToLower()))
                //{
                if (umaCajaDisplay == "" && datos["UnidadMedidaProductos"].ToString().ToLower().Equals("dp"))
                    error = error + "\nSe espera " + (esPromocionArmada ? "valor" : "el valor 1") + " en el campo UMA DE CJ A DP";
                else if (umaCajaUnidad == "" && datos["UnidadMedidaProductos"].ToString().ToLower().Equals("un"))
                    error = error + "\nSe espera " + (esPromocionArmada ? "valor" : "el valor 1") + " en el campo UMA DE CJ A U";

                if (listParticipacionVendido.Count > 1 && listParticipacionVendido.Sum() != 100)
                    error = error + "\nEl total del porcentaje de participación para los tipos de elementos VENDIDO debe ser 100%";

                if (listParticipacionRegalado.Count > 1 && listParticipacionRegalado.Sum() != 0)
                    error = error + "\nEl total del porcentaje de participación para los tipos de elementos REGALADO debe ser 0%";
                //}
                //else
                //{
                //    error = error + "\nLa UM debe ser igual a la Unidad de Medida de los tipos de elementos VENDIDO";
                //}
            }

            return error;
        }
        private string ObtenerListasPromocion(ExcelWorksheet ws, List<Dictionary<string, object>> listas, Dictionary<string, object> datos)
        {

            var error = "";
            var i = 32;

            //Se pone un límite de 300 por si no encuentra la palabra no. de lista
            while (ws.Cells[i, 2].Text.ToLower() != "no. de lista" && i < 300)
                i++;

            if (ws.Cells[i, 2].Text.ToLower() != "no. de lista") return "El archivo no contiene No. de Lista";

            i += 2;

            string umaCajaDisplay = ws.Cells["F23"].Text;
            string umaCajaUnidad = ws.Cells["G23"].Text;

            bool atLeastOnePrecioUnidad = false;
            bool atLeastOnePrecioDisplay = false;
            bool atLeastOnePrecioCaja = false;

            DateTime dateFechaSolicitud = DateTime.ParseExact(ws.Cells["G4"].Text, CultureInfo.CurrentCulture.DateTimeFormat.ShortDatePattern, CultureInfo.InvariantCulture);
            esExtemporanea = false;

            string txtPrecioUnidad = string.Empty;
            string txtPrecioDisplay = string.Empty;
            string txtPrecioCaja = string.Empty;

            this.listCanalIDs.Clear();

            while (ws.Cells[i, 2].Text != "" && error == "")
            {
                var numeroLista = ws.Cells[i, 2].Text;
                var esPrecioUnidad = !string.IsNullOrEmpty(ws.Cells[i, 4].Text);
                var esPrecioDisplay = !string.IsNullOrEmpty(ws.Cells[i, 5].Text);
                var esPrecioCaja = !string.IsNullOrEmpty(ws.Cells[i, 6].Text);

                if (umaCajaDisplay == "" && umaCajaUnidad == "")
                    error = esPrecioUnidad || esPrecioDisplay || !esPrecioCaja? $"\nSolo se espera el PRECIO CAJA" : "";

                if (umaCajaDisplay != "" && umaCajaUnidad == "")
                    error = esPrecioUnidad || esPrecioCaja || !esPrecioDisplay ? $"\nSolo se espera el PRECIO DISPLAY" : "";

                if (umaCajaDisplay == "" && umaCajaUnidad != "")
                    error = esPrecioDisplay || esPrecioCaja || !esPrecioUnidad ? $"\nSolo se espera el PRECIO UNIDAD" : "";

                if (error == "" && (esPrecioUnidad || esPrecioDisplay || esPrecioCaja))
                {
                    string[] valuesMarca = datos["Marca"].ToString().Split('-');
                    var unidadMedidaId = esPrecioCaja ? 1 : esPrecioUnidad ? 2 : 3;
                    var data = new Dictionary<string, object>
                    { ["NumeroLista"] = numeroLista, ["UnidadMedidaId"] = unidadMedidaId, ["Marca"] = valuesMarca[0].Trim(), ["Referencia"] = valuesMarca[1].Trim() };
                    var listaDatos = Utilities.GetItem("ListaPrecioProducto_Sel", data);

                    error = listaDatos.Count == 0
                        ? $"\nEl No. de Lista {numeroLista} no esta dado de alta o está inactivo en TPM, favor de validar"
                        : "";

                    if (error == "")
                    {
                        DateTime dateFechaInicio = DateTime.Now;
                        DateTime dateFechaCierre = DateTime.Now;

                        //Validar FECHA de CIERRE para tipos de movimientos Cierre

                        error = ValidaFechaCierre(ws.Cells[i, 8].Text, numeroLista);

                        if (error == "")
                        {
                            dateFechaCierre = DateTime.ParseExact(ws.Cells[i, 8].Text, "MM/dd/yyyy", CultureInfo.InvariantCulture);


                            if (ws.Cells["E11"].Text == "CIERRE" && dateFechaCierre < dateFechaSolicitud)// || dateFechaCierre.Subtract(dateFechaSolicitud).Days < 7)
                            {
                                error = error + $"\nEn Tipo de Movimiento Cierre, la Fecha de Cierre debe ser mayor a la Fecha de Solicitud en el número de lista {numeroLista}";
                            }
                            else
                            {
                                //if (ws.Cells["E11"].Text == "CIERRE" && ws.Cells["E11"].Text == "CIERRE" && dateFechaSolicitud.Subtract(dateFechaCierre).Days > 3)
                                if (ws.Cells["E11"].Text == "CIERRE" && ws.Cells["E11"].Text == "CIERRE" && dateFechaCierre.Subtract(dateFechaSolicitud).Days < 3)
                                    esExtemporanea = true;
                            }

                        }

                        //Validar FECHA DE INICIO para tipos de movimientos Creaciones, Reactivaciones, Actualizaciones, Ampliaciones

                        error = error + ValidaFechaInicio(ws.Cells[i, 7].Text, numeroLista);

                        if (error == "")
                        {
                            dateFechaInicio = DateTime.ParseExact(ws.Cells[i, 7].Text, "MM/dd/yyyy", CultureInfo.InvariantCulture);

                            if (dateFechaInicio > dateFechaCierre)
                            {
                                error = $"\nLa Fecha de Inicio debe ser menor a la Fecha de Cierre en el número de lista {numeroLista}";
                            }
                            else if (ws.Cells["E11"].Text != "CIERRE" && dateFechaSolicitud > dateFechaInicio)
                            {
                                error = $"\nEn todos los Tipo de Movimientos (excepto Cierre), la Fecha de Inicio debe ser mayor a la Fecha de Solicitud en el número de lista {numeroLista}";
                            }
                            else
                            {
                                if (ws.Cells["E11"].Text != "CIERRE" && (ws.Cells["E11"].Text == "CREACION" && dateFechaInicio.Subtract(dateFechaSolicitud).Days < 10
                                || ws.Cells["E11"].Text == "REACTIVACION" && dateFechaInicio.Subtract(dateFechaSolicitud).Days < 7
                                || (ws.Cells["E11"].Text == "ACTUALIZACION DE PRECIOS" || ws.Cells["E11"].Text == "ACTUALIZACION DE PARAMETROS") && dateFechaInicio.Subtract(dateFechaSolicitud).Days < 5
                                || ws.Cells["E11"].Text == "AMPLIACION" && dateFechaInicio.Subtract(dateFechaSolicitud).Days < 3))
                                    esExtemporanea = true;
                            }
                        }

                        //Obtener el texto que representa el canal
                        this.almacenesCanal = ws.Cells[i, 1].Text;

                        BuscaCanalPorNumeroLista(ws.Cells[i, 2].Text);

                        var columanPrecio = esPrecioUnidad ? 4 : esPrecioDisplay ? 5 : 6;

                        if (!string.IsNullOrEmpty(ws.Cells[i, 4].Text) && !string.IsNullOrEmpty(ws.Cells[i, 5].Text) && !string.IsNullOrEmpty(ws.Cells[i, 6].Text))
                        {
                            error = error + $"\nSolo se permite informar un Precio para el número de lista {numeroLista}";
                        }
                        else if (!string.IsNullOrEmpty(ws.Cells[i, 4].Text))
                        {
                            atLeastOnePrecioUnidad = true;
                        }
                        else if (!string.IsNullOrEmpty(ws.Cells[i, 5].Text))
                        {
                            atLeastOnePrecioDisplay = true;
                        }
                        else if (!string.IsNullOrEmpty(ws.Cells[i, 6].Text))
                        {
                            atLeastOnePrecioCaja = true;
                        }

                        //var precioPromocion = 20;
                        var propiedadPrecio = esPrecioUnidad ? "PrecioUnidad" : esPrecioDisplay ? "PrecioDisplay" : "PrecioCaja";

                        //Validar que los montos sean menores al que se encuentra en base de datos TPM

                        error = error + ValidaPrecio(esPrecioUnidad, esPrecioDisplay, esPrecioCaja, propiedadPrecio, listaDatos, ws.Cells[i, 4].Text, ws.Cells[i, 5].Text, ws.Cells[i, 6].Text, numeroLista);

                        if (esPrecioUnidad)
                            if (txtPrecioUnidad == "")
                                txtPrecioUnidad = ws.Cells[i, 4].Text.Replace("$", "");
                            else if (txtPrecioUnidad != ws.Cells[i, 4].Text.Replace("$", ""))
                                error = error + $"\nSolo se permite un único precio unidad en todos los números de lista, favor de revisar";

                        if (esPrecioDisplay)
                            if (txtPrecioDisplay == "")
                                txtPrecioDisplay = ws.Cells[i, 5].Text.Replace("$", "");
                            else if (txtPrecioDisplay != ws.Cells[i, 5].Text.Replace("$", ""))
                                error = error + $"\nSolo se permite un único precio display en todos los números de lista, favor de revisar";

                        if (esPrecioCaja)
                            if (txtPrecioCaja == "")
                                txtPrecioCaja = ws.Cells[i, 6].Text.Replace("$", "");
                            else if (txtPrecioCaja != ws.Cells[i, 6].Text.Replace("$", ""))
                                error = error + $"\nSolo se permite un único precio caja en todos los números de lista, favor de revisar";

                        decimal precioPromocion = error == "" ? Convert.ToDecimal(ws.Cells[i, columanPrecio].Text.Replace("$", "")) : 0;

                        var descuento = Utilities.GetDecimal(listaDatos, propiedadPrecio) - precioPromocion;

                        datos["Descuento"] = descuento;

                        var lista = new Dictionary<string, object>
                        {
                            ["NumeroLista"] = ws.Cells[i, 2].Text,
                            ["Cliente"] = ws.Cells[i, 3].Text,
                            //["PrecioUnidad"] = listaDatos["PrecioUnidad"],
                            //["PrecioDisplay"] = listaDatos["PrecioDisplay"],
                            //["PrecioCaja"] = listaDatos["PrecioCaja"],
                            ["PrecioUnidad"] = ws.Cells[i, 4].Text.Replace("$", ""),
                            ["PrecioDisplay"] = ws.Cells[i, 5].Text.Replace("$", ""),
                            ["PrecioCaja"] = ws.Cells[i, 6].Text.Replace("$", ""),
                            ["Descuento"] = descuento,
                            ["PrecioPromocion"] = precioPromocion,
                            ["FechaInicio"] = dateFechaInicio.Year.ToString() + CheckValuePartDate(dateFechaInicio.Month.ToString()) + CheckValuePartDate(dateFechaInicio.Day.ToString()),
                            ["FechaFin"] = dateFechaCierre.Year.ToString() + CheckValuePartDate(dateFechaCierre.Month.ToString()) + CheckValuePartDate(dateFechaCierre.Day.ToString()),
                            ["FechaInicioVisible"] = CheckValuePartDate(dateFechaInicio.Day.ToString()) + "/" + CheckValuePartDate(dateFechaInicio.Month.ToString()) + "/" + dateFechaInicio.Year.ToString(),
                            ["FechaFinVisible"] = CheckValuePartDate(dateFechaCierre.Day.ToString()) + "/" + CheckValuePartDate(dateFechaCierre.Month.ToString()) + "/" + dateFechaCierre.Year.ToString()
                        };

                        listas.Add(lista);
                    }
                }

                i++;
            }

            if (esExtemporanea)
            {
                datos["EsExtemporanea"] = "1";

                if (String.IsNullOrEmpty(ws.Cells["E97"].Text))
                    error = error + (String.IsNullOrEmpty(ws.Cells["E97"].Text) ? "\nDebido a que es extemporánea, la justificación es requerida" : "");
                else if (ws.Cells["E97"].Text.Length > 1000)
                    error = error + "\nDebido a que es extemporánea, la justificación debe tener un máx. de 1000 caracteres";
                else
                    datos["Justificacion"] = ws.Cells["E97"].Text;
            }
            else
            {
                datos["EsExtemporanea"] = "0";
                datos["Justificacion"] = "";
            }


            if (error == "")
            {
                if (this.listCanalIDs.Count > 1)
                {
                    error = "\nSe encontró más de un canal, solo se permiten números de lista de un solo canal";
                }
                else
                {
                    if (atLeastOnePrecioUnidad && umaCajaUnidad == "")
                    {
                        error = "\nSe encontró al menos un precio unidad en los numeros de lista, UMA DE CJ A U debe ser 1";
                    }

                    if (atLeastOnePrecioDisplay && umaCajaDisplay == "")
                    {
                        error = "\nSe encontró al menos un precio display en los numeros de lista, UMA DE CJ A DP debe ser 1";
                    }

                    if (atLeastOnePrecioCaja && (umaCajaUnidad != "" || umaCajaDisplay != ""))
                    {
                        error = "\nSe encontró al menos un precio caja en los numeros de lista, UMA DE CJ A DP y UMA DE CJ A U deben ser vacíos";
                    }
                }
            }

            return error;
        }

        private string CargarPromocionSinValidar(ExcelWorksheet ws, Dictionary<string, object> datos, string marca, string tipoSolicitud, int tipoSolicitudId, string tipoMovimiento, int tipoMovimientoId, string existeCodigoPromocion, int activityId, bool esSinCreacion, string codigoPromocion)
        {

            var error = ObtenerDatosPromocionSinValidar(ws, datos, tipoSolicitud, tipoSolicitudId, tipoMovimiento, tipoMovimientoId, existeCodigoPromocion, activityId, esSinCreacion, codigoPromocion);
            if (error != "") return error;

            var elementos = new List<Dictionary<string, object>>();
            error = ObtenerElementosPromocionSinValidar(ws, elementos, datos, marca);
            if (error != "") return error;

            var listas = new List<Dictionary<string, object>>();
            error = ObtenerListasPromocionSinValidar(ws, listas, datos);
            if (error != "") return error;

            //error = ObtenerDatosPromocion(ws, datos, tipoSolicitud, tipoMovimiento, existeCodigoPromocion);
            if (!esSinCreacion)
                datos["Productos"] = elementos;

            datos["ListaPrecios"] = listas;

            return error;
        }
        private string ObtenerDatosPromocionSinValidar(ExcelWorksheet ws, Dictionary<string, object> datos, string tipoSolicitud, int tipoSolicitudId, string tipoMovimiento, int tipoMovimientoId, string existeCodigoPromocion, int activityId, bool esSinCreacion, string codigoPromocion)
        {
            var error = string.Empty;

            datos["Folio"] = ws.Cells["F4"].Text;

            if (!IsValidDate(ws.Cells["G4"].Text, CultureInfo.CurrentCulture.DateTimeFormat.ShortDatePattern))
            {
                error = error + "\nFecha de Solicitud incorrecta, debe ser " + CultureInfo.CurrentCulture.DateTimeFormat.ShortDatePattern;
            }
            else
            {
                DateTime dateFechaSolicitud = DateTime.ParseExact(ws.Cells["G4"].Text, CultureInfo.CurrentCulture.DateTimeFormat.ShortDatePattern, CultureInfo.InvariantCulture);
                datos["FechaSolicitud"] = dateFechaSolicitud.Year.ToString() + CheckValuePartDate(dateFechaSolicitud.Month.ToString()) + CheckValuePartDate(dateFechaSolicitud.Day.ToString());
                datos["FechaSolicitudExcel"] = ws.Cells["G4"].Text;
                datos["FechaSolicitudVisible"] = CheckValuePartDate(dateFechaSolicitud.Day.ToString()) + "/" + CheckValuePartDate(dateFechaSolicitud.Month.ToString()) + "/" + dateFechaSolicitud.Year.ToString();
            }

            datos["Nombre"] = ws.Cells["F8"].Text;

            datos["Empresa"] = ws.Cells["C11"].Text;

            datos["TipoSolicitud"] = tipoSolicitud;
            datos["TipoSolicitudId"] = tipoSolicitudId;

            datos["TipoMovimiento"] = ws.Cells["E11"].Text;
            datos["TipoMovimientoId"] = tipoMovimientoId;

            datos["CodigoPromocion"] = ws.Cells["F6"].Text;

            if (esSinCreacion && !datos["CodigoPromocion"].ToString().ToLower().Equals(codigoPromocion.ToLower()))
                error = error + "\nEl Código de Promoción es diferente a " + codigoPromocion;

            datos["Marca"] = ws.Cells["F11"].Text;

            datos["Linea"] = ws.Cells["B21"].Text;
            datos["Grupo"] = ws.Cells["C21"].Text;
            datos["Impuesto"] = ws.Cells["D21"].Text;
            datos["AlmacenPrincipal"] = ws.Cells["F21"].Text;
            datos["Tipo"] = ws.Cells["B23"].Text;
            datos["Planeador"] = ws.Cells["C23"].Text;

            datos["CodigoBarras"] = ws.Cells["D23"].Text;

            datos["EstatusAdicional"] = ws.Cells["G21"].Text;
            datos["UnidadMedida"] = ws.Cells["E23"].Text;

            datos["UmaCajaDisplay"] = ws.Cells["F23"].Text;
            datos["UmaCajaUnidad"] = ws.Cells["G23"].Text;

            datos["ClaseImpuesto"] = ws.Cells["E21"].Text;

            return error;
        }
        private string ObtenerElementosPromocionSinValidar(ExcelWorksheet ws, List<Dictionary<string, object>> elementos, Dictionary<string, object> datos, string marca)
        {
            var i = 33;

            while (ws.Cells[i, 2].Text != "")
            {

                //Si el elemnto es de tipo vendido, esta será la unidad de medida que se pondrá en la cabecera
                decimal participacion = Convert.ToDecimal(ws.Cells[i, 6].Text.Replace("%", ""));
                bool esVendido = false;

                if (ws.Cells[i, 5].Text.ToLower() == "vendido")
                {
                    esVendido = true;
                    datos["UnidadMedidaProductos"] = ws.Cells[i, 4].Text;
                }

                var elemento = new Dictionary<string, object>
                {
                    ["NumeroProducto"] = ws.Cells[i, 2].Text,
                    ["Cantidad"] = ws.Cells[i, 3].Text,
                    ["UnidadMedida"] = ws.Cells[i, 4].Text,
                    ["TipoElemento"] = ws.Cells[i, 5].Text,
                    ["Participacion"] = ws.Cells[i, 6].Text.Replace("%", ""),
                    ["Codigo"] = ws.Cells[i, 7].Text,
                    ["Producto"] = ws.Cells[i, 8].Text,
                    ["EsVendido"] = esVendido
                };

                elementos.Add(elemento);

                i++;

            }

            return "";
        }
        private string ObtenerListasPromocionSinValidar(ExcelWorksheet ws, List<Dictionary<string, object>> listas, Dictionary<string, object> datos)
        {
            var i = 32;

            //Se pone un límite de 300 por si no encuentra la palabra no. de lista
            while (ws.Cells[i, 2].Text.ToLower() != "no. de lista" && i < 300)
                i++;

            if (ws.Cells[i, 2].Text.ToLower() != "no. de lista") return "El archivo no contiene No. de Lista";

            i += 2;

            while (ws.Cells[i, 2].Text != "")
            {

                //Obtener el texto que representa el canal
                this.almacenesCanal = ws.Cells[i, 1].Text;

                //Obtener justificación, la cual es requerida cuando sea extemporanea
                datos["Justificacion"] = ws.Cells["E97"].Text;

                //var precioPromocion = Convert.ToDecimal(ws.Cells[i, columanPrecio].Value);
                var precioPromocion = 20;

                //var descuento = Utilities.GetDecimal(listaDatos, propiedadPrecio) - precioPromocion;

                var lista = new Dictionary<string, object>
                {
                    ["NumeroLista"] = ws.Cells[i, 2].Text,
                    ["Cliente"] = ws.Cells[i, 3].Text,
                    ["PrecioUnidad"] = ws.Cells[i, 4].Text.Replace("$", ""),
                    ["PrecioDisplay"] = ws.Cells[i, 5].Text.Replace("$", ""),
                    ["PrecioCaja"] = ws.Cells[i, 6].Text.Replace("$", ""),
                    ["Descuento"] = 0,
                    ["PrecioPromocion"] = precioPromocion,
                    ["FechaInicio"] = ws.Cells[i, 7].Text,
                    ["FechaFin"] = ws.Cells[i, 8].Text
                };

                listas.Add(lista);

                i++;
            }


            return "";
        }
        
        private string CargarPresupuesto(ExcelWorksheet ws, Dictionary<string, object> data)
        {
            var error = "";
            var fila = 0;
            var header = new List<Dictionary<string, object>>();
            var listaDetalle = new List<Dictionary<string, object>>();
            var a = new logic_acces(BasePage.ConexionDB);
            //var sucursales =
            //    BasePage.GetDataFromSp("Empresa_Cmb", datos).Select(e => Utilities.GetInt(e, "EmpresaID")).ToList();
            //var empresas =
            //    BasePage.GetDataFromSp("Sucursal_Cmb", datos).Select(e => Utilities.GetInt(e, "SucursalID")).ToList();
            //var cuentasContables = BasePage.GetDataFromSp("CuentaContable_Cmb", datos);
            //var cuentasString = cuentasContables.Select(e => Utilities.GetString(e, "CuentaAlfanumerica")).ToList();

            try
            {
                fila = 2;
                string empresaId;

                do
                {
                    empresaId = ws.Cells[fila, 1].Text;

                    if (!string.IsNullOrEmpty(empresaId))
                    {
                        var datos = new Dictionary<string, object>();

                        var clasificacionId = ws.Cells[fila, 3].Text;
                        var cuentaContableId = ws.Cells[fila, 6].Text;
                        var sucursalId = ws.Cells[fila, 10].Text;

                        datos["EmpresaID"] = empresaId;
                        datos["SucursalID"] = sucursalId;
                        datos["ClasificacionID"] = clasificacionId;
                        datos["CuentaContableID"] = cuentaContableId;
                        //datos["CuentaContable"] = ws.Cells[fila, 4].Text;

                        //error += ValidarId(sucursales, sucursalId, "Sucursal", fila);
                        //error += ValidarId(empresas, empresaId, "Empresa", fila);
                        //error += ValidarCuentaContable(cuentasContables, cuentasString, datos, cuentaContable, "CuentaContableID", fila);

                        for (var i = 12; i < 24; i++)
                        {
                            var detalle = new Dictionary<string, object>();

                            detalle["EmpresaID"] = empresaId;
                            detalle["SucursalID"] = sucursalId;
                            detalle["ClasificacionID"] = clasificacionId;
                            detalle["CuentaContableID"] = cuentaContableId;

                            detalle["MesID"] = i - 11;
                            Utilities.GetDecimal(detalle, "MontoPresupuesto", ws.Cells[fila, i].Text);
                            listaDetalle.Add(detalle);
                        }

                        header.Add(datos);
                    }

                    fila++;
                } while (!string.IsNullOrEmpty(empresaId));

                data["Header"] = header;
                data["Detalle"] = listaDetalle;
            }
            catch (Exception ex)
            {
                error = "fila " + fila + ": " + ex.Message;
            }

            return error;
        }

        private string ValidarId(List<int> ids, string idString, string property, int fila)
        {
            int id;
            var error = "";
            if (int.TryParse(idString, out id))
            {
                if (ids.All(e => Convert.ToInt32(e) != id))
                {
                    error = "Fila " + fila + ": campo " + property + ", el id no esta dado de alta en la base de datos.\n ";
                }
            }
            else
            {
                error = "Fila " + fila + ": El campo " + property + " esta vacío o no es entero.\n ";
            }

            return error;
        }

        private string ValidarCuentaContable(List<Dictionary<string, object>> cuentas, List<string> cuentasString,
            Dictionary<string, object> data, string value, string property, int fila)
        {
            var error = "";

            var indexCuenta = cuentasString.BinarySearch(value);

            if (indexCuenta >= 0)
            {
                data[property] = cuentas[indexCuenta][property];
            }
            else
            {
                error = "Fila " + fila + ": campo " + property + ", la cuenta no esta dada de alta en la base de datos.\n ";
            }

            return error;
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}