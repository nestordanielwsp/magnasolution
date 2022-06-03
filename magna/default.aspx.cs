using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CYP
{
    public partial class _default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var currentPage = Page.Request.Url.ToString();
            if (currentPage.Contains(""))
                Response.Redirect("");
        }
    }
}