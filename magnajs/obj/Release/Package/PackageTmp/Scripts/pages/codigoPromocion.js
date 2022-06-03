(function () {
    app.controller('codigoPromocional', ['$scope', '$http', 'enums', 'util',
        function ($scope, $http, enums, util) {
            $Ex.Http = $http;

            $scope.filtro = {};
            $scope.forma = {};
            $scope.translateTextMultiSelect = $Ex.GetTranslateMultiSelectSettings();
            $scope.Meses = util.getMonthArray();
            $scope.Year = util.getYearArray(4);
            $scope.esNuevo = false;

            $scope.pantallas = {
                principal: 1,
                agregar: 2,
            };
            $scope.pantallaId = $scope.pantallas.principal;

            var fechaActual = new Date();
            $scope.filtro.mes = fechaActual.getMonth() + 1;
            $scope.filtro.year = fechaActual.getFullYear();

            $scope.Obtenercodigos = function () {
                $Ex.Execute("ObtenerPromociones", $scope.filtro, function (response) {
                    $scope.promociones = response.d;
                    if ($scope.filtro.Activity)
                    {
                        var promociones = [];
                        angular.forEach($scope.promociones, function (promocion) {
                            var activity = promocion.Activity.toLowerCase();
                            var existe = activity.includes($scope.filtro.Activity.toLowerCase());
                            if (existe) {
                                promociones.push(promocion);
                            }
                        });
                        $scope.promociones = promociones;
                        //var promociones = _.where($scope.promociones, { Activity: $scope.filtro.Activity })
                        //$scope.promociones = promociones;
                    }
                    $scope.tablaPromociones = true;
                    $scope.ObtenerProductos();
                });
            };

            $scope.agregar = function () {
                var fechaActual2 = new Date();
                $scope.promociones.push({ Active: true, MarcaId: "BON ICE", esNuevo: true });
            }

            $scope.guardar = function () {
                $scope.submitted = true;
                $scope.promociones.Lista = _.where($scope.promociones, { esNuevo: true });
                $Ex.Execute("Guardar", $scope.promociones, function (response,isInvalid) {

                    if (!isInvalid) {
                        $scope.submitted = false;
                        $scope.Obtenercodigos();    
                       }

                }, $scope.forma);
            }
            
            $scope.ObtenerProductos = function () {
                $Ex.Execute("ObtenerProductos", $scope.filtro, function (response) {
                    $scope.productos = response.d;
                });

            }

            $scope.eliminar = function (item, index) {
                $scope.promociones.splice(index, 1);
            };

            $scope.Obtenercodigos();


        }]);
})();