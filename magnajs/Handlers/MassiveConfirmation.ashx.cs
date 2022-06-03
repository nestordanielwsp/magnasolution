using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.SessionState;  
using logic;
using logic.Class;
using System.Configuration;

namespace Osram.Handlers
{
    /// <summary>
    /// Summary description for MassiveConfirmation
    /// </summary>
    public class MassiveConfirmation : IHttpHandler, IRequiresSessionState
    {
         
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/json";
            try
            {

                if (context.Request.Files.Count > 0)
                {
                    HttpFileCollection files = context.Request.Files;
                    HttpPostedFile file = files[0];
                    string ext = Path.GetExtension(file.FileName);
                    var fileName = Path.GetFileName(file.FileName);
                    var fechaActual = DateTime.Today;
                    string carpetaAnioMes = fechaActual.Month < 10 ? fechaActual.Year + "0" + fechaActual.Month + "\\" :
                                            fechaActual.Year.ToString() + fechaActual.Month.ToString() + "\\";
                    //Se guarda en la session que se recibe como parametro


                    var result = ReadFile(context);
                    result.FileName = fileName;
                    result.FileExtension = ext.Substring(1);
                    result.FileRoute = carpetaAnioMes;
                    if (files.Count > 0)
                    {
                        context.Response.Write(SerializerJson(result));
                    }
                }


            }
            catch (Exception ex)
            {
                context.Response.Write(SerializerJson(new MassiveConfirmation.uploadResult() { HasError = true, Message = ex.Message, FileName = string.Empty }));
            }  
        }

        private MassiveConfirmation.uploadResult ReadFile(HttpContext context)
        {
            var respuesta = new Dictionary<object, object>();
            var arr = new ArrayList();
            var result = new MassiveConfirmation.uploadResult();
            try
            {

                HttpPostedFile hpf = context.Request.Files[0] as HttpPostedFile;
                string ext = Path.GetExtension(hpf.FileName);
                var fileName = Path.GetFileName(hpf.FileName);

                byte[] fileData = null;
                using (var binaryReader = new BinaryReader(hpf.InputStream))
                {
                    fileData = binaryReader.ReadBytes(hpf.ContentLength);
                }

                var AnexoActual = new AnexoInfo(fileName, hpf.ContentType, fileData, ext);


                HttpContext.Current.Session[context.Request.Form["SesionName"].ToString()] = AnexoActual;

                //var page = new JUPMassiveConfirmation();
                //ExcelPackage datosExcel = new ExcelPackage();
                //HttpPostedFile archivo = context.Request.Files[0];
                //datosExcel = new ExcelPackage(archivo.InputStream);
                //ExcelWorksheet ws = datosExcel.Workbook.Worksheets[1];

                //var data = GetInformation(ws); 

                result.Message = string.Empty;
                result.HasError = false;

                //if (data.Count > MaximumRows)
                //{
                result.Message = "Ok";// page.GetMessage("msgExcelMaximumRows");
                //result.HasError = true;
                result.Data = null;
                result.DataError = null;
                //return result;
                //}


                //result.Data = data;
                //result.DataError = data.Where(d => d["Message"] != "").ToList();
                //HttpContext.Current.Session[context.Request.Form["SesionName"].ToString()] = result;
            }
            catch (Exception ex)
            {
                result.Message = ex.Message;
                result.HasError = true;
                result.Data = null;
            }

            return result;
        }

        

        public void StreamToArray(Stream InputStream, out byte[] bytes, int Length)
        {
            bytes = new byte[Length];
            using (Stream stream = InputStream)
            {
                stream.Read(bytes, 0, Length);
            }
        }


        public class uploadResult
        {
            public string Message { get; set; }
            public string FileName { get; set; }
            public string FileExtension { get; set; }            
            public string FileRoute { get; set; }
            public bool HasError { get; set; }
            public List<Dictionary<string, object>> Data { get; set; }
            public List<Dictionary<string, object>> DataError { get; set; }
        }

        public static string SerializerJson(uploadResult a)
        {
            System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer() { MaxJsonLength = 2147483644 };
            return serializer.Serialize(a);
        }


        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}