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
using CYP.Codes;
using logic.Class;
using System.Transactions;

namespace CYP.ClasesGenerales
{
    public class GeneralClass : BasePage
    {

        [WebMethod(EnableSession = true)]
        [ScriptMethod]
        static public List<Dictionary<string, object>> ConsultarClientes(Dictionary<string, string> datos)
        {
            var page = new logic.BasePage();
            var a = new logic_acces(ConexionDB);
            var response = new List<Dictionary<string, object>>();
            if (!String.IsNullOrEmpty(datos["TextoBusqueda"]))
                datos["NombreCliente"] = datos["TextoBusqueda"];

            datos["EsCobrarA"] = "true";

            DataTable Dt = a.ExecuteQuery("Cliente_Cmb", datos).Tables[0];
            response = page.DataTableToMap(Dt);
            return response;
        }
    }
}