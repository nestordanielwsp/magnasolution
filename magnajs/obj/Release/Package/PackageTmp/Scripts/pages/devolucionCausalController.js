

(function () {
    app.controller('devolucionCausalController', canalController);

    canalController.$inject = ['$scope', '$http', 'enums', 'util', '$timeout'];

    function canalController($scope, $http, enums, util, $timeout) {
        var service = $Ex;
        service.Http = $http;
        var vm = this;
        vm.viewDetail = false;
        vm.titulo = Ex.GetResourceValue("Titulo") || '';
        vm.isValid = true;
        $scope.modalForm = {};
        $scope.causal = [];

        $scope.fileOptionsDetalle = {
            url: "../Codes/UploadFile.ashx",
            autoUpload: true,
            validExtensions: Ex.GetResourceValue('validExtensions'),
            maxFilesize: Ex.GetResourceValue('maxFileSize'),
            puedeEliminar: true
        };

        $scope.fileParameters = { Folder: Ex.GetResourceValue("folderArchivos") };
  

        var consultar = function () {
            try {
                vm.devolucionCausal = [];
                vm.devolucionCausal_ = [];
               // Ex.load(true);
                var datos = vm.filtro || {};
                service.Execute('Consultar', datos, function (response) {
                    if (response.d) {
                        vm.devolucionCausal = response.d.DevolucionCausal;
                        vm.devolucionCausal_ = angular.copy(vm.devolucionCausal);
                    }
                    Ex.load(false);
                })
            }
            catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }
        }

        vm.consultar = function () {
            consultar();
        };

        var causalSeleccionada = {};
        $scope.openModalNotas = function (causalDevolucion) {

            try {
                causalSeleccionada = causalDevolucion;

                $scope.causal = {
                    DevolucionCausalId: causalDevolucion.DevolucionCausalId,
                    NombreTipoDevolucion: causalDevolucion.NombreTipoDevolucion,
                    NombreCausal: causalDevolucion.NombreCausal,
                    Descripcion: causalDevolucion.Descripcion
                };


                $scope.tituloModal = "Devolución de Producto Terminado de Clientes";
                $scope.tituloDetalle = "Detalle";
                $scope.tituloEvidencias = "Evidencias";
                $scope.tituloDescripcion = "Descripción";

                vm.devolucionCausalEvidencia = [];
                vm.devolucionCausalEvidencia_ = [];
                //Ex.load(true);
                var datos = { DevolucionCausalId: causalDevolucion.DevolucionCausalId };
                service.Execute('ConsultarCausal', datos, function (response) {
                    if (response.d) {
                        vm.devolucionCausalEvidencia = response.d.DevolucionCausalEvidencia;
                        vm.devolucionCausalEvidencia_ = angular.copy(vm.devolucionCausalEvidencia);
                    }
                    //Ex.load(false);
                })
            }
            catch (ex) {
                Ex.mensajes(ex.message, 4);
               // Ex.load(false);
            }

            Ex.load(false);
            $scope.modalNotas.open();
        };

        $scope.setParametrosArchivo = function (response, item) {
            item.UID = response.UID;
            item.RutaArchivo = response.RutaArchivo;
            item.EsArchivoNuevo = response.EsNuevo;
        };

        $scope.abrirDocumento = function (item) {
            $Ex.Execute("AbrirDocumento", item, function (response, isInvalid) {
                if (response.d) {
                    window.location = "DownLoadPage.aspx?d=" + getRandom();
                }
                else {
                    Ex.mensajes(Ex.GetResourceValue("msgArchivoNoEncontrado"));
                }
            });
        };

        //var devolucioncausalSeleccionada = [];        
        $scope.guardar = function (forma) {
            $scope.submitted = true;

            
           // Ex.load(true);
            $Ex.Execute("Guardar", vm.devolucionCausalEvidencia, function (response, isInvalid) {
                Ex.load(false);
                if (response.d == 0) {
                    Ex.mensajes("Se deben cargar todos los archivos marcados como **Requerido**");
                } else {
                    
                    $scope.modalNotas.close();
                }
            });
         
          
        };




        var init = function () {
            vm.consultar();
        }


        init();
    }
})();