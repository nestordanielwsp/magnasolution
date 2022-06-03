using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Web;

namespace magnajs.Codes
{
    public class LogicAccess
    {
        private readonly string _conexionDb;

        public LogicAccess()
        {
            _conexionDb = ConfigurationManager.ConnectionStrings["ConexionDB"].ToString();
        }

        public DataSet ExecuteQuery(string p_procedure, Dictionary<string, object> p_datos)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(_conexionDb))
            {
                string sNomParametro = string.Empty;
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(p_procedure, conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    SqlCommandBuilder.DeriveParameters(cmd);
                    foreach (SqlParameter param in cmd.Parameters)
                    {
                        if (param.Direction == ParameterDirection.Input || param.Direction == ParameterDirection.InputOutput)
                        {
                            sNomParametro = param.ParameterName.Substring(3, param.ParameterName.Length - 3);

                            foreach (KeyValuePair<string, object> entry in p_datos)
                            {
                                if (entry.Key.ToLower() == sNomParametro.ToLower())
                                {
                                    param.Value = entry.Value;
                                    break;
                                }
                            }

                            //Si el parametro es de tipo numero y se recibio un '' desde codigo se envia null a la base de datos.
                            if ((ToString(param.Value) == "") && (param.SqlDbType == SqlDbType.Int || param.SqlDbType == SqlDbType.Float || param.SqlDbType == SqlDbType.Decimal))
                            {
                                param.Value = null;
                            }
                        }
                    }

                    SqlDataAdapter adp = new SqlDataAdapter(cmd);
                    adp.Fill(ds);


                    return ds;
                }
            }
        }

        public void ExecuteNonQuery(string nombreSP, Dictionary<string, object> parameters)
        {
            using (SqlConnection conn = new SqlConnection(_conexionDb))
            {
                conn.Open();
                using (var cmd = new SqlCommand(nombreSP, conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandTimeout = 600;
                    SqlCommandBuilder.DeriveParameters(cmd);
                    string sNomParametro;
                    foreach (SqlParameter param in cmd.Parameters)
                    {
                        if (param.Direction == ParameterDirection.Input || param.Direction == ParameterDirection.InputOutput)
                        {
                            sNomParametro = param.ParameterName.Substring(3, param.ParameterName.Length - 3);

                            foreach (KeyValuePair<string, object> entry in parameters)
                            {
                                if (entry.Key.ToLower() == sNomParametro.ToLower())
                                {
                                    if (sNomParametro.ToLower() != "idioma")
                                    {
                                        param.Value = entry.Value;
                                        break;
                                    }
                                    else
                                        param.Value = null;
                                }
                            }

                            //Si el parametro es de tipo numero y se recibio un '' desde codigo se envia null a la base de datos.
                            if ((ToString(param.Value) == "") && (param.SqlDbType == SqlDbType.Int || param.SqlDbType == SqlDbType.Float || param.SqlDbType == SqlDbType.Decimal || param.SqlDbType == SqlDbType.BigInt))
                            {
                                param.Value = null;
                            }
                        }
                    }

                    cmd.ExecuteNonQuery();

                    var key = string.Empty;

                    foreach (SqlParameter param in cmd.Parameters)
                    {
                        if (param.Direction == ParameterDirection.Output || param.Direction == ParameterDirection.InputOutput)
                        {
                            sNomParametro = param.ParameterName.Substring(3, param.ParameterName.Length - 3);

                            foreach (KeyValuePair<string, object> entry in parameters)
                            {
                                if (entry.Key.ToLower() == sNomParametro.ToLower())
                                {
                                    key = entry.Key;
                                    break;
                                }
                            }

                            parameters[key] = param.Value.ToString();
                        }
                    }
                }
            }
        }

        public string ToString(object value)
        {
            if (value is DBNull)
                return string.Empty;

            return Convert.ToString(value);
        }

        public List<Dictionary<string, object>> DataTableToMap(DataTable p_dt)
        {
            return
                (from DataRow dr in p_dt.Rows
                 select p_dt.Columns.Cast<DataColumn>().ToDictionary(col => col.ColumnName, col => dr[col])).ToList();
        }

        public string GetString(Dictionary<string, object> data, string property, string value = "")
        {
            var result = data.ContainsKey(property) ? data[property].ToString() : value != "" ? value : "";

            if (value != "")
            {
                data[property] = value;
            }

            return result;
        }

        public string GetString(object value)
        {
            var result = "";

            if (value != null)
            {
                result = value.ToString();
            }

            return result;
        }

        public int GetInt(Dictionary<string, object> data, string property)
        {
            int result;
            var valueToConvert = data.ContainsKey(property) ? data[property].ToString() : "";

            int.TryParse(valueToConvert, out result);

            return result;
        }

        public int GetInt(Dictionary<string, object> data, string property, ref string error, string value = "")
        {
            int result;
            var valueToConvert = data.ContainsKey(property) ? data[property].ToString() : value != "" ? value : "";

            if (!int.TryParse(valueToConvert, out result))
            {
                error += string.Format("El campo {0} no es un valor numérico; ", property);
            };

            if (value != "")
            {
                data[property] = value;
            }

            return result;
        }

        public int GetInt(object value, ref string error)
        {
            int result;

            if (!int.TryParse(value.ToString(), out result))
            {
                error += string.Format("El campo {0} no es un valor numérico; ", value);
            }

            return result;
        }

        public decimal GetDecimal(Dictionary<string, object> data, string property, ref string error, string value = "")
        {
            decimal result;
            var valueToConvert = data.ContainsKey(property) ? data[property].ToString() : value != "" ? value : "";

            if (!decimal.TryParse(valueToConvert, out result))
            {
                error += string.Format("El campo {0} no es un valor numérico; ", property);
            }

            if (value != "")
            {
                data[property] = value;
            }

            return result;
        }

        public decimal GetDecimal(object value, ref string error)
        {
            decimal result;

            if (!decimal.TryParse(value.ToString(), out result))
            {
                error += string.Format("El campo {0} no es un valor numérico; ", value);
            }

            return result;
        }

        public bool GetBool(Dictionary<string, object> data, string property, ref string error, string value = "")
        {
            bool result;
            var valueToConvert = data.ContainsKey(property) ? data[property].ToString() : value != "" ? value : "";

            if (!bool.TryParse(valueToConvert, out result))
            {
                error += string.Format("El campo {0} no es un valor boleano; ", property);
            }

            if (value != "")
            {
                data[property] = value;
            }

            return result;
        }

        public bool GetBool(object value, ref string error)
        {
            bool result;

            if (!bool.TryParse(value.ToString(), out result))
            {
                error += string.Format("El campo {0} no es un valor boleano; ", value);
            }

            return result;
        }

        public bool GetBoolFromString(Dictionary<string, object> data, string property, ref string error, string trueValue, string value = "")
        {
            var valueToConvert = data.ContainsKey(property) ? data[property].ToString() : value != "" ? value : "";

            var result = valueToConvert.ToLower().Trim() == trueValue.ToLower().Trim();

            if (value != "")
            {
                data[property] = value;
            }

            return result;
        }

        public bool GetBoolFromString(object value, string trueValue, ref string error)
        {
            var result = value.ToString().ToLower().Trim() == trueValue.ToLower().Trim();

            return result;
        }

        public DateTime GetDate(Dictionary<string, object> data, string property, ref string error, string format = "", string value = "")
        {
            DateTime result;

            var valueToConvert = data.ContainsKey(property) ? data[property].ToString() : value != "" ? value : "";

            if (format == "")
            {
                if (!DateTime.TryParse(valueToConvert, out result))
                {
                    error += string.Format("El campo {0} no es una fecha; ", property);
                }
            }
            else
            {
                if (!DateTime.TryParseExact(valueToConvert, format, CultureInfo.InvariantCulture, DateTimeStyles.None,
                    out result))
                {
                    error += string.Format("El campo {0} no tiene el formato correcto: {1}; ", property, format);
                }
            }

            if (value != "")
            {
                data[property] = value;
            }

            return result;
        }

        public DateTime GetDate(object value, ref string error, string format = "")
        {
            DateTime result;
            if (format == "")
            {
                if (!DateTime.TryParse(value.ToString(), out result))
                {
                    error += string.Format("El campo {0} no es una fecha; ", value);
                }
            }
            else
            {
                if (!DateTime.TryParseExact(value.ToString(), format, CultureInfo.InvariantCulture, DateTimeStyles.None,
                    out result))
                {
                    error += string.Format("El campo {0} no tiene el formato correcto: {1}; ", value, format);
                }
            }

            return result;
        }
    }
}