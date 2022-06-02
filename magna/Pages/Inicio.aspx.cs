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
using System.Text;
using logic;
using CYP.Codes;

namespace CYP.Pages
{
    public partial class Inicio : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
           
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod]
        static public Dictionary<string, object> GetInfromacion(Dictionary<string, object> datos)
        {
            var page = new logic.BasePage();
            var a = new logic_acces(ConexionDB);
            var response = new Dictionary<string, object>();

            var dt = a.ExecuteQuery("Dashboard_Sel", datos);
            response["Resumen"] = page.DataTableToMap(dt.Tables[0]);
            response["VentasMarca"] = page.DataTableToMap(dt.Tables[1]);
            response["VentasCanal"] = page.DataTableToMap(dt.Tables[2]);
            response["CanalModerno"] = page.DataTableToMap(dt.Tables[3]);
            response["CanalTradicional"] = page.DataTableToMap(dt.Tables[4]);

            return response;
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod]
        static public Dictionary<string, object> Salir(Dictionary<string, string> datos)
        {
            var page = new logic.BasePage();
            var a = new logic_acces(ConfigurationManager.ConnectionStrings["ConexionDB"].ToString());
            var response = new Dictionary<string, object>();
            HttpContext.Current.Session.Abandon();
            response["Data"] = true;
            return response;
        }
    }
}