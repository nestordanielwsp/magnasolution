using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using logic;
using System.Web.Script.Serialization;
using System.Text.RegularExpressions;
using System.Xml.Linq;
using Infraestructura.Archivos;

namespace magnajs.Codes
{
    public class Utilities : BasePage
    {
        /// <summary>
        /// Borra los archivos que no se ocuparon y tienen una antigüedad con los dias que se especifican
        /// </summary>
        /// <param name="path">Ruta de los archivos</param>
        /// <param name="daysToDelete">Dias de antigüedad para borrar archivos</param>
        /// <param name="page"></param>
        public static void DeleteFiles(string path, string spName, int daysToDelete, string page)
        {
            var logicAcces = new logic_acces(ConexionDB);
            var archivos = Directory.GetFiles(path);
            var data = new Dictionary<string, object>();
            foreach (var archivo in archivos)
            {
                var informacionArchivo = new FileInfo(archivo);
                var fechaCreacion = informacionArchivo.CreationTime.AddDays(daysToDelete);

                var index = archivo.LastIndexOf("\\") + 1;

                if (fechaCreacion < DateTime.Today)
                {
                    var fileName = archivo.Substring(index, archivo.Length - index);
                    var nameSplit = fileName.Split('_');
                    data[page + "ArchivoId"] = nameSplit[0];

                    logicAcces.ExecuteNonQuery(spName, data);
                    File.Delete(archivo);
                }
            }
        }
        /// <summary>
        /// Borra los archivos que no se ocuparon y tienen una antigüedad con los dias que se especifican
        /// </summary>
        /// <param name="path">Ruta de los archivos</param>
        /// <param name="daysToDelete">Dias de antigüedad para borrar archivos</param>
        /// <param name="page"></param>
        public static void DeleteFiles(string path, int daysToDelete)// todo cambiar a azure
        {
            //if (!Directory.Exists(path))
            //    Directory.CreateDirectory(path);

            //var archivos = Directory.GetFiles(path);
            //var data = new Dictionary<string, object>();
            //foreach (var archivo in archivos)
            //{
            //    var informacionArchivo = new FileInfo(archivo);
            //    var fechaCreacion = informacionArchivo.CreationTime.AddDays(daysToDelete);

            //    if (fechaCreacion < DateTime.Today)
            //    {
            //        File.Delete(archivo);
            //    }
            //}
        }

        public static void DeleteFiles(string path, List<Dictionary<string, object>> files)
        {
            if (files.Count > 0)
            {
                var rutaArchivo = DateTime.Today.ToString("yyyyMM");
                var newPath = path + "\\" + rutaArchivo;

                if (!Directory.Exists(newPath))
                    Directory.CreateDirectory(newPath);

                string[] fileNewPaths = Directory.GetFiles(newPath);
                var exits = false;

                foreach (var fileNewPath in fileNewPaths)
                {
                    exits = false;
                    foreach (var file in files)
                    {
                        if (fileNewPath.Contains(file["NombreAnexo"].ToString()))
                        {
                            exits = true;
                            break;
                        }
                    }

                    if (!exits)
                        File.Delete(fileNewPath);
                    else
                        exits = false;

                }
            }

        }

        /// <summary>
        /// Borra los archivos que se eliminaron en pantalla, en fileSystem y en base de datos
        /// </summary>
        /// <param name="path"></param>
        /// <param name="spName"></param>
        /// <param name="jsonFiles"></param>
        /// <param name="page"></param>
        public static void DeleteFiles(string path, string spName, object jsonFiles, string page)
        {
            var files = StringToList(jsonFiles);
            var logicAcces = new logic_acces(ConexionDB);
            foreach (var file in files)
            {
                logicAcces.ExecuteNonQuery(spName, file);

                var filePath = path + file["RutaArchivo"] + "\\" + file[page + "ArchivoId"] +
                               "_" + file["NombreArchivo"];

                if (File.Exists(filePath))
                {
                    File.Delete(filePath);
                }
            }
        }

        public static void DeleteFilesEmpleadoExterno(string path, string spName, object jsonFiles, string page, object mainId)
        {
            var files = StringToList(jsonFiles);
            var logicAcces = new logic_acces(ConexionDB);
            foreach (var file in files)
            {
                logicAcces.ExecuteNonQuery(spName, file);

                var filePath = path + file["RutaArchivo"] + "\\" + file[page + "ArchivoId"] + "_" + mainId + "_" + file["NombreArchivo"];

                if (File.Exists(filePath))
                {
                    File.Delete(filePath);
                }
            }
        }

        public static void MoveFileToDateDirectory(string path, Dictionary<string, object> data,
            string idName, string adittionalFolder = "")
        {
            var storage = new AlmacenamientoAzureServicio();
            var fileName = data["RutaArchivo"].ToString();
            var newName = fileName.Replace(data["UID"].ToString(), data[idName] + "_");
            var dateDirectory = DateTime.Today.ToString("yyyyMM") + "/";
            var newPath = path + (adittionalFolder != "" ? adittionalFolder + "/" : "") + dateDirectory;
          
            path += fileName;
            fileName = newName;
            newPath += fileName;

            storage.Mover(path, newPath);

            data["RutaArchivo"] = (adittionalFolder != "" ? adittionalFolder + "/" : "") + dateDirectory + fileName;

        }

        public static void MoveFiles(string path, List<Dictionary<string, object>> files,
            string spName, string page, object mainId)
        {
            var logicAcces = new logic_acces(ConexionDB);
            var rutaArchivo = DateTime.Today.ToString("yyyyMM");
            var newPath = path + rutaArchivo;
            CreateDirectory(newPath);
            foreach (var file in files)
            {
                var id = file[page + "ArchivoId"];
                var filePath = path + id + "_" + file["NombreArchivo"];
                var newFilePath = newPath + "\\" + id + "_" + file["NombreArchivo"];
                if (File.Exists(filePath))
                {
                    file[page + "Id"] = mainId;
                    file["RutaArchivo"] = rutaArchivo;
                    logicAcces.ExecuteNonQuery(spName, file);
                    File.Move(filePath, newFilePath);
                }
            }
        }

        public static void MoveFiles(string path, List<Dictionary<string, object>> files)
        {
            var rutaArchivo = DateTime.Today.ToString("yyyyMM");
            var newPath = path + "\\" + rutaArchivo;
            CreateDirectory(newPath);
            foreach (var file in files)
            {
                if (file.ContainsKey("file"))
                {

                    var filePath = path + "\\" + file["file"].ToString();
                    var newFilePath = newPath + "\\" + file["file"].ToString();
                    if (File.Exists(filePath) && !File.Exists(newFilePath))
                    {
                        File.Move(filePath, newFilePath);
                    }

                }
            }
        }

        public static void MoveFiles(string path, Dictionary<string, object> file, string key)
        {
            var rutaArchivo = DateTime.Today.ToString("yyyyMM");
            var newPath = path + "\\" + rutaArchivo;
            CreateDirectory(newPath);

            if (file.ContainsKey(key))
            {

                var filePath = path + "\\" + file[key].ToString();
                var newFilePath = newPath + "\\" + file[key].ToString();
                if (File.Exists(filePath) && !File.Exists(newFilePath))
                {
                    File.Move(filePath, newFilePath);
                }

            }

        }


        public static void MoveFiles(string path, string path2, List<Dictionary<string, object>> files)
        {
            var rutaArchivo = "";
            var newPath = path2 + "\\" + rutaArchivo;
            CreateDirectory(newPath);
            foreach (var file in files)
            {
                if (file.ContainsKey("file"))
                {

                    var filePath = path + "\\" + file["file"].ToString();
                    var newFilePath = newPath + "\\" + file["file"].ToString();
                    if (File.Exists(filePath) && !File.Exists(newFilePath))
                    {
                        File.Move(filePath, newFilePath);
                    }

                }
            }
        }

        public static void MoveFiles(string path, string path2, Dictionary<string, object> file, string key)
        {
            var rutaArchivo = "";
            var newPath = path2 + "\\" + rutaArchivo;
            CreateDirectory(newPath);

            if (file.ContainsKey(key))
            {

                var filePath = path + "\\" + file[key].ToString();
                var newFilePath = newPath + "\\" + file[key].ToString();
                if (File.Exists(filePath) && !File.Exists(newFilePath))
                {
                    File.Move(filePath, newFilePath);
                }

            }

        }

        public static void CopyFiles(string path, string path2, List<Dictionary<string, object>> files)
        {
            var rutaArchivo = "";
            var newPath = path2 + "\\" + rutaArchivo;
            CreateDirectory(newPath);
            foreach (var file in files)
            {
                if (file.ContainsKey("file"))
                {

                    var filePath = path + "\\" + file["file"].ToString();
                    var newFilePath = newPath + "\\" + file["file"].ToString();
                    if (File.Exists(filePath) && !File.Exists(newFilePath))
                    {
                        File.Copy(filePath, newFilePath);
                    }

                }
            }
        }

        public static void CopyFiles(string path, string path2, Dictionary<string, object> file, string key)
        {
            var rutaArchivo = "";
            var newPath = path2 + "\\" + rutaArchivo;
            CreateDirectory(newPath);

            if (file.ContainsKey(key))
            {

                var filePath = path + "\\" + file[key].ToString();
                var newFilePath = newPath + "\\" + file[key].ToString();
                if (File.Exists(filePath) && !File.Exists(newFilePath))
                {
                    File.Copy(filePath, newFilePath);
                }

            }

        }

        public static void CopyDirectory(DirectoryInfo source, DirectoryInfo destination)
        {
            if (!destination.Exists)
            {
                destination.Create();
            }

            // Copy all files.
            FileInfo[] files = source.GetFiles();
            foreach (FileInfo file in files)
            {
                file.CopyTo(Path.Combine(destination.FullName,
                    file.Name), true);
            }

            // Process subdirectories.
            DirectoryInfo[] dirs = source.GetDirectories();
            foreach (DirectoryInfo dir in dirs)
            {
                // Get destination directory.
                string destinationDir = Path.Combine(destination.FullName, dir.Name);

                // Call CopyDirectory() recursively.
                CopyDirectory(dir, new DirectoryInfo(destinationDir));
            }
        }

        public static void MoveFilesEmpleadoExterno(string path, List<Dictionary<string, object>> files,
            string spName, string page, object mainId)
        {
            var logicAcces = new logic_acces(ConexionDB);
            var rutaArchivo = DateTime.Today.ToString("yyyyMM");
            var newPath = path + rutaArchivo;
            CreateDirectory(newPath);
            foreach (var file in files)
            {
                var id = file[page + "ArchivoId"];
                var filePath = path + id + "_" + file["NombreArchivo"];
                var newFilePath = newPath + "\\" + id + "_" + mainId + "_" + file["NombreArchivo"];
                if (File.Exists(filePath))
                {
                    file[page + "Id"] = mainId;
                    file["RutaArchivo"] = rutaArchivo;
                    logicAcces.ExecuteNonQuery(spName, file);
                    File.Move(filePath, newFilePath);
                }
            }
        }

        public static void MoveFilesEmpleadoExterno(string path, List<Dictionary<string, object>> files,
            string spName, string page, List<Dictionary<string, object>> empleadosExternos)
        {
            var logicAcces = new logic_acces(ConexionDB);
            var rutaArchivo = DateTime.Today.ToString("yyyyMM");
            var newPath = path + rutaArchivo;
            CreateDirectory(newPath);
            foreach (var file in files)
            {
                var id = file[page + "ArchivoId"];
                var filePath = path + id + "_" + file["NombreArchivo"];
                //var newFilePath = newPath + "\\" + id + "_" + file["NombreArchivo"];
                if (File.Exists(filePath))
                {
                    foreach (var empleadoExterno in empleadosExternos)
                    {
                        var newFilePath = newPath + "\\" + id + "_" + empleadoExterno["EmpleadoExternoId"] + "_" + file["NombreArchivo"];

                        //file[page + "Id"] = mainId;
                        file[page + "Id"] = empleadoExterno["EmpleadoExternoId"];
                        file["RutaArchivo"] = rutaArchivo;
                        logicAcces.ExecuteNonQuery(spName, file);
                        File.Copy(filePath, newFilePath);
                        //File.Move(filePath, newFilePath);
                    }
                    File.Delete(filePath);
                }
            }
        }

        public static void CreateDirectory(string path)
        {
            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
            }
        }

        public static List<Dictionary<string, object>> StringToList(object json, bool isArray = false)
        {
            json = isArray ? new JavaScriptSerializer().Serialize(json) : json;

            var list = new JavaScriptSerializer().Deserialize<List<Dictionary<string, object>>>(json.ToString());
            return list;
        }

        public static List<Dictionary<string, object>> DataTableToDictionaryList(DataTable dt)
        {
            var result = new List<Dictionary<string, object>>();
            //or var result = new List<Dictionary<string, string>>();

            foreach (DataRow row in dt.Rows)
            {
                var dictRow = new Dictionary<string, object>();
                foreach (DataColumn col in dt.Columns)
                {
                    dictRow.Add(col.ColumnName, row[col]);
                    //or dictRow.Add(col.ColumnName, row[col].ToString());
                }

                result.Add(dictRow);
            }

            return result;
        }

        /// <summary>
        /// Guarda listas en la base de datos
        /// </summary>
        /// <param name="spName"></param>
        /// <param name="jSon"></param>
        /// <param name="mainIdName"></param>
        /// <param name="mainId"></param>
        public static void SaveList(string spName, object jSon, string mainIdName, object mainId)
        {
            var logicAcces = new logic_acces(ConexionDB);
            var list = new JavaScriptSerializer().Deserialize<List<Dictionary<string, object>>>(jSon.ToString());
            foreach (var item in list)
            {
                item[mainIdName] = mainId;
                logicAcces.ExecuteNonQuery(spName, item);
            }
        }

        public static void DownloadFile(string path, string fileName)
        {
            if (File.Exists(path))
            {
                Byte[] bytes = File.ReadAllBytes(path);

                HttpContext.Current.Response.AddHeader("Content-disposition", "attachment; filename=" + fileName);
                HttpContext.Current.Response.ContentType = "application/octet-stream";
                HttpContext.Current.Response.BinaryWrite(bytes);
                HttpContext.Current.Response.End();
            }
            else
            {
                var archivoPath = HttpContext.Current.Server.MapPath("~/Templates/MensajeArchivoNoExiste.txt");
                Byte[] bytes = File.ReadAllBytes(archivoPath);
                HttpContext.Current.Response.AddHeader("Content-disposition", "attachment; filename=ArchivoInexistente.txt");
                HttpContext.Current.Response.ContentType = "application/octet-stream";
                HttpContext.Current.Response.BinaryWrite(bytes);
                HttpContext.Current.Response.End();
            }
        }

        /// <summary>
        /// Ejecuta el sp especificado para actualizar la base de datos
        /// </summary>
        /// <param name="spName"></param>
        /// <param name="data"></param>
        /// <param name="keyField"></param>
        public static void SaveData(string spName, Dictionary<string, object> data, string keyField = "")
        {
            if (keyField != "" && !data.ContainsKey(keyField))
            {
                data[keyField] = 0;
            }

            var logicAcces = new logic_acces(ConexionDB);
            logicAcces.ExecuteNonQuery(spName, data);
        }

        public static void SaveDetailList(Dictionary<string, object> mainData, string additionalField, string detailName,
            string spName, bool isArray = false)
        {
            var additionalFields = new[] { additionalField };
            SaveDetailList(mainData, additionalFields, detailName, spName, isArray);
        }

        public static void SaveDetailList(Dictionary<string, object> mainData, string[] additionalFields, string detailName,
            string spName, bool isArray = false)
        {
            if (mainData.ContainsKey(detailName))
            {
                var logicAcces = new logic_acces(ConexionDB);

                var json = isArray ? new JavaScriptSerializer().Serialize(mainData[detailName]) : mainData[detailName];

                var detailList = StringToList(json);

                foreach (var detail in detailList)
                {
                    foreach (var field in additionalFields)
                    {
                        detail[field] = mainData[field];
                    }

                    logicAcces.ExecuteNonQuery(spName, detail);
                }
            }
        }

        public static Dictionary<string, object> GetItem(string spName, Dictionary<string, object> data = null, bool esValidarSesion = true)
        {
            var logicAcces = new logic_acces(ConexionDB,esValidarSesion);
            var page = new logic.BasePage();
            var response = new Dictionary<string, object>();

            data = data ?? new Dictionary<string, object>();
            DataTable dt = logicAcces.ExecuteQuery(spName, data).Tables[0];
            var responseList = page.DataTableToMap(dt);

            if (responseList.Count > 0)
            {
                response = responseList[0];
            }

            return response;
        }

        public static List<Dictionary<string, object>> GetDataSesion(string spName, Dictionary<string, object> data)
        {
            var logicAcces = new logic_acces(ConexionDB,false);
            var page = new logic.BasePage();
            DataTable dt = logicAcces.ExecuteQuery(spName, data).Tables[0];
            var response = page.DataTableToMap(dt);
            return response;
        }

        /// <summary>
        /// Ejecuta el sp especificado para obtener datos de la base de datos
        /// </summary>
        /// <param name="spName"></param>
        /// <param name="data"></param>
        /// <returns></returns>
        public static List<Dictionary<string, object>> GetData(string spName, Dictionary<string, object> data)
        {
            var logicAcces = new logic_acces(ConexionDB);
            var page = new logic.BasePage();
            DataTable dt = logicAcces.ExecuteQuery(spName, data).Tables[0];
            var response = page.DataTableToMap(dt);
            return response;
        }

        public static Dictionary<string, object> GetDataWithDetail(string spName, Dictionary<string, object> data,
            string detailName)
        {
            var logicAcces = new logic_acces(ConexionDB);
            var page = new logic.BasePage();
            var response = new Dictionary<string, object>();

            DataSet dt = logicAcces.ExecuteQuery(spName, data);
            var responseList = page.DataTableToMap(dt.Tables[0]);

            if (responseList.Count > 0)
            {
                response = responseList[0];
                var detail = dt.Tables[1];
                response[detailName] = page.DataTableToMap(detail);
            }

            return response;
        }



        public static Dictionary<string, object> GetDataWithDetail(string spName, Dictionary<string, object> data,
            string[] detailList)
        {
            var logicAcces = new logic_acces(ConexionDB);
            var page = new logic.BasePage();
            var response = new Dictionary<string, object>();

            DataSet dt = logicAcces.ExecuteQuery(spName, data);
            var responseList = page.DataTableToMap(dt.Tables[0]);

            if (responseList.Count > 0)
            {
                response = responseList[0];

                var totalList = detailList.Count();
                for (var i = 0; i < totalList; i++)
                {
                    var detail = dt.Tables[i + 1];
                    response[detailList[i]] = page.DataTableToMap(detail);
                }
            }

            return response;
        }


        public static object ParseValue(Dictionary<string, object> dictionary, string dictionaryKey, string dataType)
        {
            try
            {
                var value = ValidateDictionaryKey(dictionary, dictionaryKey);
                object result;
                switch (dataType)
                {
                    case "int":
                        int shortNumber;
                        Int32.TryParse(value, out shortNumber);
                        result = shortNumber;
                        break;
                    case "int64":
                        Int64 longNumber;
                        Int64.TryParse(value, out longNumber);
                        result = longNumber;
                        break;
                    case "Boolean":
                        Boolean booleanValue;
                        Boolean.TryParse(value, out booleanValue);
                        result = booleanValue;
                        break;
                    case "decimal":
                        Decimal decimalValue;
                        Decimal.TryParse(value, out decimalValue);
                        result = decimalValue;
                        break;
                    case "double":
                        Double doubleValue;
                        Double.TryParse(value, out doubleValue);
                        result = doubleValue;
                        break;
                    case "date":
                        DateTime dateTimeValue;
                        DateTime.TryParse(value, out dateTimeValue);
                        result = dateTimeValue;
                        break;
                    default:
                        result = value;
                        break;
                }
                return result;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public static string ValidateDictionaryKey(Dictionary<string, object> dictionary, string dictionaryKey)
        {
            var value = dictionary.ContainsKey(dictionaryKey) ? dictionary[dictionaryKey] : "";
            var result = value ?? "";
            return result.ToString();
        }

        public static bool IsValidMail(string emails)
        {
            string expresion = "\\w+([-+.']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
            string[] arrEmails = emails.Split(',');
            foreach (string email in arrEmails)
            {
                if (Regex.IsMatch(email, expresion))
                {
                    if (Regex.Replace(email, expresion, String.Empty).Length > 0)
                    { /*throw (new Exception("No se envió el mensaje. Dirección de Correo no válida " + email));*/ return false; }
                }
                else
                { /*throw (new Exception("No se envió el mensaje. Dirección de Correo no válida " + email));*/ return false; }
            }
            return true;
        }
       
        public static string ObtenerRutaArchivos(int MateriaID)
        {
            var conf = new BasePage();
            Dictionary<string, object> datosNotificacion = new Dictionary<string, object>();
            var a = new logic_acces(ConexionDB);

            datosNotificacion.Add("MaterialID", MateriaID);
            datosNotificacion.Add("PathArchivos", conf.GetAppSetting("CarpetaArchivos"));

            DataTable dtNotificacion = a.ExecuteQuery("NotificacionArchivos_Sel", datosNotificacion).Tables[0];

            return dtNotificacion.Rows[0]["RutaArchivos"].ToString();

        }

        public static XElement ConvertToXml(List<Dictionary<string, object>> lista)
        {
            if (lista == null) return null;

            var xmlElements = new XElement("root",
                lista.Select(e =>
                    new XElement("row",
                        e.Select(kv => new XElement(kv.Key, kv.Value)))
                    )
                );

            return xmlElements;
        }

        public static string GetString(Dictionary<string, object> data, string property, string value = "")
        {
            var result = "";
            if (data.ContainsKey(property) && data[property] != null)
            {
                result = data[property].ToString();
            }
            //El diccionario na trae la llave, pero como trae el string value se creara la llave con el valor de value
            else if (value != "")
            {
                data[property] = value;
            }

            return result;
        }

        public static int GetInt(Dictionary<string, object> data, string property, string value = "")
        {
            var result = 0;
            if (data.ContainsKey(property) && data[property] != null)
            {
                int.TryParse(data[property].ToString(), out result);
            }
            //El diccionario na trae la llave, pero como trae el string value se creara la llave con el valor de value
            else if (value != "")
            {
                int.TryParse(value, out result);
                data[property] = result;
            }

            return result;
        }

        public static decimal GetDecimal(Dictionary<string, object> data, string property, string value = "")
        {
            decimal result = 0;
            if (data.ContainsKey(property) && data[property] != null)
            {
                decimal.TryParse(data[property].ToString(), out result);
            }
            //El diccionario na trae la llave, pero como trae el string value se creara la llave con el valor de value
            else if (value != "")
            {
                decimal.TryParse(value, out result);
                data[property] = result;
            }

            return result;
        }

        public static bool GetBool(Dictionary<string, object> data, string property, string value = "")
        {
            bool result = false;
            if (data.ContainsKey(property) && data[property] != null)
            {
                bool.TryParse(data[property].ToString(), out result);
            }
            //El diccionario na trae la llave, pero como trae el string value se creara la llave con el valor de value
            else if (value != "")
            {
                bool.TryParse(value, out result);
                data[property] = result;
            }

            return result;
        }
        public static void EnviarCorreo(Dictionary<string, object> datos, Dictionary<string, object> datosCorreo, string[] campos)
        {
            try
            {
                if (datosCorreo.Count > 0)
                {
                    var emails = datosCorreo["Correo"].ToString().Split(',');
                    var emailCc = Utilities.GetString(datosCorreo, "EmailCc").Split(',');

                    var subject = datosCorreo["Subject"].ToString();
                    var body = datosCorreo["Body"].ToString();

                    if (ConfigurationManager.AppSettings["EmailPruebas"] != null)
                    {
                        body += "<br/> Emails originales(" + string.Join(",", emails) + " emailCc: " + string.Join(",", emailCc) + ")";
                        emails = new[] { ConfigurationManager.AppSettings["EmailPruebas"] };
                        emailCc = new string[0];
                    }


                    foreach (var campo in campos)
                    {
                        body = body.Replace("{" + campo + "}", Utilities.GetString(datosCorreo, campo));
                    }

                    string error;
                    BasePage.SendMail(emails, emailCc, subject, body, true, new Dictionary<string, byte[]>(), out error);
      
                    if (error != "")
                    {
                        datos["ErrorParaUsuario"] =
                            string.Format(
                                "En este momento no es posible enviar el correo a: {0} favor de informar al Administrador." + emails[0],
                                datosCorreo["Correo"]);
                        datos["ErrorParaTi"] = "Error al enviar el correo: " + error;
                    }
                }
            }
            catch (Exception ex)
            {
                datos["ErrorParaUsuario"] =
                             string.Format(
                                 "En este momento no es posible enviar el correo a: {0} favor de informar al Administrador." + ex.Message ,
                                 datosCorreo["Correo"]);
                datos["ErrorParaTi"] = "Error al enviar el correo: " + ex.Message;
            }
        }
        public static void EnviarCorreoTareaPendiente(Dictionary<string, object> datos, TareaPendiente tareaPendiente)
        {
            datos["TareaPendienteId"] = (int) tareaPendiente;
            var datosCorreo = Utilities.GetItem("TareaPendienteNotificacion_Get", datos);
            var campos = new[] { "Codigo", "Nombre" };

            EnviarCorreo(datos, datosCorreo, campos);
        }

        public static void EnviarCorreoTareaPendiente(Dictionary<string, object> datos)
        {
            var datosCorreo = Utilities.GetItem("TareaPendienteNotificacion_Get", datos, false);
            var campos = new[] { "Codigo", "Nombre" };

            EnviarCorreo(datos, datosCorreo, campos);
        }

        public static string Right(string input, int count)
        {
            return input.Substring(Math.Max(input.Length - count, 0), Math.Min(count, input.Length));
        }

        public static DataTable DistinctRows(DataTable tb, string ColumnName)
        {
            DataTable shortTable = null; //tabla que se regresara
            string val = "";  //variable filtro
            shortTable = new DataTable(); // Inicializa nueva tabla
            try
            {
                shortTable = tb.Clone(); // Clona tabla Source

                shortTable.ImportRow(tb.Rows[0]);//Agrega el primer registro

                val = shortTable.Rows[0][ColumnName].ToString(); //agrega valor filtro a la variable

                foreach (DataRow dr in tb.Rows)
                {
                    if (val != dr[ColumnName].ToString()) //Compara contenido del registro, si son iguales los descarata sino agrega registro a la nueva tabla
                    {
                        shortTable.ImportRow(dr); //importa Registro a la nueva tabla
                    }

                    val = dr[ColumnName].ToString(); //Siguiente valor del filtro
                }

                return shortTable; //Regresa nueva tabla
            }
            catch (Exception ex)
            {
                return null;
            }
        }
    }
}