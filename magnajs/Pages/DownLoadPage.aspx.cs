using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Services;
using System.Web.Services;
using System.Collections;
using logic;
using System.Data;
using System.Configuration;
using System.Transactions;
using logic.Class;

namespace magnajs.pages
{
    public partial class DownLoadPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["ArchivoADescargar"] != null)
            {
                var anexoInfo = (AnexoInfo)Session["ArchivoADescargar"];
                anexoInfo._fileName = !anexoInfo.Extension.Contains("txt") ? DateTime.Now.Millisecond.ToString() + "_" + anexoInfo._fileName.Replace(",", "") : anexoInfo._fileName.Replace(",", "");
                HttpContext.Current.Response.AddHeader("Content-disposition", "attachment; filename=" + anexoInfo._fileName);

                if (anexoInfo.Extension.Contains("xlsm"))
                    HttpContext.Current.Response.ContentType = "application/vnd.ms-excel.sheet.macroEnabled.main+xml";
                else if (anexoInfo.Extension.Contains("xls"))
                    HttpContext.Current.Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                else if (anexoInfo.Extension.Contains("txt"))
                    HttpContext.Current.Response.ContentType = "application/force-download";
                else
                    HttpContext.Current.Response.ContentType = anexoInfo.Extension;

                //HttpContext.Current.Response.ContentType = anexoInfo.Extension.Contains("xls")
                //    ? "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                //    : anexoInfo.Extension;

                HttpContext.Current.Response.BinaryWrite(anexoInfo._source);
                Session["ArchivoADescargar"] = null;
                HttpContext.Current.Response.End();
            }
        }
    }
}