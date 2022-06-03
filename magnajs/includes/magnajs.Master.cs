using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using logic;
using logic.Class;
using System.Configuration;
using System.Data;
using System.Collections;
using System.Transactions;
using System.Web.Script.Services;
using System.Web.Services;
using magnajs.Codes;
using System.IO;

namespace magnajs.includes
{
    public partial class magnajs : System.Web.UI.MasterPage
    {
        private static logic.BasePage Base = new BasePage();
        private logic_acces _DataAcces;
        public string ruta = string.Empty;
        public string Imguser = string.Empty;
        public string host = string.Empty;
        public static string _Conexion;
        public static string ConexionDB
        {
            get
            {
                if (_Conexion == null)
                {
                    _Conexion = ConfigurationManager.ConnectionStrings["Conexion"].ToString();
                }

                return _Conexion;
            }

        }
        public logic_acces DataAcces
        {
            get
            {
                if (_DataAcces == null)
                {
                    _DataAcces = new logic_acces(ConexionDB);
                }
                return _DataAcces;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            //ruta = Base.URL;
            //if (!Page.IsPostBack)
            //{
                //sUsuario.InnerText = (HttpContext.Current.Session["Usuario"] != null
                //    ? HttpContext.Current.Session["Usuario"].ToString()
                //    : "");
                //Imguser = (HttpContext.Current.Session["ImgUser"] != null
                //    ? HttpContext.Current.Session["ImgUser"].ToString()
                //    : "");

              

            //}
            //var rutaArchivo = ConfigurationManager.AppSettings["CarpetaArchivos"] + HttpContext.Current.Session["UID"];
            //var rutaCompletaArchivo = HttpContext.Current.Server.MapPath(rutaArchivo);
            ////var rutaCompletaArchivo = (rutaArchivo);
         
            //var jsonMenu = Base.SerializerJson(GetMenu());
            //this.RunJavascriptBeforeLoadPage("var appMenu = jQuery.parseJSON('" + HttpUtility.JavaScriptStringEncode(jsonMenu) + "');");

            //if (File.Exists(rutaCompletaArchivo))
            //{

            //    this.RunJavascriptBeforeLoadPage("var ImgPerfil = '" + rutaArchivo.Replace("~", "..").Replace("\\", "/") + "';var Usuario='"+Convert.ToString(HttpContext.Current.Session["Usuario"]) + "'");

            //}
            //else
            //    this.RunJavascriptBeforeLoadPage("var ImgPerfil = '';var Usuario='" + Convert.ToString(HttpContext.Current.Session["Usuario"]) + "'");

        }

        public void RunJavascriptBeforeLoadPage(string script)
        {
            ScriptManager.RegisterClientScriptBlock(this.Page, this.Page.GetType(), Guid.NewGuid().ToString(), script, true);
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod]
        private static List<Dictionary<string, object>> GetMenu()
        {
            var page = new BasePage();
            logic_acces a = new logic_acces(BasePage.ConexionDB);
            var perfilId = HttpContext.Current.Session["PerfilId"];
            var datos = new Dictionary<string, object>();
            datos["PerfilId"] = perfilId;
            var dt = a.ExecuteQuery("MenuPerfil_Get", datos).Tables[0];
            var menuOriginal = page.DataTableToMap(dt);

            var menusPadre = menuOriginal.Where(e => Utilities.GetInt(e, "MenuPadreId") == 0).ToList();

            foreach (var menuPadre in menusPadre)
            {
                GroupMenu(menuOriginal, menuPadre);
            }

            return menusPadre;
        }

        private static void GroupMenu(List<Dictionary<string, object>> menuOriginal,
            Dictionary<string, object> menu)
        {
            var menuPadreId = Utilities.GetInt(menu, "MenuId");
            var menusHijo = menuOriginal.Where(e => Utilities.GetInt(e, "MenuPadreId") == menuPadreId).ToList();

            if (menusHijo.Count > 0)
            {
                menu["subMenu"] = menusHijo;

                foreach (var menuHijo in menusHijo)
                {
                    GroupMenu(menuOriginal, menuHijo);
                }
            }            
        }
    }
}