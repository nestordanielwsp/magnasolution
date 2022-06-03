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
    public partial class ConfiguracionGeneral : BasePage
    {
        public string ruta = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            this.Title = "";
            ruta = this.URL; 

        }
        [WebMethod(EnableSession = true)]
        [ScriptMethod]
        static public Dictionary<string, object> Consultar(Dictionary<string, string> datos)
        {
            var page = new logic.BasePage();
            var a = new logic_acces(ConexionDB);
            var response = new Dictionary<string, object>();    
            DataTable Dt1 = a.ExecuteQuery("ConfiguracionGeneral_Sel", datos).Tables[0]; 
            response["ConfiguracionGeneral"] = page.DataTableToMap(Dt1); 
            return response;
        }
        [WebMethod(EnableSession = true)]
        [ScriptMethod]
        static public Dictionary<string, string> Guardar(Dictionary<string, string> datos)
        {
            var page = new logic.BasePage();
            var a = new logic_acces(ConexionDB);
            var response = new Dictionary<string, object>();

            using (TransactionScope scope = new TransactionScope()) {
                if (!datos.ContainsKey("ConfiguracionGeneralId"))
                    datos["ConfiguracionGeneralId"] = "0";
                if (datos["ConfiguracionGeneralId"] == "0")
                    datos["Active"] = "True";
                a.ExecuteNonQuery("ConfiguracionGeneral_IU", datos);
                scope.Complete();
            } 
            return datos;
        }

 

    }
}