using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Services;
using System.Web.Services;
using System.Collections;
using System.Configuration;
using System.Data;
using System.IO;
using logic;
using magnajs.Codes;
using logic.Class;
using System.Transactions;

namespace magnajs.Pages
{
    public partial class Profile : BasePage
    {
        public string ruta = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            this.Title = "";
            ruta = this.URL;
            this.RunJavascriptBeforeLoadPage("var UsuarioId = jQuery.parseJSON('" + HttpContext.Current.Session["UsuarioId"] + "');");

        }
        [WebMethod(EnableSession = true)]
        [ScriptMethod]
        static public Dictionary<string, object> Consultar(Dictionary<string, string> datos)
        {
            var page = new logic.BasePage();
            var a = new logic_acces(ConexionDB);
            var response = new Dictionary<string, object>();
            var noDatos = new Dictionary<string, string>();
            datos["UsuarioId"] = Convert.ToString(HttpContext.Current.Session["UsuarioId"]);
            DataTable Dt1 = a.ExecuteQuery("Usuario_Sel", datos).Tables[0];
            DataTable Dt2 = a.ExecuteQuery("Perfil_Sel", noDatos).Tables[0];
            //Respone 
            DataRow pathImgRow= Dt1.NewRow();
            datos["UID"] = Convert.ToString(Dt1.Rows[0]["UID"]);
            pathImgRow[Dt1.Rows.Count] = ConsultarRutaArchivoLocal(datos);

            Dt1.Rows.Add(pathImgRow); 

            response["Usuario"] = page.DataTableToMap(Dt1);
            response["Perfil"] = page.DataTableToMap(Dt2);

            return response;
        }
        [WebMethod(EnableSession = true)]
        [ScriptMethod]
        static public Dictionary<string, string> Guardar(Dictionary<string, string> datos)
        {
            var page = new logic.BasePage();
            var a = new logic_acces(ConexionDB);
            var response = new Dictionary<string, object>();


            Dictionary<string, string> datosActuales = new Dictionary<string, string>();
            using (TransactionScope scope = new TransactionScope())
            {
                datosActuales["UsuarioId"] = datos["UsuarioId"];
                datosActuales["Img"] = "";
                datosActuales["UID"] = "";

                a.ExecuteNonQuery("UsuarioImg_Sel", datosActuales);
                scope.Complete();
            }

          


            using (TransactionScope scope2 = new TransactionScope())
            {
                if (!datos.ContainsKey("UsuarioId"))
                    datos["UsuarioId"] = "0";
                if (datos["UsuarioId"] == "0")
                    datos["Active"] = "True";

                datos["Page"] = "Edicion";
                a.ExecuteNonQuery("Usuario_IU", datos);
                scope2.Complete();

                if (!(datosActuales["Img"] == datos["Img"] && datosActuales["UID"] == datos["UID"]))
                    GuardarArchivo(datos, datosActuales);
                else
                    HttpContext.Current.Session["MassiveConfirmation"] = null;
            }
            return datos;
        }

        private static string ConsultarRutaArchivoLocal(Dictionary<string, string> datos)
        {

            var rutaArchivo = ConfigurationManager.AppSettings["CarpetaArchivos"] + datos["UID"];
            var rutaCompletaArchivo = HttpContext.Current.Server.MapPath(rutaArchivo);
            //var rutaCompletaArchivo = (rutaArchivo);


            if (!File.Exists(rutaCompletaArchivo))
            {

                return null;
            }

            return rutaArchivo.Replace("~", "..").Replace("\\", "/");

        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod]
        static public string ConsultarRutaArchivo(Dictionary<string, string> datos)
        {

            var rutaArchivo = ConfigurationManager.AppSettings["CarpetaArchivos"] + datos["UID"];
            var rutaCompletaArchivo = HttpContext.Current.Server.MapPath(rutaArchivo);
            if (!File.Exists(rutaCompletaArchivo))
            {
                return null;
            }
            HttpContext.Current.Session["UID"] = datos["UID"];
            return rutaArchivo.Replace("~", "..").Replace("\\", "/");

        }

        private static void RemoveUID()
        { 
            HttpContext.Current.Session["UID"] = null; 
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod]
        static public Boolean REmoveSessionMassive()
        {
            HttpContext.Current.Session["MassiveConfirmation"] = null;
            return true;
        }


        private static void GuardarArchivo(Dictionary<string, string> datos, Dictionary<string, string> datosActuales)
        {

            /*GuardarImagen*/
            var page = new logic.BasePage();
            var a = new logic_acces(ConexionDB);
            var directorio = ConfigurationManager.AppSettings["CarpetaArchivos"];
            AnexoInfo session = HttpContext.Current.Session["MassiveConfirmation"] as AnexoInfo;
            var UIDArchivo = "";
            var rutaArchivo = "";


            var path = HttpContext.Current.Server.MapPath(directorio);
            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
            }



            if (session != null )
            {
                UIDArchivo = datos["UsuarioId"] + "-" + page.UIDPage.Substring(1, 6) + Path.GetExtension(datos["Img"]);
                rutaArchivo = HttpContext.Current.Server.MapPath(directorio + UIDArchivo);
                File.WriteAllBytes(rutaArchivo, session._source);
                HttpContext.Current.Session["UID"] = null;
                //Actualizar el UID
                using (TransactionScope scope3 = new TransactionScope())
                {
                    datos["UID"] = UIDArchivo;
                    a.ExecuteNonQuery("Usuario_IU", datos);
                    scope3.Complete();
                }
            }
            else
                HttpContext.Current.Session["MassiveConfirmation"] = null;


            if (datosActuales["UID"] != "" || !String.IsNullOrEmpty(datosActuales["UID"]))
            {
                var rutaArchivoAnterior = HttpContext.Current.Server.MapPath(directorio + datosActuales["UID"]);
                if (File.Exists(rutaArchivoAnterior))
                {
                    File.Delete(rutaArchivoAnterior);
                }
            }

            if (datos["UID"] == "" || String.IsNullOrEmpty(datos["UID"])) {
                RemoveUID();
            }

            if(datos["UID"] != datosActuales["UID"] )
                HttpContext.Current.Session["UID"] = datos["UID"];
        }

    }
}