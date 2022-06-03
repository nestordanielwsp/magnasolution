using System; 
using System.Collections.Generic;
using System.Linq;
using System.Web;   
using System.Web.Routing;
using System.Web.Security;
using magnajs;

namespace magnajs
{
    public class Global : System.Web.HttpApplication
    {
        void Application_Start(object sender, EventArgs e)
        {
            // Code that runs on application startup
           // RegisterRoutes(RouteTable.Routes);
        }

        void Application_End(object sender, EventArgs e)
        {
            //  Code that runs on application shutdown

        }

        void Application_Error(object sender, EventArgs e)
        {
            // Code that runs when an unhandled error occurs

           //Response.Redirect("~/Pages/Login.aspx");
        }
        public static void RegisterRoutes(RouteCollection routes)
        {
            //routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            //routes.MapRoute(
            //    "Default",                                              // Route name 
            //    "{controller}/{action}/{id}",                           // URL with parameters 
            //    new { controller = "Home", action = "Index", id = "" }  // Parameter defaults
            //);

            //routes.MapRoute(
            //      name: "profile",
            //      url: "profile"
           //defaults: new { controller = "RoutesDemo", action = "One" });
           //);

        }
    }
}
