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
using magnajs.Codes;

namespace magnajs.Pages
{
    public partial class FastResponse : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [WebMethod(EnableSession = true)]
        [ScriptMethod]
        static public Dictionary<string, object> GetInformacion(Dictionary<string, object> datos)
        {
            var page = new logic.BasePage();
            var a = new logic_acces(ConexionDB);
            var response = new Dictionary<string, object>();
            Dictionary<string, string> noDatos = new Dictionary<string, string>();
            DataTable Dt1 = a.ExecuteQuery("sp_FR_GetList_AlertaCalidad", datos).Tables[0];

            //Response
            response["InformacionPrincipal"] = page.DataTableToMap(Dt1);

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