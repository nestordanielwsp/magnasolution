using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using logic;
using System.Data;
using System.Collections;
using System.Xml;
using System.IO;
using NPOI.HSSF.UserModel;
using NPOI.SS.UserModel;
using System.Runtime.Serialization;
using System.Text.RegularExpressions;
using System.Text;
using System.Net;
using System.Net.Mail;
using System.Data.Common;
using System.Data.SqlClient;
using System.Globalization;
using System.Reflection;
using System.Web.Configuration;
using System.Web.Script.Serialization;
using System.Web.Security;
using logic.Common.Resources;
using System.Security.Cryptography;
using System.Xml.Serialization;
using NPOI.HSSF.Util;
using OfficeOpenXml;
using System.Xml.Linq;
using Newtonsoft.Json;
using RestSharp;

namespace logic
{
    public enum SessionStateModes
    {
        SinglePage = 0,
        AllPages = 1
    }


    public class BasePage : System.Web.UI.Page
    {
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

        private const string UidPage = "UidPage";
        public const string REMOTE_HOST = "REMOTE_HOST";

        KeyValuePlainTextResource resourceMgr, commonResourceMgr;


        public string SqlLanguage
        {
            get
            {
                CultureInfo culture = this.Session["SESSION_CULTURE"] as CultureInfo;
                if (culture != null)
                {
                    return culture.TwoLetterISOLanguageName;
                }

                return "es";
            }
        }

        public string NombrePcMod
        {
            get
            {
                string nombrePcMod = this.Session["NamePcMod"] as string;
                if (nombrePcMod == null)
                {
                    nombrePcMod = this.GetNombrePC();
                    this.Session["NamePcMod"] = nombrePcMod;
                }

                return nombrePcMod;
            }
        }

        protected string TypeName
        {
            get
            {
                string value = this.GetType().Name;
                if (!value.StartsWith("pages_"))
                    return string.Format("pages_{0}_aspx", value);
                else
                    return value;

            }
        }

        public KeyValuePlainTextResource ResourceManager
        {
            get
            {
                if (resourceMgr == null)
                {
                    CultureInfo culture = this.Session["SESSION_CULTURE"] as CultureInfo;
                    if (culture == null)
                    {
                        culture = CultureManager.ResolveCulture();
                    }

                    resourceMgr = ResourceFactory.CreateResource(this.TypeName, !IsPostBack, culture);
                }

                return resourceMgr;
            }
        }

        public KeyValuePlainTextResource CommonResourceManager
        {
            get
            {
                if (commonResourceMgr == null)
                {
                    CultureInfo culture = this.Session["SESSION_CULTURE"] as CultureInfo;
                    if (culture == null)
                    {
                        culture = CultureManager.ResolveCulture();
                    }
                    commonResourceMgr = ResourceFactory.CreateResource("GlobalResources", !IsPostBack, culture);
                }
                return commonResourceMgr;
            }
        }

        public string UIDPage
        {
            get
            {
                string value = ViewState[UidPage] as string;
                if (string.IsNullOrWhiteSpace(value))
                {
                    value = Guid.NewGuid().ToString();
                    ViewState.Add(UidPage, value);
                }

                return value;
            }
        }

        public string URL
        {
            get
            {
                return this.GetAppSetting("URL");
            }
        }


        public int UsuarioID
        {
            get
            {
                return ToInt32(this.GetSession("UsuarioID"));
            }
        }

        public delegate void LanguageChanged(CultureInfo cultureInfo);

        public event LanguageChanged LanguageChangedEvent;

        public delegate void OnPageRefresh(EventArgs e);

        public event OnPageRefresh OnPageRefreshEvent;


        public bool ValidaSessionActiva()
        {
            if (HttpContext.Current.Session["UsuarioID"] == null)
            {
                string msgError = this.CommonResourceManager.GetMessage("msgSinSesion") == null ? " -999.- La sesión ha caducado se requiere volver a iniciar sesión." : this.CommonResourceManager.GetMessage("msgSinSesion");
                throw new Exception(msgError);
            }

            return true;
        }

        protected override void OnLoad(System.EventArgs e)
        {
            if (!this.Page.IsPostBack)
            {
                var serializer = new JavaScriptSerializer();
                ValidaSeguridad();
                var jsonRecursos = this.GetCommonResourcesJSON();
                this.RunJavascriptBeforeLoadPage("var recursosGlobal = jQuery.parseJSON('" + jsonRecursos + "');");
                jsonRecursos = this.GetResourcesJSON();
                this.RunJavascript("var recursos = jQuery.parseJSON('" + jsonRecursos + "');");
            }

            base.OnLoad(e);
        }

        protected override void OnPreInit(EventArgs e)
        {
            /* ScriptManager.RegisterClientScriptInclude(Page, typeof(Page), "jquery", this.URL + "scripts/carga.js?0404"); */
            Response.AppendHeader("X-UA-Compatible", "IE=edge,chrome=1");
            this.Theme = (HttpContext.Current.Session["Tema"] == null ? "Portal" : HttpContext.Current.Session["Tema"].ToString());

            base.OnPreInit(e);


        }

        protected override void OnInit(System.EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                CtrlsTranslator.Translate(this, this.ResourceManager);
            }

            base.OnInit(e);
            this.DisableClientCaching();
        }

        public void RaiseLanguageChanged(CultureInfo cultureInfo)
        {
            if (LanguageChangedEvent != null)
            {
                CultureManager.StoreCulture(cultureInfo);
                CtrlsTranslator.Translate(this, this.ResourceManager);
                LanguageChangedEvent(cultureInfo);
                Response.Redirect(Request.RawUrl);
            }
        }

        protected static String StringToDateUniversal(string Fecha)
        {
            return new DateTime(int.Parse(Fecha.Substring(6, 4)), int.Parse(Fecha.Substring(3, 2)), int.Parse(Fecha.Substring(0, 2))).ToString("yyyyMMdd");
        }

        public void RaiseOnPageRefresh(EventArgs e)
        {
            if (OnPageRefreshEvent != null)
            {
                OnPageRefreshEvent(e);
            }
        }

        protected override void InitializeCulture()
        {
            base.InitializeCulture();

            if (!this.Page.IsPostBack)
            {
                if (HttpContext.Current.Session["UsuarioID"] == null && HttpContext.Current.User.Identity.Name != "")
                {
                    DataTable dt;
                    var a = new logic_acces(ConexionDB);
                    Dictionary<string, string> datos = new Dictionary<string, string>();

                    if (HttpContext.Current.Session["UsuarioID"] == null)
                    {
                        datos.Add("Usuario", HttpContext.Current.User.Identity.Name);
                        dt = a.ExecuteQuery("UsuarioInformacion_Sel", datos).Tables[0];

                        if (dt.Rows.Count > 0)
                        {
                            HttpContext.Current.Session["UsuarioID"] = dt.Rows[0]["UsuarioID"];
                            HttpContext.Current.Session["Usuario"] = this.Page.User.Identity.Name;
                        }
                    }

                    //HttpContext.Current.Session["UsuarioID"]       = "0";
                    //HttpContext.Current.Session["Usuario"]         = this.Page.User.Identity.Name;
                    HttpContext.Current.Session["DefaultLanguageID"] = string.Empty;
                }
            }

            CultureManager.Initialize();
        }

        public string GetMessage(string resourceID)
        {
            return ResourceManager.GetMessage(resourceID);
        }

        public string GetCommonMessage(string resourceID)
        {
            return CommonResourceManager.GetMessage(resourceID);
        }

        public void RunJavascript(string script)
        {
            ScriptManager.RegisterStartupScript(this.Page, this.Page.GetType(), Guid.NewGuid().ToString(), script, true);
        }

        public void RunJavascriptBeforeLoadPage(string script)
        {
            ScriptManager.RegisterClientScriptBlock(this.Page, this.Page.GetType(), Guid.NewGuid().ToString(), script, true);
        }

        public string GetAppSetting(string key)
        {
            return WebConfigurationManager.AppSettings[key];
        }

        public object GetSession(string name)
        {
            return Session[name];
        }

        public string GetNombrePC()
        {
            string computerName = string.Empty;
            try
            {
                /*
                var host = new System.Net.IPHostEntry();
                host = System.Net.Dns.GetHostEntry(HttpContext.Current.Request.ServerVariables[REMOTE_HOST]);
                if (!string.IsNullOrEmpty(host.HostName))
                {
                    computerName = host.HostName;
                }
                */
                computerName = HttpContext.Current.Request.ServerVariables[REMOTE_HOST];
            }
            catch
            {
                computerName = HttpContext.Current.Request.ServerVariables[REMOTE_HOST];
            }

            if (string.IsNullOrWhiteSpace(computerName))
            {
                computerName = Environment.MachineName;
            }
            else
            {
                System.Net.IPAddress ipaddr = null;
                if (!System.Net.IPAddress.TryParse(computerName, out ipaddr))
                    computerName = computerName.Split(new Char[] { '.' })[0];
            }

            return computerName;
        }

        public string GetResourcesJSON()
        {
            var serializer = new JavaScriptSerializer();

            var recursos = DataTableToMap(ResourceManager.GetResourcesValues());

            return serializer.Serialize(recursos);
        }

        public string GetCommonResourcesJSON()
        {
            var serializer = new JavaScriptSerializer();

            var recursos = DataTableToMap(CommonResourceManager.GetResourcesValues());

            return serializer.Serialize(recursos);
        }

        public void FillCmb(string sp, string jsvar)
        {
            var a = new logic_acces(ConexionDB);
            Dictionary<string, string> datos = new Dictionary<string, string>();

            DataTable dt = a.ExecuteQuery(sp, datos).Tables[0];
            var jSON = this.SerializerJson(this.DataTableToMap(dt));
            this.RunJavascriptBeforeLoadPage("var " + jsvar + " = jQuery.parseJSON('" + HttpUtility.JavaScriptStringEncode(jSON) + "');");
        }

        public void LoadJs(string jsvar, string jsValue)
        {
            this.RunJavascriptBeforeLoadPage("var " + jsvar + " = " + jsValue + ";");
        }

        public void FillCmb(string sp, Dictionary<string, string> datos, string jsvar)
        {
            var a = new logic_acces(ConexionDB);

            DataTable dt = a.ExecuteQuery(sp, datos).Tables[0];
            var jSON = this.SerializerJson(this.DataTableToMap(dt));
            this.RunJavascriptBeforeLoadPage("var " + jsvar + " = jQuery.parseJSON('" + HttpUtility.JavaScriptStringEncode(jSON) + "');");
        }

        public void FillFecha(string jsvar)
        {

            DataTable dt = new DataTable();
            dt.Columns.Add("Anio", typeof(int));
            dt.Columns.Add("Mes", typeof(int));
            dt.Columns.Add("Dia", typeof(int));
            dt.Columns.Add("FechaFormat", typeof(string));

            DataRow _rfecha = dt.NewRow();
            _rfecha["Anio"] = DateTime.Now.Year;
            _rfecha["Mes"] = DateTime.Now.Month - 1;
            _rfecha["Dia"] = DateTime.Now.Day;
            _rfecha["FechaFormat"] =  DateTime.Now.ToString("dd/MM/yyyy");

            dt.Rows.Add(_rfecha);

            var jSON = this.SerializerJson(this.DataTableToMap(dt));
            this.RunJavascriptBeforeLoadPage("var " + jsvar + " = jQuery.parseJSON('" + HttpUtility.JavaScriptStringEncode(jSON) + "');");
        }

        public static List<Dictionary<string, object>> GetDataFromSp(string sp, Dictionary<string, object> datos)
        {
            var page = new BasePage();
            var a = new logic_acces(ConexionDB);
            DataTable dt = a.ExecuteQuery(sp, datos).Tables[0];
            var result = page.DataTableToMap(dt);
            return result;
        }

        public void Mensaje(string msj, int tipo)
        {
            System.Web.UI.ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Aviso", "Ex.mensajes('" + msj.Replace("'", "") + "'," + tipo + ");", true);
        }

        public static decimal? DecimalIsNull(string numero)
        {

            if (numero == "")
            {
                return null;
            }
            else
            {
                return decimal.Parse(numero);
            }
        }

        public static string ToString(object value)
        {
            if (value is DBNull)
                return string.Empty;

            return Convert.ToString(value);
        }

        public static int ToInt32(object value)
        {
            if (value is DBNull)
                return 0;

            return Convert.ToInt32(value);
        }

        public static decimal ToDecimal(object value)
        {
            if (value is DBNull)
                return 0;

            return Convert.ToDecimal(value);
        }

        public static bool ToBoolean(object value)
        {
            if (value is DBNull)
                return false;

            return Convert.ToBoolean(value);
        }

        public static DateTime ToDateTime(object value)
        {
            if (value is DBNull)
                return DateTime.MinValue;

            return Convert.ToDateTime(value);
        }

        public List<Dictionary<string, object>> DataTableToMap(DataTable p_dt)
        {
            List<Dictionary<string, object>> maps = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in p_dt.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in p_dt.Columns)
                {
                    if (col.DataType.Name.ToLower().Contains("date"))
                    {
                        if (DateTime.TryParse(dr[col].ToString(), out var fecha))
                        {
                            var index = col.ColumnName.IndexOf("ConHora");
                            var formato = index != -1 ? "dd/MM/yyyy HH:mm:ss" : "dd/MM/yyyy";
                            var nombreColumna = index != -1 ? col.ColumnName.Substring(0, index) : col.ColumnName;
                            var fechaLocal = fecha.ToLocalTime().ToString(formato);
                            row.Add(nombreColumna, fechaLocal);
                        }
                    }
                    else
                        row.Add(col.ColumnName, dr[col]);
                }
                maps.Add(row);
            }
            return maps;
        }

        public static DataTable GetDataTableFromDictionaries<T>(List<Dictionary<string, T>> list)
        {
            DataTable dataTable = new DataTable();

            if (list == null || !list.Any()) return dataTable;

            foreach (var column in list.First().Select(c => new DataColumn(c.Key, typeof(T))))
            {
                dataTable.Columns.Add(column);
            }

            foreach (var row in list.Select(
                r =>
                {
                    var dataRow = dataTable.NewRow();
                    r.ToList().ForEach(c => dataRow.SetField(c.Key, c.Value));
                    return dataRow;
                }))
            {
                dataTable.Rows.Add(row);
            }

            return dataTable;
        }

        public string SerializerJson(List<Dictionary<string, object>> a)
        {
            System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer() { MaxJsonLength = 2147483644 };
            return serializer.Serialize(a);
        }

        public string SerializerJson(string a)
        {
            System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            return serializer.Serialize(a);
        }

        public List<Dictionary<string, string>> Deserialize(string json)
        {
            System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            List<Dictionary<string, string>> items = serializer.Deserialize<List<Dictionary<string, string>>>(json);
            return items;
        }

        public List<Dictionary<string, object>> DeserializeObject(string json)
        {
            System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            List<Dictionary<string, object>> items = serializer.Deserialize<List<Dictionary<string, object>>>(json);
            return items;
        }

        public static string ReemplazaTagsCorreo(string body, Dictionary<string, object> datos)
        {
            var page = new BasePage();
            var a = new logic_acces(ConexionDB);
            Dictionary<string, object> param = new Dictionary<string, object>();
            DataTable dt = a.ExecuteQuery("NotificacionEtiqueta_sel", param).Tables[0];

            foreach (DataRow item in dt.Rows)
            {
                var tagName = item["TagName"].ToString();
                var tagVale = tagName.Replace("{", "").Replace("}", "");
                if (datos.ContainsKey(tagVale))
                    body = Regex.Replace(body, tagName, datos[tagVale].ToString(), RegexOptions.IgnoreCase);
            }

            //body = body.Replace(("{UrlPortal}").ToLower(), "<a href=" + page.GetAppSetting("URLPortalCandidato") + ">Reclutamiento HEINEKEN</a>");
            body = Regex.Replace(body, "{UrlPortal}", "<a href=" + page.GetAppSetting("URLPortal") + "></a>", RegexOptions.IgnoreCase);

            return body;
        }

        public static bool SendMail(string[] pMails, string pSubject, string pBody, bool isBodyHtml, Dictionary<string, byte[]> attachments, out string messageError)
        {
            return SendMail(pMails, new string[] { }, pSubject, pBody, isBodyHtml, attachments, out messageError, null);
        }

        public static bool SendMail(string[] pMails, string[] pCCMails, string pSubject, string pBody, bool isBodyHtml, Dictionary<string, byte[]> attachments, out string messageError)
        {
            return SendMail(pMails, pCCMails, pSubject, pBody, isBodyHtml, attachments, out messageError, null);
        }

        public static bool SendMail(string[] pMails, string[] pCCMails, string pSubject, string pBody, bool isBodyHtml, Dictionary<string, byte[]> attachments, out string messageError, Dictionary<string, Stream> stearmAttachments)
        {
            messageError = string.Empty;
            if (ConfigurationManager.AppSettings["EnviaMail"] == null || ConfigurationManager.AppSettings["EnviaMail"] == "0")
            {
                messageError = "NO esta configurado el sistema para envio de correos, favor de verificar.";
                return false;
            }


            if (ConfigurationManager.AppSettings["EnviaMail"].ToString() == "1")
            {
                try
                {
                    var client = new RestClient(ConfigurationManager.AppSettings["RestClient"]);
                    var request = new RestRequest(Method.POST);
                    request.AddHeader("cache-control", "no-cache");
                    request.AddHeader("x-server-api-key", ConfigurationManager.AppSettings["MailApiKey"]);
                    request.AddHeader("content-type", "application/json");

                    var dataMail = new Dictionary<string, object>
                    {
                        ["to"] = pMails,
                        ["from"] = ConfigurationManager.AppSettings["UserMail"],
                        ["subject"] = pSubject,
                        ["html_body"] = pBody
                    };

                    if (pCCMails.Any(e => !string.IsNullOrEmpty(e)))
                        dataMail["cc"] = pCCMails.Where(e => !string.IsNullOrEmpty(e));

                    var attachmentsMail = new List<Dictionary<string, object>>();

                    foreach (var attachment in attachments)
                    {
                        var fileName = attachment.Key;
                        var index = fileName.LastIndexOf(@"\") + 1;
                        fileName = fileName.Substring(index, fileName.Length - index);
                        var file = Convert.ToBase64String(attachment.Value);

                        var attachmentMail = new Dictionary<string, object>()
                        {
                            {"name", fileName},
                            {"data", file},
                            {"content_type", "text/plain"}
                        };

                        attachmentsMail.Add(attachmentMail);
                    }

                    //foreach (var attachment in attachments)
                    //{
                    //    if (attachment != "")
                    //    {
                    //        if (System.IO.File.Exists(attachment))
                    //        {
                    //            var index = attachment.LastIndexOf(@"\") + 1;
                    //            var filaName = attachment.Substring(index, attachment.Length - index);
                    //            var file = Convert.ToBase64String(File.ReadAllBytes(attachment));

                    //            var attachmentMail = new Dictionary<string, object>()
                    //            {
                    //                {"name", filaName},
                    //                {"data", file},
                    //                {"content_type", "text/plain"}
                    //            };

                    //            attachmentsMail.Add(attachmentMail);
                    //        }
                    //    }
                    //}

                    dataMail["attachments"] = attachmentsMail;
                    var json = JsonConvert.SerializeObject(dataMail);

                    request.AddParameter("application/json", json, ParameterType.RequestBody);
                    IRestResponse response = client.Execute(request);

                    var responseMail = JsonConvert.DeserializeObject<Dictionary<string, object>>(response.Content);

                    if (responseMail["status"].ToString() == "error")
                    {
                        var data = JsonConvert.DeserializeObject<Dictionary<string, object>>(responseMail["data"].ToString());
                        messageError = data["message"].ToString();
                        return false;
                    }

                    return true;
                }
                catch (Exception ex)
                {
                    messageError = ex.Message;
                    return false;
                }
            }

            return false;
        }


        public static bool SendMail(string[] pMails, string[] pBccMails, string[] pCCMails, string pSubject, string pBody, bool isBodyHtml, string[] attachments, out string messageError, Dictionary<string, Stream> stearmAttachments, Dictionary<string, string> settings)
        {
            messageError = string.Empty;
            if (settings["EnviaMail"] == null || settings["EnviaMail"] == "0")
            {
                messageError = "NO esta configurado el sistema para envio de correos, favor de verificar.";
                return false;
            }


            if (settings["EnviaMail"].ToString() == "1")
            {
                try
                {
                    SmtpClient objSendEmail = new SmtpClient(settings["ServerSMTP"]);
                    objSendEmail.Credentials = new NetworkCredential(settings["UserMail"].ToString(), settings["PasswordMail"].ToString());
                    MailMessage Message = new MailMessage();

                    Message.From = new MailAddress(settings["SenderEmail"], settings["SenderName"]);

                    string defaultStyles = " <style type=\"text/css\"> body, p, table, div, ul, li  {font-family:\"Verdana\", \"Arial\"; font-weight:normal; font-size:12px; } </style> ";

                    Message.Subject = pSubject;// "Encuesta pendiente";
                    //Para que tome en cuenta los TAGS de HTML
                    Message.IsBodyHtml = isBodyHtml;
                    Message.Body = defaultStyles + pBody;

                    //TO
                    foreach (string Email in pMails)
                    {
                        if (Email != "")
                            Message.To.Add(Email.Trim());
                    }

                    //BCC
                    foreach (string Email in pBccMails)
                    {
                        if (Email != "")
                            Message.Bcc.Add(Email.Trim());
                    }

                    //CC
                    foreach (string Email in pCCMails)
                    {
                        if (Email != "")
                            Message.CC.Add(Email.Trim());
                    }

                    foreach (string attachment in attachments)
                    {
                        if (attachment != "")
                        {
                            if (System.IO.File.Exists(attachment))
                            {
                                var attach = new System.Net.Mail.Attachment(attachment);
                                Message.Attachments.Add(attach);
                            }
                        }
                    }

                    if (stearmAttachments != null)
                    {
                        foreach (var attachment in stearmAttachments)
                        {
                            var attach = new System.Net.Mail.Attachment((Stream)attachment.Value, attachment.Key);
                            Message.Attachments.Add(attach);
                        }
                    }

                    objSendEmail.Send(Message);
                    return true;
                }
                catch (Exception ex)
                {
                    messageError = ex.Message;
                    return false;
                }
            }

            return false;
        }

        public static string SerializeOne(Dictionary<string, string> a)
        {
            System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            return serializer.Serialize(a);
        }

        public static Dictionary<string, string> DeserializeOne(string json)
        {
            System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            Dictionary<string, string> items = serializer.Deserialize<Dictionary<string, string>>(json);
            return items;
        }

        public static string[] DeserializeArray(string json)
        {
            return new JavaScriptSerializer().Deserialize<string[]>(json);
        }


        public static void WriteLineOnTxt(String message)
        {
            string strFecha = DateTime.Now.ToString("ddMMyyyy");
            string url = System.Web.Hosting.HostingEnvironment.MapPath("~/Log/") + strFecha + ".txt";
            //path = path.Replace("file:\\", "").Replace("\\Debug", "");
            StreamWriter sw = new StreamWriter(url, true);
            // Agrega linea de Error.
            sw.WriteLine(message);
            sw.Flush();
            sw.Close();
        }

        public static string Encripta(string Password)
        {
            string str1 = "";
            try
            {
                SHA1 shA1 = SHA1.Create();
                byte[] bytes = new ASCIIEncoding().GetBytes(Password);
                shA1.ComputeHash(bytes);
                str1 = Convert.ToBase64String(shA1.Hash);
            }
            catch (Exception ex)
            {
                string str2 = "Error in HashCode : " + ex.Message;
            }
            return str1;
        }

        protected DataTable SetColumnsName(DataTable dt)
        {
            List<string> ColsNames = dt.Columns.OfType<DataColumn>().Select<DataColumn, string>(col => col.ColumnName).ToList();
            foreach (string columnName in ColsNames)
            {
                string value = this.GetMessage(string.Format("{0}-{1}", dt.TableName, dt.Columns[columnName].ColumnName));
                dt.Columns[columnName].ColumnName = System.Web.HttpUtility.HtmlDecode(!string.IsNullOrEmpty(value) ? value : dt.Columns[columnName].ColumnName);
            }

            return dt;
        }

        public static T XmlDeserializeFromString<T>(string objectData)
        {
            return (T)XmlDeserializeFromString(objectData, typeof(T));
        }

        public static object XmlDeserializeFromString(string objectData, Type type)
        {
            var serializer = new XmlSerializer(type);
            object result;

            using (TextReader reader = new StringReader(objectData))
            {
                result = serializer.Deserialize(reader);
            }

            return result;
        }


        public void ValidaSeguridad()
        {
            //var a = new logic_acces(ConexionDB);
            //var data = new Dictionary<string, object>();
            //data["UrlPagina"] = Page.Request.AppRelativeCurrentExecutionFilePath.Replace("~", "..");
            //data["PerfilId"] = Session["PerfilId"];

            //var dt = a.ExecuteQuery("PerfilMenu_Validar", data).Tables[0];

            //if (dt.Rows.Count == 0)
            //{
            //    data["UrlPagina"] = "../Pages/Solicitudes.aspx";
            //    dt = a.ExecuteQuery("PerfilMenu_Validar", data).Tables[0];

            //    var pageRedirected = dt.Rows.Count == 0 ? "~/Pages/Login.aspx" : "~/Pages/Solicitudes.aspx";

            //    Response.Redirect(pageRedirected);
            //}
        }

        public bool EsTienePermisoEspecial(int PermisoEspecialID)
        {
            var a = new logic_acces(ConexionDB);
            Dictionary<string, string> datos = new Dictionary<string, string>();

            datos.Add("Usuario", "");
            datos.Add("PermisoEspecialID", PermisoEspecialID.ToString());
            if (HttpContext.Current.Session["Usuario"] != null)
            {
                datos["Usuario"] = HttpContext.Current.Session["Usuario"].ToString();
            }

            var dt = a.ExecuteQuery("UsuarioOpcion_Sel", datos).Tables[0];

            return dt.Rows[0]["TienePermiso"].ToString() == "1" ? true : false;
        }

        public void PermisosEspecial()
        {
            var a = new logic_acces(ConexionDB);
            Dictionary<string, string> datos = new Dictionary<string, string>();

            datos.Add("Usuario", "");

            if (HttpContext.Current.Session["Usuario"] != null)
            {
                datos["Usuario"] = HttpContext.Current.Session["Usuario"].ToString();
            }

            var dt = a.ExecuteQuery("UsuarioOpcion_Sel", datos).Tables[1];

            var jSON = this.SerializerJson(this.DataTableToMap(dt));
            this.RunJavascriptBeforeLoadPage("var PermisosInfo = jQuery.parseJSON('" + HttpUtility.JavaScriptStringEncode(jSON) + "');");
        }

        private void DisableClientCaching()
        {
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            //Response.Headers.Add("Cache-Control", "no-cache, no-store"); 
            Response.Cache.SetExpires(DateTime.UtcNow.AddYears(-1));
            Response.Cache.SetNoStore();
        }

        public byte[] ExportToExcel(DataTable dt)
        {
            var pck = new ExcelPackage(new FileInfo(HttpContext.Current.Server.MapPath("~/Templates/Default_Layout.xlsx")), true);
            var ws = pck.Workbook.Worksheets[1];


            var columnas = new List<string>();

            int i = 1;
            int col = 1;


            foreach (DataColumn column in dt.Columns)
            {
                string value = this.GetMessage(string.Format("{0}-{1}", dt.TableName, column.ColumnName));

                if (!string.IsNullOrEmpty(value))
                {

                    ws.Cells[i, col].Value = value;

                    columnas.Add(column.ColumnName);

                    if (column.DataType == typeof(DateTime))
                    {
                        if (HttpContext.Current.Session["DefaultLanguageID"] != null)
                        {
                            if (HttpContext.Current.Session["DefaultLanguageID"].ToString().Length > 0)
                            {
                                ws.Column(col).Style.Numberformat.Format = CultureInfo.CreateSpecificCulture(HttpContext.Current.Session["DefaultLanguageID"].ToString()).DateTimeFormat.ShortDatePattern;
                            }
                        }
                    }

                    col = col + 1;
                }


            }

            i = 2;

            foreach (DataRow item in dt.Rows)
            {
                int col2 = 1;

                foreach (string columnName in columnas)
                {
                    if (item[columnName].ToString().IndexOf("http:") > -1 || item[columnName].ToString().IndexOf("\\\\") > -1)
                    {
                        ws.Cells[i, col2].Hyperlink = new Uri(item[columnName].ToString());
                        char[] delimiter = new char[] { '\\' };
                        string[] array = item[columnName].ToString().Split(delimiter);
                        ws.Cells[i, col2].Value = array[array.Length - 1].Trim();
                    }
                    else
                        ws.Cells[i, col2].Value = item[columnName];

                    col2 = col2 + 1;
                }

                i++;
            }

            col = 1;
            foreach (DataColumn column in dt.Columns)
            {
                ws.Column(col).AutoFit();
                col++;
            }

            return pck.GetAsByteArray();
        }

        public byte[] ExportToExcel(DataTable dt, DataTable dt2)
        {
            var pck = new ExcelPackage(new FileInfo(HttpContext.Current.Server.MapPath("~/Templates/Default_Layout_Doble.xlsx")), true);
            var ws = pck.Workbook.Worksheets[1];


            var columnas = new List<string>();

            int i = 2;
            int col = 2;


            foreach (DataColumn column in dt.Columns)
            {
                string value = this.GetMessage(string.Format("{0}-{1}", dt.TableName, column.ColumnName));

                if (!string.IsNullOrEmpty(value))
                {
                    ws.Cells[i, col].Value = value;
                    columnas.Add(column.ColumnName);
                    col = col + 1;
                }
            }

            i = 3;

            foreach (DataRow item in dt.Rows)
            {
                int col2 = 2;

                foreach (string columnName in columnas)
                {
                    ws.Cells[i, col2].Value = item[columnName];
                    col2 = col2 + 1;
                }

                i++;
            }


            ws = pck.Workbook.Worksheets[2];


            columnas = new List<string>();

            i = 2;
            col = 2;


            foreach (DataColumn column in dt2.Columns)
            {
                string value = this.GetMessage(string.Format("{0}-{1}", dt2.TableName, column.ColumnName));

                if (!string.IsNullOrEmpty(value))
                {
                    ws.Cells[i, col].Value = value;
                    columnas.Add(column.ColumnName);
                    col = col + 1;
                }
            }

            i = 3;

            foreach (DataRow item in dt2.Rows)
            {
                int col2 = 2;

                foreach (string columnName in columnas)
                {
                    ws.Cells[i, col2].Value = item[columnName];
                    col2 = col2 + 1;
                }

                i++;
            }

            return pck.GetAsByteArray();
        }

        public byte[] ReportExportToExcel(DataTable dt)
        {
            var pck = new ExcelPackage(new FileInfo(HttpContext.Current.Server.MapPath("~/Templates/Default_Layout.xlsx")), true);
            var ws = pck.Workbook.Worksheets[1];


            var columnas = new List<string>();

            int i = 1;
            int col = 2;


            foreach (DataColumn column in dt.Columns)
            {
                string value = column.ColumnName;

                if (!string.IsNullOrEmpty(value))
                {
                    ws.Cells[i, col].Value = value;
                    columnas.Add(column.ColumnName);

                    if (column.DataType == typeof(DateTime))
                    {
                        if (HttpContext.Current.Session["DefaultLanguageID"] == null)
                        {
                            HttpContext.Current.Session["DefaultLanguageID"] = "es";
                        }

                        if (HttpContext.Current.Session["DefaultLanguageID"] == string.Empty)
                        {
                            HttpContext.Current.Session["DefaultLanguageID"] = "es";
                        }

                        if (HttpContext.Current.Session["DefaultLanguageID"] != null)
                        {
                            if (HttpContext.Current.Session["DefaultLanguageID"].ToString().Length > 0)
                            {
                                ws.Column(col).Style.Numberformat.Format = CultureInfo.CreateSpecificCulture(HttpContext.Current.Session["DefaultLanguageID"].ToString()).DateTimeFormat.ShortDatePattern;
                            }
                        }
                    }

                    col = col + 1;
                }


            }

            i = 3;

            foreach (DataRow item in dt.Rows)
            {
                int col2 = 2;

                foreach (string columnName in columnas)
                {
                    ws.Cells[i, col2].Value = item[columnName];
                    col2 = col2 + 1;
                }

                i++;
            }
            return pck.GetAsByteArray();
        }

        public static string DirectoryToXML(List<Dictionary<string, string>> registrosActuales)
        {
            string xmlStr = "<root></root>";

            if (registrosActuales.Count > 0)
            {
                xmlStr = "<root>";

                var dictionaryPaso = new Dictionary<string, string>();

                foreach (Dictionary<string, string> item in registrosActuales)
                {

                    dictionaryPaso = new Dictionary<string, string>();

                    foreach (var key in item)
                    {
                        if (!key.Key.Contains("$$"))
                        {
                            dictionaryPaso.Add(key.Key, HttpUtility.HtmlEncode(key.Value));
                        }
                    }

                    XElement el = new XElement("item", dictionaryPaso.Select(kv => new XElement(kv.Key, kv.Value)));
                    xmlStr = xmlStr + el.ToString();
                }

                xmlStr = xmlStr + "</root>";

            }

            return xmlStr;
        }

        public static string DirectoryToXML(List<Dictionary<string, object>> registrosActuales)
        {
            string xmlStr = "<root></root>";

            if (registrosActuales.Count > 0)
            {
                xmlStr = "<root>";

                var dictionaryPaso = new Dictionary<string, object>();

                foreach (Dictionary<string, object> item in registrosActuales)
                {

                    dictionaryPaso = new Dictionary<string, object>();

                    foreach (var key in item)
                    {
                        if (!key.Key.Contains("$$"))
                        {
                            dictionaryPaso.Add(key.Key, HttpUtility.HtmlEncode(key.Value));
                        }
                    }

                    XElement el = new XElement("item", dictionaryPaso.Select(kv => new XElement(kv.Key, kv.Value)));
                    xmlStr = xmlStr + el.ToString();
                }

                xmlStr = xmlStr + "</root>";

            }

            return xmlStr;
        }

        public static DataTable ToDataTable<T>(List<T> items)
        {
            DataTable dataTable = new DataTable(typeof(T).Name);

            //Get all the properties
            PropertyInfo[] Props = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);
            foreach (PropertyInfo prop in Props)
            {
                //Defining type of data column gives proper data table 
                var type = (prop.PropertyType.IsGenericType && prop.PropertyType.GetGenericTypeDefinition() == typeof(Nullable<>) ? Nullable.GetUnderlyingType(prop.PropertyType) : prop.PropertyType);
                //Setting column names as Property names
                dataTable.Columns.Add(prop.Name, type);
            }
            foreach (T item in items)
            {
                var values = new object[Props.Length];
                for (int i = 0; i < Props.Length; i++)
                {
                    //inserting property values to datatable rows
                    values[i] = Props[i].GetValue(item, null);
                }
                dataTable.Rows.Add(values);
            }
            //put a breakpoint here and check datatable
            return dataTable;
        }

        public static bool IsValidEmail(string strIn)
        {
            // Return true if strIn is in valid e-mail format.
            return Regex.IsMatch(strIn,
                   @"^(?("")("".+?""@)|(([0-9a-zA-Z]((\.(?!\.))|[-!#\$%&'\*\+/=\?\^`\{\}\|~\w])*)(?<=[0-9a-zA-Z])@))" +
                   @"(?(\[)(\[(\d{1,3}\.){3}\d{1,3}\])|(([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,6}))$");
        }
        public byte[] ExportToExcel_(List<DataTable> dt, string ExcludeItems)
        {



            if (dt.Count <= 0)
            {
                throw new Exception("No hay informacion en las tablas seleccionadas.");

            }

            var pck = new ExcelPackage();//(new FileInfo(HttpContext.Current.Server.MapPath("~/Templates/Default_Layout_Doble.xlsx")), true);

            var indexHoja = 1;
            foreach (DataTable dtbl in dt)
            {
                ExcelWorksheet ws;

                string[] enca2 = dtbl.TableName.Split('&');
                try
                {
                    ws = pck.Workbook.Worksheets.Add(enca2[0]);

                }
                catch (Exception e)
                {
                    ws = pck.Workbook.Worksheets.Add(dtbl.TableName);
                }



                //Encabezados
                string[] enca = null;
                if (enca2.Length > 1)
                {
                    enca = enca2;
                }
                else
                {
                    enca = dtbl.Columns.Contains("nombreTabla") && dtbl.Rows.Count > 0 ? dtbl.Rows[0]["nombreTabla"].ToString().Split('&') : null;
                }
                //nombre de la hoja
                //ws.Workbook.Worksheets[indexHoja].Name = dtbl.TableName;
                string range = string.Empty;
                int indx = 0;
                int andx = 0;
                string[] camposExcluir = ExcludeItems != null || ExcludeItems != "" ? ExcludeItems.ToString().Split(',') : null;

                if ((dtbl.Columns.Contains("nombreTabla") && dtbl.Rows.Count > 0) || enca2.Length > 0)
                { // Insercion de encabezado en hoja.
                    if (enca != null)
                    {
                        for (indx = 1; indx <= enca.Length; indx++)
                        {
                            ws.Cells[indx, 1].Value = enca[indx - 1];
                            range = "A" + indx + ":D" + indx;
                            ws.Cells[range].Merge = true;
                        }
                        andx = indx;
                        ws.View.FreezePanes(indx + 2, 1);
                    }
                }
                else
                    indx = 2;

                var columnas = new List<string>();

                int i = indx + 1;
                int col = 1;


                foreach (DataColumn column in dtbl.Columns)
                {
                    string value = column.ColumnName;// this.GetMessage(string.Format("{0}-{1}", dt.TableName, column.ColumnName));

                    if (!string.IsNullOrEmpty(value))
                    {
                        try
                        {
                            if (!camposExcluir.Contains(value))
                            {
                                ws.Cells[i, col].Value = value;
                                columnas.Add(column.ColumnName);
                                col = col + 1;
                            }
                        }
                        catch (Exception)
                        {
                            ws.Cells[i, col].Value = value;
                            columnas.Add(column.ColumnName);
                            col = col + 1;
                        }
                    }
                }

                i = indx + 2;

                if (dtbl.Rows.Count > 0)
                    foreach (DataRow item in dtbl.Rows)
                    {
                        int col2 = 1;

                        foreach (string columnName in columnas)
                        {
                            try
                            {
                                if (!camposExcluir.Contains(columnName))
                                {
                                    ws.Cells[i, col2].Value = item[columnName];
                                    col2 = col2 + 1;
                                }
                            }
                            catch (Exception)
                            {
                                ws.Cells[i, col2].Value = item[columnName];
                                col2 = col2 + 1;
                            }
                        }

                        i++;
                    }

                indexHoja++;
            }

            return pck.GetAsByteArray();
        }

        public static string NumeroALetras(decimal value)
        {
            string num2Text; value = Math.Truncate(value);
            if (value == 0) num2Text = "CERO";
            else if (value == 1) num2Text = "UNO";
            else if (value == 2) num2Text = "DOS";
            else if (value == 3) num2Text = "TRES";
            else if (value == 4) num2Text = "CUATRO";
            else if (value == 5) num2Text = "CINCO";
            else if (value == 6) num2Text = "SEIS";
            else if (value == 7) num2Text = "SIETE";
            else if (value == 8) num2Text = "OCHO";
            else if (value == 9) num2Text = "NUEVE";
            else if (value == 10) num2Text = "DIEZ";
            else if (value == 11) num2Text = "ONCE";
            else if (value == 12) num2Text = "DOCE";
            else if (value == 13) num2Text = "TRECE";
            else if (value == 14) num2Text = "CATORCE";
            else if (value == 15) num2Text = "QUINCE";
            else if (value < 20) num2Text = "DIECI" + NumeroALetras(value - 10);
            else if (value == 20) num2Text = "VEINTE";
            else if (value < 30) num2Text = "VEINTI" + NumeroALetras(value - 20);
            else if (value == 30) num2Text = "TREINTA";
            else if (value == 40) num2Text = "CUARENTA";
            else if (value == 50) num2Text = "CINCUENTA";
            else if (value == 60) num2Text = "SESENTA";
            else if (value == 70) num2Text = "SETENTA";
            else if (value == 80) num2Text = "OCHENTA";
            else if (value == 90) num2Text = "NOVENTA";
            else if (value < 100) num2Text = NumeroALetras(Math.Truncate(value / 10) * 10) + " Y " + NumeroALetras(value % 10);
            else if (value == 100) num2Text = "CIEN";
            else if (value < 200) num2Text = "CIENTO " + NumeroALetras(value - 100);
            else if ((value == 200) || (value == 300) || (value == 400) || (value == 600) || (value == 800)) num2Text = NumeroALetras(Math.Truncate(value / 100)) + "CIENTOS";
            else if (value == 500) num2Text = "QUINIENTOS";
            else if (value == 700) num2Text = "SETECIENTOS";
            else if (value == 900) num2Text = "NOVECIENTOS";
            else if (value < 1000) num2Text = NumeroALetras(Math.Truncate(value / 100) * 100) + " " + NumeroALetras(value % 100);
            else if (value == 1000) num2Text = "MIL";
            else if (value < 2000) num2Text = "MIL " + NumeroALetras(value % 1000);
            else if (value < 1000000)
            {
                num2Text = NumeroALetras(Math.Truncate(value / 1000)) + " MIL";
                if ((value % 1000) > 0)
                {
                    num2Text = num2Text + " " + NumeroALetras(value % 1000);
                }
            }
            else if (value == 1000000)
            {
                num2Text = "UN MILLON";
            }
            else if (value < 2000000)
            {
                num2Text = "UN MILLON " + NumeroALetras(value % 1000000);
            }
            else if (value < 1000000000000)
            {
                num2Text = NumeroALetras(Math.Truncate(value / 1000000)) + " MILLONES ";
                if ((value - Math.Truncate(value / 1000000) * 1000000) > 0)
                {
                    num2Text = num2Text + " " + NumeroALetras(value - Math.Truncate(value / 1000000) * 1000000);
                }
            }
            else if (value == 1000000000000) num2Text = "UN BILLON";
            else if (value < 2000000000000) num2Text = "UN BILLON " + NumeroALetras(value - Math.Truncate(value / 1000000000000) * 1000000000000);
            else
            {
                num2Text = NumeroALetras(Math.Truncate(value / 1000000000000)) + " BILLONES";
                if ((value - Math.Truncate(value / 1000000000000) * 1000000000000) > 0)
                {
                    num2Text = num2Text + " " + NumeroALetras(value - Math.Truncate(value / 1000000000000) * 1000000000000);
                }
            }
            return num2Text;
        }



    }


}
