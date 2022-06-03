using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using Newtonsoft.Json;

namespace CYP.Codes
{
    public class Robot
    {
        public Dictionary<int, string> IdCampos;

        public Robot()
        {
            IdCampos = new Dictionary<int, string>
            {
                {1, Cliente},
                {2, Vendedor},
                {3, CentroCostos},
                {4, CuentaContable},
                {5, Subcuenta}
            };
        }
                       
        private const string Cliente = @"[{'Campo': 'CodigoCliente', 'Posicion': '0', 'TipoDato': ''},
	                            {'Campo': 'NombreCliente', 'Posicion': '1', 'TipoDato': ''},
	                            {'Campo': 'CobrA', 'Posicion': '2', 'TipoDato': ''},
	                            {'Campo': 'Rfc', 'Posicion': '3', 'TipoDato': ''},
	                            {'Campo': 'LimiteCredito', 'Posicion': '4', 'TipoDato': 'decimal'},
	                            {'Campo': 'TerminosCredito', 'Posicion': '5', 'TipoDato': ''},
	                            {'Campo': 'VendedorId', 'Posicion': '6', 'TipoDato': 'int'},
	                            {'Campo': 'CanalId', 'Posicion': '7', 'TipoDato': 'int'},
	                            {'Campo': 'ListaPrecios', 'Posicion': '8', 'TipoDato': ''},
	                            {'Campo': 'ZonaImpuestos', 'Posicion': '9', 'TipoDato': ''},
	                            {'Campo': 'ClaseImpuestos', 'Posicion': '10', 'TipoDato': ''},
	                            {'Campo': 'UsoImpuestos', 'Posicion': '11', 'TipoDato': ''},
	                            {'Campo': 'RelacionComercial', 'Posicion': '12', 'TipoDato': ''},
	                            {'Campo': 'Direccion1', 'Posicion': '13', 'TipoDato': ''},
	                            {'Campo': 'Direccion2', 'Posicion': '14', 'TipoDato': ''},
	                            {'Campo': 'Direccion3', 'Posicion': '15', 'TipoDato': ''},
	                            {'Campo': 'Municipio', 'Posicion': '16', 'TipoDato': ''},
	                            {'Campo': 'Ciudad', 'Posicion': '17', 'TipoDato': ''},
	                            {'Campo': 'CodigoPostal', 'Posicion': '18', 'TipoDato': ''},
	                            {'Campo': 'Estado', 'Posicion': '19', 'TipoDato': ''},
	                            {'Campo': 'Pais', 'Posicion': '20', 'TipoDato': ''},
	                            {'Campo': 'Moneda', 'Posicion': '21', 'TipoDato': ''},
	                            {'Campo': 'NoIdentificador', 'Posicion': '22', 'TipoDato': ''},
	                            {'Campo': 'Active', 'Posicion': '23', 'TipoDato': 'stringToBool'},
	                            {'Campo': 'RetencionCredito', 'Posicion': '24', 'TipoDato': 'stringToBool'},
	                            {'Campo': 'CuentaLmClientes', 'Posicion': '25', 'TipoDato': ''},
                                {'Campo': 'CuentaLmVentas', 'Posicion': '26', 'TipoDato': ''},
	                            {'Campo': 'Gravables', 'Posicion': '27', 'TipoDato': 'stringToBool'},
	                            {'Campo': 'UltimaVenta', 'Posicion': '28', 'TipoDato': 'date', 'Formato':'MM/dd/yy'},
	                            {'Campo': 'Observaciones', 'Posicion': '29', 'TipoDato': ''},
	                            {'Campo': 'Almacen', 'Posicion': '30', 'TipoDato': ''}]";

        private const string Vendedor = @"[{'Campo': 'CodigoJefe', 'Posicion': '0', 'TipoDato': ''},
	                            {'Campo': 'CodigoVendedor', 'Posicion': '2', 'TipoDato': ''},
	                            {'Campo': 'NombreVendedor', 'Posicion': '3', 'TipoDato': ''}]";

         private const string CentroCostos = @"[{'Campo': 'GrupoPresupuesto', 'Posicion': '0', 'TipoDato': ''},
	                            {'Campo': 'MascaraCentroCosto', 'Posicion': '1', 'TipoDato': ''},
	                            {'Campo': 'NombreCentroCosto', 'Posicion': '2', 'TipoDato': ''},
	                            {'Campo': 'DescripcionCentroCosto', 'Posicion': '3', 'TipoDato': ''},
	                            {'Campo': 'Activo', 'Posicion': '4', 'TipoDato': 'stringToBool'},
	                            {'Campo': 'RecuperarEstructuraLm', 'Posicion': '5', 'TipoDato': 'stringToBool'},
	                            {'Campo': 'Saf', 'Posicion': '6', 'TipoDato': 'stringToBool'},
	                            {'Campo': 'SafFijadoFecha', 'Posicion': '7', 'TipoDato': 'stringToBool'},
	                            {'Campo': 'FechaModificacion', 'Posicion': '8', 'TipoDato': 'date', 'Formato': 'MM/dd/yyyy'},
	                            {'Campo': 'HoraModificacon', 'Posicion': '9', 'TipoDato': 'time'},
	                            {'Campo': 'UsuarioModificacion', 'Posicion': '10', 'TipoDato': ''},
	                            {'Campo': 'CodigoPerfil', 'Posicion': '11', 'TipoDato': ''},
	                            {'Campo': 'SafFijadoPor', 'Posicion': '12', 'TipoDato': 'stringToBool'},
	                            {'Campo': 'UsuarioResponsable', 'Posicion': '13', 'TipoDato': ''}]";

         private const string CuentaContable = @"[{'Campo': 'CuentaLm', 'Posicion': '0', 'TipoDato': ''},
	                            {'Campo': 'DescripcionCuentaContable', 'Posicion': '1', 'TipoDato': ''},
                                {'Campo': 'NombreCuentaContable', 'Posicion': '1', 'TipoDato': ''},
	                            {'Campo': 'TipoLm', 'Posicion': '2', 'TipoDato': ''},
	                            {'Campo': 'Subcuenta', 'Posicion': '3', 'TipoDato': 'stringToBool'},
	                            {'Campo': 'CuentaCentroCostos', 'Posicion': '4', 'TipoDato': 'stringToBool'},
	                            {'Campo': 'UsarApv', 'Posicion': '5', 'TipoDato': 'stringToBool'},
	                            {'Campo': 'Activo', 'Posicion': '6', 'TipoDato': 'stringToBool'}]";

         private const string Subcuenta = @"[{'Campo': 'GrupoPresupuesto', 'Posicion': '0', 'TipoDato': ''},
	                            {'Campo': 'MascaraSubcuenta', 'Posicion': '1', 'TipoDato': ''},
	                            {'Campo': 'Subcuenta', 'Posicion': '2', 'TipoDato': ''},
	                            {'Campo': 'DescripcionSubcuenta', 'Posicion': '3', 'TipoDato': ''},
	                            {'Campo': 'Active', 'Posicion': '4', 'TipoDato': 'stringToBool'},
	                            {'Campo': 'FechaModificacion', 'Posicion': '5', 'TipoDato': 'date', 'Formato': 'MM/dd/yyyy'},
	                            {'Campo': 'HoraModificacon', 'Posicion': '6', 'TipoDato': 'time'},
	                            {'Campo': 'UsuarioModificacion', 'Posicion': '7', 'TipoDato': ''}]";


        public bool Sincronizar(Dictionary<string, object> data = null)
        {
            var servidor = "189.206.130.31";
            var user = "qmx_exertus";
            var pass = "Qu4L4_Ex3rtu$";
            var directoryFtp = "quala/interfaces/qualaCartera/IN/";
            var directoryLocal = @"D:\Proyectos Exertus\Quala\SFTP\";
            var configuracion = new Configuracion();
            var a = new LogicAccess();

            //Se obtiene la información de los sincronizadores que toca cargar para procesar los archivos.
            var datos = new Dictionary<string, object>();
            datos["EsRobot"] = true;
            var dt = a.ExecuteQuery("Sincronizador_Sel", datos).Tables[0];
            var sincronizadores = a.DataTableToMap(dt);

            using (var sftp = new SftpClient(servidor, user, pass))
            {
                sftp.Connect();

                foreach (var sincronizador in sincronizadores)
                {
                    var nombreArchivo = a.GetString(sincronizador, "NombreArchivo");
                    var rutaArchivoSftp = directoryFtp + nombreArchivo;
                    var rutaArchivosLocal = directoryLocal + nombreArchivo;

                    if (sftp.Exists(rutaArchivoSftp))
                    {
                        using (Stream fileStream = File.OpenWrite(rutaArchivosLocal))
                        {
                            sftp.DownloadFile(rutaArchivoSftp, fileStream);
                        }
                    }
                    else
                    {
                        var descripcion = "Error: El archivo no existe";
                        GuardarLogError(descripcion, sincronizador);
                        sincronizador["Resultado"] = descripcion;
                        a.ExecuteNonQuery("Sincronizador_U", sincronizador);
                    }
                }

                sftp.Disconnect();
            }

            //Se obtienen los archivos previamente bajados desde el ftp
            var files = Directory.GetFiles(directoryLocal);
            foreach (var file in files)
            {
                try
                {
                    var nombrearchivo = Path.GetFileName(file);

                    //Si el archivo coincide con alguno de los del sincronizador se procesa
                    var sincronizador = sincronizadores.FirstOrDefault(x => x["NombreArchivo"].ToString() == nombrearchivo);

                    if (sincronizador != null)
                    {
                        var sincronizadorId = a.GetInt(sincronizador, "SincronizadorId");

                        sincronizador["SincronizacionId"] = 0;
                        sincronizador["NamePcMod"] = NamePcMod;

                        if (configuracion.IdCampos.ContainsKey(sincronizadorId))
                        {
                            var tipo = a.GetString(sincronizador, "Tipo").Trim();
                            var json = configuracion.IdCampos[sincronizadorId];
                            var campos = JsonConvert.DeserializeObject<List<Dictionary<string, object>>>(json);
                            var allLines = File.ReadAllLines(file);

                            if (tipo == "|" || tipo == ",")
                            {
                                var tipoChar = Convert.ToChar(tipo);
                                var startLine = tipo == "|" ? 1 : 2;
                                ProcesarCsvOrTxt(allLines, tipoChar, sincronizador, campos, startLine);
                                File.Delete(file);
                            }
                        }
                        else
                        {
                            var descripcion = "El sincronizador no tiene un archivo de configuración";
                            GuardarLogError(descripcion, sincronizador);
                        }
                    }
                }
                catch (Exception ex)
                {
                    GuardarLogError(ex.Message, null, ex.StackTrace);
                }
            }
            return true;
        }
    }
}