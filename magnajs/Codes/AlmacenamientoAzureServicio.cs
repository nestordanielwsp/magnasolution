using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Text;
using Microsoft.Azure.Storage;
using Microsoft.Azure.Storage.Blob;

namespace Infraestructura.Archivos
{
    public class AlmacenamientoAzureServicio
    {      
        public void Guardar(Stream archivoStream, string destino)
        {
            var cloudBlockBlob =  this.ObtenerBlockBlob(destino);
            cloudBlockBlob.UploadFromStream(archivoStream);
        }

        public void Mover(string origen, string destino)
        {
            var blobOrigen =  this.ObtenerBlockBlob(origen);
            var blobDestino =  this.ObtenerBlockBlob(destino);

            try
            {
                blobDestino.StartCopy(blobOrigen);
            }
            catch (Exception e)
            {
                throw new Exception("No existe el origen " +  origen, e);
            }

            blobOrigen.DeleteIfExists();
        }


        public void Eliminar(string rutaArchivo)
        {
            var blockBlob =  this.ObtenerBlockBlob(rutaArchivo);
            blockBlob.DeleteIfExists();
        }

        public byte[] ObtenerArchivo(string ruta)
        {
            var stream = this.ObtenerStream(ruta);
            return ReadFully(stream);
        }

        public Stream ObtenerStream(string ruta)
        {
            var blockBlob =  this.ObtenerBlockBlob(ruta);
            var memStream = new MemoryStream();
            blockBlob.DownloadToStream(memStream);
            memStream.Position = 0;
            return memStream;
        }

        private CloudBlockBlob ObtenerBlockBlob(string rutaCompleta)
        {
            var componentes = rutaCompleta.Split('/').ToList();
            var contenedor = componentes.FirstOrDefault();
            var archivo = string.Join("/", componentes.Skip(1));
            var connectionString = ConfigurationManager.AppSettings["ConnectionString"];
            if (CloudStorageAccount.TryParse(connectionString, out var storageAccount))
            {
                var cloudBlobClient = storageAccount.CreateCloudBlobClient();
                var cloudBlobContainer = cloudBlobClient.GetContainerReference(contenedor.ToLower());
                cloudBlobContainer.CreateIfNotExists();
                return cloudBlobContainer.GetBlockBlobReference(archivo);
            }
            throw new Exception("No existe el acceso a los contenedores de azure");
        }

        private static byte[] ReadFully(Stream input)
        {
            var buffer = new byte[16*1024];
            using (var ms = new MemoryStream())
            {
                int read;
                while ((read = input.Read(buffer, 0, buffer.Length)) > 0)
                {
                    ms.Write(buffer, 0, read);
                }
                return ms.ToArray();
            }
        }
    }
}
