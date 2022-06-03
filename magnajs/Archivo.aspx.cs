using magnajs.Codes;
using Infraestructura.Archivos;
using logic.Class;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace magnajs
{
    public partial class Archivo : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Dictionary<string, object> datos = new Dictionary<string, object>();
            if (Request["ReqId"] != null)
            {
                datos["ArchivoId"] = Request["ReqId"].ToString();

                var response = Utilities.GetDataSesion("ActivityDetalleArchivoId_Sel", datos);
                var storage = new AlmacenamientoAzureServicio();
                var page = new Archivo();
                var rutaArchivos = ConfigurationManager.AppSettings["CarpetaArchivos"] +
                                   "Activity" + "/" + response[0]["RutaArchivo"];
                var bytes = storage.ObtenerArchivo(rutaArchivos);
                var extension = Path.GetExtension(response[0]["RutaArchivo"].ToString()).Substring(1);
                page.Session["ArchivoADescargar"] = new AnexoInfo(DateTime.Now.Millisecond.ToString() +  "_" + response[0]["NombreArchivo"].ToString(), "application/octet-stream", bytes, extension);
                Response.Redirect("Pages/DownLoadPage.aspx?" + DateTime.Now.Millisecond.ToString());
            }

        }
    }
}