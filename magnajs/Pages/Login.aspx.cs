using Infraestructura.Archivos;
using logic;
using OfficeOpenXml;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Xml.Linq;

namespace magnajs.Pages
{
    public partial class Login : BasePageLogIn
    { 
        public string ruta = string.Empty;
        public string opcionRedirect = string.Empty;
        public string oid = string.Empty;
        public static string _Conexion;
        public static string ConexionDB
        {
            get
            {
                if (_Conexion == null)
                {
                    _Conexion = ConfigurationManager.ConnectionStrings["ConexionDB"].ToString();
                }

                return _Conexion;

            }

        }

        protected void Page_PreInit(object sender, EventArgs e)
        {
            this.Theme = "";
            ruta = this.URL;

        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            {               

            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            try
            {
                HttpContext.Current.Session.RemoveAll();
                this.lblError.Text = "";
                opcionRedirect = Request.QueryString["op"] != null ? Request.QueryString["op"] : string.Empty;
                oid = Request.QueryString["oid"] != null ? Request.QueryString["oid"] : string.Empty;

                //string contrasenia =  Encripta(this.txtPassword.Value);
                //string hash =  EncodePassword(this.txtPassword.Value);


                var bp = new BasePage();
                var a = new logic_acces(ConexionDB, false);
                var datos = new Dictionary<string, string>();
                datos.Add("Usuario", this.txtUsuario.Value);
                datos.Add("Contrasenia", this.txtPassword.Value);

                DataSet ds = a.ExecuteQuery("Usuario_Login", datos);
                if (ds != null)
                {
                    var dt = ds.Tables[0];
                    if (dt.Rows.Count > 0)
                    {
                        HttpContext.Current.Session["UsuarioId"] = dt.Rows[0]["UsuarioId"].ToString();
                        HttpContext.Current.Session["NumUsuario"] = dt.Rows[0]["NumUsuario"].ToString();
                        HttpContext.Current.Session["Usuario"] = dt.Rows[0]["NombreUsuario"].ToString();
                        HttpContext.Current.Session["PerfilId"] = dt.Rows[0]["PerfilId"].ToString();
                        HttpContext.Current.Session["ImgUser"] = dt.Rows[0]["ImgUser"].ToString();
                        HttpContext.Current.Session["SucursalId"] = "1";//  dt.Rows[0]["SucursalId"].ToString();
                        HttpContext.Current.Session["EmpresaId"] = "1";// dt.Rows[0]["EmpresaId"].ToString();
                        HttpContext.Current.Session["UID"] = dt.Rows[0]["UID"].ToString();
                        HttpContext.Current.Session["AreaId"] = dt.Rows[0]["AreaId"].ToString();
                        HttpContext.Current.Session["Tema"] = "Portal";
                        HttpContext.Current.Session["PerfilFuncionalId"] = dt.Rows[0]["PerfilFuncionalId"].ToString();
                        //HttpContext.Current.Session["EsCrearModificarActivity"] = dt.Rows[0]["EsCrearModificarActivity"].ToString();

                        switch (opcionRedirect)
                        {
                            case "act":
                                Response.Redirect("Activity.aspx?oid=" + oid);
                                break;
                            case "tp":
                                Response.Redirect("TareasPendientes.aspx");
                                break;
                            case "nc":
                                Response.Redirect("Solicitudes.aspx");
                                break;
                            default:
                                Response.Redirect("Inicio.aspx");
                                break;
                        }

                    }
                }
            }
            catch (Exception ex)
            {
                this.lblError.Text = ex.Message;
            }
        }


        [WebMethod(EnableSession = true)]
        [ScriptMethod]
        static public Dictionary<string, object> LogInfo(Dictionary<string, string> datos)
        {
            var page = new logic.BasePage();
            var a = new logic_acces(ConexionDB, false);
            var response = new Dictionary<string, object>();

            DataTable dtInfo = a.ExecuteQuery("Get_Cat_Usuario_Id", datos).Tables[0];
            response["dtInfo"] = page.DataTableToMap(dtInfo);

            return response;
        }
    }
}